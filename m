Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga07.intel.com ([134.134.136.100]:35136 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726401AbeIZOJI (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 26 Sep 2018 10:09:08 -0400
Date: Wed, 26 Sep 2018 10:57:16 +0300
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: bingbu.cao@intel.com
Cc: linux-media@vger.kernel.org, tfiga@google.com,
        rajmohan.mani@intel.com, bingbu.cao@linux.intel.com,
        tian.shu.qiu@intel.com, jian.xu.zheng@intel.com,
        chiranjeevi.rapolu@intel.com
Subject: Re: [PATCH v7] media: add imx319 camera sensor driver
Message-ID: <20180926075716.zjyt6kn2hb6nx7mp@kekkonen.localdomain>
References: <1537929738-27745-1-git-send-email-bingbu.cao@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1537929738-27745-1-git-send-email-bingbu.cao@intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Bingbu,

On Wed, Sep 26, 2018 at 10:42:18AM +0800, bingbu.cao@intel.com wrote:
> From: Bingbu Cao <bingbu.cao@intel.com>
> 
> Add a v4l2 sub-device driver for the Sony imx319 image sensor.
> This is a camera sensor using the i2c bus for control and the
> csi-2 bus for data.
> 
> This driver supports following features:
> - manual exposure and analog/digital gain control support
> - vblank/hblank control support
> -  4 test patterns control support
> - vflip/hflip control support (will impact the output bayer order)
> - support following resolutions:
>     - 3264x2448, 3280x2464 @ 30fps
>     - 1936x1096, 1920x1080 @ 60fps
>     - 1640x1232, 1640x922, 1296x736, 1280x720 @ 120fps
> - support 4 bayer orders output (via change v/hflip)
>     - SRGGB10(default), SGRBG10, SGBRG10, SBGGR10
> 
> Cc: Tomasz Figa <tfiga@chromium.org>
> Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
> Signed-off-by: Bingbu Cao <bingbu.cao@intel.com>
> Signed-off-by: Tianshu Qiu <tian.shu.qiu@intel.com>
> 
> ---
> 
> This patch is based on sakari's media-tree git:
> https://git.linuxtv.org/sailus/media_tree.git/log/?h=for-4.20-1
> 
> Changes from v5:
>  - add some comments for gain calculation
>  - use lock to protect the format
>  - fix some style issues

Thanks for the update!

I've applied the patch with the following diff. Dividing a 64-bit number
generally requires do_div() which was missed in the review:

diff --git a/drivers/media/i2c/imx319.c b/drivers/media/i2c/imx319.c
index e10d60f500dd..37c31d17ecf0 100644
--- a/drivers/media/i2c/imx319.c
+++ b/drivers/media/i2c/imx319.c
@@ -2038,7 +2038,7 @@ imx319_set_pad_format(struct v4l2_subdev *sd,
 	s32 vblank_def;
 	s32 vblank_min;
 	s64 h_blank;
-	s64 pixel_rate;
+	u64 pixel_rate;
 	u32 height;
 
 	mutex_lock(&imx319->mutex);
@@ -2059,7 +2059,8 @@ imx319_set_pad_format(struct v4l2_subdev *sd,
 		*framefmt = fmt->format;
 	} else {
 		imx319->cur_mode = mode;
-		pixel_rate = (imx319->link_def_freq * 2 * 4) / 10;
+		pixel_rate = imx319->link_def_freq * 2 * 4;
+		do_div(pixel_rate, 10);
 		__v4l2_ctrl_s_ctrl_int64(imx319->pixel_rate, pixel_rate);
 		/* Update limits and set FPS to default */
 		height = imx319->cur_mode->height;
@@ -2268,7 +2269,7 @@ static int imx319_init_controls(struct imx319 *imx319)
 	s64 vblank_def;
 	s64 vblank_min;
 	s64 hblank;
-	s64 pixel_rate;
+	u64 pixel_rate;
 	const struct imx319_mode *mode;
 	u32 max;
 	int ret;
@@ -2287,7 +2288,8 @@ static int imx319_init_controls(struct imx319 *imx319)
 		imx319->link_freq->flags |= V4L2_CTRL_FLAG_READ_ONLY;
 
 	/* pixel_rate = link_freq * 2 * nr_of_lanes / bits_per_sample */
-	pixel_rate = (imx319->link_def_freq * 2 * 4) / 10;
+	pixel_rate = imx319->link_def_freq * 2 * 4;
+	do_div(pixel_rate, 10);
 	/* By default, PIXEL_RATE is read only */
 	imx319->pixel_rate = v4l2_ctrl_new_std(ctrl_hdlr, &imx319_ctrl_ops,
 					       V4L2_CID_PIXEL_RATE, pixel_rate,

-- 
Kind regards,

Sakari Ailus
sakari.ailus@linux.intel.com
