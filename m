Return-path: <mchehab@pedra>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:47788 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752487Ab1ASFUt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 19 Jan 2011 00:20:49 -0500
Received: by vws16 with SMTP id 16so212389vws.19
        for <linux-media@vger.kernel.org>; Tue, 18 Jan 2011 21:20:48 -0800 (PST)
Subject: Re: [GIT PATCHES for 2.6.38] Zilog Z8 IR unit fixes
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=us-ascii
From: Jarod Wilson <jarod@wilsonet.com>
In-Reply-To: <1295234982.2407.38.camel@localhost>
Date: Wed, 19 Jan 2011 00:20:44 -0500
Cc: linux-media@vger.kernel.org, Mike Isely <isely@isely.net>,
	Jarod Wilson <jarod@redhat.com>,
	Jean Delvare <khali@linux-fr.org>, Janne Grunau <j@jannau.net>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Content-Transfer-Encoding: 7bit
Message-Id: <848D2317-613E-42B1-950D-A227CFF15C5B@wilsonet.com>
References: <1295205650.2400.27.camel@localhost> <1295234982.2407.38.camel@localhost>
To: Andy Walls <awalls@md.metrocast.net>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Jan 16, 2011, at 10:29 PM, Andy Walls wrote:

> On Sun, 2011-01-16 at 14:20 -0500, Andy Walls wrote:
>> Mauro,
>> 
>> Please pull the one ir-kbd-i2c change and multiple lirc_zilog changes
>> for 2.6.38.
>> 
>> The one ir-kbd-i2c change is to put back a case to have ir-kbd-i2c set
>> defaults for I2C client address 0x71.  I know I was the one who
>> recommend that ir-kbd-i2c not do this, but I discovered pvrusb2 and bttv
>> rely on it for the moment - Mea culpa.
>> 
>> The lirc_zilog changes are tested to work with both Tx and Rx with an
>> HVR-1600.  I don't want to continue much further on lirc_zilog changes,
>> unitl a few things happen:
>> 
>> 1. I have developed, and have had tested, a patch for the pvrusb2 driver
>> to allow the in kernel lirc_zilog to bind to a Z8 on a pvrusb2 supported
>> device.
> 
> Mauro,
> 
> I have developed a patch for pvrusb2 and Mike Isely provided his Ack.  I
> have added it to my "z8" branch and this pull request.

I've finally got around to trying it out with the HVR-1950 I've got here,
and it does do the trick for ir-kbd-i2c (albeit I never see proper key
repeats, only alternating press/release key events). Not working with
lirc_zilog yet, it fails to load, due to an -EIO ret to one of the
i2c_master_send() calls in lirc_zilog during probe of the TX side. Haven't
looked into it any more than that yet.


>> 2. Jarrod finishes his changes related to the Z8 chip for hdpvr and they
>> are pulled into media_tree.git branch.

They're in now. Still need to tweak the ir-kbd-i2c usage by hdpvr a bit,
but at least I'm close to having other hardware to compare and contrast
with, behavior-wise.


>> 3. I hear from Jean, or whomever really cares about ir-kbd-i2c, if
>> adding some new fields for struct IR_i2c_init_data is acceptable.
>> Specifically, I'd like to add a transceiver_lock mutex, a transceiver
>> reset callback, and a data pointer for that reset callback.
>> (Only lirc_zilog would use the reset callback and data pointer.)
>> 
>> 4. I find spare time ever again.

Ha, I feel your pain... ;)

-- 
Jarod Wilson
jarod@wilsonet.com



