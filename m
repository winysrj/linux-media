Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:49766 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751959AbbBXAea (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Feb 2015 19:34:30 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Lad Prabhakar <prabhakar.csengg@gmail.com>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
	LMML <linux-media@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/3] media: omap3isp: ispvideo: drop driver specific isp_video_fh
Date: Tue, 24 Feb 2015 02:35:31 +0200
Message-ID: <7125910.hm5qgSJ3zA@avalon>
In-Reply-To: <1424722773-20131-3-git-send-email-prabhakar.csengg@gmail.com>
References: <1424722773-20131-1-git-send-email-prabhakar.csengg@gmail.com> <1424722773-20131-3-git-send-email-prabhakar.csengg@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Prabhakar,

Thank you for the patch.

On Monday 23 February 2015 20:19:32 Lad Prabhakar wrote:
> From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
> 
> this patch drops driver specific isp_video_fh, as this
> can be handled by core.

I'm afraid it's not that simple.

The omap3isp driver stores video queues per file handle for a reason. This was 
design to permit creating a high-resolution still image capture queue and 
prepare buffers ahead of time, to avoid the large delay due to cache 
management as prepare time when taking the snapshot.

Now this use case has been partially solved by VIDIOC_CREATE_BUFS, but we're 
still missing a VIDIOC_DESTROY_BUFS to make it work completely. That needs to 
be solved first.

> Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
> ---
>  drivers/media/platform/omap3isp/ispvideo.c | 128  ++++++++++---------------
>  drivers/media/platform/omap3isp/ispvideo.h |  13 +--
>  2 files changed, 49 insertions(+), 92 deletions(-)

-- 
Regards,

Laurent Pinchart

