Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:40104 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754226AbeEHGoz (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 8 May 2018 02:44:55 -0400
Received: by mail-wm0-f68.google.com with SMTP id j5-v6so19361548wme.5
        for <linux-media@vger.kernel.org>; Mon, 07 May 2018 23:44:54 -0700 (PDT)
Subject: Re: [PATCH 2/2] media: v4l: Add new 10-bit packed grayscale format
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: mchehab@kernel.org, hverkuil@xs4all.nl,
        laurent.pinchart@ideasonboard.com, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1524829239-4664-1-git-send-email-todor.tomov@linaro.org>
 <1524829239-4664-3-git-send-email-todor.tomov@linaro.org>
 <20180507105956.o5fhjq7udmo7qt2z@valkosipuli.retiisi.org.uk>
From: Todor Tomov <todor.tomov@linaro.org>
Message-ID: <de236dfe-fba6-0f96-0144-e108136eef92@linaro.org>
Date: Tue, 8 May 2018 09:44:50 +0300
MIME-Version: 1.0
In-Reply-To: <20180507105956.o5fhjq7udmo7qt2z@valkosipuli.retiisi.org.uk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On  7.05.2018 13:59, Sakari Ailus wrote:
> Hi Todor,
> 
> On Fri, Apr 27, 2018 at 02:40:39PM +0300, Todor Tomov wrote:
>> The new format will be called V4L2_PIX_FMT_Y10P.
>> It is similar to the V4L2_PIX_FMT_SBGGR10P family formats
>> but V4L2_PIX_FMT_Y10P is a grayscale format.
>>
>> Signed-off-by: Todor Tomov <todor.tomov@linaro.org>
>> ---
>>  Documentation/media/uapi/v4l/pixfmt-y10p.rst | 31 ++++++++++++++++++++++++++++
>>  Documentation/media/uapi/v4l/yuv-formats.rst |  1 +
>>  drivers/media/v4l2-core/v4l2-ioctl.c         |  1 +
>>  include/uapi/linux/videodev2.h               |  1 +
>>  4 files changed, 34 insertions(+)
>>  create mode 100644 Documentation/media/uapi/v4l/pixfmt-y10p.rst
>>
>> diff --git a/Documentation/media/uapi/v4l/pixfmt-y10p.rst b/Documentation/media/uapi/v4l/pixfmt-y10p.rst
>> new file mode 100644
>> index 0000000..0018fe7
>> --- /dev/null
>> +++ b/Documentation/media/uapi/v4l/pixfmt-y10p.rst
>> @@ -0,0 +1,31 @@
>> +.. -*- coding: utf-8; mode: rst -*-
>> +
>> +.. _V4L2-PIX-FMT-Y10P:
>> +
>> +******************************
>> +V4L2_PIX_FMT_Y10P ('Y10P')
>> +******************************
>> +
>> +Grey-scale image as a MIPI RAW10 packed array
>> +
>> +
>> +Description
>> +===========
>> +
>> +This is a packed grey-scale image format with a depth of 10 bits per
>> +pixel. Every four consecutive pixels are packed into 5 bytes. Each of
>> +the first 4 bytes contain the 8 high order bits of the pixels, and
>> +the 5th byte contains the 2 least significants bits of each pixel,
>> +in the same order.
>> +
>> +**Bit-packed representation.**
>> +
>> +.. flat-table::
>> +    :header-rows:  0
>> +    :stub-columns: 0
>> +
>> +    * - Y'\ :sub:`00[9:2]`
>> +      - Y'\ :sub:`01[9:2]`
>> +      - Y'\ :sub:`02[9:2]`
>> +      - Y'\ :sub:`03[9:2]`
>> +      - Y'\ :sub:`03[1:0]`\ Y'\ :sub:`02[1:0]`\ Y'\ :sub:`01[1:0]`\ Y'\ :sub:`00[1:0]`
> 
> Could you add which exact bits the two LSBs of each pixel go to in the last
> byte, as in the 10-bit packed Bayer format documentation?

Thank you for review. I'll add and send v2.

Best regards,
Todor

> 
>> diff --git a/Documentation/media/uapi/v4l/yuv-formats.rst b/Documentation/media/uapi/v4l/yuv-formats.rst
>> index 3334ea4..9ab0592 100644
>> --- a/Documentation/media/uapi/v4l/yuv-formats.rst
>> +++ b/Documentation/media/uapi/v4l/yuv-formats.rst
>> @@ -29,6 +29,7 @@ to brightness information.
>>      pixfmt-y10
>>      pixfmt-y12
>>      pixfmt-y10b
>> +    pixfmt-y10p
>>      pixfmt-y16
>>      pixfmt-y16-be
>>      pixfmt-y8i
>> diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
>> index f48c505..bdf2399 100644
>> --- a/drivers/media/v4l2-core/v4l2-ioctl.c
>> +++ b/drivers/media/v4l2-core/v4l2-ioctl.c
>> @@ -1147,6 +1147,7 @@ static void v4l_fill_fmtdesc(struct v4l2_fmtdesc *fmt)
>>  	case V4L2_PIX_FMT_Y16:		descr = "16-bit Greyscale"; break;
>>  	case V4L2_PIX_FMT_Y16_BE:	descr = "16-bit Greyscale BE"; break;
>>  	case V4L2_PIX_FMT_Y10BPACK:	descr = "10-bit Greyscale (Packed)"; break;
>> +	case V4L2_PIX_FMT_Y10P:		descr = "10-bit Greyscale (MIPI Packed)"; break;
>>  	case V4L2_PIX_FMT_Y8I:		descr = "Interleaved 8-bit Greyscale"; break;
>>  	case V4L2_PIX_FMT_Y12I:		descr = "Interleaved 12-bit Greyscale"; break;
>>  	case V4L2_PIX_FMT_Z16:		descr = "16-bit Depth"; break;
>> diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
>> index 600877b..b24ab720 100644
>> --- a/include/uapi/linux/videodev2.h
>> +++ b/include/uapi/linux/videodev2.h
>> @@ -522,6 +522,7 @@ struct v4l2_pix_format {
>>  
>>  /* Grey bit-packed formats */
>>  #define V4L2_PIX_FMT_Y10BPACK    v4l2_fourcc('Y', '1', '0', 'B') /* 10  Greyscale bit-packed */
>> +#define V4L2_PIX_FMT_Y10P    v4l2_fourcc('Y', '1', '0', 'P') /* 10  Greyscale, MIPI RAW10 packed */
>>  
>>  /* Palette formats */
>>  #define V4L2_PIX_FMT_PAL8    v4l2_fourcc('P', 'A', 'L', '8') /*  8  8-bit palette */
>> -- 
>> 2.7.4
>>
> 
