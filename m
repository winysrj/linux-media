Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:53846 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750811AbaKZUp6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 26 Nov 2014 15:45:58 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, pawel@osciak.com,
	m.szyprowski@samsung.com, Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [REVIEWv7 PATCH 10/12] vivid: enable vb2_expbuf support.
Date: Wed, 26 Nov 2014 22:46:24 +0200
Message-ID: <18924016.auAXXVZnGG@avalon>
In-Reply-To: <1416315068-22936-11-git-send-email-hverkuil@xs4all.nl>
References: <1416315068-22936-1-git-send-email-hverkuil@xs4all.nl> <1416315068-22936-11-git-send-email-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Thank you for the patch.

On Tuesday 18 November 2014 13:51:06 Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> Now that vb2 supports DMABUF export for dma-sg and vmalloc memory
> modes, we can enable the vb2_expbuf support in vivid.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> Reviewed-by: Pawel Osciak <pawel@osciak.com>

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> ---
>  drivers/media/platform/vivid/vivid-core.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/media/platform/vivid/vivid-core.c
> b/drivers/media/platform/vivid/vivid-core.c index 686c3c2..f80d1ca 100644
> --- a/drivers/media/platform/vivid/vivid-core.c
> +++ b/drivers/media/platform/vivid/vivid-core.c
> @@ -586,7 +586,7 @@ static const struct v4l2_ioctl_ops vivid_ioctl_ops = {
>  	.vidioc_querybuf		= vb2_ioctl_querybuf,
>  	.vidioc_qbuf			= vb2_ioctl_qbuf,
>  	.vidioc_dqbuf			= vb2_ioctl_dqbuf,
> -/* Not yet	.vidioc_expbuf		= vb2_ioctl_expbuf,*/
> +	.vidioc_expbuf			= vb2_ioctl_expbuf,
>  	.vidioc_streamon		= vb2_ioctl_streamon,
>  	.vidioc_streamoff		= vb2_ioctl_streamoff,

-- 
Regards,

Laurent Pinchart

