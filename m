Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:34650 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726223AbeKGT1g (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 7 Nov 2018 14:27:36 -0500
Date: Wed, 7 Nov 2018 11:57:57 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Yong Zhi <yong.zhi@intel.com>
Cc: linux-media@vger.kernel.org, hans.verkuil@cisco.com,
        sakari.ailus@linux.intel.com, rajmohan.mani@intel.com
Subject: Re: [PATCH] [v4l-utils] libv4l2subdev: Add MEDIA_BUS_FMT_FIXED to
 mbus_formats[]
Message-ID: <20181107095757.qtpqk4pnic2emhzw@valkosipuli.retiisi.org.uk>
References: <1541524376-27795-1-git-send-email-yong.zhi@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1541524376-27795-1-git-send-email-yong.zhi@intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Yong,

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

Extra newlne.

I can remove it as well while applying the patch.

>  };
>  
>  const char *v4l2_subdev_colorspace_to_string(enum v4l2_colorspace colorspace)

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi
