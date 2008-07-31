Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from blu0-omc2-s13.blu0.hotmail.com ([65.55.111.88])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <ben_v_johnson@hotmail.com>) id 1KOhWu-0008OL-K2
	for linux-dvb@linuxtv.org; Fri, 01 Aug 2008 01:26:01 +0200
Message-ID: <BLU117-W75BB1B915538C38349EF5A17C0@phx.gbl>
From: Ben Johnson <ben_v_johnson@hotmail.com>
To: hermann pitton <hermann-pitton@arcor.de>
Date: Fri, 1 Aug 2008 09:25:22 +1000
In-Reply-To: <1217527412.3272.24.camel@pc10.localdom.local>
References: <mailman.0.1217068026.17467.linux-dvb@linuxtv.org>
	<BLU117-W36B61F5A42625A378CA7D7A17C0@phx.gbl>
	<1217527412.3272.24.camel@pc10.localdom.local>
MIME-Version: 1.0
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Please - can't someone help -
	saa7134-input	Avermedia Super 007 Support (Remote)
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1129619988=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============1129619988==
Content-Type: multipart/alternative;
	boundary="_cc263a81-5c6c-42cf-8680-1c54d482f00d_"

--_cc263a81-5c6c-42cf-8680-1c54d482f00d_
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable


Hi Herman

Thankyou very much for your response.  The card comes with a remote and a d=
ongle that you plug in to the back=2C so I assume it includes an IR decoder=
 chip.  I think I have found the wiki entry you mentioned at http://www.lin=
uxtv.org/v4lwiki/index.php/Remote_controllers and I will work through the i=
nstructions with my card when I get home tonight.  I assume that will pose =
more questions but I greatly appreciate this pointer.

Thanks again

Ben

