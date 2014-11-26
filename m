Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:53843 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750811AbaKZUp5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 26 Nov 2014 15:45:57 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, pawel@osciak.com,
	m.szyprowski@samsung.com, Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [REVIEWv7 PATCH 11/12] vim2m: support expbuf
Date: Wed, 26 Nov 2014 22:46:22 +0200
Message-ID: <3137751.VuWyuCONSS@avalon>
In-Reply-To: <1416315068-22936-12-git-send-email-hverkuil@xs4all.nl>
References: <1416315068-22936-1-git-send-email-hverkuil@xs4all.nl> <1416315068-22936-12-git-send-email-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Thank you for the patch.

On Tuesday 18 November 2014 13:51:07 Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> Reviewed-by: Pawel Osciak <pawel@osciak.com>

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> ---
>  drivers/media/platform/vim2m.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/media/platform/vim2m.c b/drivers/media/platform/vim2m.c
> index 87af47a..1105c11 100644
> --- a/drivers/media/platform/vim2m.c
> +++ b/drivers/media/platform/vim2m.c
> @@ -697,6 +697,7 @@ static const struct v4l2_ioctl_ops vim2m_ioctl_ops = {
>  	.vidioc_querybuf	= v4l2_m2m_ioctl_querybuf,
>  	.vidioc_qbuf		= v4l2_m2m_ioctl_qbuf,
>  	.vidioc_dqbuf		= v4l2_m2m_ioctl_dqbuf,
> +	.vidioc_expbuf		= v4l2_m2m_ioctl_expbuf,
> 
>  	.vidioc_streamon	= v4l2_m2m_ioctl_streamon,
>  	.vidioc_streamoff	= v4l2_m2m_ioctl_streamoff,

-- 
Regards,

Laurent Pinchart

