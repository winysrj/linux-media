Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:59782 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759134Ab2CSPeM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 19 Mar 2012 11:34:12 -0400
Received: from euspt2 (mailout1.w1.samsung.com [210.118.77.11])
 by mailout1.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0M1500IFM1WICK@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 19 Mar 2012 15:33:54 +0000 (GMT)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0M15001IZ1WVSW@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 19 Mar 2012 15:34:07 +0000 (GMT)
Date: Mon, 19 Mar 2012 16:34:01 +0100
From: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
Subject: RE: [PATCH] [media] s5p-jpeg: Make the output format setting
 conditional
In-reply-to: <1332156889-8175-1-git-send-email-sachin.kamat@linaro.org>
To: 'Sachin Kamat' <sachin.kamat@linaro.org>,
	linux-media@vger.kernel.org
Cc: mchehab@infradead.org, patches@linaro.org
Message-id: <000601cd05e5$b576bdc0$20643940$%p@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-language: pl
Content-transfer-encoding: 7BIT
References: <1332156889-8175-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

On March 19, 2012 12:35 PM Sachin Kamat wrote:

> Subject: [PATCH] [media] s5p-jpeg: Make the output format setting
conditional
> 
> S5P-JPEG IP on Exynos4210 SoC supports YCbCr422 and YCbCr420
> as decoded output formats. But the driver used to fix the output
> format as YCbCr422. This is now made conditional depending upon
> the requested output format.
> 
> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
> ---
>  drivers/media/video/s5p-jpeg/jpeg-core.c |    5 ++++-

<snip>

This has already been submitted and been pulled by Mauro:

http://git.linuxtv.org/media_tree.git/commit/fb6f8c0269644a19ee5e9bd6db080b3
64ab28ea7

Andrzej



