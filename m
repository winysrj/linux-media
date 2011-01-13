Return-path: <mchehab@pedra>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:59908 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756310Ab1AMIqj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 13 Jan 2011 03:46:39 -0500
Received: from eu_spt1 (mailout2.w1.samsung.com [210.118.77.12])
 by mailout2.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0LEY001BHDPLKH@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 13 Jan 2011 08:46:34 +0000 (GMT)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LEY009UEDPKYJ@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 13 Jan 2011 08:46:33 +0000 (GMT)
Date: Thu, 13 Jan 2011 09:46:27 +0100
From: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
Subject: RE: [GIT PATCHES FOR 2.6.38] Videbuf2 framework,
 NOON010PC30 sensor driver and s5p-fimc updates
In-reply-to: <4D2E0DD8.4010305@redhat.com>
To: 'Mauro Carvalho Chehab' <mchehab@redhat.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>, pawel@osciak.com,
	linux-media@vger.kernel.org,
	Andrzej Pietrasiewicz <andrzej.p@samsung.com>
Message-id: <000001cbb2fe$5d8f2290$18ad67b0$%p@samsung.com>
MIME-version: 1.0
Content-type: multipart/mixed; boundary="Boundary_(ID_t6XsxDe4qlSkNGrd2Wctmw)"
Content-language: pl
References: <4D21FDC1.7000803@samsung.com> <4D2CBB3F.5050904@redhat.com>
 <000001cbb243$1051cb60$30f56220$%szyprowski@samsung.com>
 <4D2E0DD8.4010305@redhat.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

This is a multi-part message in MIME format.

--Boundary_(ID_t6XsxDe4qlSkNGrd2Wctmw)
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7BIT

Hello Mauro,

On Wednesday, January 12, 2011 9:24 PM Mauro Carvalho Chehab wrote:
> 
> Em 12-01-2011 08:25, Marek Szyprowski escreveu:
> > Hello Mauro,
> >
> > I've rebased our fimc and saa patches onto
> http://linuxtv.org/git/mchehab/experimental.git
> > vb2_test branch.
> >
> > The last 2 patches are for SAA7134 driver and are only to show that
> videobuf2-dma-sg works
> > correctly.
> 
> On my first test with saa7134, it hanged. It seems that the code
> reached a dead lock.
> 
> On my test environment, I'm using a remote machine, without monitor. My
> test is using
> qv4l2 via a remote X server. Using a remote X server is an interesting
> test, as it will
> likely loose some frames, increasing the probability of races and dead
> locks.
> 

We did a similar test using a remote machine and qv4l2 with X forwarding.
Both userptr and mmap worked. Read does not work because it is not
implemented, but there was no freeze anyway, just green screen in qv4l2.
However, we set "Capture Image Formats" to "YUV - 4:2:2 packed, YUV", "TV
Standard" to "PAL". I enclose a (lengthy) log for reference - it is a log of
a short session when modules where loaded, qv4l2 started, userptr mode run
for a while and then mmap mode run for a while.

We did it on a 32-bit system. We are going to repeat the test on a 64-bit
system, it just takes some time to set it up. Perhaps this is the
difference.

Thank you for testing, we will let you know as soon as we learn more,

Andrzej

--Boundary_(ID_t6XsxDe4qlSkNGrd2Wctmw)
Content-type: application/octet-stream; name=saa7134.log
Content-transfer-encoding: quoted-printable
Content-disposition: attachment; filename=saa7134.log

