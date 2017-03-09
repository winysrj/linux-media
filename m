Return-path: <linux-media-owner@vger.kernel.org>
Received: from iodev.co.uk ([82.211.30.53]:45322 "EHLO iodev.co.uk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750803AbdCIUwb (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 9 Mar 2017 15:52:31 -0500
Date: Thu, 9 Mar 2017 17:41:42 -0300
From: Ismael Luceno <ismael@iodev.co.uk>
To: Anton Sviridenko <anton@corp.bluecherry.net>
Cc: Bluecherry Maintainers <maintainers@bluecherrydvr.com>,
        Andrey Utkin <andrey.utkin@corp.bluecherry.net>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] [media] solo6x10: release vb2 buffers in
 solo_stop_streaming()
Message-ID: <20170309204140.GA2940@pirotess.bf.iodev.co.uk>
References: <20170309134615.GA17229@magpie-gentoo>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="C7zPtVaVf+AK4Oqc"
Content-Disposition: inline
In-Reply-To: <20170309134615.GA17229@magpie-gentoo>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--C7zPtVaVf+AK4Oqc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


On 09/Mar/2017 17:46, Anton Sviridenko wrote:
> v2: removed var dbg_buf_cnt, left-over from debugging
>=20
> Fixes warning that appears in dmesg after closing V4L2 userspace
> application that plays video from the display device
> (first device from V4L2 device nodes provided by solo, usually /dev/video0
> when no other V4L2 devices are present). Encoder device nodes are not
> affected. Can be reproduced by starting and closing
>=20
> ffplay -f video4linux2  /dev/video0
>=20
> [ 8130.281251] ------------[ cut here ]------------
> [ 8130.281256] WARNING: CPU: 1 PID: 20414 at drivers/media/v4l2-core/vide=
obuf2-core.c:1651 __vb2_queue_cancel+0x14b/0x230
> [ 8130.281257] Modules linked in: ipt_MASQUERADE nf_nat_masquerade_ipv4 i=
ptable_nat solo6x10 x86_pkg_temp_thermal vboxpci(O) vboxnetadp(O) vboxnetfl=
t(O) vboxdrv(O)
> [ 8130.281264] CPU: 1 PID: 20414 Comm: ffplay Tainted: G           O    4=
=2E10.0-gentoo #1
> [ 8130.281264] Hardware name: ASUS All Series/B85M-E, BIOS 2301 03/30/2015
> [ 8130.281265] Call Trace:
> [ 8130.281267]  dump_stack+0x4f/0x72
> [ 8130.281270]  __warn+0xc7/0xf0
> [ 8130.281271]  warn_slowpath_null+0x18/0x20
> [ 8130.281272]  __vb2_queue_cancel+0x14b/0x230
> [ 8130.281273]  vb2_core_streamoff+0x23/0x90
> [ 8130.281275]  vb2_streamoff+0x24/0x50
> [ 8130.281276]  vb2_ioctl_streamoff+0x3d/0x50
> [ 8130.281278]  v4l_streamoff+0x15/0x20
> [ 8130.281279]  __video_do_ioctl+0x25e/0x2f0
> [ 8130.281280]  video_usercopy+0x279/0x520
> [ 8130.281282]  ? v4l_enum_fmt+0x1330/0x1330
> [ 8130.281285]  ? unmap_region+0xdf/0x110
> [ 8130.281285]  video_ioctl2+0x10/0x20
> [ 8130.281286]  v4l2_ioctl+0xce/0xe0
> [ 8130.281289]  do_vfs_ioctl+0x8b/0x5b0
> [ 8130.281290]  ? __fget+0x72/0xa0
> [ 8130.281291]  SyS_ioctl+0x74/0x80
> [ 8130.281294]  entry_SYSCALL_64_fastpath+0x13/0x94
> [ 8130.281295] RIP: 0033:0x7ff86fee6b27
> [ 8130.281296] RSP: 002b:00007ffe467f6a08 EFLAGS: 00000246 ORIG_RAX: 0000=
000000000010
> [ 8130.281297] RAX: ffffffffffffffda RBX: 00000000d1a4d788 RCX: 00007ff86=
fee6b27
> [ 8130.281297] RDX: 00007ffe467f6a14 RSI: 0000000040045613 RDI: 000000000=
0000006
> [ 8130.281298] RBP: 000000000373f8d0 R08: 00000000ffffffff R09: 00007ff86=
0001140
> [ 8130.281298] R10: 0000000000000243 R11: 0000000000000246 R12: 000000000=
0000000
> [ 8130.281299] R13: 00000000000000a0 R14: 00007ffe467f6530 R15: 000000000=
1f32228
> [ 8130.281300] ---[ end trace 00695dc96be646e7 ]---
>=20
> Signed-off-by: Anton Sviridenko <anton@corp.bluecherry.net>
> ---
>  drivers/media/pci/solo6x10/solo6x10-v4l2.c | 11 +++++++++++
>  1 file changed, 11 insertions(+)
>=20
> diff --git a/drivers/media/pci/solo6x10/solo6x10-v4l2.c b/drivers/media/p=
ci/solo6x10/solo6x10-v4l2.c
> index 896bec6..3266fc2 100644
> --- a/drivers/media/pci/solo6x10/solo6x10-v4l2.c
> +++ b/drivers/media/pci/solo6x10/solo6x10-v4l2.c
> @@ -341,6 +341,17 @@ static void solo_stop_streaming(struct vb2_queue *q)
>  	struct solo_dev *solo_dev =3D vb2_get_drv_priv(q);
> =20
>  	solo_stop_thread(solo_dev);
> +
> +	spin_lock(&solo_dev->slock);
> +	while (!list_empty(&solo_dev->vidq_active)) {
> +		struct solo_vb2_buf *buf =3D list_entry(
> +				solo_dev->vidq_active.next,
> +				struct solo_vb2_buf, list);
> +
> +		list_del(&buf->list);
> +		vb2_buffer_done(&buf->vb.vb2_buf, VB2_BUF_STATE_ERROR);
> +	}
> +	spin_unlock(&solo_dev->slock);
>  	INIT_LIST_HEAD(&solo_dev->vidq_active);
>  }
> =20

