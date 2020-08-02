module Main exposing (..)

import Array exposing (Array)
import Browser
import Html exposing (Html, div, i, table, tbody, td, text, tr, span)
import Html.Attributes exposing (class)



---- MODEL ----


type alias Model =
    { gameBoard : GameBoard }


type alias GameBoard =
    Array (Array GameBoardState)


type GameBoardState
    = Unknown
    | Sunk ShipType SunkType
    | Hit ShipType
    | Miss


type SunkType
    = Body
    | Tip Direction


type alias Coordinate =
    ( Int, Int )


type Direction
    = Right
    | Left
    | Up
    | Down


directionToString : Direction -> String
directionToString direction =
    case direction of
        Right ->
            "right"

        Left ->
            "left"

        Up ->
            "up"

        Down ->
            "down"


{-| 船の先端マスを表す型
-}
type alias ShipTip =
    ( Coordinate, Direction )


type BattleShip
    = Battleship Coordinate Coordinate Coordinate Coordinate ShipTip


type Cruiser
    = Cruiser Coordinate Coordinate Coordinate ShipTip


type Destroyer
    = Destroyer Coordinate Coordinate ShipTip


type Submarine
    = Submarine Coordinate ShipTip


type ShipType
    = B
    | C
    | D
    | S


shipTypeToString : ShipType -> String
shipTypeToString shipType =
    case shipType of
        B ->
            "B"

        C ->
            "C"

        D ->
            "D"

        S ->
            "S"


type ShipData
    = ShipData BattleShip Cruiser Cruiser Destroyer Destroyer Destroyer Destroyer Submarine Submarine


init : ( Model, Cmd Msg )
init =
    ( { gameBoard = initGameBoard }, Cmd.none )


gameBoardSize =
    10


initGameBoard : GameBoard
initGameBoard =
    Array.repeat gameBoardSize <| Array.repeat gameBoardSize Unknown



---- UPDATE ----


type Msg
    = NoOp


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    ( model, Cmd.none )



---- VIEW ----


view : Model -> Html Msg
view model =
    div []
        [ viewGameBoard model.gameBoard
        ]


viewGameBoard : GameBoard -> Html msg
viewGameBoard gameBoard =
    table []
        [ tbody []
            (Array.map
                (\row ->
                    tr [] <|
                        Array.toList <|
                            Array.map
                                viewSquare
                                row
                )
                gameBoard
                |> Array.toList
            )
        ]


viewSquare : GameBoardState -> Html msg
viewSquare state =
    case state of
        Sunk shipType Body ->
            td [ class "sunk" ] [ text <| shipTypeToString shipType ]

        Sunk shipType (Tip direction) ->
            td [ class <| "sunk " ++ directionToString direction ]
                [ 
                    div [] [], -- 図形表示用DOM
                    span [] [text <| shipTypeToString shipType]
                ]

        Miss ->
            td [] [ i [ class "fas fa-times" ] [] ]

        Hit shipType ->
            td [ class "hit" ] [ text <| shipTypeToString shipType ]

        _ ->
            td [] []



---- PROGRAM ----


main : Program () Model Msg
main =
    Browser.element
        { view = view
        , init = \_ -> init
        , update = update
        , subscriptions = always Sub.none
        }
