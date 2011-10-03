Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:55458 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752001Ab1JCWA4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 3 Oct 2011 18:00:56 -0400
From: =?iso-8859-1?Q?S=E9bastien_RAILLARD_=28COEXSI=29?= <sr@coexsi.fr>
To: "'Issa Gorissen'" <flop.m@usa.net>, <o.endriss@gmx.de>
Cc: "'Linux Media Mailing List'" <linux-media@vger.kernel.org>
References: <533PJcN7P6848S01.1317650355@web01.cms.usa.net> <006f01cc81db$2dfdf220$89f9d660$@coexsi.fr>
In-Reply-To: <006f01cc81db$2dfdf220$89f9d660$@coexsi.fr>
Subject: RE: [DVB] CXD2099 - Question about the CAM clock
Date: Tue, 4 Oct 2011 00:00:53 +0200
Message-ID: <008301cc8217$ec0ff830$c42fe890$@coexsi.fr>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Language: fr
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



> -----Original Message-----
> From: linux-media-owner@vger.kernel.org [mailto:linux-media-
> owner@vger.kernel.org] On Behalf Of Sébastien RAILLARD (COEXSI)
> Sent: lundi 3 octobre 2011 16:46
> To: 'Issa Gorissen'; o.endriss@gmx.de
> Cc: 'Linux Media Mailing List'
> Subject: RE: [DVB] CXD2099 - Question about the CAM clock
> 
> 
> 
> > -----Original Message-----
> > From: Issa Gorissen [mailto:flop.m@usa.net]
> > Sent: lundi 3 octobre 2011 15:59
> > To: o.endriss@gmx.de; Sébastien RAILLARD
> > Cc: 'Linux Media Mailing List'
> > Subject: RE: [DVB] CXD2099 - Question about the CAM clock
> >
> > > >
> > > > > Dear Oliver,
> > > > >
> > > > > I’ve done some tests with the CAM reader from Digital Devices
> > > > > based on
> > > > Sony
> > > > > CXD2099 chip and I noticed some issues with some CAM:
> > > > > * SMIT CAM    : working fine
> > > > > * ASTON CAM   : working fine, except that it's crashing quite
> > > > regularly
> > > > > * NEOTION CAM : no stream going out but access to the CAM menu
> > > > > is ok
> > > > >
> > > > > When looking at the CXD2099 driver code, I noticed the CAM clock
> > > > > (fMCLKI)
> > > > is
> > > > > fixed at 9MHz using the 27MHz onboard oscillator and using the
> > > > > integer divider set to 3 (as MCLKI_FREQ=2).
> > > > >
> > > > > I was wondering if some CAM were not able to work correctly at
> > > > > such high clock frequency.
> > > > >
> > > > > So, I've tried to enable the NCO (numeric controlled oscillator)
> > > > > in order
> > > > to
> > > > > setup a lower frequency for the CAM clock, but I wasn't
> > > > > successful, it's looking like the frequency must be around the
> > > > > 9MHz or I can't get any stream.
> > > > >
> > > > > Do you know a way to decrease this CAM clock frequency to do
> > > > > some
> > > > testing?
> > > > >
> > > > > Best regards,
> > > > > Sebastien.
> > > >
> > > > Weird that the frequency would pose a problem for those CAMs. The
> > > > CI spec [1] explains that the minimum byte transfer clock period
> > > > must be 111ns. This gives us a frequency of ~9MHz.
> > > >
> > >
> > > You're totally right about the maximum clock frequency specified in
> > > the norm, but I had confirmation from CAM manufacturers that their
> > > CAM may not work correctly up to this maximum frequency.
> > >
> > > Usually, the CAM clock is coming from the input TS stream and I
> > > don't think there is for now a DVB-S2 transponder having a 72mbps
> > > bitrate (so a 9MHz
> > for
> > > parallel CAM clocking).
> > >
> > > > Anyway, wouldn't it be wiser to base MCLKI on TICLK ?
> > > >
> > >
> > > I've tried to use mode C instead of mode D, and I have the same
> > > problem, so I guess TICLK is around 72MHz.
> > >
> > > It could be a good idea to use TICLK, but I don't know the value and
> > > if the clock is constant or only active during data transmission.
> > >
> > >
> > > Did you manage to enable and use the NCO of the CXD2099 (instead of
> > > the integer divider) ?
> >
> > No, but if your output to the CAM is slower than what comes from the
> > ngene chip, you will lose bytes, no ?
> 
> The real bandwidth of my transponder is 62mbps, so I've room to decrease
> the CAM clock.
> 
> I did more tests with the NCO, and I've strange results:
> * Using MCLKI=0x5553 => fMCLKI= 8,99903 => Not working, a lot of TS
> errors
> * Using MCLKI=0x5554 => fMCLKI= 8,99945 => Working fine
> * Using MCLKI=0x5555 => fMCLKI= 8,99986 => Not working, a lot of TS
> errors
> 
> It's strange that changing very slightly the clock make so much errors!
> 

I managed to find a series of values that are working correctly for MCLKI:

MCLKI = 0x5554 - i * 0x0c

In my case I can go down to 0x5338 before having TS errors.

> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media"
> in the body of a message to majordomo@vger.kernel.org More majordomo
> info at  http://vger.kernel.org/majordomo-info.html

