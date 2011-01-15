Return-path: <mchehab@pedra>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:40420 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750770Ab1AOG4H convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 15 Jan 2011 01:56:07 -0500
Received: by vws16 with SMTP id 16so1357749vws.19
        for <linux-media@vger.kernel.org>; Fri, 14 Jan 2011 22:56:05 -0800 (PST)
Subject: Re: [PATCH] hdpvr: enable IR part
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=us-ascii
From: Jarod Wilson <jarod@wilsonet.com>
In-Reply-To: <0EADA025-77B0-4E8B-A649-F3BE6F2E437B@wilsonet.com>
Date: Sat, 15 Jan 2011 01:56:02 -0500
Cc: Jean Delvare <khali@linux-fr.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Janne Grunau <j@jannau.net>, Jarod Wilson <jarod@redhat.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <C59C652B-B4C2-40B9-A195-7719718ECC9D@wilsonet.com>
References: <20110114195448.GA9849@redhat.com> <1295041480.2459.9.camel@localhost> <20110114220759.GG9849@redhat.com> <661A728F-3CF1-47F3-A650-D17429AF7DF1@wilsonet.com> <1295066141.2459.34.camel@localhost> <0EADA025-77B0-4E8B-A649-F3BE6F2E437B@wilsonet.com>
To: Andy Walls <awalls@md.metrocast.net>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Jan 15, 2011, at 12:37 AM, Jarod Wilson wrote:

> On Jan 14, 2011, at 11:35 PM, Andy Walls wrote:
> 
>> On Fri, 2011-01-14 at 21:30 -0500, Jarod Wilson wrote:
>>> On Jan 14, 2011, at 5:08 PM, Jarod Wilson wrote:
>> 
>>>>>> Registered IR keymap rc-hauppauge-new
>>>>>> input: i2c IR (HD PVR) as /devices/virtual/rc/rc1/input6
>>>>>> rc1: i2c IR (HD PVR) as /devices/virtual/rc/rc1
>>>>>> ir-kbd-i2c: i2c IR (HD PVR) detected at i2c-1/1-0071/ir0 [Hauppage HD PVR I2C]
>>> 
>>> And it *almost* works. Every key on the bundled remote is recognized, but
>>> every press gets feedback about like this w/evtest:
>>> 
>>> Event: time 1295058330.966180, type 4 (Misc), code 4 (ScanCode), value 29
>>> Event: time 1295058330.966212, type 1 (Key), code 401 (Blue), value 1
>>> Event: time 1295058330.966220, -------------- Report Sync ------------
>>> Event: time 1295058331.066175, type 4 (Misc), code 4 (ScanCode), value 29
>>> Event: time 1295058331.166290, type 4 (Misc), code 4 (ScanCode), value 29
>>> Event: time 1295058331.275664, type 4 (Misc), code 4 (ScanCode), value 29
>>> Event: time 1295058331.376160, type 4 (Misc), code 4 (ScanCode), value 29
>>> Event: time 1295058331.465505, type 1 (Key), code 401 (Blue), value 2
>>> Event: time 1295058331.476161, type 4 (Misc), code 4 (ScanCode), value 29
>>> Event: time 1295058331.498502, type 1 (Key), code 401 (Blue), value 2
>>> Event: time 1295058331.531504, type 1 (Key), code 401 (Blue), value 2
>>> Event: time 1295058331.564503, type 1 (Key), code 401 (Blue), value 2
>>> Event: time 1295058331.576153, type 4 (Misc), code 4 (ScanCode), value 29
>>> Event: time 1295058331.597502, type 1 (Key), code 401 (Blue), value 2
>>> Event: time 1295058331.630501, type 1 (Key), code 401 (Blue), value 2
>>> Event: time 1295058331.663502, type 1 (Key), code 401 (Blue), value 2
>>> Event: time 1295058331.696500, type 1 (Key), code 401 (Blue), value 2
>>> Event: time 1295058331.729503, type 1 (Key), code 401 (Blue), value 2
>>> Event: time 1295058331.762502, type 1 (Key), code 401 (Blue), value 2
>>> Event: time 1295058331.795500, type 1 (Key), code 401 (Blue), value 2
>>> Event: time 1295058331.825507, type 1 (Key), code 401 (Blue), value 0
>>> Event: time 1295058331.825526, -------------- Report Sync ------------
>>> 
>>> That's just a single short press. With arrow keys, its quite funky to
>>> watch in, say, mythtv UI menus. Hit up, and it moves up one, stalls for a
>>> second, then moves up several more.
>> 
>> Hmm bizzarre.
> 
> Shouldn't have said "stalls for a second", its a just brief pause, but
> regardless, yeah, its kinda odd.

Okay, last spam before I head off to bed... :)

I can get ir-kbd-i2c behavior to pretty much match lirc_zilog wrt key repeat,
by simply setting init_data->polling_interval = 260; in hdpvr-i2c.c, which
matches up with the delay in lirc_zilog. With the 260 interval:

Event: time 1295072449.490542, -------------- Report Sync ------------
Event: time 1295072453.321206, type 4 (Misc), code 4 (ScanCode), value 15
Event: time 1295072453.321245, type 1 (Key), code 108 (Down), value 1
Event: time 1295072453.321252, -------------- Report Sync ------------
Event: time 1295072453.570512, type 1 (Key), code 108 (Down), value 0
Event: time 1295072453.570544, -------------- Report Sync ------------
Event: time 1295072453.575718, type 4 (Misc), code 4 (ScanCode), value 15
Event: time 1295072453.575744, type 1 (Key), code 108 (Down), value 1
Event: time 1295072453.575752, -------------- Report Sync ------------
Event: time 1295072453.816215, type 4 (Misc), code 4 (ScanCode), value 15
Event: time 1295072454.065515, type 1 (Key), code 108 (Down), value 0
Event: time 1295072454.065544, -------------- Report Sync ------------

Lowering this a bit, I can get split personality, one press will look like
what I was originally seeing, another will look like the 260 output.

Adding filtering (return 0 if buf[0] != 0x80) doesn't help any.

The final thing I've noticed tonight is that ir-kbd-i2c calls rc_keydown
using a value of 0 for its 3rd parameter. From rc-main.c:

 * @toggle:     the toggle value (protocol dependent, if the protocol doesn't
 *              support toggle values, this should be set to zero)

Well, in this case, the protocol *does* use a toggle, so that's probably
something that could use fixing. Not sure it actually has anything to do with
the odd repeats I'm seeing. Okay, wasn't too much work to pass along toggle
values too, but it didn't help any.

I'll sleep on it.

-- 
Jarod Wilson
jarod@wilsonet.com



