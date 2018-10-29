Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-it1-f173.google.com ([209.85.166.173]:38108 "EHLO
        mail-it1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726046AbeJ2Wo0 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 29 Oct 2018 18:44:26 -0400
Received: by mail-it1-f173.google.com with SMTP id i76-v6so9459670ita.3
        for <linux-media@vger.kernel.org>; Mon, 29 Oct 2018 06:55:39 -0700 (PDT)
MIME-Version: 1.0
From: Martin Townsend <mtownsend1973@gmail.com>
Date: Mon, 29 Oct 2018 13:55:27 +0000
Message-ID: <CABatt_yUqTfQgoJJH6sS+4GsHLXejQchPUZSCJL+s1Jk8-o8Gg@mail.gmail.com>
Subject: NPE with atmel-isc when using the ov5640 driver
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Apologies if this is the wrong mailing list and if so could you advise
me on the correct one.

I'm trying to use the OmniVision ov5640 camera sensor with the ATMEL
SAMA5D2 using it's Image Sensor Controller (ISC).  I've seen a link
where they have this controller working with the ov7670 and ov7740.
But when I try and use with the OV5640 I get a NULL pointer
dereference on boot.  After debugging I found that it was due to the
atmel ISC driver assuming that isc->raw_fmt would be set.  It looks
like it should be set in isc_formats_init but the OV5640 doesn't have
any formats that match the formats in ISC where FMT_FLAG_RAW_FORMAT is
set and hence isc->raw_fmt is NULL.

In the OV5640 driver it has the following list
static const struct ov5640_pixfmt ov5640_formats[] = {
{ MEDIA_BUS_FMT_JPEG_1X8, V4L2_COLORSPACE_JPEG, },
{ MEDIA_BUS_FMT_UYVY8_2X8, V4L2_COLORSPACE_SRGB, },
{ MEDIA_BUS_FMT_YUYV8_2X8, V4L2_COLORSPACE_SRGB, },
{ MEDIA_BUS_FMT_RGB565_2X8_LE, V4L2_COLORSPACE_SRGB, },
{ MEDIA_BUS_FMT_RGB565_2X8_BE, V4L2_COLORSPACE_SRGB, },
};

and ISC matches MEDIA_BUS_FMT_YUYV8_2X8
{
.fourcc = V4L2_PIX_FMT_YUYV,
.mbus_code = MEDIA_BUS_FMT_YUYV8_2X8,
.flags = FMT_FLAG_FROM_CONTROLLER |
  FMT_FLAG_FROM_SENSOR,
.bpp = 16,
},

but that seems about all it does match.  Then in the ISC driver there
are quite a few cases where sensor_is_preferred is called but it goes
down the RAW format case
e.g.
if (sensor_is_preferred(isc_fmt))
   fse.code = isc_fmt->mbus_code;
else
   fse.code = isc->raw_fmt->mbus_code;

would run fse.code = isc->raw_fmt->mbus_code; and raise a NPE.  I
debugged sensor_is_preferred and it was because isc_fmt->sd_support is
false.

I notice that the ov7760 driver matches a format that has
FMT_FLAG_RAW_FROM_SENSOR so this is probably why it works.

My question is should the ov5640 driver be modified to include a
format where FMT_FLAG_RAW_FROM_SENSOR is set, or should the Atmel ISC
driver be modified to handle drivers where there is no match for a Raw
Format?

Many Thanks in Advance,
Martin.
