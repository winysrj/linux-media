Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:48454 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750729Ab3FZPAh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 26 Jun 2013 11:00:37 -0400
Message-id: <51CB0212.3050103@samsung.com>
Date: Wed, 26 Jun 2013 17:00:34 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: balbi@ti.com
Cc: linux-arm-kernel@lists.infradead.org,
	linux-samsung-soc@vger.kernel.org, kishon@ti.com,
	linux-media@vger.kernel.org, kyungmin.park@samsung.com,
	t.figa@samsung.com, devicetree-discuss@lists.ozlabs.org,
	kgene.kim@samsung.com, dh09.lee@samsung.com, jg1.han@samsung.com,
	inki.dae@samsung.com, plagnioj@jcrosoft.com,
	linux-fbdev@vger.kernel.org
Subject: Re: [PATCH v2 1/5] phy: Add driver for Exynos MIPI CSIS/DSIM DPHYs
References: <1372170110-12993-1-git-send-email-s.nawrocki@samsung.com>
 <20130625150649.GA21334@arwen.pp.htv.fi>
In-reply-to: <20130625150649.GA21334@arwen.pp.htv.fi>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 06/25/2013 05:06 PM, Felipe Balbi wrote:
>> +static struct platform_driver exynos_video_phy_driver = {
>> > +	.probe	= exynos_video_phy_probe,
>
> you *must* provide a remove method. drivers with NULL remove are
> non-removable :-)

Actually the remove() callback can be NULL, it's just missing module_exit
function that makes a module not unloadable.

--
Regards,
Sylwester
