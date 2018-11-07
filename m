Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:34842 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726248AbeKGTre (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 7 Nov 2018 14:47:34 -0500
Date: Wed, 7 Nov 2018 12:17:51 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Yong Zhi <yong.zhi@intel.com>
Cc: linux-media@vger.kernel.org, hans.verkuil@cisco.com,
        sakari.ailus@linux.intel.com, rajmohan.mani@intel.com
Subject: Re: [PATCH] [v4l-utils] libv4l2subdev: Add MEDIA_BUS_FMT_FIXED to
 mbus_formats[]
Message-ID: <20181107101751.kembxo4qf6lubes3@valkosipuli.retiisi.org.uk>
References: <1541524376-27795-1-git-send-email-yong.zhi@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1541524376-27795-1-git-send-email-yong.zhi@intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Nov 06, 2018 at 09:12:56AM -0800, Yong Zhi wrote:
> Also add V4L2_COLORSPACE_RAW to the colorspaces[].
> 
> Signed-off-by: Yong Zhi <yong.zhi@intel.com>
> ---
>  utils/media-ctl/libv4l2subdev.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/utils/media-ctl/libv4l2subdev.c b/utils/media-ctl/libv4l2subdev.c
> index a989efb..46668eb 100644
> --- a/utils/media-ctl/libv4l2subdev.c
> +++ b/utils/media-ctl/libv4l2subdev.c
> @@ -855,6 +855,7 @@ static const struct {
>  	enum v4l2_mbus_pixelcode code;
>  } mbus_formats[] = {
>  #include "media-bus-format-names.h"
> +	{ "FIXED", MEDIA_BUS_FMT_FIXED},
>  	{ "Y8", MEDIA_BUS_FMT_Y8_1X8},
>  	{ "Y10", MEDIA_BUS_FMT_Y10_1X10 },
>  	{ "Y12", MEDIA_BUS_FMT_Y12_1X12 },
> @@ -965,7 +966,9 @@ static struct {
>  	{ "srgb", V4L2_COLORSPACE_SRGB },
>  	{ "oprgb", V4L2_COLORSPACE_OPRGB },
>  	{ "bt2020", V4L2_COLORSPACE_BT2020 },
> +	{ "raw", V4L2_COLORSPACE_RAW },
>  	{ "dcip3", V4L2_COLORSPACE_DCI_P3 },
> +
>  };
>  
>  const char *v4l2_subdev_colorspace_to_string(enum v4l2_colorspace colorspace)

The diff became:

diff --git a/utils/media-ctl/libv4l2subdev.c b/utils/media-ctl/libv4l2subdev.c
index 46668eb5..0d0afbe7 100644
--- a/utils/media-ctl/libv4l2subdev.c
+++ b/utils/media-ctl/libv4l2subdev.c
@@ -855,8 +855,8 @@ static const struct {
 	enum v4l2_mbus_pixelcode code;
 } mbus_formats[] = {
 #include "media-bus-format-names.h"
-	{ "FIXED", MEDIA_BUS_FMT_FIXED},
-	{ "Y8", MEDIA_BUS_FMT_Y8_1X8},
+	{ "FIXED", MEDIA_BUS_FMT_FIXED },
+	{ "Y8", MEDIA_BUS_FMT_Y8_1X8 },
 	{ "Y10", MEDIA_BUS_FMT_Y10_1X10 },
 	{ "Y12", MEDIA_BUS_FMT_Y12_1X12 },
 	{ "YUYV", MEDIA_BUS_FMT_YUYV8_1X16 },
@@ -968,7 +968,6 @@ static struct {
 	{ "bt2020", V4L2_COLORSPACE_BT2020 },
 	{ "raw", V4L2_COLORSPACE_RAW },
 	{ "dcip3", V4L2_COLORSPACE_DCI_P3 },
-
 };
 
 const char *v4l2_subdev_colorspace_to_string(enum v4l2_colorspace colorspace)

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi
