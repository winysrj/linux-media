Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from bay0-omc2-s18.bay0.hotmail.com ([65.54.246.154])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <tlli@hotmail.com>) id 1KDggc-0000Aj-T0
	for linux-dvb@linuxtv.org; Tue, 01 Jul 2008 16:18:30 +0200
Message-ID: <BAY136-W51AE9A3EF97CBB5CEA6E0ED29E0@phx.gbl>
From: Alistair M <tlli@hotmail.com>
To: <linux-dvb@linuxtv.org>
Date: Wed, 2 Jul 2008 00:17:50 +1000
MIME-Version: 1.0
Subject: [linux-dvb] Leadtek WinFast DTV Dongle Gold Remote issues
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0529748072=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============0529748072==
Content-Type: multipart/alternative;
	boundary="_6dabda50-ae36-433e-b8da-66e4bb4357f9_"

--_6dabda50-ae36-433e-b8da-66e4bb4357f9_
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable





Hi,

I finally got the usb Leadtek DTV dongle gold tuner working using the below=
 method. The tuner works fine with kaffeine and mythtv, but no luck with th=
e remote (Y04G0044).

1) hg clone http://linuxtv.org/hg/~anttip/af9015-mxl500x  # to get the driv=
er working
then make, make install
2) copied firmware from=20
http://www.otit.fi/~crope/v4l-dvb/af9015/af9015_firmware_cutter/firmware_fi=
les/4.95.0/
to /lib/firmware/

- cat /proc/bus/input/devices produces the following:

I: Bus=3D0003 Vendor=3D0413 Product=3D6029 Version=3D0101
N: Name=3D"Leadtek WinFast DTV Dongle Gold"
P: Phys=3Dusb-0000:00:1d.7-1/input1
S: Sysfs=3D/devices/pci0000:00/0000:00:1d.7/usb5/5-1/5-1:1.1/input/input12
U: Uniq=3D
H: Handlers=3Dkbd event11=20
B: EV=3D120013
B: KEY=3D10000 7 ff9f207a c14057ff febeffdf ffefffff ffffffff fffffffe
B: MSC=3D10
B: LED=3D7

