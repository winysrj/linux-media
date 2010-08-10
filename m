Return-path: <mchehab@pedra>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:35026 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752872Ab0HJKZi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Aug 2010 06:25:38 -0400
Date: Tue, 10 Aug 2010 12:25:36 +0200
From: Michael Grzeschik <mgr@pengutronix.de>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Michael Grzeschik <m.grzeschik@pengutronix.de>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	baruch@tkos.co.il, Sascha Hauer <s.hauer@pengutronix.de>
Subject: Re: [PATCH 1/5] mx2_camera: change to register and probe
Message-ID: <20100810102536.GA13418@pengutronix.de>
References: <1280828276-483-1-git-send-email-m.grzeschik@pengutronix.de> <1280828276-483-2-git-send-email-m.grzeschik@pengutronix.de> <Pine.LNX.4.64.1008052211560.26127@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1008052211560.26127@axis700.grange>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

Hi Guennadi,

On Thu, Aug 05, 2010 at 10:17:11PM +0200, Guennadi Liakhovetski wrote:
> On Tue, 3 Aug 2010, Michael Grzeschik wrote:
> 
> > change this driver back to register and probe, since some platforms
> > first have to initialize an already registered power regulator to switch
> > on the camera.
> 
> I shall be preparing a pull-request for 2.6.36-rc1 #2, but since we 
> haven't finished discussing this and when this is ready, this will be a 
> fix - without this your platform doesn't work, right? So, we can push it 
> after rc1.

The issue is, that we cannot change the platform code from the
late_initcall structure. For me there is no other solution than that,
because we have to enable the regulator before the camera chip to
communicate over i2c. If we would move to the notify way we would
first listen for the i2c enabled clients but for that we would still
have to first enable the regulator. At this moment i don't see a
solution in this way.

The safest way would still be to use the patch as is.

Thanks,
Michael

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
