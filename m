Return-path: <mchehab@pedra>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:45864 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753198Ab1DHHBD (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 8 Apr 2011 03:01:03 -0400
Received: from eu_spt1 (mailout1.w1.samsung.com [210.118.77.11])
 by mailout1.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0LJB00IBSNHOV9@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 08 Apr 2011 08:01:00 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LJB00ADENHNVF@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 08 Apr 2011 08:01:00 +0100 (BST)
Date: Fri, 08 Apr 2011 09:00:55 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: RE: [RFCv1 PATCH 5/9] vb2_poll: don't start DMA,
	leave that to the first read().
In-reply-to: <aa6ba599252cedcbb977fa151a5af70860384bf1.1301916466.git.hans.verkuil@cisco.com>
To: 'Hans Verkuil' <hans.verkuil@cisco.com>,
	linux-media@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Message-id: <000601cbf5ba$b499c690$1dcd53b0$%szyprowski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-language: pl
Content-transfer-encoding: 7BIT
References: <1301917914-27437-1-git-send-email-hans.verkuil@cisco.com>
 <aa6ba599252cedcbb977fa151a5af70860384bf1.1301916466.git.hans.verkuil@cisco.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hello,

On Monday, April 04, 2011 1:52 PM Hans Verkuil wrote:

> The vb2_poll function would start read DMA if called without any streaming
> in progress. This unfortunately does not work if the application just wants
> to poll for exceptions. This information of what the application is polling
> for is sadly unavailable in the driver.
> 
> Andy Walls suggested to just return POLLIN | POLLRDNORM and let the first
> call to read start the DMA. This initial read() call will return EAGAIN
> since no actual data is available yet, but it does start the DMA.

The current implementation of vb2_read() will just start streaming on first
call without returning EAGAIN. Do you think this should be changed?

> 
> Application are supposed to handle EAGAIN. MythTV does handle this
> correctly.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>  drivers/media/video/videobuf2-core.c |   16 +++-------------
>  1 files changed, 3 insertions(+), 13 deletions(-)
> 
> diff --git a/drivers/media/video/videobuf2-core.c
> b/drivers/media/video/videobuf2-core.c
> index 6698c77..2dea57a 100644
> --- a/drivers/media/video/videobuf2-core.c
> +++ b/drivers/media/video/videobuf2-core.c
> @@ -1372,20 +1372,10 @@ unsigned int vb2_poll(struct vb2_queue *q, struct
> file *file, poll_table *wait)
>  	 * Start file I/O emulator only if streaming API has not been used
> yet.
>  	 */
>  	if (q->num_buffers == 0 && q->fileio == NULL) {
> -		if (!V4L2_TYPE_IS_OUTPUT(q->type) && (q->io_modes & VB2_READ))
> {
> -			ret = __vb2_init_fileio(q, 1);
> -			if (ret)
> -				return POLLERR;
> -		}
> -		if (V4L2_TYPE_IS_OUTPUT(q->type) && (q->io_modes & VB2_WRITE))
> {
> -			ret = __vb2_init_fileio(q, 0);
> -			if (ret)
> -				return POLLERR;
> -			/*
> -			 * Write to OUTPUT queue can be done immediately.
> -			 */
> +		if (!V4L2_TYPE_IS_OUTPUT(q->type) && (q->io_modes & VB2_READ))
> +			return POLLIN | POLLRDNORM;
> +		if (V4L2_TYPE_IS_OUTPUT(q->type) && (q->io_modes & VB2_WRITE))
>  			return POLLOUT | POLLWRNORM;
> -		}
>  	}
> 
>  	/*
> --

Best regards
-- 
Marek Szyprowski
Samsung Poland R&D Center

