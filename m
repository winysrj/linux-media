Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:57579 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755861Ab2K0Qcj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 27 Nov 2012 11:32:39 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org, hverkuil@xs4all.nl
Subject: Re: [yavta PATCH 2/2] Print v4l2_buffer timestamp type
Date: Tue, 27 Nov 2012 17:33:43 +0100
Message-ID: <1389859.pZ9IpEcYuE@avalon>
In-Reply-To: <1353017384-472-2-git-send-email-sakari.ailus@iki.fi>
References: <20121115220932.GC29863@valkosipuli.retiisi.org.uk> <1353017384-472-2-git-send-email-sakari.ailus@iki.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

Thanks for the patch.

On Friday 16 November 2012 00:09:44 Sakari Ailus wrote:
> Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
> ---
>  yavta.c |   12 +++++++++++-
>  1 files changed, 11 insertions(+), 1 deletions(-)
> 
> diff --git a/yavta.c b/yavta.c
> index bf3e096..a50f11e 100644
> --- a/yavta.c
> +++ b/yavta.c
> @@ -464,6 +464,7 @@ static int video_alloc_buffers(struct device *dev, int
> nbufs,
> 
>  	/* Map the buffers. */
>  	for (i = 0; i < rb.count; ++i) {
> +		const char *ts_type = "invalid";

Any reason for not moving this to a default case ? That shouldn't be the most 
common case, it will nearly always get overwritten so that's hardly an 
optimization :-)

>  		memset(&buf, 0, sizeof buf);
>  		buf.index = i;
>  		buf.type = dev->type;
> @@ -474,7 +475,16 @@ static int video_alloc_buffers(struct device *dev, int
> nbufs, strerror(errno), errno);
>  			return ret;
>  		}
> -		printf("length: %u offset: %u\n", buf.length, buf.m.offset);
> +		switch (buf.flags & V4L2_BUF_FLAG_TIMESTAMP_MASK) {
> +		case V4L2_BUF_FLAG_TIMESTAMP_UNKNOWN:
> +			ts_type = "unknown";
> +			break;
> +		case V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC:
> +			ts_type = "monotonic";
> +			break;
> +		}
> +		printf("length: %u offset: %u timestamp type: %s\n",
> +		       buf.length, buf.m.offset, ts_type);
> 
>  		switch (dev->memtype) {
>  		case V4L2_MEMORY_MMAP:
-- 
Regards,

Laurent Pinchart