> Subject: Re: [linux-dvb] Please - can't someone help - saa7134-input	Aver=
media Super 007 Support (Remote)
> From: hermann-pitton@arcor.de
> To: ben_v_johnson@hotmail.com
> CC: linux-dvb@linuxtv.org
> Date: Thu=2C 31 Jul 2008 20:03:32 +0200
>=20
> Hi Ben=2C
>=20
> Am Donnerstag=2C den 31.07.2008=2C 19:48 +1000 schrieb Ben Johnson:
> > Hi
> >=20
> > I sent in this a few days ago=2C but no one has been able to help yet.
> > Please can someone help me.
> >=20
>=20
> if this card also has no IR decoder chip on board=2C like the analog only
> ones=2C then Mauro seems to have a solution.
>=20
> Plaese be patient=2C he is not free in what is on top of his todo list.
>=20
> Else for simple gpio remotes we have instructions on the v4l wiki at
> linutv.org. If it has an IR controller=2C you can look up other Avermedia
> cards and remotes also at the http://www.bttv-gallery.de
>=20
> If already known=2C then you simply add the card to the gpio remotes in
> saa7134-cards.c and accordingly in saa7134-input.c.
>=20
> An example for a solution without IR controller chip is the patch for
> the recent Asus PC-39 remote. This has an unknown transmitter chip and a
> 3.3 Volts only receiver talking some sort of RC5. A potential deadlock=2C
> if irqs are delayed=2C was fixed later.
>=20
> Cheers=2C
> Hermann
>=20
>=20
> ________________________________________________________________________
> >=20
> > Hi
> >=20
> > I am a complete newbie looking for help getting the Remote for an
> > Avermedia Super 007 (Digital only) working.  After looking around I
> > believe that adding support should only require adding a new case to
> > the (dev->board) switch in the saa7134-input.c file titled:
> >=20
> > SAA7134_BOARD_AVERMEDIA_SUPER_007
> >=20
> > Questions:
> > 1.  Is this forum the right place to be asking these questions? If
> > not=2C where is please?
> > 2.  Should adding the relevant information to the saa7134-input.c file
> > for an otherwise supported saa7134 dvb-t card result in the remote
> > being supported?
> > 3. If so=2C how do I determine what information needs to be supplied.
> > ie:
> >  - are the ir_codes_avermedia appropriate for this card
> >  - how do you tell what the mask_keycode and mask_keydown should be?
> >  - how do you work out the appropriate polling interval
> >  - what part does saa_setb play in all this.
> >=20
> > I have the card working and am able to upload any supported
> > information needed.
> >=20
> > Thanks in advance for your help - BVJ.
> >=20
> > My New Box:
> > 2.6.24-19-generic x86_64 GNU/Linux (Mythbuntu 8.04 fully patched)
> > AMD Athalon X2 64 B4850
> > Gigabyte MA78GM-S2H with AMD 780 Northbridge & ATI HD 3200 Graphics
> > Avermedia Super 007 (Digital Only) saa7133 & tda8290
> >=20
> > LSPCI output:
> > 03:06.0 Multimedia controller: Philips Semiconductors SAA7133/SAA7135
> > Video Broadcast Decoder (rev d1)
> >     Subsystem: Avermedia Technologies Inc Unknown device f01d
> >     Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
> > ParErr- Stepping- SERR- FastB2B-
> >     Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort-
> > <TAbort- <MAbort- >SERR- <PERR-
> >     Latency: 32 (21000ns min=2C 8000ns max)
> >     Interrupt: pin A routed to IRQ 20
> >     Region 0: Memory at fdcff000 (32-bit=2C non-prefetchable) [size=3D2=
K]
> >     Capabilities: [40] Power Management version 2
> >         Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=3D0mA
> > PME(D0-=2CD1-=2CD2-=2CD3hot-=2CD3cold-)
> >         Status: D0 PME-Enable- DSel=3D0 DScale=3D1 PME-
> > 00: 31 11 33 71 06 00 90 02 d1 00 80 04 00 20 00 00
> > 10: 00 f0 cf fd 00 00 00 00 00 00 00 00 00 00 00 00
> > 20: 00 00 00 00 00 00 00 00 00 00 00 00 61 14 1d f0
> > 30: 00 00 00 00 40 00 00 00 00 00 00 00 0b 01 54 20
> > 40: 01 00 02 06 00 20 00 1c 00 00 00 00 00 00 00 00
> > 50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> > 60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> > 70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> > 80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> > 90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> > a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> > b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> > c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> > d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> > e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> > f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> >=20
> >=20
> > DMESG output:
> >=20
> > [   47.222507] Linux video capture interface: v2.00
> > [   47.407888] saa7130/34: v4l2 driver version 0.2.14 loaded
> > [   47.407972] saa7133[0]: found at 0000:03:06.0=2C rev: 209=2C irq: 20=
=2C
> > latency: 32=2C mmio: 0xfdcff000
> > [   47.407979] saa7133[0]: subsystem: 1461:f01d=2C board: Avermedia
> > Super 007 [card=3D117=2Cautodetected]
> > [   47.407988] saa7133[0]: board init: gpio is 40000
> > [   47.542574] saa7133[0]: i2c eeprom 00: 61 14 1d f0 54 20 1c 00 43
> > 43 a9 1c 55 d2 b2 92
> > [   47.542581] saa7133[0]: i2c eeprom 10: ff ff ff ff ff 20 ff ff ff
> > ff ff ff ff ff ff ff
> > [   47.542586] saa7133[0]: i2c eeprom 20: 01 40 01 32 32 01 01 43 88
> > ff 00 55 ff ff ff ff
> > [   47.542590] saa7133[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff
> > ff ff ff ff ff ff ff
> > [   47.542595] saa7133[0]: i2c eeprom 40: ff 21 00 c0 96 10 03 02 15
> > 16 ff ff ff ff ff ff
> > [   47.542599] saa7133[0]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff
> > ff ff ff ff ff ff ff
> > [   47.542603] saa7133[0]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff
> > ff ff ff ff ff ff ff
> > [   47.542607] saa7133[0]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff
> > ff ff ff ff ff ff ff
> >=20
> > [   47.932906] tuner 1-004b: chip found @ 0x96 (saa7133[0])
> > [   47.981769] tda8290 1-004b: setting tuner address to 60
> > [   48.084618] tuner 1-004b: type set to tda8290+75a
> > [   48.132535] tda8290 1-004b: setting tuner address to 60
> > [   48.236347] tuner 1-004b: type set to tda8290+75a
> > [   48.239259] saa7133[0]: registered device video0 [v4l2]
> > [   48.239278] saa7133[0]: registered device vbi0
> > [   48.330034] saa7134 ALSA driver for DMA sound loaded
> > [   48.330064] saa7133[0]/alsa: saa7133[0] at 0xfdcff000 irq 20
> > registered as card -2
> > [   48.356488] DVB: registering new adapter (saa7133[0])
> > [   48.356494] DVB: registering frontend 0 (Philips TDA10046H
> > DVB-T)...
> > [   48.428950] tda1004x: setting up plls for 48MHz sampling clock
> > [   48.712424] tda1004x: found firmware revision 20 -- ok
> >=20
> >=20
> >=20
> > ______________________________________________________________________
>=20

_________________________________________________________________
Windows Live Messenger=A0treats you to 30 free emoticons -=A0Bees=2C cows=
=2C tigers and more!
http://livelife.ninemsn.com.au/article.aspx?id=3D567534=

--_cc263a81-5c6c-42cf-8680-1c54d482f00d_
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
Hi Herman<br><br>Thankyou very much for your response.&nbsp=3B The card com=
es with a remote and a dongle that you plug in to the back=2C so I assume i=
t includes an IR decoder chip.&nbsp=3B I think I have found the wiki entry =
you mentioned at http://www.linuxtv.org/v4lwiki/index.php/Remote_controller=
s and I will work through the instructions with my card when I get home ton=
ight.&nbsp=3B I assume that will pose more questions but I greatly apprecia=
te this pointer.<br><br>Thanks again<br><br>Ben<br><br>&gt=3B Subject: Re: =
[linux-dvb] Please - can't someone help - saa7134-input	Avermedia Super 007=
 Support (Remote)<br>&gt=3B From: hermann-pitton@arcor.de<br>&gt=3B To: ben=
_v_johnson@hotmail.com<br>&gt=3B CC: linux-dvb@linuxtv.org<br>&gt=3B Date: =
Thu=2C 31 Jul 2008 20:03:32 +0200<br>&gt=3B <br>&gt=3B Hi Ben=2C<br>&gt=3B =
<br>&gt=3B Am Donnerstag=2C den 31.07.2008=2C 19:48 +1000 schrieb Ben Johns=
on:<br>&gt=3B &gt=3B Hi<br>&gt=3B &gt=3B <br>&gt=3B &gt=3B I sent in this a=
 few days ago=2C but no one has been able to help yet.<br>&gt=3B &gt=3B Ple=
ase can someone help me.<br>&gt=3B &gt=3B <br>&gt=3B <br>&gt=3B if this car=
d also has no IR decoder chip on board=2C like the analog only<br>&gt=3B on=
es=2C then Mauro seems to have a solution.<br>&gt=3B <br>&gt=3B Plaese be p=
atient=2C he is not free in what is on top of his todo list.<br>&gt=3B <br>=
&gt=3B Else for simple gpio remotes we have instructions on the v4l wiki at=
<br>&gt=3B linutv.org. If it has an IR controller=2C you can look up other =
Avermedia<br>&gt=3B cards and remotes also at the http://www.bttv-gallery.d=
e<br>&gt=3B <br>&gt=3B If already known=2C then you simply add the card to =
the gpio remotes in<br>&gt=3B saa7134-cards.c and accordingly in saa7134-in=
put.c.<br>&gt=3B <br>&gt=3B An example for a solution without IR controller=
 chip is the patch for<br>&gt=3B the recent Asus PC-39 remote. This has an =
unknown transmitter chip and a<br>&gt=3B 3.3 Volts only receiver talking so=
me sort of RC5. A potential deadlock=2C<br>&gt=3B if irqs are delayed=2C wa=
s fixed later.<br>&gt=3B <br>&gt=3B Cheers=2C<br>&gt=3B Hermann<br>&gt=3B <=
br>&gt=3B <br>&gt=3B ______________________________________________________=
__________________<br>&gt=3B &gt=3B <br>&gt=3B &gt=3B Hi<br>&gt=3B &gt=3B <=
br>&gt=3B &gt=3B I am a complete newbie looking for help getting the Remote=
 for an<br>&gt=3B &gt=3B Avermedia Super 007 (Digital only) working.  After=
 looking around I<br>&gt=3B &gt=3B believe that adding support should only =
require adding a new case to<br>&gt=3B &gt=3B the (dev-&gt=3Bboard) switch =
in the saa7134-input.c file titled:<br>&gt=3B &gt=3B <br>&gt=3B &gt=3B SAA7=
134_BOARD_AVERMEDIA_SUPER_007<br>&gt=3B &gt=3B <br>&gt=3B &gt=3B Questions:=
<br>&gt=3B &gt=3B 1.  Is this forum the right place to be asking these ques=
tions? If<br>&gt=3B &gt=3B not=2C where is please?<br>&gt=3B &gt=3B 2.  Sho=
uld adding the relevant information to the saa7134-input.c file<br>&gt=3B &=
gt=3B for an otherwise supported saa7134 dvb-t card result in the remote<br=
>&gt=3B &gt=3B being supported?<br>&gt=3B &gt=3B 3. If so=2C how do I deter=
mine what information needs to be supplied.<br>&gt=3B &gt=3B ie:<br>&gt=3B =
&gt=3B  - are the ir_codes_avermedia appropriate for this card<br>&gt=3B &g=
t=3B  - how do you tell what the mask_keycode and mask_keydown should be?<b=
r>&gt=3B &gt=3B  - how do you work out the appropriate polling interval<br>=
&gt=3B &gt=3B  - what part does saa_setb play in all this.<br>&gt=3B &gt=3B=
 <br>&gt=3B &gt=3B I have the card working and am able to upload any suppor=
ted<br>&gt=3B &gt=3B information needed.<br>&gt=3B &gt=3B <br>&gt=3B &gt=3B=
 Thanks in advance for your help - BVJ.<br>&gt=3B &gt=3B <br>&gt=3B &gt=3B =
My New Box:<br>&gt=3B &gt=3B 2.6.24-19-generic x86_64 GNU/Linux (Mythbuntu =
8.04 fully patched)<br>&gt=3B &gt=3B AMD Athalon X2 64 B4850<br>&gt=3B &gt=
=3B Gigabyte MA78GM-S2H with AMD 780 Northbridge &amp=3B ATI HD 3200 Graphi=
cs<br>&gt=3B &gt=3B Avermedia Super 007 (Digital Only) saa7133 &amp=3B tda8=
290<br>&gt=3B &gt=3B <br>&gt=3B &gt=3B LSPCI output:<br>&gt=3B &gt=3B 03:06=
.0 Multimedia controller: Philips Semiconductors SAA7133/SAA7135<br>&gt=3B =
&gt=3B Video Broadcast Decoder (rev d1)<br>&gt=3B &gt=3B     Subsystem: Ave=
rmedia Technologies Inc Unknown device f01d<br>&gt=3B &gt=3B     Control: I=
/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-<br>&gt=3B &gt=3B ParErr- =
Stepping- SERR- FastB2B-<br>&gt=3B &gt=3B     Status: Cap+ 66MHz- UDF- Fast=
B2B+ ParErr- DEVSEL=3Dmedium &gt=3BTAbort-<br>&gt=3B &gt=3B &lt=3BTAbort- &=
lt=3BMAbort- &gt=3BSERR- &lt=3BPERR-<br>&gt=3B &gt=3B     Latency: 32 (2100=
0ns min=2C 8000ns max)<br>&gt=3B &gt=3B     Interrupt: pin A routed to IRQ =
20<br>&gt=3B &gt=3B     Region 0: Memory at fdcff000 (32-bit=2C non-prefetc=
hable) [size=3D2K]<br>&gt=3B &gt=3B     Capabilities: [40] Power Management=
 version 2<br>&gt=3B &gt=3B         Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=
=3D0mA<br>&gt=3B &gt=3B PME(D0-=2CD1-=2CD2-=2CD3hot-=2CD3cold-)<br>&gt=3B &=
gt=3B         Status: D0 PME-Enable- DSel=3D0 DScale=3D1 PME-<br>&gt=3B &gt=
=3B 00: 31 11 33 71 06 00 90 02 d1 00 80 04 00 20 00 00<br>&gt=3B &gt=3B 10=
: 00 f0 cf fd 00 00 00 00 00 00 00 00 00 00 00 00<br>&gt=3B &gt=3B 20: 00 0=
0 00 00 00 00 00 00 00 00 00 00 61 14 1d f0<br>&gt=3B &gt=3B 30: 00 00 00 0=
0 40 00 00 00 00 00 00 00 0b 01 54 20<br>&gt=3B &gt=3B 40: 01 00 02 06 00 2=
0 00 1c 00 00 00 00 00 00 00 00<br>&gt=3B &gt=3B 50: 00 00 00 00 00 00 00 0=
0 00 00 00 00 00 00 00 00<br>&gt=3B &gt=3B 60: 00 00 00 00 00 00 00 00 00 0=
0 00 00 00 00 00 00<br>&gt=3B &gt=3B 70: 00 00 00 00 00 00 00 00 00 00 00 0=
0 00 00 00 00<br>&gt=3B &gt=3B 80: 00 00 00 00 00 00 00 00 00 00 00 00 00 0=
0 00 00<br>&gt=3B &gt=3B 90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 0=
0<br>&gt=3B &gt=3B a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00<br>&=
gt=3B &gt=3B b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00<br>&gt=3B =
&gt=3B c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00<br>&gt=3B &gt=3B=
 d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00<br>&gt=3B &gt=3B e0: 0=
0 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00<br>&gt=3B &gt=3B f0: 00 00 0=
0 00 00 00 00 00 00 00 00 00 00 00 00 00<br>&gt=3B &gt=3B <br>&gt=3B &gt=3B=
 <br>&gt=3B &gt=3B DMESG output:<br>&gt=3B &gt=3B <br>&gt=3B &gt=3B [   47.=
222507] Linux video capture interface: v2.00<br>&gt=3B &gt=3B [   47.407888=
] saa7130/34: v4l2 driver version 0.2.14 loaded<br>&gt=3B &gt=3B [   47.407=
972] saa7133[0]: found at 0000:03:06.0=2C rev: 209=2C irq: 20=2C<br>&gt=3B =
&gt=3B latency: 32=2C mmio: 0xfdcff000<br>&gt=3B &gt=3B [   47.407979] saa7=
133[0]: subsystem: 1461:f01d=2C board: Avermedia<br>&gt=3B &gt=3B Super 007=
 [card=3D117=2Cautodetected]<br>&gt=3B &gt=3B [   47.407988] saa7133[0]: bo=
ard init: gpio is 40000<br>&gt=3B &gt=3B [   47.542574] saa7133[0]: i2c eep=
rom 00: 61 14 1d f0 54 20 1c 00 43<br>&gt=3B &gt=3B 43 a9 1c 55 d2 b2 92<br=
>&gt=3B &gt=3B [   47.542581] saa7133[0]: i2c eeprom 10: ff ff ff ff ff 20 =
ff ff ff<br>&gt=3B &gt=3B ff ff ff ff ff ff ff<br>&gt=3B &gt=3B [   47.5425=
86] saa7133[0]: i2c eeprom 20: 01 40 01 32 32 01 01 43 88<br>&gt=3B &gt=3B =
ff 00 55 ff ff ff ff<br>&gt=3B &gt=3B [   47.542590] saa7133[0]: i2c eeprom=
 30: ff ff ff ff ff ff ff ff ff<br>&gt=3B &gt=3B ff ff ff ff ff ff ff<br>&g=
t=3B &gt=3B [   47.542595] saa7133[0]: i2c eeprom 40: ff 21 00 c0 96 10 03 =
02 15<br>&gt=3B &gt=3B 16 ff ff ff ff ff ff<br>&gt=3B &gt=3B [   47.542599]=
 saa7133[0]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff<br>&gt=3B &gt=3B ff =
ff ff ff ff ff ff<br>&gt=3B &gt=3B [   47.542603] saa7133[0]: i2c eeprom 60=
: ff ff ff ff ff ff ff ff ff<br>&gt=3B &gt=3B ff ff ff ff ff ff ff<br>&gt=
=3B &gt=3B [   47.542607] saa7133[0]: i2c eeprom 70: ff ff ff ff ff ff ff f=
f ff<br>&gt=3B &gt=3B ff ff ff ff ff ff ff<br>&gt=3B &gt=3B <br>&gt=3B &gt=
=3B [   47.932906] tuner 1-004b: chip found @ 0x96 (saa7133[0])<br>&gt=3B &=
gt=3B [   47.981769] tda8290 1-004b: setting tuner address to 60<br>&gt=3B =
&gt=3B [   48.084618] tuner 1-004b: type set to tda8290+75a<br>&gt=3B &gt=
=3B [   48.132535] tda8290 1-004b: setting tuner address to 60<br>&gt=3B &g=
t=3B [   48.236347] tuner 1-004b: type set to tda8290+75a<br>&gt=3B &gt=3B =
[   48.239259] saa7133[0]: registered device video0 [v4l2]<br>&gt=3B &gt=3B=
 [   48.239278] saa7133[0]: registered device vbi0<br>&gt=3B &gt=3B [   48.=
330034] saa7134 ALSA driver for DMA sound loaded<br>&gt=3B &gt=3B [   48.33=
0064] saa7133[0]/alsa: saa7133[0] at 0xfdcff000 irq 20<br>&gt=3B &gt=3B reg=
istered as card -2<br>&gt=3B &gt=3B [   48.356488] DVB: registering new ada=
pter (saa7133[0])<br>&gt=3B &gt=3B [   48.356494] DVB: registering frontend=
 0 (Philips TDA10046H<br>&gt=3B &gt=3B DVB-T)...<br>&gt=3B &gt=3B [   48.42=
8950] tda1004x: setting up plls for 48MHz sampling clock<br>&gt=3B &gt=3B [=
   48.712424] tda1004x: found firmware revision 20 -- ok<br>&gt=3B &gt=3B <=
br>&gt=3B &gt=3B <br>&gt=3B &gt=3B <br>&gt=3B &gt=3B ______________________=
________________________________________________<br>&gt=3B <br><br /><hr />=
Bees=2C cows=2C tigers and more! <a href=3D'http://livelife.ninemsn.com.au/=
article.aspx?id=3D567534' target=3D'_new'>Windows Live Messenger=A0treats y=
ou to 30 free emoticons.=A0</a></body>
</html>=

--_cc263a81-5c6c-42cf-8680-1c54d482f00d_--


--===============1129619988==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1129619988==--
