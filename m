Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:34682 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933257AbaH0NDF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Aug 2014 09:03:05 -0400
Received: from eucpsbgm2.samsung.com (unknown [203.254.199.245])
 by mailout1.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0NAY00026V1Y7320@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 27 Aug 2014 14:05:58 +0100 (BST)
Message-id: <53FDD6FA.1010303@samsung.com>
Date: Wed, 27 Aug 2014 15:02:50 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: Marek Szyprowski <m.szyprowski@samsung.com>,
	linux-media@vger.kernel.org
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Kamil Debski <k.debski@samsung.com>,
	Jacek Anaszewski <j.anaszewski@samsung.com>
Subject: Re: [PATCH] media: s5p-mfc: rename special clock to sclk_mfc
References: <1409142988-9315-1-git-send-email-m.szyprowski@samsung.com>
In-reply-to: <1409142988-9315-1-git-send-email-m.szyprowski@samsung.com>
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 27/08/14 14:36, Marek Szyprowski wrote:
> Commit d19f405a5a8d2ed942b40f8cf7929a5a50d0cc59 ("[media] s5p-mfc: Fix
> selective sclk_mfc init") added support for special clock handling
> (named "sclk-mfc"). However this clock is not defined yet on any
> platform, so before adding it to all Exynos platform, better rename it
> to "sclk_mfc" to match the scheme used for all other special clocks on
> Exynos platform.
> 
> Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>

Acked-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
