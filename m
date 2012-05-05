Return-path: <linux-media-owner@vger.kernel.org>
Received: from bay0-omc2-s6.bay0.hotmail.com ([65.54.190.81]:29299 "EHLO
	bay0-omc2-s6.bay0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755052Ab2EEMbE convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 5 May 2012 08:31:04 -0400
Message-ID: <BAY154-W22CF587B340668D556C29BC92D0@phx.gbl>
From: Per Wetterberg <dtv00pwg@hotmail.com>
To: <linux-media@vger.kernel.org>
Subject: PCTV 520e - DVB-C not working
Date: Sat, 5 May 2012 14:24:53 +0200
In-Reply-To: <BAY154-W29D14F1C862FA852849E80C92D0@phx.gbl>
References: <BAY154-W29D14F1C862FA852849E80C92D0@phx.gbl>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Hi,


I have problem getting the PCTV 520e to work with DVB-C on Linux. The video output stream is full of defects.
"drxk: SCU_RESULT_INVPAR while sending cmd 0x0203 with params" is printed to the dmesg log when scanning and watching DVB-C channels.
I have no problems scanning and watching DVB-T.


On Windows 7, both DVB-T and DVB-C works fine. So I guess its not an hardware problem or  the quality of the tv signal.


I have tried the drivers that came with kernel 3.3.4 and the latest media drivers built from source.
The dvb-demod-drxk-pctv.fw firmware file is downloaded with the get_dvb_firmware script and copied to /lib/firmware.


I can't figure out what the problem is.
Has anyone got PCTV 520e with DVB-C to work on Linux?


I have attached some log outputs below.


Cheers,
Per






[per@tux ~]$ uname -a
Linux tux 3.3.4-1.fc16.x86_64 #1 SMP Fri Apr 27 20:12:28 UTC 2012 x86_64 x86_64 x86_64 GNU/Linux


Log from initialization on kernel 3.3.4 with latest linux media drivers built from source.
***************************************************************************************************


[  285.856249] usb 2-1.5: new high-speed USB device number 4 using ehci_hcd
[  285.943002] usb 2-1.5: New USB device found, idVendor=2013, idProduct=0251
[  285.943008] usb 2-1.5: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[  285.943013] usb 2-1.5: Product: PCTV 520e
[  285.943016] usb 2-1.5: Manufacturer: PCTV Systems
[  285.943019] usb 2-1.5: SerialNumber: 000000XXXXXX
[  285.962866] Linux media interface: v0.10
[  285.965105] Linux video capture interface: v2.00
[  285.965113] WARNING: You are using an experimental version of the media stack.
[  285.965116] 	As the driver is backported to an older kernel, it doesn't offer
[  285.965119] 	enough quality for its usage in production.
[  285.965122] 	Use it with care.
[  285.965124] Latest git patches (needed if you report a bug to linux-media@vger.kernel.org):
[  285.965127] 	a1ac5dc28d2b4ca78e183229f7c595ffd725241c [media] gspca - sn9c20x: Change the exposure setting of Omnivision sensors
[  285.965130] 	4fb8137c43ebc0f5bc0dde6b64faa9dd1b1d7970 [media] gspca - sn9c20x: Don't do sensor update before the capture is started
[  285.965132] 	c4407fe86d3856f60ec711e025bbe9a0159354a3 [media] gspca - sn9c20x: Set the i2c interface speed
[  285.967402] em28xx: New device PCTV Systems PCTV 520e @ 480 Mbps (2013:0251, interface 0, class 0)
[  285.967407] em28xx: Audio Vendor Class interface 0 found
[  285.967410] em28xx: Video interface 0 found
[  285.967413] em28xx: DVB interface 0 found
[  285.967503] em28xx #0: chip ID is em2884
[  286.261235] em28xx #0: Identified as PCTV QuatroStick nano (520e) (card=86)
[  286.261291] em28xx #0: Config register raw data: 0x78
[  286.261294] em28xx #0: I2S Audio (5 sample rates)
[  286.261296] em28xx #0: No AC97 audio processor
[  286.277834] em28xx #0: v4l2 driver version 0.1.3
[  286.300381] em28xx #0: V4L2 video device registered as video0
[  286.300851] usbcore: registered new interface driver em28xx
[  286.303734] em28xx-audio.c: probing for em28xx Audio Vendor Class
[  286.303739] em28xx-audio.c: Copyright (C) 2006 Markus Rechberger
[  286.303743] em28xx-audio.c: Copyright (C) 2007-2011 Mauro Carvalho Chehab
[  286.304014] Em28xx: Initialized (Em28xx Audio Extension) extension
[  286.308285] WARNING: You are using an experimental version of the media stack.
[  286.308288] 	As the driver is backported to an older kernel, it doesn't offer
[  286.308290] 	enough quality for its usage in production.
[  286.308292] 	Use it with care.
[  286.308293] Latest git patches (needed if you report a bug to linux-media@vger.kernel.org):
[  286.308295] 	a1ac5dc28d2b4ca78e183229f7c595ffd725241c [media] gspca - sn9c20x: Change the exposure setting of Omnivision sensors
[  286.308298] 	4fb8137c43ebc0f5bc0dde6b64faa9dd1b1d7970 [media] gspca - sn9c20x: Don't do sensor update before the capture is started
[  286.308300] 	c4407fe86d3856f60ec711e025bbe9a0159354a3 [media] gspca - sn9c20x: Set the i2c interface speed
[  286.324233] drxk: status = 0x639260d9
[  286.324239] drxk: detected a drx-3926k, spin A3, xtal 20.250 MHz
[  287.719396] DRXK driver version 0.9.4300
[  287.734984] drxk: frontend initialized.
[  287.738016] tda18271 3-0060: creating new instance
[  287.747206] TDA18271HD/C2 detected @ 3-0060
[  288.087250] DVB: registering new adapter (em28xx #0)
[  288.087256] DVB: registering adapter 0 frontend 0 (DRXK DVB-C DVB-T)...
[  288.088101] em28xx #0: Successfully loaded em28xx-dvb
[  288.088112] Em28xx: Initialized (Em28xx dvb Extension) extension








Using czap:
*************
[per@tux ~]$ czap -c comhem_zapc.conf -r "TV6"
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
reading channels from file 'comhem_zapc.conf'
  1 TV6:362000000:INVERSION_AUTO:6875100:FEC_3_4:QAM_64:4102:4358:1135
  1 TV6: f 362000000, s 6875100, i 2, fec 3, qam 3, v 0x1006, a 0x1106, s 0x46f 
status 00 | signal 0000 | snr 00a4 | ber 00000000 | unc 00005e45 | 
status 07 | signal 0000 | snr 00df | ber 00000000 | unc 00005e45 | 
status 1f | signal 0000 | snr 00d9 | ber 00000000 | unc 00005e45 | FE_HAS_LOCK
status 1f | signal 0000 | snr 00d2 | ber 00000000 | unc 000062ba | FE_HAS_LOCK
status 1f | signal 0000 | snr 00e0 | ber 00000000 | unc 00006cad | FE_HAS_LOCK
status 1f | signal 0000 | snr 00da | ber 00000000 | unc 00007604 | FE_HAS_LOCK
status 1f | signal 0000 | snr 00dd | ber 00000000 | unc 00008137 | FE_HAS_LOCK
status 1f | signal 0000 | snr 00e1 | ber 00000000 | unc 00008fd9 | FE_HAS_LOCK
status 1f | signal 0000 | snr 00d7 | ber 00000000 | unc 00009992 | FE_HAS_LOCK
status 1f | signal 0000 | snr 00dd | ber 00000000 | unc 0000a70a | FE_HAS_LOCK


The dmesg output for the command above:
***********************************************
[  845.864724] tda18271: performing RF tracking filter calibration
[  851.066311] tda18271: RF tracking filter calibration complete
[  851.294765] drxk: SCU_RESULT_INVPAR while sending cmd 0x0203 with params:
[  851.294773] drxk: 02 00 00 00 10 00 05 00 03 02                    ..........










When scanning for channels:
********************************
[per@tux ~]$ scan -v -a 0 -t 1 -A 2 /usr/share/dvb/dvb-c/se-comhem 
scanning /usr/share/dvb/dvb-c/se-comhem
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
initial transponder 289500000 6875000 0 3
initial transponder 298000000 6875000 0 3
initial transponder 306000000 6875000 0 3
initial transponder 314000000 6875000 0 3
initial transponder 322000000 6875000 0 3
initial transponder 338000000 6875000 0 3
initial transponder 346000000 6875000 0 3
initial transponder 354000000 6875000 0 3
initial transponder 362000000 6875000 0 3
initial transponder 370000000 6875000 0 3
initial transponder 378000000 6875000 0 3
initial transponder 386000000 6875000 0 3
initial transponder 394000000 6875000 0 3
initial transponder 402000000 6875000 0 3
initial transponder 418000000 6875000 0 3
initial transponder 434000000 6875000 0 3
initial transponder 442000000 6875000 0 3
initial transponder 450000000 6875000 0 3
initial transponder 458000000 6875000 0 3
initial transponder 714000000 6875000 0 3
initial transponder 722000000 6875000 0 3
initial transponder 738000000 6875000 0 3
initial transponder 786000000 6875000 0 3
>>> tune to: 362000000:INVERSION_AUTO:6875000:FEC_NONE:QAM_64
>>> tuning status == 0x00
>>> tuning status == 0x1f
PAT
NIT (actual TS)
Network Name 'Com Hem'
PMT 0x0191 for service 0x07d8
PMT 0x0106 for service 0x046f
PMT 0x0193 for service 0x07d7
PMT 0x0154 for service 0x0bbd
PMT 0x0133 for service 0x0418
PMT 0x0101 for service 0x046d
PMT 0x0108 for service 0x0402
PMT 0x0107 for service 0x03fe
PMT 0x0104 for service 0x040b
PMT 0x0122 for service 0x0411
PMT 0x0192 for service 0x0803
SDT (actual TS)
0x0021 0x03fe: pmt_pid 0x0107 Com Hem -- Eurosport 2 (running, scrambled)
0x0021 0x040b: pmt_pid 0x0104 Com Hem -- CNN (running, scrambled)
0x0021 0x046f: pmt_pid 0x0106 Com Hem -- TV6 (running)


Some of the outputs from the dmesg for the command above:
******************************************************************
[ 1682.537672] drxk: SCU_RESULT_INVPAR while sending cmd 0x0203 with params:
[ 1682.537678] drxk: 02 00 00 00 10 00 05 00 03 02                    ..........
[ 1684.606807] drxk: SCU_RESULT_INVPAR while sending cmd 0x0203 with params:
[ 1684.606813] drxk: 02 00 00 00 10 00 05 00 03 02                    ..........
[ 1701.209388] drxk: SCU_RESULT_INVPAR while sending cmd 0x0203 with params:
[ 1701.209394] drxk: 02 00 00 00 10 00 07 00 03 02                    ..........
[ 1717.568636] drxk: SCU_RESULT_INVPAR while sending cmd 0x0203 with params:
[ 1717.568642] drxk: 02 00 00 00 10 00 07 00 03 02                    ..........


 		 	   		  