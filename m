Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (ext-mx03.extmail.prod.ext.phx2.redhat.com
	[10.5.110.7])
	by int-mx08.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id n9UATA45008029
	for <video4linux-list@redhat.com>; Fri, 30 Oct 2009 06:29:10 -0400
Received: from bay0-omc1-s34.bay0.hotmail.com (bay0-omc1-s34.bay0.hotmail.com
	[65.54.246.106])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n9UASvAB015330
	for <video4linux-list@redhat.com>; Fri, 30 Oct 2009 06:28:57 -0400
Message-ID: <BAY127-W198D24AE45D8B882FF38DABFB60@phx.gbl>
From: =?iso-8859-1?B?Q2FybG9zIExhdu1uIEZ1ZW50ZXM=?=
	<telecomunicador@hotmail.com>
To: <video4linux-list@redhat.com>
Date: Fri, 30 Oct 2009 10:28:57 +0000
In-Reply-To: <20091029160016.6E22D8E0181@hormel.redhat.com>
References: <20091029160016.6E22D8E0181@hormel.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Subject: RE: video4linux-list Digest, Vol 68, Issue 17
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





hello=2C I am working in a driver. I need
your file ov7670_sco.c but i dont' know where i can download this file=2C
can you help me? thank you.


From: video4linux-list-request@redhat.com
Subject: video4linux-list Digest=2C Vol 68=2C Issue 17
To: video4linux-list@redhat.com
Date: Thu=2C 29 Oct 2009 12:00:16 -0400

Send video4linux-list mailing list submissions to
	video4linux-list@redhat.com
=20
To subscribe or unsubscribe via the World Wide Web=2C visit
	https://www.redhat.com/mailman/listinfo/video4linux-list
or=2C via email=2C send a message with subject or body 'help' to
	video4linux-list-request@redhat.com
=20
You can reach the person managing the list at
	video4linux-list-owner@redhat.com
=20
When replying=2C please edit your Subject line so it is more specific
than "Re: Contents of video4linux-list digest..."


--Archivo adjunto de mensaje reenviado--
From: morimoto.kuninori@renesas.com
CC: video4linux-list@redhat.com
To: g.liakhovetski@gmx.de
Date: Thu=2C 29 Oct 2009 09:17:45 +0900
Subject: Re: [PATCH 2/4] soc-camera: tw9910: add hsync control support for	=
platform

=20
Dear Guennadi
=20
Thank you for checking patch
=20
> as you see=2C the snapshot with 0x260 - current mainline value - the imag=
e=20
> is squeezed from sides and padded at the bottom. Which is already not=20
> perfect. Is this also what you're getting in your tests? With 0x160 it is=
=20
> also shifted to the right.
>=20
> So=2C so far this patch doesn't seem like a very good idea to me?
=20
I can agree.
=20
I think that I have asked to you to remove all
my tw9910 and INTERLACE_TB/BT patches except following.
=20
Subject: [PATCH] soc-camera: tw9910: Revision 0 and 1 are able to use
=20
Please remove.
=20
Now I'm trying to modify tw9910 driver.
I guess current tw9910 have some un-correct settings=2C
and it is working with a big luck.
=20
Best regards
--
Kuninori Morimoto
=20
=20
=20


--Archivo adjunto de mensaje reenviado--
From: granis@gmail.com
To: video4linux-list@redhat.com
Date: Thu=2C 29 Oct 2009 02:38:43 +0100
Subject: Hauppauge WinTV HVR-900/EyeTV hybrid USB stick (em2882/em2883)

Hi=2C
=20
Im currently using the EyeTV hybrid USB stick for analog-tv purposes
and its working fine with module "em28xx". However=2C the EyeTV package
is bundled with an IR remote and I was hoping to get it working=2C but
so far - no luck.
=20
In dmesg I can see that somekind of IR is detected by the driver ->
input: em28xx IR (em28xx #0) as /class/input/input4
=20
This is the output from "cat /proc/bus/input/devices" ->
I: Bus=3D0003 Vendor=3D2040 Product=3D6502 Version=3D0001
N: Name=3D"em28xx IR (em28xx #0)"
P: Phys=3Dusb-0000:02:0c.2-1/input0
S: Sysfs=3D/class/input/input4
U: Uniq=3D
H: Handlers=3Dkbd event4
B: EV=3D100003
B: KEY=3D100fc312 214a802 0 0 0 0 18000 41a8 4801 9e1680 0 0 10000ffc
=20
List of loaded modules ->
tveeprom videobuf_core videobuf_vmalloc ir_common v4l1_compat videodev
em28xx v4l2_common tvp5150 tuner tuner_xc2028 em28xx_alsa
=20
I have been testing with " evtest /dev/input/event4" but I am
receiving no output at all.
=20
Does anyone have any suggestions what to try for getting IR to work? :-)
=20
=20


--Archivo adjunto de mensaje reenviado--
From: carlos.lavin@vista-silicon.com
To: video4linux-list@redhat.com
Date: Thu=2C 29 Oct 2009 12:08:36 +0100
Subject: sensors support

hello=2C my name is CARLOS LAVIN FUENTES and I will like to know that senso=
rs
supports imx27 of freescale=2C I don't know where to find them. Can anyone
help me?.
I need to know this information because I have to make a driver with IMX27.
=20
thanks.
=20
 		 	   		 =20
_________________________________________________________________
Convierte las fotos que m=E1s te gustan en tu nuevo fondo de escritorio par=
a el ordenador. Es f=E1cil y adem=E1s gratis
http://wallpapers.msn.com/es-es=
--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
