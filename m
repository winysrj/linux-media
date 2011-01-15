Return-path: <mchehab@pedra>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:41694 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752783Ab1AOWKO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 15 Jan 2011 17:10:14 -0500
Received: by mail-vw0-f46.google.com with SMTP id 16so1554740vws.19
        for <linux-media@vger.kernel.org>; Sat, 15 Jan 2011 14:10:14 -0800 (PST)
Subject: Re: [PATCH] hdpvr: enable IR part
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=us-ascii
From: Jarod Wilson <jarod@wilsonet.com>
In-Reply-To: <1295128608.7147.14.camel@localhost>
Date: Sat, 15 Jan 2011 17:10:11 -0500
Cc: Jean Delvare <khali@linux-fr.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Janne Grunau <j@jannau.net>, Jarod Wilson <jarod@redhat.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <D883AF90-0404-46D6-835A-34BE0146E1AC@wilsonet.com>
References: <20110114195448.GA9849@redhat.com> <1295041480.2459.9.camel@localhost> <20110114220759.GG9849@redhat.com> <661A728F-3CF1-47F3-A650-D17429AF7DF1@wilsonet.com> <1295066141.2459.34.camel@localhost> <0EADA025-77B0-4E8B-A649-F3BE6F2E437B@wilsonet.com> <C59C652B-B4C2-40B9-A195-7719718ECC9D@wilsonet.com> <1295128608.7147.14.camel@localhost>
To: Andy Walls <awalls@md.metrocast.net>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Jan 15, 2011, at 4:56 PM, Andy Walls wrote:

> On Sat, 2011-01-15 at 01:56 -0500, Jarod Wilson wrote:
>> On Jan 15, 2011, at 12:37 AM, Jarod Wilson wrote:
> 
>>>>>>>> Registered IR keymap rc-hauppauge-new
>>>>>>>> input: i2c IR (HD PVR) as /devices/virtual/rc/rc1/input6
>>>>>>>> rc1: i2c IR (HD PVR) as /devices/virtual/rc/rc1
>>>>>>>> ir-kbd-i2c: i2c IR (HD PVR) detected at i2c-1/1-0071/ir0 [Hauppage HD PVR I2C]
> 
>> Okay, last spam before I head off to bed... :)
>> 
>> I can get ir-kbd-i2c behavior to pretty much match lirc_zilog wrt key repeat,
>> by simply setting init_data->polling_interval = 260; in hdpvr-i2c.c, which
>> matches up with the delay in lirc_zilog. With the 260 interval:
> 
> RC-5 has a repetition interval of about 4096/36kHz = 113.8 ms, IIRC.  
> 
> Using 260 ms, you are throwing away one repeat from the remote for sure,
> maybe two.

Yep. From lirc_zilog:

/*
 * This is ~113*2 + 24 + jitter (2*repeat gap +
 * code length).  We use this interval as the chip
 * resets every time you poll it (bad!).  This is
 * therefore just sufficient to catch all of the
 * button presses.  It makes the remote much more
 * responsive.  You can see the difference by
 * running irw and holding down a button.  With
 * 100ms, the old polling interval, you'll notice
 * breaks in the repeat sequence corresponding to
 * lost keypresses.
 */

But as noted previously, even that doesn't result in correct behavior from
lircd/irw's standpoint.


> Maybe that will help you understand what may be going on.
> (I've lost the bubble on hdpvr with ir-kbd-i2c.)

Not yet. After reading that comment in the code, I'd actually though that
something in the 113 to 130 range might actually be the ticket. I still
think that's probably correct, but it didn't make the wacky repeats stop,
so I think I need to instrument lirc_zilog and/or ir-kbd-i2c a bit more to
get a better idea what's going on.

Oh, and while drifting off to sleep last night, I think I came upon an
explanation for why things behave as they do with that 260ms interval. The
rc_keydown() call has an automatic key release after 250ms.


-- 
Jarod Wilson
jarod@wilsonet.com



