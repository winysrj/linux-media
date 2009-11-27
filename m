Return-path: <linux-media-owner@vger.kernel.org>
Received: from static-72-93-233-3.bstnma.fios.verizon.net ([72.93.233.3]:59282
	"EHLO mail.wilsonet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752913AbZK0DHw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 26 Nov 2009 22:07:52 -0500
Message-ID: <4B0F43B3.4090804@wilsonet.com>
Date: Thu, 26 Nov 2009 22:12:51 -0500
From: Jarod Wilson <jarod@wilsonet.com>
MIME-Version: 1.0
To: Jon Smirl <jonsmirl@gmail.com>
CC: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-input@vger.kernel.org
Subject: Re: [IR-RFC PATCH v4 0/6] In-kernel IR support using evdev
References: <20091127013217.7671.32355.stgit@terra>
In-Reply-To: <20091127013217.7671.32355.stgit@terra>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

First up, thank you for reposting this. I believe several of us were 
keeping this code in mind for the in-kernel decoding portion of this 
discussion, but it hadn't been stated outright in the recent threads here.

On 11/26/2009 08:34 PM, Jon Smirl wrote:
> This is a repost of the LIRC input patch series I wrote a year ago.
> Many of the ideas being discussed in the currect "Should we create a
> raw input interface for IR's?" thread have already been implemented
> in this code.
>
> ---------------------------------------------------
>
> All of this kernel code is tiny, about 20K including a driver.
>
> Basic flow works like this:
>
> patch: Minimal changes to the core input system
> Add a new IR data type to the input framework
>
> patch: Core IR module
> In-kernel decoding of core IR protocols - RC5, RC6, etc
> This only converts from protocol pulse timing to common command format.
> Check out: http://www.sbprojects.com/knowledge/ir/sirc.htm

I think we can definitely take advantage of this for the in-kernel side 
of the initial hybrid approach I think we're converging on.

> patch: Configfs support for IR
> Decoded core protocols pass through a translation map based on configfs
> When core protocol matches an entry in configfs it is turned into a
> keycode event.

This part... Not so wild about. The common thought I'm seeing from 
people is that we should be using setkeycode to load keymaps. I mean, 
sure, I suppose this could be abstracted away so the user never sees it, 
but it seems to be reinventing a way to set up key mapping when 
setkeycode already exists, and is used by a number of existing IR 
devices in the v4l/dvb subsystem (as well as misc things like the ati rf 
remotes, iirc). Is there some distinct advantage to going this route vs. 
setkeycode that I'm missing?

> patch: Microsoft mceusb2 driver for in-kernel IR subsystem
> Example mceusb IR input driver

Bah. I completely forgot you'd actually did have transmit code too.

...
> Raw IR pulse data is available in a FIFO via sysfs. You can use this
> to figure out new remote protocols.
>
> Two input events are generated
> 1) an event for the decoded raw IR protocol
> 2) a keycode event if the decoded raw IR protocol matches an entry in
> the configfs
>
> You can also send pulses.
...
> Raw mode. There are three sysfs attributes - ir_raw, ir_carrier,
> ir_xmitter. Read from ir_raw to get the raw timing data from the IR
> device. Set carrier and active xmitters and then copy raw data to
> ir_raw to send. These attributes may be better on a debug switch. You
> would use raw mode when decoding a new protocol. After you figure out
> the new protocol, write an in-kernel encoder/decoder for it.

Also neglected to recall there was raw IR data access too. However, a 
few things... One, this is, in some sense, cheating, as its not an input 
layer interface being used. :) Granted though, it *is* an existing 
kernel interface being used, instead of adding a new one. Two, there's 
no userspace to do anything with it at this time. I mean, sure, in 
theory, writing it wouldn't be that hard, but we can already do the same 
thing using the lirc interface, and already have userspace code for it. 
I think users need/desire to use raw IR modes may be more prevalent that 
most people think.

> Two drivers are supplied. mceusb2 implements send and receive support
> for the Microsoft USB IR dongle.

I'd be game to try hacking up the lirc_mceusb driver (which has, since 
your work was done, merged mce v1 and v2 transceiver support) to support 
both your in-kernel interface and the lirc interface as an example of 
the hybrid approach I'm thinking of.

> Code is only lightly tested. Encoders and decoders have not been
> written for all protocols. Repeat is not handled for any protocol. I'm
> looking for help. There are 15 more existing LIRC drivers.

And there's the hangup for me. The lirc drivers and interface have been 
pretty heavily battle-tested over years and years in the field. And 
there are those 15 more drivers that already work with the lirc 
interface. I'm woefully short on time to work on any porting myself, and 
about to get even shorter with some new responsibilities at work 
requiring even more of my attention.

If we go with a hybrid approach, all those existing drivers can be 
brought in supporting just the lirc interface initially, and have 
in-kernel decode support added as folks have time to work on them, if it 
actually makes sense for those devices.

Just trying to find a happy middle ground that minimizes regressions for 
users *and* gives us maximum flexibility.

-- 
Jarod Wilson
jarod@wilsonet.com
