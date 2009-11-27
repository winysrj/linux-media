Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qy0-f192.google.com ([209.85.221.192]:38463 "EHLO
	mail-qy0-f192.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751510AbZK0D67 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 26 Nov 2009 22:58:59 -0500
MIME-Version: 1.0
In-Reply-To: <4B0F43B3.4090804@wilsonet.com>
References: <20091127013217.7671.32355.stgit@terra>
	 <4B0F43B3.4090804@wilsonet.com>
Date: Thu, 26 Nov 2009 22:58:59 -0500
Message-ID: <9e4733910911261958w2911f69dk4ab747b4bf12461@mail.gmail.com>
Subject: Re: [IR-RFC PATCH v4 0/6] In-kernel IR support using evdev
From: Jon Smirl <jonsmirl@gmail.com>
To: Jarod Wilson <jarod@wilsonet.com>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-input@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Nov 26, 2009 at 10:12 PM, Jarod Wilson <jarod@wilsonet.com> wrote:
>> Raw mode. There are three sysfs attributes - ir_raw, ir_carrier,
>> ir_xmitter. Read from ir_raw to get the raw timing data from the IR
>> device. Set carrier and active xmitters and then copy raw data to
>> ir_raw to send. These attributes may be better on a debug switch. You
>> would use raw mode when decoding a new protocol. After you figure out
>> the new protocol, write an in-kernel encoder/decoder for it.
>
> Also neglected to recall there was raw IR data access too. However, a few
> things... One, this is, in some sense, cheating, as its not an input layer
> interface being used. :) Granted though, it *is* an existing kernel
> interface being used, instead of adding a new one. Two, there's no userspace
> to do anything with it at this time. I mean, sure, in theory, writing it
> wouldn't be that hard, but we can already do the same thing using the lirc
> interface, and already have userspace code for it. I think users need/desire
> to use raw IR modes may be more prevalent that most people think.

I would view raw mode as a developer interface which would be used to
implement a new protocol decode engine.  There is an assumption in my
design that all IR timings can be decoded/constructed by a protocol
engine.  Sure we may end up with 40 protocol engines, but they are
only about 50 lines of code. You could put each engine into a loadable
module if you want.

You see raw data used a lot with Sony remotes. Sony remotes mix
multiple protocols in a single remote. The irrecord program does not
understand these mixed protocols and generates a raw mode config file.
The mixed protocols don't bother the protocol state machine system.
This happens with other mixed protocol remotes too.

> Two drivers are supplied. mceusb2 implements send and receive support
>> for the Microsoft USB IR dongle.
>
> I'd be game to try hacking up the lirc_mceusb driver (which has, since your
> work was done, merged mce v1 and v2 transceiver support) to support both
> your in-kernel interface and the lirc interface as an example of the hybrid
> approach I'm thinking of.
>
>> Code is only lightly tested. Encoders and decoders have not been
>> written for all protocols. Repeat is not handled for any protocol. I'm
>> looking for help. There are 15 more existing LIRC drivers.
>
> And there's the hangup for me. The lirc drivers and interface have been
> pretty heavily battle-tested over years and years in the field. And there
> are those 15 more drivers that already work with the lirc interface. I'm
> woefully short on time to work on any porting myself, and about to get even
> shorter with some new responsibilities at work requiring even more of my
> attention.
>
> If we go with a hybrid approach, all those existing drivers can be brought
> in supporting just the lirc interface initially, and have in-kernel decode
> support added as folks have time to work on them, if it actually makes sense
> for those devices.
>
> Just trying to find a happy middle ground that minimizes regressions for
> users *and* gives us maximum flexibility.

You are going to have to choose. Recreate the problems of type
specific devices like /dev/mouse and /dev/kbd that evdev was created
to fix, or skip those type specific devices and go straight to evdev.
We've known for years the /dev/mouse was badly broken. How many more
years is it going to be before it can be removed? /dev/lirc has the
same type of problems that /dev/mouse has. The only reason that
/dev/lirc works now is because there is a single app that uses it.

Also, implementing a new evdev based system in the kernel in no way
breaks existing lirc installations. Just don't load the new
implementation and everything works exactly the same way as before.

I'd go the evdev only route for in-kernel and leave existing lirc out
of tree. Existing lirc will continue to work. This is probably the
most stable strategy, even more so than a hybrid approach. The
in-kernel implementation will then be free to evolve without the
constraint of legacy APIs. As people become happy with it they can
switch over.


-- 
Jon Smirl
jonsmirl@gmail.com
