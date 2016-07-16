Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:36100 "EHLO
	mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751451AbcGPOc5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 16 Jul 2016 10:32:57 -0400
MIME-Version: 1.0
In-Reply-To: <13000259.LGWzqn8rdl@avalon>
References: <1468599199-5902-1-git-send-email-ricardo.ribalda@gmail.com>
 <1704928.3gI88ec2Bn@avalon> <f0f50faf-67f6-6614-4ae3-b0f23aa09953@xs4all.nl> <13000259.LGWzqn8rdl@avalon>
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Date: Sat, 16 Jul 2016 16:32:35 +0200
Message-ID: <CAPybu_2N+gKU4=qRfxHhEurTvUqT0f8Pup55C8KKTT_jEwf2nw@mail.gmail.com>
Subject: Re: [PATCH v2 2/6] [media] Documentation: Add HSV format
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Antti Palosaari <crope@iki.fi>,
	Guennadi Liakhovetski <guennadi.liakhovetski@intel.com>,
	Helen Mae Koike Fornazier <helen.koike@collabora.co.uk>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Shuah Khan <shuahkh@osg.samsung.com>,
	linux-media <linux-media@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi

On Sat, Jul 16, 2016 at 4:12 PM, Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:

> I'd still like to know about it for my personal information :-)

Maybe it is just a very cheap gamma.

>
>> Anyway, I am inclined to use ycbcr_enc as well.
>
> I'm glad we agree.
>

Are you thinking about something like this:


diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
index c7fb760386cf..3e613fba1b20 100644
--- a/include/uapi/linux/videodev2.h
+++ b/include/uapi/linux/videodev2.h
@@ -330,6 +330,16 @@ enum v4l2_ycbcr_encoding {
        V4L2_YCBCR_ENC_SMPTE240M      = 8,
 };

+enum v4l2_hsv_encoding {
+       V4L2_HSV_ENC_180        = 16,
+       V4L2_HSV_ENC_256        = 17,
+};
+
+enum v4l2_rgb_encoding {
+       V4L2_RGB_ENC_FULL       = 32,
+       V4L2_HSV_ENC_16_235     = 33,
+};
+
 /*
  * Determine how YCBCR_ENC_DEFAULT should map to a proper Y'CbCr encoding.
  * This depends on the colorspace.
@@ -455,7 +465,11 @@ struct v4l2_pix_format {
        __u32                   colorspace;     /* enum v4l2_colorspace */
        __u32                   priv;           /* private data,
depends on pixelformat */
        __u32                   flags;          /* format flags
(V4L2_PIX_FMT_FLAG_*) */
-       __u32                   ycbcr_enc;      /* enum v4l2_ycbcr_encoding */
+       union {
+               __u32                   ycbcr_enc;      /* enum
v4l2_ycbcr_encoding */
+               __u32                   hsv_enc;        /* enum
v4l2_hsv_encoding */
+               __u32                   rgb_enc;        /* enum
v4l2_rgb_encoding */
+       };
        __u32                   quantization;   /* enum v4l2_quantization */
        __u32                   xfer_func;      /* enum v4l2_xfer_func */
 };
@@ -1988,7 +2002,11 @@ struct v4l2_pix_format_mplane {
        struct v4l2_plane_pix_format    plane_fmt[VIDEO_MAX_PLANES];
        __u8                            num_planes;
        __u8                            flags;
-       __u8                            ycbcr_enc;
+       union {
+               __u8                    ycbcr_enc;      /* enum
v4l2_ycbcr_encoding */
+               __u8                    hsv_enc;        /* enum
v4l2_hsv_encoding */
+               __u8                    rgb_enc;        /* enum
v4l2_rgb_encoding */
+       };
        __u8                            quantization;
        __u8                            xfer_func;
        __u8                            reserved[7];

> --


Best regards!

-- 
Ricardo Ribalda
