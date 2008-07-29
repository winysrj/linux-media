Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from vds2011.yellis.net ([79.170.233.11])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <frederic.cand@anevia.com>) id 1KNrnb-0002ks-4P
	for linux-dvb@linuxtv.org; Tue, 29 Jul 2008 18:11:43 +0200
Message-ID: <488F4135.1070505@anevia.com>
Date: Tue, 29 Jul 2008 18:11:33 +0200
From: Frederic CAND <frederic.cand@anevia.com>
MIME-Version: 1.0
To: Nico Sabbi <Nicola.Sabbi@poste.it>
References: <3a665c760807290538i76303879pfc3cbd5171c1c3a4@mail.gmail.com>	<d9def9db0807290601w343469e4h5e33e7fe7924ca77@mail.gmail.com>
	<200807291516.38452.Nicola.Sabbi@poste.it>
In-Reply-To: <200807291516.38452.Nicola.Sabbi@poste.it>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Where I can get the open sofware to play TS file?
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Nico Sabbi a =E9crit :
> On Tuesday 29 July 2008 15:01:39 Markus Rechberger wrote:
>> On Tue, Jul 29, 2008 at 2:38 PM, loody <miloody@gmail.com> wrote:
>>> Dear all:
>>> I study 13818-1 recently, but I cannot understand the whole flow
>>> of PCR, PTS and DTS.
>>> Would someone please tell me where I can get any open TS-player
>>> or part of source code which can help me to figure this part out?
>>> ps:I have check ffmpeg and vcl, and both of them seem cannot play
>>> TS directly.
>> you could use mplayer.
> =

> it's the most messy player around and also the least academical ;)
> ffmpeg is much cleaner, but it doesn't expose how to use
> PCR wrt to DTS and PTS. =

> To make it short: you can consider the PCR your "wallclock",
> the DTS and the PTS are then timestamps when you should
> begin to decode and display, respectively.
> In a stream the DTS and PTS are always > PCR, thus you
> have to buffer packets (PES payloads) and dispatch each packet whose
> [PD]TS is <=3D last PCR seen to the respective decoder/player
> =


Btw if vlc can't play a TS file then there's a problem in your computer =

since I've been using it for a very long time and it works perfectly =

fine to me (able to read a full TS from DVB-S, Demux it, presents the =

list of the services within the stream on the top menu, a.s.o.)

-- =

CAND Frederic
Product Manager
ANEVIA

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
