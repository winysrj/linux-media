Return-path: <linux-media-owner@vger.kernel.org>
Received: from cassiel.sirena.org.uk ([80.68.93.111]:47862 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755358AbZDTOEO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Apr 2009 10:04:14 -0400
Date: Mon, 20 Apr 2009 15:04:11 +0100
From: Mark Brown <broonie@sirena.org.uk>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Magnus Damm <magnus.damm@gmail.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Robert Jarzmik <robert.jarzmik@free.fr>,
	Kuninori Morimoto <morimoto.kuninori@renesas.com>,
	linux-i2c@vger.kernel.org, Greg KH <greg@kroah.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: v4l2-subdev Re: [PATCH 0/5] soc-camera: convert to platform
	device
Message-ID: <20090420140411.GE8776@sirena.org.uk>
References: <aec7e5c30904170040p6ec1721aj6885ef16573cd484@mail.gmail.com> <Pine.LNX.4.64.0904170950320.5119@axis700.grange> <aec7e5c30904170331n6da85695gdd6da8d6a42eacf1@mail.gmail.com> <Pine.LNX.4.64.0904171235010.5119@axis700.grange> <aec7e5c30904200014n2d8cdcfeud23f2b6b221f9fad@mail.gmail.com> <Pine.LNX.4.64.0904200921090.4403@axis700.grange> <aec7e5c30904200100wb117328sb97ea0262d163547@mail.gmail.com> <Pine.LNX.4.64.0904201010130.4403@axis700.grange> <aec7e5c30904200154w758e4ecl8174a4cb0bce11f9@mail.gmail.com> <Pine.LNX.4.64.0904201525320.4403@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0904201525320.4403@axis700.grange>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Apr 20, 2009 at 03:50:44PM +0200, Guennadi Liakhovetski wrote:

> break if we move it down right after i2c? Another hackish interim solution 
> would be to replace module_init with subsys_init in i2c-sh_mobile.c like 
> some other i2c adapters do (including MXC, PXA). That's certainly easier, 
> but then we'd also have to modify i2c-imx, later maybe i2c-at91.c...

That'd be sensible long term anyway - voltage and current regulators are
often I2C devices and they need to be initialised very early in order to
be available for general use.
