Return-path: <mchehab@pedra>
Received: from mailout4.samsung.com ([203.254.224.34]:43541 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751263Ab1CUIAL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Mar 2011 04:00:11 -0400
Received: from epmmp2 (mailout4.samsung.com [203.254.224.34])
 by mailout4.samsung.com
 (Oracle Communications Messaging Exchange Server 7u4-19.01 64bit (built Sep  7
 2010)) with ESMTP id <0LIE0095SE3LNE30@mailout4.samsung.com> for
 linux-media@vger.kernel.org; Mon, 21 Mar 2011 16:57:21 +0900 (KST)
Received: from AMDC159 ([106.116.37.153])
 by mmp2.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTPA id <0LIE00IOXE3ECM@mmp2.samsung.com> for
 linux-media@vger.kernel.org; Mon, 21 Mar 2011 16:57:21 +0900 (KST)
Date: Mon, 21 Mar 2011 08:57:12 +0100
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: RE: [PATCH 2/2] [media] vb2: Handle return value from start_streaming
 callback
In-reply-to: <1300663876-24712-2-git-send-email-pawel@osciak.com>
To: 'Pawel Osciak' <pawel@osciak.com>, linux-media@vger.kernel.org
Message-id: <000101cbe79d$9827fbb0$c877f310$%szyprowski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-language: pl
Content-transfer-encoding: 7BIT
References: <1300663876-24712-1-git-send-email-pawel@osciak.com>
 <1300663876-24712-2-git-send-email-pawel@osciak.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hello,

On Monday, March 21, 2011 12:31 AM Pawel Osciak wrote:

> Fix vb2 not handling return value from start_streaming() callback.
> 
> Signed-off-by: Pawel Osciak <pawel@osciak.com>

Acked-by: Marek Szyprowski <m.szyprowski@samsung.com>

> ---
>  drivers/media/video/videobuf2-core.c |   11 ++++++++---
>  1 files changed, 8 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/media/video/videobuf2-core.c b/drivers/media/video/videobuf2-core.c
> index 8c6f04b..6698c77 100644
> --- a/drivers/media/video/videobuf2-core.c
> +++ b/drivers/media/video/videobuf2-core.c
> @@ -1111,6 +1111,7 @@ EXPORT_SYMBOL_GPL(vb2_dqbuf);
>  int vb2_streamon(struct vb2_queue *q, enum v4l2_buf_type type)
>  {
>  	struct vb2_buffer *vb;
> +	int ret;
> 
>  	if (q->fileio) {
>  		dprintk(1, "streamon: file io in progress\n");
> @@ -1138,12 +1139,16 @@ int vb2_streamon(struct vb2_queue *q, enum v4l2_buf_type type)
>  		}
>  	}
> 
> -	q->streaming = 1;
> -
>  	/*
>  	 * Let driver notice that streaming state has been enabled.
>  	 */
> -	call_qop(q, start_streaming, q);
> +	ret = call_qop(q, start_streaming, q);
> +	if (ret) {
> +		dprintk(1, "streamon: driver refused to start streaming\n");
> +		return ret;
> +	}
> +
> +	q->streaming = 1;
> 
>  	/*
>  	 * If any buffers were queued before streamon,
> --
> 1.7.4.1

Best regards
--
Marek Szyprowski
Samsung Poland R&D Center


