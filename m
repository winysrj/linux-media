Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from blu0-omc3-s18.blu0.hotmail.com ([65.55.116.93])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <ben_v_johnson@hotmail.com>) id 1KMvkQ-0006td-Rs
	for linux-dvb@linuxtv.org; Sun, 27 Jul 2008 04:12:38 +0200
Message-ID: <BLU117-W548508AF6B4ACF5851EDD8A1800@phx.gbl>
From: Ben Johnson <ben_v_johnson@hotmail.com>
To: <linux-dvb@linuxtv.org>
Date: Sun, 27 Jul 2008 12:11:57 +1000
In-Reply-To: <mailman.0.1217068026.17467.linux-dvb@linuxtv.org>
References: <mailman.0.1217068026.17467.linux-dvb@linuxtv.org>
MIME-Version: 1.0
Subject: [linux-dvb] saa7134-input Avermedia Super 007 Support (Remote)
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1756441592=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============1756441592==
Content-Type: multipart/alternative;
	boundary="_ab60005e-c7f4-4f6b-ba5d-0b5110d34471_"

--_ab60005e-c7f4-4f6b-ba5d-0b5110d34471_
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable








Hi

I am a complete newbie looking for help getting the Remote for an Avermedia=
 Super 007 (Digital only) working.  After looking around I believe that add=
ing support should only require adding a new case to the (dev->board) switc=
h in the saa7134-input.c file titled:

SAA7134_BOARD_AVERMEDIA_SUPER_007

Questions:
1.  Is this forum the right place to be asking these questions? If not=2C w=
here is please?
2.  Should adding the relevant information to the saa7134-input.c file for =
an otherwise supported saa7134 dvb-t card result in the remote being suppor=
ted?
3. If so=2C how do I determine what information needs to be supplied.  ie:
 - are the ir_codes_avermedia appropriate for this card
 - how do you tell what the mask_keycode and mask_keydown should be?
 - how do you work out the appropriate polling interval
 - what part does saa_setb play in all this.

I have the card working and am able to upload any supported information nee=
ded.

Thanks in advance for your help - BVJ.

My New Box:
2.6.24-19-generic x86_64 GNU/Linux (Mythbuntu 8.04 fully patched)
AMD Athalon X2 64 B4850
Gigabyte MA78GM-S2H with AMD 780 Northbridge & ATI HD 3200 Graphics
Avermedia Super 007 (Digital Only) saa7133 & tda8290

LSPCI output:
03:06.0 Multimedia controller: Philips Semiconductors SAA7133/SAA7135 Video=
 Broadcast Decoder (rev d1)
    Subsystem: Avermedia Technologies Inc Unknown device f01d
    Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Ste=
pping- SERR- FastB2B-
    Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort- <TAb=
ort- <MAbort- >SERR- <PERR-
    Latency: 32 (21000ns min=2C 8000ns max)
    Interrupt: pin A routed to IRQ 20
    Region 0: Memory at fdcff000 (32-bit=2C non-prefetchable) [size=3D2K]
    Capabilities: [40] Power Management version 2
        Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=3D0mA PME(D0-=2CD1-=2CD2-=2C=
D3hot-=2CD3cold-)
        Status: D0 PME-Enable- DSel=3D0 DScale=3D1 PME-
00: 31 11 33 71 06 00 90 02 d1 00 80 04 00 20 00 00
10: 00 f0 cf fd 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 61 14 1d f0
30: 00 00 00 00 40 00 00 00 00 00 00 00 0b 01 54 20
40: 01 00 02 06 00 20 00 1c 00 00 00 00 00 00 00 00
50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00


DMESG output:

