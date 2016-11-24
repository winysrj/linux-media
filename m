Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:54172 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S936406AbcKXM2V (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 24 Nov 2016 07:28:21 -0500
Date: Thu, 24 Nov 2016 14:28:17 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Jacek Anaszewski <j.anaszewski@samsung.com>
Cc: linux-media@vger.kernel.org, sakari.ailus@linux.intel.com,
        hverkuil@xs4all.nl, mchehab@kernel.org, m.szyprowski@samsung.com,
        s.nawrocki@samsung.com
Subject: Re: [PATCH v4l-utils v7 5/7] mediactl: libv4l2subdev: Add colorspace
 logging
Message-ID: <20161124122816.GG16630@valkosipuli.retiisi.org.uk>
References: <1476282922-11544-1-git-send-email-j.anaszewski@samsung.com>
 <1476282922-11544-6-git-send-email-j.anaszewski@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1476282922-11544-6-git-send-email-j.anaszewski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Hi Jacek,

On Wed, Oct 12, 2016 at 04:35:20PM +0200, Jacek Anaszewski wrote:
> Add a function for obtaining colorspace name by id.
> 
> Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
> Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
>  utils/media-ctl/libv4l2subdev.c | 32 ++++++++++++++++++++++++++++++++
>  utils/media-ctl/v4l2subdev.h    | 10 ++++++++++
>  2 files changed, 42 insertions(+)
> 
> diff --git a/utils/media-ctl/libv4l2subdev.c b/utils/media-ctl/libv4l2subdev.c
> index 4f8ee7f..31393bb 100644
> --- a/utils/media-ctl/libv4l2subdev.c
> +++ b/utils/media-ctl/libv4l2subdev.c
> @@ -33,6 +33,7 @@
>  #include <unistd.h>
>  
>  #include <linux/v4l2-subdev.h>
> +#include <linux/videodev2.h>
>  
>  #include "mediactl.h"
>  #include "mediactl-priv.h"
> @@ -831,6 +832,37 @@ const char *v4l2_subdev_pixelcode_to_string(enum v4l2_mbus_pixelcode code)
>  	return "unknown";
>  }
>  
> +static struct {

static const

> +	const char *name;
> +	enum v4l2_colorspace cs;
> +} colorspaces[] = {
> +        { "DEFAULT", V4L2_COLORSPACE_DEFAULT },
> +        { "SMPTE170M", V4L2_COLORSPACE_SMPTE170M },
> +        { "SMPTE240M", V4L2_COLORSPACE_SMPTE240M },
> +        { "REC709", V4L2_COLORSPACE_REC709 },
> +        { "BT878", V4L2_COLORSPACE_BT878 },
> +        { "470_SYSTEM_M", V4L2_COLORSPACE_470_SYSTEM_M },
> +        { "470_SYSTEM_BG", V4L2_COLORSPACE_470_SYSTEM_BG },
> +        { "JPEG", V4L2_COLORSPACE_JPEG },
> +        { "SRGB", V4L2_COLORSPACE_SRGB },
> +        { "ADOBERGB", V4L2_COLORSPACE_ADOBERGB },
> +        { "BT2020", V4L2_COLORSPACE_BT2020 },
> +        { "RAW", V4L2_COLORSPACE_RAW },
> +        { "DCI_P3", V4L2_COLORSPACE_DCI_P3 },
> +};
> +
> +const char *v4l2_subdev_colorspace_to_string(enum v4l2_colorspace cs)
> +{
> +	unsigned int i;
> +
> +	for (i = 0; i < ARRAY_SIZE(colorspaces); ++i) {
> +		if (colorspaces[i].cs == cs)
> +			return colorspaces[i].name;
> +	}
> +
> +	return "unknown";
> +}
> +
>  enum v4l2_mbus_pixelcode v4l2_subdev_string_to_pixelcode(const char *string)
>  {
>  	unsigned int i;
> diff --git a/utils/media-ctl/v4l2subdev.h b/utils/media-ctl/v4l2subdev.h
> index 4dee6b1..cf1250d 100644
> --- a/utils/media-ctl/v4l2subdev.h
> +++ b/utils/media-ctl/v4l2subdev.h
> @@ -278,6 +278,16 @@ int v4l2_subdev_parse_setup_formats(struct media_device *media, const char *p);
>  const char *v4l2_subdev_pixelcode_to_string(enum v4l2_mbus_pixelcode code);
>  
>  /**
> + * @brief Convert colorspace to string.
> + * @param code - input string
> + *
> + * Convert colorspace @a to a human-readable string.

@a code ?

With these,

Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>

> + *
> + * @return A pointer to a string on success, NULL on failure.
> + */
> +const char *v4l2_subdev_colorspace_to_string(enum v4l2_colorspace cs);
> +
> +/**
>   * @brief Parse string to media bus pixel code.
>   * @param string - nul terminalted string, textual media bus pixel code
>   *

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
