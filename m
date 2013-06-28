Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:42531 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755130Ab3F1KCk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 28 Jun 2013 06:02:40 -0400
Message-id: <51CD5F3C.4010504@samsung.com>
Date: Fri, 28 Jun 2013 12:02:36 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: Kishon Vijay Abraham I <kishon@ti.com>
Cc: Jingoo Han <jg1.han@samsung.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-samsung-soc@vger.kernel.org, linux-media@vger.kernel.org,
	'Kukjin Kim' <kgene.kim@samsung.com>,
	'Felipe Balbi' <balbi@ti.com>,
	'Tomasz Figa' <t.figa@samsung.com>,
	devicetree-discuss@lists.ozlabs.org,
	'Inki Dae' <inki.dae@samsung.com>,
	'Donghwa Lee' <dh09.lee@samsung.com>,
	'Kyungmin Park' <kyungmin.park@samsung.com>,
	'Jean-Christophe PLAGNIOL-VILLARD' <plagnioj@jcrosoft.com>,
	linux-fbdev@vger.kernel.org
Subject: Re: [PATCH 1/3] phy: Add driver for Exynos DP PHY
References: <001501ce73bf$87c49c00$974dd400$@samsung.com>
 <51CD57EF.5010808@ti.com>
In-reply-to: <51CD57EF.5010808@ti.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 06/28/2013 11:31 AM, Kishon Vijay Abraham I wrote:
>> diff --git a/Documentation/devicetree/bindings/phy/samsung,exynos5250-dp-video-phy.txt
>> b/Documentation/devicetree/bindings/phy/samsung,exynos5250-dp-video-phy.txt
>> new file mode 100644
>> index 0000000..8b6fa79
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/phy/samsung,exynos5250-dp-video-phy.txt
> 
> How about creating a single Documentation file for all samsung video phys? 
> Sylwester?

Yes, makes sense. There are quite a few various PHYs on the Exynos SoC.
Let me resend my series with the binding description file name changed
to samsung-phy.txt. I need to add couple fixes to that series anyway.

Regards,
Sylwester
