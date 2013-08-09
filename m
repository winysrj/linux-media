Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f182.google.com ([209.85.214.182]:48930 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934068Ab3HIQD6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 9 Aug 2013 12:03:58 -0400
Received: by mail-ob0-f182.google.com with SMTP id wo10so6633362obc.13
        for <linux-media@vger.kernel.org>; Fri, 09 Aug 2013 09:03:57 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAPybu_2nzJ5YmjzMViK+bnChKdNT_XvP3KPz5JARTbQPKQugjA@mail.gmail.com>
References: <1375483372-4354-1-git-send-email-ricardo.ribalda@gmail.com>
 <1375483372-4354-3-git-send-email-ricardo.ribalda@gmail.com>
 <51FD32F5.40200@googlemail.com> <CAPybu_2nzJ5YmjzMViK+bnChKdNT_XvP3KPz5JARTbQPKQugjA@mail.gmail.com>
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Date: Fri, 9 Aug 2013 18:03:37 +0200
Message-ID: <CAPybu_3mE16EeEuUvbimZr2Z2a0cNfPGpWYAZ2_qHPptqXQppQ@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] libv4lconvert: Support for RGB32 and BGR32 format
To: Gregor Jasny <gjasny@googlemail.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

ping?

On Sun, Aug 4, 2013 at 10:05 AM, Ricardo Ribalda Delgado
<ricardo.ribalda@gmail.com> wrote:
> Hello Gregor
>
> Thanks for your comments. I have replied inline.
>
> On Sat, Aug 3, 2013 at 6:42 PM, Gregor Jasny <gjasny@googlemail.com> wrote:
>> On 8/3/13 12:42 AM, Ricardo Ribalda Delgado wrote:
>>>
>>> +       case V4L2_PIX_FMT_RGB32:
>>> +               switch (dest_pix_fmt) {
>>> +               case V4L2_PIX_FMT_RGB24:
>>> +                       v4lconvert_rgb32_to_rgb24(src, dest, width,
>>> height, 0);
>>> +                       break;
>>> +               case V4L2_PIX_FMT_BGR24:
>>> +                       v4lconvert_rgb32_to_rgb24(src, dest, width,
>>> height, 1);
>>> +                       break;
>>> +               case V4L2_PIX_FMT_YUV420:
>>> +                       v4lconvert_rgb24_to_yuv420(src, dest, fmt, 0, 0,
>>> 4);
>>> +                       break;
>>> +               case V4L2_PIX_FMT_YVU420:
>>> +                       v4lconvert_rgb24_to_yuv420(src, dest, fmt, 0, 1,
>>> 4);
>>> +                       break;
>>> +               }
>>> +               if (src_size < (width * height * 4)) {
>>> +                       V4LCONVERT_ERR("short rgb32 data frame\n");
>>> +                       errno = EPIPE;
>>> +                       result = -1;
>>> +               }
>>> +               break;
>>
>>
>> I have not looked at the whole function but shouldn't this sanity check
>> happen before the actual work?
>
> Yes, but it is how it is done in the whole library with all the
> formats. Please grep for "short " on libv4lconvert.c
>
>> Also aren't you applying the condition here
>> also for rgb24_to_xxx which should have only three bpp?
>>
>
> I have modified the function rgb24_to_yuv420 to support other bytes per pixel.
>
>>
>>> +       case V4L2_PIX_FMT_BGR32:
>>> +               switch (dest_pix_fmt) {
>>> +               case V4L2_PIX_FMT_RGB24:
>>> +                       v4lconvert_rgb32_to_rgb24(src, dest, width,
>>> height, 1);
>>> +                       break;
>>> +               case V4L2_PIX_FMT_BGR24:
>>> +                       v4lconvert_rgb32_to_rgb24(src, dest, width,
>>> height, 0);
>>> +                       break;
>>> +               case V4L2_PIX_FMT_YUV420:
>>> +                       v4lconvert_rgb24_to_yuv420(src, dest, fmt, 1, 0,
>>> 4);
>>> +                       break;
>>> +               case V4L2_PIX_FMT_YVU420:
>>> +                       v4lconvert_rgb24_to_yuv420(src, dest, fmt, 1, 1,
>>> 4);
>>> +                       break;
>>> +               }
>>> +               if (src_size < (width * height * 4)) {
>>> +                       V4LCONVERT_ERR("short bgr32 data frame\n");
>>> +                       errno = EPIPE;
>>> +                       result = -1;
>>> +               }
>>> +               break;
>>
>>
>> Same here. And also in the other patch.
>>
>>
>
> Thanks again
>
> --
> Ricardo Ribalda



-- 
Ricardo Ribalda
