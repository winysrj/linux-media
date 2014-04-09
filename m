Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:38600 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932908AbaDIRVd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 9 Apr 2014 13:21:33 -0400
Date: Wed, 9 Apr 2014 20:21:28 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, pawel@osciak.com,
	s.nawrocki@samsung.com, m.szyprowski@samsung.com,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [REVIEW PATCH 10/11] vb2: set v4l2_buffer.bytesused to 0 for mp
 buffers
Message-ID: <20140409172128.GA7530@valkosipuli.retiisi.org.uk>
References: <1394486458-9836-1-git-send-email-hverkuil@xs4all.nl>
 <1394486458-9836-11-git-send-email-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1394486458-9836-11-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Thanks for the set.

On Mon, Mar 10, 2014 at 10:20:57PM +0100, Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> The bytesused field of struct v4l2_buffer is not used for multiplanar
> formats, so just zero it to prevent it from having some random value.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>  drivers/media/v4l2-core/videobuf2-core.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
> index f68a60f..54a4150 100644
> --- a/drivers/media/v4l2-core/videobuf2-core.c
> +++ b/drivers/media/v4l2-core/videobuf2-core.c
> @@ -583,6 +583,7 @@ static void __fill_v4l2_buffer(struct vb2_buffer *vb, struct v4l2_buffer *b)
>  		 * for it. The caller has already verified memory and size.
>  		 */
>  		b->length = vb->num_planes;
> +		b->bytesused = 0;

I wonder if I'm missing something, but doesn't the value of the field come
from the v4l2_buf field of the vb2_buffer which is allocated using kzalloc()
in __vb2_queue_alloc(), and never changed afterwards?

>  		memcpy(b->m.planes, vb->v4l2_planes,
>  			b->length * sizeof(struct v4l2_plane));
>  	} else {

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
