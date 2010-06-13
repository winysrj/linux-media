Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.tu-berlin.de ([130.149.7.33])
	by www.linuxtv.org with esmtp (Exim 4.69)
	(envelope-from <cdurrhau@zedat.fu-berlin.de>) id 1ONkoL-0000os-UP
	for linux-dvb@linuxtv.org; Sun, 13 Jun 2010 12:53:08 +0200
Received: from outpost1.zedat.fu-berlin.de ([130.133.4.66])
	by mail.tu-berlin.de (exim-4.69/mailfrontend-c) with esmtp
	for <linux-dvb@linuxtv.org>
	id 1ONkoL-0004oB-4Y; Sun, 13 Jun 2010 12:53:05 +0200
Received: from inpost2.zedat.fu-berlin.de ([130.133.4.69])
	by outpost1.zedat.fu-berlin.de (Exim 4.69)
	for linux-dvb@linuxtv.org with esmtp
	(envelope-from <cdurrhau@zedat.fu-berlin.de>)
	id <1ONkoK-0006Gz-Q3>; Sun, 13 Jun 2010 12:53:04 +0200
Received: from portal.zedat.fu-berlin.de ([130.133.3.2])
	by inpost2.zedat.fu-berlin.de (Exim 4.69)
	for linux-dvb@linuxtv.org with esmtp
	(envelope-from <cdurrhau@zedat.fu-berlin.de>)
	id <1ONkoK-0006F8-Nh>; Sun, 13 Jun 2010 12:53:04 +0200
Message-ID: <65183.188.105.18.18.1276426384.webmail@portal.zedat.fu-berlin.de>
Date: Sun, 13 Jun 2010 12:53:04 +0200
From: cdurrhau@zedat.fu-berlin.de
To: linux-dvb@linuxtv.org
MIME-Version: 1.0
Subject: [linux-dvb] Cinergy C PCI HD with current v4l-dvb
Reply-To: linux-media@vger.kernel.org
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/options/linux-dvb>,
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

Hello,

once in a while, a server with three Terratec Cinergy C DVB-C PCI HD cards
will just become unresponsive and the watchdog of the BMC will timeout,
causing a reset. While this is a good thing - as opposed to just sitting
there and having crashed - I am digging at the cause.

Hardware has been tested and partly swapped already. Memtest says the 8GB
ECC memory of Crucial is fine after 48hrs. Power supply has been swapped,
CPU works fine and I don't see any reason why the system should be too hot
(neither by touching nor by checking the sensors). Most of the time, the
CPU (Xeon L3360) is clocked at 2GHz anyway (its just digging in its nose i
believe). HDD also has no errors according to SMART and to self test.
The mainboard is an Asus P5BP-E/4L. The cpu is cooled by the boxed HSF,
additionally, 3 Papst fans blowing air on the hdds (2x 8cm) and sucking
air out (12cm on the rear). 1 WD VelociRaptor 146GB and 8x WD 1001FALS
Caviar Black are being used on a 3Ware 7690SA-8i with 9.5.3 codeset
drivers and firmware.

The crash will always happen similar to this (I cannot reproduce it
safely, though):
-zap with vdr (streaming out via network, no local output)
-while running several recordings on different transport streams at the
same time
-preferrably on services that dont have highest signal quality

As I said, this will produce a lockup once in a while but of course not if
you try to reproduce the problem :-)

This is what I get on the remote console via IPMI:
40849.442492] BUG: soft lockup - CPU#2 stuck for 61s! [section
handler:4617]
[40849.442501] Stack:
[40849.442501] Call Trace:
[40849.442501] Code: 48 c7 c2 ae 06 03 81 48 c7 c1 b1 06 03 81 e9 fe
fe ff ff 90 90 90 90 90 90 55 b8 00 01 00 00 48 89 e5 f0 66 0f c1 07
38 e0 74 06 <f3> 90 8a 07 eb f6 c9 c3 66 0f 1f 44 00 00 55 48 89 e5 0f
b7 07
[40850.513743] BUG: soft lockup - CPU#3 stuck for 61s! [tuner on
device:4495]
[40850.513751] Stack:
[40850.513751] Call Trace:
[40850.513751] Code: c2 ae 06 03 81 48 c7 c1 b1 06 03 81 e9 fe fe ff
ff 90 90 90 90 90 90 55 b8 00 01 00 00 48 89 e5 f0 66 0f c1 07 38 e0
74 06 f3 90 <8a> 07 eb f6 c9 c3 66 0f 1f 44 00 00 55 48 89 e5 0f b7 07
38 e0

This will then have the watchdog timer time out and cause the configured
reset to happen via the BMC.

Since I was digging, I found that although I have the 153B:1178 device
mentioned in mantis_vp2040.h, the dmesg is reporting "VP-2033 found".
Then, both the tda10021 and tda10023 are loaded (I understand only
tda10023 should be loaded).

Can I have a suggestion what to do?

(BTW: When I have been using the s2-liplianin set some months earlier, I
modified the msleep parameters in the set and recompiled, improving the
situation drastically; I provided a diff and somebody else suggested it
might have to do also with DMA:
http://www.vdr-portal.de/board/thread.php?threadid=77704&page=5&sid=cf8ec9ff4a5b5c8b78ac5234a2140ef5
)


_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
