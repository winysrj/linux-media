Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:37767 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753042AbeDJN7Q (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 10 Apr 2018 09:59:16 -0400
Date: Tue, 10 Apr 2018 10:59:10 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [RFCv11 PATCH 23/29] videobuf2-v4l2: export request_fd
Message-ID: <20180410105910.282d74f1@vento.lan>
In-Reply-To: <20180409142026.19369-24-hverkuil@xs4all.nl>
References: <20180409142026.19369-1-hverkuil@xs4all.nl>
        <20180409142026.19369-24-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon,  9 Apr 2018 16:20:20 +0200
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> Requested by Sakari

Huh? What kind of description is that?

Why is it needed?

It is even harder to analyze this as documentation for the new
field is not there.

> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>  drivers/media/common/videobuf2/videobuf2-v4l2.c | 6 ++++--
>  include/media/videobuf2-v4l2.h                  | 2 ++
>  2 files changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/common/videobuf2/videobuf2-v4l2.c b/drivers/media/common/videobuf2/videobuf2-v4l2.c
> index 3d0c74bb4220..7b79149b7fae 100644
> --- a/drivers/media/common/videobuf2/videobuf2-v4l2.c
> +++ b/drivers/media/common/videobuf2/videobuf2-v4l2.c
> @@ -184,6 +184,7 @@ static int vb2_fill_vb2_v4l2_buffer(struct vb2_buffer *vb, struct v4l2_buffer *b
>  		return -EINVAL;
>  	}
>  	vbuf->sequence = 0;
> +	vbuf->request_fd = -1;
>  
>  	if (V4L2_TYPE_IS_MULTIPLANAR(b->type)) {
>  		switch (b->memory) {
> @@ -391,6 +392,7 @@ static int vb2_queue_or_prepare_buf(struct vb2_queue *q, struct media_device *md
>  	}
>  
>  	*p_req = req;
> +	vbuf->request_fd = b->request_fd;
>  
>  	return 0;
>  }
> @@ -496,9 +498,9 @@ static void __fill_v4l2_buffer(struct vb2_buffer *vb, void *pb)
>  
>  	if (vb2_buffer_in_use(q, vb))
>  		b->flags |= V4L2_BUF_FLAG_MAPPED;
> -	if (vb->req_obj.req) {
> +	if (vbuf->request_fd >= 0) {
>  		b->flags |= V4L2_BUF_FLAG_REQUEST_FD;
> -		b->request_fd = -1;
> +		b->request_fd = vbuf->request_fd;
>  	}
>  
>  	if (!q->is_output &&
> diff --git a/include/media/videobuf2-v4l2.h b/include/media/videobuf2-v4l2.h
> index 0baa3023d7ad..d3ee1f28e197 100644
> --- a/include/media/videobuf2-v4l2.h
> +++ b/include/media/videobuf2-v4l2.h
> @@ -32,6 +32,7 @@
>   *		&enum v4l2_field.
>   * @timecode:	frame timecode.
>   * @sequence:	sequence count of this frame.
> + * @request_fd:	the request_fd associated with this buffer
>   * @planes:	plane information (userptr/fd, length, bytesused, data_offset).
>   *
>   * Should contain enough information to be able to cover all the fields
> @@ -44,6 +45,7 @@ struct vb2_v4l2_buffer {
>  	__u32			field;
>  	struct v4l2_timecode	timecode;
>  	__u32			sequence;
> +	__s32			request_fd;
>  	struct vb2_plane	planes[VB2_MAX_PLANES];
>  };
>  



Thanks,
Mauro
