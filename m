Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f196.google.com ([209.85.161.196]:56020 "EHLO
        mail-yw0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750703AbdKBEA1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 2 Nov 2017 00:00:27 -0400
Received: by mail-yw0-f196.google.com with SMTP id t11so3629094ywg.12
        for <linux-media@vger.kernel.org>; Wed, 01 Nov 2017 21:00:27 -0700 (PDT)
Received: from mail-yw0-f179.google.com (mail-yw0-f179.google.com. [209.85.161.179])
        by smtp.gmail.com with ESMTPSA id n134sm1059519ywn.27.2017.11.01.21.00.25
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 01 Nov 2017 21:00:25 -0700 (PDT)
Received: by mail-yw0-f179.google.com with SMTP id q126so3634620ywq.10
        for <linux-media@vger.kernel.org>; Wed, 01 Nov 2017 21:00:25 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170830212819.6tepof4jzdiqtezd@valkosipuli.retiisi.org.uk>
References: <1504115332-26651-1-git-send-email-rajmohan.mani@intel.com> <20170830212819.6tepof4jzdiqtezd@valkosipuli.retiisi.org.uk>
From: Tomasz Figa <tfiga@chromium.org>
Date: Thu, 2 Nov 2017 13:00:03 +0900
Message-ID: <CAAFQd5BWExq1mqAhg6z-=rRvwLh_HMdVdqPx2bGsA4cjjuyDPg@mail.gmail.com>
Subject: Re: [PATCH] [media] dw9714: Set the v4l2 focus ctrl step as 1
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Rajmohan Mani <rajmohan.mani@intel.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        "Toivonen, Tuukka" <tuukka.toivonen@intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On Thu, Aug 31, 2017 at 6:28 AM, Sakari Ailus <sakari.ailus@iki.fi> wrote:
> Hi Rajmohan,
>
> On Wed, Aug 30, 2017 at 10:48:52AM -0700, Rajmohan Mani wrote:
>> Current v4l2 focus ctrl step value of 16, limits
>> the minimum granularity of focus positions to 16.
>> Setting this value as 1, enables more accurate
>> focus positions.
>
> Thanks for the patch.
>
> The recommended limit for line length is 75, not 50 (or 25 or whatever) as
> it might be in certain Gerrit installations. :-) Please make good use of
> lines in the future, I've rewrapped the text this time. Thanks.

Has this patch been applied to your tree? I can't find it on
linux-next or https://git.linuxtv.org/sailus/media_tree.git/ . Just
want to make sure it doesn't get lost in action.

Best regards,
Tomasz

>
>>
>> Signed-off-by: Rajmohan Mani <rajmohan.mani@intel.com>
>> ---
>>  drivers/media/i2c/dw9714.c | 7 ++++++-
>>  1 file changed, 6 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/media/i2c/dw9714.c b/drivers/media/i2c/dw9714.c
>> index 6a607d7..f9212a8 100644
>> --- a/drivers/media/i2c/dw9714.c
>> +++ b/drivers/media/i2c/dw9714.c
>> @@ -22,6 +22,11 @@
>>  #define DW9714_NAME          "dw9714"
>>  #define DW9714_MAX_FOCUS_POS 1023
>>  /*
>> + * This sets the minimum granularity for the focus positions.
>> + * A value of 1 gives maximum accuracy for a desired focus position
>> + */
>> +#define DW9714_FOCUS_STEPS   1
>> +/*
>>   * This acts as the minimum granularity of lens movement.
>>   * Keep this value power of 2, so the control steps can be
>>   * uniformly adjusted for gradual lens movement, with desired
>> @@ -138,7 +143,7 @@ static int dw9714_init_controls(struct dw9714_device *dev_vcm)
>>       v4l2_ctrl_handler_init(hdl, 1);
>>
>>       v4l2_ctrl_new_std(hdl, ops, V4L2_CID_FOCUS_ABSOLUTE,
>> -                       0, DW9714_MAX_FOCUS_POS, DW9714_CTRL_STEPS, 0);
>> +                       0, DW9714_MAX_FOCUS_POS, DW9714_FOCUS_STEPS, 0);
>>
>>       if (hdl->error)
>>               dev_err(&client->dev, "%s fail error: 0x%x\n",
>
> --
> Regards,
>
> Sakari Ailus
> e-mail: sakari.ailus@iki.fi
