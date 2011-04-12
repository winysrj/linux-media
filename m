Return-path: <mchehab@pedra>
Received: from na3sys009aog107.obsmtp.com ([74.125.149.197]:42460 "EHLO
	na3sys009aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757637Ab1DLPj5 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 12 Apr 2011 11:39:57 -0400
Received: by mail-ey0-f173.google.com with SMTP id 6so3203959eyb.18
        for <linux-media@vger.kernel.org>; Tue, 12 Apr 2011 08:39:55 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201104112352.07808.jkrzyszt@tis.icnet.pl>
References: <Pine.LNX.4.64.1104111054110.18511@axis700.grange>
 <201104112040.08077.jkrzyszt@tis.icnet.pl> <BANLkTinv7FxQjR7w4eL2je-s+3NC78GPHw@mail.gmail.com>
 <201104112352.07808.jkrzyszt@tis.icnet.pl>
From: "Aguirre, Sergio" <saaguirre@ti.com>
Date: Tue, 12 Apr 2011 10:39:35 -0500
Message-ID: <BANLkTik7YRvvthrSHwMuH_dcDaNzkN96NQ@mail.gmail.com>
Subject: Re: [PATCH] V4L: soc-camera: regression fix: calculate .sizeimage in soc_camera.c
To: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Mon, Apr 11, 2011 at 4:52 PM, Janusz Krzysztofik
<jkrzyszt@tis.icnet.pl> wrote:
> Dnia poniedzia³ek 11 kwiecieñ 2011 o 22:05:35 Aguirre, Sergio
> napisa³(a):
>>
>> Please find below a refreshed patch, which should be based on
>> mainline commit:
>
> Hi,
> This version works for me, and fixes the regression.

Ok, Thanks for testing.

Guennadi,

It's up to you if you want to take your patch or mine. I guess I just wanted
to be more complete in my patch, but strictly speaking about a regression
fix (And based on what the current popular apps do), both do the job.

This was just my proposal :).

Regards,
Sergio

>
> Thanks,
> Janusz
>
>> >From f767059c12c755ebe79c4b74de17c23a257007c7 Mon Sep 17 00:00:00
>> >2001
>>
>> From: Sergio Aguirre <saaguirre@ti.com>
>> Date: Mon, 11 Apr 2011 11:14:33 -0500
>> Subject: [PATCH] V4L: soc-camera: regression fix: calculate
>> .sizeimage in soc_camera.c
>>
>> A recent patch has given individual soc-camera host drivers a
>> possibility to calculate .sizeimage and .bytesperline pixel format
>> fields internally, however, some drivers relied on the core
>> calculating these values for them, following a default algorithm.
>> This patch restores the default calculation for such drivers.
>>
>> Based on initial patch by Guennadi Liakhovetski, found here:
>>
>> http://www.spinics.net/lists/linux-media/msg31282.html
>>
>> Except that this covers try_fmt aswell.
>>
>> Signed-off-by: Sergio Aguirre <saaguirre@ti.com>
>> ---
>>  drivers/media/video/soc_camera.c |   48
>> +++++++++++++++++++++++++++++++++---- 1 files changed, 42
>> insertions(+), 6 deletions(-)
>>
>> diff --git a/drivers/media/video/soc_camera.c
>> b/drivers/media/video/soc_camera.c index 4628448..dcc6623 100644
>> --- a/drivers/media/video/soc_camera.c
>> +++ b/drivers/media/video/soc_camera.c
>> @@ -136,11 +136,50 @@ unsigned long
>> soc_camera_apply_sensor_flags(struct soc_camera_link *icl,
>>  }
>>  EXPORT_SYMBOL(soc_camera_apply_sensor_flags);
>>
>> +#define pixfmtstr(x) (x) & 0xff, ((x) >> 8) & 0xff, ((x) >> 16) &
>> 0xff, \ +     ((x) >> 24) & 0xff
>> +
>> +static int soc_camera_try_fmt(struct soc_camera_device *icd,
>> +                           struct v4l2_format *f)
>> +{
>> +     struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
>> +     struct v4l2_pix_format *pix = &f->fmt.pix;
>> +     int ret;
>> +
>> +     dev_dbg(&icd->dev, "TRY_FMT(%c%c%c%c, %ux%u)\n",
>> +             pixfmtstr(pix->pixelformat), pix->width, pix->height);
>> +
>> +     pix->bytesperline = 0;
>> +     pix->sizeimage = 0;
>> +
>> +     ret = ici->ops->try_fmt(icd, f);
>> +     if (ret < 0)
>> +             return ret;
>> +
>> +     if (!pix->sizeimage) {
>> +             if (!pix->bytesperline) {
>> +                     const struct soc_camera_format_xlate *xlate;
>> +
>> +                     xlate = soc_camera_xlate_by_fourcc(icd, pix->pixelformat);
>> +                     if (!xlate)
>> +                             return -EINVAL;
>> +
>> +                     ret = soc_mbus_bytes_per_line(pix->width,
>> +                                                   xlate->host_fmt);
>> +                     if (ret > 0)
>> +                             pix->bytesperline = ret;
>> +             }
>> +             if (pix->bytesperline)
>> +                     pix->sizeimage = pix->bytesperline * pix->height;
>> +     }
>> +
>> +     return 0;
>> +}
>> +
>>  static int soc_camera_try_fmt_vid_cap(struct file *file, void *priv,
>>                                     struct v4l2_format *f)
>>  {
>>       struct soc_camera_device *icd = file->private_data;
>> -     struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
>>
>>       WARN_ON(priv != file->private_data);
>>
>> @@ -149,7 +188,7 @@ static int soc_camera_try_fmt_vid_cap(struct file
>> *file, void *priv,
>>               return -EINVAL;
>>
>>       /* limit format to hardware capabilities */
>> -     return ici->ops->try_fmt(icd, f);
>> +     return soc_camera_try_fmt(icd, f);
>>  }
>>
>>  static int soc_camera_enum_input(struct file *file, void *priv,
>> @@ -362,9 +401,6 @@ static void soc_camera_free_user_formats(struct
>> soc_camera_device *icd)
>>       icd->user_formats = NULL;
>>  }
>>
>> -#define pixfmtstr(x) (x) & 0xff, ((x) >> 8) & 0xff, ((x) >> 16) &
>> 0xff, \ -     ((x) >> 24) & 0xff
>> -
>>  /* Called with .vb_lock held, or from the first open(2), see comment
>> there */ static int soc_camera_set_fmt(struct soc_camera_device
>> *icd, struct v4l2_format *f)
>> @@ -377,7 +413,7 @@ static int soc_camera_set_fmt(struct
>> soc_camera_device *icd, pixfmtstr(pix->pixelformat), pix->width,
>> pix->height);
>>
>>       /* We always call try_fmt() before set_fmt() or set_crop() */
>> -     ret = ici->ops->try_fmt(icd, f);
>> +     ret = soc_camera_try_fmt(icd, f);
>>       if (ret < 0)
>>               return ret;
>
