Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from widget.gizmolabs.org ([69.55.236.117])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <ecronin@gizmolabs.org>) id 1JrFib-0004Dx-Ga
	for linux-dvb@linuxtv.org; Wed, 30 Apr 2008 19:03:47 +0200
Message-Id: <CAB8636B-64E8-40CB-9D6C-0F52E9CD2394@gizmolabs.org>
From: Eric Cronin <ecronin@gizmolabs.org>
To: linux-dvb@linuxtv.org
Mime-Version: 1.0 (Apple Message framework v919.2)
Date: Wed, 30 Apr 2008 13:03:07 -0400
Subject: [linux-dvb] HVR-1800 failing to detect any QAM256 channels
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1260883259=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--===============1260883259==
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=pgp-sha256; boundary="Apple-Mail-8--660446449"
Content-Transfer-Encoding: 7bit

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--Apple-Mail-8--660446449
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit

Hello,

I have an HP Pavilion OEM'd HVR-1800 that I'm giving a shot at getting  
working (PVR-500 and HDHR are my production analog/digital inputs).

I'm running Mythbuntu 8.04 and have tried both with the bundled  
version of v4l-dvb modules and a hg copy from April 29, and both have  
the same problem:

The card is detected fine and /dev/dvb/* created.  When I run 'scan us- 
Cable-Standard-center-frequencies-QAM256' it detects nothing, even on  
frequencies which I know are QAM256 from the HDHR which is 12" of coax  
away from the HVR-1800.  Here is an example from the HDHR scan:

SCANNING: 759000000 (us-cable:118, us-irc:118)
LOCK: qam256 (ss=90 snq=52 seq=100)
PROGRAM: 1: 6.1 WPVI-HD
PROGRAM: 2: 10.1 WCAU-DT
PROGRAM: 3: 6.2 WPVI-SD
PROGRAM: 4: 6.3 WPVI-WX
PROGRAM: 5: 10.2 WX-PLUS

and from 'scan -v test-chan118' which has just 759000000 in it:

scanning test-chan118
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
 >>> tune to: 759000000:QAM_256
 >>> tuning status == 0x00
 >>> tuning status == 0x00
 >>> tuning status == 0x00
 >>> tuning status == 0x00
 >>> tuning status == 0x00
 >>> tuning status == 0x00
 >>> tuning status == 0x00
 >>> tuning status == 0x00
 >>> tuning status == 0x00
 >>> tuning status == 0x00
WARNING: >>> tuning failed!!!
 >>> tune to: 759000000:QAM_256 (tuning failed)
 >>> tuning status == 0x00
 >>> tuning status == 0x00
 >>> tuning status == 0x00
 >>> tuning status == 0x00
 >>> tuning status == 0x00
 >>> tuning status == 0x00
 >>> tuning status == 0x00
 >>> tuning status == 0x00
 >>> tuning status == 0x00
 >>> tuning status == 0x00
WARNING: >>> tuning failed!!!
ERROR: initial tuning failed
dumping lists (0 services)
Done.

I have checked the physical connections best I can.  Connecting the  
HVR-1800's coax to the PVR-500 sees the analog side of things fine,  
and the correct jack on the HVR-1800 is being used.

I'm not sure where to go from here debugging things, any suggestions  
or more data I can provide?  The modprobe-produced info from dmesg is  
at the end of this message.

Thanks,
Eric

[67182.599444] cx23885 driver version 0.0.1 loaded
[67182.599631] ACPI: PCI Interrupt 0000:02:00.0[A] -> GSI 17 (level,  
low) -> IRQ 17
[67182.599870] CORE cx23885[0]: subsystem: 0070:7801, board: Hauppauge  
WinTV-HVR1800 [card=2,autodetected]
[67182.762076] cx23885[0]: i2c bus 0 registered
[67182.764615] tuner' 2-0042: chip found @ 0x84 (cx23885[0])
[67182.799857] tda829x 2-0042: could not clearly identify tuner  
address, defaulting to 60
[67182.823174] tda18271 2-0060: creating new instance
[67182.859178] TDA18271HD/C1 detected @ 2-0060
[67184.029322] tda829x 2-0042: type set to tda8295+18271
[67185.226752] cx23885[0]: i2c bus 1 registered
[67185.229777] msp3400' 3-0044: MSP5431H-^8 found @ 0x88 (cx23885[0])
[67185.229782] msp3400' 3-0044: MSP5431H-^8 supports radio, mode is  
autodetect and autoselect
[67185.229980] cx23885[0]: i2c bus 2 registered
[67185.257210] tveeprom 1-0050: Hauppauge model 78521, rev C1E9,  
serial# 2639463
[67185.257214] tveeprom 1-0050: MAC address is 00-0D-FE-28-46-67
[67185.257217] tveeprom 1-0050: tuner model is Philips 18271_8295 (idx  
149, type 54)
[67185.257220] tveeprom 1-0050: TV standards NTSC(M) ATSC/DVB Digital  
(eeprom 0x88)
[67185.257223] tveeprom 1-0050: audio processor is CX23887 (idx 42)
[67185.257226] tveeprom 1-0050: decoder processor is CX23887 (idx 37)
[67185.257228] tveeprom 1-0050: has radio, has no IR receiver, has no  
IR transmitter
[67185.257231] cx23885[0]: hauppauge eeprom: model=78521
[67185.343514] cx23885[0]/0: registered device video1 [v4l2]
[67186.513413] cx23885[0]: registered device video2 [mpeg]
[67186.513419] cx23885[0]: cx23885 based dvb card
[67186.544894] MT2131: successfully identified at address 0x61
[67186.544901] DVB: registering new adapter (cx23885[0])
[67186.544905] DVB: registering frontend 0 (Samsung S5H1409 QAM/8VSB  
Frontend)...
[67186.546383] cx23885_dev_checkrevision() Hardware revision = 0xb1
[67186.546396] cx23885[0]/0: found at 0000:02:00.0, rev: 15, irq: 17,  
latency: 0, mmio: 0xf9e00000
[67186.546407] PCI: Setting latency timer of device 0000:02:00.0 to 64

--Apple-Mail-8--660446449
content-type: application/pgp-signature; x-mac-type=70674453;
	name=PGP.sig
content-description: This is a digitally signed message part
content-disposition: inline; filename=PGP.sig
content-transfer-encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.8 (Darwin)

iQEcBAEBCAAGBQJIGKZLAAoJEIgz4Q+coYsSNVAH/Rxjs9Vibx5Ls5Svl1KQlKbV
UjiDscc/bjyWChCs2q7uIxhV2p3anpmEdj+a07XonGvcsyUdEauYwJlJp7meYTrR
zV6D76PBDV6533H/aR9qOFXaHJa771bXXLuUU5YKS3ymxS1tCii78I9fJCIjyGlT
KMR01oP++ljuDcGEarb1aHR24y1M6oIUsXaveei73RlD9pWrWZxzTx2/uXk4uDFt
1Ig8lLkuYIASLmkZjfPrZgx7kmspdFAY8rj116SRW24ckVWBMPoGx3N8+RRAgFvI
h+1PMBfaZo7JG+xsYIGxEtUX5NxodRcvY8TTxz+nr9sGOlGbTuEY3Pj8WUdrNow=
=V1/q
-----END PGP SIGNATURE-----

--Apple-Mail-8--660446449--


--===============1260883259==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1260883259==--
