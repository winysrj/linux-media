Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-07.arcor-online.net ([151.189.21.47]:60516 "EHLO
	mail-in-07.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751131Ab0BKBIA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Feb 2010 20:08:00 -0500
Subject: Re: Fwd: Re: FM radio problem with HVR1120
From: hermann pitton <hermann-pitton@arcor.de>
To: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Michael Krufky <mkrufky@kernellabs.com>
Cc: ftape-jlc@club-internet.fr,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
In-Reply-To: <4B733321.40803@redhat.com>
References: <201001252029.12009.ftape-jlc@club-internet.fr>
	 <4B733321.40803@redhat.com>
Content-Type: text/plain
Date: Thu, 11 Feb 2010 02:07:56 +0100
Message-Id: <1265850476.4422.25.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Am Mittwoch, den 10.02.2010, 20:28 -0200 schrieb Mauro Carvalho Chehab:
> Hi,
> 
> ftape-jlc wrote:
> > Hello,
> > 
> > I didn't received any message about radio on HVR1120.
> > I just want to know if the use /dev/radio0 is deprecated in v4l2 today.
> > In the mails, I only read messages about video or TV.
> 
> No, it is not deprecated.
> 
> > Did one user of the mailing list have tested actual v4l2 on /dev/radio0 ?
> 
> Yes. It works with several devices. Maybe there's a bug at the radio entry
> for your board.
> 
> >> The problem is to listen radio.
> >> With Linux, the command used is
> >> /usr/bin/radio -c /dev/radio0
> >> in association with
> >> sox -t ossdsp -r 32000 -c 2 /dev/dsp1 -t ossdsp /dev/dsp
> >> to listen the sound.
> >>
> >> The result is an unstable frecuency. The station is not tuned. Stereo is
> >> permanently switching to mono.
> >> The 91.5MHz station is mixed permanently with other stations.
> 
> This probably means that the GPIO setup for your board is wrong for radio.
> Only someone with a HVR1120 could fix it, since the GPIO's are board-specific.
> 
> The better is if you could try to do it. It is not hard. Please take a look at:
>  
> http://linuxtv.org/wiki/index.php/GPIO_pins
> 
> You'll need to run the regspy.exe utility (part of Dscaler package), and check
> how the original driver sets the GPIO registers. Then edit them on your board
> entry, at saa78134-cards.c, recompile the driver and test.
> 
> The better is to use the out-of-tree mercuiral tree:
> 	http://linuxtv.org/hg/v4l-dvb
> 
> since it allows you to recompile and test without needing to replace your kernel.
> 

Mauro, without looking at anything, everything above 1110 can have the
newer tuners and analog demods and on the radio is ongoing work.

We need to ask Mike for the latest status or try to look it up.

I doubt you come further with the regspy stuff.

Cheers,
Hermann


