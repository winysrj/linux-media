Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp208.alice.it ([82.57.200.104]:52408 "EHLO smtp208.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751460Ab1JRIfh (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 18 Oct 2011 04:35:37 -0400
Date: Tue, 18 Oct 2011 10:35:25 +0200
From: Antonio Ospite <ospite@studenti.unina.it>
To: linux-media@vger.kernel.org, David Rientjes <rientjes@google.com>
Cc: Antonio Ospite <ospite@studenti.unina.it>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [PATCH] [media] videodev: fix a NULL pointer dereference in
 v4l2_device_release()
Message-Id: <20111018103525.10399d9d2f51a53fd0d6eb20@studenti.unina.it>
In-Reply-To: <1318456766-4165-1-git-send-email-ospite@studenti.unina.it>
References: <1318456766-4165-1-git-send-email-ospite@studenti.unina.it>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__18_Oct_2011_10_35_25_+0200_QuzDhY+/xt.cwfx="
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--Signature=_Tue__18_Oct_2011_10_35_25_+0200_QuzDhY+/xt.cwfx=
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, 12 Oct 2011 23:59:26 +0200
Antonio Ospite <ospite@studenti.unina.it> wrote:

> The change in 8280b66 does not cover the case when v4l2_dev is already
> NULL, fix that.
>=20
> With a Kinect sensor, seen as an USB camera using GSPCA in this context,
> a NULL pointer dereference BUG can be triggered by just unplugging the
> device after the camera driver has been loaded.
>=20
> Signed-off-by: Antonio Ospite <ospite@studenti.unina.it>
> ---
> Hi,
>=20
> can anyone reproduce this?
>

Ping.

David, does the change below fix it for you, I sent the patch
last week.

Regards,
   Antonio

> This is the complete trace, I left it out of the commit message, but feel=
 free=20
> to include it if you think it is worth it.
>=20
> BUG: unable to handle kernel NULL pointer dereference at 0000000000000090
> IP: [<ffffffffa10cc604>] v4l2_device_release+0xb8/0xe8 [videodev]
> PGD 0=20
> Oops: 0000 [#1] SMP=20
> CPU 0=20
> Modules linked in: snd_usb_audio snd_usbmidi_lib gspca_kinect gspca_main=
=20
> videodev media v4l2_compat_ioctl32 hidp snd_hrtimer ebtable_nat ebtables=
=20
> powernow_k8 mperf cpufreq_powersave cpufreq_conservative cpufreq_stats=20
> cpufreq_userspace ipt_MASQUERADE xt_CHECKSUM bridge stp ppdev lp bnep rfc=
omm=20
> tun sit tunnel4 ip6table_raw ip6table_mangle ip6t_REJECT ip6t_LOG=20
> nf_conntrack_ipv6 nf_defrag_ipv6 ip6t_rt ip6table_filter ip6_tables decne=
t=20
> binfmt_misc uinput fuse xt_tcpudp ipt_REJECT ipt_ULOG xt_limit xt_state=20
> xt_multiport iptable_filter iptable_nat nf_nat nf_conntrack_ipv4 nf_connt=
rack=20
> nf_defrag_ipv4 iptable_mangle iptable_raw ip_tables x_tables nfsd nfs loc=
kd=20
> fscache auth_rpcgss nfs_acl sunrpc it87 hwmon_vid loop kvm_amd kvm=20
> snd_hda_codec_hdmi snd_hda_codec_via nvidia(P) snd_hda_intel snd_hda_code=
c=20
> snd_hwdep snd_pcm_oss snd_mixer_oss snd_pcm snd_seq_midi snd_rawmidi cryp=
td=20
> aes_x86_64 snd_seq_midi_event aes_generic ecb snd_seq btusb bluetooth evd=
ev=20
> snd_timer snd_seq_device edac_core parport_pc pcspkr parport rfkill snd=20
> edac_mce_amd k8temp crc16 soundcore mxm_wmi snd_page_alloc asus_atk0110 s=
hpchp=20
> video pci_hotplug i2c_nforce2 wmi i2c_core processor thermal_sys button e=
xt3=20
> jbd mbcache dm_mod sg sd_mod sr_mod crc_t10dif cdrom ata_generic usb_stor=
age=20
> usbhid hid uas ahci libahci pata_amd libata scsi_mod forcedeth floppy ohc=
i_hcd=20
> ehci_hcd usbcore [last unloaded: scsi_wait_scan]
>=20
> Pid: 125, comm: khubd Tainted: P            3.1.0-rc9-ao2 #3 System manuf=
acturer System Product Name/M3N78-VM
> RIP: 0010:[<ffffffffa10cc604>]  [<ffffffffa10cc604>] v4l2_device_release+=
0xb8/0xe8 [videodev]
> RSP: 0018:ffff88011639fc10  EFLAGS: 00010246
> RAX: 0000000000000000 RBX: ffff8800ca61a088 RCX: 0000000000000001
> RDX: 0000000000000001 RSI: 0000000000000000 RDI: ffffffffa10db000
> RBP: 0000000000000000 R08: ffffffff8119b320 R09: ffffffff8119b320
> R10: 0000000000000001 R11: 0000000000000001 R12: ffff8800ca61a000
> R13: ffffffff8164ffb0 R14: 0000000000000000 R15: 000000000000001f
> FS:  00007f61275f37a0(0000) GS:ffff88011fc00000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> CR2: 0000000000000090 CR3: 00000001150de000 CR4: 00000000000006f0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> Process khubd (pid: 125, threadinfo ffff88011639e000, task ffff88011639d5=
90)
> Stack:
>  ffff8800ca5d8380 ffff8800ca61a098 ffff8800ca66c200 ffffffff81232e94
>  ffff8800ca61a0d0 ffffffff8119a7fa ffffffff8119b320 ffff8800ca61a0d0
>  ffffffff8119a7ab ffff8800ca56dc00 ffffffffa10e1068 ffffffff8119b93a
> Call Trace:
>  [<ffffffff81232e94>] ? device_release+0x41/0x72
>  [<ffffffff8119a7fa>] ? kobject_release+0x4f/0x6c
>  [<ffffffff8119b320>] ? add_uevent_var+0xdc/0xdc
>  [<ffffffff8119a7ab>] ? kobject_del+0x2d/0x2d
>  [<ffffffff8119b93a>] ? kref_put+0x3e/0x47
>  [<ffffffffa0039f15>] ? usb_unbind_interface+0x4d/0x111 [usbcore]
>  [<ffffffff81235b9b>] ? __device_release_driver+0x7d/0xc9
>  [<ffffffff81235c02>] ? device_release_driver+0x1b/0x27
>  [<ffffffff81235804>] ? bus_remove_device+0x7c/0x8b
>  [<ffffffff812337e6>] ? device_del+0x129/0x177
>  [<ffffffffa00384f7>] ? usb_disable_device+0x6a/0x159 [usbcore]
>  [<ffffffffa003250c>] ? usb_disconnect+0x8c/0x108 [usbcore]
>  [<ffffffffa00324ed>] ? usb_disconnect+0x6d/0x108 [usbcore]
>  [<ffffffffa0033bc5>] ? hub_thread+0x58e/0xec6 [usbcore]
>  [<ffffffff81036e08>] ? set_next_entity+0x32/0x52
>  [<ffffffff8105ec53>] ? add_wait_queue+0x3c/0x3c
>  [<ffffffffa0033637>] ? usb_remote_wakeup+0x2f/0x2f [usbcore]
>  [<ffffffff8105e60d>] ? kthread+0x76/0x7e
>  [<ffffffff81332f34>] ? kernel_thread_helper+0x4/0x10
>  [<ffffffff8105e597>] ? kthread_worker_fn+0x139/0x139
>  [<ffffffff81332f30>] ? gs_change+0x13/0x13
> Code: 0d a1 e8 7a ec 25 e0 48 8b 83 78 02 00 00 48 85 c0 74 18 48 83 78 0=
8 00 74 11 83 bb b0 02 00 00 03 74 08 4c 89 e7 e8 03 5a ff ff=20
>  83 bd 90 00 00 00 00 b8 00 00 00 00 4c 89 e7 48 0f 44 e8 ff=20
> RIP  [<ffffffffa10cc604>] v4l2_device_release+0xb8/0xe8 [videodev]
>  RSP <ffff88011639fc10>
> CR2: 0000000000000090
> ---[ end trace 99f7feddc91f30d6 ]---
>=20
> Thanks,
>    Antonio Ospite
>    http://ao2.it
>=20
>  drivers/media/video/v4l2-dev.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>=20
> diff --git a/drivers/media/video/v4l2-dev.c b/drivers/media/video/v4l2-de=
v.c
> index d721565..a5c9ed1 100644
> --- a/drivers/media/video/v4l2-dev.c
> +++ b/drivers/media/video/v4l2-dev.c
> @@ -181,7 +181,7 @@ static void v4l2_device_release(struct device *cd)
>  	 * TODO: In the long run all drivers that use v4l2_device should use the
>  	 * v4l2_device release callback. This check will then be unnecessary.
>  	 */
> -	if (v4l2_dev->release =3D=3D NULL)
> +	if (v4l2_dev && v4l2_dev->release =3D=3D NULL)
>  		v4l2_dev =3D NULL;
> =20
>  	/* Release video_device and perform other
> --=20
> 1.7.7
>=20
>=20


--=20
Antonio Ospite
http://ao2.it

PGP public key ID: 0x4553B001

A: Because it messes up the order in which people normally read text.
   See http://en.wikipedia.org/wiki/Posting_style
Q: Why is top-posting such a bad thing?

--Signature=_Tue__18_Oct_2011_10_35_25_+0200_QuzDhY+/xt.cwfx=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEUEARECAAYFAk6dOk0ACgkQ5xr2akVTsAG1nQCdH9gJZpqjchO/C6ZK24FVoC8A
B0AAl2FueHjISTT7gWZzzyYh+hPiR+M=
=Rqlx
-----END PGP SIGNATURE-----

--Signature=_Tue__18_Oct_2011_10_35_25_+0200_QuzDhY+/xt.cwfx=--
