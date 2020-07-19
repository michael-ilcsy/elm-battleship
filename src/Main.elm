module Main exposing (..)

import Array exposing (Array)
import Browser
import Html exposing (Html, div, table, tbody, td, tr)



---- MODEL ----


type alias Model =
    { gameBoard : GameBoard }


type alias GameBoard =
    Array (Array GameBoardState)


type GameBoardState
    = Unknown


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
                                (\square ->
                                    td [] []
                                )
                                row
                )
                gameBoard
                |> Array.toList
            )
        ]



---- PROGRAM ----


main : Program () Model Msg
main =
    Browser.element
        { view = view
        , init = \_ -> init
        , update = update
        , subscriptions = always Sub.none
        }
