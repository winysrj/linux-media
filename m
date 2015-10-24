Return-path: <linux-dvb-bounces+mchehab=linuxtv.org@linuxtv.org>
Received: from mail.tu-berlin.de ([130.149.7.33])
	by www.linuxtv.org with esmtp (Exim 4.72)
	(envelope-from <perkins1724@hotmail.com>) id 1ZpwMw-0003KW-Pg
	for linux-dvb@linuxtv.org; Sat, 24 Oct 2015 12:48:40 +0200
Received: from blu004-omc3s21.hotmail.com ([65.55.116.96])
	by mail.tu-berlin.de (exim-4.76/mailfrontend-6) with esmtps
	[UNKNOWN:AES256-SHA256:256] for <linux-dvb@linuxtv.org>
	id 1ZpwMu-0004iY-5Z; Sat, 24 Oct 2015 12:48:14 +0200
Message-ID: <BLU174-W35B48D3D07C92AB7CB6488B7250@phx.gbl>
From: Mark Perkins <perkins1724@hotmail.com>
To: "linux-dvb@linuxtv.org" <linux-dvb@linuxtv.org>
Date: Sat, 24 Oct 2015 20:48:10 +1000
MIME-Version: 1.0
Subject: [linux-dvb] 5th and 6th Sony PlayTV DVB-T device always error (-23)
Reply-To: linux-media@vger.kernel.org
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/options/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1016023321=="
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=linuxtv.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============1016023321==
Content-Type: multipart/alternative;
	boundary="_d1dc9079-ff83-4e9d-914d-992a6914f6a2_"

--_d1dc9079-ff83-4e9d-914d-992a6914f6a2_
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

I'm having difficulties with 6 x Sony PlayTV DVB-T tuners. Essentially the =
first 4 that get plugged in work perfectly fine - but the 5th and 6th retur=
n an error "Sony PlayTV error while loading driver (-23)" and refuse to wor=
k (and no red light on the DVB-T box).
=20
It doesn't matter which port / device gets plugged in first / last=2C its a=
lways the 5th and 6th one that don't work. I disabled xhci but same result.=
 I tried on Ubuntu 14.04 and Centos 7 but exact same result. I tried unplug=
ging every other USB device (keyboard and mouse) but no change. Most troubl=
eshooting has been on Ubuntu.
=20
I created a modprobe.d conf file as follows but no change and didn't find a=
ny new information.
=20
$ cat /etc/modprobe.d/sony-playtv.conf
options dvb_usb debug=3D1
options dvb_usb disable_rc_polling=3D1
=20
I have toggled pretty much every USB setting I can find in bios but always =
the exact same result.
=20
Have I come up against a limitation of the driver or a bug? Any guidance on=
 troubleshooting would be greatly appreciated.
=20
Some further info below.
=20
$ uname -a
Linux mythbackend-master 3.16.0-49-generic #65~14.04.1-Ubuntu SMP Wed Sep 9=
 10:03:23 UTC 2015 x86_64 x86_64 x86_64 GNU/Linux
=20
$ lsusb
Bus 002 Device 002: ID 8087:8001 Intel Corp.
Bus 002 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
Bus 001 Device 002: ID 8087:8009 Intel Corp.
Bus 001 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
Bus 004 Device 001: ID 1d6b:0003 Linux Foundation 3.0 root hub
Bus 003 Device 007: ID 1415:0003 Nam Tai E&E Products Ltd. or OmniVision Te=
chnologies=2C Inc.
Bus 003 Device 006: ID 1415:0003 Nam Tai E&E Products Ltd. or OmniVision Te=
chnologies=2C Inc.
Bus 003 Device 005: ID 05e3:0745 Genesys Logic=2C Inc.
Bus 003 Device 004: ID 1415:0003 Nam Tai E&E Products Ltd. or OmniVision Te=
chnologies=2C Inc.
Bus 003 Device 003: ID 1415:0003 Nam Tai E&E Products Ltd. or OmniVision Te=
chnologies=2C Inc.
Bus 003 Device 011: ID 046d:c227 Logitech=2C Inc. G15 Refresh Keyboard
Bus 003 Device 010: ID 046d:c049 Logitech=2C Inc. G5 Laser Mouse
Bus 003 Device 009: ID 046d:c226 Logitech=2C Inc. G15 Refresh Keyboard
Bus 003 Device 002: ID 046d:c223 Logitech=2C Inc. G11/G15 Keyboard / USB Hu=
b
Bus 003 Device 008: ID 8087:07dc Intel Corp.
Bus 003 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub

$dmesg
[  743.951183] usb 3-1: new high-speed USB device number 12 using xhci_hcd
[  744.079673] usb 3-1: New USB device found=2C idVendor=3D1415=2C idProduc=
t=3D0003
[  744.079680] usb 3-1: New USB device strings: Mfr=3D1=2C Product=3D2=2C S=
erialNumber=3D3
[  744.079684] usb 3-1: Product: SCEH-0036
[  744.079687] usb 3-1: Manufacturer: SONY
[  744.079690] usb 3-1: SerialNumber: ALR001LBTL
[  744.080417] dvb-usb: found a 'Sony PlayTV' in cold state=2C will try to =
load a firmware
[  744.082984] dvb-usb: downloading firmware from file 'dvb-usb-dib0700-1.2=
0.fw'
[  744.148289] dib0700: firmware started successfully.
[  744.650966] dvb-usb: found a 'Sony PlayTV' in warm state.
[  744.651009] dvb-usb: will pass the complete MPEG2 transport stream to th=
e software demuxer.
[  744.651060] dvb-usb: Sony PlayTV error while loading driver (-23)

