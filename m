Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:42161 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759174Ab1JFVVR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 6 Oct 2011 17:21:17 -0400
From: =?iso-8859-1?Q?S=E9bastien_RAILLARD_=28COEXSI=29?= <sr@coexsi.fr>
To: "'Manu Abraham'" <abraham.manu@gmail.com>,
	"'Mauro Carvalho Chehab'" <mchehab@redhat.com>
Cc: "'Lutz Sammer'" <johns98@gmx.net>, <linux-media@vger.kernel.org>
References: <4DA63A66.1070300@gmx.net>	<4DC08CB8.3020105@redhat.com>	<4DC13823.7000700@gmx.net>	<4E7A1481.1090205@redhat.com> <CAHFNz9K3kAVeH=um-9yts4UkehUf9x=-C_3pfdhR5c4qZ4euvw@mail.gmail.com>
In-Reply-To: <CAHFNz9K3kAVeH=um-9yts4UkehUf9x=-C_3pfdhR5c4qZ4euvw@mail.gmail.com>
Subject: RE: TT-budget S2-3200 cannot tune on HB13E DVBS2 transponder
Date: Thu, 6 Oct 2011 23:21:16 +0200
Message-ID: <014e01cc846d$e309e540$a91dafc0$@coexsi.fr>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Language: fr
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



> -----Original Message-----
> From: linux-media-owner@vger.kernel.org [mailto:linux-media-
> owner@vger.kernel.org] On Behalf Of Manu Abraham
> Sent: mercredi 21 septembre 2011 19:53
> To: Mauro Carvalho Chehab
> Cc: Lutz Sammer; linux-media@vger.kernel.org
> Subject: Re: TT-budget S2-3200 cannot tune on HB13E DVBS2 transponder
> 
> Mauro,
> 
> On Wed, Sep 21, 2011 at 10:14 PM, Mauro Carvalho Chehab
> <mchehab@redhat.com> wrote:
> > Em 04-05-2011 08:27, Lutz Sammer escreveu:
> >> On 05/04/11 01:16, Mauro Carvalho Chehab wrote:
> >>> Em 13-04-2011 21:05, Lutz Sammer escreveu:
> >>>>> On 05/04/11 21:07, Steffen Barszus wrote:
> >>>>>> On Tue, 05 Apr 2011 13:00:14 +0200 "Issa Gorissen"
> >>>>>> <flop.m@xxxxxxx> wrote:
> >>>>>>
> >>>>>>> Hi,
> >>>>>>>
> >>>>>>> Eutelsat made a recent migration from DVB-S to DVB-S2 (since
> >>>>>>> 31/3/2011) on two transponders on HB13E
> >>>>>>>
> >>>>>>> - HOT BIRD 6 13° Est TP 159 Freq 11,681 Ghz DVB-S2 FEC 3/4 27500
> >>>>>>> Msymb/s 0.2 Pilot off Polar H
> >>>>>>>
> >>>>>>> - HOT BIRD 9 13° Est TP 99 Freq 12,692 Ghz DVB-S2 FEC 3/4 27500
> >>>>>>> Msymb/s 0.2 Pilot off Polar H
> >>>>>>>
> >>>>>>>
> >>>>>>> Before those changes, with my TT S2 3200, I was able to watch TV
> >>>>>>> on those transponders. Now, I cannot even tune on those
> >>>>>>> transponders. I have tried with scan-s2 and w_scan and the
> latest drivers from git.
> >>>>>>> They both find the transponders but cannot tune onto it.
> >>>>>>>
> >>>>>>> Something noteworthy is that my other card, a DuoFlex S2 can
> >>>>>>> tune fine on those transponders.
> >>>>>>>
> >>>>>>> My question is; can someone try this as well with a TT S2 3200
> >>>>>>> and post the results ?
> >>>>>> i read something about it lately here (german!):
> >>>>>> http://www.vdr-portal.de/board16-video-disk-recorder/board85-hdtv
> >>>>>> -dvb-s2/p977938-stb0899-fec-3-4-tester-gesucht/#post977938
> >>>>>>
> >>>>>> It says in stb0899_drv.c function:
> >>>>>> static void stb0899_set_iterations(struct stb0899_state *state)
> >>>>>>
> >>>>>> This:
> >>>>>> reg = STB0899_READ_S2REG(STB0899_S2DEMOD, MAX_ITER);
> >>>>>> STB0899_SETFIELD_VAL(MAX_ITERATIONS, reg, iter_scale);
> >>>>>> stb0899_write_s2reg(state, STB0899_S2DEMOD,
> >>>>>> STB0899_BASE_MAX_ITER, STB0899_OFF0_MAX_ITER, reg);
> >>>>>>
> >>>>>> should be replaced with this:
> >>>>>>
> >>>>>> reg = STB0899_READ_S2REG(STB0899_S2FEC, MAX_ITER);
> >>>>>> STB0899_SETFIELD_VAL(MAX_ITERATIONS, reg, iter_scale);
> >>>>>> stb0899_write_s2reg(state, STB0899_S2FEC, STB0899_BASE_MAX_ITER,
> >>>>>> STB0899_OFF0_MAX_ITER, reg);
> >>>>>>
> >>>>>> Basically replace STB0899_S2DEMOD with STB0899_S2FEC in this 2
> >>>>>> lines affected.
> >>>>>>
> >>>>>> Kind Regards
> >>>>>>
> >>>>>> Steffen
> >>>>> Hi Steffen,
> >>>>>
> >>>>> Unfortunately, it does not help in my case. Thx anyway.
> >>>>
> >>>> Try my locking fix. With above patch I can lock the channels
> >>>> without problem.
> >>>
> >>> Can someone confirm that such patch would fix the issue? If so,
> >>> please forward it in a way that it could be applied (patch is
> >>> currently line-wrapped), and submit with some comments/description
> and your SOB.
> >>>
> >>> As the patch is currently broken, I'm just marking it as rejected at
> patchwork.
> >>>
> >>> Manu,
> >>>
> >>> Please take a look on this trouble report.
> >>>
> >>
> >> Sorry, the things are mixed here. My patch (resend and hopefully this
> >> time not broken) handles only DVB-S transponders.
> >>
> >> The FEC fix patch fixed locking on 11,681 Ghz, but not on 12,692 Ghz
> >> for me.  But I have very weak receiption,
> >>

We did a lot of experiments with this card and these 2 transponders, and
here is what you need:
* The dish must be perfectly oriented
* Check carefully the X-pol (LNB rotation)
* Be careful that all the LNB are not equal: we managed to get good results
with some LNBs and never manage to have reception with other models of LNB
* It seems that the DVB-S2 demodulator (that is quite old now) in this card
is very sensitive to bad signals and maybe sensitive to cross polarization
more than other demodulators.

So make a short answer: to correct the issues with these specifics
transponders and this card, we first do a fine dish/LND orientation and then
change the LNB, usually, it's enough. Specific measurement tool is needed to
make good work.

Finally, it isn't that much a driver problem in my opinion.

> >> Johns
> >
> > Manu,
> >
> > We're still missing your review on this patch[1], or it were
> > eventually missed. Please review it.
> >
> > Thanks,
> > Mauro
> >
> > [1] http://patchwork.linuxtv.org/patch/6511/
> >
> 
> Patch is good and correct. Thanks.
> Reviewed-by: Manu Abraham <manu@linuxtv.org>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media"
> in the body of a message to majordomo@vger.kernel.org More majordomo
> info at  http://vger.kernel.org/majordomo-info.html

