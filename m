Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from holly.castlecore.com ([89.21.8.102])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <lists@philpem.me.uk>) id 1JX0e3-0008MM-HX
	for linux-dvb@linuxtv.org; Wed, 05 Mar 2008 21:55:26 +0100
Received: from [87.194.114.122] (helo=wolf.philpem.me.uk)
	by holly.castlecore.com with esmtp (Exim 4.68)
	(envelope-from <lists@philpem.me.uk>) id 1JX0dx-0000c5-1q
	for linux-dvb@linuxtv.org; Wed, 05 Mar 2008 20:55:17 +0000
Received: from [10.0.0.8] (cheetah.homenet.philpem.me.uk [10.0.0.8])
	by wolf.philpem.me.uk (Postfix) with ESMTP id A32A01AFDB8D
	for <linux-dvb@linuxtv.org>; Wed,  5 Mar 2008 20:56:07 +0000 (GMT)
Message-ID: <47CF08B2.50008@philpem.me.uk>
Date: Wed, 05 Mar 2008 20:55:14 +0000
From: Philip Pemberton <lists@philpem.me.uk>
MIME-Version: 1.0
To: linux-dvb <linux-dvb@linuxtv.org>
Subject: [linux-dvb] Hauppauge Nova T-500 / Nova-TD Stick (DiBcom
 tuners/demods) - the plot thickens...
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Hi guys,
   I've just bought a Nova-TD stick to replace the Nova-T-500 (which really 
doesn't seem to want to play nice) and as soon as I enabled EIT scanning in 
MythTV, I got this in dmesg:

[ 2780.827260] >>> 02 81 01 f5
[ 2780.828753] <<< ff ff
[ 2780.828761] >>> 02 81 01 fa
[ 2780.830250] <<< 00 00
[ 2780.830550] modifying (1) streaming state for 0
[ 2780.830555] data for streaming: 10 11
[ 2780.830557] >>> 0f 10 11 00
[ 2780.831372] modifying (0) streaming state for 0
[ 2780.831377] data for streaming: 0 10
[ 2780.831378] >>> 0f 00 10 00
[ 2780.836076] modifying (1) streaming state for 0
[ 2780.836086] data for streaming: 10 11
[ 2780.836087] >>> 0f 10 11 00
[ 2780.842428] hub 6-0:1.0: port 1 disabled by hub (EMI?), re-enabling...
[ 2780.842436] usb 6-1: USB disconnect, address 2
[ 2780.842721] >>> 03 80 04 01 c0 00
[ 2780.842728] ep 0 write error (status = -19, len: 6)
[ 2780.842730] MT2266 I2C write failed
[ 2780.842732] >>> 03 80 04 01 c0 00
[ 2780.842735] ep 0 write error (status = -19, len: 6)
[ 2780.842737] MT2266 I2C write failed
[ 2780.842739] >>> 02 81 00 eb
[ 2780.842743] ep 0 read error (status = -19)
[ 2780.842744] <<< e0 93
[ 2780.842746] I2C read failed on address 40
[ 2780.842748] >>> 03 80 00 eb 00 32
[ 2780.842752] ep 0 write error (status = -19, len: 6)
[ 2780.842753] >>> 03 80 00 ec 07 00
[ 2780.842757] ep 0 write error (status = -19, len: 6)
[ 2780.842758] >>> 03 80 05 06 00 00
[ 2780.842762] ep 0 write error (status = -19, len: 6)
[ 2780.842764] >>> 02 81 05 00
[ 2780.842766] ep 0 read error (status = -19)
[ 2780.842768] <<< ac 1f
[ 2780.842770] I2C read failed on address 40
[ 2780.842771] >>> 03 80 03 06 ff ff
[ 2780.842775] ep 0 write error (status = -19, len: 6)
[ 2780.842776] >>> 03 80 03 07 ff ff
[ 2780.842780] ep 0 write error (status = -19, len: 6)
[ 2780.842781] >>> 03 80 03 08 00 07
[ 2780.842785] ep 0 write error (status = -19, len: 6)
[ 2780.842786] >>> 03 80 03 83 00 03
[ 2780.842790] ep 0 write error (status = -19, len: 6)
[ 2780.842791] >>> 03 80 05 00 8a 1f
[ 2780.842795] ep 0 write error (status = -19, len: 6)
[ 3097.541289] modifying (0) streaming state for 0
[ 3097.541294] data for streaming: 0 10
[ 3097.541295] >>> 0f 00 10 00
[ 3097.541301] ep 0 write error (status = -19, len: 4)
[ 3097.541302] dvb-usb: error while stopping stream.
[ 3383.815796] wifi0: rx FIFO overrun; resetting

First point: this is a DiB7000 based device, not a DiB3000 (which is what the 
Nova T-500 has on board -- that and a DiB0700 USB bridge).

Now what caught my eye was the

Now what I find interesting is the "disabled by hub (EMI?)" message -- the 
Nova-TD Stick is connected straight to the motherboard USB header via the 
short (6in) cable that came with the TD.

A quick Google search suggests this might be down to heavy data transfer on 
the USB bus -- the controller can't handle the mass of data (buffer 
overflow?), so it shuts down the port. The Kernel notices that the controller 
has killed the port and restarts it. Most of what I've found seems to point to 
issues with older kernels (2.6.20 RCs mainly) and/or SMP...

This suggests putting a hub in the way might help: 
http://forum.sparkfun.com/viewtopic.php?=&p=25520

And this suggests issues surfacing under high I/O / Ethernet activity: 
http://www.mail-archive.com/linux-usb-users@lists.sourceforge.net/msg18069.html
Of course, the response was "no it's not a kernel bug, it's a bug with your 
device" (which is fair enough because 8/10 times it's NOT the kernel's fault, 
but in the other 2 times... :-/ )

The same thing was reported here with a DDR (Dance Dance Revolution?) pad... 
http://www.linuxquestions.org/questions/linux-hardware-18/usb-device-ddr-pad-keeps-disconnecting-596445/

The last one is interesting because if MythTV is grabbing the EIT, it'll be 
spooling the EIT data to RAM, then decoding it and saving it to the database. 
The database writes involve a good bit of disc access, and the data's going to 
be spooling in at ~20Mbit/sec from the DVB receiver. I wonder if the 
combination of lots of USB I/O, disc I/O, etc. is upsetting the kernel, or the 
USB controller (again - maybe the USB controller's buffer isn't getting 
flushed in time and is overflowing?)

Though that said, 2x20Mbit=40Mbit, which is still well below USB2 High Speed's 
claimed 480Mbit transfer limit. The data is going to be packed into USB data 
frames/packets though, and I suspect the chip will be sending it in 188-byte 
blobs (i.e. full transport stream packets).

I'm going to put my USB thumb-hub in the way (in unpowered mode) and see what 
happens. Given that I've never seen that bug in my syslog before today, and 
that the Fedora 7 / 8 stock kernels seem to be happy with it, I'd like to say 
"kernel bug", but equally I don't want to place the blame on something that is 
rarely the cause of a problem.

I'm also tempted to unplug the wireless card... that last "rx FIFO overrun" is 
making me somewhat suspicious.

-- 
Phil.                         |  (\_/)  This is Bunny. Copy and paste Bunny
lists@philpem.me.uk           | (='.'=) into your signature to help him gain
http://www.philpem.me.uk/     | (")_(") world domination.

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
