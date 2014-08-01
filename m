Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:49015 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753060AbaHAK5I (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 1 Aug 2014 06:57:08 -0400
Received: from epcpsbgr3.samsung.com
 (u143.gpu120.samsung.co.kr [203.254.230.143])
 by mailout4.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTP id <0N9M00503JR6X370@mailout4.samsung.com> for
 linux-media@vger.kernel.org; Fri, 01 Aug 2014 19:57:06 +0900 (KST)
Message-id: <53DB7282.4070806@samsung.com>
Date: Fri, 01 Aug 2014 19:57:06 +0900
From: Joonyoung Shim <jy0922.shim@samsung.com>
MIME-version: 1.0
To: panpan liu <panpan1.liu@samsung.com>, kyungmin.park@samsung.com,
	k.debski@samsung.com, jtp.park@samsung.com, mchehab@redhat.com
Cc: linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org
Subject: Re: [PATCH] media: s5p_mfc_dec: delete the redundant code
References: <1406884515-3250-1-git-send-email-panpan1.liu@samsung.com>
In-reply-to: <1406884515-3250-1-git-send-email-panpan1.liu@samsung.com>
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 08/01/2014 06:15 PM, panpan liu wrote:
> Because the api s5p_mfc_queue_setup has already realized the same function
> 
> Signed-off-by: panpan liu <panpan1.liu@samsung.com>
> ---
>  drivers/media/platform/s5p-mfc/s5p_mfc_dec.c |    9 +--------
>  1 file changed, 1 insertion(+), 8 deletions(-)
> 
> diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c b/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
> 
> --- a/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
> +++ b/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
> @@ -544,14 +544,7 @@ static int vidioc_reqbufs(struct file *file, void *priv,
>  			mfc_err("vb2_reqbufs on capture failed\n");
>  			return ret;
>  		}
> -		if (reqbufs->count < ctx->pb_count) {
> -			mfc_err("Not enough buffers allocated\n");
> -			reqbufs->count = 0;
> -			s5p_mfc_clock_on();
> -			ret = vb2_reqbufs(&ctx->vq_dst, reqbufs);
> -			s5p_mfc_clock_off();
> -			return -ENOMEM;
> -		}
> +

As Hans said, you should always check the latest upstream kernel. Why do
you post patches based on old kernel at ML continuously?
