Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:33766 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936159AbcCQQnP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Mar 2016 12:43:15 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [v4l-utils PATCH 1/1] libv4l2subdev: Allow extra spaces between format strings
Date: Thu, 17 Mar 2016 13:48:56 +0200
Message-ID: <1601179.aug9MENS7K@avalon>
In-Reply-To: <1457728998-11906-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1457728998-11906-1-git-send-email-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

Thank you for the patch.

On Friday 11 March 2016 22:43:18 Sakari Ailus wrote:
> It's possible to pass more than one format string (and entity) to
> v4l2_subdev_parse_setup_formats(), yet v4l2_subdev_parse_pad_format() does
> not parse the string until the next non-space character.
> v4l2_subdev_parse_setup_formats() expects to find a comma right after that
> leading spaces before the comma to produce an error.
> 
> Seek until no spaces are seen.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> ---
>  utils/media-ctl/libv4l2subdev.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/utils/media-ctl/libv4l2subdev.c
> b/utils/media-ctl/libv4l2subdev.c index 1f5fca4..3dcf943 100644
> --- a/utils/media-ctl/libv4l2subdev.c
> +++ b/utils/media-ctl/libv4l2subdev.c
> @@ -723,6 +723,7 @@ int v4l2_subdev_parse_setup_formats(struct media_device
> *media, const char *p) if (ret < 0)
>  			return ret;
> 
> +		for (; isspace(*end); end++);
>  		p = end + 1;
>  	} while (*end == ',');

-- 
Regards,

Laurent Pinchart

