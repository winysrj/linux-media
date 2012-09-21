Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr8.xs4all.nl ([194.109.24.28]:2141 "EHLO
	smtp-vbr8.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751138Ab2IUJzl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 21 Sep 2012 05:55:41 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: Re: [RFCv1 PATCH 4/6] videobuf2-core: fill in length field for multiplanar buffers.
Date: Fri, 21 Sep 2012 11:54:56 +0200
Cc: Pawel Osciak <pawel@osciak.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
References: <1348065460-1624-1-git-send-email-hverkuil@xs4all.nl> <bbbf815b74d00312a07be07ad4f336a3792fd0d3.1348064901.git.hans.verkuil@cisco.com>
In-Reply-To: <bbbf815b74d00312a07be07ad4f336a3792fd0d3.1348064901.git.hans.verkuil@cisco.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201209211154.56770.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed September 19 2012 16:37:38 Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> length should be set to num_planes in __fill_v4l2_buffer(). That way the
> caller knows how many planes there are in the buffer.

Can someone review this? I'd like to know whether it will cause problems
for existing applications to set the length back to the actual number of
planes, and whether it makes sense at all to do so. I believe it does, but
I don't know if anyone is using the current behavior.

Note that the documentation currently doesn't specify what will happen with
length.

Since the only drivers implementing multiplanar support are Samsung drivers,
I assume that Samsung will know best whether this change might cause problems.

Regards,

	Hans

> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
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
> 
