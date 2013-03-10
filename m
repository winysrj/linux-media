Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f171.google.com ([74.125.82.171]:37419 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751487Ab3CJUgd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 10 Mar 2013 16:36:33 -0400
Message-ID: <513CEECC.8050903@gmail.com>
Date: Sun, 10 Mar 2013 21:36:28 +0100
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: Shaik Ameer Basha <shaik.ameer@samsung.com>
CC: linux-media@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
	linux-samsung-soc@vger.kernel.org, s.nawrocki@samsung.com,
	shaik.samsung@gmail.com
Subject: Re: [RFC 00/12] Adding media device driver for Exynos imaging subsystem
References: <1362570838-4737-1-git-send-email-shaik.ameer@samsung.com>
In-Reply-To: <1362570838-4737-1-git-send-email-shaik.ameer@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/06/2013 12:53 PM, Shaik Ameer Basha wrote:
> The following patchset features:
>
> 1] Creating a common pipeline framework which can be used by all
> Exynos series SoCs for developing media device drivers.
> 2] Modified the existing fimc-mdevice for exynos4 to use the common
> pipeline framework.
> 3] Adding of media device driver for Exynos5 Imaging subsystem.
> 4] Upgrading mipi-csis and fimc-lite drivers for Exynos5 SoCs.
> 5] Adding DT support to m5mols driver and tested with Exynos5 media
> device driver.
>
> Current changes are not tested on exynos4 series SoCs. Current media
> device driver only support one pipeline (pipeline0) which consists of
> 	Sensor -->  MIPI-CSIS -->  FIMC-LITE
> 	Sensor -->  FIMC-LITE

Thanks Shaik. My quick review to follow. I'll focus on most significant
issues for now.

And here is my updated patch series adding device tree support to
s5p-fimc driver [1]. I hope it gets merged to v3.10 without significant
changes. Sorry, for now we need to use that private branch.

[1] http://git.linuxtv.org/snawrocki/samsung.git/devicetree-fimc

Regards,
Sylwester