$ lsusb -t
/:  Bus 04.Port 1: Dev 1=2C Class=3Droot_hub=2C Driver=3Dxhci_hcd/6p=2C 500=
0M
/:  Bus 03.Port 1: Dev 1=2C Class=3Droot_hub=2C Driver=3Dxhci_hcd/14p=2C 48=
0M
    |__ Port 2: Dev 2=2C If 0=2C Class=3DHub=2C Driver=3Dhub/4p=2C 12M
        |__ Port 1: Dev 9=2C If 0=2C Class=3DHuman Interface Device=2C Driv=
er=3Dusbhid=2C 1.5M
        |__ Port 1: Dev 9=2C If 1=2C Class=3DHuman Interface Device=2C Driv=
er=3Dusbhid=2C 1.5M
        |__ Port 3: Dev 10=2C If 0=2C Class=3DHuman Interface Device=2C Dri=
ver=3Dusbhid=2C 12M
        |__ Port 3: Dev 10=2C If 1=2C Class=3DHuman Interface Device=2C Dri=
ver=3Dusbhid=2C 12M
        |__ Port 4: Dev 11=2C If 0=2C Class=3DHuman Interface Device=2C Dri=
ver=3Dusbhid=2C 12M
    |__ Port 3: Dev 3=2C If 0=2C Class=3DVendor Specific Class=2C Driver=3D=
dvb_usb_dib0700=2C 480M
    |__ Port 4: Dev 4=2C If 0=2C Class=3DVendor Specific Class=2C Driver=3D=
dvb_usb_dib0700=2C 480M
    |__ Port 5: Dev 13=2C If 0=2C Class=3DVendor Specific Class=2C Driver=
=3D=2C 480M
    |__ Port 6: Dev 5=2C If 0=2C Class=3DMass Storage=2C Driver=3Dusb-stora=
ge=2C 480M
    |__ Port 7: Dev 6=2C If 0=2C Class=3DVendor Specific Class=2C Driver=3D=
dvb_usb_dib0700=2C 480M
    |__ Port 8: Dev 7=2C If 0=2C Class=3DVendor Specific Class=2C Driver=3D=
dvb_usb_dib0700=2C 480M
    |__ Port 11: Dev 8=2C If 0=2C Class=3DWireless=2C Driver=3Dbtusb=2C 12M
    |__ Port 11: Dev 8=2C If 1=2C Class=3DWireless=2C Driver=3Dbtusb=2C 12M
/:  Bus 02.Port 1: Dev 1=2C Class=3Droot_hub=2C Driver=3Dehci-pci/2p=2C 480=
M
    |__ Port 1: Dev 2=2C If 0=2C Class=3DHub=2C Driver=3Dhub/8p=2C 480M
/:  Bus 01.Port 1: Dev 1=2C Class=3Droot_hub=2C Driver=3Dehci-pci/2p=2C 480=
M
    |__ Port 1: Dev 2=2C If 0=2C Class=3DHub=2C Driver=3Dhub/6p=2C 480M
