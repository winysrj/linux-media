Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:47153 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750804AbaLOQbC (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Dec 2014 11:31:02 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH 1/1] yavta: Set plane size for mplane buffers in qbuf
Date: Mon, 15 Dec 2014 18:31:01 +0200
Message-ID: <9786074.WfrgYWU2fm@avalon>
In-Reply-To: <1418657264-20388-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1418657264-20388-1-git-send-email-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

Thank you for the patch.

On Monday 15 December 2014 17:27:44 Sakari Ailus wrote:
> The plane size was left zero for mplane buffers when queueing a buffer. Fix
> this.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> ---
>  yavta.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/yavta.c b/yavta.c
> index 7f9e814..77e5a41 100644
> --- a/yavta.c
> +++ b/yavta.c
> @@ -979,8 +979,12 @@ static int video_queue_buffer(struct device *dev, int
> index, enum buffer_fill_mo
> 
>  	if (dev->memtype == V4L2_MEMORY_USERPTR) {
>  		if (video_is_mplane(dev)) {
> -			for (i = 0; i < dev->num_planes; i++)
> -				buf.m.planes[i].m.userptr = (unsigned long)dev->
> buffers[index].mem[i];
> +			for (i = 0; i < dev->num_planes; i++) {
> +				buf.m.planes[i].m.userptr = (unsigned long)
> +					dev->buffers[index].mem[i];
> +				buf.m.planes[i].length =
> +					dev->buffers[index].size[i];

According to the V4L2 API, this field is set by the driver. That's not in line 
with the videobuf2 implementation, which requires the length field to be set 
for USERPTR and DMABUF. Would you like to submit a documentation patch ?

> +			}
>  		} else {
>  			buf.m.userptr = (unsigned long)dev->buffers[index].mem[0];

For consistency, what would you think about moving the buf.length assignment 
from the else statement right before this hunk to here ? If you're fine with 
that there's no need to resubmit, I'll apply the modification locally.

>  		}

-- 
Regards,

Laurent Pinchart

