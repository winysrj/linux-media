Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:34395 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933657AbcAYTl2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 25 Jan 2016 14:41:28 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org, hverkuil@xs4all.nl
Subject: Re: [PATCH v2 1/1] v4l: libv4l2subdev: Precisely convert media bus string to code
Date: Mon, 25 Jan 2016 21:41:46 +0200
Message-ID: <1623086.c6ggshGW3K@avalon>
In-Reply-To: <1453725306-4047-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1453725306-4047-1-git-send-email-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

Thank you for the patch.

On Monday 25 January 2016 14:35:06 Sakari Ailus wrote:
> Any character beyond the fist `length' characters in the mbus_formats
> strings are ignored, causing incorrect matches if the format entry starts
> with but isn't equal to the passed format.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> ---
> since v1:
> - Use mbus_formats[i].name[length] == '\0' instead of comparing strlen()
>   result.
> 
>  utils/media-ctl/libv4l2subdev.c | 10 ++++------
>  1 file changed, 4 insertions(+), 6 deletions(-)
> 
> diff --git a/utils/media-ctl/libv4l2subdev.c
> b/utils/media-ctl/libv4l2subdev.c index 33c1ee6..dc2cd87 100644
> --- a/utils/media-ctl/libv4l2subdev.c
> +++ b/utils/media-ctl/libv4l2subdev.c
> @@ -769,14 +769,12 @@ enum v4l2_mbus_pixelcode
> v4l2_subdev_string_to_pixelcode(const char *string, unsigned int i;
> 
>  	for (i = 0; i < ARRAY_SIZE(mbus_formats); ++i) {
> -		if (strncmp(mbus_formats[i].name, string, length) == 0)
> -			break;
> +		if (strncmp(mbus_formats[i].name, string, length) == 0
> +		    && mbus_formats[i].name[length] == '\0')
> +			return mbus_formats[i].code;
>  	}
> 
> -	if (i == ARRAY_SIZE(mbus_formats))
> -		return (enum v4l2_mbus_pixelcode)-1;
> -
> -	return mbus_formats[i].code;
> +	return (enum v4l2_mbus_pixelcode)-1;
>  }
> 
>  static struct {

-- 
Regards,

Laurent Pinchart