=20
(only the 5th one plugged in here=2C 6th one unplugged hence why only 1 sho=
wing without driver loaded).
=20
$ modinfo dvb-usb-dib0700
filename:       /lib/modules/3.16.0-49-generic/kernel/drivers/media/usb/dvb=
-usb/dvb-usb-dib0700.ko
license:        GPL
version:        1.0
description:    Driver for devices based on DiBcom DiB0700 - USB bridge
author:         Patrick Boettcher <pboettcher@dibcom.fr>
firmware:       dvb-usb-dib0700-1.20.fw
srcversion:     1BD50D694E5FDD19CBCD02E
alias:          usb:v2013p025Dd*dc*dsc*dp*ic*isc*ip*in*
alias:          usb:v2013p025Cd*dc*dsc*dp*ic*isc*ip*in*
alias:          usb:v0FD9p003Fd*dc*dsc*dp*ic*isc*ip*in*
alias:          usb:v10B8p1F9Cd*dc*dsc*dp*ic*isc*ip*in*
alias:          usb:v10B8p1E6Ed*dc*dsc*dp*ic*isc*ip*in*
alias:          usb:v2304p023Ed*dc*dsc*dp*ic*isc*ip*in*
alias:          usb:v2304p023Dd*dc*dsc*dp*ic*isc*ip*in*
alias:          usb:v1660p1921d*dc*dsc*dp*ic*isc*ip*in*
alias:          usb:v14F7p0004d*dc*dsc*dp*ic*isc*ip*in*
alias:          usb:v10B8p1BB4d*dc*dsc*dp*ic*isc*ip*in*
alias:          usb:v10B8p1BB2d*dc*dsc*dp*ic*isc*ip*in*
alias:          usb:v10B8p2384d*dc*dsc*dp*ic*isc*ip*in*
alias:          usb:v10B8p1FA8d*dc*dsc*dp*ic*isc*ip*in*
alias:          usb:v10B8p2383d*dc*dsc*dp*ic*isc*ip*in*
alias:          usb:v0FD9p0011d*dc*dsc*dp*ic*isc*ip*in*
alias:          usb:v10B8p1FA0d*dc*dsc*dp*ic*isc*ip*in*
alias:          usb:v2304p0248d*dc*dsc*dp*ic*isc*ip*in*
alias:          usb:v2304p0245d*dc*dsc*dp*ic*isc*ip*in*
alias:          usb:v1E59p0002d*dc*dsc*dp*ic*isc*ip*in*
alias:          usb:v1554p5010d[0-2]*dc*dsc*dp*ic*isc*ip*in*
alias:          usb:v1554p5010d3[0-9A-E]*dc*dsc*dp*ic*isc*ip*in*
alias:          usb:v1554p5010d3F00dc*dsc*dp*ic*isc*ip*in*
alias:          usb:v10B8p1F90d*dc*dsc*dp*ic*isc*ip*in*
alias:          usb:v10B8p1F98d*dc*dsc*dp*ic*isc*ip*in*
alias:          usb:v0CCDp00ABd*dc*dsc*dp*ic*isc*ip*in*
alias:          usb:v10B8p1E80d*dc*dsc*dp*ic*isc*ip*in*
alias:          usb:v2013p0248d*dc*dsc*dp*ic*isc*ip*in*
alias:          usb:v2013p0245d*dc*dsc*dp*ic*isc*ip*in*
alias:          usb:v2304p0243d*dc*dsc*dp*ic*isc*ip*in*
alias:          usb:v1164p1E8Cd*dc*dsc*dp*ic*isc*ip*in*
alias:          usb:v1164p1EFCd*dc*dsc*dp*ic*isc*ip*in*
alias:          usb:v0CCDp10A1d*dc*dsc*dp*ic*isc*ip*in*
alias:          usb:v0CCDp10A0d*dc*dsc*dp*ic*isc*ip*in*
alias:          usb:v0413p60F6d*dc*dsc*dp*ic*isc*ip*in*
alias:          usb:v0FD9p0020d*dc*dsc*dp*ic*isc*ip*in*
alias:          usb:v0FD9p0021d*dc*dsc*dp*ic*isc*ip*in*
alias:          usb:v1164p0871d*dc*dsc*dp*ic*isc*ip*in*
alias:          usb:v2040pB210d*dc*dsc*dp*ic*isc*ip*in*
alias:          usb:v2040pB200d*dc*dsc*dp*ic*isc*ip*in*
alias:          usb:v1164p2EDCd*dc*dsc*dp*ic*isc*ip*in*
alias:          usb:v1415p0003d*dc*dsc*dp*ic*isc*ip*in*
alias:          usb:v0CCDp0081d*dc*dsc*dp*ic*isc*ip*in*
alias:          usb:v0CCDp0062d*dc*dsc*dp*ic*isc*ip*in*
alias:          usb:v2304p023Bd*dc*dsc*dp*ic*isc*ip*in*
alias:          usb:v2304p023Ad*dc*dsc*dp*ic*isc*ip*in*
alias:          usb:v0B05p1736d*dc*dsc*dp*ic*isc*ip*in*
alias:          usb:v1164p1F08d*dc*dsc*dp*ic*isc*ip*in*
alias:          usb:v1044p7002d*dc*dsc*dp*ic*isc*ip*in*
alias:          usb:v2040p8400d*dc*dsc*dp*ic*isc*ip*in*
alias:          usb:v2040p5200d*dc*dsc*dp*ic*isc*ip*in*
alias:          usb:v0413p6F01d*dc*dsc*dp*ic*isc*ip*in*
alias:          usb:v0CCDp0078d*dc*dsc*dp*ic*isc*ip*in*
alias:          usb:v0CCDp0060d*dc*dsc*dp*ic*isc*ip*in*
alias:          usb:v1164p1EDCd*dc*dsc*dp*ic*isc*ip*in*
alias:          usb:v2304p0237d*dc*dsc*dp*ic*isc*ip*in*
alias:          usb:v2304p0236d*dc*dsc*dp*ic*isc*ip*in*
alias:          usb:v2304p022Ed*dc*dsc*dp*ic*isc*ip*in*
alias:          usb:v0CCDp0058d*dc*dsc*dp*ic*isc*ip*in*
alias:          usb:v2040p7080d*dc*dsc*dp*ic*isc*ip*in*
alias:          usb:v2040p7070d*dc*dsc*dp*ic*isc*ip*in*
alias:          usb:v0B05p173Fd*dc*dsc*dp*ic*isc*ip*in*
alias:          usb:v0B05p171Fd*dc*dsc*dp*ic*isc*ip*in*
alias:          usb:v05D8p810Fd*dc*dsc*dp*ic*isc*ip*in*
alias:          usb:v1044p7001d*dc*dsc*dp*ic*isc*ip*in*
alias:          usb:v07CApB568d*dc*dsc*dp*ic*isc*ip*in*
alias:          usb:v185Bp1E80d*dc*dsc*dp*ic*isc*ip*in*
alias:          usb:v2304p0229d*dc*dsc*dp*ic*isc*ip*in*
alias:          usb:v10B8p1EBEd*dc*dsc*dp*ic*isc*ip*in*
alias:          usb:v2304p0228d*dc*dsc*dp*ic*isc*ip*in*
alias:          usb:v10B8p1EBCd*dc*dsc*dp*ic*isc*ip*in*
alias:          usb:v10B8p1EF0d*dc*dsc*dp*ic*isc*ip*in*
alias:          usb:v2040p9580d*dc*dsc*dp*ic*isc*ip*in*
alias:          usb:v0CCDp005Ad*dc*dsc*dp*ic*isc*ip*in*
alias:          usb:v2304p022Cd*dc*dsc*dp*ic*isc*ip*in*
alias:          usb:v07CApB808d*dc*dsc*dp*ic*isc*ip*in*
alias:          usb:v2040p7060d*dc*dsc*dp*ic*isc*ip*in*
alias:          usb:v0413p6F00d*dc*dsc*dp*ic*isc*ip*in*
alias:          usb:v1584p6003d*dc*dsc*dp*ic*isc*ip*in*
alias:          usb:v185Bp1E78d*dc*dsc*dp*ic*isc*ip*in*
alias:          usb:v07CApA807d*dc*dsc*dp*ic*isc*ip*in*
alias:          usb:v2040p7050d*dc*dsc*dp*ic*isc*ip*in*
alias:          usb:v2040p9950d*dc*dsc*dp*ic*isc*ip*in*
alias:          usb:v2040p9941d*dc*dsc*dp*ic*isc*ip*in*
alias:          usb:v10B8p1E78d*dc*dsc*dp*ic*isc*ip*in*
alias:          usb:v10B8p1E14d*dc*dsc*dp*ic*isc*ip*in*
depends:        dib7000m=2Cdib7000p=2Cdib8000=2Cdibx000_common=2Cdvb-usb=2C=
dib0090=2Cdib0070=2Cdib3000mc=2Crc-core
intree:         Y
vermagic:       3.16.0-49-generic SMP mod_unload modversions
signer:         Magrathea: Glacier signing key
sig_key:        ED:CF:BF:81:5A:6E:CA:BE:5C:35:0D:4A:AF:8A:8B:80:AE:A6:16:B6
sig_hashalgo:   sha512
parm:           force_lna_activation:force the activation of Low-Noise-Ampl=
ifyer(s) (LNA)=2C if applicable for the device (default: 0=3Dautomatic/off)=
. (int)
parm:           debug:set debugging level (1=3Dinfo=2C2=3Dfw=2C4=3Dfwdata=
=2C8=3Ddata (or-able)). (debugging is not enabled) (int)
parm:           nb_packet_buffer_size:Set the dib0700 driver data buffer si=
ze. This parameter corresponds to the number of TS packets. The actual size=
 of the data buffer corresponds to this parameter multiplied by 188 (defaul=
t: 21) (int)
parm:           adapter_nr:DVB adapter numbers (array of short)

 		 	   		  =

