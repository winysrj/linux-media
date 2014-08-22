Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:47533 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750733AbaHVS5q (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 22 Aug 2014 14:57:46 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: LMML <linux-media@vger.kernel.org>, Jan Kara <jack@suse.cz>,
	m.szyprowski@samsung.com, pawel@osciak.com
Subject: Re: [PATCH] videobuf2-core: take mmap_sem before calling __qbuf_userptr
Date: Fri, 22 Aug 2014 20:58:24 +0200
Message-ID: <4145315.i0HCALftfB@avalon>
In-Reply-To: <53F78565.5000502@xs4all.nl>
References: <53F78565.5000502@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Thank you for the patch.

On Friday 22 August 2014 18:01:09 Hans Verkuil wrote:
> Commit f035eb4e976ef5a059e30bc91cfd310ff030a7d3 (videobuf2: fix lockdep
> warning) unfortunately removed the mmap_sem lock that is needed around the
> call to __qbuf_userptr. Amazingly nobody noticed this until Jan Kara
> pointed this out to me.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> Reported-by: Jan Kara <jack@suse.cz>
> ---
>  drivers/media/v4l2-core/videobuf2-core.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/media/v4l2-core/videobuf2-core.c
> b/drivers/media/v4l2-core/videobuf2-core.c index 5b808e2..2f6ac7e 100644
> --- a/drivers/media/v4l2-core/videobuf2-core.c
> +++ b/drivers/media/v4l2-core/videobuf2-core.c
> @@ -1591,6 +1591,7 @@ static void __enqueue_in_driver(struct vb2_buffer *vb)
> static int __buf_prepare(struct vb2_buffer *vb, const struct v4l2_buffer
> *b) {
>  	struct vb2_queue *q = vb->vb2_queue;
> +	struct rw_semaphore *mmap_sem;

I don't want to to be included in the category of the "amazing reviewers who 
don't notice obvious issues" twice in a row, so I'll point out the obvious 
lack of initialization of the mmap_sem variable :-)

>  	int ret;
> 
>  	ret = __verify_length(vb, b);
> @@ -1627,7 +1628,9 @@ static int __buf_prepare(struct vb2_buffer *vb, const
> struct v4l2_buffer *b) ret = __qbuf_mmap(vb, b);
>  		break;
>  	case V4L2_MEMORY_USERPTR:
> +		down_read(mmap_sem);
>  		ret = __qbuf_userptr(vb, b);
> +		up_read(mmap_sem);
>  		break;
>  	case V4L2_MEMORY_DMABUF:
>  		ret = __qbuf_dmabuf(vb, b);

-- 
Regards,

Laurent Pinchart

