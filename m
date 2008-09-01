Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m81NAcAK009559
	for <video4linux-list@redhat.com>; Mon, 1 Sep 2008 19:10:38 -0400
Received: from bay0-omc1-s32.bay0.hotmail.com (bay0-omc1-s32.bay0.hotmail.com
	[65.54.246.104])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m81NADJV031851
	for <video4linux-list@redhat.com>; Mon, 1 Sep 2008 19:10:22 -0400
Message-ID: <BAY126-W60A14086F5E15F9DE62FA0E35C0@phx.gbl>
From: Lee Alkureishi <lee_alkureishi@hotmail.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Date: Tue, 2 Sep 2008 00:10:12 +0100
In-Reply-To: <20080901110337.442e207e@mchehab.chehab.org>
References: <BAY126-W51445FEADC96EC0484E7ABE35D0@phx.gbl>
	<20080901110337.442e207e@mchehab.chehab.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Cc: V4L video4linux list <video4linux-list@redhat.com>
Subject: RE: em2820, Tena TNF-9533 and V4L
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

Dear Mauro=2C

Thanks for the response. I've done as Markus suggested (reinstalled my kern=
el=2C rebooted=2C then copy-pasted the lines to hg clone the correct driver=
 folder). I then tried to access the tuner/composite/svideo=2C but am still=
 not getting anything.=20

I tried as you suggested=2C using usbview as a snoop tool to find out more =
about my board. Here is the output:

em28xx
Speed: 480Mb/s (high)
USB Version:  2.00
Device Class: 00(>ifc )
Device Subclass: 00
Device Protocol: 00
Maximum Default Endpoint Size: 64
Number of Configurations: 1
Vendor Id: eb1a
Product Id: 2820
Revision Number:  1.00

Config Number: 1
    Number of Interfaces: 1
    Attributes: 80
    MaxPower Needed: 500mA

    Interface Number: 0
        Name: em28xx
        Alternate Number: 0
        Class: ff(vend.)=20
        Sub Class: 00
        Protocol: ff
        Number of Endpoints: 3

            Endpoint Address: 81
            Direction: in
            Attribute: 3
            Type: Int.
            Max Packet Size: 1
            Interval: 128ms

            Endpoint Address: 82
            Direction: in
            Attribute: 1
            Type: Isoc
            Max Packet Size: 0
            Interval: 125us

            Endpoint Address: 84
            Direction: in
            Attribute: 2
            Type: Bulk
            Max Packet Size: 512
            Interval: 0ms

    Interface Number: 0
        Name: em28xx
        Alternate Number: 1
        Class: ff(vend.)=20
        Sub Class: 00
        Protocol: ff
        Number of Endpoints: 3

            Endpoint Address: 81
            Direction: in
            Attribute: 3
            Type: Int.
            Max Packet Size: 1
            Interval: 128ms

            Endpoint Address: 82
            Direction: in
            Attribute: 1
            Type: Isoc
            Max Packet Size: 1024
            Interval: 125us

            Endpoint Address: 84
            Direction: in
            Attribute: 2
            Type: Bulk
            Max Packet Size: 512
            Interval: 0ms

    Interface Number: 0
        Name: em28xx
        Alternate Number: 2
        Class: ff(vend.)=20
        Sub Class: 00
        Protocol: ff
        Number of Endpoints: 3

            Endpoint Address: 81
            Direction: in
            Attribute: 3
            Type: Int.
            Max Packet Size: 1
            Interval: 128ms

            Endpoint Address: 82
            Direction: in
            Attribute: 1
            Type: Isoc
            Max Packet Size: 1448
            Interval: 125us

            Endpoint Address: 84
            Direction: in
            Attribute: 2
            Type: Bulk
            Max Packet Size: 512
            Interval: 0ms

    Interface Number: 0
        Name: em28xx
        Alternate Number: 3
        Class: ff(vend.)=20
        Sub Class: 00
        Protocol: ff
        Number of Endpoints: 3

            Endpoint Address: 81
            Direction: in
            Attribute: 3
            Type: Int.
            Max Packet Size: 1
            Interval: 128ms

            Endpoint Address: 82
            Direction: in
            Attribute: 1
            Type: Isoc
            Max Packet Size: 2048
            Interval: 125us

            Endpoint Address: 84
            Direction: in
            Attribute: 2
            Type: Bulk
            Max Packet Size: 512
            Interval: 0ms

    Interface Number: 0
        Name: em28xx
        Alternate Number: 4
        Class: ff(vend.)=20
        Sub Class: 00
        Protocol: ff
        Number of Endpoints: 3

            Endpoint Address: 81
            Direction: in
            Attribute: 3
            Type: Int.
            Max Packet Size: 1
            Interval: 128ms

            Endpoint Address: 82
            Direction: in
            Attribute: 1
            Type: Isoc
            Max Packet Size: 2304
            Interval: 125us

            Endpoint Address: 84
            Direction: in
            Attribute: 2
            Type: Bulk
            Max Packet Size: 512
            Interval: 0ms

    Interface Number: 0
        Name: em28xx
        Alternate Number: 5
        Class: ff(vend.)=20
        Sub Class: 00
        Protocol: ff
        Number of Endpoints: 3

            Endpoint Address: 81
            Direction: in
            Attribute: 3
            Type: Int.
            Max Packet Size: 1
            Interval: 128ms

            Endpoint Address: 82
            Direction: in
            Attribute: 1
            Type: Isoc
            Max Packet Size: 2580
            Interval: 125us

            Endpoint Address: 84
            Direction: in
            Attribute: 2
            Type: Bulk
            Max Packet Size: 512
            Interval: 0ms

    Interface Number: 0
        Name: em28xx
        Alternate Number: 6
        Class: ff(vend.)=20
        Sub Class: 00
        Protocol: ff
        Number of Endpoints: 3

            Endpoint Address: 81
            Direction: in
            Attribute: 3
            Type: Int.
            Max Packet Size: 1
            Interval: 128ms

            Endpoint Address: 82
            Direction: in
            Attribute: 1
            Type: Isoc
            Max Packet Size: 2892
            Interval: 125us

            Endpoint Address: 84
            Direction: in
            Attribute: 2
            Type: Bulk
            Max Packet Size: 512
            Interval: 0ms

    Interface Number: 0
        Name: em28xx
        Alternate Number: 7
        Class: ff(vend.)=20
        Sub Class: 00
        Protocol: ff
        Number of Endpoints: 3

            Endpoint Address: 81
            Direction: in
            Attribute: 3
            Type: Int.
            Max Packet Size: 1
            Interval: 128ms

            Endpoint Address: 82
            Direction: in
            Attribute: 1
            Type: Isoc
            Max Packet Size: 3072
            Interval: 125us

            Endpoint Address: 84
            Direction: in
            Attribute: 2
            Type: Bulk
            Max Packet Size: 512
            Interval: 0ms