--_d1dc9079-ff83-4e9d-914d-992a6914f6a2_
Content-Type: text/html; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

<html>
<head>
<style><!--
.hmmessage P
{
margin:0px=3B
padding:0px
}
body.hmmessage
{
font-size: 12pt=3B
font-family:Calibri
}
--></style></head>
<body class=3D'hmmessage'><div dir=3D'ltr'>I'm having difficulties with 6 x=
 Sony PlayTV DVB-T tuners. Essentially the first 4 that get plugged in work=
 perfectly fine - but&nbsp=3Bthe 5th and 6th return an error "Sony PlayTV e=
rror while loading driver (-23)" and refuse to work (and no red light on th=
e DVB-T box).<BR>&nbsp=3B<BR>It doesn't matter which port / device gets plu=
gged in first / last=2C its always the 5th and 6th one that don't work. I d=
isabled xhci but same result. I tried on Ubuntu 14.04 and Centos&nbsp=3B7 b=
ut exact same result. I tried unplugging every other USB device (keyboard a=
nd mouse) but no change. Most troubleshooting has been on Ubuntu.<BR>&nbsp=
=3B<BR>I created a modprobe.d conf file as follows but no change and didn't=
 find any new information.<BR>&nbsp=3B<BR>$ cat /etc/modprobe.d/sony-playtv=
.conf<br>options dvb_usb debug=3D1<br>options dvb_usb disable_rc_polling=3D=
1<BR>&nbsp=3B<BR>I have toggled pretty much every USB setting I can find in=
 bios but always the exact same result.<BR>&nbsp=3B<BR>Have I come up again=
st a limitation of the driver or a bug? Any guidance on troubleshooting wou=
ld be greatly appreciated.<BR>&nbsp=3B<BR>Some further info below.<BR>&nbsp=
=3B<BR>$ uname -a<br>Linux mythbackend-master 3.16.0-49-generic #65~14.04.1=
-Ubuntu SMP Wed Sep 9 10:03:23 UTC 2015 x86_64 x86_64 x86_64 GNU/Linux<BR>&=
nbsp=3B<BR>$ lsusb<br>Bus 002 Device 002: ID 8087:8001 Intel Corp.<br>Bus 0=
02 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub<br>Bus 001 Device=
 002: ID 8087:8009 Intel Corp.<br>Bus 001 Device 001: ID 1d6b:0002 Linux Fo=
undation 2.0 root hub<br>Bus 004 Device 001: ID 1d6b:0003 Linux Foundation =
3.0 root hub<br>Bus 003 Device 007: ID 1415:0003 Nam Tai E&amp=3BE Products=
 Ltd. or OmniVision Technologies=2C Inc.<br>Bus 003 Device 006: ID 1415:000=
3 Nam Tai E&amp=3BE Products Ltd. or OmniVision Technologies=2C Inc.<br>Bus=
 003 Device 005: ID 05e3:0745 Genesys Logic=2C Inc.<br>Bus 003 Device 004: =
