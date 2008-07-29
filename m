Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from relay-pt1.poste.it ([62.241.4.164])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <Nicola.Sabbi@poste.it>) id 1KNp3j-00033C-SU
	for linux-dvb@linuxtv.org; Tue, 29 Jul 2008 15:16:12 +0200
Received: from nico2.od.loc (89.97.249.170) by relay-pt1.poste.it (7.3.122)
	(authenticated as Nicola.Sabbi@poste.it)
	id 488E5E01000090C0 for linux-dvb@linuxtv.org;
	Tue, 29 Jul 2008 15:16:07 +0200
From: Nico Sabbi <Nicola.Sabbi@poste.it>
To: linux-dvb@linuxtv.org
Date: Tue, 29 Jul 2008 15:16:38 +0200
References: <3a665c760807290538i76303879pfc3cbd5171c1c3a4@mail.gmail.com>
	<d9def9db0807290601w343469e4h5e33e7fe7924ca77@mail.gmail.com>
In-Reply-To: <d9def9db0807290601w343469e4h5e33e7fe7924ca77@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200807291516.38452.Nicola.Sabbi@poste.it>
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

On Tuesday 29 July 2008 15:01:39 Markus Rechberger wrote:
> On Tue, Jul 29, 2008 at 2:38 PM, loody <miloody@gmail.com> wrote:
> > Dear all:
> > I study 13818-1 recently, but I cannot understand the whole flow
> > of PCR, PTS and DTS.
> > Would someone please tell me where I can get any open TS-player
> > or part of source code which can help me to figure this part out?
> > ps:I have check ffmpeg and vcl, and both of them seem cannot play
> > TS directly.
>
> you could use mplayer.

it's the most messy player around and also the least academical ;)
ffmpeg is much cleaner, but it doesn't expose how to use
PCR wrt to DTS and PTS. 
To make it short: you can consider the PCR your "wallclock",
the DTS and the PTS are then timestamps when you should
begin to decode and display, respectively.
In a stream the DTS and PTS are always > PCR, thus you
have to buffer packets (PES payloads) and dispatch each packet whose
[PD]TS is <= last PCR seen to the respective decoder/player

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
