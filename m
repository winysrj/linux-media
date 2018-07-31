Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:36429 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731988AbeGaOPF (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 31 Jul 2018 10:15:05 -0400
Date: Tue, 31 Jul 2018 14:34:52 +0200
From: Maxime Ripard <maxime.ripard@bootlin.com>
To: Philipp Rossak <embed3d@gmail.com>
Cc: mchehab@kernel.org, robh+dt@kernel.org, mark.rutland@arm.com,
        wens@csie.org, linux@armlinux.org.uk, sean@mess.org,
        p.zabel@pengutronix.de, andi.shyti@samsung.com,
        linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com
Subject: Re: [PATCH v6 0/4] IR support for A83T
Message-ID: <20180731123452.74jyxc4q3ewig35z@flea>
References: <20180731092258.2279-1-embed3d@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20180731092258.2279-1-embed3d@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Jul 31, 2018 at 11:22:54AM +0200, Philipp Rossak wrote:
> This patch series adds support for the sunxi A83T ir module and enhances 
> the sunxi-ir driver. Right now the base clock frequency for the ir driver
> is a hard coded define and is set to 8 MHz.
> This works for the most common ir receivers. On the Sinovoip Bananapi M3 
> the ir receiver needs, a 3 MHz base clock frequency to work without
> problems with this driver.
> 
> This patch series adds support for an optinal property that makes it able
> to override the default base clock frequency and enables the ir interface 
> on the a83t and the Bananapi M3.

Once the minor comment on patch 2 has been fixed,
Acked-by: Maxime Ripard <maxime.ripard@bootlin.com>

Maxime

-- 
Maxime Ripard, Bootlin (formerly Free Electrons)
Embedded Linux and Kernel engineering
https://bootlin.com
