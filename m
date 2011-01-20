Return-path: <mchehab@pedra>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:59886 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755379Ab1ATVtZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 20 Jan 2011 16:49:25 -0500
Received: by vws16 with SMTP id 16so476986vws.19
        for <linux-media@vger.kernel.org>; Thu, 20 Jan 2011 13:49:24 -0800 (PST)
References: <1295205650.2400.27.camel@localhost> <1295234982.2407.38.camel@localhost> <848D2317-613E-42B1-950D-A227CFF15C5B@wilsonet.com> <1295439718.2093.17.camel@morgan.silverblock.net> <alpine.DEB.1.10.1101190714570.5396@ivanova.isely.net> <1295444282.4317.20.camel@morgan.silverblock.net> <20110119145002.6f94f800@endymion.delvare> <D7F0E4A6-5A23-4A28-95F8-0A088F1D6114@wilsonet.com> <20110119184322.0e5d12cd@endymion.delvare> <0281052D-AFBF-4764-ADFF-64EF0A0CC2CB@wilsonet.com> <DF6BA086-43FF-4FD9-A30E-EB8AAF451A94@wilsonet.com> <1295529772.2056.24.camel@morgan.silverblock.net>
In-Reply-To: <1295529772.2056.24.camel@morgan.silverblock.net>
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=us-ascii
Message-Id: <F3EC69D7-B0B9-4475-B21A-2312BA4D1E05@wilsonet.com>
Content-Transfer-Encoding: 7bit
Cc: Jean Delvare <khali@linux-fr.org>, Mike Isely <isely@isely.net>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Jarod Wilson <jarod@redhat.com>, Janne Grunau <j@jannau.net>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
From: Jarod Wilson <jarod@wilsonet.com>
Subject: Re: [GIT PATCHES for 2.6.38] Zilog Z8 IR unit fixes
Date: Thu, 20 Jan 2011 16:49:38 -0500
To: Andy Walls <awalls@md.metrocast.net>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Jan 20, 2011, at 8:22 AM, Andy Walls wrote:

> On Wed, 2011-01-19 at 23:45 -0500, Jarod Wilson wrote:
>> On Jan 19, 2011, at 3:08 PM, Jarod Wilson wrote:
> 
>>> I'm working on
>>> fixing up hdpvr-i2c further right now, and will do some more prodding
>>> with pvrusb2, the code for which looks correct with two i2c_new_device()
>>> calls in it, one for each address, so I just need to figure out why
>>> lirc_zilog is getting an -EIO trying to get tx brought up.
>> 
>> So as we were discussing on irc today, the -EIO is within lirc_zilog's
>> send_boot_data() function. The firmware is loaded, and then we send the
>> z8 a command to activate the firmware, immediately follow by an attempt
>> to read the firmware version. The z8 is still busy when we do that, and
>> throwing in a simple mdelay() remedies the problem for both the hvr-1950
>> and the hdpvr -- tried 100 initially, and all the way down to 20 still
>> worked, didn't try any lower.
> 
> The Z8 on my HVR-1600 is using a 18.432 MHz crystal for its clock.
> 
> The Z8 CPU Fetch and Execution units are running with a pipeline depth
> of 1: 1 insn being executed while another 1 insn is being fetched.  Most
> Z8 fetch or execution cycle counts are in the range of 2-4 cycles.  So
> let's just assume an insn takes 4 cycles to execute.
> 
> 	18.432 MHz * 20 ms = 368,640 cycles 
> 	368,640 cycles / 4 cycles/insn = 92,160 insns
> 
> 20 ms is ~90k instructions, and seems like too long a delay to be just
> for Z8 latency.

Some further testing today with a try-check success-delay-retry loop
shows one i2c_master_send() failure plus a udelay(100), and the second
i2c_master_send() typically always works (I haven't seen it *not* work
on the HVR-1950 in cursory testing).

A second similar loop has proven necessary for IR TX attempts to actually
claim to succeed -- not 100% certain they really worked, as I don't have
the IR emitter with me at the moment, its at home hooked up to my hdpvr,
but I suspect its working fine now.

> I find it interesting that for the HVR-1600 the delay isn't needed at
> all.
> 
> I'm wondering if there might also be some Linux/USB latency in getting
> commands shoved over to the HVR-1950's controller (or maybe latency in
> the HVR-1950's controller too), for which this delay is really
> accounting.  I suppose in kernel tracing can be used to find the latency
> on shoving things across the USB and watching for any Ack from the
> HVR-1950 controller.  An experiment for some other day, I guess.

Yeah, definitely seems to be specific to usb devices. On the plus side,
the delay loops should only add insignificant delay overhead for pci
devices, since if they work on the first call, there won't be any delay
added.

Oh, I've also got IR RX with ir-kbd-i2c attached to the HVR-1950 working
much better now, with the polling interval reverted to the standard
100ms, but simply introducing the same i2c_master_send() poll that
lirc_zilog uses into get_key_haup_xvr().

I want to test today's changes with the hdpvr tonight (and verify that
tx is working on the HVR-1950) before I send along my current stack of
patches, and I have suspicions that most of the hdpvr-specific crud in
lirc_zilog is bogus now -- it *should* behave exactly like the HVR-1950,
which obviously doesn't follow any of those hdpvr-specific code paths,
so I'm hoping we can rip out some additional complexity from lirc_zilog.

-- 
Jarod Wilson
jarod@wilsonet.com



