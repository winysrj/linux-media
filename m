Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:57257 "EHLO
        mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751059AbdBJHSn (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 10 Feb 2017 02:18:43 -0500
Subject: Re: [PATCH] media: fix s5p_mfc_set_dec_frame_buffer_v6() to print buf
 size in hex
To: Shuah Khan <shuahkh@osg.samsung.com>, kyungmin.park@samsung.com,
        kamil@wypas.org, jtp.park@samsung.com, mchehab@kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
From: Andrzej Hajda <a.hajda@samsung.com>
Message-id: <80f7c198-0fd0-2101-de3d-998634ffcd92@samsung.com>
Date: Fri, 10 Feb 2017 08:18:07 +0100
MIME-version: 1.0
In-reply-to: <20170209221051.26234-1-shuahkh@osg.samsung.com>
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 7bit
References: <CGME20170209221100epcas1p31efbe8cd7f29d67e830616af02865521@epcas1p3.samsung.com>
 <20170209221051.26234-1-shuahkh@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09.02.2017 23:10, Shuah Khan wrote:
> Fix s5p_mfc_set_dec_frame_buffer_v6() to print buffer size in hex to be
> consistent with the rest of the messages in the routine.
>
> Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>

As Nicolas said please fix the subject.

After this you can add my:
Acked-by: Andrzej Hajda <a.hajda@samsung.com>

--
Regards
Andrzej

> ---
>  drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c b/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c
> index d6f207e..fc45980 100644
> --- a/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c
> +++ b/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c
> @@ -497,7 +497,7 @@ static int s5p_mfc_set_dec_frame_buffer_v6(struct s5p_mfc_ctx *ctx)
>  		}
>  	}
>  
> -	mfc_debug(2, "Buf1: %zu, buf_size1: %d (frames %d)\n",
> +	mfc_debug(2, "Buf1: %zx, buf_size1: %d (frames %d)\n",
>  			buf_addr1, buf_size1, ctx->total_dpb_count);
>  	if (buf_size1 < 0) {
>  		mfc_debug(2, "Not enough memory has been allocated.\n");


