Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.irobotique.be ([92.243.18.41]:56542 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751738Ab0DVJM5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 22 Apr 2010 05:12:57 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Pawel Osciak <p.osciak@samsung.com>
Subject: Re: [PATCH] v4l: videobuf: qbuf now uses relevant v4l2_buffer fields for OUTPUT types
Date: Thu, 22 Apr 2010 11:14:41 +0200
Cc: linux-media@vger.kernel.org, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com
References: <1271843067-23496-1-git-send-email-p.osciak@samsung.com>
In-Reply-To: <1271843067-23496-1-git-send-email-p.osciak@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201004221114.41737.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Pawel,

On Wednesday 21 April 2010 11:44:27 Pawel Osciak wrote:
> According to the V4L2 specification, applications set bytesused, field and
> timestamp fields of struct v4l2_buffer when the buffer is intended for
> output and memory type is MMAP. This adds proper copying of those values
> to videobuf_buffer so drivers can use them.

Why only for the MMAP memory type ? Don't drivers need the information for 
USERPTR buffers as well ?

> Signed-off-by: Pawel Osciak <p.osciak@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
>  drivers/media/video/videobuf-core.c |    7 +++++++
>  1 files changed, 7 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/media/video/videobuf-core.c
> b/drivers/media/video/videobuf-core.c index 63d7043..e573ca7 100644
> --- a/drivers/media/video/videobuf-core.c
> +++ b/drivers/media/video/videobuf-core.c
> @@ -549,6 +549,13 @@ int videobuf_qbuf(struct videobuf_queue *q, struct
> v4l2_buffer *b) "but buffer addr is zero!\n");
>  			goto done;
>  		}
> +		if (q->type == V4L2_BUF_TYPE_VIDEO_OUTPUT
> +		    || q->type == V4L2_BUF_TYPE_VBI_OUTPUT
> +		    || q->type == V4L2_BUF_TYPE_SLICED_VBI_OUTPUT) {
> +			buf->size = b->bytesused;
> +			buf->field = b->field;
> +			buf->ts = b->timestamp;
> +		}
>  		break;
>  	case V4L2_MEMORY_USERPTR:
>  		if (b->length < buf->bsize) {

-- 
Regards,

Laurent Pinchart
