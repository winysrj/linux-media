Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp119.rog.mail.re2.yahoo.com ([68.142.224.74]:27673 "HELO
	smtp119.rog.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752752AbZBVVBp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 22 Feb 2009 16:01:45 -0500
Message-ID: <49A1BD37.6010606@rogers.com>
Date: Sun, 22 Feb 2009 16:01:43 -0500
From: CityK <cityk@rogers.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
CC: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] [Bulk]  Problem with TV card's sound (SAA7134)
References: <BAY111-W598DBD904310E159C109CC5B40@phx.gbl>	<499CD588.8030104@rogers.com> <BAY111-W30090D901B75228887D50BC5B20@phx.gbl>
In-Reply-To: <BAY111-W30090D901B75228887D50BC5B20@phx.gbl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

panagiotis takis_rs wrote:
> > panagiotis takis_rs wrote:
> > > Hey!!
> > >
> > > I have a problem with my tv card(pinnacle pctv 310i)
> > > I can see image but i have no sound.
> > > I have tried both tvtime and kdetv.
> > >
> > > I have found this http://ubuntuforums.org/showthread.php?t=568528
> . Is it related with my problem?
> > >
> > > My tv card give audio output with this way: direct cable
> connection from
> > > tv card to sound card ( same cable witch connect cdrom and soundcard )
> >
> > I didn't read through the link you provided, but it appeared to be in
> > regards to getting audio via DMA (using the card's 7134 chip to digitize
> > the audio and send it over the PCI bus to the host system). You, on the
> > other hand, indicate that you are attempting to use the method of
> > running a patch cable between your TV card and sound card (meaning that
> > the sound card will do the digitizing instead). Question: have you
> > checked your audio mixer to make sure that any of the inputs are not
> muted?
>
> Yes i have.
> The only way i managed to get sound is these two commands:
>
>  tvtime | arecord -D hw:2,0 -r 32000 -c 2 -f S16_LE | aplay -  (out of
> sync)
>
> tvtime | sox -r 32000 -t alsa hw:2,0 -t alsa hw:0,1 | aplay -


Which, as you likely know, is essentially going the DMA route and using
the helper apps (sox, arecord) as tvtime currently doesn't support audio
DMA.

Hmm, if everything is unmuted, I have no idea why it isn't working
simply via your patch cable ... last stab at this --> how about the
leads on the patch cable itself; have you tried reversing the way one of
the ends is plugged in?
