Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:51992 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726386AbeJAOJH (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 1 Oct 2018 10:09:07 -0400
Date: Mon, 1 Oct 2018 10:32:40 +0300
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: bingbu.cao@intel.com
Cc: linux-media@vger.kernel.org, tfiga@chromium.org, tfiga@google.com,
        rajmohan.mani@intel.com, bingbu.cao@linux.intel.com,
        tian.shu.qiu@intel.com, jian.xu.zheng@intel.com,
        chiranjeevi.rapolu@intel.com
Subject: Re: [PATCH v3] media: add imx355 camera sensor driver
Message-ID: <20181001073240.x4ocejnes3j2pzbp@paasikivi.fi.intel.com>
References: <1538215434-29375-1-git-send-email-bingbu.cao@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1538215434-29375-1-git-send-email-bingbu.cao@intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Bingbu,

On Sat, Sep 29, 2018 at 06:03:54PM +0800, bingbu.cao@intel.com wrote:
> From: Bingbu Cao <bingbu.cao@intel.com>
> 
> Add a v4l2 sub-device driver for the Sony imx355 image sensor.
> This is a camera sensor using the i2c bus for control and the
> csi-2 bus for data.
> 
> This driver supports following features:
> 
> - manual exposure and analog/digital gain control support
> - vblank/hblank control support
> - 4 test patterns control support
> - vflip/hflip control support (will impact the output bayer order)
> - support following resolutions:
>     - 3268x2448, 3264x2448, 3280x2464 @ 30fps
>     - 1940x1096, 1936x1096, 1924x1080, 1920x1080 @ 60fps
>     - 1640x1232, 1640x922, 1300x736, 1296x736,
>       1284x720, 1280x720 820x616 @ 120fps
> - support 4 bayer orders output (via change v/hflip)
>     - SRGGB10(default), SGRBG10, SGBRG10, SBGGR10
> 
> Cc: Tomasz Figa <tfiga@chromium.org>
> Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
> Signed-off-by: Tianshu Qiu <tian.shu.qiu@intel.com>
> Signed-off-by: Bingbu Cao <bingbu.cao@intel.com>
> 
> ---
> 
> This patch is based on sakari's media-tree git:
> https://git.linuxtv.org/sailus/media_tree.git/log/?h=for-4.20-8
> 
> changes since v2:
>  - get CSI-2 link frequencies and external clock
>    from firmware
>  - select digital gain mode when streaming
> 
> changes v1 -> v2:
>  - fix some coding style issues - line breaks
>  - add v4l2_ctrl_grab() to prevent v/hflip change
>    during streaming
>  - add v4l2 ctrl event (un)subscribe support
>  - correct link frequency
>  - add more info into commit message

Thanks for the update.

I've applied the patch with the following diff, to make it work on systems
without 64-bit division:

diff --git a/drivers/media/i2c/imx355.c b/drivers/media/i2c/imx355.c
index 858cd0f8bc10..6878b444ea78 100644
--- a/drivers/media/i2c/imx355.c
+++ b/drivers/media/i2c/imx355.c
@@ -1360,7 +1360,8 @@ imx355_set_pad_format(struct v4l2_subdev *sd,
 		*framefmt = fmt->format;
 	} else {
 		imx355->cur_mode = mode;
-		pixel_rate = (imx355->link_def_freq * 2 * 4) / 10;
+		pixel_rate = imx355->link_def_freq * 2 * 4;
+		do_div(pixel_rate, 10);
 		__v4l2_ctrl_s_ctrl_int64(imx355->pixel_rate, pixel_rate);
 		/* Update limits and set FPS to default */
 		height = imx355->cur_mode->height;
@@ -1587,7 +1588,8 @@ static int imx355_init_controls(struct imx355 *imx355)
 		imx355->link_freq->flags |= V4L2_CTRL_FLAG_READ_ONLY;
 
 	/* pixel_rate = link_freq * 2 * nr_of_lanes / bits_per_sample */
-	pixel_rate = (imx355->link_def_freq * 2 * 4) / 10;
+	pixel_rate = imx355->link_def_freq * 2 * 4;
+	do_div(pixel_rate, 10);
 	/* By default, PIXEL_RATE is read only */
 	imx355->pixel_rate = v4l2_ctrl_new_std(ctrl_hdlr, &imx355_ctrl_ops,
 					       V4L2_CID_PIXEL_RATE, pixel_rate,

-- 
Kind regards,

Sakari Ailus
sakari.ailus@linux.intel.com
