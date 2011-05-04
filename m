Return-path: <mchehab@pedra>
Received: from cmsout01.mbox.net ([165.212.64.31]:49767 "EHLO
	cmsout01.mbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750725Ab1EDNWc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 4 May 2011 09:22:32 -0400
Date: Wed, 04 May 2011 15:22:27 +0200
From: "Issa Gorissen" <flop.m@usa.net>
To: Lutz Sammer <johns98@gmx.net>
Subject: Re: TT-budget S2-3200 cannot tune on HB13E DVBS2 transponder
CC: <linux-media@vger.kernel.org>
Mime-Version: 1.0
Message-ID: <229PeDNVb2848S04.1304515347@web04.cms.usa.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

From: Lutz Sammer <johns98@gmx.net>
> On 05/04/11 01:16, Mauro Carvalho Chehab wrote:
> > Em 13-04-2011 21:05, Lutz Sammer escreveu:
> >>> On 05/04/11 21:07, Steffen Barszus wrote:
> >>>> On Tue, 05 Apr 2011 13:00:14 +0200
> >>>> "Issa Gorissen" <flop.m@xxxxxxx> wrote:
> >>>>
> >>>>> Hi,
> >>>>>
> >>>>> Eutelsat made a recent migration from DVB-S to DVB-S2 (since
> >>>>> 31/3/2011) on two transponders on HB13E
> >>>>>
> >>>>> - HOT BIRD 6 13� Est TP 159 Freq 11,681 Ghz DVB-S2 FEC 3/4 27500
> >>>>> Msymb/s 0.2 Pilot off Polar H
> >>>>>
> >>>>> - HOT BIRD 9 13� Est TP 99 Freq 12,692 Ghz DVB-S2 FEC 3/4 27500
> >>>>> Msymb/s 0.2 Pilot off Polar H
> >>>>>
> >>>>>
> >>>>> Before those changes, with my TT S2 3200, I was able to watch TV on
> >>>>> those transponders. Now, I cannot even tune on those transponders. I
> >>>>> have tried with scan-s2 and w_scan and the latest drivers from git.
> >>>>> They both find the transponders but cannot tune onto it.
> >>>>>
> >>>>> Something noteworthy is that my other card, a DuoFlex S2 can tune
> >>>>> fine on those transponders.
> >>>>>
> >>>>> My question is; can someone try this as well with a TT S2 3200 and
> >>>>> post the results ?
> >>>> i read something about it lately here (german!): 
> >>>>
http://www.vdr-portal.de/board16-video-disk-recorder/board85-hdtv-dvb-s2/p977938-stb0899-fec-3-4-tester-gesucht/#post977938
> >>>>
> >>>> It says in stb0899_drv.c function:
> >>>> static void stb0899_set_iterations(struct stb0899_state *state) 
> >>>>
> >>>> This:
> >>>> reg = STB0899_READ_S2REG(STB0899_S2DEMOD, MAX_ITER);
> >>>> STB0899_SETFIELD_VAL(MAX_ITERATIONS, reg, iter_scale);
> >>>> stb0899_write_s2reg(state, STB0899_S2DEMOD, STB0899_BASE_MAX_ITER,
STB0899_OFF0_MAX_ITER, reg);
> >>>>
> >>>> should be replaced with this:
> >>>>
> >>>> reg = STB0899_READ_S2REG(STB0899_S2FEC, MAX_ITER);
> >>>> STB0899_SETFIELD_VAL(MAX_ITERATIONS, reg, iter_scale);
> >>>> stb0899_write_s2reg(state, STB0899_S2FEC, STB0899_BASE_MAX_ITER,
STB0899_OFF0_MAX_ITER, reg);
> >>>>
> >>>> Basically replace STB0899_S2DEMOD with STB0899_S2FEC in this 2 lines
> >>>> affected.
> >>>>
> >>>> Kind Regards 
> >>>>
> >>>> Steffen
> >>> Hi Steffen,
> >>>
> >>> Unfortunately, it does not help in my case. Thx anyway.
> >>
> >> Try my locking fix. With above patch I can lock the
> >> channels without problem.
> > 
> > Can someone confirm that such patch would fix the issue? If so, please
> > forward it in a way that it could be applied (patch is currently
line-wrapped),
> > and submit with some comments/description and your SOB.
> > 
> > As the patch is currently broken, I'm just marking it as rejected at
patchwork.
> > 
> > Manu,
> > 
> > Please take a look on this trouble report.
> > 
> 
> Sorry, the things are mixed here. My patch (resend and hopefully this
> time not broken) handles only DVB-S transponders.
> 
> The FEC fix patch fixed locking on 11,681 Ghz, but not on 12,692 Ghz for
> me.  But I have very weak receiption,
> 
> Johns

Thank you Johns,

I got out of patience and reverted back to kernel 2.6.37. Added an amplifier
on the line and repositionned my dish. It works now. But very difficult to get
both Hotbird 6 and 9 sats! Maybe they transmit a weak signal ???

--
Issa

