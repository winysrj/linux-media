Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:15689 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751309AbaGKQkM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Jul 2014 12:40:12 -0400
Received: from eucpsbgm2.samsung.com (unknown [203.254.199.245])
 by mailout1.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0N8K00ASJ3MTQ230@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 11 Jul 2014 17:40:05 +0100 (BST)
Message-id: <53C01368.6070306@samsung.com>
Date: Fri, 11 Jul 2014 18:40:08 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: Jacek Anaszewski <j.anaszewski@samsung.com>,
	linux-media@vger.kernel.org
Cc: andrzej.p@samsung.com
Subject: Re: [PATCH v2 0/9] Add support for Exynos3250 SoC to the s5p-jpeg
 driver
References: <1405091990-28567-1-git-send-email-j.anaszewski@samsung.com>
In-reply-to: <1405091990-28567-1-git-send-email-j.anaszewski@samsung.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jacek,

On 11/07/14 17:19, Jacek Anaszewski wrote:
> 
> Jacek Anaszewski (9):
>   s5p-jpeg: Add support for Exynos3250 SoC
>   s5p-jpeg: return error immediately after get_byte fails
>   s5p-jpeg: Adjust jpeg_bound_align_image to Exynos3250 needs
>   s5p-jpeg: fix g_selection op
>   s5p-jpeg: Assure proper crop rectangle initialization
>   s5p-jpeg: Prevent erroneous downscaling for Exynos3250 SoC
>   s5p-jpeg: add chroma subsampling adjustment for Exynos3250
>   Documentation: devicetree: Document sclk-jpeg clock for exynos3250
>     SoC
>   ARM: dts: exynos3250: add JPEG codec device node

I've applied all patches from this series except the last one
into my tree.

-- 
Thanks,
Sylwester
