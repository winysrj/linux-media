Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:50875 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756267Ab0EYGiP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 25 May 2010 02:38:15 -0400
Date: Tue, 25 May 2010 08:38:05 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Baruch Siach <baruch@tkos.co.il>
Cc: linux-media@vger.kernel.org,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Sascha Hauer <kernel@pengutronix.de>,
	linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 0/3] Driver for the i.MX2x CMOS Sensor Interface
Message-ID: <20100525063805.GE17272@pengutronix.de>
References: <cover.1274706733.git.baruch@tkos.co.il>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1274706733.git.baruch@tkos.co.il>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, May 24, 2010 at 04:20:38PM +0300, Baruch Siach wrote:
> This series contains a soc_camera driver for the i.MX25/i.MX27 CSI device, and
> platform code for the i.MX25 and i.MX27 chips. This driver is based on a 
> driver for i.MX27 CSI from Sascha Hauer, that  Alan Carvalho de Assis has 
> posted in linux-media last December[1]. I tested the mx2_camera driver on the 
> i.MX25 PDK. Sascha Hauer has tested a earlier version of this driver on an 
> i.MX27 based board. I included in this version some fixes from Sascha that 
> enable i.MX27 support.
> 
> [1] https://patchwork.kernel.org/patch/67636/
> 
> Changes v1 -> v2
>     Addressed the comments of Guennadi Liakhovetski except from the following:
> 
>     1. The mclk_get_divisor implementation, since I don't know what this code 
>        is good for

I'll have a look at this soon.

Sascha


-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
