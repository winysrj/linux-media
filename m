Return-path: <linux-media-owner@vger.kernel.org>
Received: from ms16-1.1blu.de ([89.202.0.34]:45135 "EHLO ms16-1.1blu.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933756Ab0FFAS3 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 5 Jun 2010 20:18:29 -0400
Received: from [95.103.170.192] (helo=romy.gusto)
	by ms16-1.1blu.de with esmtpsa (TLS-1.0:DHE_RSA_AES_128_CBC_SHA1:16)
	(Exim 4.69)
	(envelope-from <lars.schotte@schotteweb.de>)
	id 1OL2T4-0005AH-1n
	for linux-media@vger.kernel.org; Sun, 06 Jun 2010 01:07:54 +0200
Date: Sun, 6 Jun 2010 01:07:52 +0200
From: Lars Schotte <lars.schotte@schotteweb.de>
To: linux-media@vger.kernel.org
Subject: hvr4000 doesnt work w/ dvb-s2 nor DVB-T
Message-ID: <20100606010752.4a138f82@romy.gusto>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

hi,
i have a happauge HVR4000 and all works fine, analogue TV and DVB-S was
tested by me so, all would be fine except the fact, that there is
DVB-S2 support noted on the wiki
http://linuxtv.org/wiki/index.php/Hauppauge_WinTV-HVR-4000 site.

so basically my question is, what makes you think, that HVR4000 is able
to play DVB-S2 streams when it doesn't?!

so I have tried this out, run w_scan which printed me also all the
DVB-S2 channels out and provided me a tuning list (channels.conf) and
then I tried to tune in w/ "szap-s2 -S 1 -c ~/.mplayer/channels.conf
ZDFHD"

the output is:
--------------
zapping to 1 'ZDFHD':
delivery DVB-S2, modulation 8PSK (i tried QPSK as well)
sat 0, frequency 11361 MHz H, symbolrate 22000000, coderate auto,
rolloff 0.35 vpid 0x17de, apid 0x17e8, sid 0x2b66
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
status 01 | signal dbc0 | snr 0000 | ber 00000000 | unc 00000000 | 
status 03 | signal db40 | snr 0000 | ber 00000000 | unc 00000000 | 
status 01 | signal dbc0 | snr 0000 | ber 00000000 | unc 00000000 | 
status 01 | signal dbc0 | snr 0000 | ber 00000000 | unc 00000000 | 
--------------

so, and that is basically the same as w/ my old NOVA-S CL.

the fact, that he is not able to get a lock tells me, that there is no
DVB-S2 kind of thing on this HVR4000 and I bought my card for nothing,
except that now I have a newer card, w/ FM and analog TV, maybe DVB-T
as well, but i tested that one as well and it doesn't work as well, so
I wouldn't say that that card is able to do DVB-T as well.

there are USB sticks, like my VOLAR-HD or my Equinox Tube, that ones do
DVB-T really, but not this HVR4000, so it is a 3in1 card w/ DVB-S,
analog TV and FM, at best, as long as I don't know if FM works.

here some data (first lspci -v and then dmesg):

05:02.0 Multimedia video controller: Conexant Systems, Inc.
CX23880/1/2/3 PCI Video and Audio Decoder (rev 05) Subsystem: Hauppauge
computer works Inc. WinTV HVR-4000-HD Flags: bus master, medium devsel,
latency 32, IRQ 18 Memory at fc000000 (32-bit, non-prefetchable)
[size=16M] Capabilities: [44] Vital Product Data
	Capabilities: [4c] Power Management version 2
	Kernel driver in use: cx8800
	Kernel modules: cx8800

05:02.1 Multimedia controller: Conexant Systems, Inc. CX23880/1/2/3 PCI
Video and Audio Decoder [Audio Port] (rev 05) Subsystem: Hauppauge
computer works Inc. Device 6902 Flags: bus master, medium devsel,
latency 32, IRQ 18 Memory at fb000000 (32-bit, non-prefetchable)
[size=16M] Capabilities: [4c] Power Management version 2
	Kernel driver in use: cx88_audio
	Kernel modules: cx88-alsa

05:02.2 Multimedia controller: Conexant Systems, Inc. CX23880/1/2/3 PCI
Video and Audio Decoder [MPEG Port] (rev 05) Subsystem: Hauppauge
computer works Inc. WinTV HVR-4000-HD Flags: bus master, medium devsel,
latency 32, IRQ 18 Memory at fa000000 (32-bit, non-prefetchable)
[size=16M] Capabilities: [4c] Power Management version 2
	Kernel driver in use: cx88-mpeg driver manager
	Kernel modules: cx8802

05:02.4 Multimedia controller: Conexant Systems, Inc. CX23880/1/2/3 PCI
Video and Audio Decoder [IR Port] (rev 05) Subsystem: Hauppauge
computer works Inc. WinTV HVR-4000-HD Flags: bus master, medium devsel,
latency 32, IRQ 7 Memory at f9000000 (32-bit, non-prefetchable)
[size=16M] Capabilities: [4c] Power Management version 2

cx24116_firmware_ondemand: Waiting for firmware upload
(dvb-fe-cx24116.fw)... cx88-mpeg driver manager 0000:05:02.2: firmware:
requesting dvb-fe-cx24116.fw cx24116_firmware_ondemand: Waiting for
firmware upload(2)... cx24116_load_firmware: FW version 1.26.90.0
cx24116_firmware_ondemand: Firmware upload complete
cx24116_firmware_ondemand: Waiting for firmware upload
(dvb-fe-cx24116.fw)... cx88-mpeg driver manager 0000:05:02.2: firmware:
requesting dvb-fe-cx24116.fw cx24116_firmware_ondemand: Waiting for
firmware upload(2)... cx24116_load_firmware: FW version 1.26.90.0
cx24116_firmware_ondemand: Firmware upload complete
cx24116_firmware_ondemand: Waiting for firmware upload
(dvb-fe-cx24116.fw)... cx88-mpeg driver manager 0000:05:02.2: firmware:
requesting dvb-fe-cx24116.fw cx24116_firmware_ondemand: Waiting for
firmware upload(2)... cx24116_load_firmware: FW version 1.26.90.0
cx24116_firmware_ondemand: Firmware upload complete
cx24116_firmware_ondemand: Waiting for firmware upload
(dvb-fe-cx24116.fw)... cx88-mpeg driver manager 0000:05:02.2: firmware:
requesting dvb-fe-cx24116.fw cx24116_firmware_ondemand: Waiting for
firmware upload(2)... cx24116_load_firmware: FW version 1.26.90.0
cx24116_firmware_ondemand: Firmware upload complete
cx24116_firmware_ondemand: Waiting for firmware upload
(dvb-fe-cx24116.fw)... cx88-mpeg driver manager 0000:05:02.2: firmware:
requesting dvb-fe-cx24116.fw cx24116_firmware_ondemand: Waiting for
firmware upload(2)... cx24116_load_firmware: FW version 1.26.90.0
cx24116_firmware_ondemand: Firmware upload complete
cx24116_firmware_ondemand: Waiting for firmware upload
(dvb-fe-cx24116.fw)... cx88-mpeg driver manager 0000:05:02.2: firmware:
requesting dvb-fe-cx24116.fw cx24116_firmware_ondemand: Waiting for
firmware upload(2)... cx24116_load_firmware: FW version 1.26.90.0
cx24116_firmware_ondemand: Firmware upload complete
cx24116_firmware_ondemand: Waiting for firmware upload
(dvb-fe-cx24116.fw)... cx88-mpeg driver manager 0000:05:02.2: firmware:
requesting dvb-fe-cx24116.fw cx24116_firmware_ondemand: Waiting for
firmware upload(2)... cx24116_load_firmware: FW version 1.26.90.0
cx24116_firmware_ondemand: Firmware upload complete
