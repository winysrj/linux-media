Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f68.google.com ([74.125.83.68]:48933 "EHLO
        mail-pg0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751029AbdJYPWg (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 25 Oct 2017 11:22:36 -0400
Received: by mail-pg0-f68.google.com with SMTP id v78so236728pgb.5
        for <linux-media@vger.kernel.org>; Wed, 25 Oct 2017 08:22:35 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20171025102307.qjvqtorri4lw3weo@valkosipuli.retiisi.org.uk>
References: <1508779826-12499-1-git-send-email-akinobu.mita@gmail.com> <20171025102307.qjvqtorri4lw3weo@valkosipuli.retiisi.org.uk>
From: Akinobu Mita <akinobu.mita@gmail.com>
Date: Thu, 26 Oct 2017 00:22:14 +0900
Message-ID: <CAC5umyhsaWru-Z-LO7jZDt0z6H8LNh+VgC8PCO4y9GGEVA8YRQ@mail.gmail.com>
Subject: Re: [PATCH] media: ov9650: remove unnecessary terminated entry in
 menu items array
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org,
        Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

2017-10-25 19:23 GMT+09:00 Sakari Ailus <sakari.ailus@iki.fi>:
> On Tue, Oct 24, 2017 at 02:30:26AM +0900, Akinobu Mita wrote:
>> The test_pattern_menu[] array has two valid items and a null terminated
>> item.  So the control's maximum value which is passed to
>> v4l2_ctrl_new_std_menu_items() should be one.  However,
>> 'ARRAY_SIZE(test_pattern_menu) - 1' is actually passed and it's not
>> correct.
>>
>> Fix it by removing unnecessary terminated entry and let the correct
>> control's maximum value be passed to v4l2_ctrl_new_std_menu_items().
>>
>> Cc: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
>> Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>
>> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
>> ---
>>  drivers/media/i2c/ov9650.c | 1 -
>>  1 file changed, 1 deletion(-)
>>
>> diff --git a/drivers/media/i2c/ov9650.c b/drivers/media/i2c/ov9650.c
>> index 6ffb460..69433e1 100644
>> --- a/drivers/media/i2c/ov9650.c
>> +++ b/drivers/media/i2c/ov9650.c
>> @@ -985,7 +985,6 @@ static const struct v4l2_ctrl_ops ov965x_ctrl_ops = {
>>  static const char * const test_pattern_menu[] = {
>>       "Disabled",
>>       "Color bars",
>> -     NULL
>
> The number of items in the menu changes; I fixed that while applying the
> patch:
>
> diff --git a/drivers/media/i2c/ov9650.c b/drivers/media/i2c/ov9650.c
> index 69433e1e2533..4f59da1f967b 100644
> --- a/drivers/media/i2c/ov9650.c
> +++ b/drivers/media/i2c/ov9650.c
> @@ -1039,7 +1039,7 @@ static int ov965x_initialize_controls(struct ov965x *ov965x)
>                                        V4L2_CID_POWER_LINE_FREQUENCY_50HZ);
>
>         v4l2_ctrl_new_std_menu_items(hdl, ops, V4L2_CID_TEST_PATTERN,
> -                                    ARRAY_SIZE(test_pattern_menu) - 1, 0, 0,
> +                                    ARRAY_SIZE(test_pattern_menu), 0, 0,
>                                      test_pattern_menu);
>         if (hdl->error) {
>                 ret = hdl->error;
>
>
> Let me know if you see issues with this.

This change actually causes an issue.

This problem was found when I got the list of available controls for
ov9650 subdev.

$ yavta -l /dev/v4l-subdev0
<...>
--- Image Processing Controls (class 0x009f0001) ---
control 0x009f0903 `Test Pattern' min 0 max 2 step 1 default 0 current 0.
  0: Disabled (*)
  1: Color bars

Strangely, the max control value is '2'.  So I tried to set the control to '2'
for the fun and got a null pointer dereference.

$ yavta -w '0x009f0903 2' --no-query /dev/v4l-subdev0
Device /dev/v4l-subdev0 opened.
Segmentation fault

Then, I found that the root cause is unnecessary terminated entry.
So 'ARRAY_SIZE(test_pattern_menu) - 1' (=1) should be passed to
v4l2_ctrl_new_std_menu_items().
