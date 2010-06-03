Return-path: <linux-media-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:43824 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933348Ab0FCARN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 2 Jun 2010 20:17:13 -0400
From: Ben Hutchings <ben@decadent.org.uk>
To: Andrey Nikitin <andrey.d.nikitin@gmail.com>, 584212@bugs.debian.org
Cc: Dmitry Belimov <d.belimov@gmail.com>,
	Michael Krufky <mkrufky@kernellabs.com>,
	Douglas Schilling Landgraf <dougsland@redhat.com>,
	linux-media <linux-media@vger.kernel.org>
In-Reply-To: <20100602100212.4092.18507.reportbug@host19>
References: <20100602100212.4092.18507.reportbug@host19>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-A/2KmNCBRsbnK376qAlb"
Date: Thu, 03 Jun 2010 01:16:40 +0100
Message-ID: <1275524200.2870.75.camel@localhost>
Mime-Version: 1.0
Subject: Re: Bug#584212: linux-image-2.6.32-3-686-bigmem: saa7134 module is
 blocks an application ("uninterruptible sleep")
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-A/2KmNCBRsbnK376qAlb
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2010-06-02 at 14:02 +0400, Andrey Nikitin wrote:
> Package: linux-2.6
> Version: 2.6.32-9
> Severity: important
> Tags: squeeze
>=20
> The kernel saa7134 module is blocking a v4l2 application as soon as
> another v4l2 application tries to open the same device,
> which is already used by the first v4l2 application.

=46rom what you say below, it seems that it is blocking when the second
process closes the device, not when it opens the device.  It does look
like this driver is trying to clean up resources on close that may not
have been allocated to the file handle.  That may explain why it hangs,
but I'm not sure.

I'm forwarding this to the driver developers for them to look at.
Debian kernel version 2.6.32-9 is closely based on stable version
2.6.32.9.

Ben.

