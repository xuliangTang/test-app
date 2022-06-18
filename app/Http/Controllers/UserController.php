<?php

namespace App\Http\Controllers;

use Illuminate\Http\JsonResponse;

class UserController extends Controller
{
    public function show(int $userId): JsonResponse
    {
        return response()->json([
            'code' => 200,
            'msg' => 'success',
            'data' => [
                'id' => $userId,
                'name' => 'lain'
            ]
        ]);
    }
}
