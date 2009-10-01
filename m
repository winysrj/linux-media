Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.irobotique.be ([92.243.18.41]:40870 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754898AbZJAASa (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 30 Sep 2009 20:18:30 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Joe Perches <joe@perches.com>
Subject: Re: [PATCH 6/9] drivers/media/video/uvc: Use %pUr to print UUIDs
Date: Thu, 1 Oct 2009 02:20:17 +0200
Cc: linux-kernel@vger.kernel.org,
	Adrian Hunter <adrian.hunter@nokia.com>,
	Alex Elder <aelder@sgi.com>,
	Artem Bityutskiy <dedekind@infradead.org>,
	Christoph Hellwig <hch@lst.de>,
	Harvey Harrison <harvey.harrison@gmail.com>,
	Huang Ying <ying.huang@intel.com>, Ingo Molnar <mingo@elte.hu>,
	Jeff Garzik <jgarzik@redhat.com>,
	Matt Mackall <mpm@selenic.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Neil Brown <neilb@suse.de>,
	Steven Whitehouse <swhiteho@redhat.com>,
	xfs-masters@oss.sgi.com, linux-media@vger.kernel.org
References: <cover.1254193019.git.joe@perches.com> <111526fa2ce7f728d1f81465a00859c1780f0607.1254193019.git.joe@perches.com>
In-Reply-To: <111526fa2ce7f728d1f81465a00859c1780f0607.1254193019.git.joe@perches.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <200910010220.17534.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Joe,

thanks for the patch. A few comments below.

On Tuesday 29 September 2009 07:01:08 Joe Perches wrote:
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  drivers/media/video/uvc/uvc_ctrl.c   |   69 ++++++++++++++++------------------
>  drivers/media/video/uvc/uvc_driver.c |    7 +--
>  drivers/media/video/uvc/uvcvideo.h   |   10 -----
>  3 files changed, 35 insertions(+), 51 deletions(-)
> 
> diff --git a/drivers/media/video/uvc/uvc_ctrl.c
>  b/drivers/media/video/uvc/uvc_ctrl.c index c3225a5..2959e46 100644
> --- a/drivers/media/video/uvc/uvc_ctrl.c
> +++ b/drivers/media/video/uvc/uvc_ctrl.c
> @@ -1093,8 +1093,8 @@ int uvc_xu_ctrl_query(struct uvc_video_chain *chain,
> 
>  	if (!found) {
>  		uvc_trace(UVC_TRACE_CONTROL,
> -			"Control " UVC_GUID_FORMAT "/%u not found.\n",
> -			UVC_GUID_ARGS(entity->extension.guidExtensionCode),
> +			"Control %pUr/%u not found.\n",
> +			entity->extension.guidExtensionCode,
>  			xctrl->selector);

Could you try to cut long statements in as few lines as possible ? This one
would become

		uvc_trace(UVC_TRACE_CONTROL, "Control %pUr/%u not found.\n",
			  entity->extension.guidExtensionCode, xctrl->selector);

There are a few others that should be changed as well. If you prefer I can
apply the patch through my tree (after the printk patch goes in of course)
and handle that myself.

[snip]

>  		flags = info->flags;
>  		if (((flags & UVC_CONTROL_GET_CUR) && !(inf & (1 << 0))) ||
>  		    ((flags & UVC_CONTROL_SET_CUR) && !(inf & (1 << 1)))) {
> -			uvc_trace(UVC_TRACE_CONTROL, "Control "
> -				UVC_GUID_FORMAT "/%u flags don't match "
> -				"supported operations.\n",
> -				UVC_GUID_ARGS(info->entity), info->selector);
> +			uvc_trace(UVC_TRACE_CONTROL,
> +				  "Control %pUr/%u flags don't match supported operations.\n",
> +				  info->entity, info->selector);

This doesn't fit the 80 columns limit. Please run checkpatch.pl on your patches.

[snip]

> diff --git a/drivers/media/video/uvc/uvc_driver.c
>  b/drivers/media/video/uvc/uvc_driver.c index 8756be5..647d0a2 100644
> --- a/drivers/media/video/uvc/uvc_driver.c
> +++ b/drivers/media/video/uvc/uvc_driver.c
> @@ -328,11 +328,10 @@ static int uvc_parse_format(struct uvc_device *dev,
>  				sizeof format->name);
>  			format->fcc = fmtdesc->fcc;
>  		} else {
> -			uvc_printk(KERN_INFO, "Unknown video format "
> -				UVC_GUID_FORMAT "\n",
> -				UVC_GUID_ARGS(&buffer[5]));
> +			uvc_printk(KERN_INFO, "Unknown video format %pUr\n",
> +				   &buffer[5]);
>  			snprintf(format->name, sizeof format->name,
> -				UVC_GUID_FORMAT, UVC_GUID_ARGS(&buffer[5]));
> +				 "%pUr", &Buffer[5]);

Should be &buffer[5], not &Buffer[5]. You haven't compiled the patch, have
you ? :-)

-- 
Regards,

Laurent Pinchart
