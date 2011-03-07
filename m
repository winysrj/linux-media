Return-path: <mchehab@pedra>
Received: from stevekez.vm.bytemark.co.uk ([80.68.91.30]:40044 "EHLO
	stevekerrison.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755477Ab1CGJwD (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 7 Mar 2011 04:52:03 -0500
Received: from localhost (localhost.localdomain [127.0.0.1])
	by stevekerrison.com (Postfix) with ESMTP id 0183B162F4
	for <linux-media@vger.kernel.org>; Mon,  7 Mar 2011 09:52:02 +0000 (GMT)
Received: from stevekerrison.com ([127.0.0.1])
	by localhost (stevekez.vm.bytemark.co.uk [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id kS0oNjcm0qJZ for <linux-media@vger.kernel.org>;
	Mon,  7 Mar 2011 09:52:00 +0000 (GMT)
Received: from [10.0.96.131] (unknown [195.26.247.141])
	(Authenticated sender: steve@stevekerrison.com)
	by stevekerrison.com (Postfix) with ESMTPSA id 6B058162B8
	for <linux-media@vger.kernel.org>; Mon,  7 Mar 2011 09:52:00 +0000 (GMT)
Subject: i2c_gate_ctrl question
From: Steve Kerrison <steve@stevekerrison.com>
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 07 Mar 2011 09:52:00 +0000
Message-ID: <1299491520.2189.10.camel@ares>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi media men & women,

I have a question regarding the cxd2820r I'm working on with a couple of
other people.

In my naivety I implemented i2c gate control for the device (to access
the tuner behind it) as a separate i2c device that did the passthrough.
Now that I realise this, it would make sense to use the gate_ctrl
features.

However, picking apart the USB data it looks as though the way the
cxd2820r implements "gate control" isn't immediately compatible with the
implementation seen in other devices.

Example, and I2C send to the tuner at (addr << 1) of:
{ xx, xx, ..., xx}

becomes a write to (demod_addr << 1) of :
{ 09, (addr << 1) | flags, xx, xx, ..., xx}

And an i2c receive is implemented to a receive from the demod address,
not from the tuner address.

So, unless there are open and close gate commands that aren't apparent
from the snoop, or there's something I've missed, all i2c transfers to
the tuner have to be mangled - sorry I mean encapsulated - prior to
sending. To my understanding this doesn't fit in with the gate_ctrl
implementation for i2c.

I haven't had time to examine all other gate control implementations in
the media modules, so if anyone knows any good examples that might work
in a similar way, I'd appreciate the tip-off. Otherwise, would there be
any objections to my implementation of a dummy i2c device that does the
encapsulation?

Regards,
-- 
Steve Kerrison MEng Hons.
http://www.stevekerrison.com/ 


