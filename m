Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:54799 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751467AbZGVOsK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 22 Jul 2009 10:48:10 -0400
Date: Wed, 22 Jul 2009 11:48:01 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Jelle de Jong <jelledejong@powercraft.nl>
Cc: "linux-media@vger.kernel.org >> \"linux-media@vger.kernel.org\""
	<linux-media@vger.kernel.org>
Subject: Re: offering bounty for GPL'd dual em28xx support
Message-ID: <20090722114801.6b4ea47d@pedra.chehab.org>
In-Reply-To: <4A66E59E.9040502@powercraft.nl>
References: <4A6666CC.7020008@eyemagnet.com>
	<829197380907211842p4c9886a3q96a8b50e58e63cbf@mail.gmail.com>
	<4A66E59E.9040502@powercraft.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 22 Jul 2009 12:10:38 +0200
Jelle de Jong <jelledejong@powercraft.nl> escreveu:

> Devin Heitmueller wrote:
> 
> <snip>
> 
> > The issue occurs with various different drivers.  Basically the issue
> > is the device attempts to reserve a certain amount of bandwidth on the
> > USB bus for the isoc stream, and in the case of analog video at
> > 640x480 this adds up to about 200Mbps.  As a result, connecting
> > multiple devices can result in exceeding the available bandwidth on
> > the USB bus.
> > 
> > Depending on your how many devices you are trying to connect, what
> > your target capture resolution is, and whether you can put each device
> > on its own USB bus will dictate what solution you can go with.
> 
> Hi all,
> 
> So I felt like doing  a field test, with my dvb-t test system.
> 
> Bus 001 Device 008: ID 2040:6502 Hauppauge WinTV HVR-900
> Bus 001 Device 007: ID 2304:0226 Pinnacle Systems, Inc. [hex] PCTV 330e
> Bus 001 Device 005: ID 0b05:173f ASUSTek Computer, Inc.
> Bus 001 Device 003: ID 2304:0236 Pinnacle Systems, Inc. [hex]
> Bus 001 Device 002: ID 15a4:9016
> 
> I have now three devices with dvb-t channels running with different
> channels and audio on an atom based cpu without problems.
> 
> two:
> dvb-usb-dib0700
> 
> and one:
> dvb-usb-af9015
> 
> the dvb-usb-af9015 takes way more cpu interrupts because of the usb
> block size.
> 
> prove:
> http://imagebin.ca/img/xM9Q7_A.jpg
> 
> I will be demonstrating this at har2009 (see demonstration village)
> 
> Devin could you login onto the dvb-t test system and see if you can get
> those em28xx device running with your new code?
> 
> I will probably make an other test system with some more cpu power to
> see if even more usb devices are possible, or I may use my nice powerful
> multiseat quad core system for it.
> 
> Best regards,
> 
> Jelle de Jong

Jelle,

DVB-T is less consuming than analog, since the streams are mpeg compressed. The
issue with em28xx is that, on analog mode, all data come uncompressed. So, the
worse case is a NTSC stream with 16 bit YUY2 frame with using 720x480x30x2 Mbps (e. g.
207 Mbps) for the payload, plus some additional bandwidth for the transport
headers. On HD, mpeg stream are up to 23 Mbps on DTV systems (ISDB full-seg is the
worse case on DTV).

So, analog demands about 9x more bandwidth than digital at USB bus.



Cheers,
Mauro
