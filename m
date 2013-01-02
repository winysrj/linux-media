Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:34921 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752709Ab3ABQcx (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 2 Jan 2013 11:32:53 -0500
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout1.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MG00060PBA6BJ30@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 02 Jan 2013 16:32:51 +0000 (GMT)
Received: from AMDN910 ([106.116.147.102])
 by eusync3.samsung.com (Oracle Communications Messaging Server 7u4-23.01
 (7.0.4.23.0) 64bit (built Aug 10 2011))
 with ESMTPA id <0MG000MCZB9LL470@eusync3.samsung.com> for
 linux-media@vger.kernel.org; Wed, 02 Jan 2013 16:32:51 +0000 (GMT)
From: Kamil Debski <k.debski@samsung.com>
To: 'Sachin Kamat' <sachin.kamat@linaro.org>,
	linux-media@vger.kernel.org
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>,
	sylvester.nawrocki@gmail.com, patches@linaro.org
References: <1357123549-14264-1-git-send-email-sachin.kamat@linaro.org>
In-reply-to: <1357123549-14264-1-git-send-email-sachin.kamat@linaro.org>
Subject: RE: [PATCH Resend] [media] s5p-mfc: Fix an error check
Date: Wed, 02 Jan 2013 17:31:51 +0100
Message-id: <006c01cde906$b63d2af0$22b780d0$%debski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
Content-language: pl
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sachin,

Thank you for finding and correcting this.

Best wishes,
-- 
Kamil Debski
Linux Platform Group
Samsung Poland R&D Center


> -----Original Message-----
> From: Sachin Kamat [mailto:sachin.kamat@linaro.org]
> Sent: Wednesday, January 02, 2013 11:46 AM
> To: linux-media@vger.kernel.org
> Cc: k.debski@samsung.com; s.nawrocki@samsung.com;
> sylvester.nawrocki@gmail.com; sachin.kamat@linaro.org;
> patches@linaro.org
> Subject: [PATCH Resend] [media] s5p-mfc: Fix an error check
> 
> Checking unsigned variable for negative value always returns false.
> Hence make this value signed as we expect it to be negative too.
> 
> Fixes the following smatch warning:
> drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:572
> s5p_mfc_set_enc_ref_buffer_v6() warn: unsigned 'buf_size1' is never
> less than zero.
> 
> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>

Acked-by: Kamil Debski <k.debski@samsung.com>

> ---
> Added additional description in commit message.
> Please ignore the previous patch.
> ---
>  drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c
> b/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c
> index 5f9a5e0..91d5087 100644
> --- a/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c
> +++ b/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c
> @@ -535,8 +535,8 @@ void s5p_mfc_get_enc_frame_buffer_v6(struct
> s5p_mfc_ctx *ctx,  int s5p_mfc_set_enc_ref_buffer_v6(struct s5p_mfc_ctx
> *ctx)  {
>  	struct s5p_mfc_dev *dev = ctx->dev;
> -	size_t buf_addr1, buf_size1;
> -	int i;
> +	size_t buf_addr1;
> +	int i, buf_size1;
> 
>  	mfc_debug_enter();
> 
> --
> 1.7.4.1


