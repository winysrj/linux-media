Return-path: <linux-media-owner@vger.kernel.org>
Received: from butterbrot.org ([176.9.106.16]:54031 "EHLO butterbrot.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750898AbbGEJk7 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 5 Jul 2015 05:40:59 -0400
Message-ID: <55982493.6030004@butterbrot.org>
Date: Sat, 04 Jul 2015 20:23:15 +0200
From: Florian Echtler <floe@butterbrot.org>
MIME-Version: 1.0
To: kbuild test robot <fengguang.wu@intel.com>
CC: kbuild-all@01.org, Mauro Carvalho Chehab <m.chehab@samsung.com>,
	linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: sur40.c:undefined reference to `video_unregister_device'
References: <201507050102.8Tn01fIF%fengguang.wu@intel.com>
In-Reply-To: <201507050102.8Tn01fIF%fengguang.wu@intel.com>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="73DW8wRLnfedk7JKX12u5GTTEC8hjKOxb"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--73DW8wRLnfedk7JKX12u5GTTEC8hjKOxb
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

I do still plan to fix this, but I have no idea right now how this can
actually happen: if TOUCHSCREEN_SUR40 is enabled, then this will enable
VIDEOBUF2_DMA_SG, and that will select most of the other V4L2 modules in
turn - or am I missing something here?

Best, Florian1

On 04.07.2015 19:56, kbuild test robot wrote:
> Hi Florian,
>=20
> FYI, the error/warning still remains. You may either fix it or ask me t=
o silently ignore in future.
>=20
> tree:   git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.gi=
t master
> head:   14a6f1989dae9445d4532941bdd6bbad84f4c8da
> commit: e831cd251fb91d6c25352d322743db0d17ea11dd [media] add raw video =
stream support for Samsung SUR40
> date:   3 months ago
> config: i386-randconfig-x006-201527 (attached as .config)
> reproduce:
>   git checkout e831cd251fb91d6c25352d322743db0d17ea11dd
>   # save the attached .config to linux build tree
>   make ARCH=3Di386=20
>=20
> All error/warnings (new ones prefixed by >>):
>=20
>    drivers/built-in.o: In function `sur40_disconnect':
>>> sur40.c:(.text+0x2ba09b): undefined reference to `video_unregister_de=
vice'
>>> sur40.c:(.text+0x2ba0a3): undefined reference to `v4l2_device_unregis=
ter'
>>> sur40.c:(.text+0x2ba0ae): undefined reference to `vb2_dma_sg_cleanup_=
ctx'
>    drivers/built-in.o: In function `sur40_stop_streaming':
>>> sur40.c:(.text+0x2ba4bc): undefined reference to `vb2_buffer_done'
>    drivers/built-in.o: In function `sur40_probe':
>>> sur40.c:(.text+0x2ba84a): undefined reference to `v4l2_device_registe=
r'
>>> sur40.c:(.text+0x2ba8bd): undefined reference to `vb2_dma_sg_memops'
>>> sur40.c:(.text+0x2ba8e9): undefined reference to `vb2_queue_init'
>>> sur40.c:(.text+0x2ba912): undefined reference to `vb2_dma_sg_init_ctx=
'
>>> sur40.c:(.text+0x2ba9a4): undefined reference to `video_device_releas=
e_empty'
>>> sur40.c:(.text+0x2ba9da): undefined reference to `__video_register_de=
vice'
>    sur40.c:(.text+0x2baa0d): undefined reference to `video_unregister_d=
evice'
>    sur40.c:(.text+0x2baa71): undefined reference to `v4l2_device_unregi=
ster'
>    drivers/built-in.o: In function `sur40_process_video':
>>> sur40.c:(.text+0x2bac03): undefined reference to `vb2_plane_cookie'
>>> sur40.c:(.text+0x2bac94): undefined reference to `v4l2_get_timestamp'=

>    sur40.c:(.text+0x2baccd): undefined reference to `vb2_buffer_done'
>    drivers/built-in.o: In function `sur40_vidioc_querycap':
>>> sur40.c:(.text+0x2bacf7): undefined reference to `video_devdata'
>>> drivers/built-in.o:(.rodata+0x6d140): undefined reference to `vb2_ioc=
tl_reqbufs'
>>> drivers/built-in.o:(.rodata+0x6d144): undefined reference to `vb2_ioc=
tl_querybuf'
>>> drivers/built-in.o:(.rodata+0x6d148): undefined reference to `vb2_ioc=
tl_qbuf'
>>> drivers/built-in.o:(.rodata+0x6d14c): undefined reference to `vb2_ioc=
tl_expbuf'
>>> drivers/built-in.o:(.rodata+0x6d150): undefined reference to `vb2_ioc=
tl_dqbuf'
>>> drivers/built-in.o:(.rodata+0x6d154): undefined reference to `vb2_ioc=
tl_create_bufs'
>>> drivers/built-in.o:(.rodata+0x6d168): undefined reference to `vb2_ioc=
tl_streamon'
>=20
> ---
> 0-DAY kernel test infrastructure                Open Source Technology =
Center
> https://lists.01.org/pipermail/kbuild-all                   Intel Corpo=
ration
>=20


--=20
SENT FROM MY DEC VT50 TERMINAL


--73DW8wRLnfedk7JKX12u5GTTEC8hjKOxb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlWYJJMACgkQ7CzyshGvatg6OgCfVinCRSmiEWuvWjQf5uq8T5Qg
0OoAoOgmfYjzaX4O7cNJ7Q6itVT9NApb
=j/Ze
-----END PGP SIGNATURE-----

--73DW8wRLnfedk7JKX12u5GTTEC8hjKOxb--