Signed-off-by: Ismael Luceno <ismael@iodev.co.uk>

Please move the patch changelog out of the commit message!

--C7zPtVaVf+AK4Oqc
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEE0FDE2gRAXOJ5hYQTNQwSKGMZ2JUFAljBvgQACgkQNQwSKGMZ
2JVAdA//b9HZqwRWuh/F6G0ABCj4FhkcFzUPznYWtfQG6+UQVAnMA89cxMUqn8bB
QRVhxUy30yWd0e3Qva90iYH8VC5t/awPoscyx9KdM+MFkzjlNOZf7nJdkIPXi06H
sxXCYGMYDHnLLobBbZ8tVC3FJcwZHcI7Ss9+uoUz78254zMYzxIqcWAzIuf9TX+9
QvV9NUxEIAqqKbg/4Z0qKvm7pVkD8gFikgrKZEGJhWGX0FtrjW9T1PFnSV2mbyTV
h02M2ivczsdn96EZAYL1VhZoP1RKtD0GvBszzjHs38v4tLfjMALUSvSf93CRTPK1
OZmkYLGrvGTMKsMoZTHM58gJOH+/KsEO58AM4LVXlZUgNKq2TaQFXur3TsSvSMbp
y5HsHa2sIVZDJGklORlvbL07VLS7p00X7qN5VlUVzOXU1NNK9/i8U77RkNzggOYd
07lpco+f/NgZVY0n8b/6fOsgZf8mMJTSCIVkGyYbI000zIXDiSg5ugo6cLAWZkSx
HMD1Y5mF8lKilh8+A/46bQlUdgvgtJIHlg++ljUtjxfossWGv/zM2OsoSOXnF7xJ
/TvCYgKd4bdfOpsHG6czVrqPhsxIitbunOnA16T3IOGe4loZU9kAWgxQT+t5OIoG
8+ADmNUd3K6ohxcqYqMGdsqdAS4lCPWaNQeeUJHfy5pylStp00s=
=tBEn
-----END PGP SIGNATURE-----

--C7zPtVaVf+AK4Oqc--
