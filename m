Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:19251 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752728Ab3AQLQS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Jan 2013 06:16:18 -0500
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout1.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MGR002XCOJVN440@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 17 Jan 2013 11:16:16 +0000 (GMT)
Received: from [106.116.147.32] by eusync3.samsung.com
 (Oracle Communications Messaging Server 7u4-23.01(7.0.4.23.0) 64bit (built Aug
 10 2011)) with ESMTPA id <0MGR00HLUON4RFA0@eusync3.samsung.com> for
 linux-media@vger.kernel.org; Thu, 17 Jan 2013 11:16:16 +0000 (GMT)
Message-id: <50F7DD7F.5030504@samsung.com>
Date: Thu, 17 Jan 2013 12:16:15 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: linux-media@vger.kernel.org, k.debski@samsung.com,
	patches@linaro.org
Subject: Re: [PATCH v2] s5p-g2d: Add support for G2D H/W Rev.4.1
References: <1358395638-26086-1-git-send-email-sachin.kamat@linaro.org>
In-reply-to: <1358395638-26086-1-git-send-email-sachin.kamat@linaro.org>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sachin,

On 01/17/2013 05:07 AM, Sachin Kamat wrote:
> Modified the G2D driver (which initially supported only H/W Rev.3)
> to support H/W Rev.4.1 present on Exynos4x12 and Exynos52x0 SOCs.
> 
> -- Set the SRC and DST type to 'memory' instead of using reset values.
> -- FIMG2D v4.1 H/W uses different logic for stretching(scaling).
> -- Use CACHECTL_REG only with FIMG2D v3.
> 
> Signed-off-by: Ajay Kumar <ajaykumar.rs@samsung.com>
> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
> Acked-by: Kamil Debski <k.debski@samsung.com>
> ---
> Changes since v1:
> Moved g2d_get_drv_data() to g2d.h as suggested by
> Sylwester Nawrocki <s.nawrocki@samsung.com>.

I have applied this patch for 3.9, thanks. You may also need a patch
adding DT support, since those new SoCs are in mainline DT only.

--

Regards,
Sylwester
