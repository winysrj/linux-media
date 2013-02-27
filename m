Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:62492 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756570Ab3B0LcQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Feb 2013 06:32:16 -0500
Received: from eucpsbgm2.samsung.com (unknown [203.254.199.245])
 by mailout4.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MIV00GLVMKQO550@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 27 Feb 2013 11:32:14 +0000 (GMT)
Received: from AMDN910 ([106.116.147.102])
 by eusync4.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTPA id <0MIV0043BMPFGT40@eusync4.samsung.com> for
 linux-media@vger.kernel.org; Wed, 27 Feb 2013 11:32:14 +0000 (GMT)
From: Kamil Debski <k.debski@samsung.com>
To: 'Arun Kumar K' <arun.kk@samsung.com>, linux-media@vger.kernel.org
Cc: jtp.park@samsung.com, Sylwester Nawrocki <s.nawrocki@samsung.com>,
	arun.m@samsung.com
References: <1361916131-1717-1-git-send-email-arun.kk@samsung.com>
In-reply-to: <1361916131-1717-1-git-send-email-arun.kk@samsung.com>
Subject: RE: [PATCH] [media] s5p-mfc: Fix frame skip bug
Date: Wed, 27 Feb 2013 12:32:02 +0100
Message-id: <012201ce14de$11420e40$33c62ac0$%debski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
Content-language: pl
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Arun,

Thank you for your patch.

Best wishes,
-- 
Kamil Debski
Linux Platform Group
Samsung Poland R&D Center


> -----Original Message-----
> From: Arun Kumar K [mailto:arun.kk@samsung.com]
> Sent: Tuesday, February 26, 2013 11:02 PM
> To: linux-media@vger.kernel.org
> Cc: k.debski@samsung.com; jtp.park@samsung.com; s.nawrocki@samsung.com;
> arun.kk@samsung.com; arun.m@samsung.com
> Subject: [PATCH] [media] s5p-mfc: Fix frame skip bug
> 
> The issue was seen in VP8 decoding where the last frame was skipped by
> the driver. This patch gets the correct frame_type value to fix this
> bug.
> 
> Signed-off-by: Arun Kumar K <arun.kk@samsung.com>
> Signed-off-by: Arun Mankuzhi <arun.m@samsung.com>

Acked-by: Kamil Debski <k.debski@samsung.com>

> ---
>  drivers/media/platform/s5p-mfc/s5p_mfc.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc.c
> b/drivers/media/platform/s5p-mfc/s5p_mfc.c
> index ac69e9b..64c55cf 100644
> --- a/drivers/media/platform/s5p-mfc/s5p_mfc.c
> +++ b/drivers/media/platform/s5p-mfc/s5p_mfc.c
> @@ -276,7 +276,7 @@ static void s5p_mfc_handle_frame_new(struct
> s5p_mfc_ctx *ctx, unsigned int err)
>  	unsigned int frame_type;
> 
>  	dspl_y_addr = s5p_mfc_hw_call(dev->mfc_ops, get_dspl_y_adr, dev);
> -	frame_type = s5p_mfc_hw_call(dev->mfc_ops, get_dec_frame_type,
> dev);
> +	frame_type = s5p_mfc_hw_call(dev->mfc_ops, get_disp_frame_type,
> ctx);
> 
>  	/* If frame is same as previous then skip and do not dequeue */
>  	if (frame_type == S5P_FIMV_DECODE_FRAME_SKIPPED) {
> --
> 1.7.9.5


