Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:42300 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751876Ab2KTRXF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 20 Nov 2012 12:23:05 -0500
Received: from eusync2.samsung.com (mailout4.w1.samsung.com [210.118.77.14])
 by mailout4.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MDS002GCQZ9GYA0@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 20 Nov 2012 17:23:33 +0000 (GMT)
Received: from AMDN910 ([106.116.147.102])
 by eusync2.samsung.com (Oracle Communications Messaging Server 7u4-23.01
 (7.0.4.23.0) 64bit (built Aug 10 2011))
 with ESMTPA id <0MDS001TZQY92B30@eusync2.samsung.com> for
 linux-media@vger.kernel.org; Tue, 20 Nov 2012 17:23:02 +0000 (GMT)
From: Kamil Debski <k.debski@samsung.com>
To: 'Arun Kumar K' <arun.kk@samsung.com>, linux-media@vger.kernel.org
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>, jtp.park@samsung.com,
	sunilm@samsung.com, joshi@samsung.com
References: <1352106843-1765-1-git-send-email-arun.kk@samsung.com>
In-reply-to: <1352106843-1765-1-git-send-email-arun.kk@samsung.com>
Subject: RE: [PATCH] [media] s5p-mfc: Bug fix of timestamp/timecode copy
 mechanism
Date: Tue, 20 Nov 2012 18:22:56 +0100
Message-id: <006701cdc743$af0132c0$0d039840$%debski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
Content-language: pl
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> From: Arun Kumar K [mailto:arun.kk@samsung.com]
> Sent: Monday, November 05, 2012 10:14 AM
> Subject: [PATCH] [media] s5p-mfc: Bug fix of timestamp/timecode copy
> mechanism
> 
> Modified the function s5p_mfc_get_dec_y_adr_v6 to access the decode Y
> address register instead of display Y address.
> 
> Signed-off-by: Sunil Mazhavanchery <sunilm@samsung.com>
> Signed-off-by: Arun Kumar K <arun.kk@samsung.com>

Acked-by: Kamil Debski <k.debski@samsung.com>

> ---
>  drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c
> b/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c
> index 50b5bee..3a8cfd9 100644
> --- a/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c
> +++ b/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c
> @@ -1762,7 +1762,7 @@ int s5p_mfc_get_dspl_y_adr_v6(struct s5p_mfc_dev
> *dev)
> 
>  int s5p_mfc_get_dec_y_adr_v6(struct s5p_mfc_dev *dev)  {
> -	return mfc_read(dev, S5P_FIMV_D_DISPLAY_LUMA_ADDR_V6);
> +	return mfc_read(dev, S5P_FIMV_D_DECODED_LUMA_ADDR_V6);
>  }
> 
>  int s5p_mfc_get_dspl_status_v6(struct s5p_mfc_dev *dev)
> --
> 1.7.0.4


