Return-path: <linux-media-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.25]:47053 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752024AbZLYJv7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 25 Dec 2009 04:51:59 -0500
Received: by ey-out-2122.google.com with SMTP id 25so857199eya.19
        for <linux-media@vger.kernel.org>; Fri, 25 Dec 2009 01:51:58 -0800 (PST)
Date: Fri, 25 Dec 2009 10:51:48 +0100 (CET)
From: BOUWSMA Barry <freebeer.bouwsma@gmail.com>
To: TAXI <taxi@a-city.de>
cc: linux-media@vger.kernel.org
Subject: Re: Bad image/sound quality with Medion MD 95700
In-Reply-To: <4B33F4CA.7060607@a-city.de>
Message-ID: <alpine.DEB.2.01.0912251021210.5481@ybpnyubfg.ybpnyqbznva>
References: <4B33F4CA.7060607@a-city.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 25 Dec 2009, TAXI wrote:

> I tried a Medion MD 95700 with kernel 2.6.32 (for tests: 2.6.30.9) and
> have a very bad image and sound quality.

I have two of these boxes, and they work great -- but I've had to 
patch the kernel in different ways to have success.

One way for my production machine happily running 2.6.14 with 
patches, due to the fact that this kernel has a problem with
isochronous data being passed through an external hub -- the
95700 has a built-in hub to allow its built-in USB port to co-
exist with the datastream and the remote control.

The other way works for newer kernels, sort of, and looks for the
data on a different alternate interface where it can be found (but
it requires a kick in the pants to get it started), although it
is possible to successfully use either the isochronous or the bulk
datastream which the device delivers with these later modern 
kernels.

The other thing to note is that this device delivers a full
unfiltered Transport Stream, which with the 13,27Mbit/sec typical
bandwidth per channel used in your country (apart from some local
exceptions of greater values), will require a USB2 interface.

I mention this because the last multi-gigahertz-CPU machine I got
my grubby fingers on still had only a built-in USB1 chipset, 
although when you write:


> under windows XP the image and sound is perfect.

That leads me to believe you have a USB2 interface and can ignore
this -- although if you're somehow failing to load the EHCI driver
and falling back to the companion UHCI or EHCI USB1, it will be a
problem.  You may want to verify that -- I am thwarted by 
unco-operative hardware that prevents me from using numbered
kernel revisions as you mention as opposed to my custom kernels
direct from the `git' repository tuned to my hardware and usually
with more patches and hacks than are reasonable.


> [mpeg2video @ 0xc62be0]ac-tex damaged at 23 4
> [mpeg2video @ 0xc62be0]ac-tex damaged at 14 9
> [mpeg2video @ 0xc62be0]skipped MB in I frame at 40 10
> [mpeg2video @ 0xc62be0]invalid mb type in I Frame at 29 15
> [mpeg2video @ 0xc62be0]skipped MB in I frame at 32 19

This and the following errors can be caused by any number of 
reasons for a corrupt data stream -- inadequate bandwidth (use
of USB1 where USB2 is required for a complete Transport Stream),
improper antenna orientation, or, with certain kernel revisions,
attempting to read an isochronous data stream as bulk or vice
versa.



Ooops, I just rebooted after a crash before plugging in a more-
than-one-button-mouse on this machine I never intended to make
serious use of, so I can't paste the diffs, but...

around line 620 in my reference code, there is a line that sets
the alternate interface to 6.  This is expected to be bulk, but
on my boxes is isoc.

You can change this to interface 0, on which my boxes delivers
bulk data flawlessly.

I've attempted to add a test of what sort of data is present on
this interface, and if it's not bulk, decides to read isoc data
from this interface (6) instead.  That also works, but somehow
needs an extra kick such that the first time it fails, yet is
fine after that.  (I get occasional failures from other tuner
cards that work fine immediately after, so I've worked around
this in the scripts I use.)



Anyway, I've been meaning to clean up this patch, or the 
alternative patches, and submit them to be ignored, but when
I have my machine operating fully again (yeahright), I can send
you some of these alternative patches to try -- running 
successfully on 2.6.14 and 2.6.27-rc4.


Hope this is helpful in spite of its vagueness...


thanks
barry bouwsma
