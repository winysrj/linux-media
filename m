Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:46721 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935421Ab1JFU3n (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 6 Oct 2011 16:29:43 -0400
From: =?iso-8859-1?Q?S=E9bastien_RAILLARD_=28COEXSI=29?= <sr@coexsi.fr>
To: "'Issa Gorissen'" <flop.m@usa.net>, <o.endriss@gmx.de>
Cc: "'Linux Media Mailing List'" <linux-media@vger.kernel.org>
References: <198PJDL451344S01.1317729416@web01.cms.usa.net>
In-Reply-To: <198PJDL451344S01.1317729416@web01.cms.usa.net>
Subject: RE: [DVB] CXD2099 - Question about the CAM clock
Date: Thu, 6 Oct 2011 22:29:42 +0200
Message-ID: <014801cc8466$aec776a0$0c5663e0$@coexsi.fr>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Language: fr
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



> -----Original Message-----
> From: Issa Gorissen [mailto:flop.m@usa.net]
> Sent: mardi 4 octobre 2011 13:57
> To: o.endriss@gmx.de; sr@coexsi.fr
> Cc: 'Linux Media Mailing List'
> Subject: RE: [DVB] CXD2099 - Question about the CAM clock
> 
> >
> > I managed to find a series of values that are working correctly for
> MCLKI:
> >
> > MCLKI = 0x5554 - i * 0x0c
> >
> > In my case I can go down to 0x5338 before having TS errors.
> >
> 
> From CXD2099 specs
> --
> It is a requirement for the frequency of MCLKI to be set higher than the
> input data rate. ie 8 times TICLK. If this condition is not met then the
> internal buffer will overflow and the register TSIN_FIFO_OVFL is set to
> 1. This register should be read at regular intervals to ensure reliable
> operation.
> --
> 
> Watch out that you're not slowly overflowing the internal buffer if
> MCLKI is not fast enough...

That's the problem, if the input clock can't be slowed down...
I didn't find any parameters that allows for decreasing the clock.

> 
> Are you working with the ddbridge ?

Yes, I'm working with the ddbridge (lattice)

> 
> --
> Issa


