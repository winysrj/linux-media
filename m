Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:38821 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752726AbaHNHPY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 14 Aug 2014 03:15:24 -0400
Date: Thu, 14 Aug 2014 09:15:20 +0200
From: Robert Schwebel <r.schwebel@pengutronix.de>
To: Jeff Kudrick <B37172@freescale.com>
Cc: 'Fabio Estevam' <fabio.estevam@freescale.com>,
	Kamil Debski <k.debski@samsung.com>,
	'Nicolas Dufresne' <nicolas.dufresne@collabora.com>,
	linux-media@vger.kernel.org,
	'Mauro Carvalho Chehab' <m.chehab@samsung.com>,
	kernel@pengutronix.de, Guo Shawn-R65073 <r65073@freescale.com>,
	Estevam Fabio-R49496 <r49496@freescale.com>
Subject: Re: [PATCH v2 06/29] [media] coda: Add encoder/decoder support for
 CODA960
Message-ID: <20140814071520.GA5946@pengutronix.de>
References: <1403621771-11636-1-git-send-email-p.zabel@pengutronix.de>
 <1403621771-11636-7-git-send-email-p.zabel@pengutronix.de>
 <1403626611.10756.11.camel@mpb-nicolas>
 <1404237187.19382.78.camel@paszta.hi.pengutronix.de>
 <0b3a01cf95fa$b7df2190$279d64b0$%debski@samsung.com>
 <20140702191642.GM22620@pengutronix.de>
 <20140711123318.GB5441@pengutronix.de>
 <20140721070750.GF13730@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140721070750.GF13730@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Jeff,

On Mon, Jul 21, 2014 at 09:07:50AM +0200, Robert Schwebel wrote:
> On Fri, Jul 11, 2014 at 02:33:18PM +0200, Robert Schwebel wrote:
> > On Wed, Jul 02, 2014 at 09:16:42PM +0200, Robert Schwebel wrote:
> > > > It would be really nice if the firmware was available in the
> > > > linux-firmware repository. Do you think this would be possible?
> > > > 
> > > > Best wishes,
> > > > -- 
> > > > Kamil Debski
> > > > Samsung R&D Institute Poland
> > > 
> > > I tried to convince Freescale to put the firmware into linux-firmware
> > > for 15 months now, but recently got no reply any more.
> > > 
> > > Fabio, Shawn, could you try to discuss this with the responsible folks
> > > inside FSL again? Maybe responsibilities have changed in the meantime
> > > and I might have tried to talk to the wrong people.
> > 
> > Any news?
> 
> Did you get some feedback? I didn't.

Jeff, does Freescale have concerns putting the MX6 CODA firmware into
the linux-firmware repository? If yes, it would be interesting to learn
about those and discuss the possibilities. 

Support for the CODA960 has been added to the mainline kernel in 3.16,
which is basically unusable without distributable firmware.

Please make it possible that your customers can actually use your
hardware.

Best regards,
Robert
-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
