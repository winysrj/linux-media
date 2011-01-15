Return-path: <mchehab@pedra>
Received: from mail-qy0-f181.google.com ([209.85.216.181]:34517 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750746Ab1AOFiP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 15 Jan 2011 00:38:15 -0500
Received: by qyk12 with SMTP id 12so4096957qyk.19
        for <linux-media@vger.kernel.org>; Fri, 14 Jan 2011 21:38:15 -0800 (PST)
Subject: Re: [PATCH] hdpvr: enable IR part
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=us-ascii
From: Jarod Wilson <jarod@wilsonet.com>
In-Reply-To: <1295066141.2459.34.camel@localhost>
Date: Sat, 15 Jan 2011 00:37:42 -0500
Cc: Jean Delvare <khali@linux-fr.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Janne Grunau <j@jannau.net>, Jarod Wilson <jarod@redhat.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <0EADA025-77B0-4E8B-A649-F3BE6F2E437B@wilsonet.com>
References: <20110114195448.GA9849@redhat.com> <1295041480.2459.9.camel@localhost> <20110114220759.GG9849@redhat.com> <661A728F-3CF1-47F3-A650-D17429AF7DF1@wilsonet.com> <1295066141.2459.34.camel@localhost>
To: Andy Walls <awalls@md.metrocast.net>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Jan 14, 2011, at 11:35 PM, Andy Walls wrote:

> On Fri, 2011-01-14 at 21:30 -0500, Jarod Wilson wrote:
>> On Jan 14, 2011, at 5:08 PM, Jarod Wilson wrote:
> 
>>>>> Registered IR keymap rc-hauppauge-new
>>>>> input: i2c IR (HD PVR) as /devices/virtual/rc/rc1/input6
>>>>> rc1: i2c IR (HD PVR) as /devices/virtual/rc/rc1
>>>>> ir-kbd-i2c: i2c IR (HD PVR) detected at i2c-1/1-0071/ir0 [Hauppage HD PVR I2C]
>> 
>> And it *almost* works. Every key on the bundled remote is recognized, but
>> every press gets feedback about like this w/evtest:
>> 
>> Event: time 1295058330.966180, type 4 (Misc), code 4 (ScanCode), value 29
>> Event: time 1295058330.966212, type 1 (Key), code 401 (Blue), value 1
>> Event: time 1295058330.966220, -------------- Report Sync ------------
>> Event: time 1295058331.066175, type 4 (Misc), code 4 (ScanCode), value 29
>> Event: time 1295058331.166290, type 4 (Misc), code 4 (ScanCode), value 29
>> Event: time 1295058331.275664, type 4 (Misc), code 4 (ScanCode), value 29
>> Event: time 1295058331.376160, type 4 (Misc), code 4 (ScanCode), value 29
>> Event: time 1295058331.465505, type 1 (Key), code 401 (Blue), value 2
>> Event: time 1295058331.476161, type 4 (Misc), code 4 (ScanCode), value 29
>> Event: time 1295058331.498502, type 1 (Key), code 401 (Blue), value 2
>> Event: time 1295058331.531504, type 1 (Key), code 401 (Blue), value 2
>> Event: time 1295058331.564503, type 1 (Key), code 401 (Blue), value 2
>> Event: time 1295058331.576153, type 4 (Misc), code 4 (ScanCode), value 29
>> Event: time 1295058331.597502, type 1 (Key), code 401 (Blue), value 2
>> Event: time 1295058331.630501, type 1 (Key), code 401 (Blue), value 2
>> Event: time 1295058331.663502, type 1 (Key), code 401 (Blue), value 2
>> Event: time 1295058331.696500, type 1 (Key), code 401 (Blue), value 2
>> Event: time 1295058331.729503, type 1 (Key), code 401 (Blue), value 2
>> Event: time 1295058331.762502, type 1 (Key), code 401 (Blue), value 2
>> Event: time 1295058331.795500, type 1 (Key), code 401 (Blue), value 2
>> Event: time 1295058331.825507, type 1 (Key), code 401 (Blue), value 0
>> Event: time 1295058331.825526, -------------- Report Sync ------------
>> 
>> That's just a single short press. With arrow keys, its quite funky to
>> watch in, say, mythtv UI menus. Hit up, and it moves up one, stalls for a
>> second, then moves up several more.
> 
> Hmm bizzarre.

Shouldn't have said "stalls for a second", its a just brief pause, but
regardless, yeah, its kinda odd.


>> ...
>>>> Note, that code in lirc_zilog.c indicates that ir-kbd-i2c.c's function
>>>> get_key_haup_xvr() *may* need some additions to account for the Rx data
>>>> format.  I'm not sure of this though.  (Or a custom get_key() in the
>>>> hdpvr module could be provided as a function pointer to ir-kbd-i2c.c via
>>>> platform_data.)
>>>> 
>>>> I will provide a debug patch in another email so that it's easier to see
>>>> the data ir-kbd-i2c.c sees coming from the Z8.
>>> 
>>> I'll tack that onto the machine I've got hooked to the hdpvr and see what
>>> I can see this weekend, thanks much for the pointers.
>> 
>> I'm inclined to think that it does indeed need some of the changes from
>> lirc_zilog brought over (or the custom get_key()). Now on to adding that
>> patch and some testing with lirc_zilog...


