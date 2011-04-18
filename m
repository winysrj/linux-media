Return-path: <mchehab@pedra>
Received: from msa105.auone-net.jp ([61.117.18.165]:41268 "EHLO
	msa105.auone-net.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751797Ab1DRPKZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Apr 2011 11:10:25 -0400
Date: Tue, 19 Apr 2011 00:10:21 +0900
From: Akira Tsukamoto <akira-t@s9.dion.ne.jp>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: soc_camera with V4L2 driver 
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.1104181603470.27247@axis700.grange>
References: <20110418225538.155F.B41FCDD0@s9.dion.ne.jp> <Pine.LNX.4.64.1104181603470.27247@axis700.grange>
Message-Id: <20110419001020.A4B5.B41FCDD0@s9.dion.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hello Guennadi,

> > Also,
> > I would like to know, if I need to bind to 
> >    sh_mobile_ceu_camera.c
> > too, and how, because the camera is connected to CEU.
> 
> Yes, you do. Look at the board-ap4evb and board-mackerel files at 
> everything, containing the "ceu" string in it. The former configures a 
> serially connected camera sensor over the MIPI CSI-2 bus, the latter over 
> the parallel interface.

Thank you, I will definitely look into those files about ceu.

> > +static struct platform_device rj65na20_camera = {
> > +	.name	= "soc-camera-pdrv-2M",
> 
> This name has to match with what's advertised in 
> drivers/media/video/soc_camera.c, namely "soc-camera-pdrv"

I will fix it.

> >  static struct i2c_board_info i2c0_devices[] = {
> >  	{
> >  		I2C_BOARD_INFO("ag5evm_ts", 0x20),
> >  		.irq	= pint2irq(12),	/* PINTC3 */
> >  	},
> > +	/* 2M camera */
> > +	{
> > +		I2C_BOARD_INFO("rj65na20", 0x40),
> > +	},
> 
> No, you do not have to include this here, the sensor must not be registered 
> automatically during the board initialisation.

Thank you for your review. It is already midnight in Tokyo,
so I will try it first in the morning tomorrow.

With kind regards,

FYI:
>    the ARM board, Renesas, through I2C.
>     arch/arm/mach-shmobile/board-ag5evm.c

This file is temporal situation just for me to start with.

Akira
-- 
Akira Tsukamoto

