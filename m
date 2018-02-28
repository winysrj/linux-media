Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34103 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753057AbeB1R1T (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 28 Feb 2018 12:27:19 -0500
From: Stanislav Brabec <sbrabec@suse.cz>
Subject: dvb: New unsupported version of Astrometa DVB-T2
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Peter Rosin <peda@axentia.se>
Message-ID: <c2ae2312-be3f-5069-ec1f-aef5b81aef78@suse.cz>
Date: Wed, 28 Feb 2018 18:27:15 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi.

I just purchased a new DVB-T2 USB dongle on Ebay[1].

This dongle reports itself as Astrometa DVB-T2, but it does not work
with the current v4l-dvb kernel (tested with 2942273).

After a teardown[2], I realized, that it has a different (and unknown,
as the manufacturer removed the label) tuner chip, MN88473 and RTL8232P.

w-scan is able to find some multiplexes, but it is not able to tune and
decode, so the tuner seems to be at least partially supported ("Info: no
data from PAT after 2 seconds", see the log in [3]).

MN88473 is not detected, and firmware is not loaded (even if the
previous supported version contains the same chip).

The bundled CD contains Windows drivers.[3]

Could anybody provide me a hint, how to debug it or make it working?

References:
[1] item to purchase: https://www.ebay.com/itm/152240047586 (Wish)
[2] teardown photos: https://photos.app.goo.gl/kWze7I03ksZWNL2C3
[3] files: https://drive.google.com/drive/folders/1N1H8KjpZHz3ruLOc37lSLpMU4fpPRnla?usp=sharing

[   66.521783] usb 1-1.3: new high-speed USB device number 4 using ehci-pci
[   66.642755] usb 1-1.3: New USB device found, idVendor=15f4, idProduct=0131
[   66.642758] usb 1-1.3: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[   66.642760] usb 1-1.3: Product: dvbt2
[   66.642761] usb 1-1.3: Manufacturer: astrometadvbt2
[   66.642763] usb 1-1.3: SerialNumber: 0
[   66.669636] rc_core: IR Remote Control driver registered, major 243
[   66.676299] usb 1-1.3: dvb_usb_v2: found a 'Astrometa DVB-T2' in warm state
[   66.736331] usb 1-1.3: dvb_usb_v2: will pass the complete MPEG2 transport stream to the software demuxer
[   66.736337] dvbdev: DVB: registering new adapter (Astrometa DVB-T2)
[   66.738086] i2c i2c-10: Added multiplexed i2c bus 11
[   66.738088] rtl2832 10-0010: Realtek RTL2832 successfully attached
[   66.738102] usb 1-1.3: DVB: registering adapter 0 frontend 0 (Realtek RTL2832 (DVB-T))...
[   66.739090] r820t 11-001a: creating new instance
[   66.746288] r820t 11-001a: Rafael Micro r820t successfully identified
[   66.751321] Linux video capture interface: v2.00
[   66.754254] rtl2832_sdr rtl2832_sdr.1.auto: Registered as swradio0
[   66.754256] rtl2832_sdr rtl2832_sdr.1.auto: Realtek RTL2832 SDR attached
[   66.754257] rtl2832_sdr rtl2832_sdr.1.auto: SDR API is still slightly experimental and functionality changes may follow
[   66.765294] Registered IR keymap rc-empty
[   66.765315] rc rc0: Astrometa DVB-T2 as /devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.3/rc/rc0
[   66.765338] input: Astrometa DVB-T2 as /devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.3/rc/rc0/input10
[   66.765387] rc rc0: lirc_dev: driver dvb_usb_rtl28xxu registered at minor = 0
[   66.765411] usb 1-1.3: dvb_usb_v2: schedule remote query interval to 200 msecs
[   66.774571] usb 1-1.3: dvb_usb_v2: 'Astrometa DVB-T2' successfully initialized and connected
[   66.774622] usbcore: registered new interface driver dvb_usb_rtl28xxu

-- 
Best Regards / S pozdravem,

Stanislav Brabec
software developer
---------------------------------------------------------------------
SUSE LINUX, s. r. o.                         e-mail: sbrabec@suse.com
Køi¾íkova 148/34 (Corso IIa)                  tel: +49 911 7405384547
186 00 Praha 8-Karlín                          fax:  +420 284 084 001
Czech Republic                                    http://www.suse.cz/
PGP: 830B 40D5 9E05 35D8 5E27 6FA3 717C 209F A04F CD76