ID 1415:0003 Nam Tai E&amp=3BE Products Ltd. or OmniVision Technologies=2C =
Inc.<br>Bus 003 Device 003: ID 1415:0003 Nam Tai E&amp=3BE Products Ltd. or=
 OmniVision Technologies=2C Inc.<br>Bus 003 Device 011: ID 046d:c227 Logite=
ch=2C Inc. G15 Refresh Keyboard<br>Bus 003 Device 010: ID 046d:c049 Logitec=
h=2C Inc. G5 Laser Mouse<br>Bus 003 Device 009: ID 046d:c226 Logitech=2C In=
c. G15 Refresh Keyboard<br>Bus 003 Device 002: ID 046d:c223 Logitech=2C Inc=
. G11/G15 Keyboard / USB Hub<br>Bus 003 Device 008: ID 8087:07dc Intel Corp=
.<br>Bus 003 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub<BR><br>=
$dmesg<br>[&nbsp=3B 743.951183] usb 3-1: new high-speed USB device number 1=
2 using xhci_hcd<br>[&nbsp=3B 744.079673] usb 3-1: New USB device found=2C =
idVendor=3D1415=2C idProduct=3D0003<br>[&nbsp=3B 744.079680] usb 3-1: New U=
SB device strings: Mfr=3D1=2C Product=3D2=2C SerialNumber=3D3<br>[&nbsp=3B =
744.079684] usb 3-1: Product: SCEH-0036<br>[&nbsp=3B 744.079687] usb 3-1: M=
anufacturer: SONY<br>[&nbsp=3B 744.079690] usb 3-1: SerialNumber: ALR001LBT=
L<br>[&nbsp=3B 744.080417] dvb-usb: found a 'Sony PlayTV' in cold state=2C =
will try to load a firmware<br>[&nbsp=3B 744.082984] dvb-usb: downloading f=
irmware from file 'dvb-usb-dib0700-1.20.fw'<br>[&nbsp=3B 744.148289] dib070=
0: firmware started successfully.<br>[&nbsp=3B 744.650966] dvb-usb: found a=
 'Sony PlayTV' in warm state.<br>[&nbsp=3B 744.651009] dvb-usb: will pass t=
he complete MPEG2 transport stream to the software demuxer.<br>[&nbsp=3B 74=
4.651060] dvb-usb: Sony PlayTV error while loading driver (-23)<BR><br>$ ls=
usb -t<br>/:&nbsp=3B Bus 04.Port 1: Dev 1=2C Class=3Droot_hub=2C Driver=3Dx=
hci_hcd/6p=2C 5000M<br>/:&nbsp=3B Bus 03.Port 1: Dev 1=2C Class=3Droot_hub=
=2C Driver=3Dxhci_hcd/14p=2C 480M<br>&nbsp=3B&nbsp=3B&nbsp=3B |__ Port 2: D=
ev 2=2C If 0=2C Class=3DHub=2C Driver=3Dhub/4p=2C 12M<br>&nbsp=3B&nbsp=3B&n=
bsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B |__ Port 1: Dev 9=2C If 0=2C Class=
=3DHuman Interface Device=2C Driver=3Dusbhid=2C 1.5M<br>&nbsp=3B&nbsp=3B&nb=
sp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B |__ Port 1: Dev 9=2C If 1=2C Class=3D=
Human Interface Device=2C Driver=3Dusbhid=2C 1.5M<br>&nbsp=3B&nbsp=3B&nbsp=
=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B |__ Port 3: Dev 10=2C If 0=2C Class=3DH=
uman Interface Device=2C Driver=3Dusbhid=2C 12M<br>&nbsp=3B&nbsp=3B&nbsp=3B=
&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B |__ Port 3: Dev 10=2C If 1=2C Class=3DHuma=
n Interface Device=2C Driver=3Dusbhid=2C 12M<br>&nbsp=3B&nbsp=3B&nbsp=3B&nb=
sp=3B&nbsp=3B&nbsp=3B&nbsp=3B |__ Port 4: Dev 11=2C If 0=2C Class=3DHuman I=
nterface Device=2C Driver=3Dusbhid=2C 12M<br>&nbsp=3B&nbsp=3B&nbsp=3B |__ P=
ort 3: Dev 3=2C If 0=2C Class=3DVendor Specific Class=2C Driver=3Ddvb_usb_d=
ib0700=2C 480M<br>&nbsp=3B&nbsp=3B&nbsp=3B |__ Port 4: Dev 4=2C If 0=2C Cla=
ss=3DVendor Specific Class=2C Driver=3Ddvb_usb_dib0700=2C 480M<br>&nbsp=3B&=
nbsp=3B&nbsp=3B |__ Port 5: Dev 13=2C If 0=2C Class=3DVendor Specific Class=
=2C Driver=3D=2C 480M<br>&nbsp=3B&nbsp=3B&nbsp=3B |__ Port 6: Dev 5=2C If 0=
=2C Class=3DMass Storage=2C Driver=3Dusb-storage=2C 480M<br>&nbsp=3B&nbsp=
=3B&nbsp=3B |__ Port 7: Dev 6=2C If 0=2C Class=3DVendor Specific Class=2C D=
river=3Ddvb_usb_dib0700=2C 480M<br>&nbsp=3B&nbsp=3B&nbsp=3B |__ Port 8: Dev=
 7=2C If 0=2C Class=3DVendor Specific Class=2C Driver=3Ddvb_usb_dib0700=2C =
