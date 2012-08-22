Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:40737 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932164Ab2HVQS4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 22 Aug 2012 12:18:56 -0400
Received: from eusync1.samsung.com (mailout1.w1.samsung.com [210.118.77.11])
 by mailout1.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0M96009MV0098100@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 22 Aug 2012 17:19:21 +0100 (BST)
Received: from AMDN157 ([106.116.147.102])
 by eusync1.samsung.com (Oracle Communications Messaging Server 7u4-23.01
 (7.0.4.23.0) 64bit (built Aug 10 2011))
 with ESMTPA id <0M95000APZZH1920@eusync1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 22 Aug 2012 17:18:54 +0100 (BST)
From: Kamil Debski <k.debski@samsung.com>
To: 'Arun Kumar K' <arun.kk@samsung.com>, linux-media@vger.kernel.org
Cc: jtp.park@samsung.com, janghyuck.kim@samsung.com,
	jaeryul.oh@samsung.com, ch.naveen@samsung.com,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	kmpark@infradead.org, joshi@samsung.com
References: <1344508110-16945-1-git-send-email-arun.kk@samsung.com>
 <1344508110-16945-2-git-send-email-arun.kk@samsung.com>
In-reply-to: <1344508110-16945-2-git-send-email-arun.kk@samsung.com>
Subject: RE: [PATCH v4 1/4] [media] s5p-mfc: Update MFCv5 driver for callback
 based architecture
Date: Wed, 22 Aug 2012 18:18:53 +0200
Message-id: <007101cd8081$d31074e0$79315ea0$%debski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
Content-language: en-gb
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Arun,

First of all - thank you for all the patches, they are getting better and
better
with every version.

Two things: 
1) A minor one - I suggest that the choice of the default pixel format should
be
done in a different manner. I suggest using a V4L2_PIX_FMT_* in the
DEF_SRC_FMT_DEC
define and then using find_format in s5p_mfc_dec_init. Same goes for encoding.

2) A major one - the ops mechanism could be improved. I see that there are
many functions that only call an ops. Such as:

> int s5p_mfc_alloc_dec_temp_buffers(struct s5p_mfc_ctx *ctx)
> {
>        return s5p_mfc_ops->s5p_mfc_alloc_dec_temp_buffers(ctx);
> }

I suggest dropping the s5p_mfc_ prefix in all the fields of s5p_mfc_hw_ops and
using a macro to call the ops. Like this:

+#define fimc_pipeline_call(f, op, p, args...)                          \
+       (!(f) ? -ENODEV : (((f)->pipeline_ops && (f)->pipeline_ops->op) ? \
+                           (f)->pipeline_ops->op((p), ##args) :
-ENOIOCTLCMD))
(from commit by Sylwester Nawrocki http://goo.gl/Q657j)

In addition, your code does not check whether the ops pointer is null and I
think that it should be done.

Best wishes,
--
Kamil Debski
Linux Platform Group
Samsung Poland R&D Center

[snip the code]