Linux video capture interface: v2.00=0A=
saa7130/34: v4l2 driver version 0.2.16 loaded=0A=
saa7130/34: w/o radio and vbi=0A=
saa7133[0]: found at 0000:05:00.0, rev: 209, irq: 20, latency: 32, mmio: =
0xf8100000=0A=
saa7133[0]: subsystem: 1461:f11d, board: Avermedia PCI pure analog =
(M135A) [card=3D149,autodetected]=0A=
saa7133[0]: board init: gpio is 40000=0A=
hwinit1=0A=
saa7133[0]: i2c eeprom 00: 61 14 1d f1 54 20 1c 00 43 43 a9 1c 55 d2 b2 =
92=0A=
saa7133[0]: i2c eeprom 10: ff ff ff ff ff 20 ff ff ff ff ff ff ff ff ff =
ff=0A=
saa7133[0]: i2c eeprom 20: 01 40 01 32 32 01 01 43 88 ff 00 56 ff ff ff =
ff=0A=
saa7133[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff =
ff=0A=
saa7133[0]: i2c eeprom 40: ff 22 00 c0 96 ff 03 30 15 00 ff ff ff ff ff =
ff=0A=
saa7133[0]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff =
ff=0A=
saa7133[0]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff =
ff=0A=
saa7133[0]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff =
ff=0A=
saa7133[0]: i2c eeprom 80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff =
ff=0A=
saa7133[0]: i2c eeprom 90: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff =
ff=0A=
saa7133[0]: i2c eeprom a0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff =
ff=0A=
saa7133[0]: i2c eeprom b0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff =
ff=0A=
saa7133[0]: i2c eeprom c0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff =
ff=0A=
saa7133[0]: i2c eeprom d0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff =
ff=0A=
saa7133[0]: i2c eeprom e0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff =
ff=0A=
saa7133[0]: i2c eeprom f0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff =
ff=0A=
tuner 0-004b: chip found @ 0x96 (saa7133[0])=0A=
tda829x 0-004b: setting tuner address to 60=0A=
tda829x 0-004b: type set to tda8290+75a=0A=
hwinit2=0A=
DCSDT: pll: not locked, sync: no, norm: (no signal)=0A=
saa7133[0]: registered device video0 [v4l2]=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_QUERYCAP driver=3Dsaa7134, =
card=3DAvermedia PCI pure analog (M135, bus=3DPCI:0000:05:00.0, =
version=3D0x00000210, capabilities=3D0x05010015=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_QUERYCAP driver=3Dsaa7134, =
card=3DAvermedia PCI pure analog (M135, bus=3DPCI:0000:05:00.0, =
version=3D0x00000210, capabilities=3D0x05010015=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_QUERYCAP driver=3Dsaa7134, =
card=3DAvermedia PCI pure analog (M135, bus=3DPCI:0000:05:00.0, =
version=3D0x00000210, capabilities=3D0x05010015=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_QUERYCAP driver=3Dsaa7134, =
card=3DAvermedia PCI pure analog (M135, bus=3DPCI:0000:05:00.0, =
version=3D0x00000210, capabilities=3D0x05010015=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_G_TUNER index=3D0, =
name=3DTelevision, type=3D2, capability=3D0x72, rangelow=3D0, =
rangehigh=3D-1, signal=3D0, afc=3D0, rxsubchans=3D0x0, audmode=3D0=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_ENUMINPUT index=3D0, =
name=3DTelevision, type=3D1, audioset=3D1, tuner=3D0, std=3D00ffbfff, =
status=3D65792=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_ENUMINPUT index=3D1, =
name=3DComposite1, type=3D2, audioset=3D1, tuner=3D0, std=3D00ffbfff, =
status=3D0=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_ENUMINPUT index=3D2, =
name=3DS-Video, type=3D2, audioset=3D1, tuner=3D0, std=3D00ffbfff, =
status=3D0=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_ENUMINPUT error -22=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_G_INPUT value=3D0=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_ENUMOUTPUT error -22=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_ENUMAUDIO error -22=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_ENUMAUDOUT error -22=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_ENUMSTD index=3D0, id=3D0xb000, =
name=3DNTSC, fps=3D1001/30000, framelines=3D525=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_ENUMSTD index=3D1, id=3D0x1000, =
name=3DNTSC-M, fps=3D1001/30000, framelines=3D525=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_ENUMSTD index=3D2, id=3D0x2000, =
name=3DNTSC-M-JP, fps=3D1001/30000, framelines=3D525=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_ENUMSTD index=3D3, id=3D0x8000, =
name=3DNTSC-M-KR, fps=3D1001/30000, framelines=3D525=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_ENUMSTD index=3D4, id=3D0xff, =
name=3DPAL, fps=3D1/25, framelines=3D625=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_ENUMSTD index=3D5, id=3D0x7, =
name=3DPAL-BG, fps=3D1/25, framelines=3D625=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_ENUMSTD index=3D6, id=3D0x8, =
name=3DPAL-H, fps=3D1/25, framelines=3D625=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_ENUMSTD index=3D7, id=3D0x10, =
name=3DPAL-I, fps=3D1/25, framelines=3D625=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_ENUMSTD index=3D8, id=3D0xe0, =
name=3DPAL-DK, fps=3D1/25, framelines=3D625=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_ENUMSTD index=3D9, id=3D0x100, =
name=3DPAL-M, fps=3D1001/30000, framelines=3D525=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_ENUMSTD index=3D10, id=3D0x200, =
name=3DPAL-N, fps=3D1/25, framelines=3D625=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_ENUMSTD index=3D11, id=3D0x400, =
name=3DPAL-Nc, fps=3D1/25, framelines=3D625=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_ENUMSTD index=3D12, id=3D0x800, =
name=3DPAL-60, fps=3D1001/30000, framelines=3D525=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_ENUMSTD index=3D13, =
id=3D0xff0000, name=3DSECAM, fps=3D1/25, framelines=3D625=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_ENUMSTD index=3D14, =
id=3D0x10000, name=3DSECAM-B, fps=3D1/25, framelines=3D625=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_ENUMSTD index=3D15, =
id=3D0x40000, name=3DSECAM-G, fps=3D1/25, framelines=3D625=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_ENUMSTD index=3D16, =
id=3D0x80000, name=3DSECAM-H, fps=3D1/25, framelines=3D625=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_ENUMSTD index=3D17, =
id=3D0x320000, name=3DSECAM-DK, fps=3D1/25, framelines=3D625=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_ENUMSTD index=3D18, =
id=3D0x400000, name=3DSECAM-L, fps=3D1/25, framelines=3D625=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_ENUMSTD index=3D19, =
id=3D0x800000, name=3DSECAM-Lc, fps=3D1/25, framelines=3D625=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_ENUMSTD error -22=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_G_STD std=3D0x000000ff=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_ENUMSTD index=3D0, id=3D0xb000, =
name=3DNTSC, fps=3D1001/30000, framelines=3D525=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_ENUMSTD index=3D1, id=3D0x1000, =
name=3DNTSC-M, fps=3D1001/30000, framelines=3D525=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_ENUMSTD index=3D2, id=3D0x2000, =
name=3DNTSC-M-JP, fps=3D1001/30000, framelines=3D525=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_ENUMSTD index=3D3, id=3D0x8000, =
name=3DNTSC-M-KR, fps=3D1001/30000, framelines=3D525=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_ENUMSTD index=3D4, id=3D0xff, =
name=3DPAL, fps=3D1/25, framelines=3D625=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_G_FREQUENCY tuner=3D0, type=3D2, =
frequency=3D0=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_ENUM_FMT index=3D0, type=3D1, =
flags=3D0, pixelformat=3DGREY, description=3D'8 bpp gray'=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_ENUM_FMT index=3D1, type=3D1, =
flags=3D0, pixelformat=3DRGBO, description=3D'15 bpp RGB, le'=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_ENUM_FMT index=3D2, type=3D1, =
flags=3D0, pixelformat=3DRGBQ, description=3D'15 bpp RGB, be'=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_ENUM_FMT index=3D3, type=3D1, =
flags=3D0, pixelformat=3DRGBP, description=3D'16 bpp RGB, le'=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_ENUM_FMT index=3D4, type=3D1, =
flags=3D0, pixelformat=3DRGBR, description=3D'16 bpp RGB, be'=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_ENUM_FMT index=3D5, type=3D1, =
flags=3D0, pixelformat=3DBGR3, description=3D'24 bpp RGB, le'=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_ENUM_FMT index=3D6, type=3D1, =
flags=3D0, pixelformat=3DRGB3, description=3D'24 bpp RGB, be'=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_ENUM_FMT index=3D7, type=3D1, =
flags=3D0, pixelformat=3DBGR4, description=3D'32 bpp RGB, le'=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_ENUM_FMT index=3D8, type=3D1, =
flags=3D0, pixelformat=3DRGB4, description=3D'32 bpp RGB, be'=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_ENUM_FMT index=3D9, type=3D1, =
flags=3D0, pixelformat=3DYUYV, description=3D'4:2:2 packed, YUYV'=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_ENUM_FMT index=3D10, type=3D1, =
flags=3D0, pixelformat=3DUYVY, description=3D'4:2:2 packed, UYVY'=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_ENUM_FMT index=3D11, type=3D1, =
flags=3D0, pixelformat=3D422P, description=3D'4:2:2 planar, Y-Cb-Cr'=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_ENUM_FMT index=3D12, type=3D1, =
flags=3D0, pixelformat=3DYU12, description=3D'4:2:0 planar, Y-Cb-Cr'=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_ENUM_FMT index=3D13, type=3D1, =
flags=3D0, pixelformat=3DYV12, description=3D'4:2:0 planar, Y-Cb-Cr'=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_ENUM_FMT error -22=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_G_FMT type=3Dvid-cap=0A=
saa7133[0] video (Avermedia PCI: width=3D720, height=3D576, =
format=3DBGR3, field=3Dany, bytesperline=3D2160 sizeimage=3D1244160, =
colorspace=3D0=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_ENUM_FMT index=3D0, type=3D1, =
flags=3D0, pixelformat=3DGREY, description=3D'8 bpp gray'=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_ENUM_FMT index=3D1, type=3D1, =
flags=3D0, pixelformat=3DRGBO, description=3D'15 bpp RGB, le'=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_ENUM_FMT index=3D2, type=3D1, =
flags=3D0, pixelformat=3DRGBQ, description=3D'15 bpp RGB, be'=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_ENUM_FMT index=3D3, type=3D1, =
flags=3D0, pixelformat=3DRGBP, description=3D'16 bpp RGB, le'=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_ENUM_FMT index=3D4, type=3D1, =
flags=3D0, pixelformat=3DRGBR, description=3D'16 bpp RGB, be'=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_ENUM_FMT index=3D5, type=3D1, =
flags=3D0, pixelformat=3DBGR3, description=3D'24 bpp RGB, le'=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_ENUM_FRAMESIZES error -22=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_ENUM_FRAMEINTERVALS error -22=0A=
saa7134_reqbufs: f2354ee8 c2043e68=0A=
queue_setup=0A=
vb2: Buffer 0, plane 0 offset 0x00000000=0A=
vb2: Allocated 1 buffers, 1 plane(s) each=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_REQBUFS count=3D1, =
type=3Dvid-cap, memory=3Duserptr=0A=
saa7134_reqbufs: f2354ee8 c2043e68=0A=
queue_setup=0A=
vb2: Allocated 0 buffers, 1 plane(s) each=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_REQBUFS count=3D0, =
type=3Dvid-cap, memory=3Duserptr=0A=
saa7134_reqbufs: f2354ee8 c2043e68=0A=
queue_setup=0A=
vb2_dma_sg_alloc: Allocated buffer of 304 pages=0A=
vb2: Buffer 0, plane 0 offset 0x00000000=0A=
vb2: Allocated 1 buffers, 1 plane(s) each=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_REQBUFS count=3D1, =
type=3Dvid-cap, memory=3Dmmap=0A=
saa7134_reqbufs: f2354ee8 c2043e68=0A=
vb2_dma_sg_put: Freeing buffer of 304 pages=0A=
vb2: Freed plane 0 of buffer 0=0A=
queue_setup=0A=
vb2: Allocated 0 buffers, 1 plane(s) each=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_REQBUFS count=3D0, =
type=3Dvid-cap, memory=3Dmmap=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_QUERYCTRL id=3D0x80000000=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_QUERYCTRL error -22=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_QUERYCTRL id=3D0x980900, =
type=3D1, name=3DBrightness, min/max=3D0/255, step=3D1, default=3D128, =
flags=3D0x00000000=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_QUERYCTRL id=3D0x980901, =
type=3D1, name=3DContrast, min/max=3D0/127, step=3D1, default=3D68, =
flags=3D0x00000000=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_QUERYCTRL id=3D0x980902, =
type=3D1, name=3DSaturation, min/max=3D0/127, step=3D1, default=3D64, =
flags=3D0x00000000=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_QUERYCTRL id=3D0x980903, =
type=3D1, name=3DHue, min/max=3D-128/127, step=3D1, default=3D0, =
flags=3D0x00000000=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_QUERYCTRL id=3D0x0, type=3D0, =
name=3D42, min/max=3D0/0, step=3D0, default=3D0, flags=3D0x00000001=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_QUERYCTRL id=3D0x980905, =
type=3D1, name=3DVolume, min/max=3D-15/15, step=3D1, default=3D0, =
flags=3D0x00000000=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_QUERYCTRL id=3D0x0, type=3D0, =
name=3D42, min/max=3D0/0, step=3D0, default=3D0, flags=3D0x00000001=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_QUERYCTRL id=3D0x0, type=3D0, =
name=3D42, min/max=3D0/0, step=3D0, default=3D0, flags=3D0x00000001=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_QUERYCTRL id=3D0x0, type=3D0, =
name=3D42, min/max=3D0/0, step=3D0, default=3D0, flags=3D0x00000001=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_QUERYCTRL id=3D0x980909, =
type=3D2, name=3DMute, min/max=3D0/1, step=3D0, default=3D0, =
flags=3D0x00000000=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_QUERYCTRL id=3D0x0, type=3D0, =
name=3D42, min/max=3D0/0, step=3D0, default=3D0, flags=3D0x00000001=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_QUERYCTRL id=3D0x0, type=3D0, =
name=3D42, min/max=3D0/0, step=3D0, default=3D0, flags=3D0x00000001=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_QUERYCTRL id=3D0x0, type=3D0, =
name=3D42, min/max=3D0/0, step=3D0, default=3D0, flags=3D0x00000001=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_QUERYCTRL id=3D0x0, type=3D0, =
name=3D42, min/max=3D0/0, step=3D0, default=3D0, flags=3D0x00000001=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_QUERYCTRL id=3D0x0, type=3D0, =
name=3D42, min/max=3D0/0, step=3D0, default=3D0, flags=3D0x00000001=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_QUERYCTRL id=3D0x0, type=3D0, =
name=3D42, min/max=3D0/0, step=3D0, default=3D0, flags=3D0x00000001=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_QUERYCTRL id=3D0x0, type=3D0, =
name=3D42, min/max=3D0/0, step=3D0, default=3D0, flags=3D0x00000001=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_QUERYCTRL id=3D0x0, type=3D0, =
name=3D42, min/max=3D0/0, step=3D0, default=3D0, flags=3D0x00000001=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_QUERYCTRL id=3D0x0, type=3D0, =
name=3D42, min/max=3D0/0, step=3D0, default=3D0, flags=3D0x00000001=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_QUERYCTRL id=3D0x0, type=3D0, =
name=3D42, min/max=3D0/0, step=3D0, default=3D0, flags=3D0x00000001=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_QUERYCTRL id=3D0x980914, =
type=3D2, name=3DMirror, min/max=3D0/1, step=3D0, default=3D0, =
flags=3D0x00000000=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_QUERYCTRL id=3D0x0, type=3D0, =
name=3D42, min/max=3D0/0, step=3D0, default=3D0, flags=3D0x00000001=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_QUERYCTRL id=3D0x0, type=3D0, =
name=3D42, min/max=3D0/0, step=3D0, default=3D0, flags=3D0x00000001=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_QUERYCTRL id=3D0x0, type=3D0, =
name=3D42, min/max=3D0/0, step=3D0, default=3D0, flags=3D0x00000001=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_QUERYCTRL id=3D0x0, type=3D0, =
name=3D42, min/max=3D0/0, step=3D0, default=3D0, flags=3D0x00000001=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_QUERYCTRL id=3D0x0, type=3D0, =
name=3D42, min/max=3D0/0, step=3D0, default=3D0, flags=3D0x00000001=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_QUERYCTRL id=3D0x0, type=3D0, =
name=3D42, min/max=3D0/0, step=3D0, default=3D0, flags=3D0x00000001=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_QUERYCTRL id=3D0x0, type=3D0, =
name=3D42, min/max=3D0/0, step=3D0, default=3D0, flags=3D0x00000001=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_QUERYCTRL id=3D0x0, type=3D0, =
name=3D42, min/max=3D0/0, step=3D0, default=3D0, flags=3D0x00000001=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_QUERYCTRL id=3D0x0, type=3D0, =
name=3D42, min/max=3D0/0, step=3D0, default=3D0, flags=3D0x00000001=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_QUERYCTRL id=3D0x0, type=3D0, =
name=3D42, min/max=3D0/0, step=3D0, default=3D0, flags=3D0x00000001=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_QUERYCTRL id=3D0x0, type=3D0, =
name=3D42, min/max=3D0/0, step=3D0, default=3D0, flags=3D0x00000001=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_QUERYCTRL id=3D0x0, type=3D0, =
name=3D42, min/max=3D0/0, step=3D0, default=3D0, flags=3D0x00000001=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_QUERYCTRL id=3D0x0, type=3D0, =
name=3D42, min/max=3D0/0, step=3D0, default=3D0, flags=3D0x00000001=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_QUERYCTRL id=3D0x0, type=3D0, =
name=3D42, min/max=3D0/0, step=3D0, default=3D0, flags=3D0x00000001=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_QUERYCTRL id=3D0x0, type=3D0, =
name=3D42, min/max=3D0/0, step=3D0, default=3D0, flags=3D0x00000001=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_QUERYCTRL id=3D0x0, type=3D0, =
name=3D42, min/max=3D0/0, step=3D0, default=3D0, flags=3D0x00000001=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_QUERYCTRL id=3D0x8000000, =
type=3D2, name=3DInvert, min/max=3D0/1, step=3D0, default=3D0, =
flags=3D0x00000000=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_QUERYCTRL id=3D0x8000001, =
type=3D1, name=3Dy offset odd field, min/max=3D0/128, step=3D1, =
default=3D0, flags=3D0x00000000=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_QUERYCTRL id=3D0x8000002, =
type=3D1, name=3Dy offset even field, min/max=3D0/128, step=3D1, =
default=3D0, flags=3D0x00000000=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_QUERYCTRL id=3D0x8000003, =
type=3D2, name=3Dautomute, min/max=3D0/1, step=3D0, default=3D1, =
flags=3D0x00000000=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_QUERYCTRL id=3D0x8000004=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_QUERYCTRL error -22=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_G_CTRL id=3D0x980900, value=3D128=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_QUERYCTRL id=3D0x980900, =
type=3D1, name=3DBrightness, min/max=3D0/255, step=3D1, default=3D128, =
flags=3D0x00000000=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_S_CTRL id=3D0x980900, value=3D128=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_G_CTRL id=3D0x980901, value=3D68=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_QUERYCTRL id=3D0x980901, =
type=3D1, name=3DContrast, min/max=3D0/127, step=3D1, default=3D68, =
flags=3D0x00000000=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_S_CTRL id=3D0x980901, value=3D68=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_G_CTRL id=3D0x980902, value=3D64=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_QUERYCTRL id=3D0x980902, =
type=3D1, name=3DSaturation, min/max=3D0/127, step=3D1, default=3D64, =
flags=3D0x00000000=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_S_CTRL id=3D0x980902, value=3D64=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_G_CTRL id=3D0x980903, value=3D0=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_QUERYCTRL id=3D0x980903, =
type=3D1, name=3DHue, min/max=3D-128/127, step=3D1, default=3D0, =
flags=3D0x00000000=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_G_CTRL id=3D0x980905, value=3D0=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_QUERYCTRL id=3D0x980905, =
type=3D1, name=3DVolume, min/max=3D-15/15, step=3D1, default=3D0, =
flags=3D0x00000000=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_G_CTRL id=3D0x980909, value=3D1=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_QUERYCTRL id=3D0x980909, =
type=3D2, name=3DMute, min/max=3D0/1, step=3D0, default=3D0, =
flags=3D0x00000000=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_G_CTRL id=3D0x980914, value=3D0=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_QUERYCTRL id=3D0x980914, =
type=3D2, name=3DMirror, min/max=3D0/1, step=3D0, default=3D0, =
flags=3D0x00000000=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_G_CTRL id=3D0x8000000, value=3D0=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_QUERYCTRL id=3D0x8000000, =
type=3D2, name=3DInvert, min/max=3D0/1, step=3D0, default=3D0, =
flags=3D0x00000000=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_G_CTRL id=3D0x8000001, value=3D0=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_QUERYCTRL id=3D0x8000001, =
type=3D1, name=3Dy offset odd field, min/max=3D0/128, step=3D1, =
default=3D0, flags=3D0x00000000=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_G_CTRL id=3D0x8000002, value=3D0=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_QUERYCTRL id=3D0x8000002, =
type=3D1, name=3Dy offset even field, min/max=3D0/128, step=3D1, =
default=3D0, flags=3D0x00000000=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_G_CTRL id=3D0x8000003, value=3D1=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_QUERYCTRL id=3D0x8000003, =
type=3D2, name=3Dautomute, min/max=3D0/1, step=3D0, default=3D1, =
flags=3D0x00000000=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_ENUM_FMT index=3D0, type=3D1, =
flags=3D0, pixelformat=3DGREY, description=3D'8 bpp gray'=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_ENUM_FMT index=3D1, type=3D1, =
flags=3D0, pixelformat=3DRGBO, description=3D'15 bpp RGB, le'=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_ENUM_FMT index=3D2, type=3D1, =
flags=3D0, pixelformat=3DRGBQ, description=3D'15 bpp RGB, be'=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_ENUM_FMT index=3D3, type=3D1, =
flags=3D0, pixelformat=3DRGBP, description=3D'16 bpp RGB, le'=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_ENUM_FRAMESIZES error -22=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_ENUM_FMT index=3D4, type=3D1, =
flags=3D0, pixelformat=3DRGBR, description=3D'16 bpp RGB, be'=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_ENUM_FMT index=3D5, type=3D1, =
flags=3D0, pixelformat=3DBGR3, description=3D'24 bpp RGB, le'=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_ENUM_FRAMESIZES error -22=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_ENUM_FMT index=3D6, type=3D1, =
flags=3D0, pixelformat=3DRGB3, description=3D'24 bpp RGB, be'=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_ENUM_FRAMESIZES error -22=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_ENUM_FMT index=3D7, type=3D1, =
flags=3D0, pixelformat=3DBGR4, description=3D'32 bpp RGB, le'=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_ENUM_FMT index=3D8, type=3D1, =
flags=3D0, pixelformat=3DRGB4, description=3D'32 bpp RGB, be'=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_ENUM_FMT index=3D9, type=3D1, =
flags=3D0, pixelformat=3DYUYV, description=3D'4:2:2 packed, YUYV'=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_ENUM_FRAMESIZES error -22=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_ENUM_FMT index=3D10, type=3D1, =
flags=3D0, pixelformat=3DUYVY, description=3D'4:2:2 packed, UYVY'=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_ENUM_FRAMESIZES error -22=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_ENUM_FMT index=3D11, type=3D1, =
flags=3D0, pixelformat=3D422P, description=3D'4:2:2 planar, Y-Cb-Cr'=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_ENUM_FMT index=3D12, type=3D1, =
flags=3D0, pixelformat=3DYU12, description=3D'4:2:0 planar, Y-Cb-Cr'=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_ENUM_FRAMESIZES error -22=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_ENUM_FMT index=3D13, type=3D1, =
flags=3D0, pixelformat=3DYV12, description=3D'4:2:0 planar, Y-Cb-Cr'=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_ENUM_FRAMESIZES error -22=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_ENUM_FMT error -22=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_QUERYCAP driver=3Dsaa7134, =
card=3DAvermedia PCI pure analog (M135, bus=3DPCI:0000:05:00.0, =
version=3D0x00000210, capabilities=3D0x05010015=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_G_INPUT value=3D0=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_ENUMINPUT index=3D0, =
name=3DTelevision, type=3D1, audioset=3D1, tuner=3D0, std=3D00ffbfff, =
status=3D65792=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_QUERYCTRL id=3D0x80000000=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_QUERYCTRL error -22=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_S_INPUT value=3D2=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_G_INPUT value=3D2=0A=
saa7133[0]/irq[0,21275244]: r=3D0x100 s=3D0x10 INTL=0A=
DCSDT: pll: locked, sync: no, norm: (no signal)=0A=
saa7133[0]/irq: no (more) work=0A=
saa7133[0]/irq[0,21275276]: r=3D0x100 s=3D0x10 INTL=0A=
DCSDT: pll: locked, sync: no, norm: PAL=0A=
saa7133[0]/irq: no (more) work=0A=
saa7133[0]/irq[0,21275306]: r=3D0x80 s=3D0x10 RDCAP=0A=
DCSDT: pll: locked, sync: yes, norm: PAL=0A=
saa7133[0]/irq: no (more) work=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_ENUM_FMT index=3D9, type=3D1, =
flags=3D0, pixelformat=3DYUYV, description=3D'4:2:2 packed, YUYV'=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_G_FMT type=3Dvid-cap=0A=
saa7133[0] video (Avermedia PCI: width=3D720, height=3D576, =
format=3DBGR3, field=3Dany, bytesperline=3D2160 sizeimage=3D1244160, =
colorspace=3D0=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_TRY_FMT type=3Dvid-cap=0A=
saa7133[0] video (Avermedia PCI: width=3D720, height=3D576, =
format=3DYUYV, field=3Dinterlaced, bytesperline=3D1440 =
sizeimage=3D829440, colorspace=3D0=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_S_FMT type=3Dvid-cap=0A=
saa7133[0] video (Avermedia PCI: width=3D720, height=3D576, =
format=3DYUYV, field=3Dinterlaced, bytesperline=3D1440 =
sizeimage=3D829440, colorspace=3D0=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_G_FMT type=3Dvid-cap=0A=
saa7133[0] video (Avermedia PCI: width=3D720, height=3D576, =
format=3DYUYV, field=3Dany, bytesperline=3D1440 sizeimage=3D829440, =
colorspace=3D0=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_ENUM_FMT index=3D0, type=3D1, =
flags=3D0, pixelformat=3DGREY, description=3D'8 bpp gray'=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_ENUM_FMT index=3D1, type=3D1, =
flags=3D0, pixelformat=3DRGBO, description=3D'15 bpp RGB, le'=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_ENUM_FMT index=3D2, type=3D1, =
flags=3D0, pixelformat=3DRGBQ, description=3D'15 bpp RGB, be'=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_ENUM_FMT index=3D3, type=3D1, =
flags=3D0, pixelformat=3DRGBP, description=3D'16 bpp RGB, le'=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_ENUM_FMT index=3D4, type=3D1, =
flags=3D0, pixelformat=3DRGBR, description=3D'16 bpp RGB, be'=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_ENUM_FMT index=3D5, type=3D1, =
flags=3D0, pixelformat=3DBGR3, description=3D'24 bpp RGB, le'=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_ENUM_FMT index=3D6, type=3D1, =
flags=3D0, pixelformat=3DRGB3, description=3D'24 bpp RGB, be'=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_ENUM_FMT index=3D7, type=3D1, =
flags=3D0, pixelformat=3DBGR4, description=3D'32 bpp RGB, le'=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_ENUM_FMT index=3D8, type=3D1, =
flags=3D0, pixelformat=3DRGB4, description=3D'32 bpp RGB, be'=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_ENUM_FMT index=3D9, type=3D1, =
flags=3D0, pixelformat=3DYUYV, description=3D'4:2:2 packed, YUYV'=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_ENUM_FRAMESIZES error -22=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_ENUM_FRAMEINTERVALS error -22=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_G_FMT type=3Dvid-cap=0A=
saa7133[0] video (Avermedia PCI: width=3D720, height=3D576, =
format=3DYUYV, field=3Dany, bytesperline=3D1440 sizeimage=3D829440, =
colorspace=3D0=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_TRY_FMT type=3Dvid-cap=0A=
saa7133[0] video (Avermedia PCI: width=3D720, height=3D576, =
format=3DRGB3, field=3Dinterlaced, bytesperline=3D2160 =
sizeimage=3D1244160, colorspace=3D0=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_TRY_FMT type=3Dvid-cap=0A=
saa7133[0] video (Avermedia PCI: width=3D720, height=3D576, =
format=3DBGR3, field=3Dinterlaced, bytesperline=3D2160 =
sizeimage=3D1244160, colorspace=3D0=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_TRY_FMT type=3Dvid-cap=0A=
saa7133[0] video (Avermedia PCI: width=3D720, height=3D576, =
format=3DYU12, field=3Dinterlaced, bytesperline=3D1080 =
sizeimage=3D622080, colorspace=3D0=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_TRY_FMT type=3Dvid-cap=0A=
saa7133[0] video (Avermedia PCI: width=3D720, height=3D576, =
format=3DYV12, field=3Dinterlaced, bytesperline=3D1080 =
sizeimage=3D622080, colorspace=3D0=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_TRY_FMT type=3Dvid-cap=0A=
saa7133[0] video (Avermedia PCI: width=3D720, height=3D576, =
format=3DYUYV, field=3Dinterlaced, bytesperline=3D1440 =
sizeimage=3D829440, colorspace=3D0=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_TRY_FMT type=3Dvid-cap=0A=
saa7133[0] video (Avermedia PCI: width=3D720, height=3D576, =
format=3DUYVY, field=3Dinterlaced, bytesperline=3D1440 =
sizeimage=3D829440, colorspace=3D0=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_TRY_FMT type=3Dvid-cap=0A=
saa7133[0] video (Avermedia PCI: width=3D720, height=3D576, =
format=3DRGBP, field=3Dinterlaced, bytesperline=3D1440 =
sizeimage=3D829440, colorspace=3D0=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_G_FMT type=3Dvid-cap=0A=
saa7133[0] video (Avermedia PCI: width=3D720, height=3D576, =
format=3DYUYV, field=3Dany, bytesperline=3D1440 sizeimage=3D829440, =
colorspace=3D0=0A=
saa7134_reqbufs: f2354ee8 c2043e68=0A=
queue_setup=0A=
vb2: Buffer 0, plane 0 offset 0x00000000=0A=
vb2: Buffer 1, plane 0 offset 0x00000000=0A=
vb2: Buffer 2, plane 0 offset 0x00000000=0A=
vb2: Buffer 3, plane 0 offset 0x00000000=0A=
vb2: Allocated 4 buffers, 1 plane(s) each=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_REQBUFS count=3D4, =
type=3Dvid-cap, memory=3Duserptr=0A=
saa7134_qbuf: f2354ee8 c2043e68=0A=
vb2: qbuf: userspace address for plane 0 changed, reacquiring memory=0A=
buffer_prepare: sglist:fab44000 num_pages:203=0A=
vb2: qbuf of buffer 0 succeeded=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_QBUF 00:00:00.00000000 =
index=3D0, type=3Dvid-cap, flags=3D0x00000000, field=3D0, sequence=3D0, =
memory=3Duserptr=0A=
saa7133[0] video (Avermedia PCI: bytesused=3D0, =
offset/userptr=3D0xb5d97008, length=3D829440=0A=
saa7133[0] video (Avermedia PCI: timecode=3D00:00:00 type=3D0, =
flags=3D0x00000000, frames=3D0, userbits=3D0x00000000=0A=
saa7134_qbuf: f2354ee8 c2043e68=0A=
vb2: qbuf: userspace address for plane 0 changed, reacquiring memory=0A=
buffer_prepare: sglist:fab47000 num_pages:203=0A=
vb2: qbuf of buffer 1 succeeded=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_QBUF 00:00:00.00000000 =
index=3D1, type=3Dvid-cap, flags=3D0x00000000, field=3D0, sequence=3D0, =
memory=3Duserptr=0A=
saa7133[0] video (Avermedia PCI: bytesused=3D0, =
offset/userptr=3D0xb5ccc008, length=3D829440=0A=
saa7133[0] video (Avermedia PCI: timecode=3D00:00:00 type=3D0, =
flags=3D0x00000000, frames=3D0, userbits=3D0x00000000=0A=
saa7134_qbuf: f2354ee8 c2043e68=0A=
vb2: qbuf: userspace address for plane 0 changed, reacquiring memory=0A=
buffer_prepare: sglist:fab4a000 num_pages:203=0A=
vb2: qbuf of buffer 2 succeeded=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_QBUF 00:00:00.00000000 =
index=3D2, type=3Dvid-cap, flags=3D0x00000000, field=3D0, sequence=3D0, =
memory=3Duserptr=0A=
saa7133[0] video (Avermedia PCI: bytesused=3D0, =
offset/userptr=3D0xb5c01008, length=3D829440=0A=
saa7133[0] video (Avermedia PCI: timecode=3D00:00:00 type=3D0, =
flags=3D0x00000000, frames=3D0, userbits=3D0x00000000=0A=
saa7134_qbuf: f2354ee8 c2043e68=0A=
vb2: qbuf: userspace address for plane 0 changed, reacquiring memory=0A=
buffer_prepare: sglist:fab4d000 num_pages:203=0A=
vb2: qbuf of buffer 3 succeeded=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_QBUF 00:00:00.00000000 =
index=3D3, type=3Dvid-cap, flags=3D0x00000000, field=3D0, sequence=3D0, =
memory=3Duserptr=0A=
saa7133[0] video (Avermedia PCI: bytesused=3D0, =
offset/userptr=3D0xb5b36008, length=3D829440=0A=
saa7133[0] video (Avermedia PCI: timecode=3D00:00:00 type=3D0, =
flags=3D0x00000000, frames=3D0, userbits=3D0x00000000=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_STREAMON type=3Dvid-cap=0A=
saa7134_streamon: f2354ee8=0A=
buffer_queue=0A=
buffer_queue c3c1c000=0A=
buffer_activate buf=3Dc3c1c000=0A=
saa7134_set_dmabits=0A=
dmabits: task=3D0x01 ctrl=3D0x01 irq=3D0x3 split=3Dyes=0A=
buffer_queue=0A=
buffer_queue c3c1f800=0A=
buffer_queue=0A=
buffer_queue c3c1dc00=0A=
buffer_queue=0A=
buffer_queue c3c1d400=0A=
vb2: Streamon successful=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
saa7133[0]/irq[0,21277591]: r=3D0x1 s=3D0x10 DONE_RA0 | =
RA0=3Dvideo,a,odd,0=0A=
buffer_finish c3c1c000=0A=
vb2: Done processing on buffer 0, state: 2=0A=
buffer_next c3c1f800 [prev=3Dc3c1d694/next=3Dc3c1fa94]=0A=
buffer_activate buf=3Dc3c1f800=0A=
saa7134_set_dmabits=0A=
dmabits: task=3D0x01 ctrl=3D0x01 irq=3D0x3 split=3Dyes=0A=
buffer_next #2 prev=3Dc3c1d694/next=3Dc3c1de94=0A=
saa7133[0]/irq: no (more) work=0A=
video_poll: f2354ee8=0A=
saa7134_dqbuf: f2354ee8 c2043e68=0A=
vb2: dqbuf: Returning done buffer=0A=
vb2: dqbuf of buffer 0, with state 3=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_DQBUF 359696:21:05.00187684 =
index=3D0, type=3Dvid-cap, flags=3D0x00000004, field=3D0, sequence=3D0, =
memory=3Duserptr=0A=
saa7133[0] video (Avermedia PCI: bytesused=3D829440, =
offset/userptr=3D0xb5d97008, length=3D829440=0A=
saa7133[0] video (Avermedia PCI: timecode=3D00:00:00 type=3D0, =
flags=3D0x00000000, frames=3D0, userbits=3D0x00000000=0A=
saa7134_qbuf: f2354ee8 c2043e68=0A=
buffer_prepare: sglist:fab44000 num_pages:203=0A=
buffer_queue=0A=
buffer_queue c3c1c000=0A=
buffer_activate buf=3Dc3c1c000=0A=
saa7134_set_dmabits=0A=
dmabits: task=3D0x01 ctrl=3D0x01 irq=3D0x3 split=3Dyes=0A=
vb2: qbuf of buffer 0 succeeded=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_QBUF 359696:21:05.00187684 =
index=3D0, type=3Dvid-cap, flags=3D0x00000004, field=3D0, sequence=3D0, =
memory=3Duserptr=0A=
saa7133[0] video (Avermedia PCI: bytesused=3D829440, =
offset/userptr=3D0xb5d97008, length=3D829440=0A=
saa7133[0] video (Avermedia PCI: timecode=3D00:00:00 type=3D0, =
flags=3D0x00000000, frames=3D0, userbits=3D0x00000000=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_G_CTRL id=3D0x980900, value=3D128=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_QUERYCTRL id=3D0x980900, =
type=3D1, name=3DBrightness, min/max=3D0/255, step=3D1, default=3D128, =
flags=3D0x00000000=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_G_CTRL id=3D0x980901, value=3D68=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_QUERYCTRL id=3D0x980901, =
type=3D1, name=3DContrast, min/max=3D0/127, step=3D1, default=3D68, =
flags=3D0x00000000=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_G_CTRL id=3D0x980902, value=3D64=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_QUERYCTRL id=3D0x980902, =
type=3D1, name=3DSaturation, min/max=3D0/127, step=3D1, default=3D64, =
flags=3D0x00000000=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_G_CTRL id=3D0x980903, value=3D0=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_QUERYCTRL id=3D0x980903, =
type=3D1, name=3DHue, min/max=3D-128/127, step=3D1, default=3D0, =
flags=3D0x00000000=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_G_CTRL id=3D0x980905, value=3D0=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_QUERYCTRL id=3D0x980905, =
type=3D1, name=3DVolume, min/max=3D-15/15, step=3D1, default=3D0, =
flags=3D0x00000000=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_G_CTRL id=3D0x980909, value=3D1=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_QUERYCTRL id=3D0x980909, =
type=3D2, name=3DMute, min/max=3D0/1, step=3D0, default=3D0, =
flags=3D0x00000000=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_G_CTRL id=3D0x980914, value=3D0=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_QUERYCTRL id=3D0x980914, =
type=3D2, name=3DMirror, min/max=3D0/1, step=3D0, default=3D0, =
flags=3D0x00000000=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_G_CTRL id=3D0x8000000, value=3D0=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_QUERYCTRL id=3D0x8000000, =
type=3D2, name=3DInvert, min/max=3D0/1, step=3D0, default=3D0, =
flags=3D0x00000000=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_G_CTRL id=3D0x8000001, value=3D0=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_QUERYCTRL id=3D0x8000001, =
type=3D1, name=3Dy offset odd field, min/max=3D0/128, step=3D1, =
default=3D0, flags=3D0x00000000=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_G_CTRL id=3D0x8000002, value=3D0=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_QUERYCTRL id=3D0x8000002, =
type=3D1, name=3Dy offset even field, min/max=3D0/128, step=3D1, =
default=3D0, flags=3D0x00000000=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_G_CTRL id=3D0x8000003, value=3D1=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_QUERYCTRL id=3D0x8000003, =
type=3D2, name=3Dautomute, min/max=3D0/1, step=3D0, default=3D1, =
flags=3D0x00000000=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
saa7133[0]/irq[0,21277596]: r=3D0x1 s=3D0x00 DONE_RA0 | =
RA0=3Dvideo,a,even,0=0A=
buffer_finish c3c1c000=0A=
vb2: Done processing on buffer 0, state: 2=0A=
buffer_next c3c1dc00 [prev=3Dc3c1d694/next=3Dc3c1de94]=0A=
buffer_activate buf=3Dc3c1dc00=0A=
saa7134_set_dmabits=0A=
dmabits: task=3D0x01 ctrl=3D0x01 irq=3D0x3 split=3Dyes=0A=
buffer_next #2 prev=3Dc3c1d694/next=3Dc3c1d694=0A=
saa7133[0]/irq: no (more) work=0A=
video_poll: f2354ee8=0A=
saa7134_dqbuf: f2354ee8 c2043e68=0A=
vb2: dqbuf: Returning done buffer=0A=
vb2: dqbuf of buffer 0, with state 3=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_DQBUF 359696:21:05.00207652 =
index=3D0, type=3Dvid-cap, flags=3D0x00000004, field=3D0, sequence=3D0, =
memory=3Duserptr=0A=
saa7133[0] video (Avermedia PCI: bytesused=3D829440, =
offset/userptr=3D0xb5d97008, length=3D829440=0A=
saa7133[0] video (Avermedia PCI: timecode=3D00:00:00 type=3D0, =
flags=3D0x00000000, frames=3D0, userbits=3D0x00000000=0A=
saa7134_qbuf: f2354ee8 c2043e68=0A=
buffer_prepare: sglist:fab44000 num_pages:203=0A=
buffer_queue=0A=
buffer_queue c3c1c000=0A=
buffer_activate buf=3Dc3c1c000=0A=
saa7134_set_dmabits=0A=
dmabits: task=3D0x01 ctrl=3D0x01 irq=3D0x3 split=3Dyes=0A=
vb2: qbuf of buffer 0 succeeded=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_QBUF 359696:21:05.00207652 =
index=3D0, type=3Dvid-cap, flags=3D0x00000004, field=3D0, sequence=3D0, =
memory=3Duserptr=0A=
saa7133[0] video (Avermedia PCI: bytesused=3D829440, =
offset/userptr=3D0xb5d97008, length=3D829440=0A=
saa7133[0] video (Avermedia PCI: timecode=3D00:00:00 type=3D0, =
flags=3D0x00000000, frames=3D0, userbits=3D0x00000000=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
saa7133[0]/irq[0,21277601]: r=3D0x1 s=3D0x10 DONE_RA0 | =
RA0=3Dvideo,a,odd,0=0A=
buffer_finish c3c1c000=0A=
vb2: Done processing on buffer 0, state: 2=0A=
buffer_next c3c1d400 [prev=3Dc3c1d694/next=3Dc3c1d694]=0A=
buffer_activate buf=3Dc3c1d400=0A=
saa7134_set_dmabits=0A=
dmabits: task=3D0x01 ctrl=3D0x01 irq=3D0x3 split=3Dyes=0A=
buffer_next #2 prev=3Def857ce8/next=3Def857ce8=0A=
saa7133[0]/irq: no (more) work=0A=
video_poll: f2354ee8=0A=
saa7134_dqbuf: f2354ee8 c2043e68=0A=
vb2: dqbuf: Returning done buffer=0A=
vb2: dqbuf of buffer 0, with state 3=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_DQBUF 359696:21:05.00227682 =
index=3D0, type=3Dvid-cap, flags=3D0x00000004, field=3D0, sequence=3D0, =
memory=3Duserptr=0A=
saa7133[0] video (Avermedia PCI: bytesused=3D829440, =
offset/userptr=3D0xb5d97008, length=3D829440=0A=
saa7133[0] video (Avermedia PCI: timecode=3D00:00:00 type=3D0, =
flags=3D0x00000000, frames=3D0, userbits=3D0x00000000=0A=
saa7134_qbuf: f2354ee8 c2043e68=0A=
buffer_prepare: sglist:fab44000 num_pages:203=0A=
buffer_queue=0A=
buffer_queue c3c1c000=0A=
buffer_activate buf=3Dc3c1c000=0A=
saa7134_set_dmabits=0A=
dmabits: task=3D0x01 ctrl=3D0x01 irq=3D0x3 split=3Dyes=0A=
vb2: qbuf of buffer 0 succeeded=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_QBUF 359696:21:05.00227682 =
index=3D0, type=3Dvid-cap, flags=3D0x00000004, field=3D0, sequence=3D0, =
memory=3Duserptr=0A=
saa7133[0] video (Avermedia PCI: bytesused=3D829440, =
offset/userptr=3D0xb5d97008, length=3D829440=0A=
saa7133[0] video (Avermedia PCI: timecode=3D00:00:00 type=3D0, =
flags=3D0x00000000, frames=3D0, userbits=3D0x00000000=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
saa7133[0]/irq[0,21277606]: r=3D0x1 s=3D0x00 DONE_RA0 | =
RA0=3Dvideo,a,even,0=0A=
buffer_finish c3c1c000=0A=
vb2: Done processing on buffer 0, state: 2=0A=
buffer_next   (null)=0A=
video_poll: f2354ee8=0A=
saa7134_set_dmabits=0A=
dmabits: task=3D0x00 ctrl=3D0x00 irq=3D0x0 split=3Dyes=0A=
saa7133[0]/irq: no (more) work=0A=
saa7134_dqbuf: f2354ee8 c2043e68=0A=
vb2: dqbuf: Returning done buffer=0A=
vb2: dqbuf of buffer 0, with state 3=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_DQBUF 359696:21:05.00247650 =
index=3D0, type=3Dvid-cap, flags=3D0x00000004, field=3D0, sequence=3D0, =
memory=3Duserptr=0A=
saa7133[0] video (Avermedia PCI: bytesused=3D829440, =
offset/userptr=3D0xb5d97008, length=3D829440=0A=
saa7133[0] video (Avermedia PCI: timecode=3D00:00:00 type=3D0, =
flags=3D0x00000000, frames=3D0, userbits=3D0x00000000=0A=
saa7134_qbuf: f2354ee8 c2043e68=0A=
buffer_prepare: sglist:fab44000 num_pages:203=0A=
buffer_queue=0A=
buffer_queue c3c1c000=0A=
buffer_activate buf=3Dc3c1c000=0A=
saa7134_set_dmabits=0A=
dmabits: task=3D0x01 ctrl=3D0x01 irq=3D0x3 split=3Dyes=0A=
vb2: qbuf of buffer 0 succeeded=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_QBUF 359696:21:05.00247650 =
index=3D0, type=3Dvid-cap, flags=3D0x00000004, field=3D0, sequence=3D0, =
memory=3Duserptr=0A=
saa7133[0] video (Avermedia PCI: bytesused=3D829440, =
offset/userptr=3D0xb5d97008, length=3D829440=0A=
saa7133[0] video (Avermedia PCI: timecode=3D00:00:00 type=3D0, =
flags=3D0x00000000, frames=3D0, userbits=3D0x00000000=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
saa7133[0]/irq[0,21277621]: r=3D0x1 s=3D0x10 DONE_RA0 | =
RA0=3Dvideo,a,odd,0=0A=
buffer_finish c3c1c000=0A=
vb2: Done processing on buffer 0, state: 2=0A=
buffer_next   (null)=0A=
saa7134_set_dmabits=0A=
dmabits: task=3D0x00 ctrl=3D0x00 irq=3D0x0 split=3Dyes=0A=
saa7133[0]/irq: no (more) work=0A=
video_poll: f2354ee8=0A=
saa7134_dqbuf: f2354ee8 c2043e68=0A=
vb2: dqbuf: Returning done buffer=0A=
vb2: dqbuf of buffer 0, with state 3=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_DQBUF 359696:21:05.00307684 =
index=3D0, type=3Dvid-cap, flags=3D0x00000004, field=3D0, sequence=3D0, =
memory=3Duserptr=0A=
saa7133[0] video (Avermedia PCI: bytesused=3D829440, =
offset/userptr=3D0xb5d97008, length=3D829440=0A=
saa7133[0] video (Avermedia PCI: timecode=3D00:00:00 type=3D0, =
flags=3D0x00000000, frames=3D0, userbits=3D0x00000000=0A=
saa7134_qbuf: f2354ee8 c2043e68=0A=
buffer_prepare: sglist:fab44000 num_pages:203=0A=
buffer_queue=0A=
buffer_queue c3c1c000=0A=
buffer_activate buf=3Dc3c1c000=0A=
saa7134_set_dmabits=0A=
dmabits: task=3D0x01 ctrl=3D0x01 irq=3D0x3 split=3Dyes=0A=
vb2: qbuf of buffer 0 succeeded=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_QBUF 359696:21:05.00307684 =
index=3D0, type=3Dvid-cap, flags=3D0x00000004, field=3D0, sequence=3D0, =
memory=3Duserptr=0A=
saa7133[0] video (Avermedia PCI: bytesused=3D829440, =
offset/userptr=3D0xb5d97008, length=3D829440=0A=
saa7133[0] video (Avermedia PCI: timecode=3D00:00:00 type=3D0, =
flags=3D0x00000000, frames=3D0, userbits=3D0x00000000=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
saa7133[0]/irq[0,21277631]: r=3D0x1 s=3D0x10 DONE_RA0 | =
RA0=3Dvideo,a,odd,0=0A=
buffer_finish c3c1c000=0A=
vb2: Done processing on buffer 0, state: 2=0A=
buffer_next   (null)=0A=
saa7134_set_dmabits=0A=
dmabits: task=3D0x00 ctrl=3D0x00 irq=3D0x0 split=3Dyes=0A=
saa7133[0]/irq: no (more) work=0A=
video_poll: f2354ee8=0A=
saa7134_dqbuf: f2354ee8 c2043e68=0A=
vb2: dqbuf: Returning done buffer=0A=
vb2: dqbuf of buffer 0, with state 3=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_DQBUF 359696:21:05.00347684 =
index=3D0, type=3Dvid-cap, flags=3D0x00000004, field=3D0, sequence=3D0, =
memory=3Duserptr=0A=
saa7133[0] video (Avermedia PCI: bytesused=3D829440, =
offset/userptr=3D0xb5d97008, length=3D829440=0A=
saa7133[0] video (Avermedia PCI: timecode=3D00:00:00 type=3D0, =
flags=3D0x00000000, frames=3D0, userbits=3D0x00000000=0A=
saa7134_qbuf: f2354ee8 c2043e68=0A=
buffer_prepare: sglist:fab44000 num_pages:203=0A=
buffer_queue=0A=
buffer_queue c3c1c000=0A=
buffer_activate buf=3Dc3c1c000=0A=
saa7134_set_dmabits=0A=
dmabits: task=3D0x01 ctrl=3D0x01 irq=3D0x3 split=3Dyes=0A=
vb2: qbuf of buffer 0 succeeded=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_QBUF 359696:21:05.00347684 =
index=3D0, type=3Dvid-cap, flags=3D0x00000004, field=3D0, sequence=3D0, =
memory=3Duserptr=0A=
saa7133[0] video (Avermedia PCI: bytesused=3D829440, =
offset/userptr=3D0xb5d97008, length=3D829440=0A=
saa7133[0] video (Avermedia PCI: timecode=3D00:00:00 type=3D0, =
flags=3D0x00000000, frames=3D0, userbits=3D0x00000000=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
saa7133[0]/irq[0,21277641]: r=3D0x1 s=3D0x10 DONE_RA0 | =
RA0=3Dvideo,a,odd,0=0A=
buffer_finish c3c1c000=0A=
vb2: Done processing on buffer 0, state: 2=0A=
buffer_next   (null)=0A=
saa7134_set_dmabits=0A=
dmabits: task=3D0x00 ctrl=3D0x00 irq=3D0x0 split=3Dyes=0A=
saa7133[0]/irq: no (more) work=0A=
video_poll: f2354ee8=0A=
saa7134_dqbuf: f2354ee8 c2043e68=0A=
vb2: dqbuf: Returning done buffer=0A=
vb2: dqbuf of buffer 0, with state 3=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_DQBUF 359696:21:05.00387685 =
index=3D0, type=3Dvid-cap, flags=3D0x00000004, field=3D0, sequence=3D0, =
memory=3Duserptr=0A=
saa7133[0] video (Avermedia PCI: bytesused=3D829440, =
offset/userptr=3D0xb5d97008, length=3D829440=0A=
saa7133[0] video (Avermedia PCI: timecode=3D00:00:00 type=3D0, =
flags=3D0x00000000, frames=3D0, userbits=3D0x00000000=0A=
saa7134_qbuf: f2354ee8 c2043e68=0A=
buffer_prepare: sglist:fab44000 num_pages:203=0A=
buffer_queue=0A=
buffer_queue c3c1c000=0A=
buffer_activate buf=3Dc3c1c000=0A=
saa7134_set_dmabits=0A=
dmabits: task=3D0x01 ctrl=3D0x01 irq=3D0x3 split=3Dyes=0A=
vb2: qbuf of buffer 0 succeeded=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_QBUF 359696:21:05.00387685 =
index=3D0, type=3Dvid-cap, flags=3D0x00000004, field=3D0, sequence=3D0, =
memory=3Duserptr=0A=
saa7133[0] video (Avermedia PCI: bytesused=3D829440, =
offset/userptr=3D0xb5d97008, length=3D829440=0A=
saa7133[0] video (Avermedia PCI: timecode=3D00:00:00 type=3D0, =
flags=3D0x00000000, frames=3D0, userbits=3D0x00000000=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
saa7133[0]/irq[0,21277651]: r=3D0x1 s=3D0x10 DONE_RA0 | =
RA0=3Dvideo,a,odd,0=0A=
buffer_finish c3c1c000=0A=
vb2: Done processing on buffer 0, state: 2=0A=
buffer_next   (null)=0A=
saa7134_set_dmabits=0A=
dmabits: task=3D0x00 ctrl=3D0x00 irq=3D0x0 split=3Dyes=0A=
saa7133[0]/irq: no (more) work=0A=
video_poll: f2354ee8=0A=
saa7134_dqbuf: f2354ee8 c2043e68=0A=
vb2: dqbuf: Returning done buffer=0A=
vb2: dqbuf of buffer 0, with state 3=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_DQBUF 359696:21:05.00427686 =
index=3D0, type=3Dvid-cap, flags=3D0x00000004, field=3D0, sequence=3D0, =
memory=3Duserptr=0A=
saa7133[0] video (Avermedia PCI: bytesused=3D829440, =
offset/userptr=3D0xb5d97008, length=3D829440=0A=
saa7133[0] video (Avermedia PCI: timecode=3D00:00:00 type=3D0, =
flags=3D0x00000000, frames=3D0, userbits=3D0x00000000=0A=
saa7134_qbuf: f2354ee8 c2043e68=0A=
buffer_prepare: sglist:fab44000 num_pages:203=0A=
buffer_queue=0A=
buffer_queue c3c1c000=0A=
buffer_activate buf=3Dc3c1c000=0A=
saa7134_set_dmabits=0A=
dmabits: task=3D0x01 ctrl=3D0x01 irq=3D0x3 split=3Dyes=0A=
vb2: qbuf of buffer 0 succeeded=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_QBUF 359696:21:05.00427686 =
index=3D0, type=3Dvid-cap, flags=3D0x00000004, field=3D0, sequence=3D0, =
memory=3Duserptr=0A=
saa7133[0] video (Avermedia PCI: bytesused=3D829440, =
offset/userptr=3D0xb5d97008, length=3D829440=0A=
saa7133[0] video (Avermedia PCI: timecode=3D00:00:00 type=3D0, =
flags=3D0x00000000, frames=3D0, userbits=3D0x00000000=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
saa7133[0]/irq[0,21277661]: r=3D0x1 s=3D0x10 DONE_RA0 | =
RA0=3Dvideo,a,odd,0=0A=
buffer_finish c3c1c000=0A=
vb2: Done processing on buffer 0, state: 2=0A=
buffer_next   (null)=0A=
saa7134_set_dmabits=0A=
dmabits: task=3D0x00 ctrl=3D0x00 irq=3D0x0 split=3Dyes=0A=
saa7133[0]/irq: no (more) work=0A=
video_poll: f2354ee8=0A=
saa7134_dqbuf: f2354ee8 c2043e68=0A=
vb2: dqbuf: Returning done buffer=0A=
vb2: dqbuf of buffer 0, with state 3=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_DQBUF 359696:21:05.00467686 =
index=3D0, type=3Dvid-cap, flags=3D0x00000004, field=3D0, sequence=3D0, =
memory=3Duserptr=0A=
saa7133[0] video (Avermedia PCI: bytesused=3D829440, =
offset/userptr=3D0xb5d97008, length=3D829440=0A=
saa7133[0] video (Avermedia PCI: timecode=3D00:00:00 type=3D0, =
flags=3D0x00000000, frames=3D0, userbits=3D0x00000000=0A=
saa7134_qbuf: f2354ee8 c2043e68=0A=
buffer_prepare: sglist:fab44000 num_pages:203=0A=
buffer_queue=0A=
buffer_queue c3c1c000=0A=
buffer_activate buf=3Dc3c1c000=0A=
saa7134_set_dmabits=0A=
dmabits: task=3D0x01 ctrl=3D0x01 irq=3D0x3 split=3Dyes=0A=
vb2: qbuf of buffer 0 succeeded=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_QBUF 359696:21:05.00467686 =
index=3D0, type=3Dvid-cap, flags=3D0x00000004, field=3D0, sequence=3D0, =
memory=3Duserptr=0A=
saa7133[0] video (Avermedia PCI: bytesused=3D829440, =
offset/userptr=3D0xb5d97008, length=3D829440=0A=
saa7133[0] video (Avermedia PCI: timecode=3D00:00:00 type=3D0, =
flags=3D0x00000000, frames=3D0, userbits=3D0x00000000=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
saa7133[0]/irq[0,21277671]: r=3D0x1 s=3D0x10 DONE_RA0 | =
RA0=3Dvideo,a,odd,0=0A=
buffer_finish c3c1c000=0A=
vb2: Done processing on buffer 0, state: 2=0A=
buffer_next   (null)=0A=
saa7134_set_dmabits=0A=
dmabits: task=3D0x00 ctrl=3D0x00 irq=3D0x0 split=3Dyes=0A=
saa7133[0]/irq: no (more) work=0A=
video_poll: f2354ee8=0A=
saa7134_dqbuf: f2354ee8 c2043e68=0A=
vb2: dqbuf: Returning done buffer=0A=
vb2: dqbuf of buffer 0, with state 3=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_DQBUF 359696:21:05.00507687 =
index=3D0, type=3Dvid-cap, flags=3D0x00000004, field=3D0, sequence=3D0, =
memory=3Duserptr=0A=
saa7133[0] video (Avermedia PCI: bytesused=3D829440, =
offset/userptr=3D0xb5d97008, length=3D829440=0A=
saa7133[0] video (Avermedia PCI: timecode=3D00:00:00 type=3D0, =
flags=3D0x00000000, frames=3D0, userbits=3D0x00000000=0A=
saa7134_qbuf: f2354ee8 c2043e68=0A=
buffer_prepare: sglist:fab44000 num_pages:203=0A=
buffer_queue=0A=
buffer_queue c3c1c000=0A=
buffer_activate buf=3Dc3c1c000=0A=
saa7134_set_dmabits=0A=
dmabits: task=3D0x01 ctrl=3D0x01 irq=3D0x3 split=3Dyes=0A=
vb2: qbuf of buffer 0 succeeded=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_QBUF 359696:21:05.00507687 =
index=3D0, type=3Dvid-cap, flags=3D0x00000004, field=3D0, sequence=3D0, =
memory=3Duserptr=0A=
saa7133[0] video (Avermedia PCI: bytesused=3D829440, =
offset/userptr=3D0xb5d97008, length=3D829440=0A=
saa7133[0] video (Avermedia PCI: timecode=3D00:00:00 type=3D0, =
flags=3D0x00000000, frames=3D0, userbits=3D0x00000000=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
saa7133[0]/irq[0,21277681]: r=3D0x1 s=3D0x10 DONE_RA0 | =
RA0=3Dvideo,a,odd,0=0A=
buffer_finish c3c1c000=0A=
vb2: Done processing on buffer 0, state: 2=0A=
buffer_next   (null)=0A=
saa7134_set_dmabits=0A=
dmabits: task=3D0x00 ctrl=3D0x00 irq=3D0x0 split=3Dyes=0A=
saa7133[0]/irq: no (more) work=0A=
video_poll: f2354ee8=0A=
saa7134_dqbuf: f2354ee8 c2043e68=0A=
vb2: dqbuf: Returning done buffer=0A=
vb2: dqbuf of buffer 0, with state 3=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_DQBUF 359696:21:05.00547687 =
index=3D0, type=3Dvid-cap, flags=3D0x00000004, field=3D0, sequence=3D0, =
memory=3Duserptr=0A=
saa7133[0] video (Avermedia PCI: bytesused=3D829440, =
offset/userptr=3D0xb5d97008, length=3D829440=0A=
saa7133[0] video (Avermedia PCI: timecode=3D00:00:00 type=3D0, =
flags=3D0x00000000, frames=3D0, userbits=3D0x00000000=0A=
saa7134_qbuf: f2354ee8 c2043e68=0A=
buffer_prepare: sglist:fab44000 num_pages:203=0A=
buffer_queue=0A=
buffer_queue c3c1c000=0A=
buffer_activate buf=3Dc3c1c000=0A=
saa7134_set_dmabits=0A=
dmabits: task=3D0x01 ctrl=3D0x01 irq=3D0x3 split=3Dyes=0A=
vb2: qbuf of buffer 0 succeeded=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_QBUF 359696:21:05.00547687 =
index=3D0, type=3Dvid-cap, flags=3D0x00000004, field=3D0, sequence=3D0, =
memory=3Duserptr=0A=
saa7133[0] video (Avermedia PCI: bytesused=3D829440, =
offset/userptr=3D0xb5d97008, length=3D829440=0A=
saa7133[0] video (Avermedia PCI: timecode=3D00:00:00 type=3D0, =
flags=3D0x00000000, frames=3D0, userbits=3D0x00000000=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
saa7133[0]/irq[0,21277691]: r=3D0x1 s=3D0x10 DONE_RA0 | =
RA0=3Dvideo,a,odd,0=0A=
buffer_finish c3c1c000=0A=
vb2: Done processing on buffer 0, state: 2=0A=
buffer_next   (null)=0A=
saa7134_set_dmabits=0A=
dmabits: task=3D0x00 ctrl=3D0x00 irq=3D0x0 split=3Dyes=0A=
saa7133[0]/irq: no (more) work=0A=
video_poll: f2354ee8=0A=
saa7134_dqbuf: f2354ee8 c2043e68=0A=
vb2: dqbuf: Returning done buffer=0A=
vb2: dqbuf of buffer 0, with state 3=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_DQBUF 359696:21:05.00587688 =
index=3D0, type=3Dvid-cap, flags=3D0x00000004, field=3D0, sequence=3D0, =
memory=3Duserptr=0A=
saa7133[0] video (Avermedia PCI: bytesused=3D829440, =
offset/userptr=3D0xb5d97008, length=3D829440=0A=
saa7133[0] video (Avermedia PCI: timecode=3D00:00:00 type=3D0, =
flags=3D0x00000000, frames=3D0, userbits=3D0x00000000=0A=
saa7134_qbuf: f2354ee8 c2043e68=0A=
buffer_prepare: sglist:fab44000 num_pages:203=0A=
buffer_queue=0A=
buffer_queue c3c1c000=0A=
buffer_activate buf=3Dc3c1c000=0A=
saa7134_set_dmabits=0A=
dmabits: task=3D0x01 ctrl=3D0x01 irq=3D0x3 split=3Dyes=0A=
vb2: qbuf of buffer 0 succeeded=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_QBUF 359696:21:05.00587688 =
index=3D0, type=3Dvid-cap, flags=3D0x00000004, field=3D0, sequence=3D0, =
memory=3Duserptr=0A=
saa7133[0] video (Avermedia PCI: bytesused=3D829440, =
offset/userptr=3D0xb5d97008, length=3D829440=0A=
saa7133[0] video (Avermedia PCI: timecode=3D00:00:00 type=3D0, =
flags=3D0x00000000, frames=3D0, userbits=3D0x00000000=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
saa7133[0]/irq[0,21277701]: r=3D0x1 s=3D0x10 DONE_RA0 | =
RA0=3Dvideo,a,odd,0=0A=
buffer_finish c3c1c000=0A=
vb2: Done processing on buffer 0, state: 2=0A=
buffer_next   (null)=0A=
saa7134_set_dmabits=0A=
dmabits: task=3D0x00 ctrl=3D0x00 irq=3D0x0 split=3Dyes=0A=
saa7133[0]/irq: no (more) work=0A=
video_poll: f2354ee8=0A=
saa7134_dqbuf: f2354ee8 c2043e68=0A=
vb2: dqbuf: Returning done buffer=0A=
vb2: dqbuf of buffer 0, with state 3=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_DQBUF 359696:21:05.00627688 =
index=3D0, type=3Dvid-cap, flags=3D0x00000004, field=3D0, sequence=3D0, =
memory=3Duserptr=0A=
saa7133[0] video (Avermedia PCI: bytesused=3D829440, =
offset/userptr=3D0xb5d97008, length=3D829440=0A=
saa7133[0] video (Avermedia PCI: timecode=3D00:00:00 type=3D0, =
flags=3D0x00000000, frames=3D0, userbits=3D0x00000000=0A=
saa7134_qbuf: f2354ee8 c2043e68=0A=
buffer_prepare: sglist:fab44000 num_pages:203=0A=
buffer_queue=0A=
buffer_queue c3c1c000=0A=
buffer_activate buf=3Dc3c1c000=0A=
saa7134_set_dmabits=0A=
dmabits: task=3D0x01 ctrl=3D0x01 irq=3D0x3 split=3Dyes=0A=
vb2: qbuf of buffer 0 succeeded=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_QBUF 359696:21:05.00627688 =
index=3D0, type=3Dvid-cap, flags=3D0x00000004, field=3D0, sequence=3D0, =
memory=3Duserptr=0A=
saa7133[0] video (Avermedia PCI: bytesused=3D829440, =
offset/userptr=3D0xb5d97008, length=3D829440=0A=
saa7133[0] video (Avermedia PCI: timecode=3D00:00:00 type=3D0, =
flags=3D0x00000000, frames=3D0, userbits=3D0x00000000=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
saa7133[0]/irq[0,21277711]: r=3D0x1 s=3D0x10 DONE_RA0 | =
RA0=3Dvideo,a,odd,0=0A=
buffer_finish c3c1c000=0A=
vb2: Done processing on buffer 0, state: 2=0A=
buffer_next   (null)=0A=
saa7134_set_dmabits=0A=
dmabits: task=3D0x00 ctrl=3D0x00 irq=3D0x0 split=3Dyes=0A=
saa7133[0]/irq: no (more) work=0A=
video_poll: f2354ee8=0A=
saa7134_dqbuf: f2354ee8 c2043e68=0A=
vb2: dqbuf: Returning done buffer=0A=
vb2: dqbuf of buffer 0, with state 3=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_DQBUF 359696:21:05.00667688 =
index=3D0, type=3Dvid-cap, flags=3D0x00000004, field=3D0, sequence=3D0, =
memory=3Duserptr=0A=
saa7133[0] video (Avermedia PCI: bytesused=3D829440, =
offset/userptr=3D0xb5d97008, length=3D829440=0A=
saa7133[0] video (Avermedia PCI: timecode=3D00:00:00 type=3D0, =
flags=3D0x00000000, frames=3D0, userbits=3D0x00000000=0A=
saa7134_qbuf: f2354ee8 c2043e68=0A=
buffer_prepare: sglist:fab44000 num_pages:203=0A=
buffer_queue=0A=
buffer_queue c3c1c000=0A=
buffer_activate buf=3Dc3c1c000=0A=
saa7134_set_dmabits=0A=
dmabits: task=3D0x01 ctrl=3D0x01 irq=3D0x3 split=3Dyes=0A=
vb2: qbuf of buffer 0 succeeded=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_QBUF 359696:21:05.00667688 =
index=3D0, type=3Dvid-cap, flags=3D0x00000004, field=3D0, sequence=3D0, =
memory=3Duserptr=0A=
saa7133[0] video (Avermedia PCI: bytesused=3D829440, =
offset/userptr=3D0xb5d97008, length=3D829440=0A=
saa7133[0] video (Avermedia PCI: timecode=3D00:00:00 type=3D0, =
flags=3D0x00000000, frames=3D0, userbits=3D0x00000000=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
saa7133[0]/irq[0,21277721]: r=3D0x1 s=3D0x10 DONE_RA0 | =
RA0=3Dvideo,a,odd,0=0A=
buffer_finish c3c1c000=0A=
vb2: Done processing on buffer 0, state: 2=0A=
buffer_next   (null)=0A=
saa7134_set_dmabits=0A=
dmabits: task=3D0x00 ctrl=3D0x00 irq=3D0x0 split=3Dyes=0A=
saa7133[0]/irq: no (more) work=0A=
video_poll: f2354ee8=0A=
saa7134_dqbuf: f2354ee8 c2043e68=0A=
vb2: dqbuf: Returning done buffer=0A=
vb2: dqbuf of buffer 0, with state 3=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_DQBUF 359696:21:05.00707689 =
index=3D0, type=3Dvid-cap, flags=3D0x00000004, field=3D0, sequence=3D0, =
memory=3Duserptr=0A=
saa7133[0] video (Avermedia PCI: bytesused=3D829440, =
offset/userptr=3D0xb5d97008, length=3D829440=0A=
saa7133[0] video (Avermedia PCI: timecode=3D00:00:00 type=3D0, =
flags=3D0x00000000, frames=3D0, userbits=3D0x00000000=0A=
saa7134_qbuf: f2354ee8 c2043e68=0A=
buffer_prepare: sglist:fab44000 num_pages:203=0A=
buffer_queue=0A=
buffer_queue c3c1c000=0A=
buffer_activate buf=3Dc3c1c000=0A=
saa7134_set_dmabits=0A=
dmabits: task=3D0x01 ctrl=3D0x01 irq=3D0x3 split=3Dyes=0A=
vb2: qbuf of buffer 0 succeeded=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_QBUF 359696:21:05.00707689 =
index=3D0, type=3Dvid-cap, flags=3D0x00000004, field=3D0, sequence=3D0, =
memory=3Duserptr=0A=
saa7133[0] video (Avermedia PCI: bytesused=3D829440, =
offset/userptr=3D0xb5d97008, length=3D829440=0A=
saa7133[0] video (Avermedia PCI: timecode=3D00:00:00 type=3D0, =
flags=3D0x00000000, frames=3D0, userbits=3D0x00000000=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
saa7133[0]/irq[0,21277731]: r=3D0x1 s=3D0x10 DONE_RA0 | =
RA0=3Dvideo,a,odd,0=0A=
buffer_finish c3c1c000=0A=
vb2: Done processing on buffer 0, state: 2=0A=
buffer_next   (null)=0A=
saa7134_set_dmabits=0A=
dmabits: task=3D0x00 ctrl=3D0x00 irq=3D0x0 split=3Dyes=0A=
saa7133[0]/irq: no (more) work=0A=
video_poll: f2354ee8=0A=
saa7134_dqbuf: f2354ee8 c2043e68=0A=
vb2: dqbuf: Returning done buffer=0A=
vb2: dqbuf of buffer 0, with state 3=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_DQBUF 359696:21:05.00747690 =
index=3D0, type=3Dvid-cap, flags=3D0x00000004, field=3D0, sequence=3D0, =
memory=3Duserptr=0A=
saa7133[0] video (Avermedia PCI: bytesused=3D829440, =
offset/userptr=3D0xb5d97008, length=3D829440=0A=
saa7133[0] video (Avermedia PCI: timecode=3D00:00:00 type=3D0, =
flags=3D0x00000000, frames=3D0, userbits=3D0x00000000=0A=
saa7134_qbuf: f2354ee8 c2043e68=0A=
buffer_prepare: sglist:fab44000 num_pages:203=0A=
buffer_queue=0A=
buffer_queue c3c1c000=0A=
buffer_activate buf=3Dc3c1c000=0A=
saa7134_set_dmabits=0A=
dmabits: task=3D0x01 ctrl=3D0x01 irq=3D0x3 split=3Dyes=0A=
vb2: qbuf of buffer 0 succeeded=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_QBUF 359696:21:05.00747690 =
index=3D0, type=3Dvid-cap, flags=3D0x00000004, field=3D0, sequence=3D0, =
memory=3Duserptr=0A=
saa7133[0] video (Avermedia PCI: bytesused=3D829440, =
offset/userptr=3D0xb5d97008, length=3D829440=0A=
saa7133[0] video (Avermedia PCI: timecode=3D00:00:00 type=3D0, =
flags=3D0x00000000, frames=3D0, userbits=3D0x00000000=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
saa7133[0]/irq[0,21277741]: r=3D0x1 s=3D0x10 DONE_RA0 | =
RA0=3Dvideo,a,odd,0=0A=
buffer_finish c3c1c000=0A=
vb2: Done processing on buffer 0, state: 2=0A=
buffer_next   (null)=0A=
saa7134_set_dmabits=0A=
dmabits: task=3D0x00 ctrl=3D0x00 irq=3D0x0 split=3Dyes=0A=
saa7133[0]/irq: no (more) work=0A=
video_poll: f2354ee8=0A=
saa7134_dqbuf: f2354ee8 c2043e68=0A=
vb2: dqbuf: Returning done buffer=0A=
vb2: dqbuf of buffer 0, with state 3=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_DQBUF 359696:21:05.00787690 =
index=3D0, type=3Dvid-cap, flags=3D0x00000004, field=3D0, sequence=3D0, =
memory=3Duserptr=0A=
saa7133[0] video (Avermedia PCI: bytesused=3D829440, =
offset/userptr=3D0xb5d97008, length=3D829440=0A=
saa7133[0] video (Avermedia PCI: timecode=3D00:00:00 type=3D0, =
flags=3D0x00000000, frames=3D0, userbits=3D0x00000000=0A=
saa7134_qbuf: f2354ee8 c2043e68=0A=
buffer_prepare: sglist:fab44000 num_pages:203=0A=
buffer_queue=0A=
buffer_queue c3c1c000=0A=
buffer_activate buf=3Dc3c1c000=0A=
saa7134_set_dmabits=0A=
dmabits: task=3D0x01 ctrl=3D0x01 irq=3D0x3 split=3Dyes=0A=
vb2: qbuf of buffer 0 succeeded=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_QBUF 359696:21:05.00787690 =
index=3D0, type=3Dvid-cap, flags=3D0x00000004, field=3D0, sequence=3D0, =
memory=3Duserptr=0A=
saa7133[0] video (Avermedia PCI: bytesused=3D829440, =
offset/userptr=3D0xb5d97008, length=3D829440=0A=
saa7133[0] video (Avermedia PCI: timecode=3D00:00:00 type=3D0, =
flags=3D0x00000000, frames=3D0, userbits=3D0x00000000=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
saa7133[0]/irq[0,21277751]: r=3D0x1 s=3D0x10 DONE_RA0 | =
RA0=3Dvideo,a,odd,0=0A=
buffer_finish c3c1c000=0A=
vb2: Done processing on buffer 0, state: 2=0A=
buffer_next   (null)=0A=
saa7134_set_dmabits=0A=
dmabits: task=3D0x00 ctrl=3D0x00 irq=3D0x0 split=3Dyes=0A=
saa7133[0]/irq: no (more) work=0A=
video_poll: f2354ee8=0A=
saa7134_dqbuf: f2354ee8 c2043e68=0A=
vb2: dqbuf: Returning done buffer=0A=
vb2: dqbuf of buffer 0, with state 3=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_DQBUF 359696:21:05.00827691 =
index=3D0, type=3Dvid-cap, flags=3D0x00000004, field=3D0, sequence=3D0, =
memory=3Duserptr=0A=
saa7133[0] video (Avermedia PCI: bytesused=3D829440, =
offset/userptr=3D0xb5d97008, length=3D829440=0A=
saa7133[0] video (Avermedia PCI: timecode=3D00:00:00 type=3D0, =
flags=3D0x00000000, frames=3D0, userbits=3D0x00000000=0A=
saa7134_qbuf: f2354ee8 c2043e68=0A=
buffer_prepare: sglist:fab44000 num_pages:203=0A=
buffer_queue=0A=
buffer_queue c3c1c000=0A=
buffer_activate buf=3Dc3c1c000=0A=
saa7134_set_dmabits=0A=
dmabits: task=3D0x01 ctrl=3D0x01 irq=3D0x3 split=3Dyes=0A=
vb2: qbuf of buffer 0 succeeded=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_QBUF 359696:21:05.00827691 =
index=3D0, type=3Dvid-cap, flags=3D0x00000004, field=3D0, sequence=3D0, =
memory=3Duserptr=0A=
saa7133[0] video (Avermedia PCI: bytesused=3D829440, =
offset/userptr=3D0xb5d97008, length=3D829440=0A=
saa7133[0] video (Avermedia PCI: timecode=3D00:00:00 type=3D0, =
flags=3D0x00000000, frames=3D0, userbits=3D0x00000000=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
saa7133[0]/irq[0,21277761]: r=3D0x1 s=3D0x90 DONE_RA0 | =
RA0=3Dvideo,a,odd,0=0A=
buffer_finish c3c1c000=0A=
vb2: Done processing on buffer 0, state: 2=0A=
buffer_next   (null)=0A=
saa7134_set_dmabits=0A=
dmabits: task=3D0x00 ctrl=3D0x00 irq=3D0x0 split=3Dyes=0A=
saa7133[0]/irq: no (more) work=0A=
video_poll: f2354ee8=0A=
saa7134_dqbuf: f2354ee8 c2043e68=0A=
vb2: dqbuf: Returning done buffer=0A=
vb2: dqbuf of buffer 0, with state 3=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_DQBUF 359696:21:05.00867691 =
index=3D0, type=3Dvid-cap, flags=3D0x00000004, field=3D0, sequence=3D0, =
memory=3Duserptr=0A=
saa7133[0] video (Avermedia PCI: bytesused=3D829440, =
offset/userptr=3D0xb5d97008, length=3D829440=0A=
saa7133[0] video (Avermedia PCI: timecode=3D00:00:00 type=3D0, =
flags=3D0x00000000, frames=3D0, userbits=3D0x00000000=0A=
saa7134_qbuf: f2354ee8 c2043e68=0A=
buffer_prepare: sglist:fab44000 num_pages:203=0A=
buffer_queue=0A=
buffer_queue c3c1c000=0A=
buffer_activate buf=3Dc3c1c000=0A=
saa7134_set_dmabits=0A=
dmabits: task=3D0x01 ctrl=3D0x01 irq=3D0x3 split=3Dyes=0A=
vb2: qbuf of buffer 0 succeeded=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_QBUF 359696:21:05.00867691 =
index=3D0, type=3Dvid-cap, flags=3D0x00000004, field=3D0, sequence=3D0, =
memory=3Duserptr=0A=
saa7133[0] video (Avermedia PCI: bytesused=3D829440, =
offset/userptr=3D0xb5d97008, length=3D829440=0A=
saa7133[0] video (Avermedia PCI: timecode=3D00:00:00 type=3D0, =
flags=3D0x00000000, frames=3D0, userbits=3D0x00000000=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
saa7133[0]/irq[0,21277771]: r=3D0x1 s=3D0x10 DONE_RA0 | =
RA0=3Dvideo,a,odd,0=0A=
buffer_finish c3c1c000=0A=
vb2: Done processing on buffer 0, state: 2=0A=
buffer_next   (null)=0A=
saa7134_set_dmabits=0A=
dmabits: task=3D0x00 ctrl=3D0x00 irq=3D0x0 split=3Dyes=0A=
saa7133[0]/irq: no (more) work=0A=
video_poll: f2354ee8=0A=
saa7134_dqbuf: f2354ee8 c2043e68=0A=
vb2: dqbuf: Returning done buffer=0A=
vb2: dqbuf of buffer 0, with state 3=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_DQBUF 359696:21:05.00907691 =
index=3D0, type=3Dvid-cap, flags=3D0x00000004, field=3D0, sequence=3D0, =
memory=3Duserptr=0A=
saa7133[0] video (Avermedia PCI: bytesused=3D829440, =
offset/userptr=3D0xb5d97008, length=3D829440=0A=
saa7133[0] video (Avermedia PCI: timecode=3D00:00:00 type=3D0, =
flags=3D0x00000000, frames=3D0, userbits=3D0x00000000=0A=
saa7134_qbuf: f2354ee8 c2043e68=0A=
buffer_prepare: sglist:fab44000 num_pages:203=0A=
buffer_queue=0A=
buffer_queue c3c1c000=0A=
buffer_activate buf=3Dc3c1c000=0A=
saa7134_set_dmabits=0A=
dmabits: task=3D0x01 ctrl=3D0x01 irq=3D0x3 split=3Dyes=0A=
vb2: qbuf of buffer 0 succeeded=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_QBUF 359696:21:05.00907691 =
index=3D0, type=3Dvid-cap, flags=3D0x00000004, field=3D0, sequence=3D0, =
memory=3Duserptr=0A=
saa7133[0] video (Avermedia PCI: bytesused=3D829440, =
offset/userptr=3D0xb5d97008, length=3D829440=0A=
saa7133[0] video (Avermedia PCI: timecode=3D00:00:00 type=3D0, =
flags=3D0x00000000, frames=3D0, userbits=3D0x00000000=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
saa7133[0]/irq[0,21277781]: r=3D0x1 s=3D0x10 DONE_RA0 | =
RA0=3Dvideo,a,odd,0=0A=
buffer_finish c3c1c000=0A=
vb2: Done processing on buffer 0, state: 2=0A=
buffer_next   (null)=0A=
saa7134_set_dmabits=0A=
dmabits: task=3D0x00 ctrl=3D0x00 irq=3D0x0 split=3Dyes=0A=
saa7133[0]/irq: no (more) work=0A=
video_poll: f2354ee8=0A=
saa7134_dqbuf: f2354ee8 c2043e68=0A=
vb2: dqbuf: Returning done buffer=0A=
vb2: dqbuf of buffer 0, with state 3=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_DQBUF 359696:21:05.00947693 =
index=3D0, type=3Dvid-cap, flags=3D0x00000004, field=3D0, sequence=3D0, =
memory=3Duserptr=0A=
saa7133[0] video (Avermedia PCI: bytesused=3D829440, =
offset/userptr=3D0xb5d97008, length=3D829440=0A=
saa7133[0] video (Avermedia PCI: timecode=3D00:00:00 type=3D0, =
flags=3D0x00000000, frames=3D0, userbits=3D0x00000000=0A=
saa7134_qbuf: f2354ee8 c2043e68=0A=
buffer_prepare: sglist:fab44000 num_pages:203=0A=
buffer_queue=0A=
buffer_queue c3c1c000=0A=
buffer_activate buf=3Dc3c1c000=0A=
saa7134_set_dmabits=0A=
dmabits: task=3D0x01 ctrl=3D0x01 irq=3D0x3 split=3Dyes=0A=
vb2: qbuf of buffer 0 succeeded=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_QBUF 359696:21:05.00947693 =
index=3D0, type=3Dvid-cap, flags=3D0x00000004, field=3D0, sequence=3D0, =
memory=3Duserptr=0A=
saa7133[0] video (Avermedia PCI: bytesused=3D829440, =
offset/userptr=3D0xb5d97008, length=3D829440=0A=
saa7133[0] video (Avermedia PCI: timecode=3D00:00:00 type=3D0, =
flags=3D0x00000000, frames=3D0, userbits=3D0x00000000=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
saa7133[0]/irq[0,21277791]: r=3D0x1 s=3D0x10 DONE_RA0 | =
RA0=3Dvideo,a,odd,0=0A=
buffer_finish c3c1c000=0A=
vb2: Done processing on buffer 0, state: 2=0A=
buffer_next   (null)=0A=
saa7134_set_dmabits=0A=
dmabits: task=3D0x00 ctrl=3D0x00 irq=3D0x0 split=3Dyes=0A=
saa7133[0]/irq: no (more) work=0A=
video_poll: f2354ee8=0A=
saa7134_dqbuf: f2354ee8 c2043e68=0A=
vb2: dqbuf: Returning done buffer=0A=
vb2: dqbuf of buffer 0, with state 3=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_DQBUF 359696:21:05.00987693 =
index=3D0, type=3Dvid-cap, flags=3D0x00000004, field=3D0, sequence=3D0, =
memory=3Duserptr=0A=
saa7133[0] video (Avermedia PCI: bytesused=3D829440, =
offset/userptr=3D0xb5d97008, length=3D829440=0A=
saa7133[0] video (Avermedia PCI: timecode=3D00:00:00 type=3D0, =
flags=3D0x00000000, frames=3D0, userbits=3D0x00000000=0A=
saa7134_qbuf: f2354ee8 c2043e68=0A=
buffer_prepare: sglist:fab44000 num_pages:203=0A=
buffer_queue=0A=
buffer_queue c3c1c000=0A=
buffer_activate buf=3Dc3c1c000=0A=
saa7134_set_dmabits=0A=
dmabits: task=3D0x01 ctrl=3D0x01 irq=3D0x3 split=3Dyes=0A=
vb2: qbuf of buffer 0 succeeded=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_QBUF 359696:21:05.00987693 =
index=3D0, type=3Dvid-cap, flags=3D0x00000004, field=3D0, sequence=3D0, =
memory=3Duserptr=0A=
saa7133[0] video (Avermedia PCI: bytesused=3D829440, =
offset/userptr=3D0xb5d97008, length=3D829440=0A=
saa7133[0] video (Avermedia PCI: timecode=3D00:00:00 type=3D0, =
flags=3D0x00000000, frames=3D0, userbits=3D0x00000000=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
saa7133[0]/irq[0,21277801]: r=3D0x1 s=3D0x10 DONE_RA0 | =
RA0=3Dvideo,a,odd,0=0A=
buffer_finish c3c1c000=0A=
vb2: Done processing on buffer 0, state: 2=0A=
buffer_next   (null)=0A=
saa7134_set_dmabits=0A=
dmabits: task=3D0x00 ctrl=3D0x00 irq=3D0x0 split=3Dyes=0A=
saa7133[0]/irq: no (more) work=0A=
video_poll: f2354ee8=0A=
saa7134_dqbuf: f2354ee8 c2043e68=0A=
vb2: dqbuf: Returning done buffer=0A=
vb2: dqbuf of buffer 0, with state 3=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_DQBUF 359696:21:06.00027693 =
index=3D0, type=3Dvid-cap, flags=3D0x00000004, field=3D0, sequence=3D0, =
memory=3Duserptr=0A=
saa7133[0] video (Avermedia PCI: bytesused=3D829440, =
offset/userptr=3D0xb5d97008, length=3D829440=0A=
saa7133[0] video (Avermedia PCI: timecode=3D00:00:00 type=3D0, =
flags=3D0x00000000, frames=3D0, userbits=3D0x00000000=0A=
saa7134_qbuf: f2354ee8 c2043e68=0A=
buffer_prepare: sglist:fab44000 num_pages:203=0A=
buffer_queue=0A=
buffer_queue c3c1c000=0A=
buffer_activate buf=3Dc3c1c000=0A=
saa7134_set_dmabits=0A=
dmabits: task=3D0x01 ctrl=3D0x01 irq=3D0x3 split=3Dyes=0A=
vb2: qbuf of buffer 0 succeeded=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_QBUF 359696:21:06.00027693 =
index=3D0, type=3Dvid-cap, flags=3D0x00000004, field=3D0, sequence=3D0, =
memory=3Duserptr=0A=
saa7133[0] video (Avermedia PCI: bytesused=3D829440, =
offset/userptr=3D0xb5d97008, length=3D829440=0A=
saa7133[0] video (Avermedia PCI: timecode=3D00:00:00 type=3D0, =
flags=3D0x00000000, frames=3D0, userbits=3D0x00000000=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
saa7133[0]/irq[0,21277811]: r=3D0x1 s=3D0x10 DONE_RA0 | =
RA0=3Dvideo,a,odd,0=0A=
buffer_finish c3c1c000=0A=
vb2: Done processing on buffer 0, state: 2=0A=
buffer_next   (null)=0A=
saa7134_set_dmabits=0A=
dmabits: task=3D0x00 ctrl=3D0x00 irq=3D0x0 split=3Dyes=0A=
saa7133[0]/irq: no (more) work=0A=
video_poll: f2354ee8=0A=
saa7134_dqbuf: f2354ee8 c2043e68=0A=
vb2: dqbuf: Returning done buffer=0A=
vb2: dqbuf of buffer 0, with state 3=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_DQBUF 359696:21:06.00067694 =
index=3D0, type=3Dvid-cap, flags=3D0x00000004, field=3D0, sequence=3D0, =
memory=3Duserptr=0A=
saa7133[0] video (Avermedia PCI: bytesused=3D829440, =
offset/userptr=3D0xb5d97008, length=3D829440=0A=
saa7133[0] video (Avermedia PCI: timecode=3D00:00:00 type=3D0, =
flags=3D0x00000000, frames=3D0, userbits=3D0x00000000=0A=
saa7134_qbuf: f2354ee8 c2043e68=0A=
buffer_prepare: sglist:fab44000 num_pages:203=0A=
buffer_queue=0A=
buffer_queue c3c1c000=0A=
buffer_activate buf=3Dc3c1c000=0A=
saa7134_set_dmabits=0A=
dmabits: task=3D0x01 ctrl=3D0x01 irq=3D0x3 split=3Dyes=0A=
vb2: qbuf of buffer 0 succeeded=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_QBUF 359696:21:06.00067694 =
index=3D0, type=3Dvid-cap, flags=3D0x00000004, field=3D0, sequence=3D0, =
memory=3Duserptr=0A=
saa7133[0] video (Avermedia PCI: bytesused=3D829440, =
offset/userptr=3D0xb5d97008, length=3D829440=0A=
saa7133[0] video (Avermedia PCI: timecode=3D00:00:00 type=3D0, =
flags=3D0x00000000, frames=3D0, userbits=3D0x00000000=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
saa7133[0]/irq[0,21277821]: r=3D0x1 s=3D0x10 DONE_RA0 | =
RA0=3Dvideo,a,odd,0=0A=
buffer_finish c3c1c000=0A=
vb2: Done processing on buffer 0, state: 2=0A=
buffer_next   (null)=0A=
saa7134_set_dmabits=0A=
dmabits: task=3D0x00 ctrl=3D0x00 irq=3D0x0 split=3Dyes=0A=
saa7133[0]/irq: no (more) work=0A=
video_poll: f2354ee8=0A=
saa7134_dqbuf: f2354ee8 c2043e68=0A=
vb2: dqbuf: Returning done buffer=0A=
vb2: dqbuf of buffer 0, with state 3=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_DQBUF 359696:21:06.00107695 =
index=3D0, type=3Dvid-cap, flags=3D0x00000004, field=3D0, sequence=3D0, =
memory=3Duserptr=0A=
saa7133[0] video (Avermedia PCI: bytesused=3D829440, =
offset/userptr=3D0xb5d97008, length=3D829440=0A=
saa7133[0] video (Avermedia PCI: timecode=3D00:00:00 type=3D0, =
flags=3D0x00000000, frames=3D0, userbits=3D0x00000000=0A=
saa7134_qbuf: f2354ee8 c2043e68=0A=
buffer_prepare: sglist:fab44000 num_pages:203=0A=
buffer_queue=0A=
buffer_queue c3c1c000=0A=
buffer_activate buf=3Dc3c1c000=0A=
saa7134_set_dmabits=0A=
dmabits: task=3D0x01 ctrl=3D0x01 irq=3D0x3 split=3Dyes=0A=
vb2: qbuf of buffer 0 succeeded=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_QBUF 359696:21:06.00107695 =
index=3D0, type=3Dvid-cap, flags=3D0x00000004, field=3D0, sequence=3D0, =
memory=3Duserptr=0A=
saa7133[0] video (Avermedia PCI: bytesused=3D829440, =
offset/userptr=3D0xb5d97008, length=3D829440=0A=
saa7133[0] video (Avermedia PCI: timecode=3D00:00:00 type=3D0, =
flags=3D0x00000000, frames=3D0, userbits=3D0x00000000=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
saa7133[0]/irq[0,21277831]: r=3D0x1 s=3D0x10 DONE_RA0 | =
RA0=3Dvideo,a,odd,0=0A=
buffer_finish c3c1c000=0A=
vb2: Done processing on buffer 0, state: 2=0A=
buffer_next   (null)=0A=
saa7134_set_dmabits=0A=
dmabits: task=3D0x00 ctrl=3D0x00 irq=3D0x0 split=3Dyes=0A=
saa7133[0]/irq: no (more) work=0A=
video_poll: f2354ee8=0A=
saa7134_dqbuf: f2354ee8 c2043e68=0A=
vb2: dqbuf: Returning done buffer=0A=
vb2: dqbuf of buffer 0, with state 3=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_DQBUF 359696:21:06.00147696 =
index=3D0, type=3Dvid-cap, flags=3D0x00000004, field=3D0, sequence=3D0, =
memory=3Duserptr=0A=
saa7133[0] video (Avermedia PCI: bytesused=3D829440, =
offset/userptr=3D0xb5d97008, length=3D829440=0A=
saa7133[0] video (Avermedia PCI: timecode=3D00:00:00 type=3D0, =
flags=3D0x00000000, frames=3D0, userbits=3D0x00000000=0A=
saa7134_qbuf: f2354ee8 c2043e68=0A=
buffer_prepare: sglist:fab44000 num_pages:203=0A=
buffer_queue=0A=
buffer_queue c3c1c000=0A=
buffer_activate buf=3Dc3c1c000=0A=
saa7134_set_dmabits=0A=
dmabits: task=3D0x01 ctrl=3D0x01 irq=3D0x3 split=3Dyes=0A=
vb2: qbuf of buffer 0 succeeded=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_QBUF 359696:21:06.00147696 =
index=3D0, type=3Dvid-cap, flags=3D0x00000004, field=3D0, sequence=3D0, =
memory=3Duserptr=0A=
saa7133[0] video (Avermedia PCI: bytesused=3D829440, =
offset/userptr=3D0xb5d97008, length=3D829440=0A=
saa7133[0] video (Avermedia PCI: timecode=3D00:00:00 type=3D0, =
flags=3D0x00000000, frames=3D0, userbits=3D0x00000000=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
saa7133[0]/irq[0,21277841]: r=3D0x1 s=3D0x10 DONE_RA0 | =
RA0=3Dvideo,a,odd,0=0A=
buffer_finish c3c1c000=0A=
vb2: Done processing on buffer 0, state: 2=0A=
buffer_next   (null)=0A=
saa7134_set_dmabits=0A=
dmabits: task=3D0x00 ctrl=3D0x00 irq=3D0x0 split=3Dyes=0A=
saa7133[0]/irq: no (more) work=0A=
video_poll: f2354ee8=0A=
saa7134_dqbuf: f2354ee8 c2043e68=0A=
vb2: dqbuf: Returning done buffer=0A=
vb2: dqbuf of buffer 0, with state 3=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_DQBUF 359696:21:06.00187696 =
index=3D0, type=3Dvid-cap, flags=3D0x00000004, field=3D0, sequence=3D0, =
memory=3Duserptr=0A=
saa7133[0] video (Avermedia PCI: bytesused=3D829440, =
offset/userptr=3D0xb5d97008, length=3D829440=0A=
saa7133[0] video (Avermedia PCI: timecode=3D00:00:00 type=3D0, =
flags=3D0x00000000, frames=3D0, userbits=3D0x00000000=0A=
saa7134_qbuf: f2354ee8 c2043e68=0A=
buffer_prepare: sglist:fab44000 num_pages:203=0A=
buffer_queue=0A=
buffer_queue c3c1c000=0A=
buffer_activate buf=3Dc3c1c000=0A=
saa7134_set_dmabits=0A=
dmabits: task=3D0x01 ctrl=3D0x01 irq=3D0x3 split=3Dyes=0A=
vb2: qbuf of buffer 0 succeeded=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_QBUF 359696:21:06.00187696 =
index=3D0, type=3Dvid-cap, flags=3D0x00000004, field=3D0, sequence=3D0, =
memory=3Duserptr=0A=
saa7133[0] video (Avermedia PCI: bytesused=3D829440, =
offset/userptr=3D0xb5d97008, length=3D829440=0A=
saa7133[0] video (Avermedia PCI: timecode=3D00:00:00 type=3D0, =
flags=3D0x00000000, frames=3D0, userbits=3D0x00000000=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
saa7133[0]/irq[0,21277851]: r=3D0x1 s=3D0x10 DONE_RA0 | =
RA0=3Dvideo,a,odd,0=0A=
buffer_finish c3c1c000=0A=
vb2: Done processing on buffer 0, state: 2=0A=
buffer_next   (null)=0A=
saa7134_set_dmabits=0A=
dmabits: task=3D0x00 ctrl=3D0x00 irq=3D0x0 split=3Dyes=0A=
saa7133[0]/irq: no (more) work=0A=
video_poll: f2354ee8=0A=
saa7134_dqbuf: f2354ee8 c2043e68=0A=
vb2: dqbuf: Returning done buffer=0A=
vb2: dqbuf of buffer 0, with state 3=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_DQBUF 359696:21:06.00227697 =
index=3D0, type=3Dvid-cap, flags=3D0x00000004, field=3D0, sequence=3D0, =
memory=3Duserptr=0A=
saa7133[0] video (Avermedia PCI: bytesused=3D829440, =
offset/userptr=3D0xb5d97008, length=3D829440=0A=
saa7133[0] video (Avermedia PCI: timecode=3D00:00:00 type=3D0, =
flags=3D0x00000000, frames=3D0, userbits=3D0x00000000=0A=
saa7134_qbuf: f2354ee8 c2043e68=0A=
buffer_prepare: sglist:fab44000 num_pages:203=0A=
buffer_queue=0A=
buffer_queue c3c1c000=0A=
buffer_activate buf=3Dc3c1c000=0A=
saa7134_set_dmabits=0A=
dmabits: task=3D0x01 ctrl=3D0x01 irq=3D0x3 split=3Dyes=0A=
vb2: qbuf of buffer 0 succeeded=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_QBUF 359696:21:06.00227697 =
index=3D0, type=3Dvid-cap, flags=3D0x00000004, field=3D0, sequence=3D0, =
memory=3Duserptr=0A=
saa7133[0] video (Avermedia PCI: bytesused=3D829440, =
offset/userptr=3D0xb5d97008, length=3D829440=0A=
saa7133[0] video (Avermedia PCI: timecode=3D00:00:00 type=3D0, =
flags=3D0x00000000, frames=3D0, userbits=3D0x00000000=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
saa7133[0]/irq[0,21277861]: r=3D0x1 s=3D0x10 DONE_RA0 | =
RA0=3Dvideo,a,odd,0=0A=
buffer_finish c3c1c000=0A=
vb2: Done processing on buffer 0, state: 2=0A=
buffer_next   (null)=0A=
saa7134_set_dmabits=0A=
dmabits: task=3D0x00 ctrl=3D0x00 irq=3D0x0 split=3Dyes=0A=
saa7133[0]/irq: no (more) work=0A=
video_poll: f2354ee8=0A=
saa7134_dqbuf: f2354ee8 c2043e68=0A=
vb2: dqbuf: Returning done buffer=0A=
vb2: dqbuf of buffer 0, with state 3=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_DQBUF 359696:21:06.00267697 =
index=3D0, type=3Dvid-cap, flags=3D0x00000004, field=3D0, sequence=3D0, =
memory=3Duserptr=0A=
saa7133[0] video (Avermedia PCI: bytesused=3D829440, =
offset/userptr=3D0xb5d97008, length=3D829440=0A=
saa7133[0] video (Avermedia PCI: timecode=3D00:00:00 type=3D0, =
flags=3D0x00000000, frames=3D0, userbits=3D0x00000000=0A=
saa7134_qbuf: f2354ee8 c2043e68=0A=
buffer_prepare: sglist:fab44000 num_pages:203=0A=
buffer_queue=0A=
buffer_queue c3c1c000=0A=
buffer_activate buf=3Dc3c1c000=0A=
saa7134_set_dmabits=0A=
dmabits: task=3D0x01 ctrl=3D0x01 irq=3D0x3 split=3Dyes=0A=
vb2: qbuf of buffer 0 succeeded=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_QBUF 359696:21:06.00267697 =
index=3D0, type=3Dvid-cap, flags=3D0x00000004, field=3D0, sequence=3D0, =
memory=3Duserptr=0A=
saa7133[0] video (Avermedia PCI: bytesused=3D829440, =
offset/userptr=3D0xb5d97008, length=3D829440=0A=
saa7133[0] video (Avermedia PCI: timecode=3D00:00:00 type=3D0, =
flags=3D0x00000000, frames=3D0, userbits=3D0x00000000=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
saa7133[0]/irq[0,21277871]: r=3D0x1 s=3D0x10 DONE_RA0 | =
RA0=3Dvideo,a,odd,0=0A=
buffer_finish c3c1c000=0A=
vb2: Done processing on buffer 0, state: 2=0A=
buffer_next   (null)=0A=
saa7134_set_dmabits=0A=
dmabits: task=3D0x00 ctrl=3D0x00 irq=3D0x0 split=3Dyes=0A=
saa7133[0]/irq: no (more) work=0A=
video_poll: f2354ee8=0A=
saa7134_dqbuf: f2354ee8 c2043e68=0A=
vb2: dqbuf: Returning done buffer=0A=
vb2: dqbuf of buffer 0, with state 3=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_DQBUF 359696:21:06.00307698 =
index=3D0, type=3Dvid-cap, flags=3D0x00000004, field=3D0, sequence=3D0, =
memory=3Duserptr=0A=
saa7133[0] video (Avermedia PCI: bytesused=3D829440, =
offset/userptr=3D0xb5d97008, length=3D829440=0A=
saa7133[0] video (Avermedia PCI: timecode=3D00:00:00 type=3D0, =
flags=3D0x00000000, frames=3D0, userbits=3D0x00000000=0A=
saa7134_qbuf: f2354ee8 c2043e68=0A=
buffer_prepare: sglist:fab44000 num_pages:203=0A=
buffer_queue=0A=
buffer_queue c3c1c000=0A=
buffer_activate buf=3Dc3c1c000=0A=
saa7134_set_dmabits=0A=
dmabits: task=3D0x01 ctrl=3D0x01 irq=3D0x3 split=3Dyes=0A=
vb2: qbuf of buffer 0 succeeded=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_QBUF 359696:21:06.00307698 =
index=3D0, type=3Dvid-cap, flags=3D0x00000004, field=3D0, sequence=3D0, =
memory=3Duserptr=0A=
saa7133[0] video (Avermedia PCI: bytesused=3D829440, =
offset/userptr=3D0xb5d97008, length=3D829440=0A=
saa7133[0] video (Avermedia PCI: timecode=3D00:00:00 type=3D0, =
flags=3D0x00000000, frames=3D0, userbits=3D0x00000000=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
saa7133[0]/irq[0,21277881]: r=3D0x1 s=3D0x10 DONE_RA0 | =
RA0=3Dvideo,a,odd,0=0A=
buffer_finish c3c1c000=0A=
vb2: Done processing on buffer 0, state: 2=0A=
buffer_next   (null)=0A=
saa7134_set_dmabits=0A=
dmabits: task=3D0x00 ctrl=3D0x00 irq=3D0x0 split=3Dyes=0A=
saa7133[0]/irq: no (more) work=0A=
video_poll: f2354ee8=0A=
saa7134_dqbuf: f2354ee8 c2043e68=0A=
vb2: dqbuf: Returning done buffer=0A=
vb2: dqbuf of buffer 0, with state 3=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_DQBUF 359696:21:06.00347698 =
index=3D0, type=3Dvid-cap, flags=3D0x00000004, field=3D0, sequence=3D0, =
memory=3Duserptr=0A=
saa7133[0] video (Avermedia PCI: bytesused=3D829440, =
offset/userptr=3D0xb5d97008, length=3D829440=0A=
saa7133[0] video (Avermedia PCI: timecode=3D00:00:00 type=3D0, =
flags=3D0x00000000, frames=3D0, userbits=3D0x00000000=0A=
saa7134_qbuf: f2354ee8 c2043e68=0A=
buffer_prepare: sglist:fab44000 num_pages:203=0A=
buffer_queue=0A=
buffer_queue c3c1c000=0A=
buffer_activate buf=3Dc3c1c000=0A=
saa7134_set_dmabits=0A=
dmabits: task=3D0x01 ctrl=3D0x01 irq=3D0x3 split=3Dyes=0A=
vb2: qbuf of buffer 0 succeeded=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_QBUF 359696:21:06.00347698 =
index=3D0, type=3Dvid-cap, flags=3D0x00000004, field=3D0, sequence=3D0, =
memory=3Duserptr=0A=
saa7133[0] video (Avermedia PCI: bytesused=3D829440, =
offset/userptr=3D0xb5d97008, length=3D829440=0A=
saa7133[0] video (Avermedia PCI: timecode=3D00:00:00 type=3D0, =
flags=3D0x00000000, frames=3D0, userbits=3D0x00000000=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
saa7133[0]/irq[0,21277891]: r=3D0x1 s=3D0x10 DONE_RA0 | =
RA0=3Dvideo,a,odd,0=0A=
buffer_finish c3c1c000=0A=
vb2: Done processing on buffer 0, state: 2=0A=
buffer_next   (null)=0A=
saa7134_set_dmabits=0A=
dmabits: task=3D0x00 ctrl=3D0x00 irq=3D0x0 split=3Dyes=0A=
saa7133[0]/irq: no (more) work=0A=
video_poll: f2354ee8=0A=
saa7134_dqbuf: f2354ee8 c2043e68=0A=
vb2: dqbuf: Returning done buffer=0A=
vb2: dqbuf of buffer 0, with state 3=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_DQBUF 359696:21:06.00387702 =
index=3D0, type=3Dvid-cap, flags=3D0x00000004, field=3D0, sequence=3D0, =
memory=3Duserptr=0A=
saa7133[0] video (Avermedia PCI: bytesused=3D829440, =
offset/userptr=3D0xb5d97008, length=3D829440=0A=
saa7133[0] video (Avermedia PCI: timecode=3D00:00:00 type=3D0, =
flags=3D0x00000000, frames=3D0, userbits=3D0x00000000=0A=
saa7134_qbuf: f2354ee8 c2043e68=0A=
buffer_prepare: sglist:fab44000 num_pages:203=0A=
buffer_queue=0A=
buffer_queue c3c1c000=0A=
buffer_activate buf=3Dc3c1c000=0A=
saa7134_set_dmabits=0A=
dmabits: task=3D0x01 ctrl=3D0x01 irq=3D0x3 split=3Dyes=0A=
vb2: qbuf of buffer 0 succeeded=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_QBUF 359696:21:06.00387702 =
index=3D0, type=3Dvid-cap, flags=3D0x00000004, field=3D0, sequence=3D0, =
memory=3Duserptr=0A=
saa7133[0] video (Avermedia PCI: bytesused=3D829440, =
offset/userptr=3D0xb5d97008, length=3D829440=0A=
saa7133[0] video (Avermedia PCI: timecode=3D00:00:00 type=3D0, =
flags=3D0x00000000, frames=3D0, userbits=3D0x00000000=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_STREAMOFF type=3Dvid-cap=0A=
saa7134_streamoff: f2354ee8=0A=
stop_streaming=0A=
timeout on c3c1c000=0A=
buffer_finish c3c1c000=0A=
vb2: Done processing on buffer 0, state: 2=0A=
buffer_next   (null)=0A=
saa7134_set_dmabits=0A=
dmabits: task=3D0x00 ctrl=3D0x00 irq=3D0x0 split=3Dyes=0A=
vb2: Streamoff successful=0A=
saa7134_reqbufs: f2354ee8 c2043e68=0A=
vb2_dma_sg_put_userptr: Releasing userspace buffer of 203 pages=0A=
vb2_dma_sg_put_userptr: Releasing userspace buffer of 203 pages=0A=
vb2_dma_sg_put_userptr: Releasing userspace buffer of 203 pages=0A=
vb2_dma_sg_put_userptr: Releasing userspace buffer of 203 pages=0A=
queue_setup=0A=
vb2: Allocated 0 buffers, 1 plane(s) each=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_REQBUFS count=3D0, =
type=3Dvid-cap, memory=3Duserptr=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_G_CTRL id=3D0x980900, value=3D128=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_QUERYCTRL id=3D0x980900, =
type=3D1, name=3DBrightness, min/max=3D0/255, step=3D1, default=3D128, =
flags=3D0x00000000=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_G_CTRL id=3D0x980901, value=3D68=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_QUERYCTRL id=3D0x980901, =
type=3D1, name=3DContrast, min/max=3D0/127, step=3D1, default=3D68, =
flags=3D0x00000000=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_G_CTRL id=3D0x980902, value=3D64=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_QUERYCTRL id=3D0x980902, =
type=3D1, name=3DSaturation, min/max=3D0/127, step=3D1, default=3D64, =
flags=3D0x00000000=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_G_CTRL id=3D0x980903, value=3D0=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_QUERYCTRL id=3D0x980903, =
type=3D1, name=3DHue, min/max=3D-128/127, step=3D1, default=3D0, =
flags=3D0x00000000=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_G_CTRL id=3D0x980905, value=3D0=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_QUERYCTRL id=3D0x980905, =
type=3D1, name=3DVolume, min/max=3D-15/15, step=3D1, default=3D0, =
flags=3D0x00000000=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_G_CTRL id=3D0x980909, value=3D1=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_QUERYCTRL id=3D0x980909, =
type=3D2, name=3DMute, min/max=3D0/1, step=3D0, default=3D0, =
flags=3D0x00000000=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_G_CTRL id=3D0x980914, value=3D0=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_QUERYCTRL id=3D0x980914, =
type=3D2, name=3DMirror, min/max=3D0/1, step=3D0, default=3D0, =
flags=3D0x00000000=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_G_CTRL id=3D0x8000000, value=3D0=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_QUERYCTRL id=3D0x8000000, =
type=3D2, name=3DInvert, min/max=3D0/1, step=3D0, default=3D0, =
flags=3D0x00000000=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_G_CTRL id=3D0x8000001, value=3D0=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_QUERYCTRL id=3D0x8000001, =
type=3D1, name=3Dy offset odd field, min/max=3D0/128, step=3D1, =
default=3D0, flags=3D0x00000000=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_G_CTRL id=3D0x8000002, value=3D0=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_QUERYCTRL id=3D0x8000002, =
type=3D1, name=3Dy offset even field, min/max=3D0/128, step=3D1, =
default=3D0, flags=3D0x00000000=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_G_CTRL id=3D0x8000003, value=3D1=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_QUERYCTRL id=3D0x8000003, =
type=3D2, name=3Dautomute, min/max=3D0/1, step=3D0, default=3D1, =
flags=3D0x00000000=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_G_FMT type=3Dvid-cap=0A=
saa7133[0] video (Avermedia PCI: width=3D720, height=3D576, =
format=3DYUYV, field=3Dany, bytesperline=3D1440 sizeimage=3D829440, =
colorspace=3D0=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_TRY_FMT type=3Dvid-cap=0A=
saa7133[0] video (Avermedia PCI: width=3D720, height=3D576, =
format=3DRGB3, field=3Dinterlaced, bytesperline=3D2160 =
sizeimage=3D1244160, colorspace=3D0=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_TRY_FMT type=3Dvid-cap=0A=
saa7133[0] video (Avermedia PCI: width=3D720, height=3D576, =
format=3DBGR3, field=3Dinterlaced, bytesperline=3D2160 =
sizeimage=3D1244160, colorspace=3D0=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_TRY_FMT type=3Dvid-cap=0A=
saa7133[0] video (Avermedia PCI: width=3D720, height=3D576, =
format=3DYU12, field=3Dinterlaced, bytesperline=3D1080 =
sizeimage=3D622080, colorspace=3D0=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_TRY_FMT type=3Dvid-cap=0A=
saa7133[0] video (Avermedia PCI: width=3D720, height=3D576, =
format=3DYV12, field=3Dinterlaced, bytesperline=3D1080 =
sizeimage=3D622080, colorspace=3D0=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_TRY_FMT type=3Dvid-cap=0A=
saa7133[0] video (Avermedia PCI: width=3D720, height=3D576, =
format=3DYUYV, field=3Dinterlaced, bytesperline=3D1440 =
sizeimage=3D829440, colorspace=3D0=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_TRY_FMT type=3Dvid-cap=0A=
saa7133[0] video (Avermedia PCI: width=3D720, height=3D576, =
format=3DUYVY, field=3Dinterlaced, bytesperline=3D1440 =
sizeimage=3D829440, colorspace=3D0=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_TRY_FMT type=3Dvid-cap=0A=
saa7133[0] video (Avermedia PCI: width=3D720, height=3D576, =
format=3DRGBP, field=3Dinterlaced, bytesperline=3D1440 =
sizeimage=3D829440, colorspace=3D0=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_G_FMT type=3Dvid-cap=0A=
saa7133[0] video (Avermedia PCI: width=3D720, height=3D576, =
format=3DYUYV, field=3Dany, bytesperline=3D1440 sizeimage=3D829440, =
colorspace=3D0=0A=
saa7134_reqbufs: f2354ee8 c2043e68=0A=
queue_setup=0A=
vb2_dma_sg_alloc: Allocated buffer of 203 pages=0A=
vb2_dma_sg_alloc: Allocated buffer of 203 pages=0A=
vb2_dma_sg_alloc: Allocated buffer of 203 pages=0A=
vb2: Buffer 0, plane 0 offset 0x00000000=0A=
vb2: Buffer 1, plane 0 offset 0x000cb000=0A=
vb2: Buffer 2, plane 0 offset 0x00196000=0A=
vb2: Allocated 3 buffers, 1 plane(s) each=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_REQBUFS count=3D3, =
type=3Dvid-cap, memory=3Dmmap=0A=
saa7134_querybuf: f2354ee8 c2043e68=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_QUERYBUF 00:00:00.00000000 =
index=3D0, type=3Dvid-cap, flags=3D0x00000000, field=3D0, sequence=3D0, =
memory=3Dmmap=0A=
saa7133[0] video (Avermedia PCI: bytesused=3D0, =
offset/userptr=3D0x00000000, length=3D829440=0A=
saa7133[0] video (Avermedia PCI: timecode=3D00:00:00 type=3D0, =
flags=3D0x00000000, frames=3D0, userbits=3D0x00000000=0A=
vb2_common_vm_open: f23ca7e0, refcount: 1, vma: b5ccc000-b5d97000=0A=
vb2: Buffer 0, plane 0 successfully mapped=0A=
saa7134_querybuf: f2354ee8 c2043e68=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_QUERYBUF 00:00:00.00000000 =
index=3D1, type=3Dvid-cap, flags=3D0x00000000, field=3D0, sequence=3D0, =
memory=3Dmmap=0A=
saa7133[0] video (Avermedia PCI: bytesused=3D0, =
offset/userptr=3D0x000cb000, length=3D829440=0A=
saa7133[0] video (Avermedia PCI: timecode=3D00:00:00 type=3D0, =
flags=3D0x00000000, frames=3D0, userbits=3D0x00000000=0A=
vb2_common_vm_open: f23cade0, refcount: 1, vma: b5c01000-b5ccc000=0A=
vb2: Buffer 1, plane 0 successfully mapped=0A=
saa7134_querybuf: f2354ee8 c2043e68=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_QUERYBUF 00:00:00.00000000 =
index=3D2, type=3Dvid-cap, flags=3D0x00000000, field=3D0, sequence=3D0, =
memory=3Dmmap=0A=
saa7133[0] video (Avermedia PCI: bytesused=3D0, =
offset/userptr=3D0x00196000, length=3D829440=0A=
saa7133[0] video (Avermedia PCI: timecode=3D00:00:00 type=3D0, =
flags=3D0x00000000, frames=3D0, userbits=3D0x00000000=0A=
vb2_common_vm_open: f23ca820, refcount: 1, vma: b5b36000-b5c01000=0A=
vb2: Buffer 2, plane 0 successfully mapped=0A=
saa7134_qbuf: f2354ee8 c2043e68=0A=
buffer_prepare: sglist:fab50000 num_pages:203=0A=
vb2: qbuf of buffer 0 succeeded=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_QBUF 00:00:00.00000000 =
index=3D0, type=3Dvid-cap, flags=3D0x00000000, field=3D0, sequence=3D0, =
memory=3Dmmap=0A=
saa7133[0] video (Avermedia PCI: bytesused=3D0, =
offset/userptr=3D0x00000000, length=3D0=0A=
saa7133[0] video (Avermedia PCI: timecode=3D00:00:00 type=3D0, =
flags=3D0x00000000, frames=3D0, userbits=3D0x00000000=0A=
saa7134_qbuf: f2354ee8 c2043e68=0A=
buffer_prepare: sglist:fac1f000 num_pages:203=0A=
vb2: qbuf of buffer 1 succeeded=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_QBUF 00:00:00.00000000 =
index=3D1, type=3Dvid-cap, flags=3D0x00000000, field=3D0, sequence=3D0, =
memory=3Dmmap=0A=
saa7133[0] video (Avermedia PCI: bytesused=3D0, =
offset/userptr=3D0x00000000, length=3D0=0A=
saa7133[0] video (Avermedia PCI: timecode=3D00:00:00 type=3D0, =
flags=3D0x00000000, frames=3D0, userbits=3D0x00000000=0A=
saa7134_qbuf: f2354ee8 c2043e68=0A=
buffer_prepare: sglist:facee000 num_pages:203=0A=
vb2: qbuf of buffer 2 succeeded=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_QBUF 00:00:00.00000000 =
index=3D2, type=3Dvid-cap, flags=3D0x00000000, field=3D0, sequence=3D0, =
memory=3Dmmap=0A=
saa7133[0] video (Avermedia PCI: bytesused=3D0, =
offset/userptr=3D0x00000000, length=3D0=0A=
saa7133[0] video (Avermedia PCI: timecode=3D00:00:00 type=3D0, =
flags=3D0x00000000, frames=3D0, userbits=3D0x00000000=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_STREAMON type=3Dvid-cap=0A=
saa7134_streamon: f2354ee8=0A=
buffer_queue=0A=
buffer_queue f34b7800=0A=
buffer_activate buf=3Df34b7800=0A=
saa7134_set_dmabits=0A=
dmabits: task=3D0x01 ctrl=3D0x01 irq=3D0x3 split=3Dyes=0A=
buffer_queue=0A=
buffer_queue f34b6800=0A=
buffer_queue=0A=
buffer_queue f2ab2c00=0A=
vb2: Streamon successful=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
saa7133[0]/irq[0,21278816]: r=3D0x1 s=3D0x00 DONE_RA0 | =
RA0=3Dvideo,a,even,0=0A=
buffer_finish f34b7800=0A=
vb2: Done processing on buffer 0, state: 2=0A=
buffer_next f34b6800 [prev=3Df2ab2e94/next=3Df34b6a94]=0A=
buffer_activate buf=3Df34b6800=0A=
saa7134_set_dmabits=0A=
dmabits: task=3D0x01 ctrl=3D0x01 irq=3D0x3 split=3Dyes=0A=
buffer_next #2 prev=3Df2ab2e94/next=3Df2ab2e94=0A=
saa7133[0]/irq: no (more) work=0A=
video_poll: f2354ee8=0A=
saa7134_dqbuf: f2354ee8 c2043e68=0A=
vb2: dqbuf: Returning done buffer=0A=
vb2: dqbuf of buffer 0, with state 3=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_DQBUF 359696:21:10.00087718 =
index=3D0, type=3Dvid-cap, flags=3D0x00000005, field=3D0, sequence=3D0, =
memory=3Dmmap=0A=
saa7133[0] video (Avermedia PCI: bytesused=3D829440, =
offset/userptr=3D0x00000000, length=3D829440=0A=
saa7133[0] video (Avermedia PCI: timecode=3D00:00:00 type=3D0, =
flags=3D0x00000000, frames=3D0, userbits=3D0x00000000=0A=
saa7134_qbuf: f2354ee8 c2043e68=0A=
buffer_prepare: sglist:fab50000 num_pages:203=0A=
buffer_queue=0A=
buffer_queue f34b7800=0A=
vb2: qbuf of buffer 0 succeeded=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_QBUF 359696:21:10.00087718 =
index=3D0, type=3Dvid-cap, flags=3D0x00000005, field=3D0, sequence=3D0, =
memory=3Dmmap=0A=
saa7133[0] video (Avermedia PCI: bytesused=3D829440, =
offset/userptr=3D0x00000000, length=3D829440=0A=
saa7133[0] video (Avermedia PCI: timecode=3D00:00:00 type=3D0, =
flags=3D0x00000000, frames=3D0, userbits=3D0x00000000=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_G_CTRL id=3D0x980900, value=3D128=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_QUERYCTRL id=3D0x980900, =
type=3D1, name=3DBrightness, min/max=3D0/255, step=3D1, default=3D128, =
flags=3D0x00000000=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_G_CTRL id=3D0x980901, value=3D68=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_QUERYCTRL id=3D0x980901, =
type=3D1, name=3DContrast, min/max=3D0/127, step=3D1, default=3D68, =
flags=3D0x00000000=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_G_CTRL id=3D0x980902, value=3D64=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_QUERYCTRL id=3D0x980902, =
type=3D1, name=3DSaturation, min/max=3D0/127, step=3D1, default=3D64, =
flags=3D0x00000000=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_G_CTRL id=3D0x980903, value=3D0=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_QUERYCTRL id=3D0x980903, =
type=3D1, name=3DHue, min/max=3D-128/127, step=3D1, default=3D0, =
flags=3D0x00000000=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_G_CTRL id=3D0x980905, value=3D0=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_QUERYCTRL id=3D0x980905, =
type=3D1, name=3DVolume, min/max=3D-15/15, step=3D1, default=3D0, =
flags=3D0x00000000=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_G_CTRL id=3D0x980909, value=3D1=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_QUERYCTRL id=3D0x980909, =
type=3D2, name=3DMute, min/max=3D0/1, step=3D0, default=3D0, =
flags=3D0x00000000=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_G_CTRL id=3D0x980914, value=3D0=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_QUERYCTRL id=3D0x980914, =
type=3D2, name=3DMirror, min/max=3D0/1, step=3D0, default=3D0, =
flags=3D0x00000000=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_G_CTRL id=3D0x8000000, value=3D0=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_QUERYCTRL id=3D0x8000000, =
type=3D2, name=3DInvert, min/max=3D0/1, step=3D0, default=3D0, =
flags=3D0x00000000=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_G_CTRL id=3D0x8000001, value=3D0=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_QUERYCTRL id=3D0x8000001, =
type=3D1, name=3Dy offset odd field, min/max=3D0/128, step=3D1, =
default=3D0, flags=3D0x00000000=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_G_CTRL id=3D0x8000002, value=3D0=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_QUERYCTRL id=3D0x8000002, =
type=3D1, name=3Dy offset even field, min/max=3D0/128, step=3D1, =
default=3D0, flags=3D0x00000000=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_G_CTRL id=3D0x8000003, value=3D1=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_QUERYCTRL id=3D0x8000003, =
type=3D2, name=3Dautomute, min/max=3D0/1, step=3D0, default=3D1, =
flags=3D0x00000000=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
saa7133[0]/irq[0,21278821]: r=3D0x1 s=3D0x10 DONE_RA0 | =
RA0=3Dvideo,a,odd,0=0A=
buffer_finish f34b6800=0A=
vb2: Done processing on buffer 1, state: 2=0A=
buffer_next f2ab2c00 [prev=3Df34b7a94/next=3Df2ab2e94]=0A=
buffer_activate buf=3Df2ab2c00=0A=
saa7134_set_dmabits=0A=
dmabits: task=3D0x01 ctrl=3D0x01 irq=3D0x3 split=3Dyes=0A=
buffer_next #2 prev=3Df34b7a94/next=3Df34b7a94=0A=
saa7133[0]/irq: no (more) work=0A=
video_poll: f2354ee8=0A=
saa7134_dqbuf: f2354ee8 c2043e68=0A=
vb2: dqbuf: Returning done buffer=0A=
vb2: dqbuf of buffer 1, with state 3=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_DQBUF 359696:21:10.00107749 =
index=3D1, type=3Dvid-cap, flags=3D0x00000005, field=3D0, sequence=3D0, =
memory=3Dmmap=0A=
saa7133[0] video (Avermedia PCI: bytesused=3D829440, =
offset/userptr=3D0x000cb000, length=3D829440=0A=
saa7133[0] video (Avermedia PCI: timecode=3D00:00:00 type=3D0, =
flags=3D0x00000000, frames=3D0, userbits=3D0x00000000=0A=
saa7134_qbuf: f2354ee8 c2043e68=0A=
buffer_prepare: sglist:fac1f000 num_pages:203=0A=
buffer_queue=0A=
buffer_queue f34b6800=0A=
vb2: qbuf of buffer 1 succeeded=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_QBUF 359696:21:10.00107749 =
index=3D1, type=3Dvid-cap, flags=3D0x00000005, field=3D0, sequence=3D0, =
memory=3Dmmap=0A=
saa7133[0] video (Avermedia PCI: bytesused=3D829440, =
offset/userptr=3D0x000cb000, length=3D829440=0A=
saa7133[0] video (Avermedia PCI: timecode=3D00:00:00 type=3D0, =
flags=3D0x00000000, frames=3D0, userbits=3D0x00000000=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
saa7133[0]/irq[0,21278826]: r=3D0x1 s=3D0x00 DONE_RA0 | =
RA0=3Dvideo,a,even,0=0A=
buffer_finish f2ab2c00=0A=
vb2: Done processing on buffer 2, state: 2=0A=
buffer_next f34b7800 [prev=3Df34b6a94/next=3Df34b7a94]=0A=
buffer_activate buf=3Df34b7800=0A=
saa7134_set_dmabits=0A=
dmabits: task=3D0x01 ctrl=3D0x01 irq=3D0x3 split=3Dyes=0A=
buffer_next #2 prev=3Df34b6a94/next=3Df34b6a94=0A=
saa7133[0]/irq: no (more) work=0A=
video_poll: f2354ee8=0A=
saa7134_dqbuf: f2354ee8 c2043e68=0A=
vb2: dqbuf: Returning done buffer=0A=
vb2: dqbuf of buffer 2, with state 3=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_DQBUF 359696:21:10.00127718 =
index=3D2, type=3Dvid-cap, flags=3D0x00000005, field=3D0, sequence=3D0, =
memory=3Dmmap=0A=
saa7133[0] video (Avermedia PCI: bytesused=3D829440, =
offset/userptr=3D0x00196000, length=3D829440=0A=
saa7133[0] video (Avermedia PCI: timecode=3D00:00:00 type=3D0, =
flags=3D0x00000000, frames=3D0, userbits=3D0x00000000=0A=
saa7134_qbuf: f2354ee8 c2043e68=0A=
buffer_prepare: sglist:facee000 num_pages:203=0A=
buffer_queue=0A=
buffer_queue f2ab2c00=0A=
vb2: qbuf of buffer 2 succeeded=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_QBUF 359696:21:10.00127718 =
index=3D2, type=3Dvid-cap, flags=3D0x00000005, field=3D0, sequence=3D0, =
memory=3Dmmap=0A=
saa7133[0] video (Avermedia PCI: bytesused=3D829440, =
offset/userptr=3D0x00196000, length=3D829440=0A=
saa7133[0] video (Avermedia PCI: timecode=3D00:00:00 type=3D0, =
flags=3D0x00000000, frames=3D0, userbits=3D0x00000000=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
saa7133[0]/irq[0,21278831]: r=3D0x1 s=3D0x10 DONE_RA0 | =
RA0=3Dvideo,a,odd,0=0A=
buffer_finish f34b7800=0A=
vb2: Done processing on buffer 0, state: 2=0A=
buffer_next f34b6800 [prev=3Df2ab2e94/next=3Df34b6a94]=0A=
buffer_activate buf=3Df34b6800=0A=
saa7134_set_dmabits=0A=
dmabits: task=3D0x01 ctrl=3D0x01 irq=3D0x3 split=3Dyes=0A=
buffer_next #2 prev=3Df2ab2e94/next=3Df2ab2e94=0A=
saa7133[0]/irq: no (more) work=0A=
video_poll: f2354ee8=0A=
saa7134_dqbuf: f2354ee8 c2043e68=0A=
vb2: dqbuf: Returning done buffer=0A=
vb2: dqbuf of buffer 0, with state 3=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_DQBUF 359696:21:10.00147751 =
index=3D0, type=3Dvid-cap, flags=3D0x00000005, field=3D0, sequence=3D0, =
memory=3Dmmap=0A=
saa7133[0] video (Avermedia PCI: bytesused=3D829440, =
offset/userptr=3D0x00000000, length=3D829440=0A=
saa7133[0] video (Avermedia PCI: timecode=3D00:00:00 type=3D0, =
flags=3D0x00000000, frames=3D0, userbits=3D0x00000000=0A=
saa7134_qbuf: f2354ee8 c2043e68=0A=
buffer_prepare: sglist:fab50000 num_pages:203=0A=
buffer_queue=0A=
buffer_queue f34b7800=0A=
vb2: qbuf of buffer 0 succeeded=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_QBUF 359696:21:10.00147751 =
index=3D0, type=3Dvid-cap, flags=3D0x00000005, field=3D0, sequence=3D0, =
memory=3Dmmap=0A=
saa7133[0] video (Avermedia PCI: bytesused=3D829440, =
offset/userptr=3D0x00000000, length=3D829440=0A=
saa7133[0] video (Avermedia PCI: timecode=3D00:00:00 type=3D0, =
flags=3D0x00000000, frames=3D0, userbits=3D0x00000000=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
saa7133[0]/irq[0,21278836]: r=3D0x1 s=3D0x00 DONE_RA0 | =
RA0=3Dvideo,a,even,0=0A=
buffer_finish f34b6800=0A=
vb2: Done processing on buffer 1, state: 2=0A=
buffer_next f2ab2c00 [prev=3Df34b7a94/next=3Df2ab2e94]=0A=
buffer_activate buf=3Df2ab2c00=0A=
saa7134_set_dmabits=0A=
dmabits: task=3D0x01 ctrl=3D0x01 irq=3D0x3 split=3Dyes=0A=
buffer_next #2 prev=3Df34b7a94/next=3Df34b7a94=0A=
saa7133[0]/irq: no (more) work=0A=
video_poll: f2354ee8=0A=
saa7134_dqbuf: f2354ee8 c2043e68=0A=
vb2: dqbuf: Returning done buffer=0A=
vb2: dqbuf of buffer 1, with state 3=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_DQBUF 359696:21:10.00167718 =
index=3D1, type=3Dvid-cap, flags=3D0x00000005, field=3D0, sequence=3D0, =
memory=3Dmmap=0A=
saa7133[0] video (Avermedia PCI: bytesused=3D829440, =
offset/userptr=3D0x000cb000, length=3D829440=0A=
saa7133[0] video (Avermedia PCI: timecode=3D00:00:00 type=3D0, =
flags=3D0x00000000, frames=3D0, userbits=3D0x00000000=0A=
saa7134_qbuf: f2354ee8 c2043e68=0A=
buffer_prepare: sglist:fac1f000 num_pages:203=0A=
buffer_queue=0A=
buffer_queue f34b6800=0A=
vb2: qbuf of buffer 1 succeeded=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_QBUF 359696:21:10.00167718 =
index=3D1, type=3Dvid-cap, flags=3D0x00000005, field=3D0, sequence=3D0, =
memory=3Dmmap=0A=
saa7133[0] video (Avermedia PCI: bytesused=3D829440, =
offset/userptr=3D0x000cb000, length=3D829440=0A=
saa7133[0] video (Avermedia PCI: timecode=3D00:00:00 type=3D0, =
flags=3D0x00000000, frames=3D0, userbits=3D0x00000000=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
saa7133[0]/irq[0,21278841]: r=3D0x1 s=3D0x10 DONE_RA0 | =
RA0=3Dvideo,a,odd,0=0A=
buffer_finish f2ab2c00=0A=
vb2: Done processing on buffer 2, state: 2=0A=
buffer_next f34b7800 [prev=3Df34b6a94/next=3Df34b7a94]=0A=
buffer_activate buf=3Df34b7800=0A=
saa7134_set_dmabits=0A=
dmabits: task=3D0x01 ctrl=3D0x01 irq=3D0x3 split=3Dyes=0A=
buffer_next #2 prev=3Df34b6a94/next=3Df34b6a94=0A=
saa7133[0]/irq: no (more) work=0A=
video_poll: f2354ee8=0A=
saa7134_dqbuf: f2354ee8 c2043e68=0A=
vb2: dqbuf: Returning done buffer=0A=
vb2: dqbuf of buffer 2, with state 3=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_DQBUF 359696:21:10.00187750 =
index=3D2, type=3Dvid-cap, flags=3D0x00000005, field=3D0, sequence=3D0, =
memory=3Dmmap=0A=
saa7133[0] video (Avermedia PCI: bytesused=3D829440, =
offset/userptr=3D0x00196000, length=3D829440=0A=
saa7133[0] video (Avermedia PCI: timecode=3D00:00:00 type=3D0, =
flags=3D0x00000000, frames=3D0, userbits=3D0x00000000=0A=
saa7134_qbuf: f2354ee8 c2043e68=0A=
buffer_prepare: sglist:facee000 num_pages:203=0A=
buffer_queue=0A=
buffer_queue f2ab2c00=0A=
vb2: qbuf of buffer 2 succeeded=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_QBUF 359696:21:10.00187750 =
index=3D2, type=3Dvid-cap, flags=3D0x00000005, field=3D0, sequence=3D0, =
memory=3Dmmap=0A=
saa7133[0] video (Avermedia PCI: bytesused=3D829440, =
offset/userptr=3D0x00196000, length=3D829440=0A=
saa7133[0] video (Avermedia PCI: timecode=3D00:00:00 type=3D0, =
flags=3D0x00000000, frames=3D0, userbits=3D0x00000000=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
saa7133[0]/irq[0,21278846]: r=3D0x1 s=3D0x00 DONE_RA0 | =
RA0=3Dvideo,a,even,0=0A=
buffer_finish f34b7800=0A=
vb2: Done processing on buffer 0, state: 2=0A=
buffer_next f34b6800 [prev=3Df2ab2e94/next=3Df34b6a94]=0A=
buffer_activate buf=3Df34b6800=0A=
saa7134_set_dmabits=0A=
dmabits: task=3D0x01 ctrl=3D0x01 irq=3D0x3 split=3Dyes=0A=
buffer_next #2 prev=3Df2ab2e94/next=3Df2ab2e94=0A=
saa7133[0]/irq: no (more) work=0A=
video_poll: f2354ee8=0A=
saa7134_dqbuf: f2354ee8 c2043e68=0A=
vb2: dqbuf: Returning done buffer=0A=
vb2: dqbuf of buffer 0, with state 3=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_DQBUF 359696:21:10.00207719 =
index=3D0, type=3Dvid-cap, flags=3D0x00000005, field=3D0, sequence=3D0, =
memory=3Dmmap=0A=
saa7133[0] video (Avermedia PCI: bytesused=3D829440, =
offset/userptr=3D0x00000000, length=3D829440=0A=
saa7133[0] video (Avermedia PCI: timecode=3D00:00:00 type=3D0, =
flags=3D0x00000000, frames=3D0, userbits=3D0x00000000=0A=
saa7134_qbuf: f2354ee8 c2043e68=0A=
buffer_prepare: sglist:fab50000 num_pages:203=0A=
buffer_queue=0A=
buffer_queue f34b7800=0A=
vb2: qbuf of buffer 0 succeeded=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_QBUF 359696:21:10.00207719 =
index=3D0, type=3Dvid-cap, flags=3D0x00000005, field=3D0, sequence=3D0, =
memory=3Dmmap=0A=
saa7133[0] video (Avermedia PCI: bytesused=3D829440, =
offset/userptr=3D0x00000000, length=3D829440=0A=
saa7133[0] video (Avermedia PCI: timecode=3D00:00:00 type=3D0, =
flags=3D0x00000000, frames=3D0, userbits=3D0x00000000=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
saa7133[0]/irq[0,21278851]: r=3D0x1 s=3D0x10 DONE_RA0 | =
RA0=3Dvideo,a,odd,0=0A=
buffer_finish f34b6800=0A=
vb2: Done processing on buffer 1, state: 2=0A=
buffer_next f2ab2c00 [prev=3Df34b7a94/next=3Df2ab2e94]=0A=
buffer_activate buf=3Df2ab2c00=0A=
saa7134_set_dmabits=0A=
dmabits: task=3D0x01 ctrl=3D0x01 irq=3D0x3 split=3Dyes=0A=
buffer_next #2 prev=3Df34b7a94/next=3Df34b7a94=0A=
saa7133[0]/irq: no (more) work=0A=
video_poll: f2354ee8=0A=
saa7134_dqbuf: f2354ee8 c2043e68=0A=
vb2: dqbuf: Returning done buffer=0A=
vb2: dqbuf of buffer 1, with state 3=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_DQBUF 359696:21:10.00227751 =
index=3D1, type=3Dvid-cap, flags=3D0x00000005, field=3D0, sequence=3D0, =
memory=3Dmmap=0A=
saa7133[0] video (Avermedia PCI: bytesused=3D829440, =
offset/userptr=3D0x000cb000, length=3D829440=0A=
saa7133[0] video (Avermedia PCI: timecode=3D00:00:00 type=3D0, =
flags=3D0x00000000, frames=3D0, userbits=3D0x00000000=0A=
saa7134_qbuf: f2354ee8 c2043e68=0A=
buffer_prepare: sglist:fac1f000 num_pages:203=0A=
buffer_queue=0A=
buffer_queue f34b6800=0A=
vb2: qbuf of buffer 1 succeeded=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_QBUF 359696:21:10.00227751 =
index=3D1, type=3Dvid-cap, flags=3D0x00000005, field=3D0, sequence=3D0, =
memory=3Dmmap=0A=
saa7133[0] video (Avermedia PCI: bytesused=3D829440, =
offset/userptr=3D0x000cb000, length=3D829440=0A=
saa7133[0] video (Avermedia PCI: timecode=3D00:00:00 type=3D0, =
flags=3D0x00000000, frames=3D0, userbits=3D0x00000000=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
saa7133[0]/irq[0,21278856]: r=3D0x1 s=3D0x00 DONE_RA0 | =
RA0=3Dvideo,a,even,0=0A=
buffer_finish f2ab2c00=0A=
vb2: Done processing on buffer 2, state: 2=0A=
buffer_next f34b7800 [prev=3Df34b6a94/next=3Df34b7a94]=0A=
buffer_activate buf=3Df34b7800=0A=
saa7134_set_dmabits=0A=
dmabits: task=3D0x01 ctrl=3D0x01 irq=3D0x3 split=3Dyes=0A=
buffer_next #2 prev=3Df34b6a94/next=3Df34b6a94=0A=
saa7133[0]/irq: no (more) work=0A=
video_poll: f2354ee8=0A=
saa7134_dqbuf: f2354ee8 c2043e68=0A=
vb2: dqbuf: Returning done buffer=0A=
vb2: dqbuf of buffer 2, with state 3=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_DQBUF 359696:21:10.00247720 =
index=3D2, type=3Dvid-cap, flags=3D0x00000005, field=3D0, sequence=3D0, =
memory=3Dmmap=0A=
saa7133[0] video (Avermedia PCI: bytesused=3D829440, =
offset/userptr=3D0x00196000, length=3D829440=0A=
saa7133[0] video (Avermedia PCI: timecode=3D00:00:00 type=3D0, =
flags=3D0x00000000, frames=3D0, userbits=3D0x00000000=0A=
saa7134_qbuf: f2354ee8 c2043e68=0A=
buffer_prepare: sglist:facee000 num_pages:203=0A=
buffer_queue=0A=
buffer_queue f2ab2c00=0A=
vb2: qbuf of buffer 2 succeeded=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_QBUF 359696:21:10.00247720 =
index=3D2, type=3Dvid-cap, flags=3D0x00000005, field=3D0, sequence=3D0, =
memory=3Dmmap=0A=
saa7133[0] video (Avermedia PCI: bytesused=3D829440, =
offset/userptr=3D0x00196000, length=3D829440=0A=
saa7133[0] video (Avermedia PCI: timecode=3D00:00:00 type=3D0, =
flags=3D0x00000000, frames=3D0, userbits=3D0x00000000=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
saa7133[0]/irq[0,21278861]: r=3D0x1 s=3D0x10 DONE_RA0 | =
RA0=3Dvideo,a,odd,0=0A=
buffer_finish f34b7800=0A=
vb2: Done processing on buffer 0, state: 2=0A=
buffer_next f34b6800 [prev=3Df2ab2e94/next=3Df34b6a94]=0A=
buffer_activate buf=3Df34b6800=0A=
saa7134_set_dmabits=0A=
dmabits: task=3D0x01 ctrl=3D0x01 irq=3D0x3 split=3Dyes=0A=
buffer_next #2 prev=3Df2ab2e94/next=3Df2ab2e94=0A=
saa7133[0]/irq: no (more) work=0A=
video_poll: f2354ee8=0A=
saa7134_dqbuf: f2354ee8 c2043e68=0A=
vb2: dqbuf: Returning done buffer=0A=
vb2: dqbuf of buffer 0, with state 3=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_DQBUF 359696:21:10.00267751 =
index=3D0, type=3Dvid-cap, flags=3D0x00000005, field=3D0, sequence=3D0, =
memory=3Dmmap=0A=
saa7133[0] video (Avermedia PCI: bytesused=3D829440, =
offset/userptr=3D0x00000000, length=3D829440=0A=
saa7133[0] video (Avermedia PCI: timecode=3D00:00:00 type=3D0, =
flags=3D0x00000000, frames=3D0, userbits=3D0x00000000=0A=
saa7134_qbuf: f2354ee8 c2043e68=0A=
buffer_prepare: sglist:fab50000 num_pages:203=0A=
buffer_queue=0A=
buffer_queue f34b7800=0A=
vb2: qbuf of buffer 0 succeeded=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_QBUF 359696:21:10.00267751 =
index=3D0, type=3Dvid-cap, flags=3D0x00000005, field=3D0, sequence=3D0, =
memory=3Dmmap=0A=
saa7133[0] video (Avermedia PCI: bytesused=3D829440, =
offset/userptr=3D0x00000000, length=3D829440=0A=
saa7133[0] video (Avermedia PCI: timecode=3D00:00:00 type=3D0, =
flags=3D0x00000000, frames=3D0, userbits=3D0x00000000=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
saa7133[0]/irq[0,21278866]: r=3D0x1 s=3D0x00 DONE_RA0 | =
RA0=3Dvideo,a,even,0=0A=
buffer_finish f34b6800=0A=
vb2: Done processing on buffer 1, state: 2=0A=
buffer_next f2ab2c00 [prev=3Df34b7a94/next=3Df2ab2e94]=0A=
video_poll: f2354ee8=0A=
buffer_activate buf=3Df2ab2c00=0A=
saa7134_set_dmabits=0A=
saa7134_dqbuf: f2354ee8 c2043e68=0A=
dmabits: task=3D0x01 ctrl=3D0x01 irq=3D0x3 split=3Dyes=0A=
buffer_next #2 prev=3Df34b7a94/next=3Df34b7a94=0A=
vb2: dqbuf: Returning done buffer=0A=
vb2: dqbuf of buffer 1, with state 3=0A=
saa7133[0]/irq: no (more) work=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_DQBUF 359696:21:10.00287718 =
index=3D1, type=3Dvid-cap, flags=3D0x00000005, field=3D0, sequence=3D0, =
memory=3Dmmap=0A=
saa7133[0] video (Avermedia PCI: bytesused=3D829440, =
offset/userptr=3D0x000cb000, length=3D829440=0A=
saa7133[0] video (Avermedia PCI: timecode=3D00:00:00 type=3D0, =
flags=3D0x00000000, frames=3D0, userbits=3D0x00000000=0A=
saa7134_qbuf: f2354ee8 c2043e68=0A=
buffer_prepare: sglist:fac1f000 num_pages:203=0A=
buffer_queue=0A=
buffer_queue f34b6800=0A=
vb2: qbuf of buffer 1 succeeded=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_QBUF 359696:21:10.00287718 =
index=3D1, type=3Dvid-cap, flags=3D0x00000005, field=3D0, sequence=3D0, =
memory=3Dmmap=0A=
saa7133[0] video (Avermedia PCI: bytesused=3D829440, =
offset/userptr=3D0x000cb000, length=3D829440=0A=
saa7133[0] video (Avermedia PCI: timecode=3D00:00:00 type=3D0, =
flags=3D0x00000000, frames=3D0, userbits=3D0x00000000=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
saa7133[0]/irq[0,21278871]: r=3D0x1 s=3D0x90 DONE_RA0 | =
RA0=3Dvideo,a,odd,0=0A=
buffer_finish f2ab2c00=0A=
vb2: Done processing on buffer 2, state: 2=0A=
buffer_next f34b7800 [prev=3Df34b6a94/next=3Df34b7a94]=0A=
buffer_activate buf=3Df34b7800=0A=
saa7134_set_dmabits=0A=
dmabits: task=3D0x01 ctrl=3D0x01 irq=3D0x3 split=3Dyes=0A=
buffer_next #2 prev=3Df34b6a94/next=3Df34b6a94=0A=
saa7133[0]/irq: no (more) work=0A=
video_poll: f2354ee8=0A=
saa7134_dqbuf: f2354ee8 c2043e68=0A=
vb2: dqbuf: Returning done buffer=0A=
vb2: dqbuf of buffer 2, with state 3=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_DQBUF 359696:21:10.00307752 =
index=3D2, type=3Dvid-cap, flags=3D0x00000005, field=3D0, sequence=3D0, =
memory=3Dmmap=0A=
saa7133[0] video (Avermedia PCI: bytesused=3D829440, =
offset/userptr=3D0x00196000, length=3D829440=0A=
saa7133[0] video (Avermedia PCI: timecode=3D00:00:00 type=3D0, =
flags=3D0x00000000, frames=3D0, userbits=3D0x00000000=0A=
saa7134_qbuf: f2354ee8 c2043e68=0A=
buffer_prepare: sglist:facee000 num_pages:203=0A=
buffer_queue=0A=
buffer_queue f2ab2c00=0A=
vb2: qbuf of buffer 2 succeeded=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_QBUF 359696:21:10.00307752 =
index=3D2, type=3Dvid-cap, flags=3D0x00000005, field=3D0, sequence=3D0, =
memory=3Dmmap=0A=
saa7133[0] video (Avermedia PCI: bytesused=3D829440, =
offset/userptr=3D0x00196000, length=3D829440=0A=
saa7133[0] video (Avermedia PCI: timecode=3D00:00:00 type=3D0, =
flags=3D0x00000000, frames=3D0, userbits=3D0x00000000=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
saa7133[0]/irq[0,21278876]: r=3D0x1 s=3D0x00 DONE_RA0 | =
RA0=3Dvideo,a,even,0=0A=
buffer_finish f34b7800=0A=
vb2: Done processing on buffer 0, state: 2=0A=
buffer_next f34b6800 [prev=3Df2ab2e94/next=3Df34b6a94]=0A=
buffer_activate buf=3Df34b6800=0A=
saa7134_set_dmabits=0A=
dmabits: task=3D0x01 ctrl=3D0x01 irq=3D0x3 split=3Dyes=0A=
buffer_next #2 prev=3Df2ab2e94/next=3Df2ab2e94=0A=
saa7133[0]/irq: no (more) work=0A=
video_poll: f2354ee8=0A=
saa7134_dqbuf: f2354ee8 c2043e68=0A=
vb2: dqbuf: Returning done buffer=0A=
vb2: dqbuf of buffer 0, with state 3=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_DQBUF 359696:21:10.00327720 =
index=3D0, type=3Dvid-cap, flags=3D0x00000005, field=3D0, sequence=3D0, =
memory=3Dmmap=0A=
saa7133[0] video (Avermedia PCI: bytesused=3D829440, =
offset/userptr=3D0x00000000, length=3D829440=0A=
saa7133[0] video (Avermedia PCI: timecode=3D00:00:00 type=3D0, =
flags=3D0x00000000, frames=3D0, userbits=3D0x00000000=0A=
saa7134_qbuf: f2354ee8 c2043e68=0A=
buffer_prepare: sglist:fab50000 num_pages:203=0A=
buffer_queue=0A=
buffer_queue f34b7800=0A=
vb2: qbuf of buffer 0 succeeded=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_QBUF 359696:21:10.00327720 =
index=3D0, type=3Dvid-cap, flags=3D0x00000005, field=3D0, sequence=3D0, =
memory=3Dmmap=0A=
saa7133[0] video (Avermedia PCI: bytesused=3D829440, =
offset/userptr=3D0x00000000, length=3D829440=0A=
saa7133[0] video (Avermedia PCI: timecode=3D00:00:00 type=3D0, =
flags=3D0x00000000, frames=3D0, userbits=3D0x00000000=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
saa7133[0]/irq[0,21278881]: r=3D0x1 s=3D0x10 DONE_RA0 | =
RA0=3Dvideo,a,odd,0=0A=
buffer_finish f34b6800=0A=
vb2: Done processing on buffer 1, state: 2=0A=
buffer_next f2ab2c00 [prev=3Df34b7a94/next=3Df2ab2e94]=0A=
buffer_activate buf=3Df2ab2c00=0A=
saa7134_set_dmabits=0A=
dmabits: task=3D0x01 ctrl=3D0x01 irq=3D0x3 split=3Dyes=0A=
buffer_next #2 prev=3Df34b7a94/next=3Df34b7a94=0A=
saa7133[0]/irq: no (more) work=0A=
video_poll: f2354ee8=0A=
saa7134_dqbuf: f2354ee8 c2043e68=0A=
vb2: dqbuf: Returning done buffer=0A=
vb2: dqbuf of buffer 1, with state 3=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_DQBUF 359696:21:10.00347752 =
index=3D1, type=3Dvid-cap, flags=3D0x00000005, field=3D0, sequence=3D0, =
memory=3Dmmap=0A=
saa7133[0] video (Avermedia PCI: bytesused=3D829440, =
offset/userptr=3D0x000cb000, length=3D829440=0A=
saa7133[0] video (Avermedia PCI: timecode=3D00:00:00 type=3D0, =
flags=3D0x00000000, frames=3D0, userbits=3D0x00000000=0A=
saa7134_qbuf: f2354ee8 c2043e68=0A=
buffer_prepare: sglist:fac1f000 num_pages:203=0A=
buffer_queue=0A=
buffer_queue f34b6800=0A=
vb2: qbuf of buffer 1 succeeded=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_QBUF 359696:21:10.00347752 =
index=3D1, type=3Dvid-cap, flags=3D0x00000005, field=3D0, sequence=3D0, =
memory=3Dmmap=0A=
saa7133[0] video (Avermedia PCI: bytesused=3D829440, =
offset/userptr=3D0x000cb000, length=3D829440=0A=
saa7133[0] video (Avermedia PCI: timecode=3D00:00:00 type=3D0, =
flags=3D0x00000000, frames=3D0, userbits=3D0x00000000=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
saa7133[0]/irq[0,21278886]: r=3D0x1 s=3D0x00 DONE_RA0 | =
RA0=3Dvideo,a,even,0=0A=
buffer_finish f2ab2c00=0A=
vb2: Done processing on buffer 2, state: 2=0A=
buffer_next f34b7800 [prev=3Df34b6a94/next=3Df34b7a94]=0A=
buffer_activate buf=3Df34b7800=0A=
saa7134_set_dmabits=0A=
dmabits: task=3D0x01 ctrl=3D0x01 irq=3D0x3 split=3Dyes=0A=
buffer_next #2 prev=3Df34b6a94/next=3Df34b6a94=0A=
saa7133[0]/irq: no (more) work=0A=
video_poll: f2354ee8=0A=
saa7134_dqbuf: f2354ee8 c2043e68=0A=
vb2: dqbuf: Returning done buffer=0A=
vb2: dqbuf of buffer 2, with state 3=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_DQBUF 359696:21:10.00367722 =
index=3D2, type=3Dvid-cap, flags=3D0x00000005, field=3D0, sequence=3D0, =
memory=3Dmmap=0A=
saa7133[0] video (Avermedia PCI: bytesused=3D829440, =
offset/userptr=3D0x00196000, length=3D829440=0A=
saa7133[0] video (Avermedia PCI: timecode=3D00:00:00 type=3D0, =
flags=3D0x00000000, frames=3D0, userbits=3D0x00000000=0A=
saa7134_qbuf: f2354ee8 c2043e68=0A=
buffer_prepare: sglist:facee000 num_pages:203=0A=
buffer_queue=0A=
buffer_queue f2ab2c00=0A=
vb2: qbuf of buffer 2 succeeded=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_QBUF 359696:21:10.00367722 =
index=3D2, type=3Dvid-cap, flags=3D0x00000005, field=3D0, sequence=3D0, =
memory=3Dmmap=0A=
saa7133[0] video (Avermedia PCI: bytesused=3D829440, =
offset/userptr=3D0x00196000, length=3D829440=0A=
saa7133[0] video (Avermedia PCI: timecode=3D00:00:00 type=3D0, =
flags=3D0x00000000, frames=3D0, userbits=3D0x00000000=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
saa7133[0]/irq[0,21278891]: r=3D0x1 s=3D0x10 DONE_RA0 | =
RA0=3Dvideo,a,odd,0=0A=
buffer_finish f34b7800=0A=
vb2: Done processing on buffer 0, state: 2=0A=
buffer_next f34b6800 [prev=3Df2ab2e94/next=3Df34b6a94]=0A=
buffer_activate buf=3Df34b6800=0A=
saa7134_set_dmabits=0A=
dmabits: task=3D0x01 ctrl=3D0x01 irq=3D0x3 split=3Dyes=0A=
buffer_next #2 prev=3Df2ab2e94/next=3Df2ab2e94=0A=
saa7133[0]/irq: no (more) work=0A=
video_poll: f2354ee8=0A=
saa7134_dqbuf: f2354ee8 c2043e68=0A=
vb2: dqbuf: Returning done buffer=0A=
vb2: dqbuf of buffer 0, with state 3=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_DQBUF 359696:21:10.00387754 =
index=3D0, type=3Dvid-cap, flags=3D0x00000005, field=3D0, sequence=3D0, =
memory=3Dmmap=0A=
saa7133[0] video (Avermedia PCI: bytesused=3D829440, =
offset/userptr=3D0x00000000, length=3D829440=0A=
saa7133[0] video (Avermedia PCI: timecode=3D00:00:00 type=3D0, =
flags=3D0x00000000, frames=3D0, userbits=3D0x00000000=0A=
saa7134_qbuf: f2354ee8 c2043e68=0A=
buffer_prepare: sglist:fab50000 num_pages:203=0A=
buffer_queue=0A=
buffer_queue f34b7800=0A=
vb2: qbuf of buffer 0 succeeded=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_QBUF 359696:21:10.00387754 =
index=3D0, type=3Dvid-cap, flags=3D0x00000005, field=3D0, sequence=3D0, =
memory=3Dmmap=0A=
saa7133[0] video (Avermedia PCI: bytesused=3D829440, =
offset/userptr=3D0x00000000, length=3D829440=0A=
saa7133[0] video (Avermedia PCI: timecode=3D00:00:00 type=3D0, =
flags=3D0x00000000, frames=3D0, userbits=3D0x00000000=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
saa7133[0]/irq[0,21278896]: r=3D0x1 s=3D0x00 DONE_RA0 | =
RA0=3Dvideo,a,even,0=0A=
buffer_finish f34b6800=0A=
vb2: Done processing on buffer 1, state: 2=0A=
buffer_next f2ab2c00 [prev=3Df34b7a94/next=3Df2ab2e94]=0A=
buffer_activate buf=3Df2ab2c00=0A=
saa7134_set_dmabits=0A=
dmabits: task=3D0x01 ctrl=3D0x01 irq=3D0x3 split=3Dyes=0A=
buffer_next #2 prev=3Df34b7a94/next=3Df34b7a94=0A=
saa7133[0]/irq: no (more) work=0A=
video_poll: f2354ee8=0A=
saa7134_dqbuf: f2354ee8 c2043e68=0A=
vb2: dqbuf: Returning done buffer=0A=
vb2: dqbuf of buffer 1, with state 3=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_DQBUF 359696:21:10.00407722 =
index=3D1, type=3Dvid-cap, flags=3D0x00000005, field=3D0, sequence=3D0, =
memory=3Dmmap=0A=
saa7133[0] video (Avermedia PCI: bytesused=3D829440, =
offset/userptr=3D0x000cb000, length=3D829440=0A=
saa7133[0] video (Avermedia PCI: timecode=3D00:00:00 type=3D0, =
flags=3D0x00000000, frames=3D0, userbits=3D0x00000000=0A=
saa7134_qbuf: f2354ee8 c2043e68=0A=
buffer_prepare: sglist:fac1f000 num_pages:203=0A=
buffer_queue=0A=
buffer_queue f34b6800=0A=
vb2: qbuf of buffer 1 succeeded=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_QBUF 359696:21:10.00407722 =
index=3D1, type=3Dvid-cap, flags=3D0x00000005, field=3D0, sequence=3D0, =
memory=3Dmmap=0A=
saa7133[0] video (Avermedia PCI: bytesused=3D829440, =
offset/userptr=3D0x000cb000, length=3D829440=0A=
saa7133[0] video (Avermedia PCI: timecode=3D00:00:00 type=3D0, =
flags=3D0x00000000, frames=3D0, userbits=3D0x00000000=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
saa7133[0]/irq[0,21278901]: r=3D0x1 s=3D0x10 DONE_RA0 | =
RA0=3Dvideo,a,odd,0=0A=
buffer_finish f2ab2c00=0A=
vb2: Done processing on buffer 2, state: 2=0A=
buffer_next f34b7800 [prev=3Df34b6a94/next=3Df34b7a94]=0A=
buffer_activate buf=3Df34b7800=0A=
saa7134_set_dmabits=0A=
dmabits: task=3D0x01 ctrl=3D0x01 irq=3D0x3 split=3Dyes=0A=
buffer_next #2 prev=3Df34b6a94/next=3Df34b6a94=0A=
saa7133[0]/irq: no (more) work=0A=
video_poll: f2354ee8=0A=
saa7134_dqbuf: f2354ee8 c2043e68=0A=
vb2: dqbuf: Returning done buffer=0A=
vb2: dqbuf of buffer 2, with state 3=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_DQBUF 359696:21:10.00427754 =
index=3D2, type=3Dvid-cap, flags=3D0x00000005, field=3D0, sequence=3D0, =
memory=3Dmmap=0A=
saa7133[0] video (Avermedia PCI: bytesused=3D829440, =
offset/userptr=3D0x00196000, length=3D829440=0A=
saa7133[0] video (Avermedia PCI: timecode=3D00:00:00 type=3D0, =
flags=3D0x00000000, frames=3D0, userbits=3D0x00000000=0A=
saa7134_qbuf: f2354ee8 c2043e68=0A=
buffer_prepare: sglist:facee000 num_pages:203=0A=
buffer_queue=0A=
buffer_queue f2ab2c00=0A=
vb2: qbuf of buffer 2 succeeded=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_QBUF 359696:21:10.00427754 =
index=3D2, type=3Dvid-cap, flags=3D0x00000005, field=3D0, sequence=3D0, =
memory=3Dmmap=0A=
saa7133[0] video (Avermedia PCI: bytesused=3D829440, =
offset/userptr=3D0x00196000, length=3D829440=0A=
saa7133[0] video (Avermedia PCI: timecode=3D00:00:00 type=3D0, =
flags=3D0x00000000, frames=3D0, userbits=3D0x00000000=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
saa7133[0]/irq[0,21278906]: r=3D0x1 s=3D0x00 DONE_RA0 | =
RA0=3Dvideo,a,even,0=0A=
buffer_finish f34b7800=0A=
vb2: Done processing on buffer 0, state: 2=0A=
buffer_next f34b6800 [prev=3Df2ab2e94/next=3Df34b6a94]=0A=
buffer_activate buf=3Df34b6800=0A=
saa7134_set_dmabits=0A=
dmabits: task=3D0x01 ctrl=3D0x01 irq=3D0x3 split=3Dyes=0A=
buffer_next #2 prev=3Df2ab2e94/next=3Df2ab2e94=0A=
saa7133[0]/irq: no (more) work=0A=
video_poll: f2354ee8=0A=
saa7134_dqbuf: f2354ee8 c2043e68=0A=
vb2: dqbuf: Returning done buffer=0A=
vb2: dqbuf of buffer 0, with state 3=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_DQBUF 359696:21:10.00447722 =
index=3D0, type=3Dvid-cap, flags=3D0x00000005, field=3D0, sequence=3D0, =
memory=3Dmmap=0A=
saa7133[0] video (Avermedia PCI: bytesused=3D829440, =
offset/userptr=3D0x00000000, length=3D829440=0A=
saa7133[0] video (Avermedia PCI: timecode=3D00:00:00 type=3D0, =
flags=3D0x00000000, frames=3D0, userbits=3D0x00000000=0A=
saa7134_qbuf: f2354ee8 c2043e68=0A=
buffer_prepare: sglist:fab50000 num_pages:203=0A=
buffer_queue=0A=
buffer_queue f34b7800=0A=
vb2: qbuf of buffer 0 succeeded=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_QBUF 359696:21:10.00447722 =
index=3D0, type=3Dvid-cap, flags=3D0x00000005, field=3D0, sequence=3D0, =
memory=3Dmmap=0A=
saa7133[0] video (Avermedia PCI: bytesused=3D829440, =
offset/userptr=3D0x00000000, length=3D829440=0A=
saa7133[0] video (Avermedia PCI: timecode=3D00:00:00 type=3D0, =
flags=3D0x00000000, frames=3D0, userbits=3D0x00000000=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
saa7133[0]/irq[0,21278911]: r=3D0x1 s=3D0x10 DONE_RA0 | =
RA0=3Dvideo,a,odd,0=0A=
buffer_finish f34b6800=0A=
vb2: Done processing on buffer 1, state: 2=0A=
buffer_next f2ab2c00 [prev=3Df34b7a94/next=3Df2ab2e94]=0A=
buffer_activate buf=3Df2ab2c00=0A=
saa7134_set_dmabits=0A=
dmabits: task=3D0x01 ctrl=3D0x01 irq=3D0x3 split=3Dyes=0A=
buffer_next #2 prev=3Df34b7a94/next=3Df34b7a94=0A=
saa7133[0]/irq: no (more) work=0A=
video_poll: f2354ee8=0A=
saa7134_dqbuf: f2354ee8 c2043e68=0A=
vb2: dqbuf: Returning done buffer=0A=
vb2: dqbuf of buffer 1, with state 3=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_DQBUF 359696:21:10.00467755 =
index=3D1, type=3Dvid-cap, flags=3D0x00000005, field=3D0, sequence=3D0, =
memory=3Dmmap=0A=
saa7133[0] video (Avermedia PCI: bytesused=3D829440, =
offset/userptr=3D0x000cb000, length=3D829440=0A=
saa7133[0] video (Avermedia PCI: timecode=3D00:00:00 type=3D0, =
flags=3D0x00000000, frames=3D0, userbits=3D0x00000000=0A=
saa7134_qbuf: f2354ee8 c2043e68=0A=
buffer_prepare: sglist:fac1f000 num_pages:203=0A=
buffer_queue=0A=
buffer_queue f34b6800=0A=
vb2: qbuf of buffer 1 succeeded=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_QBUF 359696:21:10.00467755 =
index=3D1, type=3Dvid-cap, flags=3D0x00000005, field=3D0, sequence=3D0, =
memory=3Dmmap=0A=
saa7133[0] video (Avermedia PCI: bytesused=3D829440, =
offset/userptr=3D0x000cb000, length=3D829440=0A=
saa7133[0] video (Avermedia PCI: timecode=3D00:00:00 type=3D0, =
flags=3D0x00000000, frames=3D0, userbits=3D0x00000000=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
saa7133[0]/irq[0,21278916]: r=3D0x1 s=3D0x00 DONE_RA0 | =
RA0=3Dvideo,a,even,0=0A=
buffer_finish f2ab2c00=0A=
vb2: Done processing on buffer 2, state: 2=0A=
buffer_next f34b7800 [prev=3Df34b6a94/next=3Df34b7a94]=0A=
buffer_activate buf=3Df34b7800=0A=
saa7134_set_dmabits=0A=
dmabits: task=3D0x01 ctrl=3D0x01 irq=3D0x3 split=3Dyes=0A=
buffer_next #2 prev=3Df34b6a94/next=3Df34b6a94=0A=
saa7133[0]/irq: no (more) work=0A=
video_poll: f2354ee8=0A=
saa7134_dqbuf: f2354ee8 c2043e68=0A=
vb2: dqbuf: Returning done buffer=0A=
vb2: dqbuf of buffer 2, with state 3=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_DQBUF 359696:21:10.00487723 =
index=3D2, type=3Dvid-cap, flags=3D0x00000005, field=3D0, sequence=3D0, =
memory=3Dmmap=0A=
saa7133[0] video (Avermedia PCI: bytesused=3D829440, =
offset/userptr=3D0x00196000, length=3D829440=0A=
saa7133[0] video (Avermedia PCI: timecode=3D00:00:00 type=3D0, =
flags=3D0x00000000, frames=3D0, userbits=3D0x00000000=0A=
saa7134_qbuf: f2354ee8 c2043e68=0A=
buffer_prepare: sglist:facee000 num_pages:203=0A=
buffer_queue=0A=
buffer_queue f2ab2c00=0A=
vb2: qbuf of buffer 2 succeeded=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_QBUF 359696:21:10.00487723 =
index=3D2, type=3Dvid-cap, flags=3D0x00000005, field=3D0, sequence=3D0, =
memory=3Dmmap=0A=
saa7133[0] video (Avermedia PCI: bytesused=3D829440, =
offset/userptr=3D0x00196000, length=3D829440=0A=
saa7133[0] video (Avermedia PCI: timecode=3D00:00:00 type=3D0, =
flags=3D0x00000000, frames=3D0, userbits=3D0x00000000=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
saa7133[0]/irq[0,21278921]: r=3D0x1 s=3D0x10 DONE_RA0 | =
RA0=3Dvideo,a,odd,0=0A=
buffer_finish f34b7800=0A=
vb2: Done processing on buffer 0, state: 2=0A=
buffer_next f34b6800 [prev=3Df2ab2e94/next=3Df34b6a94]=0A=
buffer_activate buf=3Df34b6800=0A=
saa7134_set_dmabits=0A=
dmabits: task=3D0x01 ctrl=3D0x01 irq=3D0x3 split=3Dyes=0A=
buffer_next #2 prev=3Df2ab2e94/next=3Df2ab2e94=0A=
saa7133[0]/irq: no (more) work=0A=
video_poll: f2354ee8=0A=
saa7134_dqbuf: f2354ee8 c2043e68=0A=
vb2: dqbuf: Returning done buffer=0A=
vb2: dqbuf of buffer 0, with state 3=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_DQBUF 359696:21:10.00507755 =
index=3D0, type=3Dvid-cap, flags=3D0x00000005, field=3D0, sequence=3D0, =
memory=3Dmmap=0A=
saa7133[0] video (Avermedia PCI: bytesused=3D829440, =
offset/userptr=3D0x00000000, length=3D829440=0A=
saa7133[0] video (Avermedia PCI: timecode=3D00:00:00 type=3D0, =
flags=3D0x00000000, frames=3D0, userbits=3D0x00000000=0A=
saa7134_qbuf: f2354ee8 c2043e68=0A=
buffer_prepare: sglist:fab50000 num_pages:203=0A=
buffer_queue=0A=
buffer_queue f34b7800=0A=
vb2: qbuf of buffer 0 succeeded=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_QBUF 359696:21:10.00507755 =
index=3D0, type=3Dvid-cap, flags=3D0x00000005, field=3D0, sequence=3D0, =
memory=3Dmmap=0A=
saa7133[0] video (Avermedia PCI: bytesused=3D829440, =
offset/userptr=3D0x00000000, length=3D829440=0A=
saa7133[0] video (Avermedia PCI: timecode=3D00:00:00 type=3D0, =
flags=3D0x00000000, frames=3D0, userbits=3D0x00000000=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
saa7133[0]/irq[0,21278926]: r=3D0x1 s=3D0x00 DONE_RA0 | =
RA0=3Dvideo,a,even,0=0A=
buffer_finish f34b6800=0A=
vb2: Done processing on buffer 1, state: 2=0A=
buffer_next f2ab2c00 [prev=3Df34b7a94/next=3Df2ab2e94]=0A=
buffer_activate buf=3Df2ab2c00=0A=
saa7134_set_dmabits=0A=
dmabits: task=3D0x01 ctrl=3D0x01 irq=3D0x3 split=3Dyes=0A=
buffer_next #2 prev=3Df34b7a94/next=3Df34b7a94=0A=
saa7133[0]/irq: no (more) work=0A=
video_poll: f2354ee8=0A=
saa7134_dqbuf: f2354ee8 c2043e68=0A=
vb2: dqbuf: Returning done buffer=0A=
vb2: dqbuf of buffer 1, with state 3=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_DQBUF 359696:21:10.00527725 =
index=3D1, type=3Dvid-cap, flags=3D0x00000005, field=3D0, sequence=3D0, =
memory=3Dmmap=0A=
saa7133[0] video (Avermedia PCI: bytesused=3D829440, =
offset/userptr=3D0x000cb000, length=3D829440=0A=
saa7133[0] video (Avermedia PCI: timecode=3D00:00:00 type=3D0, =
flags=3D0x00000000, frames=3D0, userbits=3D0x00000000=0A=
saa7134_qbuf: f2354ee8 c2043e68=0A=
buffer_prepare: sglist:fac1f000 num_pages:203=0A=
buffer_queue=0A=
buffer_queue f34b6800=0A=
vb2: qbuf of buffer 1 succeeded=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_QBUF 359696:21:10.00527725 =
index=3D1, type=3Dvid-cap, flags=3D0x00000005, field=3D0, sequence=3D0, =
memory=3Dmmap=0A=
saa7133[0] video (Avermedia PCI: bytesused=3D829440, =
offset/userptr=3D0x000cb000, length=3D829440=0A=
saa7133[0] video (Avermedia PCI: timecode=3D00:00:00 type=3D0, =
flags=3D0x00000000, frames=3D0, userbits=3D0x00000000=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
saa7133[0]/irq[0,21278931]: r=3D0x1 s=3D0x10 DONE_RA0 | =
RA0=3Dvideo,a,odd,0=0A=
buffer_finish f2ab2c00=0A=
vb2: Done processing on buffer 2, state: 2=0A=
buffer_next f34b7800 [prev=3Df34b6a94/next=3Df34b7a94]=0A=
buffer_activate buf=3Df34b7800=0A=
saa7134_set_dmabits=0A=
dmabits: task=3D0x01 ctrl=3D0x01 irq=3D0x3 split=3Dyes=0A=
buffer_next #2 prev=3Df34b6a94/next=3Df34b6a94=0A=
saa7133[0]/irq: no (more) work=0A=
video_poll: f2354ee8=0A=
saa7134_dqbuf: f2354ee8 c2043e68=0A=
vb2: dqbuf: Returning done buffer=0A=
vb2: dqbuf of buffer 2, with state 3=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_DQBUF 359696:21:10.00547757 =
index=3D2, type=3Dvid-cap, flags=3D0x00000005, field=3D0, sequence=3D0, =
memory=3Dmmap=0A=
saa7133[0] video (Avermedia PCI: bytesused=3D829440, =
offset/userptr=3D0x00196000, length=3D829440=0A=
saa7133[0] video (Avermedia PCI: timecode=3D00:00:00 type=3D0, =
flags=3D0x00000000, frames=3D0, userbits=3D0x00000000=0A=
saa7134_qbuf: f2354ee8 c2043e68=0A=
buffer_prepare: sglist:facee000 num_pages:203=0A=
buffer_queue=0A=
buffer_queue f2ab2c00=0A=
vb2: qbuf of buffer 2 succeeded=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_QBUF 359696:21:10.00547757 =
index=3D2, type=3Dvid-cap, flags=3D0x00000005, field=3D0, sequence=3D0, =
memory=3Dmmap=0A=
saa7133[0] video (Avermedia PCI: bytesused=3D829440, =
offset/userptr=3D0x00196000, length=3D829440=0A=
saa7133[0] video (Avermedia PCI: timecode=3D00:00:00 type=3D0, =
flags=3D0x00000000, frames=3D0, userbits=3D0x00000000=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
saa7133[0]/irq[0,21278936]: r=3D0x1 s=3D0x00 DONE_RA0 | =
RA0=3Dvideo,a,even,0=0A=
buffer_finish f34b7800=0A=
vb2: Done processing on buffer 0, state: 2=0A=
buffer_next f34b6800 [prev=3Df2ab2e94/next=3Df34b6a94]=0A=
buffer_activate buf=3Df34b6800=0A=
saa7134_set_dmabits=0A=
dmabits: task=3D0x01 ctrl=3D0x01 irq=3D0x3 split=3Dyes=0A=
buffer_next #2 prev=3Df2ab2e94/next=3Df2ab2e94=0A=
saa7133[0]/irq: no (more) work=0A=
video_poll: f2354ee8=0A=
saa7134_dqbuf: f2354ee8 c2043e68=0A=
vb2: dqbuf: Returning done buffer=0A=
vb2: dqbuf of buffer 0, with state 3=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_DQBUF 359696:21:10.00567723 =
index=3D0, type=3Dvid-cap, flags=3D0x00000005, field=3D0, sequence=3D0, =
memory=3Dmmap=0A=
saa7133[0] video (Avermedia PCI: bytesused=3D829440, =
offset/userptr=3D0x00000000, length=3D829440=0A=
saa7133[0] video (Avermedia PCI: timecode=3D00:00:00 type=3D0, =
flags=3D0x00000000, frames=3D0, userbits=3D0x00000000=0A=
saa7134_qbuf: f2354ee8 c2043e68=0A=
buffer_prepare: sglist:fab50000 num_pages:203=0A=
buffer_queue=0A=
buffer_queue f34b7800=0A=
vb2: qbuf of buffer 0 succeeded=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_QBUF 359696:21:10.00567723 =
index=3D0, type=3Dvid-cap, flags=3D0x00000005, field=3D0, sequence=3D0, =
memory=3Dmmap=0A=
saa7133[0] video (Avermedia PCI: bytesused=3D829440, =
offset/userptr=3D0x00000000, length=3D829440=0A=
saa7133[0] video (Avermedia PCI: timecode=3D00:00:00 type=3D0, =
flags=3D0x00000000, frames=3D0, userbits=3D0x00000000=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
saa7133[0]/irq[0,21278941]: r=3D0x1 s=3D0x10 DONE_RA0 | =
RA0=3Dvideo,a,odd,0=0A=
buffer_finish f34b6800=0A=
vb2: Done processing on buffer 1, state: 2=0A=
buffer_next f2ab2c00 [prev=3Df34b7a94/next=3Df2ab2e94]=0A=
buffer_activate buf=3Df2ab2c00=0A=
video_poll: f2354ee8=0A=
saa7134_set_dmabits=0A=
dmabits: task=3D0x01 ctrl=3D0x01 irq=3D0x3 split=3Dyes=0A=
buffer_next #2 prev=3Df34b7a94/next=3Df34b7a94=0A=
saa7133[0]/irq: no (more) work=0A=
saa7134_dqbuf: f2354ee8 c2043e68=0A=
vb2: dqbuf: Returning done buffer=0A=
vb2: dqbuf of buffer 1, with state 3=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_DQBUF 359696:21:10.00587756 =
index=3D1, type=3Dvid-cap, flags=3D0x00000005, field=3D0, sequence=3D0, =
memory=3Dmmap=0A=
saa7133[0] video (Avermedia PCI: bytesused=3D829440, =
offset/userptr=3D0x000cb000, length=3D829440=0A=
saa7133[0] video (Avermedia PCI: timecode=3D00:00:00 type=3D0, =
flags=3D0x00000000, frames=3D0, userbits=3D0x00000000=0A=
saa7134_qbuf: f2354ee8 c2043e68=0A=
buffer_prepare: sglist:fac1f000 num_pages:203=0A=
buffer_queue=0A=
buffer_queue f34b6800=0A=
vb2: qbuf of buffer 1 succeeded=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_QBUF 359696:21:10.00587756 =
index=3D1, type=3Dvid-cap, flags=3D0x00000005, field=3D0, sequence=3D0, =
memory=3Dmmap=0A=
saa7133[0] video (Avermedia PCI: bytesused=3D829440, =
offset/userptr=3D0x000cb000, length=3D829440=0A=
saa7133[0] video (Avermedia PCI: timecode=3D00:00:00 type=3D0, =
flags=3D0x00000000, frames=3D0, userbits=3D0x00000000=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
saa7133[0]/irq[0,21278946]: r=3D0x1 s=3D0x00 DONE_RA0 | =
RA0=3Dvideo,a,even,0=0A=
buffer_finish f2ab2c00=0A=
vb2: Done processing on buffer 2, state: 2=0A=
buffer_next f34b7800 [prev=3Df34b6a94/next=3Df34b7a94]=0A=
buffer_activate buf=3Df34b7800=0A=
saa7134_set_dmabits=0A=
dmabits: task=3D0x01 ctrl=3D0x01 irq=3D0x3 split=3Dyes=0A=
buffer_next #2 prev=3Df34b6a94/next=3Df34b6a94=0A=
saa7133[0]/irq: no (more) work=0A=
video_poll: f2354ee8=0A=
saa7134_dqbuf: f2354ee8 c2043e68=0A=
vb2: dqbuf: Returning done buffer=0A=
vb2: dqbuf of buffer 2, with state 3=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_DQBUF 359696:21:10.00607726 =
index=3D2, type=3Dvid-cap, flags=3D0x00000005, field=3D0, sequence=3D0, =
memory=3Dmmap=0A=
saa7133[0] video (Avermedia PCI: bytesused=3D829440, =
offset/userptr=3D0x00196000, length=3D829440=0A=
saa7133[0] video (Avermedia PCI: timecode=3D00:00:00 type=3D0, =
flags=3D0x00000000, frames=3D0, userbits=3D0x00000000=0A=
saa7134_qbuf: f2354ee8 c2043e68=0A=
buffer_prepare: sglist:facee000 num_pages:203=0A=
buffer_queue=0A=
buffer_queue f2ab2c00=0A=
vb2: qbuf of buffer 2 succeeded=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_QBUF 359696:21:10.00607726 =
index=3D2, type=3Dvid-cap, flags=3D0x00000005, field=3D0, sequence=3D0, =
memory=3Dmmap=0A=
saa7133[0] video (Avermedia PCI: bytesused=3D829440, =
offset/userptr=3D0x00196000, length=3D829440=0A=
saa7133[0] video (Avermedia PCI: timecode=3D00:00:00 type=3D0, =
flags=3D0x00000000, frames=3D0, userbits=3D0x00000000=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
saa7133[0]/irq[0,21278951]: r=3D0x1 s=3D0x10 DONE_RA0 | =
RA0=3Dvideo,a,odd,0=0A=
buffer_finish f34b7800=0A=
vb2: Done processing on buffer 0, state: 2=0A=
buffer_next f34b6800 [prev=3Df2ab2e94/next=3Df34b6a94]=0A=
buffer_activate buf=3Df34b6800=0A=
saa7134_set_dmabits=0A=
dmabits: task=3D0x01 ctrl=3D0x01 irq=3D0x3 split=3Dyes=0A=
buffer_next #2 prev=3Df2ab2e94/next=3Df2ab2e94=0A=
saa7133[0]/irq: no (more) work=0A=
video_poll: f2354ee8=0A=
saa7134_dqbuf: f2354ee8 c2043e68=0A=
vb2: dqbuf: Returning done buffer=0A=
vb2: dqbuf of buffer 0, with state 3=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_DQBUF 359696:21:10.00627756 =
index=3D0, type=3Dvid-cap, flags=3D0x00000005, field=3D0, sequence=3D0, =
memory=3Dmmap=0A=
saa7133[0] video (Avermedia PCI: bytesused=3D829440, =
offset/userptr=3D0x00000000, length=3D829440=0A=
saa7133[0] video (Avermedia PCI: timecode=3D00:00:00 type=3D0, =
flags=3D0x00000000, frames=3D0, userbits=3D0x00000000=0A=
saa7134_qbuf: f2354ee8 c2043e68=0A=
buffer_prepare: sglist:fab50000 num_pages:203=0A=
buffer_queue=0A=
buffer_queue f34b7800=0A=
vb2: qbuf of buffer 0 succeeded=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_QBUF 359696:21:10.00627756 =
index=3D0, type=3Dvid-cap, flags=3D0x00000005, field=3D0, sequence=3D0, =
memory=3Dmmap=0A=
saa7133[0] video (Avermedia PCI: bytesused=3D829440, =
offset/userptr=3D0x00000000, length=3D829440=0A=
saa7133[0] video (Avermedia PCI: timecode=3D00:00:00 type=3D0, =
flags=3D0x00000000, frames=3D0, userbits=3D0x00000000=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
saa7133[0]/irq[0,21278956]: r=3D0x1 s=3D0x00 DONE_RA0 | =
RA0=3Dvideo,a,even,0=0A=
buffer_finish f34b6800=0A=
vb2: Done processing on buffer 1, state: 2=0A=
buffer_next f2ab2c00 [prev=3Df34b7a94/next=3Df2ab2e94]=0A=
buffer_activate buf=3Df2ab2c00=0A=
saa7134_set_dmabits=0A=
dmabits: task=3D0x01 ctrl=3D0x01 irq=3D0x3 split=3Dyes=0A=
buffer_next #2 prev=3Df34b7a94/next=3Df34b7a94=0A=
saa7133[0]/irq: no (more) work=0A=
video_poll: f2354ee8=0A=
saa7134_dqbuf: f2354ee8 c2043e68=0A=
vb2: dqbuf: Returning done buffer=0A=
vb2: dqbuf of buffer 1, with state 3=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_DQBUF 359696:21:10.00647725 =
index=3D1, type=3Dvid-cap, flags=3D0x00000005, field=3D0, sequence=3D0, =
memory=3Dmmap=0A=
saa7133[0] video (Avermedia PCI: bytesused=3D829440, =
offset/userptr=3D0x000cb000, length=3D829440=0A=
saa7133[0] video (Avermedia PCI: timecode=3D00:00:00 type=3D0, =
flags=3D0x00000000, frames=3D0, userbits=3D0x00000000=0A=
saa7134_qbuf: f2354ee8 c2043e68=0A=
buffer_prepare: sglist:fac1f000 num_pages:203=0A=
buffer_queue=0A=
buffer_queue f34b6800=0A=
vb2: qbuf of buffer 1 succeeded=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_QBUF 359696:21:10.00647725 =
index=3D1, type=3Dvid-cap, flags=3D0x00000005, field=3D0, sequence=3D0, =
memory=3Dmmap=0A=
saa7133[0] video (Avermedia PCI: bytesused=3D829440, =
offset/userptr=3D0x000cb000, length=3D829440=0A=
saa7133[0] video (Avermedia PCI: timecode=3D00:00:00 type=3D0, =
flags=3D0x00000000, frames=3D0, userbits=3D0x00000000=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
saa7133[0]/irq[0,21278961]: r=3D0x1 s=3D0x10 DONE_RA0 | =
RA0=3Dvideo,a,odd,0=0A=
buffer_finish f2ab2c00=0A=
vb2: Done processing on buffer 2, state: 2=0A=
buffer_next f34b7800 [prev=3Df34b6a94/next=3Df34b7a94]=0A=
buffer_activate buf=3Df34b7800=0A=
saa7134_set_dmabits=0A=
dmabits: task=3D0x01 ctrl=3D0x01 irq=3D0x3 split=3Dyes=0A=
buffer_next #2 prev=3Df34b6a94/next=3Df34b6a94=0A=
saa7133[0]/irq: no (more) work=0A=
video_poll: f2354ee8=0A=
saa7134_dqbuf: f2354ee8 c2043e68=0A=
vb2: dqbuf: Returning done buffer=0A=
vb2: dqbuf of buffer 2, with state 3=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_DQBUF 359696:21:10.00667757 =
index=3D2, type=3Dvid-cap, flags=3D0x00000005, field=3D0, sequence=3D0, =
memory=3Dmmap=0A=
saa7133[0] video (Avermedia PCI: bytesused=3D829440, =
offset/userptr=3D0x00196000, length=3D829440=0A=
saa7133[0] video (Avermedia PCI: timecode=3D00:00:00 type=3D0, =
flags=3D0x00000000, frames=3D0, userbits=3D0x00000000=0A=
saa7134_qbuf: f2354ee8 c2043e68=0A=
buffer_prepare: sglist:facee000 num_pages:203=0A=
buffer_queue=0A=
buffer_queue f2ab2c00=0A=
vb2: qbuf of buffer 2 succeeded=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_QBUF 359696:21:10.00667757 =
index=3D2, type=3Dvid-cap, flags=3D0x00000005, field=3D0, sequence=3D0, =
memory=3Dmmap=0A=
saa7133[0] video (Avermedia PCI: bytesused=3D829440, =
offset/userptr=3D0x00196000, length=3D829440=0A=
saa7133[0] video (Avermedia PCI: timecode=3D00:00:00 type=3D0, =
flags=3D0x00000000, frames=3D0, userbits=3D0x00000000=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
saa7133[0]/irq[0,21278966]: r=3D0x1 s=3D0x00 DONE_RA0 | =
RA0=3Dvideo,a,even,0=0A=
buffer_finish f34b7800=0A=
vb2: Done processing on buffer 0, state: 2=0A=
buffer_next f34b6800 [prev=3Df2ab2e94/next=3Df34b6a94]=0A=
buffer_activate buf=3Df34b6800=0A=
saa7134_set_dmabits=0A=
dmabits: task=3D0x01 ctrl=3D0x01 irq=3D0x3 split=3Dyes=0A=
buffer_next #2 prev=3Df2ab2e94/next=3Df2ab2e94=0A=
saa7133[0]/irq: no (more) work=0A=
video_poll: f2354ee8=0A=
saa7134_dqbuf: f2354ee8 c2043e68=0A=
vb2: dqbuf: Returning done buffer=0A=
vb2: dqbuf of buffer 0, with state 3=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_DQBUF 359696:21:10.00687726 =
index=3D0, type=3Dvid-cap, flags=3D0x00000005, field=3D0, sequence=3D0, =
memory=3Dmmap=0A=
saa7133[0] video (Avermedia PCI: bytesused=3D829440, =
offset/userptr=3D0x00000000, length=3D829440=0A=
saa7133[0] video (Avermedia PCI: timecode=3D00:00:00 type=3D0, =
flags=3D0x00000000, frames=3D0, userbits=3D0x00000000=0A=
saa7134_qbuf: f2354ee8 c2043e68=0A=
buffer_prepare: sglist:fab50000 num_pages:203=0A=
buffer_queue=0A=
buffer_queue f34b7800=0A=
vb2: qbuf of buffer 0 succeeded=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_QBUF 359696:21:10.00687726 =
index=3D0, type=3Dvid-cap, flags=3D0x00000005, field=3D0, sequence=3D0, =
memory=3Dmmap=0A=
saa7133[0] video (Avermedia PCI: bytesused=3D829440, =
offset/userptr=3D0x00000000, length=3D829440=0A=
saa7133[0] video (Avermedia PCI: timecode=3D00:00:00 type=3D0, =
flags=3D0x00000000, frames=3D0, userbits=3D0x00000000=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
saa7133[0]/irq[0,21278971]: r=3D0x1 s=3D0x10 DONE_RA0 | =
RA0=3Dvideo,a,odd,0=0A=
buffer_finish f34b6800=0A=
vb2: Done processing on buffer 1, state: 2=0A=
buffer_next f2ab2c00 [prev=3Df34b7a94/next=3Df2ab2e94]=0A=
buffer_activate buf=3Df2ab2c00=0A=
saa7134_set_dmabits=0A=
dmabits: task=3D0x01 ctrl=3D0x01 irq=3D0x3 split=3Dyes=0A=
buffer_next #2 prev=3Df34b7a94/next=3Df34b7a94=0A=
saa7133[0]/irq: no (more) work=0A=
video_poll: f2354ee8=0A=
saa7134_dqbuf: f2354ee8 c2043e68=0A=
vb2: dqbuf: Returning done buffer=0A=
vb2: dqbuf of buffer 1, with state 3=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_DQBUF 359696:21:10.00707758 =
index=3D1, type=3Dvid-cap, flags=3D0x00000005, field=3D0, sequence=3D0, =
memory=3Dmmap=0A=
saa7133[0] video (Avermedia PCI: bytesused=3D829440, =
offset/userptr=3D0x000cb000, length=3D829440=0A=
saa7133[0] video (Avermedia PCI: timecode=3D00:00:00 type=3D0, =
flags=3D0x00000000, frames=3D0, userbits=3D0x00000000=0A=
saa7134_qbuf: f2354ee8 c2043e68=0A=
buffer_prepare: sglist:fac1f000 num_pages:203=0A=
buffer_queue=0A=
buffer_queue f34b6800=0A=
vb2: qbuf of buffer 1 succeeded=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_QBUF 359696:21:10.00707758 =
index=3D1, type=3Dvid-cap, flags=3D0x00000005, field=3D0, sequence=3D0, =
memory=3Dmmap=0A=
saa7133[0] video (Avermedia PCI: bytesused=3D829440, =
offset/userptr=3D0x000cb000, length=3D829440=0A=
saa7133[0] video (Avermedia PCI: timecode=3D00:00:00 type=3D0, =
flags=3D0x00000000, frames=3D0, userbits=3D0x00000000=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
saa7133[0]/irq[0,21278976]: r=3D0x1 s=3D0x00 DONE_RA0 | =
RA0=3Dvideo,a,even,0=0A=
buffer_finish f2ab2c00=0A=
vb2: Done processing on buffer 2, state: 2=0A=
buffer_next f34b7800 [prev=3Df34b6a94/next=3Df34b7a94]=0A=
buffer_activate buf=3Df34b7800=0A=
saa7134_set_dmabits=0A=
dmabits: task=3D0x01 ctrl=3D0x01 irq=3D0x3 split=3Dyes=0A=
buffer_next #2 prev=3Df34b6a94/next=3Df34b6a94=0A=
saa7133[0]/irq: no (more) work=0A=
video_poll: f2354ee8=0A=
saa7134_dqbuf: f2354ee8 c2043e68=0A=
vb2: dqbuf: Returning done buffer=0A=
vb2: dqbuf of buffer 2, with state 3=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_DQBUF 359696:21:10.00727726 =
index=3D2, type=3Dvid-cap, flags=3D0x00000005, field=3D0, sequence=3D0, =
memory=3Dmmap=0A=
saa7133[0] video (Avermedia PCI: bytesused=3D829440, =
offset/userptr=3D0x00196000, length=3D829440=0A=
saa7133[0] video (Avermedia PCI: timecode=3D00:00:00 type=3D0, =
flags=3D0x00000000, frames=3D0, userbits=3D0x00000000=0A=
saa7134_qbuf: f2354ee8 c2043e68=0A=
buffer_prepare: sglist:facee000 num_pages:203=0A=
buffer_queue=0A=
buffer_queue f2ab2c00=0A=
vb2: qbuf of buffer 2 succeeded=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_QBUF 359696:21:10.00727726 =
index=3D2, type=3Dvid-cap, flags=3D0x00000005, field=3D0, sequence=3D0, =
memory=3Dmmap=0A=
saa7133[0] video (Avermedia PCI: bytesused=3D829440, =
offset/userptr=3D0x00196000, length=3D829440=0A=
saa7133[0] video (Avermedia PCI: timecode=3D00:00:00 type=3D0, =
flags=3D0x00000000, frames=3D0, userbits=3D0x00000000=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
saa7133[0]/irq[0,21278981]: r=3D0x1 s=3D0x10 DONE_RA0 | =
RA0=3Dvideo,a,odd,0=0A=
buffer_finish f34b7800=0A=
vb2: Done processing on buffer 0, state: 2=0A=
buffer_next f34b6800 [prev=3Df2ab2e94/next=3Df34b6a94]=0A=
buffer_activate buf=3Df34b6800=0A=
saa7134_set_dmabits=0A=
dmabits: task=3D0x01 ctrl=3D0x01 irq=3D0x3 split=3Dyes=0A=
buffer_next #2 prev=3Df2ab2e94/next=3Df2ab2e94=0A=
saa7133[0]/irq: no (more) work=0A=
video_poll: f2354ee8=0A=
saa7134_dqbuf: f2354ee8 c2043e68=0A=
vb2: dqbuf: Returning done buffer=0A=
vb2: dqbuf of buffer 0, with state 3=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_DQBUF 359696:21:10.00747759 =
index=3D0, type=3Dvid-cap, flags=3D0x00000005, field=3D0, sequence=3D0, =
memory=3Dmmap=0A=
saa7133[0] video (Avermedia PCI: bytesused=3D829440, =
offset/userptr=3D0x00000000, length=3D829440=0A=
saa7133[0] video (Avermedia PCI: timecode=3D00:00:00 type=3D0, =
flags=3D0x00000000, frames=3D0, userbits=3D0x00000000=0A=
saa7134_qbuf: f2354ee8 c2043e68=0A=
buffer_prepare: sglist:fab50000 num_pages:203=0A=
buffer_queue=0A=
buffer_queue f34b7800=0A=
vb2: qbuf of buffer 0 succeeded=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_QBUF 359696:21:10.00747759 =
index=3D0, type=3Dvid-cap, flags=3D0x00000005, field=3D0, sequence=3D0, =
memory=3Dmmap=0A=
saa7133[0] video (Avermedia PCI: bytesused=3D829440, =
offset/userptr=3D0x00000000, length=3D829440=0A=
saa7133[0] video (Avermedia PCI: timecode=3D00:00:00 type=3D0, =
flags=3D0x00000000, frames=3D0, userbits=3D0x00000000=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
saa7133[0]/irq[0,21278986]: r=3D0x1 s=3D0x00 DONE_RA0 | =
RA0=3Dvideo,a,even,0=0A=
buffer_finish f34b6800=0A=
vb2: Done processing on buffer 1, state: 2=0A=
buffer_next f2ab2c00 [prev=3Df34b7a94/next=3Df2ab2e94]=0A=
buffer_activate buf=3Df2ab2c00=0A=
saa7134_set_dmabits=0A=
dmabits: task=3D0x01 ctrl=3D0x01 irq=3D0x3 split=3Dyes=0A=
buffer_next #2 prev=3Df34b7a94/next=3Df34b7a94=0A=
saa7133[0]/irq: no (more) work=0A=
video_poll: f2354ee8=0A=
saa7134_dqbuf: f2354ee8 c2043e68=0A=
vb2: dqbuf: Returning done buffer=0A=
vb2: dqbuf of buffer 1, with state 3=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_DQBUF 359696:21:10.00767726 =
index=3D1, type=3Dvid-cap, flags=3D0x00000005, field=3D0, sequence=3D0, =
memory=3Dmmap=0A=
saa7133[0] video (Avermedia PCI: bytesused=3D829440, =
offset/userptr=3D0x000cb000, length=3D829440=0A=
saa7133[0] video (Avermedia PCI: timecode=3D00:00:00 type=3D0, =
flags=3D0x00000000, frames=3D0, userbits=3D0x00000000=0A=
saa7134_qbuf: f2354ee8 c2043e68=0A=
buffer_prepare: sglist:fac1f000 num_pages:203=0A=
buffer_queue=0A=
buffer_queue f34b6800=0A=
vb2: qbuf of buffer 1 succeeded=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_QBUF 359696:21:10.00767726 =
index=3D1, type=3Dvid-cap, flags=3D0x00000005, field=3D0, sequence=3D0, =
memory=3Dmmap=0A=
saa7133[0] video (Avermedia PCI: bytesused=3D829440, =
offset/userptr=3D0x000cb000, length=3D829440=0A=
saa7133[0] video (Avermedia PCI: timecode=3D00:00:00 type=3D0, =
flags=3D0x00000000, frames=3D0, userbits=3D0x00000000=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
saa7133[0]/irq[0,21278991]: r=3D0x1 s=3D0x10 DONE_RA0 | =
RA0=3Dvideo,a,odd,0=0A=
buffer_finish f2ab2c00=0A=
vb2: Done processing on buffer 2, state: 2=0A=
buffer_next f34b7800 [prev=3Df34b6a94/next=3Df34b7a94]=0A=
buffer_activate buf=3Df34b7800=0A=
saa7134_set_dmabits=0A=
dmabits: task=3D0x01 ctrl=3D0x01 irq=3D0x3 split=3Dyes=0A=
buffer_next #2 prev=3Df34b6a94/next=3Df34b6a94=0A=
saa7133[0]/irq: no (more) work=0A=
video_poll: f2354ee8=0A=
saa7134_dqbuf: f2354ee8 c2043e68=0A=
vb2: dqbuf: Returning done buffer=0A=
vb2: dqbuf of buffer 2, with state 3=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_DQBUF 359696:21:10.00787759 =
index=3D2, type=3Dvid-cap, flags=3D0x00000005, field=3D0, sequence=3D0, =
memory=3Dmmap=0A=
saa7133[0] video (Avermedia PCI: bytesused=3D829440, =
offset/userptr=3D0x00196000, length=3D829440=0A=
saa7133[0] video (Avermedia PCI: timecode=3D00:00:00 type=3D0, =
flags=3D0x00000000, frames=3D0, userbits=3D0x00000000=0A=
saa7134_qbuf: f2354ee8 c2043e68=0A=
buffer_prepare: sglist:facee000 num_pages:203=0A=
buffer_queue=0A=
buffer_queue f2ab2c00=0A=
vb2: qbuf of buffer 2 succeeded=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_QBUF 359696:21:10.00787759 =
index=3D2, type=3Dvid-cap, flags=3D0x00000005, field=3D0, sequence=3D0, =
memory=3Dmmap=0A=
saa7133[0] video (Avermedia PCI: bytesused=3D829440, =
offset/userptr=3D0x00196000, length=3D829440=0A=
saa7133[0] video (Avermedia PCI: timecode=3D00:00:00 type=3D0, =
flags=3D0x00000000, frames=3D0, userbits=3D0x00000000=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
saa7133[0]/irq[0,21278996]: r=3D0x1 s=3D0x00 DONE_RA0 | =
RA0=3Dvideo,a,even,0=0A=
buffer_finish f34b7800=0A=
vb2: Done processing on buffer 0, state: 2=0A=
buffer_next f34b6800 [prev=3Df2ab2e94/next=3Df34b6a94]=0A=
buffer_activate buf=3Df34b6800=0A=
saa7134_set_dmabits=0A=
dmabits: task=3D0x01 ctrl=3D0x01 irq=3D0x3 split=3Dyes=0A=
buffer_next #2 prev=3Df2ab2e94/next=3Df2ab2e94=0A=
saa7133[0]/irq: no (more) work=0A=
video_poll: f2354ee8=0A=
saa7134_dqbuf: f2354ee8 c2043e68=0A=
vb2: dqbuf: Returning done buffer=0A=
vb2: dqbuf of buffer 0, with state 3=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_DQBUF 359696:21:10.00807728 =
index=3D0, type=3Dvid-cap, flags=3D0x00000005, field=3D0, sequence=3D0, =
memory=3Dmmap=0A=
saa7133[0] video (Avermedia PCI: bytesused=3D829440, =
offset/userptr=3D0x00000000, length=3D829440=0A=
saa7133[0] video (Avermedia PCI: timecode=3D00:00:00 type=3D0, =
flags=3D0x00000000, frames=3D0, userbits=3D0x00000000=0A=
saa7134_qbuf: f2354ee8 c2043e68=0A=
buffer_prepare: sglist:fab50000 num_pages:203=0A=
buffer_queue=0A=
buffer_queue f34b7800=0A=
vb2: qbuf of buffer 0 succeeded=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_QBUF 359696:21:10.00807728 =
index=3D0, type=3Dvid-cap, flags=3D0x00000005, field=3D0, sequence=3D0, =
memory=3Dmmap=0A=
saa7133[0] video (Avermedia PCI: bytesused=3D829440, =
offset/userptr=3D0x00000000, length=3D829440=0A=
saa7133[0] video (Avermedia PCI: timecode=3D00:00:00 type=3D0, =
flags=3D0x00000000, frames=3D0, userbits=3D0x00000000=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
saa7133[0]/irq[0,21279001]: r=3D0x1 s=3D0x10 DONE_RA0 | =
RA0=3Dvideo,a,odd,0=0A=
buffer_finish f34b6800=0A=
vb2: Done processing on buffer 1, state: 2=0A=
buffer_next f2ab2c00 [prev=3Df34b7a94/next=3Df2ab2e94]=0A=
buffer_activate buf=3Df2ab2c00=0A=
saa7134_set_dmabits=0A=
dmabits: task=3D0x01 ctrl=3D0x01 irq=3D0x3 split=3Dyes=0A=
buffer_next #2 prev=3Df34b7a94/next=3Df34b7a94=0A=
saa7133[0]/irq: no (more) work=0A=
video_poll: f2354ee8=0A=
saa7134_dqbuf: f2354ee8 c2043e68=0A=
vb2: dqbuf: Returning done buffer=0A=
vb2: dqbuf of buffer 1, with state 3=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_DQBUF 359696:21:10.00827760 =
index=3D1, type=3Dvid-cap, flags=3D0x00000005, field=3D0, sequence=3D0, =
memory=3Dmmap=0A=
saa7133[0] video (Avermedia PCI: bytesused=3D829440, =
offset/userptr=3D0x000cb000, length=3D829440=0A=
saa7133[0] video (Avermedia PCI: timecode=3D00:00:00 type=3D0, =
flags=3D0x00000000, frames=3D0, userbits=3D0x00000000=0A=
saa7134_qbuf: f2354ee8 c2043e68=0A=
buffer_prepare: sglist:fac1f000 num_pages:203=0A=
buffer_queue=0A=
buffer_queue f34b6800=0A=
vb2: qbuf of buffer 1 succeeded=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_QBUF 359696:21:10.00827760 =
index=3D1, type=3Dvid-cap, flags=3D0x00000005, field=3D0, sequence=3D0, =
memory=3Dmmap=0A=
saa7133[0] video (Avermedia PCI: bytesused=3D829440, =
offset/userptr=3D0x000cb000, length=3D829440=0A=
saa7133[0] video (Avermedia PCI: timecode=3D00:00:00 type=3D0, =
flags=3D0x00000000, frames=3D0, userbits=3D0x00000000=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
saa7133[0]/irq[0,21279006]: r=3D0x1 s=3D0x00 DONE_RA0 | =
RA0=3Dvideo,a,even,0=0A=
buffer_finish f2ab2c00=0A=
vb2: Done processing on buffer 2, state: 2=0A=
buffer_next f34b7800 [prev=3Df34b6a94/next=3Df34b7a94]=0A=
buffer_activate buf=3Df34b7800=0A=
saa7134_set_dmabits=0A=
dmabits: task=3D0x01 ctrl=3D0x01 irq=3D0x3 split=3Dyes=0A=
buffer_next #2 prev=3Df34b6a94/next=3Df34b6a94=0A=
saa7133[0]/irq: no (more) work=0A=
video_poll: f2354ee8=0A=
saa7134_dqbuf: f2354ee8 c2043e68=0A=
vb2: dqbuf: Returning done buffer=0A=
vb2: dqbuf of buffer 2, with state 3=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_DQBUF 359696:21:10.00847729 =
index=3D2, type=3Dvid-cap, flags=3D0x00000005, field=3D0, sequence=3D0, =
memory=3Dmmap=0A=
saa7133[0] video (Avermedia PCI: bytesused=3D829440, =
offset/userptr=3D0x00196000, length=3D829440=0A=
saa7133[0] video (Avermedia PCI: timecode=3D00:00:00 type=3D0, =
flags=3D0x00000000, frames=3D0, userbits=3D0x00000000=0A=
saa7134_qbuf: f2354ee8 c2043e68=0A=
buffer_prepare: sglist:facee000 num_pages:203=0A=
buffer_queue=0A=
buffer_queue f2ab2c00=0A=
vb2: qbuf of buffer 2 succeeded=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_QBUF 359696:21:10.00847729 =
index=3D2, type=3Dvid-cap, flags=3D0x00000005, field=3D0, sequence=3D0, =
memory=3Dmmap=0A=
saa7133[0] video (Avermedia PCI: bytesused=3D829440, =
offset/userptr=3D0x00196000, length=3D829440=0A=
saa7133[0] video (Avermedia PCI: timecode=3D00:00:00 type=3D0, =
flags=3D0x00000000, frames=3D0, userbits=3D0x00000000=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
saa7133[0]/irq[0,21279011]: r=3D0x1 s=3D0x10 DONE_RA0 | =
RA0=3Dvideo,a,odd,0=0A=
buffer_finish f34b7800=0A=
vb2: Done processing on buffer 0, state: 2=0A=
buffer_next f34b6800 [prev=3Df2ab2e94/next=3Df34b6a94]=0A=
buffer_activate buf=3Df34b6800=0A=
saa7134_set_dmabits=0A=
dmabits: task=3D0x01 ctrl=3D0x01 irq=3D0x3 split=3Dyes=0A=
buffer_next #2 prev=3Df2ab2e94/next=3Df2ab2e94=0A=
saa7133[0]/irq: no (more) work=0A=
video_poll: f2354ee8=0A=
saa7134_dqbuf: f2354ee8 c2043e68=0A=
vb2: dqbuf: Returning done buffer=0A=
vb2: dqbuf of buffer 0, with state 3=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_DQBUF 359696:21:10.00867760 =
index=3D0, type=3Dvid-cap, flags=3D0x00000005, field=3D0, sequence=3D0, =
memory=3Dmmap=0A=
saa7133[0] video (Avermedia PCI: bytesused=3D829440, =
offset/userptr=3D0x00000000, length=3D829440=0A=
saa7133[0] video (Avermedia PCI: timecode=3D00:00:00 type=3D0, =
flags=3D0x00000000, frames=3D0, userbits=3D0x00000000=0A=
saa7134_qbuf: f2354ee8 c2043e68=0A=
buffer_prepare: sglist:fab50000 num_pages:203=0A=
buffer_queue=0A=
buffer_queue f34b7800=0A=
vb2: qbuf of buffer 0 succeeded=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_QBUF 359696:21:10.00867760 =
index=3D0, type=3Dvid-cap, flags=3D0x00000005, field=3D0, sequence=3D0, =
memory=3Dmmap=0A=
saa7133[0] video (Avermedia PCI: bytesused=3D829440, =
offset/userptr=3D0x00000000, length=3D829440=0A=
saa7133[0] video (Avermedia PCI: timecode=3D00:00:00 type=3D0, =
flags=3D0x00000000, frames=3D0, userbits=3D0x00000000=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
saa7133[0]/irq[0,21279016]: r=3D0x1 s=3D0x00 DONE_RA0 | =
RA0=3Dvideo,a,even,0=0A=
buffer_finish f34b6800=0A=
vb2: Done processing on buffer 1, state: 2=0A=
buffer_next f2ab2c00 [prev=3Df34b7a94/next=3Df2ab2e94]=0A=
buffer_activate buf=3Df2ab2c00=0A=
saa7134_set_dmabits=0A=
dmabits: task=3D0x01 ctrl=3D0x01 irq=3D0x3 split=3Dyes=0A=
buffer_next #2 prev=3Df34b7a94/next=3Df34b7a94=0A=
saa7133[0]/irq: no (more) work=0A=
video_poll: f2354ee8=0A=
saa7134_dqbuf: f2354ee8 c2043e68=0A=
vb2: dqbuf: Returning done buffer=0A=
vb2: dqbuf of buffer 1, with state 3=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_DQBUF 359696:21:10.00887728 =
index=3D1, type=3Dvid-cap, flags=3D0x00000005, field=3D0, sequence=3D0, =
memory=3Dmmap=0A=
saa7133[0] video (Avermedia PCI: bytesused=3D829440, =
offset/userptr=3D0x000cb000, length=3D829440=0A=
saa7133[0] video (Avermedia PCI: timecode=3D00:00:00 type=3D0, =
flags=3D0x00000000, frames=3D0, userbits=3D0x00000000=0A=
saa7134_qbuf: f2354ee8 c2043e68=0A=
buffer_prepare: sglist:fac1f000 num_pages:203=0A=
buffer_queue=0A=
buffer_queue f34b6800=0A=
vb2: qbuf of buffer 1 succeeded=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_QBUF 359696:21:10.00887728 =
index=3D1, type=3Dvid-cap, flags=3D0x00000005, field=3D0, sequence=3D0, =
memory=3Dmmap=0A=
saa7133[0] video (Avermedia PCI: bytesused=3D829440, =
offset/userptr=3D0x000cb000, length=3D829440=0A=
saa7133[0] video (Avermedia PCI: timecode=3D00:00:00 type=3D0, =
flags=3D0x00000000, frames=3D0, userbits=3D0x00000000=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
saa7133[0]/irq[0,21279021]: r=3D0x1 s=3D0x10 DONE_RA0 | =
RA0=3Dvideo,a,odd,0=0A=
buffer_finish f2ab2c00=0A=
vb2: Done processing on buffer 2, state: 2=0A=
buffer_next f34b7800 [prev=3Df34b6a94/next=3Df34b7a94]=0A=
buffer_activate buf=3Df34b7800=0A=
saa7134_set_dmabits=0A=
dmabits: task=3D0x01 ctrl=3D0x01 irq=3D0x3 split=3Dyes=0A=
buffer_next #2 prev=3Df34b6a94/next=3Df34b6a94=0A=
saa7133[0]/irq: no (more) work=0A=
video_poll: f2354ee8=0A=
saa7134_dqbuf: f2354ee8 c2043e68=0A=
vb2: dqbuf: Returning done buffer=0A=
vb2: dqbuf of buffer 2, with state 3=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_DQBUF 359696:21:10.00907760 =
index=3D2, type=3Dvid-cap, flags=3D0x00000005, field=3D0, sequence=3D0, =
memory=3Dmmap=0A=
saa7133[0] video (Avermedia PCI: bytesused=3D829440, =
offset/userptr=3D0x00196000, length=3D829440=0A=
saa7133[0] video (Avermedia PCI: timecode=3D00:00:00 type=3D0, =
flags=3D0x00000000, frames=3D0, userbits=3D0x00000000=0A=
saa7134_qbuf: f2354ee8 c2043e68=0A=
buffer_prepare: sglist:facee000 num_pages:203=0A=
buffer_queue=0A=
buffer_queue f2ab2c00=0A=
vb2: qbuf of buffer 2 succeeded=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_QBUF 359696:21:10.00907760 =
index=3D2, type=3Dvid-cap, flags=3D0x00000005, field=3D0, sequence=3D0, =
memory=3Dmmap=0A=
saa7133[0] video (Avermedia PCI: bytesused=3D829440, =
offset/userptr=3D0x00196000, length=3D829440=0A=
saa7133[0] video (Avermedia PCI: timecode=3D00:00:00 type=3D0, =
flags=3D0x00000000, frames=3D0, userbits=3D0x00000000=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
saa7133[0]/irq[0,21279026]: r=3D0x1 s=3D0x00 DONE_RA0 | =
RA0=3Dvideo,a,even,0=0A=
buffer_finish f34b7800=0A=
vb2: Done processing on buffer 0, state: 2=0A=
buffer_next f34b6800 [prev=3Df2ab2e94/next=3Df34b6a94]=0A=
buffer_activate buf=3Df34b6800=0A=
saa7134_set_dmabits=0A=
dmabits: task=3D0x01 ctrl=3D0x01 irq=3D0x3 split=3Dyes=0A=
buffer_next #2 prev=3Df2ab2e94/next=3Df2ab2e94=0A=
saa7133[0]/irq: no (more) work=0A=
video_poll: f2354ee8=0A=
saa7134_dqbuf: f2354ee8 c2043e68=0A=
vb2: dqbuf: Returning done buffer=0A=
vb2: dqbuf of buffer 0, with state 3=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_DQBUF 359696:21:10.00927728 =
index=3D0, type=3Dvid-cap, flags=3D0x00000005, field=3D0, sequence=3D0, =
memory=3Dmmap=0A=
saa7133[0] video (Avermedia PCI: bytesused=3D829440, =
offset/userptr=3D0x00000000, length=3D829440=0A=
saa7133[0] video (Avermedia PCI: timecode=3D00:00:00 type=3D0, =
flags=3D0x00000000, frames=3D0, userbits=3D0x00000000=0A=
saa7134_qbuf: f2354ee8 c2043e68=0A=
buffer_prepare: sglist:fab50000 num_pages:203=0A=
buffer_queue=0A=
buffer_queue f34b7800=0A=
vb2: qbuf of buffer 0 succeeded=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_QBUF 359696:21:10.00927728 =
index=3D0, type=3Dvid-cap, flags=3D0x00000005, field=3D0, sequence=3D0, =
memory=3Dmmap=0A=
saa7133[0] video (Avermedia PCI: bytesused=3D829440, =
offset/userptr=3D0x00000000, length=3D829440=0A=
saa7133[0] video (Avermedia PCI: timecode=3D00:00:00 type=3D0, =
flags=3D0x00000000, frames=3D0, userbits=3D0x00000000=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
saa7133[0]/irq[0,21279031]: r=3D0x1 s=3D0x10 DONE_RA0 | =
RA0=3Dvideo,a,odd,0=0A=
buffer_finish f34b6800=0A=
vb2: Done processing on buffer 1, state: 2=0A=
buffer_next f2ab2c00 [prev=3Df34b7a94/next=3Df2ab2e94]=0A=
buffer_activate buf=3Df2ab2c00=0A=
saa7134_set_dmabits=0A=
dmabits: task=3D0x01 ctrl=3D0x01 irq=3D0x3 split=3Dyes=0A=
buffer_next #2 prev=3Df34b7a94/next=3Df34b7a94=0A=
saa7133[0]/irq: no (more) work=0A=
video_poll: f2354ee8=0A=
saa7134_dqbuf: f2354ee8 c2043e68=0A=
vb2: dqbuf: Returning done buffer=0A=
vb2: dqbuf of buffer 1, with state 3=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_DQBUF 359696:21:10.00947762 =
index=3D1, type=3Dvid-cap, flags=3D0x00000005, field=3D0, sequence=3D0, =
memory=3Dmmap=0A=
saa7133[0] video (Avermedia PCI: bytesused=3D829440, =
offset/userptr=3D0x000cb000, length=3D829440=0A=
saa7133[0] video (Avermedia PCI: timecode=3D00:00:00 type=3D0, =
flags=3D0x00000000, frames=3D0, userbits=3D0x00000000=0A=
saa7134_qbuf: f2354ee8 c2043e68=0A=
buffer_prepare: sglist:fac1f000 num_pages:203=0A=
buffer_queue=0A=
buffer_queue f34b6800=0A=
vb2: qbuf of buffer 1 succeeded=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_QBUF 359696:21:10.00947762 =
index=3D1, type=3Dvid-cap, flags=3D0x00000005, field=3D0, sequence=3D0, =
memory=3Dmmap=0A=
saa7133[0] video (Avermedia PCI: bytesused=3D829440, =
offset/userptr=3D0x000cb000, length=3D829440=0A=
saa7133[0] video (Avermedia PCI: timecode=3D00:00:00 type=3D0, =
flags=3D0x00000000, frames=3D0, userbits=3D0x00000000=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
saa7133[0]/irq[0,21279036]: r=3D0x1 s=3D0x00 DONE_RA0 | =
RA0=3Dvideo,a,even,0=0A=
buffer_finish f2ab2c00=0A=
vb2: Done processing on buffer 2, state: 2=0A=
buffer_next f34b7800 [prev=3Df34b6a94/next=3Df34b7a94]=0A=
buffer_activate buf=3Df34b7800=0A=
saa7134_set_dmabits=0A=
dmabits: task=3D0x01 ctrl=3D0x01 irq=3D0x3 split=3Dyes=0A=
buffer_next #2 prev=3Df34b6a94/next=3Df34b6a94=0A=
saa7133[0]/irq: no (more) work=0A=
video_poll: f2354ee8=0A=
saa7134_dqbuf: f2354ee8 c2043e68=0A=
vb2: dqbuf: Returning done buffer=0A=
vb2: dqbuf of buffer 2, with state 3=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_DQBUF 359696:21:10.00967731 =
index=3D2, type=3Dvid-cap, flags=3D0x00000005, field=3D0, sequence=3D0, =
memory=3Dmmap=0A=
saa7133[0] video (Avermedia PCI: bytesused=3D829440, =
offset/userptr=3D0x00196000, length=3D829440=0A=
saa7133[0] video (Avermedia PCI: timecode=3D00:00:00 type=3D0, =
flags=3D0x00000000, frames=3D0, userbits=3D0x00000000=0A=
saa7134_qbuf: f2354ee8 c2043e68=0A=
buffer_prepare: sglist:facee000 num_pages:203=0A=
buffer_queue=0A=
buffer_queue f2ab2c00=0A=
vb2: qbuf of buffer 2 succeeded=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_QBUF 359696:21:10.00967731 =
index=3D2, type=3Dvid-cap, flags=3D0x00000005, field=3D0, sequence=3D0, =
memory=3Dmmap=0A=
saa7133[0] video (Avermedia PCI: bytesused=3D829440, =
offset/userptr=3D0x00196000, length=3D829440=0A=
saa7133[0] video (Avermedia PCI: timecode=3D00:00:00 type=3D0, =
flags=3D0x00000000, frames=3D0, userbits=3D0x00000000=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
saa7133[0]/irq[0,21279041]: r=3D0x1 s=3D0x10 DONE_RA0 | =
RA0=3Dvideo,a,odd,0=0A=
buffer_finish f34b7800=0A=
vb2: Done processing on buffer 0, state: 2=0A=
buffer_next f34b6800 [prev=3Df2ab2e94/next=3Df34b6a94]=0A=
buffer_activate buf=3Df34b6800=0A=
saa7134_set_dmabits=0A=
dmabits: task=3D0x01 ctrl=3D0x01 irq=3D0x3 split=3Dyes=0A=
buffer_next #2 prev=3Df2ab2e94/next=3Df2ab2e94=0A=
saa7133[0]/irq: no (more) work=0A=
video_poll: f2354ee8=0A=
saa7134_dqbuf: f2354ee8 c2043e68=0A=
vb2: dqbuf: Returning done buffer=0A=
vb2: dqbuf of buffer 0, with state 3=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_DQBUF 359696:21:10.00987762 =
index=3D0, type=3Dvid-cap, flags=3D0x00000005, field=3D0, sequence=3D0, =
memory=3Dmmap=0A=
saa7133[0] video (Avermedia PCI: bytesused=3D829440, =
offset/userptr=3D0x00000000, length=3D829440=0A=
saa7133[0] video (Avermedia PCI: timecode=3D00:00:00 type=3D0, =
flags=3D0x00000000, frames=3D0, userbits=3D0x00000000=0A=
saa7134_qbuf: f2354ee8 c2043e68=0A=
buffer_prepare: sglist:fab50000 num_pages:203=0A=
buffer_queue=0A=
buffer_queue f34b7800=0A=
vb2: qbuf of buffer 0 succeeded=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_QBUF 359696:21:10.00987762 =
index=3D0, type=3Dvid-cap, flags=3D0x00000005, field=3D0, sequence=3D0, =
memory=3Dmmap=0A=
saa7133[0] video (Avermedia PCI: bytesused=3D829440, =
offset/userptr=3D0x00000000, length=3D829440=0A=
saa7133[0] video (Avermedia PCI: timecode=3D00:00:00 type=3D0, =
flags=3D0x00000000, frames=3D0, userbits=3D0x00000000=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
saa7133[0]/irq[0,21279046]: r=3D0x1 s=3D0x00 DONE_RA0 | =
RA0=3Dvideo,a,even,0=0A=
buffer_finish f34b6800=0A=
vb2: Done processing on buffer 1, state: 2=0A=
buffer_next f2ab2c00 [prev=3Df34b7a94/next=3Df2ab2e94]=0A=
buffer_activate buf=3Df2ab2c00=0A=
saa7134_set_dmabits=0A=
dmabits: task=3D0x01 ctrl=3D0x01 irq=3D0x3 split=3Dyes=0A=
buffer_next #2 prev=3Df34b7a94/next=3Df34b7a94=0A=
saa7133[0]/irq: no (more) work=0A=
video_poll: f2354ee8=0A=
saa7134_dqbuf: f2354ee8 c2043e68=0A=
vb2: dqbuf: Returning done buffer=0A=
vb2: dqbuf of buffer 1, with state 3=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_DQBUF 359696:21:11.00007731 =
index=3D1, type=3Dvid-cap, flags=3D0x00000005, field=3D0, sequence=3D0, =
memory=3Dmmap=0A=
saa7133[0] video (Avermedia PCI: bytesused=3D829440, =
offset/userptr=3D0x000cb000, length=3D829440=0A=
saa7133[0] video (Avermedia PCI: timecode=3D00:00:00 type=3D0, =
flags=3D0x00000000, frames=3D0, userbits=3D0x00000000=0A=
saa7134_qbuf: f2354ee8 c2043e68=0A=
buffer_prepare: sglist:fac1f000 num_pages:203=0A=
buffer_queue=0A=
buffer_queue f34b6800=0A=
vb2: qbuf of buffer 1 succeeded=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_QBUF 359696:21:11.00007731 =
index=3D1, type=3Dvid-cap, flags=3D0x00000005, field=3D0, sequence=3D0, =
memory=3Dmmap=0A=
saa7133[0] video (Avermedia PCI: bytesused=3D829440, =
offset/userptr=3D0x000cb000, length=3D829440=0A=
saa7133[0] video (Avermedia PCI: timecode=3D00:00:00 type=3D0, =
flags=3D0x00000000, frames=3D0, userbits=3D0x00000000=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
saa7133[0]/irq[0,21279051]: r=3D0x1 s=3D0x10 DONE_RA0 | =
RA0=3Dvideo,a,odd,0=0A=
buffer_finish f2ab2c00=0A=
vb2: Done processing on buffer 2, state: 2=0A=
buffer_next f34b7800 [prev=3Df34b6a94/next=3Df34b7a94]=0A=
buffer_activate buf=3Df34b7800=0A=
saa7134_set_dmabits=0A=
dmabits: task=3D0x01 ctrl=3D0x01 irq=3D0x3 split=3Dyes=0A=
buffer_next #2 prev=3Df34b6a94/next=3Df34b6a94=0A=
saa7133[0]/irq: no (more) work=0A=
video_poll: f2354ee8=0A=
saa7134_dqbuf: f2354ee8 c2043e68=0A=
vb2: dqbuf: Returning done buffer=0A=
vb2: dqbuf of buffer 2, with state 3=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_DQBUF 359696:21:11.00027763 =
index=3D2, type=3Dvid-cap, flags=3D0x00000005, field=3D0, sequence=3D0, =
memory=3Dmmap=0A=
saa7133[0] video (Avermedia PCI: bytesused=3D829440, =
offset/userptr=3D0x00196000, length=3D829440=0A=
saa7133[0] video (Avermedia PCI: timecode=3D00:00:00 type=3D0, =
flags=3D0x00000000, frames=3D0, userbits=3D0x00000000=0A=
saa7134_qbuf: f2354ee8 c2043e68=0A=
buffer_prepare: sglist:facee000 num_pages:203=0A=
buffer_queue=0A=
buffer_queue f2ab2c00=0A=
vb2: qbuf of buffer 2 succeeded=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_QBUF 359696:21:11.00027763 =
index=3D2, type=3Dvid-cap, flags=3D0x00000005, field=3D0, sequence=3D0, =
memory=3Dmmap=0A=
saa7133[0] video (Avermedia PCI: bytesused=3D829440, =
offset/userptr=3D0x00196000, length=3D829440=0A=
saa7133[0] video (Avermedia PCI: timecode=3D00:00:00 type=3D0, =
flags=3D0x00000000, frames=3D0, userbits=3D0x00000000=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
saa7133[0]/irq[0,21279056]: r=3D0x1 s=3D0x00 DONE_RA0 | =
RA0=3Dvideo,a,even,0=0A=
buffer_finish f34b7800=0A=
vb2: Done processing on buffer 0, state: 2=0A=
buffer_next f34b6800 [prev=3Df2ab2e94/next=3Df34b6a94]=0A=
buffer_activate buf=3Df34b6800=0A=
saa7134_set_dmabits=0A=
dmabits: task=3D0x01 ctrl=3D0x01 irq=3D0x3 split=3Dyes=0A=
buffer_next #2 prev=3Df2ab2e94/next=3Df2ab2e94=0A=
saa7133[0]/irq: no (more) work=0A=
video_poll: f2354ee8=0A=
saa7134_dqbuf: f2354ee8 c2043e68=0A=
vb2: dqbuf: Returning done buffer=0A=
vb2: dqbuf of buffer 0, with state 3=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_DQBUF 359696:21:11.00047732 =
index=3D0, type=3Dvid-cap, flags=3D0x00000005, field=3D0, sequence=3D0, =
memory=3Dmmap=0A=
saa7133[0] video (Avermedia PCI: bytesused=3D829440, =
offset/userptr=3D0x00000000, length=3D829440=0A=
saa7133[0] video (Avermedia PCI: timecode=3D00:00:00 type=3D0, =
flags=3D0x00000000, frames=3D0, userbits=3D0x00000000=0A=
saa7134_qbuf: f2354ee8 c2043e68=0A=
buffer_prepare: sglist:fab50000 num_pages:203=0A=
buffer_queue=0A=
buffer_queue f34b7800=0A=
vb2: qbuf of buffer 0 succeeded=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_QBUF 359696:21:11.00047732 =
index=3D0, type=3Dvid-cap, flags=3D0x00000005, field=3D0, sequence=3D0, =
memory=3Dmmap=0A=
saa7133[0] video (Avermedia PCI: bytesused=3D829440, =
offset/userptr=3D0x00000000, length=3D829440=0A=
saa7133[0] video (Avermedia PCI: timecode=3D00:00:00 type=3D0, =
flags=3D0x00000000, frames=3D0, userbits=3D0x00000000=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
saa7133[0]/irq[0,21279061]: r=3D0x1 s=3D0x10 DONE_RA0 | =
RA0=3Dvideo,a,odd,0=0A=
buffer_finish f34b6800=0A=
vb2: Done processing on buffer 1, state: 2=0A=
buffer_next f2ab2c00 [prev=3Df34b7a94/next=3Df2ab2e94]=0A=
buffer_activate buf=3Df2ab2c00=0A=
saa7134_set_dmabits=0A=
dmabits: task=3D0x01 ctrl=3D0x01 irq=3D0x3 split=3Dyes=0A=
buffer_next #2 prev=3Df34b7a94/next=3Df34b7a94=0A=
saa7133[0]/irq: no (more) work=0A=
video_poll: f2354ee8=0A=
saa7134_dqbuf: f2354ee8 c2043e68=0A=
vb2: dqbuf: Returning done buffer=0A=
vb2: dqbuf of buffer 1, with state 3=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_DQBUF 359696:21:11.00067762 =
index=3D1, type=3Dvid-cap, flags=3D0x00000005, field=3D0, sequence=3D0, =
memory=3Dmmap=0A=
saa7133[0] video (Avermedia PCI: bytesused=3D829440, =
offset/userptr=3D0x000cb000, length=3D829440=0A=
saa7133[0] video (Avermedia PCI: timecode=3D00:00:00 type=3D0, =
flags=3D0x00000000, frames=3D0, userbits=3D0x00000000=0A=
saa7134_qbuf: f2354ee8 c2043e68=0A=
buffer_prepare: sglist:fac1f000 num_pages:203=0A=
buffer_queue=0A=
buffer_queue f34b6800=0A=
vb2: qbuf of buffer 1 succeeded=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_QBUF 359696:21:11.00067762 =
index=3D1, type=3Dvid-cap, flags=3D0x00000005, field=3D0, sequence=3D0, =
memory=3Dmmap=0A=
saa7133[0] video (Avermedia PCI: bytesused=3D829440, =
offset/userptr=3D0x000cb000, length=3D829440=0A=
saa7133[0] video (Avermedia PCI: timecode=3D00:00:00 type=3D0, =
flags=3D0x00000000, frames=3D0, userbits=3D0x00000000=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
saa7133[0]/irq[0,21279066]: r=3D0x1 s=3D0x00 DONE_RA0 | =
RA0=3Dvideo,a,even,0=0A=
buffer_finish f2ab2c00=0A=
vb2: Done processing on buffer 2, state: 2=0A=
buffer_next f34b7800 [prev=3Df34b6a94/next=3Df34b7a94]=0A=
buffer_activate buf=3Df34b7800=0A=
saa7134_set_dmabits=0A=
dmabits: task=3D0x01 ctrl=3D0x01 irq=3D0x3 split=3Dyes=0A=
buffer_next #2 prev=3Df34b6a94/next=3Df34b6a94=0A=
saa7133[0]/irq: no (more) work=0A=
video_poll: f2354ee8=0A=
saa7134_dqbuf: f2354ee8 c2043e68=0A=
vb2: dqbuf: Returning done buffer=0A=
vb2: dqbuf of buffer 2, with state 3=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_DQBUF 359696:21:11.00087733 =
index=3D2, type=3Dvid-cap, flags=3D0x00000005, field=3D0, sequence=3D0, =
memory=3Dmmap=0A=
saa7133[0] video (Avermedia PCI: bytesused=3D829440, =
offset/userptr=3D0x00196000, length=3D829440=0A=
saa7133[0] video (Avermedia PCI: timecode=3D00:00:00 type=3D0, =
flags=3D0x00000000, frames=3D0, userbits=3D0x00000000=0A=
saa7134_qbuf: f2354ee8 c2043e68=0A=
buffer_prepare: sglist:facee000 num_pages:203=0A=
buffer_queue=0A=
buffer_queue f2ab2c00=0A=
vb2: qbuf of buffer 2 succeeded=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_QBUF 359696:21:11.00087733 =
index=3D2, type=3Dvid-cap, flags=3D0x00000005, field=3D0, sequence=3D0, =
memory=3Dmmap=0A=
saa7133[0] video (Avermedia PCI: bytesused=3D829440, =
offset/userptr=3D0x00196000, length=3D829440=0A=
saa7133[0] video (Avermedia PCI: timecode=3D00:00:00 type=3D0, =
flags=3D0x00000000, frames=3D0, userbits=3D0x00000000=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
saa7133[0]/irq[0,21279071]: r=3D0x1 s=3D0x10 DONE_RA0 | =
RA0=3Dvideo,a,odd,0=0A=
buffer_finish f34b7800=0A=
vb2: Done processing on buffer 0, state: 2=0A=
buffer_next f34b6800 [prev=3Df2ab2e94/next=3Df34b6a94]=0A=
buffer_activate buf=3Df34b6800=0A=
saa7134_set_dmabits=0A=
dmabits: task=3D0x01 ctrl=3D0x01 irq=3D0x3 split=3Dyes=0A=
buffer_next #2 prev=3Df2ab2e94/next=3Df2ab2e94=0A=
saa7133[0]/irq: no (more) work=0A=
video_poll: f2354ee8=0A=
saa7134_dqbuf: f2354ee8 c2043e68=0A=
vb2: dqbuf: Returning done buffer=0A=
vb2: dqbuf of buffer 0, with state 3=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_DQBUF 359696:21:11.00107765 =
index=3D0, type=3Dvid-cap, flags=3D0x00000005, field=3D0, sequence=3D0, =
memory=3Dmmap=0A=
saa7133[0] video (Avermedia PCI: bytesused=3D829440, =
offset/userptr=3D0x00000000, length=3D829440=0A=
saa7133[0] video (Avermedia PCI: timecode=3D00:00:00 type=3D0, =
flags=3D0x00000000, frames=3D0, userbits=3D0x00000000=0A=
saa7134_qbuf: f2354ee8 c2043e68=0A=
buffer_prepare: sglist:fab50000 num_pages:203=0A=
buffer_queue=0A=
buffer_queue f34b7800=0A=
vb2: qbuf of buffer 0 succeeded=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_QBUF 359696:21:11.00107765 =
index=3D0, type=3Dvid-cap, flags=3D0x00000005, field=3D0, sequence=3D0, =
memory=3Dmmap=0A=
saa7133[0] video (Avermedia PCI: bytesused=3D829440, =
offset/userptr=3D0x00000000, length=3D829440=0A=
saa7133[0] video (Avermedia PCI: timecode=3D00:00:00 type=3D0, =
flags=3D0x00000000, frames=3D0, userbits=3D0x00000000=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
saa7133[0]/irq[0,21279076]: r=3D0x1 s=3D0x00 DONE_RA0 | =
RA0=3Dvideo,a,even,0=0A=
buffer_finish f34b6800=0A=
vb2: Done processing on buffer 1, state: 2=0A=
buffer_next f2ab2c00 [prev=3Df34b7a94/next=3Df2ab2e94]=0A=
buffer_activate buf=3Df2ab2c00=0A=
saa7134_set_dmabits=0A=
dmabits: task=3D0x01 ctrl=3D0x01 irq=3D0x3 split=3Dyes=0A=
buffer_next #2 prev=3Df34b7a94/next=3Df34b7a94=0A=
saa7133[0]/irq: no (more) work=0A=
video_poll: f2354ee8=0A=
saa7134_dqbuf: f2354ee8 c2043e68=0A=
vb2: dqbuf: Returning done buffer=0A=
vb2: dqbuf of buffer 1, with state 3=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_DQBUF 359696:21:11.00127731 =
index=3D1, type=3Dvid-cap, flags=3D0x00000005, field=3D0, sequence=3D0, =
memory=3Dmmap=0A=
saa7133[0] video (Avermedia PCI: bytesused=3D829440, =
offset/userptr=3D0x000cb000, length=3D829440=0A=
saa7133[0] video (Avermedia PCI: timecode=3D00:00:00 type=3D0, =
flags=3D0x00000000, frames=3D0, userbits=3D0x00000000=0A=
saa7134_qbuf: f2354ee8 c2043e68=0A=
buffer_prepare: sglist:fac1f000 num_pages:203=0A=
buffer_queue=0A=
buffer_queue f34b6800=0A=
vb2: qbuf of buffer 1 succeeded=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_QBUF 359696:21:11.00127731 =
index=3D1, type=3Dvid-cap, flags=3D0x00000005, field=3D0, sequence=3D0, =
memory=3Dmmap=0A=
saa7133[0] video (Avermedia PCI: bytesused=3D829440, =
offset/userptr=3D0x000cb000, length=3D829440=0A=
saa7133[0] video (Avermedia PCI: timecode=3D00:00:00 type=3D0, =
flags=3D0x00000000, frames=3D0, userbits=3D0x00000000=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
saa7133[0]/irq[0,21279081]: r=3D0x1 s=3D0x10 DONE_RA0 | =
RA0=3Dvideo,a,odd,0=0A=
buffer_finish f2ab2c00=0A=
vb2: Done processing on buffer 2, state: 2=0A=
buffer_next f34b7800 [prev=3Df34b6a94/next=3Df34b7a94]=0A=
buffer_activate buf=3Df34b7800=0A=
saa7134_set_dmabits=0A=
dmabits: task=3D0x01 ctrl=3D0x01 irq=3D0x3 split=3Dyes=0A=
buffer_next #2 prev=3Df34b6a94/next=3Df34b6a94=0A=
saa7133[0]/irq: no (more) work=0A=
video_poll: f2354ee8=0A=
saa7134_dqbuf: f2354ee8 c2043e68=0A=
vb2: dqbuf: Returning done buffer=0A=
vb2: dqbuf of buffer 2, with state 3=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_DQBUF 359696:21:11.00147766 =
index=3D2, type=3Dvid-cap, flags=3D0x00000005, field=3D0, sequence=3D0, =
memory=3Dmmap=0A=
saa7133[0] video (Avermedia PCI: bytesused=3D829440, =
offset/userptr=3D0x00196000, length=3D829440=0A=
saa7133[0] video (Avermedia PCI: timecode=3D00:00:00 type=3D0, =
flags=3D0x00000000, frames=3D0, userbits=3D0x00000000=0A=
saa7134_qbuf: f2354ee8 c2043e68=0A=
buffer_prepare: sglist:facee000 num_pages:203=0A=
buffer_queue=0A=
buffer_queue f2ab2c00=0A=
vb2: qbuf of buffer 2 succeeded=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_QBUF 359696:21:11.00147766 =
index=3D2, type=3Dvid-cap, flags=3D0x00000005, field=3D0, sequence=3D0, =
memory=3Dmmap=0A=
saa7133[0] video (Avermedia PCI: bytesused=3D829440, =
offset/userptr=3D0x00196000, length=3D829440=0A=
saa7133[0] video (Avermedia PCI: timecode=3D00:00:00 type=3D0, =
flags=3D0x00000000, frames=3D0, userbits=3D0x00000000=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
saa7133[0]/irq[0,21279086]: r=3D0x1 s=3D0x00 DONE_RA0 | =
RA0=3Dvideo,a,even,0=0A=
buffer_finish f34b7800=0A=
vb2: Done processing on buffer 0, state: 2=0A=
buffer_next f34b6800 [prev=3Df2ab2e94/next=3Df34b6a94]=0A=
buffer_activate buf=3Df34b6800=0A=
saa7134_set_dmabits=0A=
dmabits: task=3D0x01 ctrl=3D0x01 irq=3D0x3 split=3Dyes=0A=
buffer_next #2 prev=3Df2ab2e94/next=3Df2ab2e94=0A=
saa7133[0]/irq: no (more) work=0A=
video_poll: f2354ee8=0A=
saa7134_dqbuf: f2354ee8 c2043e68=0A=
vb2: dqbuf: Returning done buffer=0A=
vb2: dqbuf of buffer 0, with state 3=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_DQBUF 359696:21:11.00167733 =
index=3D0, type=3Dvid-cap, flags=3D0x00000005, field=3D0, sequence=3D0, =
memory=3Dmmap=0A=
saa7133[0] video (Avermedia PCI: bytesused=3D829440, =
offset/userptr=3D0x00000000, length=3D829440=0A=
saa7133[0] video (Avermedia PCI: timecode=3D00:00:00 type=3D0, =
flags=3D0x00000000, frames=3D0, userbits=3D0x00000000=0A=
saa7134_qbuf: f2354ee8 c2043e68=0A=
buffer_prepare: sglist:fab50000 num_pages:203=0A=
buffer_queue=0A=
buffer_queue f34b7800=0A=
vb2: qbuf of buffer 0 succeeded=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_QBUF 359696:21:11.00167733 =
index=3D0, type=3Dvid-cap, flags=3D0x00000005, field=3D0, sequence=3D0, =
memory=3Dmmap=0A=
saa7133[0] video (Avermedia PCI: bytesused=3D829440, =
offset/userptr=3D0x00000000, length=3D829440=0A=
saa7133[0] video (Avermedia PCI: timecode=3D00:00:00 type=3D0, =
flags=3D0x00000000, frames=3D0, userbits=3D0x00000000=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
saa7133[0]/irq[0,21279091]: r=3D0x1 s=3D0x10 DONE_RA0 | =
RA0=3Dvideo,a,odd,0=0A=
buffer_finish f34b6800=0A=
vb2: Done processing on buffer 1, state: 2=0A=
buffer_next f2ab2c00 [prev=3Df34b7a94/next=3Df2ab2e94]=0A=
buffer_activate buf=3Df2ab2c00=0A=
saa7134_set_dmabits=0A=
dmabits: task=3D0x01 ctrl=3D0x01 irq=3D0x3 split=3Dyes=0A=
buffer_next #2 prev=3Df34b7a94/next=3Df34b7a94=0A=
saa7133[0]/irq: no (more) work=0A=
video_poll: f2354ee8=0A=
saa7134_dqbuf: f2354ee8 c2043e68=0A=
vb2: dqbuf: Returning done buffer=0A=
vb2: dqbuf of buffer 1, with state 3=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_DQBUF 359696:21:11.00187765 =
index=3D1, type=3Dvid-cap, flags=3D0x00000005, field=3D0, sequence=3D0, =
memory=3Dmmap=0A=
saa7133[0] video (Avermedia PCI: bytesused=3D829440, =
offset/userptr=3D0x000cb000, length=3D829440=0A=
saa7133[0] video (Avermedia PCI: timecode=3D00:00:00 type=3D0, =
flags=3D0x00000000, frames=3D0, userbits=3D0x00000000=0A=
saa7134_qbuf: f2354ee8 c2043e68=0A=
buffer_prepare: sglist:fac1f000 num_pages:203=0A=
buffer_queue=0A=
buffer_queue f34b6800=0A=
vb2: qbuf of buffer 1 succeeded=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_QBUF 359696:21:11.00187765 =
index=3D1, type=3Dvid-cap, flags=3D0x00000005, field=3D0, sequence=3D0, =
memory=3Dmmap=0A=
saa7133[0] video (Avermedia PCI: bytesused=3D829440, =
offset/userptr=3D0x000cb000, length=3D829440=0A=
saa7133[0] video (Avermedia PCI: timecode=3D00:00:00 type=3D0, =
flags=3D0x00000000, frames=3D0, userbits=3D0x00000000=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
video_poll: f2354ee8=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_STREAMOFF type=3Dvid-cap=0A=
saa7134_streamoff: f2354ee8=0A=
stop_streaming=0A=
vb2: Done processing on buffer 0, state: 2=0A=
vb2: Done processing on buffer 1, state: 2=0A=
timeout on f2ab2c00=0A=
buffer_finish f2ab2c00=0A=
vb2: Done processing on buffer 2, state: 2=0A=
buffer_next   (null)=0A=
saa7134_set_dmabits=0A=
dmabits: task=3D0x00 ctrl=3D0x00 irq=3D0x0 split=3Dyes=0A=
vb2: Streamoff successful=0A=
vb2_common_vm_close: f23ca7e0, refcount: 2, vma: b5ccc000-b5d97000=0A=
vb2_common_vm_close: f23cade0, refcount: 2, vma: b5c01000-b5ccc000=0A=
vb2_common_vm_close: f23ca820, refcount: 2, vma: b5b36000-b5c01000=0A=
saa7134_reqbufs: f2354ee8 c2043e68=0A=
vb2_dma_sg_put: Freeing buffer of 203 pages=0A=
vb2: Freed plane 0 of buffer 0=0A=
vb2_dma_sg_put: Freeing buffer of 203 pages=0A=
vb2: Freed plane 0 of buffer 1=0A=
vb2_dma_sg_put: Freeing buffer of 203 pages=0A=
vb2: Freed plane 0 of buffer 2=0A=
queue_setup=0A=
vb2: Allocated 0 buffers, 1 plane(s) each=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_REQBUFS count=3D0, =
type=3Dvid-cap, memory=3Dmmap=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_G_CTRL id=3D0x980900, value=3D128=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_QUERYCTRL id=3D0x980900, =
type=3D1, name=3DBrightness, min/max=3D0/255, step=3D1, default=3D128, =
flags=3D0x00000000=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_G_CTRL id=3D0x980901, value=3D68=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_QUERYCTRL id=3D0x980901, =
type=3D1, name=3DContrast, min/max=3D0/127, step=3D1, default=3D68, =
flags=3D0x00000000=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_G_CTRL id=3D0x980902, value=3D64=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_QUERYCTRL id=3D0x980902, =
type=3D1, name=3DSaturation, min/max=3D0/127, step=3D1, default=3D64, =
flags=3D0x00000000=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_G_CTRL id=3D0x980903, value=3D0=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_QUERYCTRL id=3D0x980903, =
type=3D1, name=3DHue, min/max=3D-128/127, step=3D1, default=3D0, =
flags=3D0x00000000=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_G_CTRL id=3D0x980905, value=3D0=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_QUERYCTRL id=3D0x980905, =
type=3D1, name=3DVolume, min/max=3D-15/15, step=3D1, default=3D0, =
flags=3D0x00000000=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_G_CTRL id=3D0x980909, value=3D1=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_QUERYCTRL id=3D0x980909, =
type=3D2, name=3DMute, min/max=3D0/1, step=3D0, default=3D0, =
flags=3D0x00000000=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_G_CTRL id=3D0x980914, value=3D0=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_QUERYCTRL id=3D0x980914, =
type=3D2, name=3DMirror, min/max=3D0/1, step=3D0, default=3D0, =
flags=3D0x00000000=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_G_CTRL id=3D0x8000000, value=3D0=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_QUERYCTRL id=3D0x8000000, =
type=3D2, name=3DInvert, min/max=3D0/1, step=3D0, default=3D0, =
flags=3D0x00000000=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_G_CTRL id=3D0x8000001, value=3D0=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_QUERYCTRL id=3D0x8000001, =
type=3D1, name=3Dy offset odd field, min/max=3D0/128, step=3D1, =
default=3D0, flags=3D0x00000000=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_G_CTRL id=3D0x8000002, value=3D0=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_QUERYCTRL id=3D0x8000002, =
type=3D1, name=3Dy offset even field, min/max=3D0/128, step=3D1, =
default=3D0, flags=3D0x00000000=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_G_CTRL id=3D0x8000003, value=3D1=0A=
saa7133[0] video (Avermedia PCI: VIDIOC_QUERYCTRL id=3D0x8000003, =
type=3D2, name=3Dautomute, min/max=3D0/1, step=3D0, default=3D1, =
flags=3D0x00000000=0A=

--Boundary_(ID_t6XsxDe4qlSkNGrd2Wctmw)--