480M<br>&nbsp=3B&nbsp=3B&nbsp=3B |__ Port 11: Dev 8=2C If 0=2C Class=3DWire=
less=2C Driver=3Dbtusb=2C 12M<br>&nbsp=3B&nbsp=3B&nbsp=3B |__ Port 11: Dev =
8=2C If 1=2C Class=3DWireless=2C Driver=3Dbtusb=2C 12M<br>/:&nbsp=3B Bus 02=
.Port 1: Dev 1=2C Class=3Droot_hub=2C Driver=3Dehci-pci/2p=2C 480M<br>&nbsp=
=3B&nbsp=3B&nbsp=3B |__ Port 1: Dev 2=2C If 0=2C Class=3DHub=2C Driver=3Dhu=
b/8p=2C 480M<br>/:&nbsp=3B Bus 01.Port 1: Dev 1=2C Class=3Droot_hub=2C Driv=
er=3Dehci-pci/2p=2C 480M<br>&nbsp=3B&nbsp=3B&nbsp=3B |__ Port 1: Dev 2=2C I=
f 0=2C Class=3DHub=2C Driver=3Dhub/6p=2C 480M<BR>&nbsp=3B<BR>(only the 5th =
one plugged in here=2C 6th one unplugged hence why only 1 showing without d=
river loaded).<BR>&nbsp=3B<BR>$ modinfo dvb-usb-dib0700<br>filename:&nbsp=
=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B /lib/modules/3.16.0-49-generic/=
kernel/drivers/media/usb/dvb-usb/dvb-usb-dib0700.ko<br>license:&nbsp=3B&nbs=
p=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B GPL<br>version:&nbsp=3B&nbsp=
=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B 1.0<br>description:&nbsp=3B&nbs=
p=3B&nbsp=3B Driver for devices based on DiBcom DiB0700 - USB bridge<br>aut=
hor:&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B Patric=
k Boettcher &lt=3B<a href=3D"mailto:pboettcher@dibcom.fr">pboettcher@dibcom=
.fr</a>&gt=3B<br>firmware:&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B =
dvb-usb-dib0700-1.20.fw<br>srcversion:&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B 1BD5=
0D694E5FDD19CBCD02E<br>alias:&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=
=3B&nbsp=3B&nbsp=3B&nbsp=3B usb:v2013p025Dd*dc*dsc*dp*ic*isc*ip*in*<br>alia=
s:&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B =
usb:v2013p025Cd*dc*dsc*dp*ic*isc*ip*in*<br>alias:&nbsp=3B&nbsp=3B&nbsp=3B&n=
bsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B usb:v0FD9p003Fd*dc*dsc*dp*ic=
*isc*ip*in*<br>alias:&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=
=3B&nbsp=3B&nbsp=3B usb:v10B8p1F9Cd*dc*dsc*dp*ic*isc*ip*in*<br>alias:&nbsp=
=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B usb:v10=
B8p1E6Ed*dc*dsc*dp*ic*isc*ip*in*<br>alias:&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&=
nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B usb:v2304p023Ed*dc*dsc*dp*ic*isc*ip=
*in*<br>alias:&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=
=3B&nbsp=3B usb:v2304p023Dd*dc*dsc*dp*ic*isc*ip*in*<br>alias:&nbsp=3B&nbsp=
=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B usb:v1660p1921d=
*dc*dsc*dp*ic*isc*ip*in*<br>alias:&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&=
nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B usb:v14F7p0004d*dc*dsc*dp*ic*isc*ip*in*<br>=
alias:&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=
=3B usb:v10B8p1BB4d*dc*dsc*dp*ic*isc*ip*in*<br>alias:&nbsp=3B&nbsp=3B&nbsp=
=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B usb:v10B8p1BB2d*dc*dsc*=
dp*ic*isc*ip*in*<br>alias:&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&=
nbsp=3B&nbsp=3B&nbsp=3B usb:v10B8p2384d*dc*dsc*dp*ic*isc*ip*in*<br>alias:&n=
bsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B usb:=
v10B8p1FA8d*dc*dsc*dp*ic*isc*ip*in*<br>alias:&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=
=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B usb:v10B8p2383d*dc*dsc*dp*ic*is=
c*ip*in*<br>alias:&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&=
nbsp=3B&nbsp=3B usb:v0FD9p0011d*dc*dsc*dp*ic*isc*ip*in*<br>alias:&nbsp=3B&n=
bsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B usb:v10B8p1F=
A0d*dc*dsc*dp*ic*isc*ip*in*<br>alias:&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=
=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B usb:v2304p0248d*dc*dsc*dp*ic*isc*ip*in*=
<br>alias:&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&=
nbsp=3B usb:v2304p0245d*dc*dsc*dp*ic*isc*ip*in*<br>alias:&nbsp=3B&nbsp=3B&n=
bsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B usb:v1E59p0002d*dc*d=
sc*dp*ic*isc*ip*in*<br>alias:&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=
=3B&nbsp=3B&nbsp=3B&nbsp=3B usb:v1554p5010d[0-2]*dc*dsc*dp*ic*isc*ip*in*<br=
>alias:&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbs=
p=3B usb:v1554p5010d3[0-9A-E]*dc*dsc*dp*ic*isc*ip*in*<br>alias:&nbsp=3B&nbs=
p=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B usb:v1554p5010=
d3F00dc*dsc*dp*ic*isc*ip*in*<br>alias:&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=
=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B usb:v10B8p1F90d*dc*dsc*dp*ic*isc*ip*in*=
<br>alias:&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&=
nbsp=3B usb:v10B8p1F98d*dc*dsc*dp*ic*isc*ip*in*<br>alias:&nbsp=3B&nbsp=3B&n=
bsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B usb:v0CCDp00ABd*dc*d=
sc*dp*ic*isc*ip*in*<br>alias:&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=
=3B&nbsp=3B&nbsp=3B&nbsp=3B usb:v10B8p1E80d*dc*dsc*dp*ic*isc*ip*in*<br>alia=
s:&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B =
usb:v2013p0248d*dc*dsc*dp*ic*isc*ip*in*<br>alias:&nbsp=3B&nbsp=3B&nbsp=3B&n=
bsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B usb:v2013p0245d*dc*dsc*dp*ic=
*isc*ip*in*<br>alias:&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=
=3B&nbsp=3B&nbsp=3B usb:v2304p0243d*dc*dsc*dp*ic*isc*ip*in*<br>alias:&nbsp=
=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B usb:v11=
64p1E8Cd*dc*dsc*dp*ic*isc*ip*in*<br>alias:&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&=
nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B usb:v1164p1EFCd*dc*dsc*dp*ic*isc*ip=
*in*<br>alias:&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=
=3B&nbsp=3B usb:v0CCDp10A1d*dc*dsc*dp*ic*isc*ip*in*<br>alias:&nbsp=3B&nbsp=
=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B usb:v0CCDp10A0d=
*dc*dsc*dp*ic*isc*ip*in*<br>alias:&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&=
nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B usb:v0413p60F6d*dc*dsc*dp*ic*isc*ip*in*<br>=
alias:&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=
=3B usb:v0FD9p0020d*dc*dsc*dp*ic*isc*ip*in*<br>alias:&nbsp=3B&nbsp=3B&nbsp=
=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B usb:v0FD9p0021d*dc*dsc*=
dp*ic*isc*ip*in*<br>alias:&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&=
nbsp=3B&nbsp=3B&nbsp=3B usb:v1164p0871d*dc*dsc*dp*ic*isc*ip*in*<br>alias:&n=
bsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B usb:=
v2040pB210d*dc*dsc*dp*ic*isc*ip*in*<br>alias:&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=
=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B usb:v2040pB200d*dc*dsc*dp*ic*is=
c*ip*in*<br>alias:&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&=
nbsp=3B&nbsp=3B usb:v1164p2EDCd*dc*dsc*dp*ic*isc*ip*in*<br>alias:&nbsp=3B&n=
bsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B usb:v1415p00=
03d*dc*dsc*dp*ic*isc*ip*in*<br>alias:&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=
=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B usb:v0CCDp0081d*dc*dsc*dp*ic*isc*ip*in*=
<br>alias:&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&=
nbsp=3B usb:v0CCDp0062d*dc*dsc*dp*ic*isc*ip*in*<br>alias:&nbsp=3B&nbsp=3B&n=
bsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B usb:v2304p023Bd*dc*d=
sc*dp*ic*isc*ip*in*<br>alias:&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=
=3B&nbsp=3B&nbsp=3B&nbsp=3B usb:v2304p023Ad*dc*dsc*dp*ic*isc*ip*in*<br>alia=
s:&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B =
usb:v0B05p1736d*dc*dsc*dp*ic*isc*ip*in*<br>alias:&nbsp=3B&nbsp=3B&nbsp=3B&n=
bsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B usb:v1164p1F08d*dc*dsc*dp*ic=
*isc*ip*in*<br>alias:&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=
=3B&nbsp=3B&nbsp=3B usb:v1044p7002d*dc*dsc*dp*ic*isc*ip*in*<br>alias:&nbsp=
=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B usb:v20=
40p8400d*dc*dsc*dp*ic*isc*ip*in*<br>alias:&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&=
nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B usb:v2040p5200d*dc*dsc*dp*ic*isc*ip=
*in*<br>alias:&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=
=3B&nbsp=3B usb:v0413p6F01d*dc*dsc*dp*ic*isc*ip*in*<br>alias:&nbsp=3B&nbsp=
=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B usb:v0CCDp0078d=
*dc*dsc*dp*ic*isc*ip*in*<br>alias:&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&=
nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B usb:v0CCDp0060d*dc*dsc*dp*ic*isc*ip*in*<br>=
alias:&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=
=3B usb:v1164p1EDCd*dc*dsc*dp*ic*isc*ip*in*<br>alias:&nbsp=3B&nbsp=3B&nbsp=
=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B usb:v2304p0237d*dc*dsc*=
dp*ic*isc*ip*in*<br>alias:&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&=
nbsp=3B&nbsp=3B&nbsp=3B usb:v2304p0236d*dc*dsc*dp*ic*isc*ip*in*<br>alias:&n=
bsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B usb:=
v2304p022Ed*dc*dsc*dp*ic*isc*ip*in*<br>alias:&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=
=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B usb:v0CCDp0058d*dc*dsc*dp*ic*is=
c*ip*in*<br>alias:&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&=
nbsp=3B&nbsp=3B usb:v2040p7080d*dc*dsc*dp*ic*isc*ip*in*<br>alias:&nbsp=3B&n=
bsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B usb:v2040p70=
70d*dc*dsc*dp*ic*isc*ip*in*<br>alias:&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=
=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B usb:v0B05p173Fd*dc*dsc*dp*ic*isc*ip*in*=
<br>alias:&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&=
nbsp=3B usb:v0B05p171Fd*dc*dsc*dp*ic*isc*ip*in*<br>alias:&nbsp=3B&nbsp=3B&n=
bsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B usb:v05D8p810Fd*dc*d=
sc*dp*ic*isc*ip*in*<br>alias:&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=
=3B&nbsp=3B&nbsp=3B&nbsp=3B usb:v1044p7001d*dc*dsc*dp*ic*isc*ip*in*<br>alia=
s:&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B =
usb:v07CApB568d*dc*dsc*dp*ic*isc*ip*in*<br>alias:&nbsp=3B&nbsp=3B&nbsp=3B&n=
bsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B usb:v185Bp1E80d*dc*dsc*dp*ic=
*isc*ip*in*<br>alias:&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=
=3B&nbsp=3B&nbsp=3B usb:v2304p0229d*dc*dsc*dp*ic*isc*ip*in*<br>alias:&nbsp=
=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B usb:v10=
B8p1EBEd*dc*dsc*dp*ic*isc*ip*in*<br>alias:&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&=
nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B usb:v2304p0228d*dc*dsc*dp*ic*isc*ip=
*in*<br>alias:&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=
=3B&nbsp=3B usb:v10B8p1EBCd*dc*dsc*dp*ic*isc*ip*in*<br>alias:&nbsp=3B&nbsp=
=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B usb:v10B8p1EF0d=
*dc*dsc*dp*ic*isc*ip*in*<br>alias:&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&=
nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B usb:v2040p9580d*dc*dsc*dp*ic*isc*ip*in*<br>=
alias:&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=
=3B usb:v0CCDp005Ad*dc*dsc*dp*ic*isc*ip*in*<br>alias:&nbsp=3B&nbsp=3B&nbsp=
=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B usb:v2304p022Cd*dc*dsc*=
dp*ic*isc*ip*in*<br>alias:&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&=
nbsp=3B&nbsp=3B&nbsp=3B usb:v07CApB808d*dc*dsc*dp*ic*isc*ip*in*<br>alias:&n=
bsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B usb:=
v2040p7060d*dc*dsc*dp*ic*isc*ip*in*<br>alias:&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=
=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B usb:v0413p6F00d*dc*dsc*dp*ic*is=
c*ip*in*<br>alias:&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&=
nbsp=3B&nbsp=3B usb:v1584p6003d*dc*dsc*dp*ic*isc*ip*in*<br>alias:&nbsp=3B&n=
bsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B usb:v185Bp1E=
78d*dc*dsc*dp*ic*isc*ip*in*<br>alias:&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=
=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B usb:v07CApA807d*dc*dsc*dp*ic*isc*ip*in*=
<br>alias:&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&=
nbsp=3B usb:v2040p7050d*dc*dsc*dp*ic*isc*ip*in*<br>alias:&nbsp=3B&nbsp=3B&n=
bsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B usb:v2040p9950d*dc*d=
sc*dp*ic*isc*ip*in*<br>alias:&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=
=3B&nbsp=3B&nbsp=3B&nbsp=3B usb:v2040p9941d*dc*dsc*dp*ic*isc*ip*in*<br>alia=
s:&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B =
usb:v10B8p1E78d*dc*dsc*dp*ic*isc*ip*in*<br>alias:&nbsp=3B&nbsp=3B&nbsp=3B&n=
bsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B usb:v10B8p1E14d*dc*dsc*dp*ic=
*isc*ip*in*<br>depends:&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbs=
p=3B dib7000m=2Cdib7000p=2Cdib8000=2Cdibx000_common=2Cdvb-usb=2Cdib0090=2Cd=
ib0070=2Cdib3000mc=2Crc-core<br>intree:&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbs=
p=3B&nbsp=3B&nbsp=3B&nbsp=3B Y<br>vermagic:&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B=
&nbsp=3B&nbsp=3B 3.16.0-49-generic SMP mod_unload modversions<br>signer:&nb=
sp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B Magrathea: Gl=
acier signing key<br>sig_key:&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=
=3B&nbsp=3B ED:CF:BF:81:5A:6E:CA:BE:5C:35:0D:4A:AF:8A:8B:80:AE:A6:16:B6<br>=
sig_hashalgo:&nbsp=3B&nbsp=3B sha512<br>parm:&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=
=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B force_lna_activation:fo=
rce the activation of Low-Noise-Amplifyer(s) (LNA)=2C if applicable for the=
 device (default: 0=3Dautomatic/off). (int)<br>parm:&nbsp=3B&nbsp=3B&nbsp=
=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B debug:set debug=
ging level (1=3Dinfo=2C2=3Dfw=2C4=3Dfwdata=2C8=3Ddata (or-able)). (debuggin=
g is not enabled) (int)<br>parm:&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nb=
sp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B nb_packet_buffer_size:Set the dib0700=
 driver data buffer size. This parameter corresponds to the number of TS pa=
ckets. The actual size of the data buffer corresponds to this parameter mul=
tiplied by 188 (default: 21) (int)<br>parm:&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B=
&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B adapter_nr:DVB adapter num=
bers (array of short)<br><BR> 		 	   		  </div></body>
</html>=

--_d1dc9079-ff83-4e9d-914d-992a6914f6a2_--


--===============1016023321==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1016023321==--