A single button press w/ir-kbd-i2c debugging and your patch:

ir-kbd-i2c: ir_poll_key
ir-kbd-i2c: get_key_haup_common: received bytes: 80 00 00 fe 54 00        ....T.
ir-kbd-i2c: ir hauppauge (rc5): s1 r1 t1 dev=30 code=21
ir-kbd-i2c: ir_poll_key
ir-kbd-i2c: get_key_haup_common: received bytes: 80 00 00 fe 54 00        ....T.
ir-kbd-i2c: ir hauppauge (rc5): s1 r1 t1 dev=30 code=21
ir-kbd-i2c: ir_poll_key
ir-kbd-i2c: get_key_haup_common: received bytes: 80 00 00 fe 54 00        ....T.
ir-kbd-i2c: ir hauppauge (rc5): s1 r1 t1 dev=30 code=21
ir-kbd-i2c: ir_poll_key
ir-kbd-i2c: get_key_haup_common: received bytes: 80 00 00 fe 54 00        ....T.
ir-kbd-i2c: ir hauppauge (rc5): s1 r1 t1 dev=30 code=21
ir-kbd-i2c: ir_poll_key
ir-kbd-i2c: get_key_haup_common: received bytes: 80 00 00 fe 54 00        ....T.
ir-kbd-i2c: ir hauppauge (rc5): s1 r1 t1 dev=30 code=21
ir-kbd-i2c: ir_poll_key
ir-kbd-i2c: get_key_haup_common: received bytes: 80 00 00 fe 54 00        ....T.
ir-kbd-i2c: ir hauppauge (rc5): s1 r1 t1 dev=30 code=21


> Yes, maybe both the Rx data parsing *and* the precise delay between Rx
> polls.

Receive with lirc_zilog does actually work slightly better, though its still
not perfect. Each key press (using irw to watch) always results in at least
two lines of output, both with sequence number 00 (i.e., two distinct events),
and holding a button down results in a stream of 00 events. So repeat is
obviously busted. But I don't see the wackiness that is happening w/ir-kbd-i2c.

Oh, and transmit works too. So this patch and the buffer alloc patch have now
been formally tested. Unless we go the custom get_key() route inside the hdpvr
driver, I think the rest of the legwork to make the hdpvr's IR part behave is
within lirc_zilog and ir-kbd-i2c (both of which I need to spend some more
time reading over).


> BTW, a checkpatch and compiler tested lirc_zilog.c is here:
> 
> http://git.linuxtv.org/awalls/media_tree.git?a=shortlog;h=refs/heads/z8
> 
> It should fix all the binding and allocation problems related to
> ir_probe()/ir_remove().  Except I suspect it may leak the Rx poll
> kthread.  That's possibly another bug to add to the list.
> 
> Anyway, $DIETY knows if the lirc_zilog module actually still works after
> all my hacks.  Give it a test if you are adventurous.  I won't be able
> to test until tomorrow evening.

I'll try to grab those and give them a test tomorrow, and hey, I've even got
a baseline to test against now.


-- 
Jarod Wilson
jarod@wilsonet.com



