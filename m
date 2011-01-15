Return-path: <mchehab@pedra>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:15235 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751090Ab1AOOlh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 15 Jan 2011 09:41:37 -0500
Subject: Re: [PATCH] hdpvr: enable IR part
From: Andy Walls <awalls@md.metrocast.net>
To: Jarod Wilson <jarod@wilsonet.com>
Cc: Jean Delvare <khali@linux-fr.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Janne Grunau <j@jannau.net>, Jarod Wilson <jarod@redhat.com>
In-Reply-To: <0EADA025-77B0-4E8B-A649-F3BE6F2E437B@wilsonet.com>
References: <20110114195448.GA9849@redhat.com>
	 <1295041480.2459.9.camel@localhost> <20110114220759.GG9849@redhat.com>
	 <661A728F-3CF1-47F3-A650-D17429AF7DF1@wilsonet.com>
	 <1295066141.2459.34.camel@localhost>
	 <0EADA025-77B0-4E8B-A649-F3BE6F2E437B@wilsonet.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 15 Jan 2011 09:41:21 -0500
Message-ID: <1295102481.3258.11.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Sat, 2011-01-15 at 00:37 -0500, Jarod Wilson wrote:
> On Jan 14, 2011, at 11:35 PM, Andy Walls wrote:
> 

> 
> A single button press w/ir-kbd-i2c debugging and your patch:
> 
> ir-kbd-i2c: ir_poll_key
> ir-kbd-i2c: get_key_haup_common: received bytes: 80 00 00 fe 54 00        ....T.
> ir-kbd-i2c: ir hauppauge (rc5): s1 r1 t1 dev=30 code=21
> ir-kbd-i2c: ir_poll_key
> ir-kbd-i2c: get_key_haup_common: received bytes: 80 00 00 fe 54 00        ....T.
> ir-kbd-i2c: ir hauppauge (rc5): s1 r1 t1 dev=30 code=21
> ir-kbd-i2c: ir_poll_key
> ir-kbd-i2c: get_key_haup_common: received bytes: 80 00 00 fe 54 00        ....T.
> ir-kbd-i2c: ir hauppauge (rc5): s1 r1 t1 dev=30 code=21
> ir-kbd-i2c: ir_poll_key
> ir-kbd-i2c: get_key_haup_common: received bytes: 80 00 00 fe 54 00        ....T.
> ir-kbd-i2c: ir hauppauge (rc5): s1 r1 t1 dev=30 code=21
> ir-kbd-i2c: ir_poll_key
> ir-kbd-i2c: get_key_haup_common: received bytes: 80 00 00 fe 54 00        ....T.
> ir-kbd-i2c: ir hauppauge (rc5): s1 r1 t1 dev=30 code=21
> ir-kbd-i2c: ir_poll_key
> ir-kbd-i2c: get_key_haup_common: received bytes: 80 00 00 fe 54 00        ....T.
> ir-kbd-i2c: ir hauppauge (rc5): s1 r1 t1 dev=30 code=21
> 


FWIW, here's what an HVR-1600 and ir-kbd-i2c dumped out for me:

ir-kbd-i2c: get_key_haup_common: received bytes: 00 00 00 00 00 00   ......
ir-kbd-i2c: get_key_haup_common: received bytes: 00 00 00 00 00 00   ......
ir-kbd-i2c: get_key_haup_common: received bytes: 80 00 00 fe 24 00   ....$.
ir-kbd-i2c: ir hauppauge (rc5): s1 r1 t1 dev=30 code=9
ir-kbd-i2c: get_key_haup_common: received bytes: 80 00 00 fe 24 00   ....$.
ir-kbd-i2c: ir hauppauge (rc5): s1 r1 t1 dev=30 code=9
ir-kbd-i2c: get_key_haup_common: received bytes: 00 00 00 00 00 00   ......
ir-kbd-i2c: get_key_haup_common: received bytes: 00 00 00 00 00 00   ......
[...]
ir-kbd-i2c: get_key_haup_common: received bytes: 00 00 00 00 00 00   ......
ir-kbd-i2c: get_key_haup_common: received bytes: 00 00 00 00 00 00   ......
ir-kbd-i2c: get_key_haup_common: received bytes: 80 00 00 de 08 00   ......
ir-kbd-i2c: ir hauppauge (rc5): s1 r1 t0 dev=30 code=2
ir-kbd-i2c: get_key_haup_common: received bytes: 80 00 00 de 08 00   ......
ir-kbd-i2c: ir hauppauge (rc5): s1 r1 t0 dev=30 code=2
ir-kbd-i2c: get_key_haup_common: received bytes: 00 00 00 00 00 00   ......
ir-kbd-i2c: get_key_haup_common: received bytes: 00 00 00 00 00 00   ......
ir-kbd-i2c: get_key_haup_common: received bytes: 00 00 00 00 00 00   ......
ir-kbd-i2c: get_key_haup_common: received bytes: 80 00 00 de 08 00   ......
ir-kbd-i2c: ir hauppauge (rc5): s1 r1 t0 dev=30 code=2
ir-kbd-i2c: get_key_haup_common: received bytes: 80 00 00 de 08 00   ......
ir-kbd-i2c: ir hauppauge (rc5): s1 r1 t0 dev=30 code=2
ir-kbd-i2c: get_key_haup_common: received bytes: 80 00 00 de 08 00   ......
ir-kbd-i2c: ir hauppauge (rc5): s1 r1 t0 dev=30 code=2
ir-kbd-i2c: get_key_haup_common: received bytes: 80 00 00 de 08 00   ......
ir-kbd-i2c: ir hauppauge (rc5): s1 r1 t0 dev=30 code=2
ir-kbd-i2c: get_key_haup_common: received bytes: 80 00 00 de 08 00   ......
ir-kbd-i2c: ir hauppauge (rc5): s1 r1 t0 dev=30 code=2
ir-kbd-i2c: get_key_haup_common: received bytes: 00 00 00 00 00 00   ......
ir-kbd-i2c: get_key_haup_common: received bytes: 00 00 00 00 00 00   ......
ir-kbd-i2c: get_key_haup_common: received bytes: 00 00 00 00 00 00   ......
ir-kbd-i2c: get_key_haup_common: received bytes: 80 00 00 fe 08 00   ......
ir-kbd-i2c: ir hauppauge (rc5): s1 r1 t1 dev=30 code=2
ir-kbd-i2c: get_key_haup_common: received bytes: 80 00 00 fe 08 00   ......
ir-kbd-i2c: ir hauppauge (rc5): s1 r1 t1 dev=30 code=2
ir-kbd-i2c: get_key_haup_common: received bytes: 00 00 00 00 00 00   ......
ir-kbd-i2c: get_key_haup_common: received bytes: 00 00 00 00 00 00   ......

I did a momentary press of button '9' and got a single '9'.

I did a press and hold of button '2' during which I accidentally pointed
the remote away from the sensor and then back.  IIRC I got one '2' and
then many '2''s after an initial lag.  (What I might expect from holding
down a keybard key.)

I did a following momentary press of button '2'. I can't recall if I got
one or many '2''s for that.

Regards,
Andy

