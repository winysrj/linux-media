Return-path: <linux-media-owner@vger.kernel.org>
Received: from znsun1.ifh.de ([141.34.1.16]:43256 "EHLO znsun1.ifh.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752828AbZLARf0 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 1 Dec 2009 12:35:26 -0500
Date: Tue, 1 Dec 2009 18:35:23 +0100 (CET)
From: Patrick Boettcher <pboettcher@kernellabs.com>
To: Devin Heitmueller <dheitmueller@kernellabs.com>
cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Jon Smirl <jonsmirl@gmail.com>,
	Maxim Levitsky <maximlevitsky@gmail.com>, awalls@radix.net,
	dmitry.torokhov@gmail.com, j@jannau.net, jarod@redhat.com,
	jarod@wilsonet.com, khc@pm.waw.pl, linux-input@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	lirc-list@lists.sourceforge.net, superm1@ubuntu.com,
	Christoph Bartelmus <lirc@bartelmus.de>
Subject: Re: [RFC v2] Another approach to IR
In-Reply-To: <829197380912010909m59cb1078q5bd2e00af0368aaf@mail.gmail.com>
Message-ID: <alpine.LRH.2.00.0912011833070.11226@pub6.ifh.de>
References: <9e4733910912010708u1064e2c6mbc08a01293c3e7fd@mail.gmail.com>  <1259682428.18599.10.camel@maxim-laptop>  <9e4733910912010816q32e829a2uce180bfda69ef86d@mail.gmail.com>  <4B154C54.5090906@redhat.com>
 <829197380912010909m59cb1078q5bd2e00af0368aaf@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,
On Tue, 1 Dec 2009, Devin Heitmueller wrote:

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
>
> The fact that the driver currently uses the same lookup table for both
> types of remote controls however, was perhaps not the best design
> choice.  It really should be separated out, and merged with the
> regular ir-functions.c.  I just never got around to it.

I did not follow all the discussion, still I have a comment:

I will soon work on a device where it is the driver who is doing the 
decoding of the IR-frames. It is (maybe, I'm still missing some pieces to 
be sure) possible to receive different protocols at the same time with 
this hardware.

--

Patrick 
http://www.kernellabs.com/
