Return-path: <linux-media-owner@vger.kernel.org>
Received: from 7of9.schinagl.nl ([88.159.158.68]:50009 "EHLO 7of9.schinagl.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750878Ab3IIImC (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 9 Sep 2013 04:42:02 -0400
Received: from [10.2.0.64] (unknown [10.2.0.64])
	(using TLSv1 with cipher DHE-RSA-CAMELLIA256-SHA (256/256 bits))
	(No client certificate requested)
	by 7of9.schinagl.nl (Postfix) with ESMTPSA id 6AC32202B6
	for <linux-media@vger.kernel.org>; Mon,  9 Sep 2013 10:41:59 +0200 (CEST)
Message-ID: <522D89C7.2080109@schinagl.nl>
Date: Mon, 09 Sep 2013 10:41:43 +0200
From: Oliver Schinagl <oliver+list@schinagl.nl>
MIME-Version: 1.0
CC: "linux-media@ >> linux-media" <linux-media@vger.kernel.org>
Subject: iMon driver with 3.11 no response
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hey Jarod,

I've been using my iMon that came with my silverstone tech case for 
years. This was all using the old methods via lirc etc. With my new 
install I decided to move to devinput and use your brand new and shiny 
driver.

However I get little to no response from either the IR part, the knob or 
the VFD (I just echo "Hello" > /dev/lcd0). The only thing I do know 
works, is powerup (since that's all handled on the PCB itself, that's no 
surprise, but does show the board seems to be still in working order).

The driver (when loading rc-imon-pad first) loads fine, but evtest 
doesn't respond to anything. I tried with lirc initially and devinput 
but also that gave no response. The debug output from imon when loading 
it with debug=1 as follows:

[  568.738241] input: iMON Panel, Knob and Mouse(15c2:ffdc) as 
/devices/pci0000:00/0000:00:1a.2/usb5/5-2/5-2:1.0/input/input19
[  568.746030] imon 5-2:1.0: Unknown 0xffdc device, defaulting to VFD 
and iMON IR
[  568.746033]  (id 0x2e)
[  568.746036] Registered IR keymap rc-imon-pad
[  568.746140] input: iMON Remote (15c2:ffdc) as 
/devices/pci0000:00/0000:00:1a.2/usb5/5-2/5-2:1.0/rc/rc4/input20
[  568.746194] rc4: iMON Remote (15c2:ffdc) as 
/devices/pci0000:00/0000:00:1a.2/usb5/5-2/5-2:1.0/rc/rc4
[  568.754091] imon 5-2:1.0: iMON device (15c2:ffdc, intf0) on usb<5:2> 
initialized
[  568.754116] usbcore: registered new interface driver imon
[  568.755501] imon 5-2:1.0: Looks like you're trying to use an IR 
protocol this device does not support
[  568.755506] imon 5-2:1.0: Unsupported IR protocol specified, 
overriding to iMON IR protocol


If you say that I'd need to double check if the original stuff still 
even works, I'll jerry rig some stuff and make sure that I can test it, 
but since I assume it works just fine, is there some deeper debug level 
that shows even more output? Is there anything else that I can do to 
test it really even works at all? Is evtest able to test the created 
input? It can't be an IR thing, since the knob doesn't produce output 
either, and lsusb shows up fine so communication seems to work to some 
length? THat last warning seems odd though?

Oliver
