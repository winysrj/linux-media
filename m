Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:38615 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753346Ab3H0IuG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 27 Aug 2013 04:50:06 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: linux-media@vger.kernel.org, m.szyprowski@samsung.com,
	pawel@osciak.com, hans.verkuil@cisco.com, m.chehab@samsung.com,
	Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCH] vb2: Allow queuing OUTPUT buffers with zeroed 'bytesused'
Date: Tue, 27 Aug 2013 10:51:27 +0200
Message-ID: <1466749.1neyrKf797@avalon>
In-Reply-To: <1377532029-12777-1-git-send-email-s.nawrocki@samsung.com>
References: <1377532029-12777-1-git-send-email-s.nawrocki@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester,

Thank you for the patch.

On Monday 26 August 2013 17:47:09 Sylwester Nawrocki wrote:
> Modify the bytesused/data_offset check to not fail if both bytesused
> and data_offset is set to 0. This should minimize possible issues in
> existing applications which worked before we enforced the plane lengths
> for output buffers checks introduced in commit 8023ed09cb278004a2
> "videobuf2-core: Verify planes lengths for output buffers"
> 
> Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> ---
>  drivers/media/v4l2-core/videobuf2-core.c |    4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/media/v4l2-core/videobuf2-core.c
> b/drivers/media/v4l2-core/videobuf2-core.c index 594c75e..de0e87f 100644
> --- a/drivers/media/v4l2-core/videobuf2-core.c
> +++ b/drivers/media/v4l2-core/videobuf2-core.c
> @@ -353,7 +353,9 @@ static int __verify_length(struct vb2_buffer *vb, const
> struct v4l2_buffer *b)
> 
>  			if (b->m.planes[plane].bytesused > length)
>  				return -EINVAL;
> -			if (b->m.planes[plane].data_offset >=
> +
> +			if (b->m.planes[plane].data_offset > 0 &&
> +			    b->m.planes[plane].data_offset >=
>  			    b->m.planes[plane].bytesused)
>  				return -EINVAL;
>  		}
-- 
Regards,

Laurent Pinchart

