Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mx3.orcon.net.nz ([219.88.242.53] ident=Debian-exim)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <mcree@orcon.net.nz>) id 1K5HI5-000456-Gu
	for linux-dvb@linuxtv.org; Sun, 08 Jun 2008 11:34:25 +0200
Received: from Debian-exim by mx3.orcon.net.nz with local (Exim 4.67)
	(envelope-from <mcree@orcon.net.nz>) id 1K5HHz-0006VB-A1
	for linux-dvb@linuxtv.org; Sun, 08 Jun 2008 21:34:15 +1200
Received: from 60-234-221-162.bitstream.orcon.net.nz ([60.234.221.162]
	helo=[192.168.1.2]) by mx3.orcon.net.nz with esmtpa (Exim 4.67)
	(envelope-from <mcree@orcon.net.nz>) id 1K5HHy-0006Ux-O1
	for linux-dvb@linuxtv.org; Sun, 08 Jun 2008 21:34:14 +1200
Message-ID: <484BA795.8010701@orcon.net.nz>
Date: Sun, 08 Jun 2008 21:34:13 +1200
From: Michael Cree <mcree@orcon.net.nz>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] Problems (bug?) with Hauppauge Nova T 500
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

I am getting 'I2C read failed' and 'ep 0 read error' errors with a 
Hauppauge Nova T 500 PCI card. I managed to get a scan done and locate 
channels (after many tries) and get a signal lock, but eventually 
(usually within 30secs of trying to use the card) the card fouls up with 
I2C errors and the like, and then there is no more response with tools 
like tzap, until a cold restart.

I originally started with kernel 2.6.24.5; upgraded to kernel 2.6.25.4 
and problem remained; upgraded the v4l install from mercurial source (at 
commit afa24b594522$) and problem remains.

Using firmware: dvb-usb-dib0700-1.10.fw

This is running on a Compaq Alpha XP1000 workstation. It has a 667Mhz 
Alpha EV67 cpu.  Running Debian Lenny.

Modprobe options:
options dvb-usb disable_rc_polling=1 debug=1
options dvb-usb-dib0700 force_lna_activation=1 debug=1

Typical dmesg log (after removing lines of no relevance) on system 
powerup is:

usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 4 ports detected
usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb2: Product: EHCI Host Controller
usb usb2: Manufacturer: Linux 2.6.25.4 ehci_hcd
usb usb2: SerialNumber: 0001:02:0a.2
usb 1-1: new full speed USB device using ohci_hcd and address 2
usb 1-1: configuration #1 chosen from 1 choice
usb 1-1: New USB device found, idVendor=0403, idProduct=6001
usb 1-1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
usb 1-1: Product: USB to Serial Cable
usb 1-1: Manufacturer: FTDI
usb 1-1: SerialNumber: FTCX9KJL
usb 1-2: new full speed USB device using ohci_hcd and address 3
usb 1-2: not running at top speed; connect to a high speed hub
usb 1-2: configuration #1 chosen from 1 choice
hub 1-2:1.0: USB hub found
hub 1-2:1.0: 4 ports detected
usb 1-2: New USB device found, idVendor=05e3, idProduct=0606
usb 1-2: New USB device strings: Mfr=0, Product=1, SerialNumber=0
usb 1-2: Product: USB2.0 Hub
usb 2-1: new high speed USB device using ehci_hcd and address 2
usb 2-1: configuration #1 chosen from 1 choice
usb 2-1: New USB device found, idVendor=2040, idProduct=9950
usb 2-1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
usb 2-1: Product: WinTV Nova-DT
usb 2-1: Manufacturer: Hauppauge
usb 2-1: SerialNumber: 4030272356
usb 1-2.2: new low speed USB device using ohci_hcd and address 4
usb 1-2.2: configuration #1 chosen from 1 choice
usb 1-2.2: New USB device found, idVendor=04d9, idProduct=0499
usb 1-2.2: New USB device strings: Mfr=0, Product=0, SerialNumber=0
dib0700: loaded with support for 7 different device-types
check for cold 10b8 1e14
check for cold 10b8 1e78
check for cold 2040 7050
check for cold 2040 7060
check for cold 7ca a807
check for cold 7ca b808
check for cold 185b 1e78
check for cold 185b 1e80
check for cold 1584 6003
check for cold 413 6f00
check for cold 413 6f01
check for cold 7ca b568
check for cold 1044 7001
check for cold 2040 9941
check for cold 2040 9950
FW GET_VERSION length: -32
cold: 1
cold: 1
dvb-usb: found a 'Hauppauge Nova-T 500 Dual DVB-T' in cold state, will 
try to load a firmware
dvb-usb: downloading firmware from file 'dvb-usb-dib0700-1.10.fw'
dib0700: firmware started successfully.
dvb-usb: found a 'Hauppauge Nova-T 500 Dual DVB-T' in warm state.
power control: 1
i2c-adapter i2c-1: SMBus Quick command not supported, can't probe for chips
dvb-usb: will pass the complete MPEG2 transport stream to the software 
demuxer.
DVB: registering new adapter (Hauppauge Nova-T 500 Dual DVB-T)
ep 0 read error (status = -32)
I2C read failed on address b
ep 0 read error (status = -32)
I2C read failed on address a
i2c-adapter i2c-2: SMBus Quick command not supported, can't probe for chips
DVB: registering frontend 0 (DiBcom 3000MC/P)...
MT2060: successfully identified (IF1 = 1217)
dvb-usb: will pass the complete MPEG2 transport stream to the software 
demuxer.
DVB: registering new adapter (Hauppauge Nova-T 500 Dual DVB-T)
i2c-adapter i2c-3: SMBus Quick command not supported, can't probe for chips
DVB: registering frontend 1 (DiBcom 3000MC/P)...
MT2060: successfully identified (IF1 = 1226)
power control: 0
dvb-usb: Hauppauge Nova-T 500 Dual DVB-T successfully initialized and 
connected.
usbcore: registered new interface driver dvb_usb_dib0700


