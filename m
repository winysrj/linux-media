Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (ext-mx10.extmail.prod.ext.phx2.redhat.com
	[10.5.110.14])
	by int-mx08.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id n8HDEbY2023239
	for <video4linux-list@redhat.com>; Thu, 17 Sep 2009 09:14:37 -0400
Received: from bay0-omc1-s5.bay0.hotmail.com (bay0-omc1-s5.bay0.hotmail.com
	[65.54.246.77])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n8HDENhi021415
	for <video4linux-list@redhat.com>; Thu, 17 Sep 2009 09:14:23 -0400
Message-ID: <BAY142-W1057A33C315CFDFA910C32DAE10@phx.gbl>
From: Gabriel Dos Santos <irkubr@hotmail.com>
To: <video4linux-list@redhat.com>
Date: Thu, 17 Sep 2009 13:14:22 +0000
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Subject: LifeView LR307Q Mini PCI
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



Hi=2C I recently got a mini PCI LifeView LR307Q Hybrid TV Tuner. =20
I want to use it to tune analog tv (digital would be a plus but it is not r=
eally important to me). The card works perfectly (Analog and digital) on th=
e same machine with Windows. Card subsystem is identified as 4e42:4307=2C w=
hich I didn't find in the list of supported cards by v4l. However=2C tHis f=
orum (http://lists.zerezo.com/video4linux/msg15910.html) reports the card t=
o be working (except for radio) with card=3D60 and audio_clock_override=3D0=
x00187de7 parameters to the module.
However=2C I am unable to make sound  work .=20

I am in Spain=2C which means norm =3D PAL-BG I think. I am using Ubuntu 9.0=
4 (kernel 2.6.18-11)

The steps I follow are

1) Remove the modules loaded by default with wrong parameters: rmmod saa714=
3-alsa=3Brmmod saa7134
2) sudo modprobe saa7134 card=3DX (I've tried several values of X)
3) Run scantv -c /dev/video0  -C /dev/vbi0  (norm =3D 5 =2C region=3D5)
4) open alsamixer in the SAAXXXX device and set the volume to 100% for ever=
y control
5) Run
sox -c 2 -t ossdsp /dev/dsp1 -t ossdsp /dev/dsp& =3B mencoder -tv norm=3DPA=
L-BG:driver=3Dv4l2:device=3D/dev/video0:forceaudio:forcechan=3D1:adevice=3D=
/dev/dsp:fps=3D25:chanlist=3Deurope-west:audiorate=3D32000:width=3D320:heig=
ht=3D240 -vf lavcdeint -ovc lavc -lavcopts vcodec=3Dmpeg4:vbitrate=3D225 -o=
ac lavc -lavcopts abitrate=3D32  -o out.avi tv://23


The results I obtain are as follows

When using any of the values 2=2C3=2C39=2C54=2C74=2C 84=2C82=2C94 for the c=
ard number when loading the module=2C  scantv does not detect any channel

When using any of the values 55=2C60=2C81=2C109 for the card: scantv finds =
channels and I get an image (perfect image with 109=2C there are some glitc=
hes with other values) but only very short pulses of distorted sound. I hav=
e also tried using the parameter audio_clock_override=3D0x00187de7 when loa=
ding the module with the different card values=2C but the result is the sam=
e.

I have also tried using the tuner=3D parameter when loading the module but =
this seems to be ignored=2C since the dmesg always seems to be loading tune=
r=3D54

    tuner' 0-004b: chip found @ 0x96 (saa7133[0])
    tda829x 0-004b: setting tuner address to 61
    tda829x 0-004b: type set to tda8290+75a


Sorry for the long mail but I wanted to provide as much info as possible. I=
 have now spent many nights trying to make this work and I am in the point =
in which I don't know what else to do. I would really appreciate to have so=
me hint on what I am doing wrong=2C

Thanks in advance=2C

Gabriel

BTW: this is the dmesg and lspci output
#sudo lspci -v
00:0e.0 Multimedia controller: Philips Semiconductors SAA7131/SAA7133/SAA71=
35 Video Broadcast Decoder (rev d1)
        Subsystem: Device 4e42:4307
        Flags: bus master=2C medium devsel=2C latency 84=2C IRQ 10
        Memory at efffe000 (32-bit=2C non-prefetchable) [size=3D2K]
        Capabilities: [40] Power Management version 2
        Kernel modules: saa7134


