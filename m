Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with SMTP id n5DANsVO021502
	for <video4linux-list@redhat.com>; Sat, 13 Jun 2009 06:23:54 -0400
Received: from mail-in-10.arcor-online.net (mail-in-10.arcor-online.net
	[151.189.21.50])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id n5DANbHp009907
	for <video4linux-list@redhat.com>; Sat, 13 Jun 2009 06:23:37 -0400
Received: from mail-in-02-z2.arcor-online.net (mail-in-02-z2.arcor-online.net
	[151.189.8.14]) by mx.arcor.de (Postfix) with ESMTP id CE3EC28ED08
	for <video4linux-list@redhat.com>;
	Sat, 13 Jun 2009 12:23:36 +0200 (CEST)
Received: from mail-in-06.arcor-online.net (mail-in-06.arcor-online.net
	[151.189.21.46])
	by mail-in-02-z2.arcor-online.net (Postfix) with ESMTP id C01641141BF
	for <video4linux-list@redhat.com>;
	Sat, 13 Jun 2009 12:23:35 +0200 (CEST)
Received: from linux-z5r4.localnet (dslb-084-058-244-056.pools.arcor-ip.net
	[84.58.244.56])
	by mail-in-06.arcor-online.net (Postfix) with ESMTPS id 92B3539A34D
	for <video4linux-list@redhat.com>;
	Sat, 13 Jun 2009 12:23:34 +0200 (CEST)
From: Armin =?iso-8859-1?q?N=FCckel?= <armin.nueckel@arcor.de>
To: "V4L Mailing List" <video4linux-list@redhat.com>
Date: Sat, 13 Jun 2009 12:24:56 +0200
MIME-Version: 1.0
Message-Id: <200906131224.57163.armin.nueckel@arcor.de>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Subject: Hauppauge USB 2.0 DVB-T WinTV-Nova-T-Stick Lite
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

Dear folks @ V4L List,

I just write this, to mention some words on how to install and use the=20

Hauppauge USB 2.0 DVB-T WinTV-Nova-T-Stick Lite. =20

As usual,=20
I found several infos on the net, but nothing was complete, and sometimes=20
referring Hauppauge WinTV-Nova-T, thus it's not sure=20
if this works all fine also for the "Lite" version. It was the cheapest dvb=
=2Dt=20
stick I was able to find, something like 20Euro.


And here is, how it works (Suse 11.1 distribution):=20

After booting up linux and plugging the t-sick to some USB port,=20

	lsusb

shows

	Bus 002 Device 005: ID 2040:7060 Hauppauge Nova-T Stick 2

and=20

	dmesg=20

should show something like:

	dib0700: loaded with support for 7 different device-types                 =
                                                                           =
                                      =20
	dvb-usb: found a 'Hauppauge Nova-T Stick' in cold state, will try to load =
a firmware                                                                 =
                                      =20
	firmware: requesting dvb-usb-dib0700-1.10.fw                              =
                                                                           =
                                      =20
	dvb-usb: did not find the firmware file. (dvb-usb-dib0700-1.10.fw) Please =
see linux/Documentation/dvb/ for more details on firmware-problems. (-2)   =
                                      =20
	usbcore: registered new interface driver dvb_usb_dib0700 =20


This is, assuming v4l is installed, the firmware is missing. The latest wor=
king version on the net I found is the file:

	dvb-usb-dib0700-1.20.fw

now, the stick needs a file named=20

	dvb-usb-dib0700-1.10.fw

as reported above.
Thus the latest firmware file needs to be renamed, and copied into the=20

	/lib/firmware=20

directory:

	cp Desktop/dvb-usb-dib0700-1.20.fw /lib/firmware/dvb-usb-dib0700-1.10.fw

now, I removed the stick and plugged it again to the USB port.=20

	dmesg=20

shows now:

	dvb-usb: found a 'Hauppauge Nova-T Stick' in cold state, will try to load =
a firmware
	firmware: requesting dvb-usb-dib0700-1.10.fw
	dvb-usb: downloading firmware from file 'dvb-usb-dib0700-1.10.fw'
	dib0700: firmware started successfully.
	dvb-usb: found a 'Hauppauge Nova-T Stick' in warm state.
	dvb-usb: will pass the complete MPEG2 transport stream to the software dem=
uxer.
	DVB: registering new adapter (Hauppauge Nova-T Stick)
	DVB: registering frontend 0 (DiBcom 7000PC)...
	MT2060: successfully identified (IF1 =3D 1220)
	input: IR-receiver inside an USB DVB receiver as /devices/pci0000:00/0000:=
00:02.1/usb2/2-9/2-9.2/input/input5
	dvb-usb: schedule remote query interval to 150 msecs.
	dvb-usb: Hauppauge Nova-T Stick successfully initialized and connected.
	usb 2-9.2: New USB device found, idVendor=3D2040, idProduct=3D7060
	usb 2-9.2: New USB device strings: Mfr=3D1, Product=3D2, SerialNumber=3D3
	usb 2-9.2: Product: Nova-T Stick
	usb 2-9.2: Manufacturer: Hauppauge
	usb 2-9.2: SerialNumber: 4028655835

This is, the firmware has been loaded and the driver strated.=20
There are now new device enties seen with=20

	ls /dev/dvb/adapter0/

	demux0     dvr0       frontend0  net0

