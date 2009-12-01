Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:35025 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752375AbZLARak (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 1 Dec 2009 12:30:40 -0500
Message-ID: <4B155288.1060509@redhat.com>
Date: Tue, 01 Dec 2009 15:29:44 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Devin Heitmueller <dheitmueller@kernellabs.com>
CC: Jon Smirl <jonsmirl@gmail.com>,
	Maxim Levitsky <maximlevitsky@gmail.com>, awalls@radix.net,
	dmitry.torokhov@gmail.com, j@jannau.net, jarod@redhat.com,
	jarod@wilsonet.com, khc@pm.waw.pl, linux-input@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	lirc-list@lists.sourceforge.net, superm1@ubuntu.com,
	Christoph Bartelmus <lirc@bartelmus.de>
Subject: Re: [RFC v2] Another approach to IR
References: <9e4733910912010708u1064e2c6mbc08a01293c3e7fd@mail.gmail.com>	 <1259682428.18599.10.camel@maxim-laptop>	 <9e4733910912010816q32e829a2uce180bfda69ef86d@mail.gmail.com>	 <4B154C54.5090906@redhat.com> <829197380912010909m59cb1078q5bd2e00af0368aaf@mail.gmail.com>
In-Reply-To: <829197380912010909m59cb1078q5bd2e00af0368aaf@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Devin Heitmueller wrote:
> On Tue, Dec 1, 2009 at 12:03 PM, Mauro Carvalho Chehab
> <mchehab@redhat.com> wrote:
>> Just taking an example from the dibcom0700 driver (as the same driver
>> supports several different RC5 and NEC codes at the same time),
>> the kernel table has several keycodes added there, all working
>> at the same time. Providing that the scancodes won't overlap, you can
>> map two different scancodes (from different IR's) to return the same
>> keycode (table is not complete - I just got a few common keycodes):
> 
> Mauro,
> 
> Just to be clear, the dib0700 does not actually support receiving RC5
> or NEC codes at the same time.  You have to tell the chip which mode
> to operate in, via a REQUEST_SET_RC to the firmware (see
> dib0700_core.c:405).  The em28xx works the same way (you have to tell
> it what type of IR format to receive).

Yes, I know. I have a dib0700-based device that came with a NEC table, and
I had to fix the driver to work with NEC on newer (1.20) firmwares and add the
corresponding table for my NEC IR. Still I prefer to use this device with a
RC5 IR from another manufacturer ;)

Yet, the same table works on my device with the shipped IR and with some
other RC5 IR's I have. Due to the lack of an API to select the IR standard,
I need to reload the module, passing a different modprobe parameter, to
set it to either mode.

> The fact that the driver currently uses the same lookup table for both
> types of remote controls however, was perhaps not the best design
> choice.  It really should be separated out, and merged with the
> regular ir-functions.c.  I just never got around to it.

I'm not sure if splitting the table on two would be the better way.

For sure we need to add an EVIOSETPROTO ioctl to allow the driver 
to change the protocol in runtime.

If we'll keep using the same table, all an userspace app need is to say what's
the desired IR mode. On the other hand, it should be easy for the application
to also replace the table when a different protocol is selected.

The point that I want to bold is that it is possible to use one big table to
support several different IR's at the same time. This may be a good solution for
devices that were shipped with more than one different IR models. It may also
be a good solution to avoid having a large number of keymaps, as we may consolidate
commonly used IR's on an unique table (or on a few groups of tables).

Cheers,
Mauro.