--------------------------------

I'm afraid I really don't know what to do with this now. Can you point me t=
oward instructions on how to use this information to correctly set the card=
/board/tuner type? I understand the tuner may not work with NTSC signals=2C=
 but I can work just with the composite!=20

For further info=2C here is the output of dmesg after I followed Markus ins=
tructions (It looks the same to me):

leeko@leeko-media:/lib/firmware/2.6.24-19-generic$ sudo rmmod em28xx=20
leeko@leeko-media:/lib/firmware/2.6.24-19-generic$ sudo modprobe em28xx car=
d=3D18 tuner=3D61
leeko@leeko-media:/lib/firmware/2.6.24-19-generic$ sudo dmesg |tail -40
[ 2590.556703] tuner-simple 1-0061: type set to 61 (Tena TNF9533-D/IF/TNF95=
33-B/DF)
[ 2590.556706] tuner 1-0061: type set to Tena TNF9533-D/IF/T
[ 2590.582521] saa7115 1-0025: saa7113 found (1f7113d0e100000) @ 0x4a (em28=
xx #0)
[ 2590.613182] attach_inform: saa7113 detected.
[ 2590.626195] em28xx #0: V4L2 device registered as /dev/video0
[ 2590.626214] em28xx #0: Found KWorld PVR TV 2800 RF
[ 2590.626284] usbcore: registered new interface driver em28xx
[ 4222.550630] usbcore: deregistering interface driver em28xx
[ 4222.550682] em28xx #0: disconnecting em28xx#0 video
[ 4222.550685] em28xx #0: V4L2 VIDEO devices /dev/video0 deregistered
[ 4239.975437] em28xx v4l2 driver version 0.0.1 loaded
[ 4239.980353] em28xx: new video device (eb1a:2820): interface 0=2C class 2=
55
[ 4239.980362] em28xx: device is attached to a USB 2.0 bus
[ 4239.980838] em28xx #0: Alternate settings: 8
[ 4239.980843] em28xx #0: Alternate setting 0=2C max size=3D 0
[ 4239.980845] em28xx #0: Alternate setting 1=2C max size=3D 1024
[ 4239.980848] em28xx #0: Alternate setting 2=2C max size=3D 1448
[ 4239.980850] em28xx #0: Alternate setting 3=2C max size=3D 2048
[ 4239.980852] em28xx #0: Alternate setting 4=2C max size=3D 2304
[ 4239.980854] em28xx #0: Alternate setting 5=2C max size=3D 2580
[ 4239.980857] em28xx #0: Alternate setting 6=2C max size=3D 2892
[ 4239.980859] em28xx #0: Alternate setting 7=2C max size=3D 3072
[ 4240.465375] TEA5767 detected.
[ 4240.465389] tuner 1-0060: chip found @ 0xc0 (em28xx #0)
[ 4240.465434] attach inform (default): detected I2C address c0
[ 4240.465443] tuner-simple 1-0060: type set to 61 (Tena TNF9533-D/IF/TNF95=
33-B/DF)
[ 4240.465447] tuner 1-0060: type set to Tena TNF9533-D/IF/T
[ 4240.465452] tuner-simple 1-0060: type set to 61 (Tena TNF9533-D/IF/TNF95=
33-B/DF)
[ 4240.465454] tuner 1-0060: type set to Tena TNF9533-D/IF/T
[ 4240.466912] tuner 1-0061: chip found @ 0xc2 (em28xx #0)
[ 4240.466950] attach inform (default): detected I2C address c2
[ 4240.466956] tuner-simple 1-0061: type set to 61 (Tena TNF9533-D/IF/TNF95=
33-B/DF)
[ 4240.466959] tuner 1-0061: type set to Tena TNF9533-D/IF/T
[ 4240.466963] tuner-simple 1-0061: type set to 61 (Tena TNF9533-D/IF/TNF95=
33-B/DF)
[ 4240.466966] tuner 1-0061: type set to Tena TNF9533-D/IF/T
[ 4240.492244] saa7115 1-0025: saa7113 found (1f7113d0e100000) @ 0x4a (em28=
xx #0)
[ 4240.523155] attach_inform: saa7113 detected.
[ 4240.530222] em28xx #0: V4L2 device registered as /dev/video0
[ 4240.530230] em28xx #0: Found KWorld PVR TV 2800 RF
[ 4240.530257] usbcore: registered new interface driver em28xx


I hope this makes sense to you - I just want to be able to watch TV!

Thanks=2C

Lee




Lee Alkureishi=20

lee_alkureishi@hotmail.com=20


> Date: Mon=2C 1 Sep 2008 11:03:37 -0300
> From: mchehab@infradead.org
> To: lee_alkureishi@hotmail.com
> CC: video4linux-list@redhat.com=3B alkureishi.lee@gmail.com
> Subject: Re: em2820=2C Tena TNF-9533 and V4L
>=20
> On Sun=2C 31 Aug 2008 19:26:51 +0100
> Lee Alkureishi <lee_alkureishi@hotmail.com> wrote:
>=20
> >=20
> > Hi all=2C
> >=20
> > Hoping someone on this list can help me with this frustrating problem:
> >=20
> > I'm running Mythbuntu 8.04=2C fully updated. I'm trying to set up a USB=
 TV tuner box=2C and have made progress but haven't quite got it working.=20
> >=20
> > The USB box is a Kworld PVR TV 2800 RF. It uses a Empia em2820 chipset=
=2C and a Tena TNF-9533-D/IF tuner. Other chips I found under the casing ar=
e:
> > RM-KUB03 04AEAAC6=2C HEF4052BT=2C TEA5767=2C SAA7113H.=20
>=20
> I have a device with similar chips. All of them are supported. TNF9533-D =
is PAL=2C afaik.
>=20
> > (I had to manally tell modprobe to set the card type (18) and tuner typ=
e (61)=2C as it does not have an EPROM. Took me forever to figure that out!
>=20
> It is possible to add some autodetection for it. Are you using the driver=
 at http://linuxtv.org/hg/v4l-dvb=2C right? On its dmesg log=2C it will pri=
nt some codes that helps to do some tricks for detecting it=2C based on I2C=
 scan signature.
>=20
> > The problem arises when I try to do anything with it=2C though: I've tr=
ied a few programs=2C including mythTV=2C tvtime and xawtv. I can't find a =
way to select the TUNER as the input source. The only options are "composit=
e1" or "s-video1".
>=20
> It seems that you're selecting a different board type.
>=20
> > I tried cycling through input=3D1 through 4=2C but they didn't work eit=
her (2 through 4 give an error about the card not being able to set its inp=
ut).
>=20
> The proper procedure is to run an usb snoop tool that allows us to know w=
hat is the pinup of certain generic entries used to select between tuner/co=
mposite/svideo.
>=20
> > The only thing I can think of=2C is that the tuner may actually have or=
iginated outside the USA (i.e. the UK). Would that stop it from working wit=
h NTSC channels? And even so=2C should the composite input not still work? =
(And why can't I even select the tuner!?).
>=20
> The tuner won't work properly in US=2C since the analog filters inside th=
e tuner is different. Composite should work fine.
>=20
> Cheers=2C
> Mauro

_________________________________________________________________
Make a mini you and download it into Windows Live Messenger
http://clk.atdmt.com/UKM/go/111354029/direct/01/=
--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
