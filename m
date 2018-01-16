Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ot0-f193.google.com ([74.125.82.193]:40154 "EHLO
        mail-ot0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751280AbeAPVqE (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 16 Jan 2018 16:46:04 -0500
MIME-Version: 1.0
In-Reply-To: <3536229.Z78lxBGCHq@avalon>
References: <20180116164740.2097257-1-arnd@arndb.de> <3536229.Z78lxBGCHq@avalon>
From: Arnd Bergmann <arnd@arndb.de>
Date: Tue, 16 Jan 2018 22:46:03 +0100
Message-ID: <CAK8P3a3mBGtMbCuC73Jos33_9-MTXXhKC6jsCe1jb963H5gxZw@mail.gmail.com>
Subject: Re: [PATCH] [v3] media: s3c-camif: fix out-of-bounds array access
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        "moderated list:ARM/SAMSUNG EXYNOS ARM ARCHITECTURES"
        <linux-samsung-soc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Jan 16, 2018 at 9:17 PM, Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
> Hi Arnd,
>
> Thank you for the patch.
>
> On Tuesday, 16 January 2018 18:47:24 EET Arnd Bergmann wrote:
>> While experimenting with older compiler versions, I ran
>> into a warning that no longer shows up on gcc-4.8 or newer:
>>
>> drivers/media/platform/s3c-camif/camif-capture.c: In function
>> '__camif_subdev_try_format':
>> drivers/media/platform/s3c-camif/camif-capture.c:1265:25: error: array
>> subscript is below array bounds
>>
>> This is an off-by-one bug, leading to an access before the start of the
>> array, while newer compilers silently assume this undefined behavior
>> cannot happen and leave the loop at index 0 if no other entry matches.
>>
>> As Sylvester explains, we actually need to ensure that the
>> value is within the range, so this reworks the loop to be
>> easier to parse correctly, and an additional check to fall
>> back on the first format value for any unexpected input.
>>
>> I found an existing gcc bug for it and added a reduced version
>> of the function there.
>>
>> Link: https://gcc.gnu.org/bugzilla/show_bug.cgi?id=69249#c3
>> Fixes: babde1c243b2 ("[media] V4L: Add driver for S3C24XX/S3C64XX SoC series
>> camera interface") Signed-off-by: Arnd Bergmann <arnd@arndb.de>
>> ---
>> v3: fix newly introduced off-by-one bug.
>> v2: rework logic rather than removing it.
>> ---
>>  drivers/media/platform/s3c-camif/camif-capture.c | 9 ++++++---
>>  1 file changed, 6 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/media/platform/s3c-camif/camif-capture.c
>> b/drivers/media/platform/s3c-camif/camif-capture.c index
>> 437395a61065..f51b92e94a32 100644
>> --- a/drivers/media/platform/s3c-camif/camif-capture.c
>> +++ b/drivers/media/platform/s3c-camif/camif-capture.c
>> @@ -1256,16 +1256,19 @@ static void __camif_subdev_try_format(struct
>> camif_dev *camif, {
>>       const struct s3c_camif_variant *variant = camif->variant;
>>       const struct vp_pix_limits *pix_lim;
>> -     int i = ARRAY_SIZE(camif_mbus_formats);
>> +     int i;
>>
>>       /* FIXME: constraints against codec or preview path ? */
>>       pix_lim = &variant->vp_pix_limits[VP_CODEC];
>>
>> -     while (i-- >= 0)
>> +     for (i = 0; i < ARRAY_SIZE(camif_mbus_formats); i++)
>>               if (camif_mbus_formats[i] == mf->code)
>>                       break;
>>
>> -     mf->code = camif_mbus_formats[i];
>> +     if (i == ARRAY_SIZE(camif_mbus_formats))
>> +             mf->code = camif_mbus_formats[0];
>> +     else
>> +             mf->code = camif_mbus_formats[i];
>
> I might be missing something very obvious, but isn't mf->code already ==
> camif_mbus_formats[i] in the else branch ?

Ah, that must be what I was thinking back when I first
discussed it with Sylvester in
https://patchwork.kernel.org/patch/9950041/

Unfortunately, I hadn't given it as much thought today when
I tried to reconstruct the result to send a new version

> How about simply

>         unsigned int i;
>
>         /* FIXME: constraints against codec or preview path ? */
>         pix_lim = &variant->vp_pix_limits[VP_CODEC];
>
>         for (i = 0; i < ARRAY_SIZE(camif_mbus_formats); i++)
>                 if (camif_mbus_formats[i] == mf->code)
>                         break;
>
>         if (i == ARRAY_SIZE(camif_mbus_formats))
>                 mf->code = camif_mbus_formats[0];

Yes, makes sense. I'll send a v4.

          Arnd
