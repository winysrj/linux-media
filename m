Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:31028 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756997Ab3FSRYr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 19 Jun 2013 13:24:47 -0400
Message-id: <51C1E95C.5040607@samsung.com>
Date: Wed, 19 Jun 2013 19:24:44 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: Kukjin Kim <kgene.kim@samsung.com>
Cc: kishon@ti.com, linux-arm-kernel@lists.infradead.org,
	linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
	kyungmin.park@samsung.com, sw0312.kim@samsung.com,
	devicetree-discuss@lists.ozlabs.org, dh09.lee@samsung.com,
	jg1.han@samsung.com, linux-fbdev@vger.kernel.org
Subject: Re: [RFC PATCH 5/5] ARM: Samsung: Remove MIPI PHY setup code
References: <1371231951-1969-1-git-send-email-s.nawrocki@samsung.com>
 <1371231951-1969-6-git-send-email-s.nawrocki@samsung.com>
 <51BE25A0.6050202@samsung.com>
In-reply-to: <51BE25A0.6050202@samsung.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/16/2013 10:52 PM, Kukjin Kim wrote:
> On 06/15/13 02:45, Sylwester Nawrocki wrote:
>> > Generic PHY drivers are used to handle the MIPI CSIS and MIPI DSIM
>> > DPHYs so we can remove now unused code at arch/arm/plat-samsung.
>
> If so, sounds good :)
> 
>> > In case there is any board file for S5PV210 platforms using MIPI
>> > CSIS/DSIM (not any upstream currently) it should use the generic
>> > PHY API to bind the PHYs to respective PHY consumer drivers.
>
> To be honest, I didn't test this on boards but if the working is fine, 
> please go ahead without RFC.

Thanks for review. I've tested it on Exynos4412 based board, and will
check also on Exynos4210 TRATS before posting the final version.
It seems to work fine, I just won't be able to test on any non-dt
platform (s5pv210), and there is currently no users of MIPI CSIS/DSIM
on s5pv210. Moreover this series depends on the generic PHY API,
perhaps it can be merged for 3.11.

[1] http://www.spinics.net/lists/arm-kernel/msg251232.html

Regards,
Sylwester
