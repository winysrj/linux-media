Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:38526 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754193Ab0EUHUz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 21 May 2010 03:20:55 -0400
Date: Fri, 21 May 2010 09:20:45 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Baruch Siach <baruch@tkos.co.il>
Cc: linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	Sascha Hauer <kernel@pengutronix.de>
Subject: Re: [PATCH 0/3] Driver for the i.MX2x CMOS Sensor Interface
Message-ID: <20100521072045.GD17272@pengutronix.de>
References: <cover.1273150585.git.baruch@tkos.co.il>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1273150585.git.baruch@tkos.co.il>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, May 06, 2010 at 04:09:38PM +0300, Baruch Siach wrote:
> This series contains a soc_camera driver for the i.MX25/i.MX27 CSI device, and 
> platform code for the i.MX25 and i.MX27 chips. This driver is based on a driver 
> for i.MX27 CSI from Sascha Hauer, that  Alan Carvalho de Assis has posted in 
> linux-media last December[1]. Since all I have is a i.MX25 PDK paltform I can't 
> test the mx27 specific code. Testers and comment are welcome.
> 
> [1] https://patchwork.kernel.org/patch/67636/
> 
> Baruch Siach (3):
>   mx2_camera: Add soc_camera support for i.MX25/i.MX27
>   mx27: add support for the CSI device
>   mx25: add support for the CSI device

With the two additions I sent I can confirm this working on i.MX27, so
no need to remove the related code.

Sascha


-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
