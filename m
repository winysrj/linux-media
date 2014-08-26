Return-path: <linux-media-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:39036 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932653AbaHZJJR (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Aug 2014 05:09:17 -0400
Date: Tue, 26 Aug 2014 11:09:13 +0200
From: Jan Kara <jack@suse.cz>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: LMML <linux-media@vger.kernel.org>, Jan Kara <jack@suse.cz>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	m.szyprowski@samsung.com, pawel@osciak.com
Subject: Re: [PATCHv2] videobuf2-core: take mmap_sem before calling
 __qbuf_userptr
Message-ID: <20140826090913.GC1581@quack.suse.cz>
References: <53F7D2D3.4070809@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53F7D2D3.4070809@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri 22-08-14 23:31:31, Hans Verkuil wrote:
> (Changes since v1: fix the embarrassing bug where mmap_sem wasn't initialized)
> 
> Commit f035eb4e976ef5a059e30bc91cfd310ff030a7d3 (videobuf2: fix lockdep warning)
> unfortunately removed the mmap_sem lock that is needed around the call to
> __qbuf_userptr. Amazingly nobody noticed this (especially me as the author)
> until Jan Kara pointed this out to me.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> Reported-by: Jan Kara <jack@suse.cz>
  The patch looks good to me. You can add:
Reviewed-by: Jan Kara <jack@suse.cz>
	
								Honza

> ---
>  drivers/media/v4l2-core/videobuf2-core.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
> index 5b808e2..a0ab6af 100644
> --- a/drivers/media/v4l2-core/videobuf2-core.c
> +++ b/drivers/media/v4l2-core/videobuf2-core.c
> @@ -1591,6 +1591,7 @@ static void __enqueue_in_driver(struct vb2_buffer *vb)
>  static int __buf_prepare(struct vb2_buffer *vb, const struct v4l2_buffer *b)
>  {
>  	struct vb2_queue *q = vb->vb2_queue;
> +	struct rw_semaphore *mmap_sem;
>  	int ret;
>  
>  	ret = __verify_length(vb, b);
> @@ -1627,7 +1628,10 @@ static int __buf_prepare(struct vb2_buffer *vb, const struct v4l2_buffer *b)
>  		ret = __qbuf_mmap(vb, b);
>  		break;
>  	case V4L2_MEMORY_USERPTR:
> +		mmap_sem = &current->mm->mmap_sem;
> +		down_read(mmap_sem);
>  		ret = __qbuf_userptr(vb, b);
> +		up_read(mmap_sem);
>  		break;
>  	case V4L2_MEMORY_DMABUF:
>  		ret = __qbuf_dmabuf(vb, b);
> -- 
> 2.0.1
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
