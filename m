Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:27062 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751146Ab3CZS5x (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Mar 2013 14:57:53 -0400
Message-id: <5151EFAC.2040002@samsung.com>
Date: Tue, 26 Mar 2013 19:57:48 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: linux-media@vger.kernel.org
Cc: kyungmin.park@samsung.com, myungjoo.ham@samsung.com,
	dh09.lee@samsung.com, shaik.samsung@gmail.com, arun.kk@samsung.com,
	a.hajda@samsung.com, linux-samsung-soc@vger.kernel.org
Subject: Re: [PATCH v2 0/4] exynos4-is updates
References: <1364323101-22046-1-git-send-email-s.nawrocki@samsung.com>
In-reply-to: <1364323101-22046-1-git-send-email-s.nawrocki@samsung.com>
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/26/2013 07:38 PM, Sylwester Nawrocki wrote:
> This patch series includes YUV order handling fix for the FIMC
> and FIMC-LITE, a fix for media entity ref_count issue, minor
> refactoring and removal of some static data that will no longer
> be needed since starting from 3.10 Exynos platform is going to
> be DT only.

Sorry for spamming with this double patch series. Will try to
be more careful next time.

> Sylwester Nawrocki (5):
>   exynos4-is: Remove static driver data for Exynos4210 FIMC variants
>   exynos4-is: Use common driver data for all FIMC-LITE IP instances
>   exynos4-is: Allow colorspace conversion at fimc-lite
>   exynos4-is: Correct input DMA YUV order configuration
>   exynos4-is: Ensure proper media pipeline state on device close

-- 
Thanks,
Sylwester
