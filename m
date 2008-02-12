Return-path: <linux-dvb-bounces@linuxtv.org>
Received: from mx5.orcon.net.nz ([219.88.242.55] ident=Debian-exim)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <lennon@orcon.net.nz>) id 1JOjNO-0007MK-JI
	for linux-dvb@linuxtv.org; Tue, 12 Feb 2008 01:51:59 +0100
Received: from Debian-exim by mx5.orcon.net.nz with local (Exim 4.67)
	(envelope-from <lennon@orcon.net.nz>) id 1JOjNG-0006RS-7O
	for linux-dvb@linuxtv.org; Tue, 12 Feb 2008 13:51:50 +1300
Received: from [60.234.13.190] (helo=CraigPC)
	by mx5.orcon.net.nz with smtp (Exim 4.67)
	(envelope-from <lennon@orcon.net.nz>) id 1JOjNF-0006Qm-Fw
	for linux-dvb@linuxtv.org; Tue, 12 Feb 2008 13:51:49 +1300
Message-ID: <C36C2AD2C1B74AA98CA40F6A1C0644EF@CraigPC>
From: "Craig Whitmore" <lennon@orcon.net.nz>
To: "linux-dvb" <linux-dvb@linuxtv.org>
Date: Tue, 12 Feb 2008 13:51:49 +1300
MIME-Version: 1.0
Subject: [linux-dvb] Multi Frontend Drivers for HVR4000 (And others)
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0472670629=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

This is a multi-part message in MIME format.

--===============0472670629==
Content-Type: multipart/alternative;
	boundary="----=_NextPart_000_035B_01C86D7E.6A015C00"

This is a multi-part message in MIME format.

------=_NextPart_000_035B_01C86D7E.6A015C00
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

I've been playing with the latest http://dev.kewl.org/hauppauge/ drivers =
(Multi frontend Support) for the HVR4000 =
(http://dev.kewl.org/hauppauge/v4l-dvb-hg-mfe-latest.diff) and they seem =
to work well.  I can use either DVB-S or DVB-T (via mythtv and swap =
easily between them) (butt not use them at the same time which is just a =
limitation of the device)

But a couple of problems.
Not many programs support the multifrontend as of yet. Like the biggest =
one Mythtv :-)
You have to do the below so it sees two cards

mkdir /dev/dvb/adapter1
ln -s /dev/dvb/adapter1/frontend1 /dev/dvb/adapter1/frontend0
ln -s /dev/dvb/adapter1/net1 /dev/dvb/adapter1/net0
ln -s /dev/dvb/adapter1/dvr1 /dev/dvb/adapter1/dvr0
ln -s /dev/dvb/adapter1/demux1 /dev/dvb/adapter1/demux0

Analog TV Tuning Stops working after you 1st use the DVB-T or DVB-S =
device

a few i2c errors when it first boots up.

tda9887 2-0043: i2c i/o error: rc =3D=3D -121 (should be 4)
DVB: registering new adapter (cx88[0])
DVB: registering frontend 0 (Conexant CX24116/CX24118)...
DVB: registering frontend 0 (Conexant CX22702 DVB-T)...

it says registering frontend 0 both times, but thats just cosmetic and =
should easily be fixed