> For example:
> $ sudo rmmod saa7134
> $ sudo modprobe saa7134 video_debug=3D1 ts_debug=3D1 core_debug=3D1 irq_d=
ebug=3D1
> # in first terminal
> $ xawtv -debug 1 -noxv -nodga -c /dev/video0
> .... good v4l capture in grab(no overlay) mode
>=20
> # in second terminal
> $ xawtv -debug 1 -noxv -nodga -c /dev/video0
> ....
> v4l2: new capture params (384x288, BGR3, 331776 byte)
> setformat: 24 bit TrueColor (LE: bgr) (384x288): ok
> v4l2: buf 0: video-cap 0x0+331776, used 0
> v4l2: buf 1: video-cap 0x51000+331776, used 0
> ioctl: VIDIOC_STREAMON(int=3D1): Device or resource busy
> main: setting defaults
> v4l2: freq: 268435455,938
> xt: enter main event loop...=20
> ioctl: VIDIOC_DQBUF(index=3D0;type=3DVIDEO_CAPTURE;bytesused=3D0;flags=3D=
0x0 [];field=3DANY;;timecode.type=3D0;timecode.flags=3D0;timecode.frames=3D=
0;timecode.seconds=3D0;timecode.minutes=3D0;timecode.hours=3D0;timecode.use=
rbits=3D"";sequence=3D0;memory=3DMMAP): =D0=9D=D0=B5=D0=B4=D0=BE=D0=BF=D1=
=83=D1=81=D1=82=D0=B8=D0=BC=D1=8B=D0=B9 =D0=B0=D1=80=D0=B3=D1=83=D0=BC=D0=
=B5=D0=BD=D1=82
> ioctl VIDIOC_STREAMOFF: =D0=9D=D0=B5=D0=B4=D0=BE=D0=BF=D1=83=D1=81=D1=82=
=D0=B8=D0=BC=D1=8B=D0=B9 =D0=B0=D1=80=D0=B3=D1=83=D0=BC=D0=B5=D0=BD=D1=82
> v4l2: buf 0: video-cap 0x0+331776, used 0
> v4l2: buf 1: video-cap 0x51000+331776, used 0
> CloseMainAction: received WM_DELETE_WINDOW message
> cmd: "capture" "off"
> gd: stop
> v4l2: new capture params (384x288, BGR4, 442368 byte)
> setformat: 32 bit TrueColor (LE: bgr-) (384x288): ok
> v4l2: new capture params (384x288, BGR4, 442368 byte)
> v4l2: read: Device or resource busy
> v4l2: close
> ....
>=20
> At this point, the xawtv(1) is completed properly
> and the xawtv(2) is blocked forever.
> xawtv(2) stderr final line: "v4l2: oops: select timeout"
>=20
> % ps alx | grep xawtv | grep -v grep
> 0  1000  4062  4057  30  10  40464 34860 -      DN+  pts/4      0:02 /usr=
/bin/xawtv bin -nodga -debug 1 -noxv -nodga -c /dev/video0
>=20
> /var/log/kern.log
>=20
>  *** xawtv(1) ***
>=20
> Jun  2 13:27:25 host19 kernel: [  675.452249] saa7130[0]/core: buffer_que=
ue f49a4780
> Jun  2 13:27:25 host19 kernel: [  675.491781] saa7130[0]/irq[0,93872]: r=
=3D0x1 s=3D0x00 DONE_RA0 | RA0=3Dvideo,a,even,0
> Jun  2 13:27:25 host19 kernel: [  675.491787] saa7130[0]/core: buffer_fin=
ish f49a49c0
> Jun  2 13:27:25 host19 kernel: [  675.491792] saa7130[0]/core: buffer_nex=
t f49a4780 [prev=3Df49a47ac/next=3Df49a47ac]
> Jun  2 13:27:25 host19 kernel: [  675.491797] saa7130[0] video (Proteus P=
ro [: VIDIOC_DQBUF
> Jun  2 13:27:25 host19 kernel: [  675.491811] saa7130[0]/core: dmabits: t=
ask=3D0x01 ctrl=3D0x01 irq=3D0x3 split=3Dno
> Jun  2 13:27:25 host19 kernel: [  675.491815] saa7130[0]/core: buffer_nex=
t #2 prev=3Df553d5a4/next=3Df553d5a4
> Jun  2 13:27:25 host19 kernel: [  675.492306] saa7130[0] video (Proteus P=
ro [: VIDIOC_QBUF
> Jun  2 13:27:25 host19 kernel: [  675.492312] saa7130[0]/core: buffer_que=
ue f49a49c0
> Jun  2 13:27:25 host19 kernel: [  675.531784] saa7130[0]/irq[0,93882]: r=
=3D0x1 s=3D0x00 DONE_RA0 | RA0=3Dvideo,a,even,0
> Jun  2 13:27:25 host19 kernel: [  675.531790] saa7130[0]/core: buffer_fin=
ish f49a4780
> Jun  2 13:27:25 host19 kernel: [  675.531795] saa7130[0]/core: buffer_nex=
t f49a49c0 [prev=3Df49a49ec/next=3Df49a49ec]
> Jun  2 13:27:25 host19 kernel: [  675.531803] saa7130[0] video (Proteus P=
ro [: VIDIOC_DQBUF
> Jun  2 13:27:25 host19 kernel: [  675.531813] saa7130[0]/core: dmabits: t=
ask=3D0x01 ctrl=3D0x01 irq=3D0x3 split=3Dno
> Jun  2 13:27:25 host19 kernel: [  675.531817] saa7130[0]/core: buffer_nex=
t #2 prev=3Df553d5a4/next=3Df553d5a4
> Jun  2 13:27:25 host19 kernel: [  675.532308] saa7130[0] video (Proteus P=
ro [: VIDIOC_QBUF
> Jun  2 13:27:25 host19 kernel: [  675.532313] saa7130[0]/core: buffer_que=
ue f49a4780
>=20
>  *** start xawtv(2) here ***
>=20
> Jun  2 13:27:25 host19 kernel: [  675.544527] saa7130[0] video (Proteus P=
ro [: VIDIOC_QUERYCAP
> Jun  2 13:27:25 host19 kernel: [  675.544561] saa7130[0] video (Proteus P=
ro [: VIDIOC_QUERYCAP
> Jun  2 13:27:25 host19 kernel: [  675.544573] saa7130[0] video (Proteus P=
ro [: VIDIOC_ENUMINPUT
> Jun  2 13:27:25 host19 kernel: [  675.544576] saa7130[0] video (Proteus P=
ro [: VIDIOC_ENUMINPUT
> Jun  2 13:27:25 host19 kernel: [  675.544583] saa7130[0] video (Proteus P=
ro [: VIDIOC_ENUMINPUT
> Jun  2 13:27:25 host19 kernel: [  675.544586] saa7130[0] video (Proteus P=
ro [: VIDIOC_ENUMINPUT
> Jun  2 13:27:25 host19 kernel: [  675.544589] saa7130[0] video (Proteus P=
ro [: VIDIOC_ENUMSTD
> .... VIDIOC_ENUMSTD ...
> Jun  2 13:27:25 host19 kernel: [  675.544630] saa7130[0] video (Proteus P=
ro [: VIDIOC_ENUMSTD
> Jun  2 13:27:25 host19 kernel: [  675.544633] saa7130[0] video (Proteus P=
ro [: VIDIOC_ENUM_FMT
> Jun  2 13:27:25 host19 kernel: [  675.544635] saa7130[0] video (Proteus P=
ro [: VIDIOC_ENUM_FMT
> .... VIDIOC_ENUM_FMT ...
> Jun  2 13:27:25 host19 kernel: [  675.544668] saa7130[0] video (Proteus P=
ro [: VIDIOC_ENUM_FMT
> Jun  2 13:27:25 host19 kernel: [  675.544671] saa7130[0] video (Proteus P=
ro [: VIDIOC_G_PARM
> Jun  2 13:27:25 host19 kernel: [  675.544675] saa7130[0] video (Proteus P=
ro [: VIDIOC_QUERYCTRL
> .... VIDIOC_QUERYCTRL ...
> Jun  2 13:27:25 host19 kernel: [  675.544835] saa7130[0] video (Proteus P=
ro [: VIDIOC_QUERYCTRL
> Jun  2 13:27:25 host19 kernel: [  675.544853] saa7130[0] video (Proteus P=
ro [: VIDIOC_G_FBUF
> Jun  2 13:27:25 host19 kernel: [  675.571786] saa7130[0]/irq[0,93892]: r=
=3D0x1 s=3D0x00 DONE_RA0 | RA0=3Dvideo,a,even,0
> Jun  2 13:27:25 host19 kernel: [  675.571792] saa7130[0]/core: buffer_fin=
ish f49a49c0
> Jun  2 13:27:25 host19 kernel: [  675.571796] saa7130[0]/core: buffer_nex=
t f49a4780 [prev=3Df49a47ac/next=3Df49a47ac]
> Jun  2 13:27:25 host19 kernel: [  675.571815] saa7130[0]/core: dmabits: t=
ask=3D0x01 ctrl=3D0x01 irq=3D0x3 split=3Dno
> Jun  2 13:27:25 host19 kernel: [  675.571817] saa7130[0]/core: buffer_nex=
t #2 prev=3Df553d5a4/next=3Df553d5a4
> Jun  2 13:27:25 host19 kernel: [  675.571844] saa7130[0] video (Proteus P=
ro [: VIDIOC_DQBUF
> Jun  2 13:27:25 host19 kernel: [  675.572278] saa7130[0] video (Proteus P=
ro [: VIDIOC_QBUF
> Jun  2 13:27:25 host19 kernel: [  675.572283] saa7130[0]/core: buffer_que=
ue f49a49c0
> Jun  2 13:27:25 host19 kernel: [  675.611785] saa7130[0]/irq[0,93902]: r=
=3D0x1 s=3D0x00 DONE_RA0 | RA0=3Dvideo,a,even,0
> Jun  2 13:27:25 host19 kernel: [  675.611791] saa7130[0]/core: buffer_fin=
ish f49a4780
> Jun  2 13:27:25 host19 kernel: [  675.611794] saa7130[0]/core: buffer_nex=
t f49a49c0 [prev=3Df49a49ec/next=3Df49a49ec]
> Jun  2 13:27:25 host19 kernel: [  675.611813] saa7130[0]/core: dmabits: t=
ask=3D0x01 ctrl=3D0x01 irq=3D0x3 split=3Dno
> Jun  2 13:27:25 host19 kernel: [  675.611815] saa7130[0]/core: buffer_nex=
t #2 prev=3Df553d5a4/next=3Df553d5a4
> Jun  2 13:27:25 host19 kernel: [  675.611839] saa7130[0] video (Proteus P=
ro [: VIDIOC_DQBUF
> Jun  2 13:27:25 host19 kernel: [  675.612221] saa7130[0] video (Proteus P=
ro [: VIDIOC_QBUF
> Jun  2 13:27:25 host19 kernel: [  675.612225] saa7130[0]/core: buffer_que=
ue f49a4780
> Jun  2 13:27:25 host19 kernel: [  675.651787] saa7130[0]/irq[0,93912]: r=
=3D0x1 s=3D0x00 DONE_RA0 | RA0=3Dvideo,a,even,0
> Jun  2 13:27:25 host19 kernel: [  675.651793] saa7130[0]/core: buffer_fin=
ish f49a49c0
> Jun  2 13:27:25 host19 kernel: [  675.651796] saa7130[0]/core: buffer_nex=
t f49a4780 [prev=3Df49a47ac/next=3Df49a47ac]
> Jun  2 13:27:25 host19 kernel: [  675.651815] saa7130[0]/core: dmabits: t=
ask=3D0x01 ctrl=3D0x01 irq=3D0x3 split=3Dno
> Jun  2 13:27:25 host19 kernel: [  675.651817] saa7130[0]/core: buffer_nex=
t #2 prev=3Df553d5a4/next=3Df553d5a4
> Jun  2 13:27:25 host19 kernel: [  675.651844] saa7130[0] video (Proteus P=
ro [: VIDIOC_DQBUF
> Jun  2 13:27:25 host19 kernel: [  675.652271] saa7130[0] video (Proteus P=
ro [: VIDIOC_QBUF
> Jun  2 13:27:25 host19 kernel: [  675.652276] saa7130[0]/core: buffer_que=
ue f49a49c0
> Jun  2 13:27:25 host19 kernel: [  675.691786] saa7130[0]/irq[0,93922]: r=
=3D0x1 s=3D0x00 DONE_RA0 | RA0=3Dvideo,a,even,0
> Jun  2 13:27:25 host19 kernel: [  675.691791] saa7130[0]/core: buffer_fin=
ish f49a4780
> Jun  2 13:27:25 host19 kernel: [  675.691795] saa7130[0]/core: buffer_nex=
t f49a49c0 [prev=3Df49a49ec/next=3Df49a49ec]
> Jun  2 13:27:25 host19 kernel: [  675.691804] saa7130[0] video (Proteus P=
ro [: VIDIOC_DQBUF
> Jun  2 13:27:25 host19 kernel: [  675.691814] saa7130[0]/core: dmabits: t=
ask=3D0x01 ctrl=3D0x01 irq=3D0x3 split=3Dno
> Jun  2 13:27:25 host19 kernel: [  675.691817] saa7130[0]/core: buffer_nex=
t #2 prev=3Df553d5a4/next=3Df553d5a4
> Jun  2 13:27:25 host19 kernel: [  675.692268] saa7130[0] video (Proteus P=
ro [: VIDIOC_QBUF
> Jun  2 13:27:25 host19 kernel: [  675.692273] saa7130[0]/core: buffer_que=
ue f49a4780
> Jun  2 13:27:25 host19 kernel: [  675.731788] saa7130[0]/irq[0,93932]: r=
=3D0x1 s=3D0x00 DONE_RA0 | RA0=3Dvideo,a,even,0
> Jun  2 13:27:25 host19 kernel: [  675.731793] saa7130[0]/core: buffer_fin=
ish f49a49c0
> Jun  2 13:27:25 host19 kernel: [  675.731797] saa7130[0]/core: buffer_nex=
t f49a4780 [prev=3Df49a47ac/next=3Df49a47ac]
> Jun  2 13:27:25 host19 kernel: [  675.731815] saa7130[0]/core: dmabits: t=
ask=3D0x01 ctrl=3D0x01 irq=3D0x3 split=3Dno
> Jun  2 13:27:25 host19 kernel: [  675.731818] saa7130[0]/core: buffer_nex=
t #2 prev=3Df553d5a4/next=3Df553d5a4
> Jun  2 13:27:25 host19 kernel: [  675.731843] saa7130[0] video (Proteus P=
ro [: VIDIOC_DQBUF
> Jun  2 13:27:25 host19 kernel: [  675.732231] saa7130[0] video (Proteus P=
ro [: VIDIOC_QBUF
> Jun  2 13:27:25 host19 kernel: [  675.732235] saa7130[0]/core: buffer_que=
ue f49a49c0
> Jun  2 13:27:25 host19 kernel: [  675.771788] saa7130[0]/irq[0,93942]: r=
=3D0x1 s=3D0x00 DONE_RA0 | RA0=3Dvideo,a,even,0
> Jun  2 13:27:25 host19 kernel: [  675.771794] saa7130[0]/core: buffer_fin=
ish f49a4780
> Jun  2 13:27:25 host19 kernel: [  675.771798] saa7130[0]/core: buffer_nex=
t f49a49c0 [prev=3Df49a49ec/next=3Df49a49ec]
> Jun  2 13:27:25 host19 kernel: [  675.771808] saa7130[0] video (Proteus P=
ro [: VIDIOC_DQBUF
> Jun  2 13:27:25 host19 kernel: [  675.771818] saa7130[0]/core: dmabits: t=
ask=3D0x01 ctrl=3D0x01 irq=3D0x3 split=3Dno
> Jun  2 13:27:25 host19 kernel: [  675.771821] saa7130[0]/core: buffer_nex=
t #2 prev=3Df553d5a4/next=3Df553d5a4
> Jun  2 13:27:25 host19 kernel: [  675.772339] saa7130[0] video (Proteus P=
ro [: VIDIOC_QBUF
> Jun  2 13:27:25 host19 kernel: [  675.772345] saa7130[0]/core: buffer_que=
ue f49a4780
> Jun  2 13:27:25 host19 kernel: [  675.811790] saa7130[0]/irq[0,93952]: r=
=3D0x1 s=3D0x00 DONE_RA0 | RA0=3Dvideo,a,even,0
> Jun  2 13:27:25 host19 kernel: [  675.811797] saa7130[0]/core: buffer_fin=
ish f49a49c0
> Jun  2 13:27:25 host19 kernel: [  675.811802] saa7130[0]/core: buffer_nex=
t f49a4780 [prev=3Df49a47ac/next=3Df49a47ac]
> Jun  2 13:27:25 host19 kernel: [  675.811811] saa7130[0] video (Proteus P=
ro [: VIDIOC_DQBUF
> Jun  2 13:27:25 host19 kernel: [  675.811823] saa7130[0]/core: dmabits: t=
ask=3D0x01 ctrl=3D0x01 irq=3D0x3 split=3Dno
> Jun  2 13:27:25 host19 kernel: [  675.811827] saa7130[0]/core: buffer_nex=
t #2 prev=3Df553d5a4/next=3Df553d5a4
> Jun  2 13:27:25 host19 kernel: [  675.812398] saa7130[0] video (Proteus P=
ro [: VIDIOC_QBUF
> Jun  2 13:27:25 host19 kernel: [  675.812405] saa7130[0]/core: buffer_que=
ue f49a49c0
> Jun  2 13:27:25 host19 kernel: [  675.830753] saa7130[0] video (Proteus P=
ro [: VIDIOC_G_STD
> Jun  2 13:27:25 host19 kernel: [  675.830782] saa7130[0] video (Proteus P=
ro [: VIDIOC_G_INPUT
> Jun  2 13:27:25 host19 kernel: [  675.830794] saa7130[0] video (Proteus P=
ro [: VIDIOC_G_TUNER
> Jun  2 13:27:25 host19 kernel: [  675.830820] saa7130[0] video (Proteus P=
ro [: VIDIOC_G_CTRL
> Jun  2 13:27:25 host19 kernel: [  675.830828] saa7130[0] video (Proteus P=
ro [: VIDIOC_G_CTRL
> Jun  2 13:27:25 host19 kernel: [  675.830832] saa7130[0] video (Proteus P=
ro [: VIDIOC_G_CTRL
> Jun  2 13:27:25 host19 kernel: [  675.830836] saa7130[0] video (Proteus P=
ro [: VIDIOC_G_CTRL
> Jun  2 13:27:25 host19 kernel: [  675.830840] saa7130[0] video (Proteus P=
ro [: VIDIOC_G_CTRL
> Jun  2 13:27:25 host19 kernel: [  675.830852] saa7130[0] video (Proteus P=
ro [: VIDIOC_G_CTRL
> Jun  2 13:27:25 host19 kernel: [  675.830863] saa7130[0] video (Proteus P=
ro [: VIDIOC_G_CTRL
> Jun  2 13:27:25 host19 kernel: [  675.830868] saa7130[0] video (Proteus P=
ro [: VIDIOC_G_CTRL
> Jun  2 13:27:25 host19 kernel: [  675.830871] saa7130[0] video (Proteus P=
ro [: VIDIOC_G_CTRL
> Jun  2 13:27:25 host19 kernel: [  675.830886] saa7130[0] video (Proteus P=
ro [: VIDIOC_S_CTRL
> Jun  2 13:27:25 host19 kernel: [  675.830891] saa7130[0] video (Proteus P=
ro [: VIDIOC_G_CTRL
> Jun  2 13:27:25 host19 kernel: [  675.830893] saa7130[0] video (Proteus P=
ro [: VIDIOC_G_CTRL
> Jun  2 13:27:25 host19 kernel: [  675.851794] saa7130[0]/irq[0,93962]: r=
=3D0x1 s=3D0x00 DONE_RA0 | RA0=3Dvideo,a,even,0
> Jun  2 13:27:25 host19 kernel: [  675.851804] saa7130[0]/core: buffer_fin=
ish f49a4780
> Jun  2 13:27:25 host19 kernel: [  675.851812] saa7130[0]/core: buffer_nex=
t f49a49c0 [prev=3Df49a49ec/next=3Df49a49ec]
> Jun  2 13:27:25 host19 kernel: [  675.851849] saa7130[0]/core: dmabits: t=
ask=3D0x01 ctrl=3D0x01 irq=3D0x3 split=3Dno
> Jun  2 13:27:25 host19 kernel: [  675.851855] saa7130[0]/core: buffer_nex=
t #2 prev=3Df553d5a4/next=3Df553d5a4
> Jun  2 13:27:25 host19 kernel: [  675.851892] saa7130[0] video (Proteus P=
ro [: VIDIOC_DQBUF
> Jun  2 13:27:25 host19 kernel: [  675.853537] saa7130[0] video (Proteus P=
ro [: VIDIOC_QBUF
> Jun  2 13:27:25 host19 kernel: [  675.853546] saa7130[0]/core: buffer_que=
ue f49a4780
> Jun  2 13:27:25 host19 kernel: [  675.881054] saa7130[0] video (Proteus P=
ro [: VIDIOC_S_FMT
> Jun  2 13:27:25 host19 kernel: [  675.881532] saa7130[0] video (Proteus P=
ro [: VIDIOC_S_FMT
> Jun  2 13:27:25 host19 kernel: [  675.881543] saa7130[0] video (Proteus P=
ro [: VIDIOC_REQBUFS
> Jun  2 13:27:25 host19 kernel: [  675.881549] saa7130[0] video (Proteus P=
ro [: VIDIOC_QUERYBUF
> Jun  2 13:27:25 host19 kernel: [  675.881559] saa7130[0] video (Proteus P=
ro [: VIDIOC_QUERYBUF
> Jun  2 13:27:25 host19 kernel: [  675.881567] saa7130[0] video (Proteus P=
ro [: VIDIOC_QBUF
> Jun  2 13:27:25 host19 kernel: [  675.881743] saa7130[0] video (Proteus P=
ro [: VIDIOC_QBUF
> Jun  2 13:27:25 host19 kernel: [  675.881906] saa7130[0] video (Proteus P=
ro [: VIDIOC_STREAMON
> Jun  2 13:27:25 host19 kernel: [  675.881957] saa7130[0] video (Proteus P=
ro [: VIDIOC_G_FREQUENCY
> Jun  2 13:27:25 host19 kernel: [  675.881965] saa7130[0] video (Proteus P=
ro [: VIDIOC_S_CTRL
> Jun  2 13:27:25 host19 kernel: [  675.881972] saa7130[0] video (Proteus P=
ro [: VIDIOC_S_CTRL
> Jun  2 13:27:25 host19 kernel: [  675.881976] saa7130[0] video (Proteus P=
ro [: VIDIOC_S_CTRL
> Jun  2 13:27:25 host19 kernel: [  675.881980] saa7130[0] video (Proteus P=
ro [: VIDIOC_S_CTRL
> Jun  2 13:27:25 host19 kernel: [  675.881984] saa7130[0] video (Proteus P=
ro [: VIDIOC_S_INPUT
> Jun  2 13:27:25 host19 kernel: [  675.882014] saa7130[0] video (Proteus P=
ro [: VIDIOC_S_STD
> Jun  2 13:27:25 host19 kernel: [  675.882035] saa7130[0]/irq[0,93970]: r=
=3D0x80 s=3D0x00 RDCAP
> Jun  2 13:27:25 host19 kernel: [  675.882038] saa7130[0] video (Proteus P=
ro [:=20
> Jun  2 13:27:25 host19 kernel: [  675.882041] VIDIOC_S_FREQUENCY
> Jun  2 13:27:25 host19 kernel: [  675.882152] saa7130[0]/irq[0,93970]: r=
=3D0x80 s=3D0x00 RDCAP
> Jun  2 13:27:25 host19 kernel: [  675.882507] saa7130[0] video (Proteus P=
ro [: VIDIOC_DQBUF
> Jun  2 13:27:25 host19 kernel: [  675.882595] saa7130[0] video (Proteus P=
ro [: VIDIOC_STREAMOFF
> Jun  2 13:27:25 host19 kernel: [  675.883206] saa7130[0]/irq[0,93970]: r=
=3D0x100 s=3D0x00 INTL
> Jun  2 13:27:25 host19 kernel: [  675.891687] saa7130[0]/irq[0,93972]: r=
=3D0x1 s=3D0x00 DONE_RA0 | RA0=3Dvideo,a,even,0
> Jun  2 13:27:25 host19 kernel: [  675.891695] saa7130[0]/core: buffer_nex=
t f49a4780 [prev=3Df49a47ac/next=3Df49a47ac]
> Jun  2 13:27:25 host19 kernel: [  675.891716] saa7130[0]/core: dmabits: t=
ask=3D0x01 ctrl=3D0x01 irq=3D0x3 split=3Dno
> Jun  2 13:27:25 host19 kernel: [  675.891719] saa7130[0]/core: buffer_nex=
t #2 prev=3Df553d5a4/next=3Df553d5a4
> Jun  2 13:27:26 host19 kernel: [  675.918533] saa7130[0]/irq[0,93979]: r=
=3D0x100 s=3D0x00 INTL
> Jun  2 13:27:26 host19 kernel: [  675.931673] saa7130[0]/irq[0,93982]: r=
=3D0x1 s=3D0x00 DONE_RA0 | RA0=3Dvideo,a,even,0
> Jun  2 13:27:26 host19 kernel: [  675.931679] saa7130[0]/core: buffer_fin=
ish f49a4780
> Jun  2 13:27:26 host19 kernel: [  675.931682] saa7130[0]/core: buffer_nex=
t (null)
> Jun  2 13:27:26 host19 kernel: [  675.931689] saa7130[0]/core: dmabits: t=
ask=3D0x00 ctrl=3D0x00 irq=3D0x0 split=3Dyes
> Jun  2 13:27:26 host19 kernel: [  675.934414] saa7130[0]/irq[0,93983]: r=
=3D0x100 s=3D0x00 INTL
> Jun  2 13:27:30 host19 kernel: [  680.878575] saa7130[0] video (Proteus P=
ro [: VIDIOC_STREAMOFF
> Jun  2 13:27:31 host19 kernel: [  681.260133] saa7130[0] video (Proteus P=
ro [: VIDIOC_S_CTRL
> Jun  2 13:27:31 host19 kernel: [  681.260168] saa7130[0] video (Proteus P=
ro [: VIDIOC_S_FMT
> Jun  2 13:27:31 host19 kernel: [  681.260185] saa7130[0] video (Proteus P=
ro [: VIDIOC_S_FMT
> Jun  2 13:30:10 host19 kernel: [  840.660063] INFO: task xawtv.bin:4062 b=
locked for more than 120 seconds.
> Jun  2 13:30:10 host19 kernel: [  840.660067] "echo 0 > /proc/sys/kernel/=
hung_task_timeout_secs" disables this message.
> Jun  2 13:30:10 host19 kernel: [  840.660070] xawtv.bin     D f9c345db   =
  0  4062   4057 0x00000000
> Jun  2 13:30:10 host19 kernel: [  840.660076]  f483d0c0 00000082 c146529c=
 f9c345db 00000400 c1420d20 c1420d20 c141c2ac
> Jun  2 13:30:10 host19 kernel: [  840.660084]  f483d27c c3c08d20 00000000=
 c104dd2e 00000092 000a032a c1037091 c1464e9c
> Jun  2 13:30:10 host19 kernel: [  840.660091]  c3c042ac f483d27c 000173ac=
 c1464ea0 00000004 00000000 00000000 00000000
> Jun  2 13:30:10 host19 kernel: [  840.660098] Call Trace:
> Jun  2 13:30:10 host19 kernel: [  840.660118]  [<c104dd2e>] ? up+0x9/0x2a
> Jun  2 13:30:10 host19 kernel: [  840.660124]  [<c1037091>] ? release_con=
sole_sem+0x174/0x1a2
> Jun  2 13:30:10 host19 kernel: [  840.660135]  [<f9cd65a8>] ? videobuf_wa=
iton+0x11d/0x134 [videobuf_core]
> Jun  2 13:30:10 host19 kernel: [  840.660141]  [<c104a882>] ? autoremove_=
wake_function+0x0/0x2d
> Jun  2 13:30:10 host19 kernel: [  840.660148]  [<f80f51a5>] ? saa7134_dma=
_free+0x2f/0x4a [saa7134]
> Jun  2 13:30:10 host19 kernel: [  840.660156]  [<f9cd6c2c>] ? videobuf_qu=
eue_cancel+0x97/0xb3 [videobuf_core]
> Jun  2 13:30:10 host19 kernel: [  840.660162]  [<f9cd6c68>] ? videobuf_st=
reamoff+0x20/0x2c [videobuf_core]
> Jun  2 13:30:10 host19 kernel: [  840.660169]  [<f80f91d6>] ? saa7134_str=
eamoff+0x28/0x4a [saa7134]
> Jun  2 13:30:10 host19 kernel: [  840.660176]  [<f9c31e9c>] ? __video_do_=
ioctl+0x10c9/0x29f6 [videodev]
> Jun  2 13:30:10 host19 kernel: [  840.660182]  [<c100cf0d>] ? sched_clock=
+0x5/0x7
> Jun  2 13:30:10 host19 kernel: [  840.660186]  [<c104e76f>] ? sched_clock=
_local+0x15/0x11b
> Jun  2 13:30:10 host19 kernel: [  840.660193]  [<f9c33a52>] ? video_ioctl=
2+0x289/0x327 [videodev]
> Jun  2 13:30:10 host19 kernel: [  840.660198]  [<c102706f>] ? __wake_up_c=
ommon+0x34/0x59
> Jun  2 13:30:10 host19 kernel: [  840.660203]  [<c102b157>] ? __wake_up+0=
x29/0x39
> Jun  2 13:30:10 host19 kernel: [  840.660208]  [<c1198575>] ? tty_wakeup+=
0x43/0x47
> Jun  2 13:30:10 host19 kernel: [  840.660212]  [<c119e27c>] ? pty_write+0=
x39/0x3f
> Jun  2 13:30:10 host19 kernel: [  840.660217]  [<c104aa2c>] ? remove_wait=
_queue+0xb/0x2f
> Jun  2 13:30:10 host19 kernel: [  840.660226]  [<f9c337c9>] ? video_ioctl=
2+0x0/0x327 [videodev]
> Jun  2 13:30:10 host19 kernel: [  840.660231]  [<f9c3010f>] ? v4l2_ioctl+=
0x31/0x34 [videodev]
> Jun  2 13:30:10 host19 kernel: [  840.660237]  [<c10c4d21>] ? vfs_ioctl+0=
x49/0x5f
> Jun  2 13:30:10 host19 kernel: [  840.660242]  [<c10c5288>] ? do_vfs_ioct=
l+0x4aa/0x4e5
> Jun  2 13:30:10 host19 kernel: [  840.660246]  [<c10ba296>] ? fsnotify_mo=
dify+0x5a/0x61
> Jun  2 13:30:10 host19 kernel: [  840.660250]  [<c119827d>] ? tty_write+0=
x0/0x1c0
> Jun  2 13:30:10 host19 kernel: [  840.660254]  [<c10bae96>] ? vfs_write+0=
x9e/0xd6
> Jun  2 13:30:10 host19 kernel: [  840.660259]  [<c10c5304>] ? sys_ioctl+0=
x41/0x58
> Jun  2 13:30:10 host19 kernel: [  840.660263]  [<c1007f5b>] ? sysenter_do=
_call+0x12/0x28
> Jun  2 13:32:10 host19 kernel: [  960.660062] INFO: task xawtv.bin:4062 b=
locked for more than 120 seconds.
> Jun  2 13:32:10 host19 kernel: [  960.660066] "echo 0 > /proc/sys/kernel/=
hung_task_timeout_secs" disables this message.
> Jun  2 13:32:10 host19 kernel: [  960.660069] xawtv.bin     D f9c345db   =
  0  4062   4057 0x00000000
> Jun  2 13:32:10 host19 kernel: [  960.660075]  f483d0c0 00000082 c146529c=
 f9c345db 00000400 c1420d20 c1420d20 c141c2ac
> Jun  2 13:32:10 host19 kernel: [  960.660083]  f483d27c c3c08d20 00000000=
 c104dd2e 00000092 000a032a c1037091 c1464e9c
> Jun  2 13:32:10 host19 kernel: [  960.660090]  c3c042ac f483d27c 000173ac=
 c1464ea0 00000004 00000000 00000000 00000000
> Jun  2 13:32:10 host19 kernel: [  960.660097] Call Trace:
> Jun  2 13:32:10 host19 kernel: [  960.660118]  [<c104dd2e>] ? up+0x9/0x2a
> Jun  2 13:32:10 host19 kernel: [  960.660124]  [<c1037091>] ? release_con=
sole_sem+0x174/0x1a2
> Jun  2 13:32:10 host19 kernel: [  960.660135]  [<f9cd65a8>] ? videobuf_wa=
iton+0x11d/0x134 [videobuf_core]
> Jun  2 13:32:10 host19 kernel: [  960.660141]  [<c104a882>] ? autoremove_=
wake_function+0x0/0x2d
> Jun  2 13:32:10 host19 kernel: [  960.660148]  [<f80f51a5>] ? saa7134_dma=
_free+0x2f/0x4a [saa7134]
> Jun  2 13:32:10 host19 kernel: [  960.660156]  [<f9cd6c2c>] ? videobuf_qu=
eue_cancel+0x97/0xb3 [videobuf_core]
> Jun  2 13:32:10 host19 kernel: [  960.660162]  [<f9cd6c68>] ? videobuf_st=
reamoff+0x20/0x2c [videobuf_core]
> Jun  2 13:32:10 host19 kernel: [  960.660169]  [<f80f91d6>] ? saa7134_str=
eamoff+0x28/0x4a [saa7134]
> Jun  2 13:32:10 host19 kernel: [  960.660175]  [<f9c31e9c>] ? __video_do_=
ioctl+0x10c9/0x29f6 [videodev]
> Jun  2 13:32:10 host19 kernel: [  960.660181]  [<c100cf0d>] ? sched_clock=
+0x5/0x7
> Jun  2 13:32:10 host19 kernel: [  960.660185]  [<c104e76f>] ? sched_clock=
_local+0x15/0x11b
> Jun  2 13:32:10 host19 kernel: [  960.660193]  [<f9c33a52>] ? video_ioctl=
2+0x289/0x327 [videodev]
> Jun  2 13:32:10 host19 kernel: [  960.660198]  [<c102706f>] ? __wake_up_c=
ommon+0x34/0x59
> Jun  2 13:32:10 host19 kernel: [  960.660203]  [<c102b157>] ? __wake_up+0=
x29/0x39
> Jun  2 13:32:10 host19 kernel: [  960.660208]  [<c1198575>] ? tty_wakeup+=
0x43/0x47
> Jun  2 13:32:10 host19 kernel: [  960.660212]  [<c119e27c>] ? pty_write+0=
x39/0x3f
> Jun  2 13:32:10 host19 kernel: [  960.660216]  [<c104aa2c>] ? remove_wait=
_queue+0xb/0x2f
> Jun  2 13:32:10 host19 kernel: [  960.660226]  [<f9c337c9>] ? video_ioctl=
2+0x0/0x327 [videodev]
> Jun  2 13:32:10 host19 kernel: [  960.660232]  [<f9c3010f>] ? v4l2_ioctl+=
0x31/0x34 [videodev]
> Jun  2 13:32:10 host19 kernel: [  960.660238]  [<c10c4d21>] ? vfs_ioctl+0=
x49/0x5f
> Jun  2 13:32:10 host19 kernel: [  960.660242]  [<c10c5288>] ? do_vfs_ioct=
l+0x4aa/0x4e5
> Jun  2 13:32:10 host19 kernel: [  960.660247]  [<c10ba296>] ? fsnotify_mo=
dify+0x5a/0x61
> Jun  2 13:32:10 host19 kernel: [  960.660251]  [<c119827d>] ? tty_write+0=
x0/0x1c0
> Jun  2 13:32:10 host19 kernel: [  960.660255]  [<c10bae96>] ? vfs_write+0=
x9e/0xd6
> Jun  2 13:32:10 host19 kernel: [  960.660259]  [<c10c5304>] ? sys_ioctl+0=
x41/0x58
> Jun  2 13:32:10 host19 kernel: [  960.660263]  [<c1007f5b>] ? sysenter_do=
_call+0x12/0x28
> Jun  2 13:34:10 host19 kernel: [ 1080.660056] INFO: task xawtv.bin:4062 b=
locked for more than 120 seconds.
>=20
>=20
> -- Package-specific info:
> ** Version:
> Linux version 2.6.32-3-686-bigmem (Debian 2.6.32-9) (maks@debian.org) (gc=
c version 4.3.4 (Debian 4.3.4-8) ) #1 SMP Thu Feb 25 06:54:30 UTC 2010
>=20
> ** Command line:
> BOOT_IMAGE=3D//vmlinuz-2.6.32-3-686-bigmem root=3D/dev/mapper/md_mirr-roo=
t ro quiet
>=20
> ** Tainted: P (1)
>  * Proprietary module has been loaded.
>=20
> ** Kernel log:
> [  681.260185] saa7130[0] video (Proteus Pro [: VIDIOC_S_FMT
> [  840.660063] INFO: task xawtv.bin:4062 blocked for more than 120 second=
s.
> [  840.660067] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disable=
s this message.
> [  840.660070] xawtv.bin     D f9c345db     0  4062   4057 0x00000000
> [  840.660076]  f483d0c0 00000082 c146529c f9c345db 00000400 c1420d20 c14=
20d20 c141c2ac
> [  840.660084]  f483d27c c3c08d20 00000000 c104dd2e 00000092 000a032a c10=
37091 c1464e9c
> [  840.660091]  c3c042ac f483d27c 000173ac c1464ea0 00000004 00000000 000=
00000 00000000
> [  840.660098] Call Trace:
> [  840.660118]  [<c104dd2e>] ? up+0x9/0x2a
> [  840.660124]  [<c1037091>] ? release_console_sem+0x174/0x1a2
> [  840.660135]  [<f9cd65a8>] ? videobuf_waiton+0x11d/0x134 [videobuf_core=
]
> [  840.660141]  [<c104a882>] ? autoremove_wake_function+0x0/0x2d
> [  840.660148]  [<f80f51a5>] ? saa7134_dma_free+0x2f/0x4a [saa7134]
> [  840.660156]  [<f9cd6c2c>] ? videobuf_queue_cancel+0x97/0xb3 [videobuf_=
core]
> [  840.660162]  [<f9cd6c68>] ? videobuf_streamoff+0x20/0x2c [videobuf_cor=
e]
> [  840.660169]  [<f80f91d6>] ? saa7134_streamoff+0x28/0x4a [saa7134]
> [  840.660176]  [<f9c31e9c>] ? __video_do_ioctl+0x10c9/0x29f6 [videodev]
> [  840.660182]  [<c100cf0d>] ? sched_clock+0x5/0x7
> [  840.660186]  [<c104e76f>] ? sched_clock_local+0x15/0x11b
> [  840.660193]  [<f9c33a52>] ? video_ioctl2+0x289/0x327 [videodev]
> [  840.660198]  [<c102706f>] ? __wake_up_common+0x34/0x59
> [  840.660203]  [<c102b157>] ? __wake_up+0x29/0x39
> [  840.660208]  [<c1198575>] ? tty_wakeup+0x43/0x47
> [  840.660212]  [<c119e27c>] ? pty_write+0x39/0x3f
> [  840.660217]  [<c104aa2c>] ? remove_wait_queue+0xb/0x2f
> [  840.660226]  [<f9c337c9>] ? video_ioctl2+0x0/0x327 [videodev]
> [  840.660231]  [<f9c3010f>] ? v4l2_ioctl+0x31/0x34 [videodev]
> [  840.660237]  [<c10c4d21>] ? vfs_ioctl+0x49/0x5f
> [  840.660242]  [<c10c5288>] ? do_vfs_ioctl+0x4aa/0x4e5
> [  840.660246]  [<c10ba296>] ? fsnotify_modify+0x5a/0x61
> [  840.660250]  [<c119827d>] ? tty_write+0x0/0x1c0
> [  840.660254]  [<c10bae96>] ? vfs_write+0x9e/0xd6
> [  840.660259]  [<c10c5304>] ? sys_ioctl+0x41/0x58
> [  840.660263]  [<c1007f5b>] ? sysenter_do_call+0x12/0x28
> [  960.660062] INFO: task xawtv.bin:4062 blocked for more than 120 second=
s.
> [  960.660066] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disable=
s this message.
> [  960.660069] xawtv.bin     D f9c345db     0  4062   4057 0x00000000
> [  960.660075]  f483d0c0 00000082 c146529c f9c345db 00000400 c1420d20 c14=
20d20 c141c2ac
> [  960.660083]  f483d27c c3c08d20 00000000 c104dd2e 00000092 000a032a c10=
37091 c1464e9c
> [  960.660090]  c3c042ac f483d27c 000173ac c1464ea0 00000004 00000000 000=
00000 00000000
> [  960.660097] Call Trace:
> [  960.660118]  [<c104dd2e>] ? up+0x9/0x2a
> [  960.660124]  [<c1037091>] ? release_console_sem+0x174/0x1a2
> [  960.660135]  [<f9cd65a8>] ? videobuf_waiton+0x11d/0x134 [videobuf_core=
]
> [  960.660141]  [<c104a882>] ? autoremove_wake_function+0x0/0x2d
> [  960.660148]  [<f80f51a5>] ? saa7134_dma_free+0x2f/0x4a [saa7134]
> [  960.660156]  [<f9cd6c2c>] ? videobuf_queue_cancel+0x97/0xb3 [videobuf_=
core]
> [  960.660162]  [<f9cd6c68>] ? videobuf_streamoff+0x20/0x2c [videobuf_cor=
e]
> [  960.660169]  [<f80f91d6>] ? saa7134_streamoff+0x28/0x4a [saa7134]
> [  960.660175]  [<f9c31e9c>] ? __video_do_ioctl+0x10c9/0x29f6 [videodev]
> [  960.660181]  [<c100cf0d>] ? sched_clock+0x5/0x7
> [  960.660185]  [<c104e76f>] ? sched_clock_local+0x15/0x11b
> [  960.660193]  [<f9c33a52>] ? video_ioctl2+0x289/0x327 [videodev]
> [  960.660198]  [<c102706f>] ? __wake_up_common+0x34/0x59
> [  960.660203]  [<c102b157>] ? __wake_up+0x29/0x39
> [  960.660208]  [<c1198575>] ? tty_wakeup+0x43/0x47
> [  960.660212]  [<c119e27c>] ? pty_write+0x39/0x3f
> [  960.660216]  [<c104aa2c>] ? remove_wait_queue+0xb/0x2f
> [  960.660226]  [<f9c337c9>] ? video_ioctl2+0x0/0x327 [videodev]
> [  960.660232]  [<f9c3010f>] ? v4l2_ioctl+0x31/0x34 [videodev]
> [  960.660238]  [<c10c4d21>] ? vfs_ioctl+0x49/0x5f
> [  960.660242]  [<c10c5288>] ? do_vfs_ioctl+0x4aa/0x4e5
> [  960.660247]  [<c10ba296>] ? fsnotify_modify+0x5a/0x61
> [  960.660251]  [<c119827d>] ? tty_write+0x0/0x1c0
> [  960.660255]  [<c10bae96>] ? vfs_write+0x9e/0xd6
> [  960.660259]  [<c10c5304>] ? sys_ioctl+0x41/0x58
> [  960.660263]  [<c1007f5b>] ? sysenter_do_call+0x12/0x28
> [ 1080.660056] INFO: task xawtv.bin:4062 blocked for more than 120 second=
s.
> [ 1080.660061] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disable=
s this message.
> [ 1080.660064] xawtv.bin     D f9c345db     0  4062   4057 0x00000000
> [ 1080.660070]  f483d0c0 00000082 c146529c f9c345db 00000400 c1420d20 c14=
20d20 c141c2ac
> [ 1080.660078]  f483d27c c3c08d20 00000000 c104dd2e 00000092 000a032a c10=
37091 c1464e9c
> [ 1080.660085]  c3c042ac f483d27c 000173ac c1464ea0 00000004 00000000 000=
00000 00000000
> [ 1080.660092] Call Trace:
> [ 1080.660113]  [<c104dd2e>] ? up+0x9/0x2a
> [ 1080.660119]  [<c1037091>] ? release_console_sem+0x174/0x1a2
> [ 1080.660130]  [<f9cd65a8>] ? videobuf_waiton+0x11d/0x134 [videobuf_core=
]
> [ 1080.660135]  [<c104a882>] ? autoremove_wake_function+0x0/0x2d
> [ 1080.660143]  [<f80f51a5>] ? saa7134_dma_free+0x2f/0x4a [saa7134]
> [ 1080.660150]  [<f9cd6c2c>] ? videobuf_queue_cancel+0x97/0xb3 [videobuf_=
core]
> [ 1080.660156]  [<f9cd6c68>] ? videobuf_streamoff+0x20/0x2c [videobuf_cor=
e]
> [ 1080.660163]  [<f80f91d6>] ? saa7134_streamoff+0x28/0x4a [saa7134]
> [ 1080.660170]  [<f9c31e9c>] ? __video_do_ioctl+0x10c9/0x29f6 [videodev]
> [ 1080.660176]  [<c100cf0d>] ? sched_clock+0x5/0x7
> [ 1080.660180]  [<c104e76f>] ? sched_clock_local+0x15/0x11b
> [ 1080.660187]  [<f9c33a52>] ? video_ioctl2+0x289/0x327 [videodev]
> [ 1080.660192]  [<c102706f>] ? __wake_up_common+0x34/0x59
> [ 1080.660197]  [<c102b157>] ? __wake_up+0x29/0x39
> [ 1080.660202]  [<c1198575>] ? tty_wakeup+0x43/0x47
> [ 1080.660206]  [<c119e27c>] ? pty_write+0x39/0x3f
> [ 1080.660210]  [<c104aa2c>] ? remove_wait_queue+0xb/0x2f
> [ 1080.660219]  [<f9c337c9>] ? video_ioctl2+0x0/0x327 [videodev]
> [ 1080.660225]  [<f9c3010f>] ? v4l2_ioctl+0x31/0x34 [videodev]
> [ 1080.660231]  [<c10c4d21>] ? vfs_ioctl+0x49/0x5f
> [ 1080.660235]  [<c10c5288>] ? do_vfs_ioctl+0x4aa/0x4e5
> [ 1080.660240]  [<c10ba296>] ? fsnotify_modify+0x5a/0x61
> [ 1080.660244]  [<c119827d>] ? tty_write+0x0/0x1c0
> [ 1080.660248]  [<c10bae96>] ? vfs_write+0x9e/0xd6
> [ 1080.660252]  [<c10c5304>] ? sys_ioctl+0x41/0x58
> [ 1080.660257]  [<c1007f5b>] ? sysenter_do_call+0x12/0x28
>=20
> ** Model information
> not available
>=20
> ** Loaded modules:
> Module                  Size  Used by
> saa7134               120224  1=20
> acpi_cpufreq            4943  0=20
> cpufreq_stats           1940  0=20
> cpufreq_powersave        602  0=20
> cpufreq_conservative     4018  0=20
> cpufreq_userspace       1476  0=20
> battery                 3782  0=20
> sco                     5837  2=20
> bnep                    7444  2=20
> rfcomm                 25131  4=20
> l2cap                  21677  4 bnep,rfcomm
> crc16                   1027  1 l2cap
> bluetooth              36327  6 sco,bnep,rfcomm,l2cap
> rfkill                 10260  3 bluetooth
> xt_TCPMSS               2303  1=20
> xt_tcpmss               1017  1=20
> ppp_deflate             2790  1=20
> zlib_deflate           15822  1 ppp_deflate
> bsd_comp                4120  0=20
> vboxnetadp              5154  0=20
> vboxnetflt             10202  0=20
> vboxdrv               115189  2 vboxnetadp,vboxnetflt
> binfmt_misc             4907  1=20
> ppp_async               5305  1=20
> crc_ccitt               1039  1 ppp_async
> ppp_generic            16359  7 ppp_deflate,bsd_comp,ppp_async
> slhc                    3691  1 ppp_generic
> bridge                 32983  0=20
> stp                      996  1 bridge
> xt_tcpudp               1743  29=20
> iptable_mangle          2325  1=20
> xt_DSCP                 1451  0=20
> ipt_LOG                 3570  23=20
> ipt_REJECT              1517  0=20
> iptable_filter          1790  1=20
> xt_multiport            1775  0=20
> xt_state                 927  10=20
> xt_limit                1088  23=20
> xt_conntrack            1955  0=20
> nf_conntrack_ftp        4272  0=20
> nf_conntrack_ipv4       7597  10=20
> nf_conntrack           38071  4 xt_state,xt_conntrack,nf_conntrack_ftp,nf=
_conntrack_ipv4
> nf_defrag_ipv4           779  1 nf_conntrack_ipv4
> ip_tables               7690  2 iptable_mangle,iptable_filter
> x_tables                8327  11 xt_TCPMSS,xt_tcpmss,xt_tcpudp,xt_DSCP,ip=
t_LOG,ipt_REJECT,xt_multiport,xt_state,xt_limit,xt_conntrack,ip_tables
> xfs                   415348  1=20
> exportfs                2618  1 xfs
> v4loop                  9922  0=20
> coretemp                3277  0=20
> eeprom                  2609  0=20
> i2c_nforce2             4556  0=20
> tun                     8760  1=20
> fuse                   43750  1=20
> firewire_sbp2           9752  0=20
> firewire_core          31183  1 firewire_sbp2
> crc_itu_t               1035  1 firewire_core
> loop                    9753  0=20
> dm_crypt                9127  0=20
> snd_hda_codec_idt      35245  1=20
> snd_hda_intel          16511  4=20
> snd_hda_codec          46002  2 snd_hda_codec_idt,snd_hda_intel
> tda8290                 7865  0=20
> tuner                  14428  8=20
> snd_pcm_oss            28671  0=20
> snd_mixer_oss          10461  1 snd_pcm_oss
> snd_usb_audio          50558  0=20
> snd_usb_lib            10997  1 snd_usb_audio
> ir_common              22187  1 saa7134
> v4l2_common             9816  2 saa7134,tuner
> snd_pcm                47518  5 snd_hda_intel,snd_hda_codec,snd_pcm_oss,s=
nd_usb_audio
> snd_hwdep               4054  2 snd_hda_codec,snd_usb_audio
> videobuf_dma_sg         7259  1 saa7134
> gspca_zc3xx            36804  0=20
> snd_seq_midi            3576  0=20
> gspca_main             15787  1 gspca_zc3xx
> snd_rawmidi            12505  2 snd_usb_lib,snd_seq_midi
> snd_seq_midi_event      3684  1 snd_seq_midi
> videobuf_core          10476  2 saa7134,videobuf_dma_sg
> tveeprom                9393  1 saa7134
> snd_seq                35459  2 snd_seq_midi,snd_seq_midi_event
> snd_timer              12258  3 snd_pcm,snd_seq
> snd_seq_device          3673  3 snd_seq_midi,snd_rawmidi,snd_seq
> videodev               25541  6 saa7134,v4loop,tuner,v4l2_common,gspca_ma=
in
> snd                    34363  18 snd_hda_codec_idt,snd_hda_intel,snd_hda_=
codec,snd_pcm_oss,snd_mixer_oss,snd_usb_audio,snd_pcm,snd_hwdep,snd_rawmidi=
,snd_seq,snd_timer,snd_seq_device
> soundcore               3450  1 snd
> v4l1_compat            10250  1 videodev
> pcspkr                  1207  0=20
> shpchp                 21264  0=20
> nvidia               9821912  40=20
> snd_page_alloc          5109  2 snd_hda_intel,snd_pcm
> pci_hotplug            18065  1 shpchp
> evdev                   5609  11=20
> psmouse                44413  0=20
> serio_raw               2916  0=20
> i2c_i801                6446  0=20
> i2c_core               12648  10 saa7134,eeprom,i2c_nforce2,tda8290,tuner=
,v4l2_common,tveeprom,videodev,nvidia,i2c_i801
> processor              26579  1 acpi_cpufreq
> ext3                   94180  6=20
> jbd                    32161  1 ext3
> mbcache                 3762  1 ext3
> dm_mod                 46074  19 dm_crypt
> raid1                  16099  2=20
> md_mod                 67165  3 raid1
> sg                     15964  0=20
> sd_mod                 25781  8=20
> sr_mod                 10770  0=20
> crc_t10dif              1012  1 sd_mod
> cdrom                  26487  1 sr_mod
> usb_storage            29837  0=20
> ata_generic             2015  0=20
> r8169                  24976  0=20
> ide_pci_generic         1924  0=20
> uhci_hcd               16129  0=20
> ide_core               64218  1 ide_pci_generic
> ata_piix               16593  6=20
> mii                     2714  1 r8169
> ehci_hcd               27974  0=20
> e1000e                 98093  0=20
> pata_marvell            1697  0=20
> button                  3598  0=20
> libata                114716  3 ata_generic,ata_piix,pata_marvell
> scsi_mod              101301  6 firewire_sbp2,sg,sd_mod,sr_mod,usb_storag=
e,libata
> usbcore                98470  8 snd_usb_audio,snd_usb_lib,gspca_zc3xx,gsp=
ca_main,usb_storage,uhci_hcd,ehci_hcd
> nls_base                4541  1 usbcore
> intel_agp              20497  0=20
> agpgart                19576  2 nvidia,intel_agp
> thermal                 9206  0=20
> fan                     2586  0=20
> thermal_sys             9378  3 processor,thermal,fan
>=20
> ** PCI devices:
> 00:00.0 Host bridge [0600]: Intel Corporation 82P965/G965 Memory Controll=
er Hub [8086:29a0] (rev 02)
> 	Subsystem: Intel Corporation Device [8086:514d]
> 	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Step=
ping- SERR- FastB2B- DisINTx-
> 	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=3Dfast >TAbort- <TAbort=
- <MAbort+ >SERR- <PERR- INTx-
> 	Latency: 0
> 	Capabilities: <access denied>
>=20
> 00:01.0 PCI bridge [0604]: Intel Corporation 82P965/G965 PCI Express Root=
 Port [8086:29a1] (rev 02) (prog-if 00 [Normal decode])
> 	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Step=
ping- SERR- FastB2B- DisINTx+
> 	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbort=
- <MAbort- >SERR- <PERR- INTx-
> 	Latency: 0, Cache Line Size: 64 bytes
> 	Bus: primary=3D00, secondary=3D01, subordinate=3D01, sec-latency=3D0
> 	I/O behind bridge: 00003000-00003fff
> 	Memory behind bridge: e0000000-e2ffffff
> 	Prefetchable memory behind bridge: 00000000d0000000-00000000dfffffff
> 	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbort=
- <MAbort- <SERR- <PERR-
> 	BridgeCtl: Parity- SERR- NoISA- VGA+ MAbort- >Reset- FastB2B-
> 		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
> 	Capabilities: <access denied>
> 	Kernel driver in use: pcieport
>=20
> 00:03.0 Communication controller [0780]: Intel Corporation 82P965/G965 HE=
CI Controller [8086:29a4] (rev 02)
> 	Subsystem: Intel Corporation Device [8086:514d]
> 	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Step=
ping- SERR- FastB2B- DisINTx-
> 	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbort=
- <MAbort- >SERR- <PERR- INTx-
> 	Latency: 0
> 	Interrupt: pin A routed to IRQ 11
> 	Region 0: Memory at e3325900 (64-bit, non-prefetchable) [size=3D16]
> 	Capabilities: <access denied>
>=20
> 00:19.0 Ethernet controller [0200]: Intel Corporation 82566DC Gigabit Net=
work Connection [8086:104b] (rev 02)
> 	Subsystem: Intel Corporation Device [8086:0001]
> 	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Step=
ping- SERR- FastB2B- DisINTx+
> 	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbort=
- <MAbort- >SERR- <PERR- INTx-
> 	Latency: 0
> 	Interrupt: pin A routed to IRQ 30
> 	Region 0: Memory at e3300000 (32-bit, non-prefetchable) [size=3D128K]
> 	Region 1: Memory at e3324000 (32-bit, non-prefetchable) [size=3D4K]
> 	Region 2: I/O ports at 40c0 [size=3D32]
> 	Capabilities: <access denied>
> 	Kernel driver in use: e1000e
>=20
> 00:1a.0 USB Controller [0c03]: Intel Corporation 82801H (ICH8 Family) USB=
 UHCI Controller #4 [8086:2834] (rev 02) (prog-if 00 [UHCI])
> 	Subsystem: Intel Corporation Device [8086:514d]
> 	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Step=
ping- SERR- FastB2B- DisINTx-
> 	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort- <TAbo=
rt- <MAbort- >SERR- <PERR- INTx-
> 	Latency: 0
> 	Interrupt: pin A routed to IRQ 16
> 	Region 4: I/O ports at 40a0 [size=3D32]
> 	Kernel driver in use: uhci_hcd
>=20
> 00:1a.1 USB Controller [0c03]: Intel Corporation 82801H (ICH8 Family) USB=
 UHCI Controller #5 [8086:2835] (rev 02) (prog-if 00 [UHCI])
> 	Subsystem: Intel Corporation Device [8086:514d]
> 	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Step=
ping- SERR- FastB2B- DisINTx-
> 	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort- <TAbo=
rt- <MAbort- >SERR- <PERR- INTx-
> 	Latency: 0
> 	Interrupt: pin B routed to IRQ 21
> 	Region 4: I/O ports at 4080 [size=3D32]
> 	Kernel driver in use: uhci_hcd
>=20
> 00:1a.7 USB Controller [0c03]: Intel Corporation 82801H (ICH8 Family) USB=
2 EHCI Controller #2 [8086:283a] (rev 02) (prog-if 20 [EHCI])
> 	Subsystem: Intel Corporation Device [8086:514d]
> 	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Step=
ping- SERR- FastB2B- DisINTx-
> 	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort- <TAbo=
rt- <MAbort- >SERR- <PERR- INTx-
> 	Latency: 0
> 	Interrupt: pin C routed to IRQ 18
> 	Region 0: Memory at e3325400 (32-bit, non-prefetchable) [size=3D1K]
> 	Capabilities: <access denied>
> 	Kernel driver in use: ehci_hcd
>=20
> 00:1b.0 Audio device [0403]: Intel Corporation 82801H (ICH8 Family) HD Au=
dio Controller [8086:284b] (rev 02)
> 	Subsystem: Intel Corporation Device [8086:2111]
> 	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Step=
ping- SERR- FastB2B- DisINTx-
> 	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbort=
- <MAbort- >SERR- <PERR- INTx-
> 	Latency: 0, Cache Line Size: 64 bytes
> 	Interrupt: pin A routed to IRQ 22
> 	Region 0: Memory at e3320000 (64-bit, non-prefetchable) [size=3D16K]
> 	Capabilities: <access denied>
> 	Kernel driver in use: HDA Intel
>=20
> 00:1c.0 PCI bridge [0604]: Intel Corporation 82801H (ICH8 Family) PCI Exp=
ress Port 1 [8086:283f] (rev 02) (prog-if 00 [Normal decode])
> 	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Step=
ping- SERR- FastB2B- DisINTx+
> 	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbort=
- <MAbort- >SERR- <PERR- INTx-
> 	Latency: 0, Cache Line Size: 64 bytes
> 	Bus: primary=3D00, secondary=3D02, subordinate=3D02, sec-latency=3D0
> 	I/O behind bridge: 00005000-00005fff
> 	Memory behind bridge: e3400000-e35fffff
> 	Prefetchable memory behind bridge: 00000000e3600000-00000000e37fffff
> 	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbort=
- <MAbort- <SERR- <PERR-
> 	BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
> 		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
> 	Capabilities: <access denied>
> 	Kernel driver in use: pcieport
>=20
> 00:1c.1 PCI bridge [0604]: Intel Corporation 82801H (ICH8 Family) PCI Exp=
ress Port 2 [8086:2841] (rev 02) (prog-if 00 [Normal decode])
> 	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Step=
ping- SERR- FastB2B- DisINTx+
> 	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbort=
- <MAbort- >SERR- <PERR- INTx-
> 	Latency: 0, Cache Line Size: 64 bytes
> 	Bus: primary=3D00, secondary=3D03, subordinate=3D03, sec-latency=3D0
> 	I/O behind bridge: 00002000-00002fff
> 	Memory behind bridge: e3200000-e32fffff
> 	Prefetchable memory behind bridge: 00000000e3800000-00000000e39fffff
> 	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbort=
- <MAbort- <SERR- <PERR-
> 	BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
> 		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
> 	Capabilities: <access denied>
> 	Kernel driver in use: pcieport
>=20
> 00:1c.2 PCI bridge [0604]: Intel Corporation 82801H (ICH8 Family) PCI Exp=
ress Port 3 [8086:2843] (rev 02) (prog-if 00 [Normal decode])
> 	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Step=
ping- SERR- FastB2B- DisINTx+
> 	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbort=
- <MAbort- >SERR- <PERR- INTx-
> 	Latency: 0, Cache Line Size: 64 bytes
> 	Bus: primary=3D00, secondary=3D04, subordinate=3D05, sec-latency=3D0
> 	I/O behind bridge: 00006000-00006fff
> 	Memory behind bridge: e3100000-e31fffff
> 	Prefetchable memory behind bridge: 00000000e3a00000-00000000e3bfffff
> 	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbort=
- <MAbort- <SERR- <PERR-
> 	BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
> 		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
> 	Capabilities: <access denied>
> 	Kernel driver in use: pcieport
>=20
> 00:1c.3 PCI bridge [0604]: Intel Corporation 82801H (ICH8 Family) PCI Exp=
ress Port 4 [8086:2845] (rev 02) (prog-if 00 [Normal decode])
> 	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Step=
ping- SERR- FastB2B- DisINTx+
> 	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbort=
- <MAbort- >SERR- <PERR- INTx-
> 	Latency: 0, Cache Line Size: 64 bytes
> 	Bus: primary=3D00, secondary=3D06, subordinate=3D06, sec-latency=3D0
> 	I/O behind bridge: 00007000-00007fff
> 	Memory behind bridge: e3c00000-e3dfffff
> 	Prefetchable memory behind bridge: 00000000e3e00000-00000000e3ffffff
> 	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbort=
- <MAbort- <SERR- <PERR-
> 	BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
> 		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
> 	Capabilities: <access denied>
> 	Kernel driver in use: pcieport
>=20
> 00:1c.4 PCI bridge [0604]: Intel Corporation 82801H (ICH8 Family) PCI Exp=
ress Port 5 [8086:2847] (rev 02) (prog-if 00 [Normal decode])
> 	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Step=
ping- SERR- FastB2B- DisINTx+
> 	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbort=
- <MAbort- >SERR- <PERR- INTx-
> 	Latency: 0, Cache Line Size: 64 bytes
> 	Bus: primary=3D00, secondary=3D07, subordinate=3D07, sec-latency=3D0
> 	I/O behind bridge: 00008000-00008fff
> 	Memory behind bridge: e4000000-e41fffff
> 	Prefetchable memory behind bridge: 00000000e4200000-00000000e43fffff
> 	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbort=
- <MAbort- <SERR- <PERR-
> 	BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
> 		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
> 	Capabilities: <access denied>
> 	Kernel driver in use: pcieport
>=20
> 00:1d.0 USB Controller [0c03]: Intel Corporation 82801H (ICH8 Family) USB=
 UHCI Controller #1 [8086:2830] (rev 02) (prog-if 00 [UHCI])
> 	Subsystem: Intel Corporation Device [8086:514d]
> 	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Step=
ping- SERR- FastB2B- DisINTx-
> 	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort- <TAbo=
rt- <MAbort- >SERR- <PERR- INTx-
> 	Latency: 0
> 	Interrupt: pin A routed to IRQ 23
> 	Region 4: I/O ports at 4060 [size=3D32]
> 	Kernel driver in use: uhci_hcd
>=20
> 00:1d.1 USB Controller [0c03]: Intel Corporation 82801H (ICH8 Family) USB=
 UHCI Controller #2 [8086:2831] (rev 02) (prog-if 00 [UHCI])
> 	Subsystem: Intel Corporation Device [8086:514d]
> 	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Step=
ping- SERR- FastB2B- DisINTx-
> 	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort- <TAbo=
rt- <MAbort- >SERR- <PERR- INTx-
> 	Latency: 0
> 	Interrupt: pin B routed to IRQ 19
> 	Region 4: I/O ports at 4040 [size=3D32]
> 	Kernel driver in use: uhci_hcd
>=20
> 00:1d.2 USB Controller [0c03]: Intel Corporation 82801H (ICH8 Family) USB=
 UHCI Controller #3 [8086:2832] (rev 02) (prog-if 00 [UHCI])
> 	Subsystem: Intel Corporation Device [8086:514d]
> 	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Step=
ping- SERR- FastB2B- DisINTx-
> 	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort- <TAbo=
rt- <MAbort- >SERR- <PERR- INTx-
> 	Latency: 0
> 	Interrupt: pin C routed to IRQ 18
> 	Region 4: I/O ports at 4020 [size=3D32]
> 	Kernel driver in use: uhci_hcd
>=20
> 00:1d.7 USB Controller [0c03]: Intel Corporation 82801H (ICH8 Family) USB=
2 EHCI Controller #1 [8086:2836] (rev 02) (prog-if 20 [EHCI])
> 	Subsystem: Intel Corporation Device [8086:514d]
> 	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Step=
ping- SERR- FastB2B- DisINTx-
> 	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort- <TAbo=
rt- <MAbort- >SERR- <PERR- INTx-
> 	Latency: 0
> 	Interrupt: pin A routed to IRQ 23
> 	Region 0: Memory at e3325000 (32-bit, non-prefetchable) [size=3D1K]
> 	Capabilities: <access denied>
> 	Kernel driver in use: ehci_hcd
>=20
> 00:1e.0 PCI bridge [0604]: Intel Corporation 82801 PCI Bridge [8086:244e]=
 (rev f2) (prog-if 01 [Subtractive decode])
> 	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Step=
ping- SERR- FastB2B- DisINTx-
> 	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbort=
- <MAbort- >SERR- <PERR- INTx-
> 	Latency: 0
> 	Bus: primary=3D00, secondary=3D08, subordinate=3D08, sec-latency=3D32
> 	I/O behind bridge: 00001000-00001fff
> 	Memory behind bridge: e3000000-e30fffff
> 	Prefetchable memory behind bridge: 00000000e4400000-00000000e44fffff
> 	Secondary status: 66MHz- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort- <TAbo=
rt- <MAbort+ <SERR- <PERR-
> 	BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
> 		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
> 	Capabilities: <access denied>
>=20
> 00:1f.0 ISA bridge [0601]: Intel Corporation 82801HB/HR (ICH8/R) LPC Inte=
rface Controller [8086:2810] (rev 02)
> 	Subsystem: Intel Corporation Device [8086:514d]
> 	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Step=
ping- SERR- FastB2B- DisINTx-
> 	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dmedium >TAbort- <TAbo=
rt- <MAbort- >SERR- <PERR- INTx-
> 	Latency: 0
> 	Capabilities: <access denied>
>=20
> 00:1f.2 IDE interface [0101]: Intel Corporation 82801H (ICH8 Family) 4 po=
rt SATA IDE Controller [8086:2820] (rev 02) (prog-if 8a [Master SecP PriP])
> 	Subsystem: Intel Corporation Device [8086:514d]
> 	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Step=
ping- SERR- FastB2B- DisINTx-
> 	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort- <TAbo=
rt- <MAbort- >SERR- <PERR- INTx-
> 	Latency: 0
> 	Interrupt: pin A routed to IRQ 19
> 	Region 0: I/O ports at 01f0 [size=3D8]
> 	Region 1: I/O ports at 03f4 [size=3D1]
> 	Region 2: I/O ports at 0170 [size=3D8]
> 	Region 3: I/O ports at 0374 [size=3D1]
> 	Region 4: I/O ports at 4410 [size=3D16]
> 	Region 5: I/O ports at 4400 [size=3D16]
> 	Capabilities: <access denied>
> 	Kernel driver in use: ata_piix
>=20
> 00:1f.3 SMBus [0c05]: Intel Corporation 82801H (ICH8 Family) SMBus Contro=
ller [8086:283e] (rev 02)
> 	Subsystem: Intel Corporation Device [8086:514d]
> 	Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Step=
ping- SERR- FastB2B- DisINTx-
> 	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort- <TAbo=
rt- <MAbort- >SERR- <PERR- INTx-
> 	Interrupt: pin B routed to IRQ 21
> 	Region 0: Memory at e3325800 (32-bit, non-prefetchable) [size=3D256]
> 	Region 4: I/O ports at 4000 [size=3D32]
> 	Kernel driver in use: i801_smbus
>=20
> 00:1f.5 IDE interface [0101]: Intel Corporation 82801H (ICH8 Family) 2 po=
rt SATA IDE Controller [8086:2825] (rev 02) (prog-if 85 [Master SecO PriO])
> 	Subsystem: Intel Corporation Device [8086:514d]
> 	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Step=
ping- SERR- FastB2B- DisINTx-
> 	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort- <TAbo=
rt- <MAbort- >SERR- <PERR- INTx-
> 	Latency: 0
> 	Interrupt: pin A routed to IRQ 19
> 	Region 0: I/O ports at 4428 [size=3D8]
> 	Region 1: I/O ports at 4444 [size=3D4]
> 	Region 2: I/O ports at 4420 [size=3D8]
> 	Region 3: I/O ports at 4440 [size=3D4]
> 	Region 4: I/O ports at 40f0 [size=3D16]
> 	Region 5: I/O ports at 40e0 [size=3D16]
> 	Capabilities: <access denied>
> 	Kernel driver in use: ata_piix
>=20
> 01:00.0 VGA compatible controller [0300]: nVidia Corporation G84 [GeForce=
 8600 GTS] [10de:0400] (rev a1) (prog-if 00 [VGA controller])
> 	Subsystem: LeadTek Research Inc. Device [107d:2a86]
> 	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Step=
ping- SERR- FastB2B- DisINTx-
> 	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbort=
- <MAbort- >SERR- <PERR- INTx-
> 	Latency: 0
> 	Interrupt: pin A routed to IRQ 16
> 	Region 0: Memory at e2000000 (32-bit, non-prefetchable) [size=3D16M]
> 	Region 1: Memory at d0000000 (64-bit, prefetchable) [size=3D256M]
> 	Region 3: Memory at e0000000 (64-bit, non-prefetchable) [size=3D32M]
> 	Region 5: I/O ports at 3000 [size=3D128]
> 	Expansion ROM at <unassigned> [disabled]
> 	Capabilities: <access denied>
> 	Kernel driver in use: nvidia
>=20
> 03:00.0 IDE interface [0101]: Marvell Technology Group Ltd. 88SE6101 sing=
le-port PATA133 interface [11ab:6101] (rev b1) (prog-if 8f [Master SecP Sec=
O PriP PriO])
> 	Subsystem: Marvell Technology Group Ltd. 88SE6101 single-port PATA133 in=
terface [11ab:6101]
> 	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Step=
ping- SERR- FastB2B- DisINTx-
> 	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbort=
- <MAbort- >SERR- <PERR- INTx-
> 	Latency: 0, Cache Line Size: 64 bytes
> 	Interrupt: pin A routed to IRQ 17
> 	Region 0: I/O ports at 2018 [size=3D8]
> 	Region 1: I/O ports at 2024 [size=3D4]
> 	Region 2: I/O ports at 2010 [size=3D8]
> 	Region 3: I/O ports at 2020 [size=3D4]
> 	Region 4: I/O ports at 2000 [size=3D16]
> 	Region 5: Memory at e3200000 (32-bit, non-prefetchable) [size=3D512]
> 	Capabilities: <access denied>
> 	Kernel driver in use: pata_marvell
>=20
> 04:00.0 PCI bridge [0604]: PLX Technology, Inc. PEX 8111 PCI Express-to-P=
CI Bridge [10b5:8111] (rev 21) (prog-if 00 [Normal decode])
> 	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Step=
ping- SERR- FastB2B- DisINTx-
> 	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbort=
- <MAbort- >SERR- <PERR- INTx-
> 	Latency: 0, Cache Line Size: 64 bytes
> 	Bus: primary=3D04, secondary=3D05, subordinate=3D05, sec-latency=3D0
> 	Memory behind bridge: e3100000-e31fffff
> 	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=3Dmedium >TAbort- <TAbo=
rt- <MAbort+ <SERR- <PERR-
> 	BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
> 		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
> 	Capabilities: <access denied>
>=20
> 05:00.0 Multimedia controller [0480]: Philips Semiconductors SAA7130 Vide=
o Broadcast Decoder [1131:7130] (rev 01)
> 	Subsystem: Philips Semiconductors Device [1131:0000]
> 	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Step=
ping- SERR- FastB2B- DisINTx-
> 	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort- <TAbo=
rt- <MAbort- >SERR- <PERR- INTx-
> 	Latency: 64 (3750ns min, 9500ns max)
> 	Interrupt: pin A routed to IRQ 18
> 	Region 0: Memory at e3101c00 (32-bit, non-prefetchable) [size=3D1K]
> 	Capabilities: <access denied>
> 	Kernel driver in use: saa7134
>=20
> 05:02.0 Multimedia controller [0480]: Philips Semiconductors SAA7130 Vide=
o Broadcast Decoder [1131:7130] (rev 01)
> 	Subsystem: Philips Semiconductors Device [1131:0000]
> 	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Step=
ping- SERR- FastB2B- DisINTx-
> 	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort- <TAbo=
rt- <MAbort- >SERR- <PERR- INTx-
> 	Latency: 64 (3750ns min, 9500ns max)
> 	Interrupt: pin A routed to IRQ 16
> 	Region 0: Memory at e3101800 (32-bit, non-prefetchable) [size=3D1K]
> 	Capabilities: <access denied>
> 	Kernel driver in use: saa7134
>=20
> 05:04.0 Multimedia controller [0480]: Philips Semiconductors SAA7130 Vide=
o Broadcast Decoder [1131:7130] (rev 01)
> 	Subsystem: Philips Semiconductors Device [1131:0000]
> 	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Step=
ping- SERR- FastB2B- DisINTx-
> 	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort- <TAbo=
rt- <MAbort- >SERR- <PERR- INTx-
> 	Latency: 64 (3750ns min, 9500ns max)
> 	Interrupt: pin A routed to IRQ 18
> 	Region 0: Memory at e3101400 (32-bit, non-prefetchable) [size=3D1K]
> 	Capabilities: <access denied>
> 	Kernel driver in use: saa7134
>=20
> 05:06.0 Multimedia controller [0480]: Philips Semiconductors SAA7130 Vide=
o Broadcast Decoder [1131:7130] (rev 01)
> 	Subsystem: Philips Semiconductors Device [1131:0000]
> 	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Step=
ping- SERR- FastB2B- DisINTx-
> 	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort- <TAbo=
rt- <MAbort- >SERR- <PERR- INTx-
> 	Latency: 64 (3750ns min, 9500ns max)
> 	Interrupt: pin A routed to IRQ 16
> 	Region 0: Memory at e3101000 (32-bit, non-prefetchable) [size=3D1K]
> 	Capabilities: <access denied>
> 	Kernel driver in use: saa7134
>=20
> 05:08.0 Multimedia controller [0480]: Philips Semiconductors SAA7130 Vide=
o Broadcast Decoder [1131:7130] (rev 01)
> 	Subsystem: Philips Semiconductors Device [1131:0000]
> 	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Step=
ping- SERR- FastB2B- DisINTx-
> 	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort- <TAbo=
rt- <MAbort- >SERR- <PERR- INTx-
> 	Latency: 64 (3750ns min, 9500ns max)
> 	Interrupt: pin A routed to IRQ 18
> 	Region 0: Memory at e3100c00 (32-bit, non-prefetchable) [size=3D1K]
> 	Capabilities: <access denied>
> 	Kernel driver in use: saa7134
>=20
> 05:0a.0 Multimedia controller [0480]: Philips Semiconductors SAA7130 Vide=
o Broadcast Decoder [1131:7130] (rev 01)
> 	Subsystem: Philips Semiconductors Device [1131:0000]
> 	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Step=
ping- SERR- FastB2B- DisINTx-
> 	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort- <TAbo=
rt- <MAbort- >SERR- <PERR- INTx-
> 	Latency: 64 (3750ns min, 9500ns max)
> 	Interrupt: pin A routed to IRQ 16
> 	Region 0: Memory at e3100800 (32-bit, non-prefetchable) [size=3D1K]
> 	Capabilities: <access denied>
> 	Kernel driver in use: saa7134
>=20
> 05:0c.0 Multimedia controller [0480]: Philips Semiconductors SAA7130 Vide=
o Broadcast Decoder [1131:7130] (rev 01)
> 	Subsystem: Philips Semiconductors Device [1131:0000]
> 	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Step=
ping- SERR- FastB2B- DisINTx-
> 	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort- <TAbo=
rt- <MAbort- >SERR- <PERR- INTx-
> 	Latency: 64 (3750ns min, 9500ns max)
> 	Interrupt: pin A routed to IRQ 18
> 	Region 0: Memory at e3100400 (32-bit, non-prefetchable) [size=3D1K]
> 	Capabilities: <access denied>
> 	Kernel driver in use: saa7134
>=20
> 05:0e.0 Multimedia controller [0480]: Philips Semiconductors SAA7130 Vide=
o Broadcast Decoder [1131:7130] (rev 01)
> 	Subsystem: Philips Semiconductors Device [1131:0000]
> 	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Step=
ping- SERR- FastB2B- DisINTx-
> 	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort- <TAbo=
rt- <MAbort- >SERR- <PERR- INTx-
> 	Latency: 64 (3750ns min, 9500ns max)
> 	Interrupt: pin A routed to IRQ 16
> 	Region 0: Memory at e3100000 (32-bit, non-prefetchable) [size=3D1K]
> 	Capabilities: <access denied>
> 	Kernel driver in use: saa7134
>=20
> 08:02.0 Ethernet controller [0200]: D-Link System Inc DGE-528T Gigabit Et=
hernet Adapter [1186:4300] (rev 10)
> 	Subsystem: D-Link System Inc DGE-528T Gigabit Ethernet Adapter [1186:430=
0]
> 	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Step=
ping- SERR- FastB2B- DisINTx-
> 	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort- <TAbo=
rt- <MAbort- >SERR- <PERR- INTx-
> 	Latency: 64 (8000ns min, 16000ns max), Cache Line Size: 32 bytes
> 	Interrupt: pin A routed to IRQ 18
> 	Region 0: I/O ports at 1000 [size=3D256]
> 	Region 1: Memory at e3000000 (32-bit, non-prefetchable) [size=3D256]
> 	Expansion ROM at e4400000 [disabled] [size=3D128K]
> 	Capabilities: <access denied>
> 	Kernel driver in use: r8169
>=20
>=20
> ** USB devices:
> Bus 005 Device 002: ID 046d:08d7 Logitech, Inc. QuickCam Communicate STX
> Bus 005 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
> Bus 002 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
> Bus 001 Device 002: ID 0bda:0111 Realtek Semiconductor Corp. Card Reader
> Bus 001 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
> Bus 004 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
> Bus 003 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
> Bus 007 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
> Bus 006 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
>=20
>=20
> -- System Information:
> Debian Release: squeeze/sid
>   APT prefers testing
>   APT policy: (990, 'testing')
> Architecture: i386 (i686)
>=20
> Kernel: Linux 2.6.32-3-686-bigmem (SMP w/4 CPU cores)
> Locale: LANG=3Dru_RU.UTF-8, LC_CTYPE=3Dru_RU.UTF-8 (charmap=3DUTF-8)
> Shell: /bin/sh linked to /bin/dash
>=20
> Versions of packages linux-image-2.6.32-3-686-bigmem depends on:
> ii  debconf [debconf-2.0]        1.5.32      Debian configuration managem=
ent sy
> ii  initramfs-tools [linux-initr 0.94.4      tools for generating an init=
ramfs
> ii  module-init-tools            3.12~pre2-3 tools for managing Linux ker=
nel mo
>=20
> Versions of packages linux-image-2.6.32-3-686-bigmem recommends:
> pn  firmware-linux-free           <none>     (no description available)
> ii  libc6-i686                    2.10.2-9   GNU C Library: Shared librar=
ies [i
>=20
> Versions of packages linux-image-2.6.32-3-686-bigmem suggests:
> ii  grub                          0.97-61    GRand Unified Bootloader (du=
mmy pa
> pn  linux-doc-2.6.32              <none>     (no description available)
>=20
> Versions of packages linux-image-2.6.32-3-686-bigmem is related to:
> pn  firmware-bnx2                 <none>     (no description available)
> pn  firmware-bnx2x                <none>     (no description available)
> pn  firmware-ipw2x00              <none>     (no description available)
> pn  firmware-ivtv                 <none>     (no description available)
> pn  firmware-iwlwifi              <none>     (no description available)
> pn  firmware-linux                <none>     (no description available)
> pn  firmware-linux-nonfree        <none>     (no description available)
> pn  firmware-qlogic               <none>     (no description available)
> pn  firmware-ralink               <none>     (no description available)
>=20
>=20
>=20

--=20
Ben Hutchings
Once a job is fouled up, anything done to improve it makes it worse.

--=-A/2KmNCBRsbnK376qAlb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIVAwUATAb0Xue/yOyVhhEJAQKqBhAAzQWNZFMYR6/oLU7xYXYgGUVFDyKBgO5q
rw/bXC345am/6LQhYsfzjG98CbSf5EDrB5mmNAUg8q0CzHo5CUz2ufA39uYL03hv
XsUJc0JwI6szbrbW5Cy4OqigXyGIYOfVP2J2pL4SBR0g7OPTcyuoLyLdRZBO1yRp
tXxsJsRcqvGdpgjNO+o2RW/3Si6hUnT162UgYOqR6ZAKIL3J+bxf9SOVACcVDe/h
wTyteHdHVVi4KpueFgNRe5ecBfW39aKTZHJnCEEBinuq4c2UP4hbNW6DjulVckm3
nN9ELBbRhQ/Zcb3eC4RQJtE7obOILdWXt07f6DfjHjt8AT1NRF1ysD1qpReHVUTX
El44JI15oGVdegB3R0eEqRVXBfvojqNGkrXCy4xnPghpS537bIIf0eI/n+RlbVb+
piQEhPczOZM1I9QOrARDeQYkzcW8iwKajvboO3ATIASQtuzU2NowYTJAUPUyDeBS
DUGrDQ69Lg0/B70oQK6Oi0SIFJj5alt20NnWKKiU8guY2gTguhnzAZx3FbCyiRiN
PpgcZdpP5ZrB4Tm4XVm9ZCxba9IWEsrE4rRFSq3AN5diNHgSjkG8xJaLgxX6zS4b
FskyC+qCehx7bSrKT7opyV+u+/6i0DGx6rQHMuu58iM/C60PYPAY0qkx+4b/520G
s0QUspjhjak=
=3IUT
-----END PGP SIGNATURE-----

--=-A/2KmNCBRsbnK376qAlb--
