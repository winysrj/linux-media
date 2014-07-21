Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:33717 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753960AbaGUJII (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Jul 2014 05:08:08 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH for v3.17] v4l2-ioctl: set V4L2_CAP_EXT_PIX_FORMAT for device_caps
Date: Mon, 21 Jul 2014 11:08:17 +0200
Message-ID: <2281012.6Hr5CBQnlD@avalon>
In-Reply-To: <53CCBDE6.7090907@xs4all.nl>
References: <53CCBDE6.7090907@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Thank you for the patch.

On Monday 21 July 2014 09:14:46 Hans Verkuil wrote:
> V4L2_CAP_EXT_PIX_FORMAT is set for capabilities, but it needs to be set for
> device_caps as well: device_caps should report all caps relevant to the
> device node, and this is one of them.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c
> b/drivers/media/v4l2-core/v4l2-ioctl.c index e620387..00ceedf 100644
> --- a/drivers/media/v4l2-core/v4l2-ioctl.c
> +++ b/drivers/media/v4l2-core/v4l2-ioctl.c
> @@ -1014,6 +1014,7 @@ static int v4l_querycap(const struct v4l2_ioctl_ops
> *ops, ret = ops->vidioc_querycap(file, fh, cap);
> 
>  	cap->capabilities |= V4L2_CAP_EXT_PIX_FORMAT;
> +	cap->device_caps |= V4L2_CAP_EXT_PIX_FORMAT;
> 
>  	return ret;
>  }

-- 
Regards,

Laurent Pinchart

