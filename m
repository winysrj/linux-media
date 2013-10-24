Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:50662 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753324Ab3JXPOA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 24 Oct 2013 11:14:00 -0400
Message-id: <52693933.8040809@samsung.com>
Date: Thu, 24 Oct 2013 17:13:55 +0200
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
MIME-version: 1.0
To: Kishon Vijay Abraham I <kishon@ti.com>
Cc: gregkh@linuxfoundation.org, linux-media@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-fbdev@vger.kernel.org,
	linux-samsung-soc@vger.kernel.org
Subject: Re: [PATCH 5/7] phy: Add driver for Exynos DP PHY
References: <1381940896-9355-1-git-send-email-kishon@ti.com>
 <1381940896-9355-6-git-send-email-kishon@ti.com>
In-reply-to: <1381940896-9355-6-git-send-email-kishon@ti.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Kishon,
Recently, I posted 'simple-phy' driver.
It is a part of patchset for HDMI enabling on Exynos4 using Device Tree.

http://www.mail-archive.com/linux-samsung-soc@vger.kernel.org/msg23655.html

The simple-phy was dedicated for single register PHYs like HDMI or DP.
Using such a generic phy may help to avoid code duplication.

Regards,
Tomasz Stanislawski


On 10/16/2013 06:28 PM, Kishon Vijay Abraham I wrote:
> From: Jingoo Han <jg1.han@samsung.com>
> 
> Add a PHY provider driver for the Samsung Exynos SoC Display Port PHY.
> 
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>
> Reviewed-by: Tomasz Figa <t.figa@samsung.com>
> Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>
> Acked-by: Felipe Balbi <balbi@ti.com>
> Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
> ---
>  .../devicetree/bindings/phy/samsung-phy.txt        |    8 ++
>  drivers/phy/Kconfig                                |    7 ++
>  drivers/phy/Makefile                               |    1 +
>  drivers/phy/phy-exynos-dp-video.c                  |  111 ++++++++++++++++++++
>  4 files changed, 127 insertions(+)
>  create mode 100644 drivers/phy/phy-exynos-dp-video.c
> 

