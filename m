Return-path: <mchehab@pedra>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:7263 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753376Ab1AOV5M (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 15 Jan 2011 16:57:12 -0500
Subject: Re: [PATCH] hdpvr: enable IR part
From: Andy Walls <awalls@md.metrocast.net>
To: Jarod Wilson <jarod@wilsonet.com>
Cc: Jean Delvare <khali@linux-fr.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Janne Grunau <j@jannau.net>, Jarod Wilson <jarod@redhat.com>
In-Reply-To: <C59C652B-B4C2-40B9-A195-7719718ECC9D@wilsonet.com>
References: <20110114195448.GA9849@redhat.com>
	 <1295041480.2459.9.camel@localhost> <20110114220759.GG9849@redhat.com>
	 <661A728F-3CF1-47F3-A650-D17429AF7DF1@wilsonet.com>
	 <1295066141.2459.34.camel@localhost>
	 <0EADA025-77B0-4E8B-A649-F3BE6F2E437B@wilsonet.com>
	 <C59C652B-B4C2-40B9-A195-7719718ECC9D@wilsonet.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 15 Jan 2011 16:56:48 -0500
Message-ID: <1295128608.7147.14.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Sat, 2011-01-15 at 01:56 -0500, Jarod Wilson wrote:
> On Jan 15, 2011, at 12:37 AM, Jarod Wilson wrote:

> >>>>>> Registered IR keymap rc-hauppauge-new
> >>>>>> input: i2c IR (HD PVR) as /devices/virtual/rc/rc1/input6
> >>>>>> rc1: i2c IR (HD PVR) as /devices/virtual/rc/rc1
> >>>>>> ir-kbd-i2c: i2c IR (HD PVR) detected at i2c-1/1-0071/ir0 [Hauppage HD PVR I2C]

> Okay, last spam before I head off to bed... :)
> 
> I can get ir-kbd-i2c behavior to pretty much match lirc_zilog wrt key repeat,
> by simply setting init_data->polling_interval = 260; in hdpvr-i2c.c, which
> matches up with the delay in lirc_zilog. With the 260 interval:

RC-5 has a repetition interval of about 4096/36kHz = 113.8 ms, IIRC.  

Using 260 ms, you are throwing away one repeat from the remote for sure,
maybe two.  Maybe that will help you understand what may be going on.
(I've lost the bubble on hdpvr with ir-kbd-i2c.)

Regards,
Andy

> Event: time 1295072449.490542, -------------- Report Sync ------------
> Event: time 1295072453.321206, type 4 (Misc), code 4 (ScanCode), value 15
> Event: time 1295072453.321245, type 1 (Key), code 108 (Down), value 1
> Event: time 1295072453.321252, -------------- Report Sync ------------
> Event: time 1295072453.570512, type 1 (Key), code 108 (Down), value 0
> Event: time 1295072453.570544, -------------- Report Sync ------------
> Event: time 1295072453.575718, type 4 (Misc), code 4 (ScanCode), value 15
> Event: time 1295072453.575744, type 1 (Key), code 108 (Down), value 1
> Event: time 1295072453.575752, -------------- Report Sync ------------
> Event: time 1295072453.816215, type 4 (Misc), code 4 (ScanCode), value 15
> Event: time 1295072454.065515, type 1 (Key), code 108 (Down), value 0
> Event: time 1295072454.065544, -------------- Report Sync ------------
> 
> Lowering this a bit, I can get split personality, one press will look like
> what I was originally seeing, another will look like the 260 output.
> 
> Adding filtering (return 0 if buf[0] != 0x80) doesn't help any.
> 
> The final thing I've noticed tonight is that ir-kbd-i2c calls rc_keydown
> using a value of 0 for its 3rd parameter. From rc-main.c:
> 
>  * @toggle:     the toggle value (protocol dependent, if the protocol doesn't
>  *              support toggle values, this should be set to zero)
> 
> Well, in this case, the protocol *does* use a toggle, so that's probably
> something that could use fixing. Not sure it actually has anything to do with
> the odd repeats I'm seeing. Okay, wasn't too much work to pass along toggle
> values too, but it didn't help any.
> 
> I'll sleep on it.






