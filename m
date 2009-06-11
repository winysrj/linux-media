Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtprelay09.ispgateway.de ([80.67.31.43]:55365 "EHLO
	smtprelay09.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754559AbZFKQDP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Jun 2009 12:03:15 -0400
Received: from [79.213.125.59] (helo=[192.168.2.110])
	by smtprelay09.ispgateway.de with esmtpa (Exim 4.68)
	(envelope-from <dominik@dschulz.net>)
	id 1MEmXs-0004Df-CP
	for linux-media@vger.kernel.org; Thu, 11 Jun 2009 17:50:28 +0200
Message-ID: <4A3127AB.70602@dschulz.net>
Date: Thu, 11 Jun 2009 17:50:03 +0200
From: Dominik Schulz <dominik@dschulz.net>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Cannot find all TV stations (cinergy DVB-C)
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

hopefully I am here at the right place to ask. If not please
give me a hint what the right place is.

My setup:
I have a Terratec Cinergy C PCI HD. My system is a openSuse 11.1
with kernel 2.6.27.21-0.1-default.(x86_64). I compiled and installed
the drivers as shown in [1]. I tried both s2-liplianin and the mantis
driver. They all compiled and loaded fine.

typing 'dmesg | grep antis' gives:

----
Mantis 0000:05:02.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
    Mantis Rev 1 [153b:1178], irq: 18, latency: 32
mantis_alloc_buffers (0): DMA=0xbdc50000 cpu=0xffff8800bdc50000 size=65536
mantis_alloc_buffers (0): RISC=0xbd88a000 cpu=0xffff8800bd88a000 size=1000
DVB: registering new adapter (Mantis dvb adapter)
mantis_frontend_init (0): Probing for CU1216 (DVB-C)
mantis_frontend_init (0): found Philips CU1216 DVB-C frontend (TDA10023)
@ 0x0c
mantis_frontend_init (0): Mantis DVB-C Philips CU1216 frontend attach
success
mantis_ca_init (0): Registering EN50221 device
mantis_ca_init (0): Registered EN50221 device
mantis_hif_init (0): Adapter(0) Initializing Mantis Host Interface
input: Mantis VP-2040 IR Receiver as
/devices/pci0000:00/0000:00:1e.0/0000:05:02.0/input/input5
Mantis VP-2040 IR Receiver: unknown key: key=0x00 raw=0x00 down=1
Mantis VP-2040 IR Receiver: unknown key: key=0x00 raw=0x00 down=0
----

Using the scan command or kaffeine I am able to scan for channels
with the initial file de-neftv. This file is not for my region
(Germany, Ilmenau, Wohnungsbaugenossenschaft [WBG]) but brings up
many Premiere and publicly owned TV channels.


My problem:
I am not able to receive any privately owned channels (RTL, Pro/ etc.-).
This is very odd since my flat mate is able to receive these channels.
He uses a MacBook with an elgato USB device and watches TV using the
eyeTV software (MacOS X). He even tried it with my plug and it worked.
He said that he just plugged in the device and installed the software.
He has no extra decryption module (CI) or something.

I searched the web since several weeks, tried a lot of things and
could not manage to get these channels. w_scan does not give me any
channel. I used the precompiled version and compiled it for my own too.
In [2] I found a patch, but i don't know whether it is wise to apply it.


I discovered another odd behavior. Since w_scan does not work
for me I wrote a little script which contained all possible
combinations of frequencies, modulations (QAM256, QAM64) and
symbol rates (6900000, 6875000). Using scan with this file
brings no channels. Even when I after that do a scan with the
de-neftv file I get not a single channel until I reboot my
computer (haven't tried to load/unload modules).


I would be grateful for any suggestions.
Thank you in advance!


Links:
[1]: http://www.linuxtv.org/wiki/index.php/
TerraTec_Cinergy_C_DVB-C#Drivers
[2]:http://translate.google.de/translate?u=http%3A%2F%2Fforum.ubuntu-fi.org%
2Findex.php%3Ftopic%3D18193.0&sl=fi&tl=de&hl=de&ie=UTF-8
