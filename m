Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail-in-11.arcor-online.net ([151.189.21.51])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <hermann-pitton@arcor.de>) id 1KO1JS-0007sS-Ej
	for linux-dvb@linuxtv.org; Wed, 30 Jul 2008 04:21:18 +0200
From: hermann pitton <hermann-pitton@arcor.de>
To: Nico Sabbi <Nicola.Sabbi@poste.it>
In-Reply-To: <200807291516.38452.Nicola.Sabbi@poste.it>
References: <3a665c760807290538i76303879pfc3cbd5171c1c3a4@mail.gmail.com>
	<d9def9db0807290601w343469e4h5e33e7fe7924ca77@mail.gmail.com>
	<200807291516.38452.Nicola.Sabbi@poste.it>
Date: Wed, 30 Jul 2008 04:14:28 +0200
Message-Id: <1217384068.2671.11.camel@pc10.localdom.local>
Mime-Version: 1.0
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Where I can get the open sofware to play TS file?
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Hi,

Am Dienstag, den 29.07.2008, 15:16 +0200 schrieb Nico Sabbi: 
> On Tuesday 29 July 2008 15:01:39 Markus Rechberger wrote:
> > On Tue, Jul 29, 2008 at 2:38 PM, loody <miloody@gmail.com> wrote:
> > > Dear all:
> > > I study 13818-1 recently, but I cannot understand the whole flow
> > > of PCR, PTS and DTS.
> > > Would someone please tell me where I can get any open TS-player
> > > or part of source code which can help me to figure this part out?
> > > ps:I have check ffmpeg and vcl, and both of them seem cannot play
> > > TS directly.
> >
> > you could use mplayer.
> 
> it's the most messy player around and also the least academical ;)
> ffmpeg is much cleaner, but it doesn't expose how to use
> PCR wrt to DTS and PTS.

in many cases it is the best player around, the v4l2 implementation was
also always great, it is still most robust for A/V sync issues if you
are at hardware limits and it has unique features concerning dma audio.

> To make it short: you can consider the PCR your "wallclock",
> the DTS and the PTS are then timestamps when you should
> begin to decode and display, respectively.
> In a stream the DTS and PTS are always > PCR, thus you
> have to buffer packets (PES payloads) and dispatch each packet whose
> [PD]TS is <= last PCR seen to the respective decoder/player
> 

What works best is not finished at all. Compiled a lot.

Concerning shuffling around HDTV files from m$ vista, with full Nvidia
h.264/AVC hardware acceleration, seemingly no flaws there, to x86_64
linux and back on the other hand, there is no winner yet.

Cheers,
Hermann


 


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
