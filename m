Return-path: <mchehab@pedra>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:48763 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751740Ab1AUD62 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 20 Jan 2011 22:58:28 -0500
Received: by iwn9 with SMTP id 9so1284111iwn.19
        for <linux-media@vger.kernel.org>; Thu, 20 Jan 2011 19:58:27 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1295572227.18114.8.camel@localhost>
References: <1295205650.2400.27.camel@localhost>
	<1295234982.2407.38.camel@localhost>
	<848D2317-613E-42B1-950D-A227CFF15C5B@wilsonet.com>
	<1295439718.2093.17.camel@morgan.silverblock.net>
	<alpine.DEB.1.10.1101190714570.5396@ivanova.isely.net>
	<1295444282.4317.20.camel@morgan.silverblock.net>
	<20110119145002.6f94f800@endymion.delvare>
	<D7F0E4A6-5A23-4A28-95F8-0A088F1D6114@wilsonet.com>
	<20110119184322.0e5d12cd@endymion.delvare>
	<0281052D-AFBF-4764-ADFF-64EF0A0CC2CB@wilsonet.com>
	<DF6BA086-43FF-4FD9-A30E-EB8AAF451A94@wilsonet.com>
	<1295529772.2056.24.camel@morgan.silverblock.net>
	<F3EC69D7-B0B9-4475-B21A-2312BA4D1E05@wilsonet.com>
	<1295572227.18114.8.camel@localhost>
Date: Thu, 20 Jan 2011 22:58:27 -0500
Message-ID: <AANLkTikTPSR_Fj8nFKpZuEWBTCsMO+E6NiV6cScw=7YX@mail.gmail.com>
Subject: Re: [GIT PATCHES for 2.6.38] Zilog Z8 IR unit fixes
From: Jarod Wilson <jarod@wilsonet.com>
To: Andy Walls <awalls@md.metrocast.net>
Cc: Jean Delvare <khali@linux-fr.org>, Mike Isely <isely@isely.net>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Jarod Wilson <jarod@redhat.com>, Janne Grunau <j@jannau.net>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Thu, Jan 20, 2011 at 8:10 PM, Andy Walls <awalls@md.metrocast.net> wrote:
> On Thu, 2011-01-20 at 16:49 -0500, Jarod Wilson wrote:
>> On Jan 20, 2011, at 8:22 AM, Andy Walls wrote:
...
>> Some further testing today with a try-check success-delay-retry loop
>> shows one i2c_master_send() failure plus a udelay(100), and the second
>> i2c_master_send() typically always works (I haven't seen it *not* work
>> on the HVR-1950 in cursory testing).
>
> Cool.
>
>> A second similar loop has proven necessary for IR TX attempts to actually
>> claim to succeed -- not 100% certain they really worked, as I don't have
>> the IR emitter with me at the moment, its at home hooked up to my hdpvr,
>> but I suspect its working fine now.
>
> I'm not sure I follow here.  By "claim" I assume you mean no
> i2c_master_send() error.

Yeah, no errors in the code, and irsend says transmit was successful.
Just tried it out with the emitter hooked up, and it is indeed working
perfectly, sending commands to my cable box.

In short, IR on the HVR-1950 is behaving perfectly right now, including RX
with ir-kbd-i2c and both RX and TX with lirc_zilog.

...
>> Oh, I've also got IR RX with ir-kbd-i2c attached to the HVR-1950 working
>> much better now, with the polling interval reverted to the standard
>> 100ms, but simply introducing the same i2c_master_send() poll that
>> lirc_zilog uses into get_key_haup_xvr().
>
> You might want to check what video cards in the source tree request of,
> or are defaulted by, ir-kbd-i2c to use get_key_haup_xvr().  If it's only
> the chips at address 0x71, you're probably OK.

>From what I can tell, its only chips at 0x71.

>> I want to test today's changes with the hdpvr tonight (and verify that
>> tx is working on the HVR-1950) before I send along my current stack of
>> patches, and I have suspicions that most of the hdpvr-specific crud in
>> lirc_zilog is bogus now -- it *should* behave exactly like the HVR-1950,
>> which obviously doesn't follow any of those hdpvr-specific code paths,
>> so I'm hoping we can rip out some additional complexity from lirc_zilog.
>
> Good riddance to old kludges. :)
>
> You could then rename the i2c client strings back to
> "ir_[tr]x_z8f0811_haup".  We're going to modify struct IR_i2c_init_data
> with all the bridge specific parameters that need to be sent anyway, so
> no need to encode that information implicitly in the client's name
> anymore.

Unfortunately, my suspicions were wrong. The hdpvr-specific tweaks for
both RX and TX are necessary.

On RX, instead of getting two distinct keypresses (each with index 0), you
get two streams of keypresses, 00 to 08. On TX, we get a -EIO from the
i2c_master_recv() after where we normally bail out on the hdpvr.

Ah well. At least it means I'm not making more changes to lirc_zilog
tonight, so I'll send along the patches I've got queued up shortly.

-- 
Jarod Wilson
jarod@wilsonet.com
