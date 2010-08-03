Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:54787 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756461Ab0HCT53 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 3 Aug 2010 15:57:29 -0400
Date: Tue, 3 Aug 2010 21:57:27 +0200
From: Michael Grzeschik <mgr@pengutronix.de>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Michael Grzeschik <m.grzeschik@pengutronix.de>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	baruch@tkos.co.il, Sascha Hauer <s.hauer@pengutronix.de>
Subject: Re: [PATCH 1/5] mx2_camera: change to register and probe
Message-ID: <20100803195727.GB12367@pengutronix.de>
References: <1280828276-483-1-git-send-email-m.grzeschik@pengutronix.de> <1280828276-483-2-git-send-email-m.grzeschik@pengutronix.de> <Pine.LNX.4.64.1008032016340.10845@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1008032016340.10845@axis700.grange>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Aug 03, 2010 at 08:22:13PM +0200, Guennadi Liakhovetski wrote:
> On Tue, 3 Aug 2010, Michael Grzeschik wrote:
> 
> > change this driver back to register and probe, since some platforms
> > first have to initialize an already registered power regulator to switch
> > on the camera.
> 
> Sorry, don't see a difference. Can you give an example of two call 
> sequences, where this change changes the behaviour?
>

Yes, when you look at the today posted patch [1] you find the function
pcm970_baseboard_init_late as an late_initcall. It uses an already
registred regulator device to turn on the power of the camera before the
cameras device registration.

[1] [PATCH 1/2] ARM: i.MX27 pcm970: Add camera support
http://lists.infradead.org/pipermail/linux-arm-kernel/2010-August/022317.html

Thanks,
Michael

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
