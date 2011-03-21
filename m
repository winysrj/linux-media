Return-path: <mchehab@pedra>
Received: from mailout2.samsung.com ([203.254.224.25]:38946 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750786Ab1CUH44 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Mar 2011 03:56:56 -0400
Received: from epmmp1 (mailout2.samsung.com [203.254.224.25])
 by mailout2.samsung.com
 (Oracle Communications Messaging Exchange Server 7u4-19.01 64bit (built Sep  7
 2010)) with ESMTP id <0LIE00FHTE23MZ30@mailout2.samsung.com> for
 linux-media@vger.kernel.org; Mon, 21 Mar 2011 16:56:27 +0900 (KST)
Received: from AMDC159 ([106.116.37.153])
 by mmp1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTPA id <0LIE00LYLE1T5R@mmp1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 21 Mar 2011 16:56:27 +0900 (KST)
Date: Mon, 21 Mar 2011 08:56:15 +0100
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: RE: [PATCH 1/2] [media] vb2: vb2_poll() fix return values for file I/O
 mode
In-reply-to: <1300663876-24712-1-git-send-email-pawel@osciak.com>
To: 'Pawel Osciak' <pawel@osciak.com>, linux-media@vger.kernel.org
Message-id: <000001cbe79d$76d58ea0$6480abe0$%szyprowski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-language: pl
Content-transfer-encoding: 7BIT
References: <1300663876-24712-1-git-send-email-pawel@osciak.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hello,

On Monday, March 21, 2011 12:31 AM Pawel Osciak wrote:

> poll() should be returning poll-specific error values, not E* errors.
> 
> Signed-off-by: Pawel Osciak <pawel@osciak.com>

Acked-by: Marek Szyprowski <m.szyprowski@samsung.com>

> ---
>  drivers/media/video/videobuf2-core.c |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/media/video/videobuf2-core.c b/drivers/media/video/videobuf2-core.c
> index ce03225..8c6f04b 100644
> --- a/drivers/media/video/videobuf2-core.c
> +++ b/drivers/media/video/videobuf2-core.c
> @@ -1364,18 +1364,18 @@ unsigned int vb2_poll(struct vb2_queue *q, struct file *file, poll_table *wait)
>  	struct vb2_buffer *vb = NULL;
> 
>  	/*
> -	 * Start file io emulator if streaming api has not been used yet.
> +	 * Start file I/O emulator only if streaming API has not been used yet.
>  	 */
>  	if (q->num_buffers == 0 && q->fileio == NULL) {
>  		if (!V4L2_TYPE_IS_OUTPUT(q->type) && (q->io_modes & VB2_READ)) {
>  			ret = __vb2_init_fileio(q, 1);
>  			if (ret)
> -				return ret;
> +				return POLLERR;
>  		}
>  		if (V4L2_TYPE_IS_OUTPUT(q->type) && (q->io_modes & VB2_WRITE)) {
>  			ret = __vb2_init_fileio(q, 0);
>  			if (ret)
> -				return ret;
> +				return POLLERR;
>  			/*
>  			 * Write to OUTPUT queue can be done immediately.
>  			 */
> --
> 1.7.4.1

Best regards
--
Marek Szyprowski
Samsung Poland R&D Center


