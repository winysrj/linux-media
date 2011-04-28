Return-path: <mchehab@pedra>
Received: from casper.infradead.org ([85.118.1.10]:46406 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751213Ab1D1Cx6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Apr 2011 22:53:58 -0400
Message-ID: <4DB8D6C1.2000301@infradead.org>
Date: Wed, 27 Apr 2011 23:53:53 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
MIME-Version: 1.0
To: a b <mjnhbg1@gmail.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: Some major problems of em28xx chip base TV devices in linux
References: <BANLkTim8fuuOC-56nPY=sJrCaY7kKOydYA@mail.gmail.com>	<4DB832B4.1060608@infradead.org> <BANLkTik15r_5eP64j8rjA70LSB3L_uiFmQ@mail.gmail.com>
In-Reply-To: <BANLkTik15r_5eP64j8rjA70LSB3L_uiFmQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 27-04-2011 18:29, a b escreveu:
> 

> Hello Mauro and thanks But,
> 
> because of my testings, i guess most of problems are in the kernel space not the user space, and my asking for your help was because of that matter. and i though that those log files and information files attached to my previous e-mail, can help you as a developer of some parts of related kernel drivers, to finding the problems is a short time, to solve them.
> 
>     Please don't think about correcting the problems by myself, because it is obvious that any one that worked on em28xx driver, can find and fix the problems, for more than 10 times faster than me, because i have not worked on this driver at all. And also if i want to do so, i first must learn two considerable matter: a- the DVB structure and its packets' protocols ( that is not little thing), b- the manner of the em28xx and xc2038 chips ( that is not little thing too).  :-(
> 
> i am waiting for your help, and i can do some tests that you need, but if you notice exactly to my hardware and linuxes (explained in before e-mail) , you see that you can prepare the same test bed for you, easily.


Let me explain how things work:

The tuner (xc3028) just tunes into some frequency.

The demod basically decodes the DVB carriers and provide some stats showing
that DVB carriers were properly locked/decoded. Some demods also provide DVB Program ID
filtering.

For DVB, all that em28xx does is to serve as a bridge between the PCI bus, the DVB
streams and the board internal bus to control the demod/tuner.

A working DVB driver (tuner+demod+bridge) will just provide a MPEG-TS stream to the userspace
application, and let it do the DVB processing.

The userspace application is responsible to open the MPEG-TS packets and extract the required info
from it (service provider, Program ID's, program name, video stream, audio stream), and to decode 
the video and audio streams according to MPEG2 Video/MPEG2 audio (or whatever video/audio standard
is used by your TV broadcasters).

So, basically, the userspace app should implement the hardest part, based on the ETSI and MPEG 
standards.

According to what you've said, with Kaffeine, you're able to watch to channels. That means 
that tuner, demod and bridge are working. You also said that you tested other boards and noticed
the same trouble. So, it doesn't look like a driver issue. The DVB drivers are well tested in
Europe, where ETSI is fully used. There aren't many DVB developers outside Europe, so locale 
adjustments is sometimes needed. For example, I needed to adjust some things at the DVB applications
I care, in order to fix some decoding stuff on DVB-C and DVB-S due to some differences on the way
the spec is used in Brazil, and to be able to use some LNBf types found here.

You also said that the DVB operators you're listening don't fully follow the ETSI and/or MPEG specs.
As such, the userspace application needs to have some extra logic to understand the differences
between the standards and what the broadcasters are doing. This is probably standardized (at least
for DVB-T) on some docs from your Country's TV Boureau.

That's why only someone with access to such specs and capable of receiving the signals available
there will be capable of adding the extra decoding stuff into the existing applications.

Ah, with respect to the high CPU used on it, this is due to software MPEG-2 decoding. Some applications
like VLC will use your GPU to decode MPEG2, decreasing a lot the amount of load on the CPU, depending
on the video board and X11 driver that you're using. An special configuration is geneally needed, in
order to enable vdpau and similar technologies.

Mauro.


PS.: Please don't remove the C/C to the linux-media ML, as others may have similar issues, or may
have already worked on some solution/workaround.
