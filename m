Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:47655 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754346AbbAHMvB (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 8 Jan 2015 07:51:01 -0500
Received: from eucpsbgm2.samsung.com (unknown [203.254.199.245])
 by mailout3.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0NHU00CJRZVR14A0@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 08 Jan 2015 12:55:03 +0000 (GMT)
From: Kamil Debski <k.debski@samsung.com>
To: 'Nicolas Dufresne' <nicolas.dufresne@collabora.com>,
	linux-media@vger.kernel.org
Cc: 'Arun Kumar K' <arun.kk@samsung.com>
References: <1418677859-31440-1-git-send-email-nicolas.dufresne@collabora.com>
 <1418677859-31440-3-git-send-email-nicolas.dufresne@collabora.com>
In-reply-to: <1418677859-31440-3-git-send-email-nicolas.dufresne@collabora.com>
Subject: RE: [PATCH 2/3] s5p-mfc-dec: Don't use encoder stop command
Date: Thu, 08 Jan 2015 13:50:58 +0100
Message-id: <009901d02b41$c0343560$409ca020$%debski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
Content-language: pl
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> -----Original Message-----
> From: Nicolas Dufresne [mailto:nicolas.dufresne@collabora.com]
> Sent: Monday, December 15, 2014 10:11 PM
> To: linux-media@vger.kernel.org
> Cc: Kamil Debski; Arun Kumar K; Nicolas Dufresne
> Subject: [PATCH 2/3] s5p-mfc-dec: Don't use encoder stop command
> 
> The decoder should handle V4L2_DEC_CMD_STOP to trigger drain, but it
> currently expecting V4L2_ENC_CMD_STOP.
> 
> Signed-off-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>

Acked-by: Kamil Debski <k.debski@samsung.com>

> ---
>  drivers/media/platform/s5p-mfc/s5p_mfc_dec.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
> b/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
> index 99e2e84..98304fc 100644
> --- a/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
> +++ b/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
> @@ -816,7 +816,7 @@ static int vidioc_decoder_cmd(struct file *file,
> void *priv,
>  	unsigned long flags;
> 
>  	switch (cmd->cmd) {
> -	case V4L2_ENC_CMD_STOP:
> +	case V4L2_DEC_CMD_STOP:
>  		if (cmd->flags != 0)
>  			return -EINVAL;
> 
> --
> 2.1.0

