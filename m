Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:40986 "EHLO
	lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752227AbbIKP60 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Sep 2015 11:58:26 -0400
Message-ID: <55F2F9DA.2080709@xs4all.nl>
Date: Fri, 11 Sep 2015 17:57:14 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Sakari Ailus <sakari.ailus@linux.intel.com>,
	linux-media@vger.kernel.org
CC: pawel@osciak.com, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, sumit.semwal@linaro.org,
	robdclark@gmail.com, daniel.vetter@ffwll.ch, labbott@redhat.com
Subject: Re: [RFC RESEND 01/11] vb2: Rename confusingly named internal buffer
 preparation functions
References: <1441972234-8643-1-git-send-email-sakari.ailus@linux.intel.com> <1441972234-8643-2-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1441972234-8643-2-git-send-email-sakari.ailus@linux.intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/11/2015 01:50 PM, Sakari Ailus wrote:
> Rename __qbuf_*() functions which are specific to a buffer type as
> __prepare_*() which matches with what they do. The naming was there for
> historical reasons; the purpose of the functions was changed without
> renaming them.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Good one!

	Hans

> ---
>  drivers/media/v4l2-core/videobuf2-core.c | 19 ++++++++++---------
>  1 file changed, 10 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
> index b866a6b..af6a23a 100644
> --- a/drivers/media/v4l2-core/videobuf2-core.c
> +++ b/drivers/media/v4l2-core/videobuf2-core.c
> @@ -1391,18 +1391,19 @@ static void __fill_vb2_buffer(struct vb2_buffer *vb, const struct v4l2_buffer *b
>  }
>  
>  /**
> - * __qbuf_mmap() - handle qbuf of an MMAP buffer
> + * __prepare_mmap() - prepare an MMAP buffer
>   */
> -static int __qbuf_mmap(struct vb2_buffer *vb, const struct v4l2_buffer *b)
> +static int __prepare_mmap(struct vb2_buffer *vb, const struct v4l2_buffer *b)
>  {
>  	__fill_vb2_buffer(vb, b, vb->v4l2_planes);
>  	return call_vb_qop(vb, buf_prepare, vb);
>  }
>  
>  /**
> - * __qbuf_userptr() - handle qbuf of a USERPTR buffer
> + * __prepare_userptr() - prepare a USERPTR buffer
>   */
> -static int __qbuf_userptr(struct vb2_buffer *vb, const struct v4l2_buffer *b)
> +static int __prepare_userptr(struct vb2_buffer *vb,
> +			     const struct v4l2_buffer *b)
>  {
>  	struct v4l2_plane planes[VIDEO_MAX_PLANES];
>  	struct vb2_queue *q = vb->vb2_queue;
> @@ -1504,9 +1505,9 @@ err:
>  }
>  
>  /**
> - * __qbuf_dmabuf() - handle qbuf of a DMABUF buffer
> + * __prepare_dmabuf() - prepare a DMABUF buffer
>   */
> -static int __qbuf_dmabuf(struct vb2_buffer *vb, const struct v4l2_buffer *b)
> +static int __prepare_dmabuf(struct vb2_buffer *vb, const struct v4l2_buffer *b)
>  {
>  	struct v4l2_plane planes[VIDEO_MAX_PLANES];
>  	struct vb2_queue *q = vb->vb2_queue;
> @@ -1678,15 +1679,15 @@ static int __buf_prepare(struct vb2_buffer *vb, const struct v4l2_buffer *b)
>  
>  	switch (q->memory) {
>  	case V4L2_MEMORY_MMAP:
> -		ret = __qbuf_mmap(vb, b);
> +		ret = __prepare_mmap(vb, b);
>  		break;
>  	case V4L2_MEMORY_USERPTR:
>  		down_read(&current->mm->mmap_sem);
> -		ret = __qbuf_userptr(vb, b);
> +		ret = __prepare_userptr(vb, b);
>  		up_read(&current->mm->mmap_sem);
>  		break;
>  	case V4L2_MEMORY_DMABUF:
> -		ret = __qbuf_dmabuf(vb, b);
> +		ret = __prepare_dmabuf(vb, b);
>  		break;
>  	default:
>  		WARN(1, "Invalid queue type\n");
> 