thus, the device driver is installed, and the application can access the US=
B stick via these named pipes.
(I assume, the sometimes reported=20

	/dev/video0

device entry is used togehter with some older version of the v4l driver sof=
tware, I'm not sure at this point..)

Having said this, clearly some palyer/toos may not work.=20
just to mention Xine, mplayer and kaffeine are.  And here is what needs to =
be done:

=46irst, the default installation of Kaffeine is not supporting mpeg stream=
s. Even if all codec are istalled,
Kaffeine can not find them correctly. The simplest way (I found) to fix thi=
s is to resinstall Kaffeine from some=20
packman repository, not from Suse directly. This seems to be due to legal i=
ssues with suse, for what reason ever,
this problem disappears after installation of Kaffeine from Packman.=20

After launching Kaffeine, a message appears like "no device found". This is=
,=20
Kaffeine needs to be told explicitely, that the device=20

	dvbt 0:0=20

should be used. The device can be selected from the Kaffeine configuration =
menu.=20

Kaffeine has a build in scanner for to determine the frequencies used from =
some sender.
Using Kaffeine to check for channels, the konsole output looks like:

	Not able to lock to the signal on the given frequency
	Frontend closed
	dvbsi: Cant tune DVB
	Using DVB device 0:0 "DiBcom 7000PC"
	tuning DVB-T to 578000000 Hz
	inv:2 bw:0 fecH:9 fecL:9 mod:6 tm:2 gi:4 hier:4
	.. LOCKED.
	Transponders: 22/57
	scanMode=3D0
	it's dvb 2!=09
	Reading SDT: pid=3D17
	RTL Television: sid=3D16405
	RTL2: sid=3D16406
	Super RTL: sid=3D16411
	VOX: sid=3D16418=09
	Reading PAT: pid=3D0
	Reading PMT: pid=3D336
	Reading PMT: pid=3D352
	Reading PMT: pid=3D368
	Reading PMT: pid=3D544
	Frontend closed

This means, that sometimes there is no sender found, and the later text=20
indicated four sender found on one frequency. (this is usual, because=20
of compression usage: four tv-channels share one frequency).

Now, in the Rhein/Main area in the south near of Frankfurt am Main, somethi=
ng like 22 dvb-t sender are found.
These are listed in the kaffeine konfiguration window and can be seletcted =
and added to the ones actually=20
used by kaffeine.=20

Similar: xine

to find the channels, xine needs a configuration file, usually named channe=
ls.conf, loos like:

	Doku/KiKa:482000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_1_2:QAM_16:=
TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_4:HIERARCHY_NONE:593:594:517
	ZDFinfokanal:482000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_1_2:QAM_=
16:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_4:HIERARCHY_NONE:577:578:516
	RTL Television:578000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_1_2:QA=
M_16:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_4:HIERARCHY_NONE:337:338:16405
	....
	Bibel TV:818000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_1_2:QAM_16:T=
RANSMISSION_MODE_8K:GUARD_INTERVAL_1_4:HIERARCHY_NONE:673:674:16426

one line of ascii code for each channel.=20
This file can be created using the v4l tool:

	scan /usr/share/dvb/dvb-t/de-Frankfurt

utilizing some default file for Frankfurt area. The prints someting like:=20


scanning /usr/share/dvb/dvb-t/de-Frankfurt
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
=2E...
>>> tune to: 818000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_=
16:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_4:HIERARCHY_NONE
0x0000 0x401d: pmt_pid 0x01d0 BetaDigital -- TELE 5 (running)
0x0000 0x4024: pmt_pid 0x0240 MEDIA BROADCAST -- Eurosport (running)
0x0000 0x402a: pmt_pid 0x02a0 MEDIA BROADCAST -- Bibel TV (running)
0x0000 0x4b00: pmt_pid 0x0b00 MEDIA BROADCAST -- rheinmaintv (running)

than, dumps the channels.conf lines on the konsole window...
Thus better to use:

scan /usr/share/dvb/dvb-t/de-Frankfurt > channels.conf

and pipe the stdout directly to the right filename (Cut and paste from the =
console output should work also).
Xine searches for this file in the=20

	/home/<username>/.xine=20

directory, thus the file channels.conf needs to be created or copied in(to)=
 this directory.=20

:-)
Armin

PS.: Just for sake of completeness,

	modprobe -l |grep  dib

shows:

	/lib/modules/2.6.27.23-0.1-default/kernel/drivers/media/dvb/frontends/dib3=
000mb.ko
	/lib/modules/2.6.27.23-0.1-default/kernel/drivers/media/dvb/frontends/dib3=
000mc.ko
	/lib/modules/2.6.27.23-0.1-default/kernel/drivers/media/dvb/frontends/dibx=
000_common.ko
	/lib/modules/2.6.27.23-0.1-default/kernel/drivers/media/dvb/frontends/dib7=
000m.ko
	/lib/modules/2.6.27.23-0.1-default/kernel/drivers/media/dvb/frontends/dib7=
000p.ko
	/lib/modules/2.6.27.23-0.1-default/kernel/drivers/media/dvb/frontends/dib0=
070.ko
	/lib/modules/2.6.27.23-0.1-default/kernel/drivers/media/dvb/dvb-usb/dvb-us=
b-dibusb-common.ko
	/lib/modules/2.6.27.23-0.1-default/kernel/drivers/media/dvb/dvb-usb/dvb-us=
b-dibusb-mb.ko
	/lib/modules/2.6.27.23-0.1-default/kernel/drivers/media/dvb/dvb-usb/dvb-us=
b-dibusb-mc.ko
	/lib/modules/2.6.27.23-0.1-default/kernel/drivers/media/dvb/dvb-usb/dvb-us=
b-dib0700.ko



=2D-=20

Armin N=FCckel
63303 Dreieich
Oisterwijkerstr. 49
mobil: +49(0)1728667251

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
