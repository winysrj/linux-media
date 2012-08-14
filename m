Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:10633 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753059Ab2HNKhO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Aug 2012 06:37:14 -0400
Received: from eusync2.samsung.com (mailout3.w1.samsung.com [210.118.77.13])
 by mailout3.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0M8Q00IW4QUYQA70@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 14 Aug 2012 11:37:46 +0100 (BST)
Received: from AMDN157 ([106.116.147.102])
 by eusync2.samsung.com (Oracle Communications Messaging Server 7u4-23.01
 (7.0.4.23.0) 64bit (built Aug 10 2011))
 with ESMTPA id <0M8Q00MVDQU06M50@eusync2.samsung.com> for
 linux-media@vger.kernel.org; Tue, 14 Aug 2012 11:37:12 +0100 (BST)
From: Kamil Debski <k.debski@samsung.com>
To: Andrzej Hajda <a.hajda@samsung.com>, linux-media@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
	'Kyungmin Park' <kyungmin.park@samsung.com>
References: <1344936573-8164-1-git-send-email-a.hajda@samsung.com>
In-reply-to: <1344936573-8164-1-git-send-email-a.hajda@samsung.com>
Subject: RE: [PATCH] v4l/s5p-mfc: added DMABUF support for encoder
Date: Tue, 14 Aug 2012 12:37:12 +0200
Message-id: <00b501cd7a08$c3b5efe0$4b21cfa0$%debski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
Content-language: en-gb
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Andrzej,

Thank you for your patch.

Best wishes,
--
Kamil Debski
Linux Platform Group
Samsung Poland R&D Center


> From: Andrzej Hajda [mailto:a.hajda@samsung.com]
> Sent: 14 August 2012 11:30
> 
> Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>

Acked-by: Kamil Debski <k.debski@samsung.com>

> ---
> Patch cleanly applies after patch
> http://patchwork.linuxtv.org/patch/13797/
> ---
>  drivers/media/video/s5p-mfc/s5p_mfc.c     |    4 ++--
>  drivers/media/video/s5p-mfc/s5p_mfc_enc.c |    3 ++-
>  2 files changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/media/video/s5p-mfc/s5p_mfc.c
b/drivers/media/video/s5p-
> mfc/s5p_mfc.c
> index e5c2b80..ab7b74c 100644
> --- a/drivers/media/video/s5p-mfc/s5p_mfc.c
> +++ b/drivers/media/video/s5p-mfc/s5p_mfc.c
> @@ -801,7 +801,7 @@ static int s5p_mfc_open(struct file *file)
>  		q->io_modes = VB2_MMAP;
>  		q->ops = get_dec_queue_ops();
>  	} else if (s5p_mfc_get_node_type(file) == MFCNODE_ENCODER) {
> -		q->io_modes = VB2_MMAP | VB2_USERPTR;
> +		q->io_modes = VB2_MMAP | VB2_USERPTR | VB2_DMABUF;
>  		q->ops = get_enc_queue_ops();
>  	} else {
>  		ret = -ENOENT;
> @@ -822,7 +822,7 @@ static int s5p_mfc_open(struct file *file)
>  		q->io_modes = VB2_MMAP;
>  		q->ops = get_dec_queue_ops();
>  	} else if (s5p_mfc_get_node_type(file) == MFCNODE_ENCODER) {
> -		q->io_modes = VB2_MMAP | VB2_USERPTR;
> +		q->io_modes = VB2_MMAP | VB2_USERPTR | VB2_DMABUF;
>  		q->ops = get_enc_queue_ops();
>  	} else {
>  		ret = -ENOENT;
> diff --git a/drivers/media/video/s5p-mfc/s5p_mfc_enc.c
> b/drivers/media/video/s5p-mfc/s5p_mfc_enc.c
> index 53c305d..b1a5f85 100644
> --- a/drivers/media/video/s5p-mfc/s5p_mfc_enc.c
> +++ b/drivers/media/video/s5p-mfc/s5p_mfc_enc.c
> @@ -1028,7 +1028,8 @@ static int vidioc_reqbufs(struct file *file, void
*priv,
> 
>  	/* if memory is not mmp or userptr return error */
>  	if ((reqbufs->memory != V4L2_MEMORY_MMAP) &&
> -		(reqbufs->memory != V4L2_MEMORY_USERPTR))
> +		(reqbufs->memory != V4L2_MEMORY_USERPTR) &&
> +		(reqbufs->memory != V4L2_MEMORY_DMABUF))
>  		return -EINVAL;
>  	if (reqbufs->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE) {
>  		if (ctx->capture_state != QUEUE_FREE) {
> --
> 1.7.0.4

