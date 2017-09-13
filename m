Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f65.google.com ([209.85.215.65]:38520 "EHLO
        mail-lf0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751120AbdIMIjc (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 13 Sep 2017 04:39:32 -0400
MIME-Version: 1.0
In-Reply-To: <20170913082211.2btqdehfq7co4mtx@mwanda>
References: <1505289879-26163-1-git-send-email-allen.lkml@gmail.com> <20170913082211.2btqdehfq7co4mtx@mwanda>
From: Allen <allen.lkml@gmail.com>
Date: Wed, 13 Sep 2017 14:09:30 +0530
Message-ID: <CAOMdWSKVi_3tjxZ6=uoakyLthnYX4ng6o4PRMoikN4Y8qr_UDQ@mail.gmail.com>
Subject: Re: [PATCH] drivers:staging/media:Use ARRAY_SIZE() for the size
 calculation of the array
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        mchehab@kernel.org, linux-media@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

>>
>> -#define array_length(array) (sizeof(array)/sizeof(array[0]))
>> +#define array_length(array) (ARRAY_SIZE(array))
>
> Just get rid of this array_length macro and use ARRAY_SIZE() directly.
>

 Sure.

       - Allen
