Return-path: <mchehab@pedra>
Received: from msa103.auone-net.jp ([61.117.18.163]:43646 "EHLO
	msa103.auone-net.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755236Ab1DRP5W (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Apr 2011 11:57:22 -0400
Date: Tue, 19 Apr 2011 00:57:18 +0900
From: Akira Tsukamoto <akira-t@s9.dion.ne.jp>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: soc_camera with V4L2 driver 
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
In-Reply-To: <20110419001020.A4B5.B41FCDD0@s9.dion.ne.jp>
References: <Pine.LNX.4.64.1104181603470.27247@axis700.grange> <20110419001020.A4B5.B41FCDD0@s9.dion.ne.jp>
Message-Id: <20110419005717.E36F.B41FCDD0@s9.dion.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hello Guennadi,

> > >  static struct i2c_board_info i2c0_devices[] = {
> > >  	{
> > >  		I2C_BOARD_INFO("ag5evm_ts", 0x20),
> > >  		.irq	= pint2irq(12),	/* PINTC3 */
> > >  	},
> > > +	/* 2M camera */
> > > +	{
> > > +		I2C_BOARD_INFO("rj65na20", 0x40),
> > > +	},
> > 
> > No, you do not have to include this here, the sensor must not be registered 
> > automatically during the board initialisation.

I have one more question before sleeping :)

The camera module needs to be initialized by writing values to the registers.
Do I need to write init function at the following?

static const struct v4l2_subdev_core_ops rj65na20_core_ops = {
         .reset = rj65na20_reset,
[snip]
}

With kind regards,

Akira
-- 
Akira Tsukamoto

