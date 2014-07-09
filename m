Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f182.google.com ([209.85.212.182]:58385 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752198AbaGIP5A (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 9 Jul 2014 11:57:00 -0400
Received: by mail-wi0-f182.google.com with SMTP id d1so736276wiv.15
        for <linux-media@vger.kernel.org>; Wed, 09 Jul 2014 08:56:59 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <6639318.OE0dlORGdR@avalon>
References: <6639318.OE0dlORGdR@avalon>
Date: Wed, 9 Jul 2014 17:56:59 +0200
Message-ID: <CAFqH_50BgmxuW1Q_4ofdDB7t=O2jw=jTGmBm+NWn1tBMtFWRjQ@mail.gmail.com>
Subject: Re: [GIT PULL FOR v3.16] mt9p031 fixes
From: Enric Balletbo Serra <eballetbo@gmail.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

2014-05-16 2:45 GMT+02:00 Laurent Pinchart <laurent.pinchart@ideasonboard.com>:
> Hi Mauro,
>
> The following changes since commit ba0d342ecc21fbbe2f6c178f4479944d1fb34f3b:
>
>   saa7134-alsa: include vmalloc.h (2014-05-13 23:05:15 -0300)
>
> are available in the git repository at:
>
>   git://linuxtv.org/pinchartl/media.git sensors/next
>
> for you to fetch changes up to a3a7145c6cecbd9752311b8ae1e431f6755ad5f3:
>
>   mt9p031: Fix BLC configuration restore when disabling test pattern
> (2014-05-16 02:43:50 +0200)
>
> ----------------------------------------------------------------
> Laurent Pinchart (2):
>       mt9p031: Really disable Black Level Calibration in test pattern mode
>       mt9p031: Fix BLC configuration restore when disabling test pattern
>
>  drivers/media/i2c/mt9p031.c | 53
> +++++++++++++++++++++++++++++++++++++++--------------
>  1 file changed, 39 insertions(+), 14 deletions(-)
>

I'm trying to test omap3-isp and a board with mt9p031 sensor with
current mainline. For now I'm using tag version 3.15 (which is close
to current mainline). First, when I tried to use the test patterns I
only saw a black screen, but after applying these two patches I saw an
improvement, although I can see the test pattern correctly.

After some modifications the subdevs_group for my board is as follows:

+static struct isp_v4l2_subdevs_group igep00x0_camera_subdevs[] = {
+       {
+               .subdevs = cam0020_primary_subdevs,
+               .interface = ISP_INTERFACE_PARALLEL,
+               .bus = {
+                       .parallel = {
+                               /* CAM[11:0] */
+                               .data_lane_shift = ISP_LANE_SHIFT_2,
+                               /* Sample on falling edge */
+                               .clk_pol = 1,
+                       }
+               },
+       },
+       { },
+};

As I have some problems I would ask some questions, maybe you can help me.

In the past in the data_lane_shift was ISP_LANE_SHIFT_0, but now, it
seems I should to use ISP_LANE_SHIFT_2 (CAM[11:0] - as I saw in the
include file). ISP_LANE_SHIFT_0 is for CAM[13:0] but OMAP3 has only 12
data bus signals. Is that right ?

Another thing is I'm not able to capture the image correctly, also if
if configure to ouput a test pattern, doesn't looks good. See as
example [1] and [2]. Do you know what could be the problem ?

For your information these are the pipeline that I'm using :

  media-ctl -v -r -l '"mt9p031 1-005d":0->"OMAP3 ISP CCDC":0[1],
"OMAP3 ISP CCDC":2->"OMAP3 ISP preview":0[1], "OMAP3 ISP
preview":1->"OMAP3 ISP resizer":0[1], "OMAP3 ISP resizer":1->"OMAP3
ISP resizer output":0[1]'

  media-ctl -v -f '"mt9p031 1-005d":0[SGRBG12 720x480], "OMAP3 ISP
CCDC":2[SGRBG8 720x480], "OMAP3 ISP preview":1[UYVY 720x480], "OMAP3
ISP resizer":1[UYVY 720x480]'

# Set Vertical Color Bars as test pattern
  yavta -w '0x009f0903 9' /dev/v4l-subdev8

# Capture data with
  yavta  -f UYVY -s 720x480 --capture=5 --skip=1 --file=image-# /dev/video6

# And convert with
  raw2rgbpnm -s 720x480 image-00000.uyuv image-00000.pnm

Thanks in advance and any help will be appreciate.

Regards,
  Enric

[1] http://downloads.isee.biz/pub/files/tmp/9-Vertical Color Bars.pnm
[2] http://downloads.isee.biz/pub/files/tmp/9-Vertical Color Bars.uyvy


> --
> Regards,
>
> Laurent Pinchart
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
