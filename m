Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:40035 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932269Ab3CGOvV (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 7 Mar 2013 09:51:21 -0500
MIME-version: 1.0
Content-transfer-encoding: 8BIT
Content-type: text/plain; charset=UTF-8
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout2.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MJA00FYSP563O90@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 07 Mar 2013 14:51:19 +0000 (GMT)
Received: from [106.116.147.32] by eusync2.samsung.com
 (Oracle Communications Messaging Server 7u4-23.01(7.0.4.23.0) 64bit (built Aug
 10 2011)) with ESMTPA id <0MJA00L5RP9J8P10@eusync2.samsung.com> for
 linux-media@vger.kernel.org; Thu, 07 Mar 2013 14:51:19 +0000 (GMT)
Message-id: <5138A967.8010203@samsung.com>
Date: Thu, 07 Mar 2013 15:51:19 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: Shaik Ameer Basha <shaik.ameer@samsung.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH] [media] fimc-lite: Fix the variable type to avoid possible
 crash
References: <1361447658-20793-1-git-send-email-shaik.ameer@samsung.com>
In-reply-to: <1361447658-20793-1-git-send-email-shaik.ameer@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/21/2013 12:54 PM, Shaik Ameer Basha wrote:
> Changing the variable type to 'int' from 'unsigned int'. Driver
> logic expects the variable type to be 'int'.
> 
> Signed-off-by: Shaik Ameer Basha <shaik.ameer@samsung.com>
> ---
>  drivers/media/platform/s5p-fimc/fimc-lite-reg.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/platform/s5p-fimc/fimc-lite-reg.c b/drivers/media/platform/s5p-fimc/fimc-lite-reg.c
> index f0af075..3c7dd65 100644
> --- a/drivers/media/platform/s5p-fimc/fimc-lite-reg.c
> +++ b/drivers/media/platform/s5p-fimc/fimc-lite-reg.c
> @@ -128,7 +128,7 @@ static const u32 src_pixfmt_map[8][3] = {
>  void flite_hw_set_source_format(struct fimc_lite *dev, struct flite_frame *f)
>  {
>  	enum v4l2_mbus_pixelcode pixelcode = dev->fmt->mbus_code;
> -	unsigned int i = ARRAY_SIZE(src_pixfmt_map);
> +	int i = ARRAY_SIZE(src_pixfmt_map);
>  	u32 cfg;
>  
>  	while (i-- >= 0) {
> @@ -224,7 +224,7 @@ static void flite_hw_set_out_order(struct fimc_lite *dev, struct flite_frame *f)
>  		{ V4L2_MBUS_FMT_VYUY8_2X8, FLITE_REG_CIODMAFMT_CRYCBY },
>  	};
>  	u32 cfg = readl(dev->regs + FLITE_REG_CIODMAFMT);
> -	unsigned int i = ARRAY_SIZE(pixcode);
> +	int i = ARRAY_SIZE(pixcode);
>  
>  	while (i-- >= 0)
>  		if (pixcode[i][0] == dev->fmt->mbus_code)
> 

There was a build warning like:

drivers/media/platform/s5p-fimc/fimc-lite-reg.c: In function ‘flite_hw_set_output_dma’:
drivers/media/platform/s5p-fimc/fimc-lite-reg.c:230: warning: array subscript is below array bounds
drivers/media/platform/s5p-fimc/fimc-lite-reg.c: In function ‘flite_hw_set_source_format’:
drivers/media/platform/s5p-fimc/fimc-lite-reg.c:135: warning: array subscript is below array bounds

thus I squashed following change before applying this patch:

diff --git a/drivers/media/platform/s5p-fimc/fimc-lite-reg.c b/drivers/media/platform/s5p-fimc/fimc-lite-reg.c
index 3c7dd65..ac9663c 100644
--- a/drivers/media/platform/s5p-fimc/fimc-lite-reg.c
+++ b/drivers/media/platform/s5p-fimc/fimc-lite-reg.c
@@ -131,7 +131,7 @@ void flite_hw_set_source_format(struct fimc_lite *dev, struct flite_frame *f)
        int i = ARRAY_SIZE(src_pixfmt_map);
        u32 cfg;
 
-       while (i-- >= 0) {
+       while (--i >= 0) {
                if (src_pixfmt_map[i][0] == pixelcode)
                        break;
        }
@@ -226,7 +226,7 @@ static void flite_hw_set_out_order(struct fimc_lite *dev, struct flite_frame *f)
        u32 cfg = readl(dev->regs + FLITE_REG_CIODMAFMT);
        int i = ARRAY_SIZE(pixcode);
 
-       while (i-- >= 0)
+       while (--i >= 0)
                if (pixcode[i][0] == dev->fmt->mbus_code)
                        break;
        cfg &= ~FLITE_REG_CIODMAFMT_YCBCR_ORDER_MASK;

--

Regards,
Sylwester
