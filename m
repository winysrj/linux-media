Return-path: <mchehab@pedra>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:35986 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753346Ab1DRIU7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Apr 2011 04:20:59 -0400
Date: Mon, 18 Apr 2011 10:20:49 +0200
From: Robert Schwebel <r.schwebel@pengutronix.de>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Uwe =?iso-8859-15?Q?Kleine-K=F6nig?=
	<u.kleine-koenig@pengutronix.de>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	kernel@pengutronix.de
Subject: Re: [PATCH] V4L: mx3_camera: select VIDEOBUF2_DMA_CONTIG instead
 of VIDEOBUF_DMA_CONTIG
Message-ID: <20110418082049.GJ3811@pengutronix.de>
References: <1302166243-650-1-git-send-email-u.kleine-koenig@pengutronix.de>
 <20110418080637.GA31131@pengutronix.de>
 <Pine.LNX.4.64.1104181013250.27247@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1104181013250.27247@axis700.grange>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Uwe,

On Mon, Apr 18, 2011 at 10:14:56AM +0200, Guennadi Liakhovetski wrote:
> It's been pushed upstream almost 2 weeks ago:
>
> http://article.gmane.org/gmane.linux.drivers.video-input-infrastructure/31352

As our autobuilder does still trigger, I assume that the configs have to
be refreshed and it may be an issue on our side. Can you take care of
that?

rsc
-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