When I try 'cat /dev/input/event11' and press the remote buttons nothing wo=
rks :(
/var/log/messages has the following in relation to the tuner. Please help, =
i've tried several sites, but nothing seems to help. I'm assuming i need to=
 get something out of event11 first, before i even try play with lirc.=20

Thank you in advance.
Alistair

[  111.337644] usb 5-1: new high speed USB device using ehci_hcd and addres=
s 3
[  111.378224] usb 5-1: configuration #1 chosen from 1 choice
[  111.805274] usbcore: registered new interface driver hiddev
[  111.809628] input: Leadtek WinFast DTV Dongle Gold as /devices/pci0000:0=
0/0000:00:1d.7/usb5/5-1/5-1:1.1/input/input11
[  111.829183] input,hidraw0: USB HID v1.01 Keyboard [Leadtek WinFast DTV D=
ongle Gold] on usb-0000:00:1d.7-1
[  111.829225] usbcore: registered new interface driver usbhid
[  111.829234] /build/buildd/linux-2.6.24/drivers/hid/usbhid/hid-core.c: v2=
.6:USB HID core driver
[  111.865039] af9015_usb_probe: interface:0
[  111.865699] af9015_identify_state: reply:01
[  111.865708] dvb-usb: found a 'Leadtek WinFast DTV Dongle Gold' in cold s=
tate, will try to load a firmware
[  111.878222] dvb-usb: downloading firmware from file 'dvb-usb-af9015.fw'
[  111.878232] af9015_download_firmware:
[  111.917252] usbcore: registered new interface driver dvb_usb_af9015
[  111.917941] usb 5-1: USB disconnect, address 3
[  111.924888] dvb-usb: generic DVB-USB module successfully deinitialized a=
nd disconnected.
[   56.173008] usb 5-1: new high speed USB device using ehci_hcd and addres=
s 4
[  112.404488] usb 5-1: configuration #1 chosen from 1 choice
[  112.404938] af9015_usb_probe: interface:0
[  112.405283] af9015_identify_state: reply:02
[  112.405292] dvb-usb: found a 'Leadtek WinFast DTV Dongle Gold' in warm s=
tate.
[  112.405379] dvb-usb: will pass the complete MPEG2 transport stream to th=
e software demuxer.
[  112.406556] DVB: registering new adapter (Leadtek WinFast DTV Dongle Gol=
d)
[  112.407103] af9015_eeprom_dump:
[  112.447578] 00: 31 c2 bb 0b 00 00 00 00 13 04 29 60 00 02 01 02=20
[  112.472211] 10: 00 80 00 fa fa 10 40 ef 01 30 31 30 31 30 32 30=20
[   56.257034] 20: 35 30 35 30 30 30 30 31 ff ff ff ff ff ff ff ff=20
[   56.281646] 30: 00 00 3a 01 00 08 02 00 cc 10 00 00 9c ff ff ff=20
[   56.320001] 40: ff ff ff ff ff 08 02 00 1d 8d c4 04 82 ff ff ff=20
[   56.350569] 50: ff ff ff ff ff 26 00 00 04 03 09 04 10 03 4c 00=20
[   56.389906] 60: 65 00 61 00 64 00 74 00 65 00 6b 00 30 03 57 00=20
[   56.430313] 70: 69 00 6e 00 46 00 61 00 73 00 74 00 20 00 44 00=20
[   56.455303] 80: 54 00 56 00 20 00 44 00 6f 00 6e 00 67 00 6c 00=20
[   56.477328] 90: 65 00 20 00 47 00 6f 00 6c 00 64 00 20 03 30 00=20
[   56.490585] a0: 31 00 30 00 31 00 30 00 31 00 30 00 31 00 30 00=20
[   56.508418] b0: 36 00 30 00 30 00 30 00 30 00 31 00 00 ff ff ff=20
[   56.521888] c0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff=20
[  113.067764] d0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff=20
[  113.081804] e0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff=20
[  113.095822] f0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff=20
[  113.096818] af9015_read_config: TS mode:0
[  113.097794] af9015_read_config: xtal:2 set adc_clock:28000
[  113.099705] af9015_read_config: IF1:4300
[  113.101596] af9015_read_config: MT2060 IF1:0
[  113.102558] af9015_read_config: tuner id1:156
[  113.103571] af9015_read_config: spectral inversion:0
[  113.200193] af9013: firmware version:4.95.0
[  113.203394] DVB: registering frontend 0 (Afatech AF9013 DVB-T)...
[  113.203466] af9015_tuner_attach:=20
[   56.671627] tda18271 0-00c0: creating new instance
[   56.673893] TDA18271HD/C1 detected @ 0-00c0
[  113.501809] dvb-usb: will pass the complete MPEG2 transport stream to th=
e software demuxer.
[  113.502800] DVB: registering new adapter (Leadtek WinFast DTV Dongle Gol=
d)
[  113.503400] dvb-usb: no frontend was attached by 'Leadtek WinFast DTV Do=
ngle Gold'
[  113.503411] dvb-usb: Leadtek WinFast DTV Dongle Gold successfully initia=
lized and connected.
[  113.503419] af9015_init:
[  113.503423] af9015_init_endpoint: USB speed:3
[  113.522752] af9015_download_ir_table:
[   56.860889] input: Leadtek WinFast DTV Dongle Gold as /devices/pci0000:0=
0/0000:00:1d.7/usb5/5-1/5-1:1.1/input/input12
[   56.889700] input,hidraw0: USB HID v1.01 Keyboard [Leadtek WinFast DTV D=
ongle Gold] on usb-0000:00:1d.7-1



_________________________________________________________________
Be part of history. Take part in Australia's first e-mail archive with Emai=
l Australia.
http://emailaustralia.ninemsn.com.au=

--_6dabda50-ae36-433e-b8da-66e4bb4357f9_
Content-Type: text/html; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

<html>
<head>
<style>
.hmmessage P
{
margin:0px;
padding:0px
}
body.hmmessage
{
FONT-SIZE: 10pt;
FONT-FAMILY:Tahoma
}
</style>
</head>
<body class=3D'hmmessage'>



Hi,<br><br>I finally got the usb Leadtek DTV dongle gold tuner working usin=
g the below method. The tuner works fine with kaffeine and mythtv, but no l=
uck with the remote (Y04G0044).<br><br>1) hg clone <a class=3D"external" re=
l=3D"nofollow" target=3D"_blank" href=3D"http://linuxtv.org/hg/%7Eanttip/af=
9015-mxl500x">http://linuxtv.org/hg/~anttip/af9015-mxl500x</a>  # to get th=
e driver working<br>then make, make install<br>2) copied firmware from <br>=
<a class=3D"external" rel=3D"nofollow" target=3D"_blank" href=3D"http://www=
.otit.fi/%7Ecrope/v4l-dvb/af9015/af9015_firmware_cutter/firmware_files/4.95=
.0/">http://www.otit.fi/~crope/v4<wbr>l-dvb/af9015/af9015_firmware<wbr>_cut=
ter/firmware_files/4.95.0/</a><br>to /lib/firmware/<br><br>- cat /proc/bus/=
input/devices produces the following:<br><br>I: Bus=3D0003 Vendor=3D0413 Pr=
oduct=3D6029 Version=3D0101<br>N: Name=3D"Leadtek WinFast DTV Dongle Gold"<=
br>P: Phys=3Dusb-0000:00:1d.7-1/input1<br>S: Sysfs=3D/devices/pci0000:00/00=
00:00:1d.7/usb5/5-1/5-1:1.1/input/input12<br>U: Uniq=3D<br>H: Handlers=3Dkb=
d event11 <br>B: EV=3D120013<br>B: KEY=3D10000 7 ff9f207a c14057ff febeffdf=
 ffefffff ffffffff fffffffe<br>B: MSC=3D10<br>B: LED=3D7<br><br>When I try =