dmesg
-------------------
cx88/2: cx2388x MPEG-TS Driver Manager version 0.0.6 loaded
cx88[0]: subsystem: 0070:6902, board: Hauppauge WinTV-HVR4000 =
DVB-S/S2/T/Hybrid [card=3D59,autodetected], frontend(s): 2
cx88[0]: TV tuner type 63, Radio tuner type -1
cx88/0: cx2388x v4l2 driver version 0.0.6 loaded
cx2388x alsa driver version 0.0.6 loaded
cx88[0]: i2c init: enabling analog demod on HVR1300/3000/4000 tuner
tveeprom 2-0050: Hauppauge model 69009, rev B2D3, serial# 2807241
tveeprom 2-0050: MAC address is 00-0D-FE-2A-D5-C9
tveeprom 2-0050: tuner model is Philips FMD1216MEX (idx 133, type 63)
tveeprom 2-0050: TV standards PAL(B/G) PAL(I) SECAM(L/L') PAL(D/D1/K) =
ATSC/DVB Digital (eeprom 0xf4)
tveeprom 2-0050: audio processor is CX882 (idx 33)
tveeprom 2-0050: decoder processor is CX882 (idx 25)
tveeprom 2-0050: has radio, has IR receiver, has no IR transmitter
cx88[0]: hauppauge eeprom: model=3D69009
input: cx88 IR (Hauppauge WinTV-HVR400 as /class/input/input3
cx88[0]/2: cx2388x 8802 Driver Manager
ACPI: PCI Interrupt Link [APC1] enabled at IRQ 16
ACPI: PCI Interrupt 0000:04:08.2[A] -> Link [APC1] -> GSI 16 (level, =
low) -> IRQ 21
cx88[0]/2: found at 0000:04:08.2, rev: 5, irq: 21, latency: 32, mmio: =
0xf8000000
cx8802_probe() allocating 2 frontend(s)
ACPI: PCI Interrupt 0000:04:08.0[A] -> Link [APC1] -> GSI 16 (level, =
low) -> IRQ 21
cx88[0]/0: found at 0000:04:08.0, rev: 5, irq: 21, latency: 32, mmio: =
0xfa000000
cx88/2: cx2388x dvb driver version 0.0.6 loaded
cx88/2: registering cx8802 driver, type: dvb access: shared
cx88[0]/2: subsystem: 0070:6902, board: Hauppauge WinTV-HVR4000 =
DVB-S/S2/T/Hybrid [card=3D59]
cx88[0]/2: cx2388x based DVB/ATSC card
tuner' 2-0043: chip found @ 0x86 (cx88[0])
tda9887 2-0043: tda988[5/6/7] found
tuner' 2-0061: chip found @ 0xc2 (cx88[0])
tuner-simple 2-0061: type set to 63 (Philips FMD1216ME MK3 Hybrid Tuner)
tuner' 2-0063: chip found @ 0xc6 (cx88[0])
cx88[0]/0: registered device video0 [v4l2]
cx88[0]/0: registered device vbi0
cx88[0]/0: registered device radio0
cx88[0]/1: CX88x/0: ALSA support for cx2388x boards
ACPI: PCI Interrupt Link [AAZA] enabled at IRQ 22
ACPI: PCI Interrupt 0000:00:10.1[B] -> Link [AAZA] -> GSI 22 (level, =
low) -> IRQ 17
tda9887 2-0043: i2c i/o error: rc =3D=3D -121 (should be 4)
DVB: registering new adapter (cx88[0])
DVB: registering frontend 0 (Conexant CX24116/CX24118)...
DVB: registering frontend 0 (Conexant CX22702 DVB-T)...
cx24116_firmware_ondemand: Waiting for firmware upload =
(dvb-fe-cx24116.fw)...
cx24116_firmware_ondemand: Waiting for firmware upload(2)...
cx24116_load_firmware: FW version 1.20.79.0
cx24116_firmware_ondemand: Firmware upload complete
cx24116_firmware_ondemand: Waiting for firmware upload =
(dvb-fe-cx24116.fw)...
cx24116_firmware_ondemand: Waiting for firmware upload(2)...
cx24116_load_firmware: FW version 1.20.79.0
cx24116_firmware_ondemand: Firmware upload complete
------------------

Thanks


------=_NextPart_000_035B_01C86D7E.6A015C00
Content-Type: text/html;
	charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML><HEAD>
<META http-equiv=3DContent-Type content=3D"text/html; =
charset=3Diso-8859-1">
<META content=3D"MSHTML 6.00.6000.16587" name=3DGENERATOR>
<STYLE></STYLE>
</HEAD>
<BODY bgColor=3D#ffffff>
<DIV><FONT face=3DArial size=3D2>I've been playing with the latest <A=20
href=3D"http://dev.kewl.org/hauppauge/">http://dev.kewl.org/hauppauge/</A=
>&nbsp;drivers=20
(Multi frontend Support) for the HVR4000 (<A=20
href=3D"http://dev.kewl.org/hauppauge/v4l-dvb-hg-mfe-latest.diff) =
and">http://dev.kewl.org/hauppauge/v4l-dvb-hg-mfe-latest.diff)=20
and</A> they seem to work well.&nbsp; I can use either DVB-S or DVB-T =
(via=20
mythtv and swap easily between them) (butt not use them at the same time =
which=20
is just a limitation of the device)</FONT></DIV>
<DIV><FONT face=3DArial size=3D2></FONT>&nbsp;</DIV>
<DIV><FONT face=3DArial size=3D2>But a couple of problems.</FONT></DIV>
<DIV><FONT face=3DArial size=3D2>Not many programs support the =
multifrontend as of=20
yet. Like the biggest one Mythtv :-)</FONT></DIV>
<DIV><FONT face=3DArial size=3D2>You have to do the below so it sees two =

cards</FONT></DIV>
<DIV><FONT face=3DArial size=3D2></FONT>&nbsp;</DIV>
<DIV><FONT face=3DArial size=3D2>mkdir /dev/dvb/adapter1</FONT></DIV>
<DIV><FONT face=3DArial size=3D2>ln -s /dev/dvb/adapter1/frontend1=20
/dev/dvb/adapter1/frontend0</FONT></DIV>
<DIV><FONT face=3DArial size=3D2>ln -s /dev/dvb/adapter1/net1=20
/dev/dvb/adapter1/net0</FONT></DIV>
<DIV><FONT face=3DArial size=3D2>ln -s /dev/dvb/adapter1/dvr1=20
/dev/dvb/adapter1/dvr0</FONT></DIV>
<DIV><FONT face=3DArial size=3D2>ln -s /dev/dvb/adapter1/demux1=20
/dev/dvb/adapter1/demux0</FONT></DIV>
<DIV><FONT face=3DArial size=3D2></FONT>&nbsp;</DIV>
<DIV><FONT face=3DArial size=3D2>Analog TV Tuning Stops working after =
you 1st use=20
the DVB-T or DVB-S device</FONT></DIV>
<DIV><FONT face=3DArial size=3D2></FONT>&nbsp;</DIV>
<DIV><FONT face=3DArial size=3D2>a few i2c errors when it first boots=20
up.</FONT></DIV>
<DIV><FONT face=3DArial size=3D2></FONT>&nbsp;</DIV>
<DIV><FONT face=3DArial size=3D2>tda9887 2-0043: i2c i/o error: rc =
=3D=3D -121 (should=20
be 4)<BR>DVB: registering new adapter (cx88[0])<BR>DVB: registering =
frontend 0=20
(Conexant CX24116/CX24118)...<BR>DVB: registering frontend 0 (Conexant =
CX22702=20
DVB-T)...<BR></FONT></DIV>
<DIV><FONT face=3DArial size=3D2>it says registering frontend 0 both =
times, but=20
thats just cosmetic and should easily be fixed</FONT></DIV>
<DIV><FONT face=3DArial size=3D2></FONT>&nbsp;</DIV>
<DIV><FONT face=3DArial size=3D2>dmesg</FONT></DIV>
<DIV><FONT face=3DArial size=3D2>-------------------</FONT></DIV>
<DIV><FONT face=3DArial size=3D2>cx88/2: cx2388x MPEG-TS Driver Manager =
version=20
0.0.6 loaded<BR>cx88[0]: subsystem: 0070:6902, board: Hauppauge =
WinTV-HVR4000=20
DVB-S/S2/T/Hybrid [card=3D59,autodetected], frontend(s): 2<BR>cx88[0]: =
TV tuner=20
type 63, Radio tuner type -1<BR>cx88/0: cx2388x v4l2 driver version =
0.0.6=20
loaded<BR>cx2388x alsa driver version 0.0.6 loaded<BR>cx88[0]: i2c init: =

enabling analog demod on HVR1300/3000/4000 tuner<BR>tveeprom 2-0050: =
Hauppauge=20
model 69009, rev B2D3, serial# 2807241<BR>tveeprom 2-0050: MAC address =
is=20
00-0D-FE-2A-D5-C9<BR>tveeprom 2-0050: tuner model is Philips FMD1216MEX =
(idx=20
133, type 63)<BR>tveeprom 2-0050: TV standards PAL(B/G) PAL(I) =
SECAM(L/L')=20
PAL(D/D1/K) ATSC/DVB Digital (eeprom 0xf4)<BR>tveeprom 2-0050: audio =
processor=20
is CX882 (idx 33)<BR>tveeprom 2-0050: decoder processor is CX882 (idx=20
25)<BR>tveeprom 2-0050: has radio, has IR receiver, has no IR=20
transmitter<BR>cx88[0]: hauppauge eeprom: model=3D69009<BR>input: cx88 =
IR=20
(Hauppauge WinTV-HVR400 as /class/input/input3<BR>cx88[0]/2: cx2388x =
8802 Driver=20
Manager<BR>ACPI: PCI Interrupt Link [APC1] enabled at IRQ 16<BR>ACPI: =
PCI=20
Interrupt 0000:04:08.2[A] -&gt; Link [APC1] -&gt; GSI 16 (level, low) =
-&gt; IRQ=20
21<BR>cx88[0]/2: found at 0000:04:08.2, rev: 5, irq: 21, latency: 32, =
mmio:=20
0xf8000000<BR>cx8802_probe() allocating 2 frontend(s)<BR>ACPI: PCI =
Interrupt=20
0000:04:08.0[A] -&gt; Link [APC1] -&gt; GSI 16 (level, low) -&gt; IRQ=20
21<BR>cx88[0]/0: found at 0000:04:08.0, rev: 5, irq: 21, latency: 32, =
mmio:=20
0xfa000000<BR>cx88/2: cx2388x dvb driver version 0.0.6 loaded<BR>cx88/2: =

registering cx8802 driver, type: dvb access: shared<BR>cx88[0]/2: =
subsystem:=20
0070:6902, board: Hauppauge WinTV-HVR4000 DVB-S/S2/T/Hybrid=20
[card=3D59]<BR>cx88[0]/2: cx2388x based DVB/ATSC card<BR>tuner' 2-0043: =
chip found=20
@ 0x86 (cx88[0])<BR>tda9887 2-0043: tda988[5/6/7] found<BR>tuner' =
2-0061: chip=20
found @ 0xc2 (cx88[0])<BR>tuner-simple 2-0061: type set to 63 (Philips =
FMD1216ME=20
MK3 Hybrid Tuner)<BR>tuner' 2-0063: chip found @ 0xc6 =
(cx88[0])<BR>cx88[0]/0:=20
registered device video0 [v4l2]<BR>cx88[0]/0: registered device=20
vbi0<BR>cx88[0]/0: registered device radio0<BR>cx88[0]/1: CX88x/0: ALSA =
support=20
for cx2388x boards<BR>ACPI: PCI Interrupt Link [AAZA] enabled at IRQ =
22<BR>ACPI:=20
PCI Interrupt 0000:00:10.1[B] -&gt; Link [AAZA] -&gt; GSI 22 (level, =
low) -&gt;=20
IRQ 17<BR>tda9887 2-0043: i2c i/o error: rc =3D=3D -121 (should be =
4)<BR>DVB:=20
registering new adapter (cx88[0])<BR>DVB: registering frontend 0 =
(Conexant=20
CX24116/CX24118)...<BR>DVB: registering frontend 0 (Conexant CX22702=20
DVB-T)...<BR>cx24116_firmware_ondemand: Waiting for firmware upload=20
(dvb-fe-cx24116.fw)...<BR>cx24116_firmware_ondemand: Waiting for =
firmware=20
upload(2)...<BR>cx24116_load_firmware: FW version=20
1.20.79.0<BR>cx24116_firmware_ondemand: Firmware upload=20
complete<BR>cx24116_firmware_ondemand: Waiting for firmware upload=20
(dvb-fe-cx24116.fw)...<BR>cx24116_firmware_ondemand: Waiting for =
firmware=20
upload(2)...<BR>cx24116_load_firmware: FW version=20
1.20.79.0<BR>cx24116_firmware_ondemand: Firmware upload=20
complete<BR>------------------</FONT></DIV>
<DIV><FONT face=3DArial size=3D2></FONT>&nbsp;</DIV>
<DIV><FONT face=3DArial size=3D2>Thanks</FONT></DIV>
<DIV><FONT face=3DArial size=3D2>&nbsp;</DIV></FONT>
<DIV><FONT face=3DArial size=3D2></FONT>&nbsp;</DIV></BODY></HTML>

------=_NextPart_000_035B_01C86D7E.6A015C00--



--===============0472670629==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0472670629==--
