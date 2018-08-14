Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:54712 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728272AbeHNMZE (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 14 Aug 2018 08:25:04 -0400
Date: Tue, 14 Aug 2018 06:38:32 -0300
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To: "Jesse Huang (=?UTF-8?B?6buD5bu66IiI?=)" <jesse.huang@mstarsemi.com>
Cc: "mchehab@kernel.org" <mchehab@kernel.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "Yishin Tung (=?UTF-8?B?56ul5oCh5paw?=)" <yishin.tung@mstarsemi.com>,
        "Zink Hsin (=?UTF-8?B?6L6b6bS75p2w?=)" <zink.hsin@mediatek.com>,
        "MF Hsieh (=?UTF-8?B?6Kyd5piO55Sr?=)" <mf.hsieh@mstarsemi.com>,
        "Junyou Lin (=?UTF-8?B?5p6X5L+K6KOV?=)" <junyou.lin@mstarsemi.com>
Subject: Re: Using big platform driver as foundation to implement TV driver
 framework in Linux
Message-ID: <20180814063832.3bb75cd4@coco.lan>
In-Reply-To: <a60afd4a1035444aa3bbbb1f07af52b0@MSTARMBS01.mstarsemi.com.tw>
References: <a60afd4a1035444aa3bbbb1f07af52b0@MSTARMBS01.mstarsemi.com.tw>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jesse,

Em Mon, 13 Aug 2018 01:32:45 +0000
Jesse Huang (=E9=BB=83=E5=BB=BA=E8=88=88) <jesse.huang@mstarsemi.com> escre=
veu:

> Hi Mchehab,
> Hi Linux-Media,
>=20
> MTK/MStar try to move TV SOC proprietary driver framework to Linux TV dri=
ver.
>=20
> But, we also need to share/re-use driver code to non-OS which is a size l=
imitation low cost system.
>=20
> Normally, each Linux driver need to control registers directly by it self=
. For example:
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D(sample code begin)
> linux-3.18-exynos7270-sandbox.opensw0312.rebase-3d91408\drivers\media\pci=
\cx25821\cx25821-video.c
> static int vidioc_streamon(struct file *file, void *priv, enum v4l2_buf_t=
ype i)
> {
>     struct cx25821_channel *chan =3D video_drvdata(file);
>=20
>     if (i !=3D V4L2_BUF_TYPE_VIDEO_CAPTURE)
>         return -EINVAL;
>=20
>     if (chan->streaming_fh && chan->streaming_fh !=3D priv)
>         return -EBUSY;
>     chan->streaming_fh =3D priv;
>=20
>     return videobuf_streamon(&chan->vidq);
> }
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D(sample code end)
>=20
>=20
>=20
> But, in our concept, we hope to provide an entire proprietary a driver as=
 a =E2=80=9CMTK TV platform driver=E2=80=9D. Base on this driver to impleme=
nt Linux standard TV driver.
> If will look like this:
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D(sample code begin)
> static int vidioc_streamon(struct file *file, void *priv, enum v4l2_buf_t=
ype i)
> {
>     return mtk_tv_platform->video->streamon();
> }
>=20
> The mtk_tv_platform will be register when setup_arch()
> void __init setup_arch(char **cmdline_p)
> {
> return platform_device_register(&mtk_tv_platform);
> }
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D(sample code end)
>=20
> Would this kid of implement method can be accept for Linux upstream/submi=
t driver rule? What kind of framework design guide line/rule we should foll=
ow? Would it possible to have some reference for us.
>=20
> If this method is possible, we can share a lot of human resource to both =
maintain for Linux and non-Linux project.

Not sure if I understand what you want to do.

The Linux Kernel is under a GPL version 2 license, meaning that
anyone wanting to do Kernel development should license their work
under those terms.

In other words, If you want to submit a driver to the Linux Kernel, the
needed software to control the hardware should all be upstreamed using
GPL version 2, including all register settings.

In the specific case of image enhancement algorithms, like 3A, we're
currently working on a solution that would allow a third party software
(ideally open source, but it could be a binary code) to run on
userspace, receiving metadata from the hardware via a documented
userspace, and using the standard V4L2 API to adjust the hardware,
after doing some (usually proprietary) processing.

So, if you're willing to contribute under this terms, we can help you.

It could still be possible to share code with other OS, depending on
how you write the driver, but we don't accept any other OS-dependent
code (like #ifdefs inside Linux). What other vendors usually do is
to either encapsulate the other-os dependent part on a different
source file (not submitted to Linux) or to internally have some
sort of process to strip #ifdefs when submitting drivers to Linux.

If otherwise all you want is to have a wrapper driver to run some
proprietary driver, then shipping such solution would likely be a
copyright violation and we can't help you.

Thanks,
Mauro
