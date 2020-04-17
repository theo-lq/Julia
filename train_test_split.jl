using DataFrames, StatsBase, Random



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


    function split(X)
        """Split a dataframe X into training and test set."""

        n = nrow(X)
        train_number = round(Int, n  * train_size)
        index = sample(1:n, train_number, replace=false)
        train = X[index, :]
        test = X[Not(index), :]
        return train, test
    end


    function X_y_split(df)
        """Split a dataframe df into the feature array X and the target array y (perform binarisation on it)"""

        X = df[:, X_columns_number]
        y = df[:, y_column_number]
        y = [value == target ? 1 : 0 for value in y]
        return X, y
    end


    function concatenate_shuffle_split(X1, X2)
        """Concatenate the two dataframes X1 and X2, shuffle the rows and then split into X and y array"""
        
        answer = append!(X1, X2)
        answer = answer[shuffle(1:nrow(answer)), :]
        X, y = X_y_split(answer)
        return X, y
    end



    X_columns_number = [index for index in 1:size(df, 2)]
    remove!(X_columns_number, y_column_number)

    df_target = df[(df[:, y_column_number] .== target), :]
    df_not_target = df[(df[:, y_column_number] .!= target), :]

    train_target, test_target = split(df_target)
    train_not_target, test_not_target = split(df_not_target)

    X_train, y_train = concatenate_shuffle_split(train_target, train_not_target)
    X_test, y_test = concatenate_shuffle_split(test_target, test_not_target)

    return Array(X_train), Array(X_test), Array(y_train), Array(y_test)
end
