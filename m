Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-out113.alice.it ([85.37.17.113]:2109 "EHLO
	smtp-out113.alice.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753728AbZHDADK (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 3 Aug 2009 20:03:10 -0400
Date: Tue, 4 Aug 2009 02:02:52 +0200
From: Antonio Ospite <ospite@studenti.unina.it>
To: linux-media@vger.kernel.org
Cc: Guennadi Liakhovetski <kernel@pengutronix.de>
Subject: [BUG] pxa_camera: possible recursive locking detected
Message-Id: <20090804020252.f33f481d.ospite@studenti.unina.it>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__4_Aug_2009_02_02_53_+0200_gA9Gqs0vm5skKvey"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--Signature=_Tue__4_Aug_2009_02_02_53_+0200_gA9Gqs0vm5skKvey
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

verified to be present in linux-2.6.31-rc5, here's some info dumped
from RAM, since the machine hangs, sorry if it is not complete but I
couldn't get anything better for now, nothing is printed on
the screen.

The userspace app is capture-example from v4l2-apps/test
and the command which should be triggering the bug is:
   xioctl(fd, VIDIOC_STREAMON, &type)

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
[ INFO: possible recursive locking detected ]
2.6.31-rc5-ezxdev #53
---------------------------------------------
capture-example/967 is trying to acquire lock:
  (&pcdev->lock {......}, at: [<c019e97c>] pxa_videobuf_queue+0x28/0xc4
but task is already holding lock:
  (&pcdev->lock {......}                     buf_streamon+0x40/0xc0
other info that might help us debug this:
held by capture-example/967:
#0:   o_lock
  soc_camera_streamon+0x40/0x70
#1:     lock
  videobuf_streamon+0x14/0xc0
#2:=20
     eobuf_streamon+0x40/0xc0

The stack backtrace I managed to get is even worse, something like:

-----------------------------------
stack backtrace: [<c002db8c>] 0x0/0xe0)=20
idate_chain+0x5b0/0xd84)
89.995951] [<c0064ac8>]=20
e_chain+0x5b0/0xd84)=20
5a60>]=20
from [<c00668e8>]=20
0x5c/0x70)
00668e8>]=20
_irqsave+0x4c/0x60)
6230] [<c023cea4>]=20
rqsave+0x4c/0x60)=20
c>]=20
eamon+0x70/0xc0)
3] [<c0199b4c>]=20
on+0x70/0xc0)=20
(soc_camera_streamon+0x58/0x70)
[   89.996488] [<c019ccc4>]=20
soc_camera_streamon+0x58/0x70)=20
rom [<c0191320>]=20
tl+0x14e0/0x3404)
-------------------------------------

With another build with debug enabled I extracted this sequence:
[  104.385424] camera 0-0: PXA Camera driver attached to camera 0
[  104.385513] pxa27x-camera pxa27x-camera.0: Registered platform device at=
 cc923d60 data c0316fe0
[  104.385554] pxa27x-camera pxa27x-camera.0: pxa_camera_activate: Init gpi=
os
[  104.447596] camera 0-0: set width: 640 height: 480
[  104.447642] camera 0-0: camera device open
[  104.502178] camera 0-0: set width: 640 height: 480
[  104.502663] camera 0-0: soc_camera_reqbufs: 1
[  104.502725] camera 0-0: count=3D4, size=3D0
[  104.508618] camera 0-0: mmap called, vma=3D0xcc07fc28
[  104.508926] camera 0-0: vma start=3D0x40144000, size=3D614400, ret=3D0
[  104.542879] camera 0-0: mmap called, vma=3D0xcc05b1d8
[  104.542990] camera 0-0: vma start=3D0x401da000, size=3D614400, ret=3D0
[  104.546148] camera 0-0: mmap called, vma=3D0xcc05b6a8
[  104.546243] camera 0-0: vma start=3D0x40270000, size=3D614400, ret=3D0
[  104.549401] camera 0-0: mmap called, vma=3D0xcc05b4f0
[  104.549509] camera 0-0: vma start=3D0x40306000, size=3D614400, ret=3D0
[  104.550380] camera 0-0: pxa_videobuf_prepare (vb=3D0xcc91e760) 0x4014400=
0 614400
[  104.714301] pxa27x-camera pxa27x-camera.0: DMA: sg_first=3Dcd83e000, sgl=
en=3D150, ofs=3D0, dma.desc=3Dacb94000
[  104.715766] camera 0-0: pxa_videobuf_prepare (vb=3D0xcc91e560) 0x401da00=
0 614400
[  104.782840] pxa27x-camera pxa27x-camera.0: DMA: sg_first=3Dcd852000, sgl=
en=3D150, ofs=3D0, dma.desc=3Dacde7000
[  104.783988] camera 0-0: pxa_videobuf_prepare (vb=3D0xcc91e660) 0x4027000=
0 614400
[  104.841132] pxa27x-camera pxa27x-camera.0: DMA: sg_first=3Dcd855000, sgl=
en=3D150, ofs=3D0, dma.desc=3Dac090000
[  104.863313] camera 0-0: pxa_videobuf_prepare (vb=3D0xcc91e860) 0x4030600=
0 614400
[  104.960047] pxa27x-camera pxa27x-camera.0: DMA: sg_first=3Dcd858000, sgl=
en=3D150, ofs=3D0, dma.desc=3Dacdd2000
[  104.960922] camera 0-0: soc_camera_streamon
[  104.961840] camera 0-0: pxa_videobuf_queue (vb=3D0xcc91e760) 0x40144000 =
614400 active=3D(null)

maybe some more pxa_videobuf_queue lines are missing,
but again I was not able to extract them from RAM.

Thanks,
   Antonio

--=20
Antonio Ospite
http://ao2.it

PGP public key ID: 0x4553B001

A: Because it messes up the order in which people normally read text.
   See http://en.wikipedia.org/wiki/Posting_style
Q: Why is top-posting such a bad thing?
A: Top-posting.
Q: What is the most annoying thing in e-mail?

--Signature=_Tue__4_Aug_2009_02_02_53_+0200_gA9Gqs0vm5skKvey
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkp3eq0ACgkQ5xr2akVTsAFoVACfVLygqrsnupS4wEMJQStkRSkk
GrYAn0Pb1t2BRddNRjkMutTy1EVEVUap
=eL7C
-----END PGP SIGNATURE-----

--Signature=_Tue__4_Aug_2009_02_02_53_+0200_gA9Gqs0vm5skKvey--
