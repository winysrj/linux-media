Return-path: <mchehab@pedra>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:55106 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751987Ab1AOCa3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 14 Jan 2011 21:30:29 -0500
Received: by vws16 with SMTP id 16so1294522vws.19
        for <linux-media@vger.kernel.org>; Fri, 14 Jan 2011 18:30:28 -0800 (PST)
Subject: Re: [PATCH] hdpvr: enable IR part
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=us-ascii
From: Jarod Wilson <jarod@wilsonet.com>
In-Reply-To: <20110114220759.GG9849@redhat.com>
Date: Fri, 14 Jan 2011 21:30:25 -0500
Cc: Jean Delvare <khali@linux-fr.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Janne Grunau <j@jannau.net>, Jarod Wilson <jarod@redhat.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <661A728F-3CF1-47F3-A650-D17429AF7DF1@wilsonet.com>
References: <20110114195448.GA9849@redhat.com> <1295041480.2459.9.camel@localhost> <20110114220759.GG9849@redhat.com>
To: Andy Walls <awalls@md.metrocast.net>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Jan 14, 2011, at 5:08 PM, Jarod Wilson wrote:

> On Fri, Jan 14, 2011 at 04:44:40PM -0500, Andy Walls wrote:
>> On Fri, 2011-01-14 at 14:54 -0500, Jarod Wilson wrote:
>>> A number of things going on here, but the end result is that the IR part
>>> on the hdpvr gets enabled, and can be used with ir-kbd-i2c and/or
>>> lirc_zilog.
>>> 
>>> First up, there are some conditional build fixes that come into play
>>> whether i2c is built-in or modular. Second, we're swapping out
>>> i2c_new_probed_device() for i2c_new_device(), as in my testing, probing
>>> always fails, but we *know* that all hdpvr devices have a z8 chip at
>>> 0x70 and 0x71. Third, we're poking at an i2c address directly without a
>>> client, and writing some magic bits to actually turn on this IR part
>>> (this could use some improvement in the future). Fourth, some of the
>>> i2c_adapter storage has been reworked, as the existing implementation
>>> used to lead to an oops following i2c changes c. 2.6.31.
>>> 
>>> Earlier editions of this patch have been floating around the 'net for a
>>> while, including being patched into Fedora kernels, and they *do* work.
>>> This specific version isn't yet tested, beyond loading ir-kbd-i2c and
>>> confirming that it does bind to the RX address of the hdpvr:
>>> 
>>> Registered IR keymap rc-hauppauge-new
>>> input: i2c IR (HD PVR) as /devices/virtual/rc/rc1/input6
>>> rc1: i2c IR (HD PVR) as /devices/virtual/rc/rc1
>>> ir-kbd-i2c: i2c IR (HD PVR) detected at i2c-1/1-0071/ir0 [Hauppage HD PVR I2C]

And it *almost* works. Every key on the bundled remote is recognized, but
every press gets feedback about like this w/evtest:

Event: time 1295058330.966180, type 4 (Misc), code 4 (ScanCode), value 29
Event: time 1295058330.966212, type 1 (Key), code 401 (Blue), value 1
Event: time 1295058330.966220, -------------- Report Sync ------------
Event: time 1295058331.066175, type 4 (Misc), code 4 (ScanCode), value 29
Event: time 1295058331.166290, type 4 (Misc), code 4 (ScanCode), value 29
Event: time 1295058331.275664, type 4 (Misc), code 4 (ScanCode), value 29
Event: time 1295058331.376160, type 4 (Misc), code 4 (ScanCode), value 29
Event: time 1295058331.465505, type 1 (Key), code 401 (Blue), value 2
Event: time 1295058331.476161, type 4 (Misc), code 4 (ScanCode), value 29
Event: time 1295058331.498502, type 1 (Key), code 401 (Blue), value 2
Event: time 1295058331.531504, type 1 (Key), code 401 (Blue), value 2
Event: time 1295058331.564503, type 1 (Key), code 401 (Blue), value 2
Event: time 1295058331.576153, type 4 (Misc), code 4 (ScanCode), value 29
Event: time 1295058331.597502, type 1 (Key), code 401 (Blue), value 2
Event: time 1295058331.630501, type 1 (Key), code 401 (Blue), value 2
Event: time 1295058331.663502, type 1 (Key), code 401 (Blue), value 2
Event: time 1295058331.696500, type 1 (Key), code 401 (Blue), value 2
Event: time 1295058331.729503, type 1 (Key), code 401 (Blue), value 2
Event: time 1295058331.762502, type 1 (Key), code 401 (Blue), value 2
Event: time 1295058331.795500, type 1 (Key), code 401 (Blue), value 2
Event: time 1295058331.825507, type 1 (Key), code 401 (Blue), value 0
Event: time 1295058331.825526, -------------- Report Sync ------------

That's just a single short press. With arrow keys, its quite funky to
watch in, say, mythtv UI menus. Hit up, and it moves up one, stalls for a
second, then moves up several more.

...
>> Note, that code in lirc_zilog.c indicates that ir-kbd-i2c.c's function
>> get_key_haup_xvr() *may* need some additions to account for the Rx data
>> format.  I'm not sure of this though.  (Or a custom get_key() in the
>> hdpvr module could be provided as a function pointer to ir-kbd-i2c.c via
>> platform_data.)
>> 
>> I will provide a debug patch in another email so that it's easier to see
>> the data ir-kbd-i2c.c sees coming from the Z8.
> 
> I'll tack that onto the machine I've got hooked to the hdpvr and see what
> I can see this weekend, thanks much for the pointers.

I'm inclined to think that it does indeed need some of the changes from
lirc_zilog brought over (or the custom get_key()). Now on to adding that
patch and some testing with lirc_zilog...

-- 
Jarod Wilson
jarod@wilsonet.com



