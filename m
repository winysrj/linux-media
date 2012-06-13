Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:19733 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753971Ab2FMMLU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 13 Jun 2012 08:11:20 -0400
Received: from epcpsbgm1.samsung.com (mailout4.samsung.com [203.254.224.34])
 by mailout4.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0M5K00HXC1UOGD01@mailout4.samsung.com> for
 linux-media@vger.kernel.org; Wed, 13 Jun 2012 21:11:18 +0900 (KST)
Received: from AMDN157 ([106.116.48.215])
 by mmp1.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTPA id <0M5K00KIY1UQZ310@mmp1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 13 Jun 2012 21:11:18 +0900 (KST)
From: Kamil Debski <k.debski@samsung.com>
To: 'Sachin Kamat' <sachin.kamat@linaro.org>,
	linux-media@vger.kernel.org
Cc: kyungmin.park@samsung.com, mchehab@infradead.org,
	patches@linaro.org
References: <1339412322-15524-1-git-send-email-sachin.kamat@linaro.org>
In-reply-to: <1339412322-15524-1-git-send-email-sachin.kamat@linaro.org>
Subject: RE: [PATCH] [media] s5p-mfc: Fix checkpatch error in s5p_mfc_shm.h file
Date: Wed, 13 Jun 2012 14:11:13 +0200
Message-id: <001701cd495d$a3279980$e976cc80$%debski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
Content-language: en-gb
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Thanks for the patch.

Best wishes,
Kamil Debski

> From: Sachin Kamat [mailto:sachin.kamat@linaro.org]
> Sent: 11 June 2012 12:59
> 
> Fixes the following error:
> ERROR: open brace '{' following enum go on the same line
> +enum MFC_SHM_OFS
> +{
> 
> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>

Acked-by: Kamil Debski <k.debski@samsung.com>

> ---
>  drivers/media/video/s5p-mfc/s5p_mfc_shm.h |    3 +--
>  1 files changed, 1 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/video/s5p-mfc/s5p_mfc_shm.h
> b/drivers/media/video/s5p-mfc/s5p_mfc_shm.h
> index 764eac6..cf962a4 100644
> --- a/drivers/media/video/s5p-mfc/s5p_mfc_shm.h
> +++ b/drivers/media/video/s5p-mfc/s5p_mfc_shm.h
> @@ -13,8 +13,7 @@
>  #ifndef S5P_MFC_SHM_H_
>  #define S5P_MFC_SHM_H_
> 
> -enum MFC_SHM_OFS
> -{
> +enum MFC_SHM_OFS {
>  	EXTENEDED_DECODE_STATUS	= 0x00,	/* D */
>  	SET_FRAME_TAG		= 0x04, /* D */
>  	GET_FRAME_TAG_TOP	= 0x08, /* D */
> --
> 1.7.4.1