'cat /dev/input/event11' and press the remote buttons nothing works :(<br>/=
var/log/messages has the following in relation to the tuner. Please help, i=
've tried several sites, but nothing seems to help. I'm assuming i need to =
get something out of event11 first, before i even try play with lirc. <br><=
br>Thank you in advance.<br>Alistair<br><br>[&nbsp; 111.337644] usb 5-1: ne=
w high speed USB device using ehci_hcd and address 3<br>[&nbsp; 111.378224]=
 usb 5-1: configuration #1 chosen from 1 choice<br>[&nbsp; 111.805274] usbc=
ore: registered new interface driver hiddev<br>[&nbsp; 111.809628] input: L=
eadtek WinFast DTV Dongle Gold as /devices/pci0000:00/0000:00:1d.7/usb5/5-1=
/5-1:1.1/input/input11<br>[&nbsp; 111.829183] input,hidraw0: USB HID v1.01 =
Keyboard [Leadtek WinFast DTV Dongle Gold] on usb-0000:00:1d.7-1<br>[&nbsp;=
 111.829225] usbcore: registered new interface driver usbhid<br>[&nbsp; 111=
.829234] /build/buildd/linux-2.6.24/drivers/hid/usbhid/hid-core.c: v2.6:USB=
 HID core driver<br>[&nbsp; 111.865039] af9015_usb_probe: interface:0<br>[&=
nbsp; 111.865699] af9015_identify_state: reply:01<br>[&nbsp; 111.865708] dv=
b-usb: found a 'Leadtek WinFast DTV Dongle Gold' in cold state, will try to=
 load a firmware<br>[&nbsp; 111.878222] dvb-usb: downloading firmware from =
file 'dvb-usb-af9015.fw'<br>[&nbsp; 111.878232] af9015_download_firmware:<b=
r>[&nbsp; 111.917252] usbcore: registered new interface driver dvb_usb_af90=
15<br>[&nbsp; 111.917941] usb 5-1: USB disconnect, address 3<br>[&nbsp; 111=
.924888] dvb-usb: generic DVB-USB module successfully deinitialized and dis=
connected.<br>[&nbsp;&nbsp; 56.173008] usb 5-1: new high speed USB device u=
sing ehci_hcd and address 4<br>[&nbsp; 112.404488] usb 5-1: configuration #=
1 chosen from 1 choice<br>[&nbsp; 112.404938] af9015_usb_probe: interface:0=
<br>[&nbsp; 112.405283] af9015_identify_state: reply:02<br>[&nbsp; 112.4052=
92] dvb-usb: found a 'Leadtek WinFast DTV Dongle Gold' in warm state.<br>[&=
nbsp; 112.405379] dvb-usb: will pass the complete MPEG2 transport stream to=
 the software demuxer.<br>[&nbsp; 112.406556] DVB: registering new adapter =
(Leadtek WinFast DTV Dongle Gold)<br>[&nbsp; 112.407103] af9015_eeprom_dump=
:<br>[&nbsp; 112.447578] 00: 31 c2 bb 0b 00 00 00 00 13 04 29 60 00 02 01 0=
2 <br>[&nbsp; 112.472211] 10: 00 80 00 fa fa 10 40 ef 01 30 31 30 31 30 32 =
30 <br>[&nbsp;&nbsp; 56.257034] 20: 35 30 35 30 30 30 30 31 ff ff ff ff ff =
ff ff ff <br>[&nbsp;&nbsp; 56.281646] 30: 00 00 3a 01 00 08 02 00 cc 10 00 =
00 9c ff ff ff <br>[&nbsp;&nbsp; 56.320001] 40: ff ff ff ff ff 08 02 00 1d =
8d c4 04 82 ff ff ff <br>[&nbsp;&nbsp; 56.350569] 50: ff ff ff ff ff 26 00 =
00 04 03 09 04 10 03 4c 00 <br>[&nbsp;&nbsp; 56.389906] 60: 65 00 61 00 64 =
00 74 00 65 00 6b 00 30 03 57 00 <br>[&nbsp;&nbsp; 56.430313] 70: 69 00 6e =
00 46 00 61 00 73 00 74 00 20 00 44 00 <br>[&nbsp;&nbsp; 56.455303] 80: 54 =
00 56 00 20 00 44 00 6f 00 6e 00 67 00 6c 00 <br>[&nbsp;&nbsp; 56.477328] 9=
0: 65 00 20 00 47 00 6f 00 6c 00 64 00 20 03 30 00 <br>[&nbsp;&nbsp; 56.490=
585] a0: 31 00 30 00 31 00 30 00 31 00 30 00 31 00 30 00 <br>[&nbsp;&nbsp; =
56.508418] b0: 36 00 30 00 30 00 30 00 30 00 31 00 00 ff ff ff <br>[&nbsp;&=
nbsp; 56.521888] c0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff <br>[&=
nbsp; 113.067764] d0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff <br>[=
&nbsp; 113.081804] e0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff <br>=
[&nbsp; 113.095822] f0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff <br=
>[&nbsp; 113.096818] af9015_read_config: TS mode:0<br>[&nbsp; 113.097794] a=
f9015_read_config: xtal:2 set adc_clock:28000<br>[&nbsp; 113.099705] af9015=
_read_config: IF1:4300<br>[&nbsp; 113.101596] af9015_read_config: MT2060 IF=
1:0<br>[&nbsp; 113.102558] af9015_read_config: tuner id1:156<br>[&nbsp; 113=
.103571] af9015_read_config: spectral inversion:0<br>[&nbsp; 113.200193] af=
9013: firmware version:4.95.0<br>[&nbsp; 113.203394] DVB: registering front=
end 0 (Afatech AF9013 DVB-T)...<br>[&nbsp; 113.203466] af9015_tuner_attach:=
 <br>[&nbsp;&nbsp; 56.671627] tda18271 0-00c0: creating new instance<br>[&n=
bsp;&nbsp; 56.673893] TDA18271HD/C1 detected @ 0-00c0<br>[&nbsp; 113.501809=
] dvb-usb: will pass the complete MPEG2 transport stream to the software de=
muxer.<br>[&nbsp; 113.502800] DVB: registering new adapter (Leadtek WinFast=
 DTV Dongle Gold)<br>[&nbsp; 113.503400] dvb-usb: no frontend was attached =
by 'Leadtek WinFast DTV Dongle Gold'<br>[&nbsp; 113.503411] dvb-usb: Leadte=
k WinFast DTV Dongle Gold successfully initialized and connected.<br>[&nbsp=
; 113.503419] af9015_init:<br>[&nbsp; 113.503423] af9015_init_endpoint: USB=
 speed:3<br>[&nbsp; 113.522752] af9015_download_ir_table:<br>[&nbsp;&nbsp; =
56.860889] input: Leadtek WinFast DTV Dongle Gold as /devices/pci0000:00/00=
00:00:1d.7/usb5/5-1/5-1:1.1/input/input12<br>[&nbsp;&nbsp; 56.889700] input=
,hidraw0: USB HID v1.01 Keyboard [Leadtek WinFast DTV Dongle Gold] on usb-0=
000:00:1d.7-1<br><br><br><br /><hr />Email Australia. <a href=3D'http://ema=
ilaustralia.ninemsn.com.au' target=3D'_new'>Be part of history. Take part i=
n Australia's first e-mail archive with </a></body>
</html>=

--_6dabda50-ae36-433e-b8da-66e4bb4357f9_--


--===============0529748072==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0529748072==--
