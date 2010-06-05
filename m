Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.tu-berlin.de ([130.149.7.33])
	by www.linuxtv.org with esmtp (Exim 4.69)
	(envelope-from <lars.schotte@schotteweb.de>) id 1OL2Oa-0004tq-8s
	for linux-dvb@linuxtv.org; Sun, 06 Jun 2010 01:03:17 +0200
Received: from ms16-1.1blu.de ([89.202.0.34])
	by mail.tu-berlin.de (exim-4.69/mailfrontend-b) with esmtps
	[TLSv1:AES256-SHA:256] for <linux-dvb@linuxtv.org>
	id 1OL2OZ-00070V-8S; Sun, 06 Jun 2010 01:03:15 +0200
Received: from [95.103.170.192] (helo=romy.gusto)
	by ms16-1.1blu.de with esmtpsa (TLS-1.0:DHE_RSA_AES_128_CBC_SHA1:16)
	(Exim 4.69) (envelope-from <lars.schotte@schotteweb.de>)
	id 1OL2OY-0003Tz-K1
	for linux-dvb@linuxtv.org; Sun, 06 Jun 2010 01:03:14 +0200
Date: Sun, 6 Jun 2010 01:03:11 +0200
From: Lars Schotte <lars.schotte@schotteweb.de>
To: linux-dvb@linuxtv.org
Message-ID: <20100606010311.6d98ef7b@romy.gusto>
Mime-Version: 1.0
Subject: [linux-dvb] hvr4000 doesnt work w/ dvb-s2 nor DVB-T
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

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
