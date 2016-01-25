Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:34443 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757848AbcAYUR3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 25 Jan 2016 15:17:29 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org, hverkuil@xs4all.nl
Subject: Re: [PATCH v3 1/4] v4l: libv4lsubdev: Make mbus_formats array const
Date: Mon, 25 Jan 2016 22:17:46 +0200
Message-ID: <3931467.gMsOrk7hPF@avalon>
In-Reply-To: <1453725585-4165-2-git-send-email-sakari.ailus@linux.intel.com>
References: <1453725585-4165-1-git-send-email-sakari.ailus@linux.intel.com> <1453725585-4165-2-git-send-email-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

Thank you for the patch.

On Monday 25 January 2016 14:39:42 Sakari Ailus wrote:
> The array is already static and may not be modified at runtime. Make it
> const.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> ---
>  utils/media-ctl/libv4l2subdev.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/utils/media-ctl/libv4l2subdev.c
> b/utils/media-ctl/libv4l2subdev.c index dc2cd87..e45834f 100644
> --- a/utils/media-ctl/libv4l2subdev.c
> +++ b/utils/media-ctl/libv4l2subdev.c
> @@ -715,7 +715,7 @@ int v4l2_subdev_parse_setup_formats(struct media_device
> *media, const char *p) return *end ? -EINVAL : 0;
>  }
> 
> -static struct {
> +static const struct {
>  	const char *name;
>  	enum v4l2_mbus_pixelcode code;
>  } mbus_formats[] = {

-- 
Regards,

Laurent Pinchart

