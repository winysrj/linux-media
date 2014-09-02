Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:37782 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754070AbaIBNCq (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 2 Sep 2014 09:02:46 -0400
Received: from eucpsbgm2.samsung.com (unknown [203.254.199.245])
 by mailout4.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0NB900FAUZ1A9H60@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 02 Sep 2014 14:05:34 +0100 (BST)
From: Kamil Debski <k.debski@samsung.com>
To: 'Mauro Carvalho Chehab' <m.chehab@samsung.com>
Cc: 'Linux Media Mailing List' <linux-media@vger.kernel.org>,
	'Mauro Carvalho Chehab' <mchehab@infradead.org>
References: <1409090111-8290-1-git-send-email-m.chehab@samsung.com>
 <1409090111-8290-28-git-send-email-m.chehab@samsung.com>
In-reply-to: <1409090111-8290-28-git-send-email-m.chehab@samsung.com>
Subject: RE: [PATCH v2 27/35] [media] s5p-jpeg: Get rid of a warning
Date: Tue, 02 Sep 2014 15:02:43 +0200
Message-id: <08bb01cfc6ae$3008b580$901a2080$%debski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
Content-language: pl
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

A subsequent patch by Jacek Anaszewski [1] is resoling this problem in
a better way. If you don't mind I will take his patch.

[1] [1/4] s5p-jpeg: Avoid assigning readl result
    https://patchwork.linuxtv.org/patch/25661/

Best wishes,
-- 
Kamil Debski
Samsung R&D Institute Poland


> From: linux-media-owner@vger.kernel.org [mailto:linux-media-
> owner@vger.kernel.org] On Behalf Of Mauro Carvalho Chehab
> Sent: Tuesday, August 26, 2014 11:55 PM
> 
> drivers/media/platform/s5p-jpeg/jpeg-hw-s5p.c: In function
> 's5p_jpeg_clear_int':
> drivers/media/platform/s5p-jpeg/jpeg-hw-s5p.c:327:16: warning: variable
> 'reg' set but not used [-Wunused-but-set-variable]
>   unsigned long reg;
>                 ^
> 
> Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
> ---
>  drivers/media/platform/s5p-jpeg/jpeg-hw-s5p.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/media/platform/s5p-jpeg/jpeg-hw-s5p.c
> b/drivers/media/platform/s5p-jpeg/jpeg-hw-s5p.c
> index 52407d790726..0d37bed088df 100644
> --- a/drivers/media/platform/s5p-jpeg/jpeg-hw-s5p.c
> +++ b/drivers/media/platform/s5p-jpeg/jpeg-hw-s5p.c
> @@ -326,7 +326,7 @@ void s5p_jpeg_clear_int(void __iomem *regs)  {
>  	unsigned long reg;
> 
> -	reg = readl(regs + S5P_JPGINTST);
> +	readl(regs + S5P_JPGINTST);
>  	writel(S5P_INT_RELEASE, regs + S5P_JPGCOM);
>  	reg = readl(regs + S5P_JPGOPR);
>  }
> --
> 1.9.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media"
> in the body of a message to majordomo@vger.kernel.org More majordomo
> info at  http://vger.kernel.org/majordomo-info.html

