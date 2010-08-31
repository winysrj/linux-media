Return-path: <mchehab@localhost>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:41548 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756832Ab0HaHqH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 31 Aug 2010 03:46:07 -0400
Date: Tue, 31 Aug 2010 09:46:05 +0200
From: Michael Grzeschik <mgr@pengutronix.de>
To: Robert Jarzmik <robert.jarzmik@free.fr>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Michael Grzeschik <m.grzeschik@pengutronix.de>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Philipp Wiesner <p.wiesner@phytec.de>
Subject: Re: [PATCH v2 10/11] mt9m111: rewrite set_pixfmt
Message-ID: <20100831074605.GC15967@pengutronix.de>
References: <1280833069-26993-1-git-send-email-m.grzeschik@pengutronix.de> <1280833069-26993-11-git-send-email-m.grzeschik@pengutronix.de> <Pine.LNX.4.64.1008271335200.28043@axis700.grange> <871v9hmdoz.fsf@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <871v9hmdoz.fsf@free.fr>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@localhost>

Hi Robert and Guennadi

On Sun, Aug 29, 2010 at 09:17:00PM +0200, Robert Jarzmik wrote:
> Guennadi Liakhovetski <g.liakhovetski@gmx.de> writes:
> 
> > Robert, I'll need your ack / tested by on this one too. It actually 
> > changes behaviour, for example, it sets MT9M111_OUTFMT_FLIP_BAYER_ROW in 
> > the OUTPUT_FORMAT_CTRL register for the V4L2_MBUS_FMT_SBGGR8_1X8 8 bit 
> > Bayer format. Maybe other things too - please have a look.
> 
> For the YUV and RGB formats, tested and acked.
> For the bayer, I don't use it. With row switch, that gives back:
> byte offset: 0 1 2 3
>              B G B G
>              G R G R
> 
> Without the switch:
> byte offset: 0 1 2 3
>              G R G R
>              B G B G
> 
> I would have expected the second version (ie. without the switch, ie. the
> original version of mt9m111 driver) to be correct, but I might be wrong. Maybe
> Michael can enlighten me here.
Yes this seems odd, i normaly expect the first line to be BGBG.
I will search for the cause and reply a little later, perhaps end of
the week, since i am also short on time at this moment.

Michael

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
