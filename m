Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f196.google.com ([209.85.220.196]:33231 "EHLO
        mail-qk0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752208AbdIHQCA (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 8 Sep 2017 12:02:00 -0400
MIME-Version: 1.0
In-Reply-To: <CAOw6vbLPfzZ5WzY0Qd9sXp40SGTZAxqVB7x+cTkNuHX79uazzw@mail.gmail.com>
References: <1504883469-8127-1-git-send-email-srishtishar@gmail.com> <CAOw6vbLPfzZ5WzY0Qd9sXp40SGTZAxqVB7x+cTkNuHX79uazzw@mail.gmail.com>
From: Srishti Sharma <srishtishar@gmail.com>
Date: Fri, 8 Sep 2017 21:31:59 +0530
Message-ID: <CAB3L5oywbZLHop9i+D7GsXg0=uete4Z2Y+PmzN_kdB3-6W6u+g@mail.gmail.com>
Subject: Re: [Outreachy kernel] [PATCH] Staging: media: imx: Prefer using BIT macro
To: Sean Paul <seanpaul@chromium.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>, mchehab@kernel.org,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        outreachy-kernel@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Sep 8, 2017 at 8:59 PM, Sean Paul <seanpaul@chromium.org> wrote:
> On Fri, Sep 8, 2017 at 11:11 AM, Srishti Sharma <srishtishar@gmail.com> wrote:
>> Use BIT(x) instead of (1<<x).
>>
>> Signed-off-by: Srishti Sharma <srishtishar@gmail.com>
>> ---
>>  drivers/staging/media/imx/imx-media.h | 16 ++++++++--------
>>  1 file changed, 8 insertions(+), 8 deletions(-)
>>
>> diff --git a/drivers/staging/media/imx/imx-media.h b/drivers/staging/media/imx/imx-media.h
>> index d409170..e5b8d29 100644
>> --- a/drivers/staging/media/imx/imx-media.h
>> +++ b/drivers/staging/media/imx/imx-media.h
>> @@ -310,16 +310,16 @@ void imx_media_capture_device_set_format(struct imx_media_video_dev *vdev,
>>  void imx_media_capture_device_error(struct imx_media_video_dev *vdev);
>>
>>  /* subdev group ids */
>> -#define IMX_MEDIA_GRP_ID_SENSOR    (1 << 8)
>> -#define IMX_MEDIA_GRP_ID_VIDMUX    (1 << 9)
>> -#define IMX_MEDIA_GRP_ID_CSI2      (1 << 10)
>> +#define IMX_MEDIA_GRP_ID_SENSOR    BIT(8)
>> +#define IMX_MEDIA_GRP_ID_VIDMUX    BIT(9)
>> +#define IMX_MEDIA_GRP_ID_CSI2      BIT(10)
>>  #define IMX_MEDIA_GRP_ID_CSI_BIT   11
>>  #define IMX_MEDIA_GRP_ID_CSI       (0x3 << IMX_MEDIA_GRP_ID_CSI_BIT)
>> -#define IMX_MEDIA_GRP_ID_CSI0      (1 << IMX_MEDIA_GRP_ID_CSI_BIT)
>> +#define IMX_MEDIA_GRP_ID_CSI0      BIT(IMX_MEDIA_GRP_ID_CSI_BIT)
>>  #define IMX_MEDIA_GRP_ID_CSI1      (2 << IMX_MEDIA_GRP_ID_CSI_BIT)
>> -#define IMX_MEDIA_GRP_ID_VDIC      (1 << 13)
>> -#define IMX_MEDIA_GRP_ID_IC_PRP    (1 << 14)
>> -#define IMX_MEDIA_GRP_ID_IC_PRPENC (1 << 15)
>> -#define IMX_MEDIA_GRP_ID_IC_PRPVF  (1 << 16)
>> +#define IMX_MEDIA_GRP_ID_VDIC      BIT(13)
>> +#define IMX_MEDIA_GRP_ID_IC_PRP    BIT(14)
>> +#define IMX_MEDIA_GRP_ID_IC_PRPENC BIT(15)
>> +#define IMX_MEDIA_GRP_ID_IC_PRPVF  BIT(16)
>
> Hi Srishti,
> Thanks for your patch.
>
> Perhaps this is just personal preference, but I find the previous
> version more readable. Since IMX_MEDIA_GRP_ID_CSI and
> IMX_MEDIA_GRP_ID_CSI1 are multi-bit fields, you can't fully eliminate
> the bit shift operations, so you end up with a mix, which is kind of
> ugly.

 Thanks, for pointing that out .
 Regards,
 Srishti
>
> Sean
>
>>
>>  #endif
>> --
>> 2.7.4
>>
>> --
>> You received this message because you are subscribed to the Google Groups "outreachy-kernel" group.
>> To unsubscribe from this group and stop receiving emails from it, send an email to outreachy-kernel+unsubscribe@googlegroups.com.
>> To post to this group, send email to outreachy-kernel@googlegroups.com.
>> To view this discussion on the web visit https://groups.google.com/d/msgid/outreachy-kernel/1504883469-8127-1-git-send-email-srishtishar%40gmail.com.
>> For more options, visit https://groups.google.com/d/optout.
