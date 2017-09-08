Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt0-f194.google.com ([209.85.216.194]:37439 "EHLO
        mail-qt0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751048AbdIHO7e (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 8 Sep 2017 10:59:34 -0400
MIME-Version: 1.0
In-Reply-To: <20170908143833.yisoj3t2yp5httle@mwanda>
References: <1504879698-5855-1-git-send-email-srishtishar@gmail.com> <20170908143833.yisoj3t2yp5httle@mwanda>
From: Srishti Sharma <srishtishar@gmail.com>
Date: Fri, 8 Sep 2017 20:29:33 +0530
Message-ID: <CAB3L5owMjYyFcLQP7p_+R2DzZz3KpUhCxaVrB0qJeJh08UzM1w@mail.gmail.com>
Subject: Re: [PATCH] Staging: media: omap4iss: Use WARN_ON() instead of BUG_ON().
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Greg KH <gregkh@linuxfoundation.org>, devel@driverdev.osuosl.org,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>,
        outreachy-kernel@googlegroups.com,
        laurent.pinchart@ideasonboard.com, mchehab@kernel.org,
        linux-media@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Sep 8, 2017 at 8:08 PM, Dan Carpenter <dan.carpenter@oracle.com> wrote:
> On Fri, Sep 08, 2017 at 07:38:18PM +0530, Srishti Sharma wrote:
>> Use WARN_ON() instead of BUG_ON() to avoid crashing the kernel.
>>
>> Signed-off-by: Srishti Sharma <srishtishar@gmail.com>
>> ---
>>  drivers/staging/media/omap4iss/iss.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/staging/media/omap4iss/iss.c b/drivers/staging/media/omap4iss/iss.c
>> index c26c99fd..b1036ba 100644
>> --- a/drivers/staging/media/omap4iss/iss.c
>> +++ b/drivers/staging/media/omap4iss/iss.c
>> @@ -893,7 +893,7 @@ void omap4iss_put(struct iss_device *iss)
>>               return;
>>
>>       mutex_lock(&iss->iss_mutex);
>> -     BUG_ON(iss->ref_count == 0);
>> +     WARN_ON(iss->ref_count == 0);
>
> ref_counting bugs often have a security aspect.  BUG_ON() is probably
> safer here.  Better to crash than to lose all your bitcoin.

Okay, Thanks for this.

Regards,
Srishti

>
> regards,
> dan carpenter
>
