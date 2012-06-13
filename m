Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:20600 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753968Ab2FMMPU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 13 Jun 2012 08:15:20 -0400
Received: from epcpsbgm2.samsung.com (mailout4.samsung.com [203.254.224.34])
 by mailout4.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0M5K00H1721IGD11@mailout4.samsung.com> for
 linux-media@vger.kernel.org; Wed, 13 Jun 2012 21:15:19 +0900 (KST)
Received: from AMDN157 ([106.116.48.215])
 by mmp1.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTPA id <0M5K00LAX21D5710@mmp1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 13 Jun 2012 21:15:18 +0900 (KST)
From: Kamil Debski <k.debski@samsung.com>
To: 'Sachin Kamat' <sachin.kamat@linaro.org>,
	linux-media@vger.kernel.org
Cc: Tomasz Stanislawski <t.stanislaws@samsung.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>, snjw23@gmail.com,
	kyungmin.park@samsung.com, mchehab@infradead.org,
	patches@linaro.org
References: <1339409634-13657-1-git-send-email-sachin.kamat@linaro.org>
 <1339409634-13657-2-git-send-email-sachin.kamat@linaro.org>
In-reply-to: <1339409634-13657-2-git-send-email-sachin.kamat@linaro.org>
Subject: RE: [PATCH 2/3] [media] s5p-mfc: Replace printk with pr_* functions
Date: Wed, 13 Jun 2012 14:15:13 +0200
Message-id: <001801cd495e$32625130$9726f390$%debski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
Content-language: en-gb
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sachin,

I am afraid that I have to NACK this patch.

pr_debug/pr_err/etc. is useful when you want to add some data in front of the
debug message.

So if you really insist then you could try to add something like this

+#define pr_fmt(fmt) ":%s:%d: " fmt, __func__, __LINE__

+#define mfc_err pr_err

I share the opinion on these patch with Sylwester's opinion on the similar
patch
for FIMC - I don't think it's worth the effort. 

Best wishes,
--
Kamil Debski
Linux Platform Group
Samsung Poland R&D Center


> -----Original Message-----
> From: Sachin Kamat [mailto:sachin.kamat@linaro.org]
> Sent: 11 June 2012 12:14
> To: linux-media@vger.kernel.org
> Cc: t.stanislaws@samsung.com; k.debski@samsung.com;
> s.nawrocki@samsung.com; snjw23@gmail.com; kyungmin.park@samsung.com;
> mchehab@infradead.org; sachin.kamat@linaro.org; patches@linaro.org
> Subject: [PATCH 2/3] [media] s5p-mfc: Replace printk with pr_* functions
> 
> Replace printk with pr_* functions to silence checkpatch warnings.
> 
> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
> ---
>  drivers/media/video/s5p-mfc/s5p_mfc_debug.h |    6 +++---
>  drivers/media/video/s5p-mfc/s5p_mfc_opr.c   |    5 +++--
>  2 files changed, 6 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/media/video/s5p-mfc/s5p_mfc_debug.h
> b/drivers/media/video/s5p-mfc/s5p_mfc_debug.h
> index ecb8616..fea2c6e 100644
> --- a/drivers/media/video/s5p-mfc/s5p_mfc_debug.h
> +++ b/drivers/media/video/s5p-mfc/s5p_mfc_debug.h
> @@ -23,7 +23,7 @@ extern int debug;
>  #define mfc_debug(level, fmt, args...)				\
>  	do {							\
>  		if (debug >= level)				\
> -			printk(KERN_DEBUG "%s:%d: " fmt,	\
> +			pr_debug("%s:%d: " fmt,	\
>  				__func__, __LINE__, ##args);	\
>  	} while (0)
>  #else
> @@ -35,13 +35,13 @@ extern int debug;
> 
>  #define mfc_err(fmt, args...)				\
>  	do {						\
> -		printk(KERN_ERR "%s:%d: " fmt,		\
> +		pr_err("%s:%d: " fmt,		\
>  		       __func__, __LINE__, ##args);	\
>  	} while (0)
> 
>  #define mfc_info(fmt, args...)				\
>  	do {						\
> -		printk(KERN_INFO "%s:%d: " fmt,		\
> +		pr_info("%s:%d: " fmt,		\
>  		       __func__, __LINE__, ##args);	\
>  	} while (0)
> 
> diff --git a/drivers/media/video/s5p-mfc/s5p_mfc_opr.c
> b/drivers/media/video/s5p-mfc/s5p_mfc_opr.c
> index e6217cb..6d3f398 100644
> --- a/drivers/media/video/s5p-mfc/s5p_mfc_opr.c
> +++ b/drivers/media/video/s5p-mfc/s5p_mfc_opr.c
> @@ -12,6 +12,8 @@
>   * published by the Free Software Foundation.
>   */
> 
> +#define pr_fmt(fmt) "s5p-mfc: " fmt
> +
>  #include "regs-mfc.h"
>  #include "s5p_mfc_cmd.h"
>  #include "s5p_mfc_common.h"
> @@ -187,8 +189,7 @@ int s5p_mfc_alloc_codec_buffers(struct s5p_mfc_ctx
> *ctx)
>  		dev->alloc_ctx[MFC_BANK1_ALLOC_CTX], ctx->bank1_size);
>  		if (IS_ERR(ctx->bank1_buf)) {
>  			ctx->bank1_buf = NULL;
> -			printk(KERN_ERR
> -			       "Buf alloc for decoding failed (port A)\n");
> +			pr_err("Buf alloc for decoding failed (port A)\n");
>  			return -ENOMEM;

This can be replaced with mfc_err to make it consistent with other error
messages in this file.
It's my mistake that I have use printk(KERN_ERR ...

I think it is beneficial to read the neighboring lines of the line which
checkpatch
returns a warning in.

>  		}
>  		ctx->bank1_phys = s5p_mfc_mem_cookie(
> --
> 1.7.4.1

