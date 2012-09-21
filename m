Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:12122 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755403Ab2IUQNY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 21 Sep 2012 12:13:24 -0400
Received: from eusync3.samsung.com (mailout3.w1.samsung.com [210.118.77.13])
 by mailout3.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MAP009AZJR47Y30@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 21 Sep 2012 17:13:52 +0100 (BST)
Received: from [106.116.147.32] by eusync3.samsung.com
 (Oracle Communications Messaging Server 7u4-23.01(7.0.4.23.0) 64bit (built Aug
 10 2011)) with ESMTPA id <0MAP00KN2JQ9DP10@eusync3.samsung.com> for
 linux-media@vger.kernel.org; Fri, 21 Sep 2012 17:13:21 +0100 (BST)
Message-id: <505C9220.9070007@samsung.com>
Date: Fri, 21 Sep 2012 18:13:20 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, Pawel Osciak <pawel@osciak.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [RFCv1 PATCH 4/6] videobuf2-core: fill in length field for
 multiplanar buffers.
References: <1348065460-1624-1-git-send-email-hverkuil@xs4all.nl>
 <bbbf815b74d00312a07be07ad4f336a3792fd0d3.1348064901.git.hans.verkuil@cisco.com>
In-reply-to: <bbbf815b74d00312a07be07ad4f336a3792fd0d3.1348064901.git.hans.verkuil@cisco.com>
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On 09/19/2012 04:37 PM, Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> length should be set to num_planes in __fill_v4l2_buffer(). That way the
> caller knows how many planes there are in the buffer.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

I think this would break VIDIOC_CREATE_BUFS. We need per buffer num_planes.
Consider a use case where device is streaming with 2-planar pixel format
and we invoke VIDIOC_CREATE_BUFS with single-planar format. On a single 
queue there will be buffers with different number of planes. The number of 
planes information must be attached to a buffer, otherwise VIDIOC_QUERYBUF 
won't work.

> ---
>  drivers/media/v4l2-core/videobuf2-core.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
> index 929cc99..bbfe022 100644
> --- a/drivers/media/v4l2-core/videobuf2-core.c
> +++ b/drivers/media/v4l2-core/videobuf2-core.c
> @@ -348,6 +348,7 @@ static void __fill_v4l2_buffer(struct vb2_buffer *vb, struct v4l2_buffer *b)
>  		 * Fill in plane-related data if userspace provided an array
>  		 * for it. The memory and size is verified above.
>  		 */
> +		b->length = q->num_planes;
>  		memcpy(b->m.planes, vb->v4l2_planes,
>  			b->length * sizeof(struct v4l2_plane));
>  	} else {

Regards,
Sylwester
