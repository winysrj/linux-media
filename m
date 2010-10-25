Return-path: <mchehab@pedra>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:53638 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754136Ab0JYJmW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 25 Oct 2010 05:42:22 -0400
Date: Mon, 25 Oct 2010 11:42:21 +0200
From: Michael Grzeschik <mgr@pengutronix.de>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Robert Jarzmik <robert.jarzmik@free.fr>,
	Michael Grzeschik <m.grzeschik@pengutronix.de>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Philipp Wiesner <p.wiesner@phytec.de>
Subject: Re: [PATCH v2 10/11] mt9m111: rewrite set_pixfmt
Message-ID: <20101025094221.GA32507@pengutronix.de>
References: <1280833069-26993-1-git-send-email-m.grzeschik@pengutronix.de> <1280833069-26993-11-git-send-email-m.grzeschik@pengutronix.de> <Pine.LNX.4.64.1008271335200.28043@axis700.grange> <871v9hmdoz.fsf@free.fr> <20100831074605.GC15967@pengutronix.de> <Pine.LNX.4.64.1009042234400.24729@axis700.grange> <Pine.LNX.4.64.1010021003190.14599@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1010021003190.14599@axis700.grange>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Sat, Oct 02, 2010 at 10:03:55AM +0200, Guennadi Liakhovetski wrote:
> Michael, any insight?

long time ago...

> > > > For the YUV and RGB formats, tested and acked.
> > > > For the bayer, I don't use it. With row switch, that gives back:
> > > > byte offset: 0 1 2 3
> > > >              B G B G
> > > >              G R G R
> > > > 
> > > > Without the switch:
> > > > byte offset: 0 1 2 3
> > > >              G R G R
> > > >              B G B G
> > > > 
> > > > I would have expected the second version (ie. without the switch, ie. the
> > > > original version of mt9m111 driver) to be correct, but I might be wrong. Maybe
> > > > Michael can enlighten me here.
> > > Yes this seems odd, i normaly expect the first line to be BGBG.
> > > I will search for the cause and reply a little later, perhaps end of
> > > the week, since i am also short on time at this moment.

I have reviewed the Datasheet of the Camera and found Roberts previously
described behaviour as correct. So the Bayercode seems functional in
that patch.

> > Ok, _if_ you have to redo this patch, maybe you could also merge
> > 
> > [PATCH 04/11] mt9m111: added new bit offset defines
> > [PATCH 08/11] mt9m111: added reg_mask function
> > 
> > into it, otherwise their purpose is unclear.

I will send a squashed Version of the three patches in some minutes.

Cheers,
Michael

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
