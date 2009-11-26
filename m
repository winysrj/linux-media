Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail5.sea5.speakeasy.net ([69.17.117.7]:59516 "EHLO
	mail5.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752922AbZKZXJw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 26 Nov 2009 18:09:52 -0500
Date: Thu, 26 Nov 2009 15:09:58 -0800 (PST)
From: Trent Piepho <xyzzy@speakeasy.org>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
cc: Christoph Bartelmus <lirc@bartelmus.de>, dmitry.torokhov@gmail.com,
	j@jannau.net, jarod@redhat.com, khc@pm.waw.pl,
	linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org, superm1@ubuntu.com
Subject: Re: [RFC] Should we create a raw input interface for IR's ? - Was:
 Re: [PATCH 1/3 v2] lirc core device driver infrastructure
In-Reply-To: <4B0EEC21.9010001@redhat.com>
Message-ID: <Pine.LNX.4.58.0911261505120.30284@shell2.speakeasy.net>
References: <BDcc3mfojFB@christoph> <4B0EEC21.9010001@redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 26 Nov 2009, Mauro Carvalho Chehab wrote:
> >> lircd supports input layer interface. Yet, patch 3/3 exports both devices
> >> that support only pulse/space raw mode and devices that generate scan
> >> codes via the raw mode interface. It does it by generating artificial
> >> pulse codes.
> >
> > Nonsense! There's no generation of artificial pulse codes in the drivers.
> > The LIRC interface includes ways to pass decoded IR codes of arbitrary
> > length to userspace.
>
> I might have got wrong then a comment in the middle of the
> imon_incoming_packet() of the SoundGraph iMON IR patch:
>
> +	/*
> +	 * Translate received data to pulse and space lengths.
> +	 * Received data is active low, i.e. pulses are 0 and
> +	 * spaces are 1.

I'm not sure about this specific code, but what is likely
going on here is the waveform is being RLE encoding.

For example, a cx88 receiver has two ways of being connected (without
using an external decoder chip).  One generates an IRQ on each
edge of the signal.  The time between IRQs gives mark/space lengths
which is what lirc expects.  This is how a simple serial port receiver
works too.

Another connections effectivly samples the waveform one bit deep at IIRC
4kHz.  I think that's what the code you are looking at gets.  The code
extracts the edges from the waveform and returns the time between them.  In
effect one is run length encoding a sequence of bits.
