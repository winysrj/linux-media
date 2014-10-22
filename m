Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:37041 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933113AbaJVLq0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 22 Oct 2014 07:46:26 -0400
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout3.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0NDU00IRUGU364A0@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 22 Oct 2014 12:49:15 +0100 (BST)
From: Kamil Debski <k.debski@samsung.com>
To: 'ayaka' <ayaka@soulik.info>, linux-media@vger.kernel.org
Cc: kyungmin.park@samsung.com, jtp.park@samsung.com,
	m.chehab@samsung.com
References: <1406132104-6430-1-git-send-email-ayaka@soulik.info>
 <1406132104-6430-2-git-send-email-ayaka@soulik.info>
In-reply-to: <1406132104-6430-2-git-send-email-ayaka@soulik.info>
Subject: RE: [PATCH] s5p-mfc: correct the formats info for encoder
Date: Wed, 22 Oct 2014 13:46:22 +0200
Message-id: <0c7e01cfeded$cdd8c000$698a4000$%debski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
Content-language: pl
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Ayaka,

Could you resend this patch with your sign-off?

Best wishes,
-- 
Kamil Debski
Samsung R&D Institute Poland


> -----Original Message-----
> From: ayaka [mailto:ayaka@soulik.info]
> Sent: Wednesday, July 23, 2014 6:15 PM
> To: linux-media@vger.kernel.org
> Cc: kyungmin.park@samsung.com; k.debski@samsung.com;
> jtp.park@samsung.com; m.chehab@samsung.com; ayaka
> Subject: [PATCH] s5p-mfc: correct the formats info for encoder
> 
> The NV12M is supported by all the version of MFC, so it is better to
> use it as default OUTPUT format.
> MFC v5 doesn't support NV21, I have tested it, for the SEC doc it is
> not supported either.
> ---
>  drivers/media/platform/s5p-mfc/s5p_mfc_enc.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
> b/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
> index d26b248..4ea3796 100644
> --- a/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
> +++ b/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
> @@ -32,7 +32,7 @@
>  #include "s5p_mfc_intr.h"
>  #include "s5p_mfc_opr.h"
> 
> -#define DEF_SRC_FMT_ENC	V4L2_PIX_FMT_NV12MT
> +#define DEF_SRC_FMT_ENC	V4L2_PIX_FMT_NV12M
>  #define DEF_DST_FMT_ENC	V4L2_PIX_FMT_H264
> 
>  static struct s5p_mfc_fmt formats[] = { @@ -67,8 +67,7 @@ static
> struct s5p_mfc_fmt formats[] = {
>  		.codec_mode	= S5P_MFC_CODEC_NONE,
>  		.type		= MFC_FMT_RAW,
>  		.num_planes	= 2,
> -		.versions	= MFC_V5_BIT | MFC_V6_BIT | MFC_V7_BIT |
> -								MFC_V8_BIT,
> +		.versions	= MFC_V6_BIT | MFC_V7_BIT | MFC_V8_BIT,
>  	},
>  	{
>  		.name		= "H264 Encoded Stream",
> --
> 1.9.3

