Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:49568 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755871Ab2EJI5X (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 10 May 2012 04:57:23 -0400
Received: from epcpsbgm1.samsung.com (mailout3.samsung.com [203.254.224.33])
 by mailout3.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0M3S00HHEU751GQ0@mailout3.samsung.com> for
 linux-media@vger.kernel.org; Thu, 10 May 2012 17:57:22 +0900 (KST)
Received: from AMDN157 ([106.116.48.215])
 by mmp2.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTPA id <0M3S00HDWU7II050@mmp2.samsung.com> for
 linux-media@vger.kernel.org; Thu, 10 May 2012 17:57:22 +0900 (KST)
From: Kamil Debski <k.debski@samsung.com>
To: 'Sachin Kamat' <sachin.kamat@linaro.org>,
	linux-media@vger.kernel.org
Cc: mchehab@infradead.org, kyungmin.park@samsung.com,
	patches@linaro.org
References: <1336631748-25160-1-git-send-email-sachin.kamat@linaro.org>
 <1336631748-25160-2-git-send-email-sachin.kamat@linaro.org>
In-reply-to: <1336631748-25160-2-git-send-email-sachin.kamat@linaro.org>
Subject: RE: [PATCH 2/2] [media] s5p-g2d: Add missing static storage class in
 g2d.c file
Date: Thu, 10 May 2012 10:57:17 +0200
Message-id: <017401cd2e8a$e97f21c0$bc7d6540$%debski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
Content-language: en-gb
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sachin,

Thanks for the patch.

Best regards,
--
Kamil Debski
Linux Platform Group
Samsung Poland R&D Center


> -----Original Message-----
> From: Sachin Kamat [mailto:sachin.kamat@linaro.org]
> Sent: 10 May 2012 08:36
> To: linux-media@vger.kernel.org
> Cc: mchehab@infradead.org; k.debski@samsung.com;
> kyungmin.park@samsung.com; sachin.kamat@linaro.org; patches@linaro.org
> Subject: [PATCH 2/2] [media] s5p-g2d: Add missing static storage class in
> g2d.c file
> 
> Fixes the following sparse warnings:
> drivers/media/video/s5p-g2d/g2d.c:68:18: warning: symbol 'def_frame' was
> not declared. Should it be static?
> drivers/media/video/s5p-g2d/g2d.c:80:16: warning: symbol 'find_fmt' was
> not declared. Should it be static?
> drivers/media/video/s5p-g2d/g2d.c:205:5: warning: symbol
> 'g2d_setup_ctrls' was not declared. Should it be static?
> 
> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>

Acked-by: Kamil Debski <k.debski@samsung.com>

> ---
>  drivers/media/video/s5p-g2d/g2d.c |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/media/video/s5p-g2d/g2d.c b/drivers/media/video/s5p-
> g2d/g2d.c
> index 70bee1c..115b936 100644
> --- a/drivers/media/video/s5p-g2d/g2d.c
> +++ b/drivers/media/video/s5p-g2d/g2d.c
> @@ -65,7 +65,7 @@ static struct g2d_fmt formats[] = {
>  };
>  #define NUM_FORMATS ARRAY_SIZE(formats)
> 
> -struct g2d_frame def_frame = {
> +static struct g2d_frame def_frame = {
>  	.width		= DEFAULT_WIDTH,
>  	.height		= DEFAULT_HEIGHT,
>  	.c_width	= DEFAULT_WIDTH,
> @@ -77,7 +77,7 @@ struct g2d_frame def_frame = {
>  	.bottom		= DEFAULT_HEIGHT,
>  };
> 
> -struct g2d_fmt *find_fmt(struct v4l2_format *f)
> +static struct g2d_fmt *find_fmt(struct v4l2_format *f)
>  {
>  	unsigned int i;
>  	for (i = 0; i < NUM_FORMATS; i++) {
> @@ -202,7 +202,7 @@ static const struct v4l2_ctrl_ops g2d_ctrl_ops = {
>  	.s_ctrl		= g2d_s_ctrl,
>  };
> 
> -int g2d_setup_ctrls(struct g2d_ctx *ctx)
> +static int g2d_setup_ctrls(struct g2d_ctx *ctx)
>  {
>  	struct g2d_dev *dev = ctx->dev;
> 
> --
> 1.7.4.1

