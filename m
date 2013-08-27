Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:38621 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753346Ab3H0Iu3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 27 Aug 2013 04:50:29 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: linux-media@vger.kernel.org, m.szyprowski@samsung.com,
	pawel@osciak.com, hans.verkuil@cisco.com, m.chehab@samsung.com,
	Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCH] vb2: Add debug print for the output buffer planes lengths checks
Date: Tue, 27 Aug 2013 10:51:50 +0200
Message-ID: <137763687.WyibnDiBf0@avalon>
In-Reply-To: <1377532073-12864-1-git-send-email-s.nawrocki@samsung.com>
References: <1377532073-12864-1-git-send-email-s.nawrocki@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester,

Thank you for the patch.

On Monday 26 August 2013 17:47:53 Sylwester Nawrocki wrote:
> Add debug print so it's easier to find any errors resulting from
> the planes' configuration checks added in commit 8023ed09cb278004a2
> "videobuf2-core: Verify planes lengths for output buffers".
> 
> Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> ---
>  drivers/media/v4l2-core/videobuf2-core.c |    5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/media/v4l2-core/videobuf2-core.c
> b/drivers/media/v4l2-core/videobuf2-core.c index de0e87f..6bffc96 100644
> --- a/drivers/media/v4l2-core/videobuf2-core.c
> +++ b/drivers/media/v4l2-core/videobuf2-core.c
> @@ -1205,8 +1205,11 @@ static int __buf_prepare(struct vb2_buffer *vb, const
> struct v4l2_buffer *b) int ret;
> 
>  	ret = __verify_length(vb, b);
> -	if (ret < 0)
> +	if (ret < 0) {
> +		dprintk(1, "%s(): plane parameters verification failed: %d\n",
> +			__func__, ret);
>  		return ret;
> +	}
> 
>  	switch (q->memory) {
>  	case V4L2_MEMORY_MMAP:
-- 
Regards,

Laurent Pinchart

