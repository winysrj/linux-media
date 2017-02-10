Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtprelay0190.hostedemail.com ([216.40.44.190]:60020 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1750910AbdBJS7U (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 10 Feb 2017 13:59:20 -0500
Message-ID: <1486753155.2192.13.camel@perches.com>
Subject: Re: [PATCH v2] media: s5p_mfc print buf pointer in hex constistently
From: Joe Perches <joe@perches.com>
To: Shuah Khan <shuahkh@osg.samsung.com>, kyungmin.park@samsung.com,
        kamil@wypas.org, jtp.park@samsung.com, a.hajda@samsung.com,
        nicolas@ndufresne.ca, mchehab@kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Fri, 10 Feb 2017 10:59:15 -0800
In-Reply-To: <20170210154053.23735-1-shuahkh@osg.samsung.com>
References: <20170210154053.23735-1-shuahkh@osg.samsung.com>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 2017-02-10 at 08:40 -0700, Shuah Khan wrote:
> Fix s5p_mfc_set_dec_frame_buffer_v6() to print buffer pointer in hex to be
> consistent with the rest of the messages in the routine.

More curiously, why is buf_addr a size_t and not
a dma_addr_t?

> Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
> ---
> 
> Fixed commit log. No code changes. Thanks for the catch.
> 
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