I have created channel config with the following (for New Zealand 
transmission from Te Aroha):

TV 
ONE:674000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_AUTO:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_16:HIERARCHY_NONE:230:310:1200
TV2:674000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_AUTO:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_16:HIERARCHY_NONE:261:311:1201
TVNZ 
6:674000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_AUTO:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_16:HIERARCHY_NONE:262:312:1202
TVNZ 
7:674000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_AUTO:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_16:HIERARCHY_NONE:263:313:1203
TVNZ SPORT 
EXTRA:674000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_AUTO:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_16:HIERARCHY_NONE:264:314:1204
TV3:690000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_AUTO:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_16:HIERARCHY_NONE:450:400:1300
C4:690000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_AUTO:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_16:HIERARCHY_NONE:451:401:1301
Maori 
Television:706000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_AUTO:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_16:HIERARCHY_NONE:550:600:1400
Parliament TV 
:706000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_AUTO:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_16:HIERARCHY_NONE:551:601:1401
Reserved 
3KSD:706000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_AUTO:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_16:HIERARCHY_NONE:552:602:1402
Reserved 
4KSD:706000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_AUTO:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_16:HIERARCHY_NONE:553:603:1403
Reserved 
5KSD:706000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_AUTO:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_16:HIERARCHY_NONE:554:604:1404
Reserved 
6KSD:706000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_AUTO:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_16:HIERARCHY_NONE:555:605:1405
Freeview | 
HD:706000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_AUTO:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_16:HIERARCHY_NONE:556:606:1406
Radio NZ 
National:706000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_AUTO:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_16:HIERARCHY_NONE:0:620:2000
Radio NZ 
Concert:706000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_AUTO:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_16:HIERARCHY_NONE:0:621:2001
tvCentral:706000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_AUTO:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_16:HIERARCHY_NONE:560:610:1408

Since the scan program left all parameters as AUTO variants which my 
version of tzap couldn't cope with, I had to hand code some of the 
parameters (the QAM, transmission mode and guard interval, which 
fortunately the transmission company published on their website).

This much works as a tzap to 'tvnz 6' produced the following:

using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
tuning to 674000000 Hz
video pid 0x0106, audio pid 0x0138
status 00 | signal 5e62 | snr 0000 | ber 001fffff | unc 00000000 |
status 1f | signal 9051 | snr 0000 | ber 0000f990 | unc 00000000 | 
FE_HAS_LOCK
status 1f | signal 9046 | snr 0000 | ber 00000000 | unc 000000d7 | 
FE_HAS_LOCK
status 1f | signal 9059 | snr 0000 | ber 00000000 | unc 00000000 | 
FE_HAS_LOCK
status 1f | signal 9049 | snr 0000 | ber 00000000 | unc 00000000 | 
FE_HAS_LOCK
status 1f | signal 9062 | snr 0000 | ber 00000000 | unc 00000000 | 
FE_HAS_LOCK
status 1f | signal 9048 | snr 0000 | ber 00000000 | unc 00000000 | 
FE_HAS_LOCK

at which point on this trial tzap froze, and the following message 
appeared in the kernel log:

power control: 1
modifying (1) streaming state for 0
data for streaming: 10 11
ep 0 read error (status = -60)
I2C read failed on address a

and similar errors repeat a number of times, terminating with (probably 
when I ctrl-Ced tzap):

  mt2060 I2C write failed


Any suggestions as to what is wrong or to how I should continue to debug 
this one?

Cheerz
Michael.

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
