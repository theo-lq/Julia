using MLDataUtils



function stratified_train_test_split(df, y_column_number, target, train_size=0.75)
    """Split a dataframe df into two feature array and two target array, it is stratified.

    Usage::
        >>> X_train, X_test, y_train, y_test = stratified_train_test_split(df, 2, "win")

    :param df: A DataFrame
    :param y_column_number: An integer
    :param target: Abstract, can be integer or string
    :param train_size: A float, proportion
    :rtype: 4 Array
    """


    function remove!(vector, item)
        """Remove in place item from vector"""
        deleteat!(vector, findall(x -> x == item, vector))
    end


    function X_y_split(df)
        """Split a dataframe df into the feature array X and the target array y (perform binarisation on it)"""

        X = df[:, X_columns_number]
        y = df[:, y_column_number]
        y = [value == target ? 1 : 0 for value in y]
        return X, y
    end



    X_columns_number = [index for index in 1:size(df, 2)]
    remove!(X_columns_number, y_column_number)

    X, y = X_y_split(df)

    (X_train, y_train), (X_test, y_test) = stratifiedobs((X, y), p=train_size)

    return Array(X_train), Array(X_test), Array(y_train), Array(y_test)
end