#sudo modprobe saa7134 card=3D109

#dmesg
[ 1821.423064] saa7130/34: v4l2 driver version 0.2.14 loaded
[ 1821.423235] saa7133[0]: found at 0000:00:0e.0=2C rev: 209=2C irq: 10=2C =
latency: 84=2C mmio: 0xefffe000
[ 1821.423269] saa7133[0]: subsystem: 4e42:4307=2C board: Philips Tiger - S=
 Reference design [card=3D109=2Cinsmod option]
[ 1821.423452] saa7133[0]: board init: gpio is 200000
[ 1821.572569] saa7133[0]: i2c eeprom 00: 42 4e 07 43 54 20 1c 00 43 43 a9 =
1c 55 d2 b2 92
[ 1821.572636] saa7133[0]: i2c eeprom 10: ff ff ff 0f ff 20 ff ff ff ff ff =
ff ff ff ff ff
[ 1821.572698] saa7133[0]: i2c eeprom 20: 01 40 01 02 02 01 01 03 08 ff 00 =
9d ff ff ff ff
[ 1821.572759] saa7133[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff ff =
ff ff ff ff ff
[ 1821.572821] saa7133[0]: i2c eeprom 40: ff 21 00 c2 96 10 03 22 15 50 ff =
ff ff ff ff ff
[ 1821.572883] saa7133[0]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff ff =
ff ff ff ff ff
[ 1821.572945] saa7133[0]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff ff ff =
ff ff ff ff ff
[ 1821.573007] saa7133[0]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff ff ff =
ff ff ff ff ff
[ 1821.573070] saa7133[0]: i2c eeprom 80: ff ff ff ff ff ff ff ff ff ff ff =
ff ff ff ff ff
[ 1821.573132] saa7133[0]: i2c eeprom 90: ff ff ff ff ff ff ff ff ff ff ff =
ff ff ff ff ff
[ 1821.573194] saa7133[0]: i2c eeprom a0: ff ff ff ff ff ff ff ff ff ff ff =
ff ff ff ff ff
[ 1821.573256] saa7133[0]: i2c eeprom b0: ff ff ff ff ff ff ff ff ff ff ff =
ff ff ff ff ff
[ 1821.573318] saa7133[0]: i2c eeprom c0: ff ff ff ff ff ff ff ff ff ff ff =
ff ff ff ff ff
[ 1821.573381] saa7133[0]: i2c eeprom d0: ff ff ff ff ff ff ff ff ff ff ff =
ff ff ff ff ff
[ 1821.573443] saa7133[0]: i2c eeprom e0: ff ff ff ff ff ff ff ff ff ff ff =
ff ff ff ff ff
[ 1821.573505] saa7133[0]: i2c eeprom f0: ff ff ff ff ff ff ff ff ff ff ff =
ff ff ff ff ff
[ 1821.657407] tuner' 0-004b: chip found @ 0x96 (saa7133[0])
[ 1821.740582] tda829x 0-004b: setting tuner address to 61
[ 1821.804588] tda829x 0-004b: type set to tda8290+75a
[ 1825.693389] saa7133[0]: registered device video0 [v4l2]
[ 1825.693525] saa7133[0]: registered device vbi0
[ 1825.693659] saa7133[0]: registered device radio0
[ 1825.867650] saa7134 ALSA driver for DMA sound loaded
[ 1825.883426] dvb_init() allocating 1 frontend
[ 1825.884457] saa7133[0]/alsa: saa7133[0] at 0xefffe000 irq 10 registered =
as card -2
[ 1825.945980] DVB: registering new adapter (saa7133[0])
[ 1825.946008] DVB: registering adapter 0 frontend 0 (Philips TDA10046H DVB=
-T)...
[ 1826.168955] tda1004x: setting up plls for 48MHz sampling clock
[ 1828.165008] tda1004x: found firmware revision 29 -- ok


=20
_________________________________________________________________

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