[   47.222507] Linux video capture interface: v2.00
[   47.407888] saa7130/34: v4l2 driver version 0.2.14 loaded
[   47.407972] saa7133[0]: found at 0000:03:06.0=2C rev: 209=2C irq: 20=2C =
latency: 32=2C mmio: 0xfdcff000
[   47.407979] saa7133[0]: subsystem: 1461:f01d=2C board: Avermedia Super 0=
07 [card=3D117=2Cautodetected]
[   47.407988] saa7133[0]: board init: gpio is 40000
[   47.542574] saa7133[0]: i2c eeprom 00: 61 14 1d f0 54 20 1c 00 43 43 a9 =
1c 55 d2 b2 92
[   47.542581] saa7133[0]: i2c eeprom 10: ff ff ff ff ff 20 ff ff ff ff ff =
ff ff ff ff ff
[   47.542586] saa7133[0]: i2c eeprom 20: 01 40 01 32 32 01 01 43 88 ff 00 =
55 ff ff ff ff
[   47.542590] saa7133[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff ff =
ff ff ff ff ff
[   47.542595] saa7133[0]: i2c eeprom 40: ff 21 00 c0 96 10 03 02 15 16 ff =
ff ff ff ff ff
[   47.542599] saa7133[0]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff ff =
ff ff ff ff ff
[   47.542603] saa7133[0]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff ff ff =
ff ff ff ff ff
[   47.542607] saa7133[0]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff ff ff =
ff ff ff ff ff

[   47.932906] tuner 1-004b: chip found @ 0x96 (saa7133[0])
[   47.981769] tda8290 1-004b: setting tuner address to 60
[   48.084618] tuner 1-004b: type set to tda8290+75a
[   48.132535] tda8290 1-004b: setting tuner address to 60
[   48.236347] tuner 1-004b: type set to tda8290+75a
[   48.239259] saa7133[0]: registered device video0 [v4l2]
[   48.239278] saa7133[0]: registered device vbi0
[   48.330034] saa7134 ALSA driver for DMA sound loaded
[   48.330064] saa7133[0]/alsa: saa7133[0] at 0xfdcff000 irq 20 registered =
as card -2
[   48.356488] DVB: registering new adapter (saa7133[0])
[   48.356494] DVB: registering frontend 0 (Philips TDA10046H DVB-T)...
[   48.428950] tda1004x: setting up plls for 48MHz sampling clock
[   48.712424] tda1004x: found firmware revision 20 -- ok


_________________________________________________________________
Windows Live Messenger=A0treats you to 30 free emoticons -=A0Bees=2C cows=
=2C tigers and more!
http://livelife.ninemsn.com.au/article.aspx?id=3D567534=

--_ab60005e-c7f4-4f6b-ba5d-0b5110d34471_
Content-Type: text/html; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

<html>
<head>
<style>
.hmmessage P
{
margin:0px=3B
padding:0px
}
body.hmmessage
{
FONT-SIZE: 10pt=3B
FONT-FAMILY:Tahoma
}
</style>
</head>
<body class=3D'hmmessage'>


<style>
.hmmessage P
{
margin:0px=3B
padding:0px
}
body.hmmessage
{
FONT-SIZE: 10pt=3B
FONT-FAMILY:Tahoma
}
</style>



Hi<br><br>I am a complete newbie looking for help getting the Remote for an=
 Avermedia Super 007 (Digital only) working.&nbsp=3B After looking around I=
 believe that adding support should only require adding a new case to the<s=
pan style=3D"font-family: monospace=3B"></span> (dev-&gt=3Bboard) switch in=
 the saa7134-input.c file titled:<br><br>SAA7134_BOARD_AVERMEDIA_SUPER_007<=
br><br>Questions:<br>1.&nbsp=3B Is this forum the right place to be asking =
these questions? If not=2C where is please?<br>2.&nbsp=3B Should adding the=
 relevant information to the saa7134-input.c file for an otherwise supporte=
d saa7134 dvb-t card result in the remote being supported?<br>3. If so=2C h=
ow do I determine what information needs to be supplied.&nbsp=3B ie:<br>&nb=
sp=3B- are the ir_codes_avermedia appropriate for this card<br>&nbsp=3B- ho=
w do you tell what the mask_keycode and mask_keydown should be?<br>&nbsp=3B=
- how do you work out the appropriate polling interval<br>&nbsp=3B- what pa=
rt does saa_setb play in all this.<br><br>I have the card working and am ab=
le to upload any supported information needed.<br><br>Thanks in advance for=
 your help - BVJ.<br><br>My New Box:<br>2.6.24-19-generic x86_64 GNU/Linux =
(Mythbuntu 8.04 fully patched)<br>AMD Athalon X2 64 B4850<br>Gigabyte MA78G=
M-S2H with AMD 780 Northbridge &amp=3B ATI HD 3200 Graphics<br>Avermedia Su=
per 007 (Digital Only) saa7133 &amp=3B tda8290<br><br>LSPCI output:<br>03:0=
6.0 Multimedia controller: Philips Semiconductors SAA7133/SAA7135 Video Bro=
adcast Decoder (rev d1)<br>&nbsp=3B&nbsp=3B&nbsp=3B Subsystem: Avermedia Te=
chnologies Inc Unknown device f01d<br>&nbsp=3B&nbsp=3B&nbsp=3B Control: I/O=
- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- Fas=
tB2B-<br>&nbsp=3B&nbsp=3B&nbsp=3B Status: Cap+ 66MHz- UDF- FastB2B+ ParErr-=
 DEVSEL=3Dmedium &gt=3BTAbort- &lt=3BTAbort- &lt=3BMAbort- &gt=3BSERR- &lt=
=3BPERR-<br>&nbsp=3B&nbsp=3B&nbsp=3B Latency: 32 (21000ns min=2C 8000ns max=
)<br>&nbsp=3B&nbsp=3B&nbsp=3B Interrupt: pin A routed to IRQ 20<br>&nbsp=3B=
&nbsp=3B&nbsp=3B Region 0: Memory at fdcff000 (32-bit=2C non-prefetchable) =
[size=3D2K]<br>&nbsp=3B&nbsp=3B&nbsp=3B Capabilities: [40] Power Management=
 version 2<br>&nbsp=3B&nbsp=3B&nbsp=3B &nbsp=3B&nbsp=3B&nbsp=3B Flags: PMEC=
lk- DSI- D1+ D2+ AuxCurrent=3D0mA PME(D0-=2CD1-=2CD2-=2CD3hot-=2CD3cold-)<b=
r>&nbsp=3B&nbsp=3B&nbsp=3B &nbsp=3B&nbsp=3B&nbsp=3B Status: D0 PME-Enable- =
DSel=3D0 DScale=3D1 PME-<br>00: 31 11 33 71 06 00 90 02 d1 00 80 04 00 20 0=
0 00<br>10: 00 f0 cf fd 00 00 00 00 00 00 00 00 00 00 00 00<br>20: 00 00 00=
 00 00 00 00 00 00 00 00 00 61 14 1d f0<br>30: 00 00 00 00 40 00 00 00 00 0=
0 00 00 0b 01 54 20<br>40: 01 00 02 06 00 20 00 1c 00 00 00 00 00 00 00 00<=
br>50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00<br>60: 00 00 00 00 0=
0 00 00 00 00 00 00 00 00 00 00 00<br>70: 00 00 00 00 00 00 00 00 00 00 00 =
00 00 00 00 00<br>80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00<br>90=
: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00<br>a0: 00 00 00 00 00 00 =
00 00 00 00 00 00 00 00 00 00<br>b0: 00 00 00 00 00 00 00 00 00 00 00 00 00=
 00 00 00<br>c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00<br>d0: 00 =
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00<br>e0: 00 00 00 00 00 00 00 00=
 00 00 00 00 00 00 00 00<br>f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 0=
0 00<br><br><br>DMESG output:<br><br>[&nbsp=3B&nbsp=3B 47.222507] Linux vid=
eo capture interface: v2.00<br>[&nbsp=3B&nbsp=3B 47.407888] saa7130/34: v4l=
2 driver version 0.2.14 loaded<br>[&nbsp=3B&nbsp=3B 47.407972] saa7133[0]: =
found at 0000:03:06.0=2C rev: 209=2C irq: 20=2C latency: 32=2C mmio: 0xfdcf=
f000<br>[&nbsp=3B&nbsp=3B 47.407979] saa7133[0]: subsystem: 1461:f01d=2C bo=
ard: Avermedia Super 007 [card=3D117=2Cautodetected]<br>[&nbsp=3B&nbsp=3B 4=
7.407988] saa7133[0]: board init: gpio is 40000<br>[&nbsp=3B&nbsp=3B 47.542=
574] saa7133[0]: i2c eeprom 00: 61 14 1d f0 54 20 1c 00 43 43 a9 1c 55 d2 b=
2 92<br>[&nbsp=3B&nbsp=3B 47.542581] saa7133[0]: i2c eeprom 10: ff ff ff ff=
 ff 20 ff ff ff ff ff ff ff ff ff ff<br>[&nbsp=3B&nbsp=3B 47.542586] saa713=
3[0]: i2c eeprom 20: 01 40 01 32 32 01 01 43 88 ff 00 55 ff ff ff ff<br>[&n=
bsp=3B&nbsp=3B 47.542590] saa7133[0]: i2c eeprom 30: ff ff ff ff ff ff ff f=
f ff ff ff ff ff ff ff ff<br>[&nbsp=3B&nbsp=3B 47.542595] saa7133[0]: i2c e=
eprom 40: ff 21 00 c0 96 10 03 02 15 16 ff ff ff ff ff ff<br>[&nbsp=3B&nbsp=
=3B 47.542599] saa7133[0]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff ff =
ff ff ff ff ff<br>[&nbsp=3B&nbsp=3B 47.542603] saa7133[0]: i2c eeprom 60: f=
f ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff<br>[&nbsp=3B&nbsp=3B 47.5426=
07] saa7133[0]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff=
 ff<br><br>[&nbsp=3B&nbsp=3B 47.932906] tuner 1-004b: chip found @ 0x96 (sa=
a7133[0])<br>[&nbsp=3B&nbsp=3B 47.981769] tda8290 1-004b: setting tuner add=
ress to 60<br>[&nbsp=3B&nbsp=3B 48.084618] tuner 1-004b: type set to tda829=
0+75a<br>[&nbsp=3B&nbsp=3B 48.132535] tda8290 1-004b: setting tuner address=
 to 60<br>[&nbsp=3B&nbsp=3B 48.236347] tuner 1-004b: type set to tda8290+75=
a<br>[&nbsp=3B&nbsp=3B 48.239259] saa7133[0]: registered device video0 [v4l=
2]<br>[&nbsp=3B&nbsp=3B 48.239278] saa7133[0]: registered device vbi0<br>[&=
nbsp=3B&nbsp=3B 48.330034] saa7134 ALSA driver for DMA sound loaded<br>[&nb=
sp=3B&nbsp=3B 48.330064] saa7133[0]/alsa: saa7133[0] at 0xfdcff000 irq 20 r=
egistered as card -2<br>[&nbsp=3B&nbsp=3B 48.356488] DVB: registering new a=
dapter (saa7133[0])<br>[&nbsp=3B&nbsp=3B 48.356494] DVB: registering fronte=
nd 0 (Philips TDA10046H DVB-T)...<br>[&nbsp=3B&nbsp=3B 48.428950] tda1004x:=
 setting up plls for 48MHz sampling clock<br>[&nbsp=3B&nbsp=3B 48.712424] t=
da1004x: found firmware revision 20 -- ok<br><br><br /><hr />Bees=2C cows=
=2C tigers and more! <a href=3D'http://livelife.ninemsn.com.au/article.aspx=
?id=3D567534' target=3D'_new'>Windows Live Messenger=A0treats you to 30 fre=
e emoticons.=A0</a></body>
</html>=

--_ab60005e-c7f4-4f6b-ba5d-0b5110d34471_--


--===============1756441592==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1756441592==--
