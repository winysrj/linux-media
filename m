Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f45.google.com ([74.125.82.45]:41674 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751970Ab3HCVkK (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 3 Aug 2013 17:40:10 -0400
Message-ID: <51FD78B5.6080507@gmail.com>
Date: Sat, 03 Aug 2013 23:40:05 +0200
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: Arun Kumar K <arun.kk@samsung.com>
CC: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
	devicetree@vger.kernel.org, s.nawrocki@samsung.com,
	hverkuil@xs4all.nl, a.hajda@samsung.com, sachin.kamat@linaro.org,
	shaik.ameer@samsung.com, kilyeon.im@samsung.com,
	arunkk.samsung@gmail.com
Subject: Re: [RFC v3 00/13] Exynos5 IS driver
References: <1375455762-22071-1-git-send-email-arun.kk@samsung.com>
In-Reply-To: <1375455762-22071-1-git-send-email-arun.kk@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Arun,

On 08/02/2013 05:02 PM, Arun Kumar K wrote:
> The patch series add support for Exynos5 camera subsystem. It
> re-uses mipi-csis and fimc-lite from exynos4-is and adds a new
> media device and fimc-is device drivers for exynos5.
> The media device supports asynchronos subdev registration for the
> fimc-is sensors and is based on the patch series from Sylwester
> for exynos4-is [1].
>
> [1]http://www.mail-archive.com/linux-media@vger.kernel.org/msg64653.html
>
> Changes from v2
> ---------------
> - Added exynos5 media device driver from Shaik to this series
> - Added ISP pipeline support in media device driver
> - Based on Sylwester's latest exynos4-is development
> - Asynchronos registration of sensor subdevs
> - Made independent IS-sensor support
> - Add s5k4e5 sensor driver
> - Addressed review comments from Sylwester, Hans, Andrzej, Sachin

This is starting to look pretty good to me, I hope we can merge this
patch set for v3.12. Let use coming two weeks for one or two review/
corrections round.
In the meantime I've done numerous fixes to the patch series [1],
especially the clock provider code was pretty buggy on the clean up
paths. Let's go through the patches and see what can be improved yet.

Thanks,
Sylwester

