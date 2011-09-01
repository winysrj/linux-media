Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.171]:63580 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751170Ab1IAFYu (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 1 Sep 2011 01:24:50 -0400
Date: Thu, 1 Sep 2011 07:24:43 +0200
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH 15/21] [staging] tm6000: Execute lightweight reset on
 close.
Message-ID: <20110901052443.GE18473@avionic-0098.mockup.avionic-design.de>
References: <1312442059-23935-1-git-send-email-thierry.reding@avionic-design.de>
 <1312442059-23935-16-git-send-email-thierry.reding@avionic-design.de>
 <4E5E9F5C.8030107@redhat.com>
 <4E5EAA41.4060502@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="zaRBsRFn0XYhEU69"
Content-Disposition: inline
In-Reply-To: <4E5EAA41.4060502@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--zaRBsRFn0XYhEU69
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

* Mauro Carvalho Chehab wrote:
> Em 31-08-2011 17:53, Mauro Carvalho Chehab escreveu:
> > Em 04-08-2011 04:14, Thierry Reding escreveu:
> >> When the last user closes the device, perform a lightweight reset of t=
he
> >> device to bring it into a well-known state.
> >>
> >> Note that this is not always enough with the TM6010, which sometimes
> >> needs a hard reset to get into a working state again.
> >> ---
> >>  drivers/staging/tm6000/tm6000-core.c  |   43 ++++++++++++++++++++++++=
+++++++++
> >>  drivers/staging/tm6000/tm6000-video.c |    8 +++++-
> >>  drivers/staging/tm6000/tm6000.h       |    1 +
> >>  3 files changed, 51 insertions(+), 1 deletions(-)
> >>
> >> diff --git a/drivers/staging/tm6000/tm6000-core.c b/drivers/staging/tm=
6000/tm6000-core.c
> >> index 317ab7e..58c1399 100644
> >> --- a/drivers/staging/tm6000/tm6000-core.c
> >> +++ b/drivers/staging/tm6000/tm6000-core.c
> >> @@ -597,6 +597,49 @@ int tm6000_init(struct tm6000_core *dev)
> >>  	return rc;
> >>  }
> >> =20
> >> +int tm6000_reset(struct tm6000_core *dev)
> >> +{
> >> +	int pipe;
> >> +	int err;
> >> +
> >> +	msleep(500);
> >> +
> >> +	err =3D usb_set_interface(dev->udev, dev->isoc_in.bInterfaceNumber, =
0);
> >> +	if (err < 0) {
> >> +		tm6000_err("failed to select interface %d, alt. setting 0\n",
> >> +				dev->isoc_in.bInterfaceNumber);
> >> +		return err;
> >> +	}
> >> +
> >> +	err =3D usb_reset_configuration(dev->udev);
> >> +	if (err < 0) {
> >> +		tm6000_err("failed to reset configuration\n");
> >> +		return err;
> >> +	}
> >> +
> >> +	msleep(5);
> >> +
> >> +	err =3D usb_set_interface(dev->udev, dev->isoc_in.bInterfaceNumber, =
2);
> >> +	if (err < 0) {
> >> +		tm6000_err("failed to select interface %d, alt. setting 2\n",
> >> +				dev->isoc_in.bInterfaceNumber);
> >> +		return err;
> >> +	}
> >> +
> >> +	msleep(5);
> >> +
> >> +	pipe =3D usb_rcvintpipe(dev->udev,
> >> +			dev->int_in.endp->desc.bEndpointAddress & USB_ENDPOINT_NUMBER_MASK=
);
> >> +
> >> +	err =3D usb_clear_halt(dev->udev, pipe);
> >> +	if (err < 0) {
> >> +		tm6000_err("usb_clear_halt failed: %d\n", err);
> >> +		return err;
> >> +	}
> >> +
> >> +	return 0;
> >> +}
> >> +
> >>  int tm6000_set_audio_bitrate(struct tm6000_core *dev, int bitrate)
> >>  {
> >>  	int val =3D 0;
> >> diff --git a/drivers/staging/tm6000/tm6000-video.c b/drivers/staging/t=
m6000/tm6000-video.c
> >> index 492ec73..70fc19e 100644
> >> --- a/drivers/staging/tm6000/tm6000-video.c
> >> +++ b/drivers/staging/tm6000/tm6000-video.c
> >> @@ -1503,7 +1503,6 @@ static int tm6000_open(struct file *file)
> >>  	tm6000_get_std_res(dev);
> >> =20
> >>  	file->private_data =3D fh;
> >> -	fh->vdev =3D vdev;
> >>  	fh->dev =3D dev;
> >>  	fh->radio =3D radio;
> >>  	fh->type =3D type;
> >> @@ -1606,9 +1605,16 @@ static int tm6000_release(struct file *file)
> >>  	dev->users--;
> >> =20
> >>  	res_free(dev, fh);
> >> +
> >>  	if (!dev->users) {
> >> +		int err;
> >> +
> >>  		tm6000_uninit_isoc(dev);
> >>  		videobuf_mmap_free(&fh->vb_vidq);
> >> +
> >> +		err =3D tm6000_reset(dev);
> >> +		if (err < 0)
> >> +			dev_err(&vdev->dev, "reset failed: %d\n", err);
> >>  	}
> >> =20
> >>  	kfree(fh);
> >> diff --git a/drivers/staging/tm6000/tm6000.h b/drivers/staging/tm6000/=
tm6000.h
> >> index cf57e1e..dac2063 100644
> >> --- a/drivers/staging/tm6000/tm6000.h
> >> +++ b/drivers/staging/tm6000/tm6000.h
> >> @@ -311,6 +311,7 @@ int tm6000_set_reg_mask(struct tm6000_core *dev, u=
8 req, u16 value,
> >>  						u16 index, u16 mask);
> >>  int tm6000_i2c_reset(struct tm6000_core *dev, u16 tsleep);
> >>  int tm6000_init(struct tm6000_core *dev);
> >> +int tm6000_reset(struct tm6000_core *dev);
> >> =20
> >>  int tm6000_init_analog_mode(struct tm6000_core *dev);
> >>  int tm6000_init_digital_mode(struct tm6000_core *dev);
> >=20
> > Something went wrong with the patchset. Got an OOPS during device probe.
> > Maybe it were caused due to udev, that opens V4L devices, as soon as th=
ey're
> > registered.
>=20
> int tm6000_reset(struct tm6000_core *dev)
> {
> ...=20
>         msleep(5);
> =20
>         pipe =3D usb_rcvintpipe(dev->udev,
>                         dev->int_in.endp->desc.bEndpointAddress & USB_END=
POINT_NUMBER_MASK);
>=20
>=20
> The bug is on the above line. It seems that usb_rcvintpipe() didn't like =
to be
> called before the end of the device registration code.

I fail to see how this can happen. tm6000_reset() is only called when the
last user closes the file. Since the file can only be opened in the first
place when the device has been registered, tm6000_reset() should never be
called before the device is registered.

Thierry

>=20
>=20
> >=20
> >=20
> > [34883.426065] tm6000 #0: registered device video0
> > [34883.430591] Trident TVMaster TM5600/TM6000/TM6010 USB2 board (Load s=
tatus: 0)
> > [34883.437763] usbcore: registered new interface driver tm6000
> > [34884.608372] BUG: unable to handle kernel NULL pointer dereference at=
 00000002
> > [34884.615514] IP: [<f8c4ceea>] tm6000_reset+0xd7/0x11c [tm6000]
> > [34884.621260] *pde =3D 00000000=20
> > [34884.624139] Oops: 0000 [#1] SMP=20
> > [34884.627375] Modules linked in: tuner_xc2028 tuner ir_lirc_codec lirc=
_dev ir_mce_kbd_decoder ir_sony_decoder ir_jvc_decoder ir_rc6_decoder ir_rc=
5_decoder tm6000 ir_nec_decoder videobuf_vmalloc videobuf_core rc_core v4l2=
_common videodev media tcp_lp fuse ebtable_nat ebtables ipt_MASQUERADE ipta=
ble_nat nf_nat xt_CHECKSUM iptable_mangle bridge stp llc bnep bluetooth sun=
rpc cpufreq_ondemand acpi_cpufreq mperf ip6t_REJECT nf_conntrack_ipv6 nf_de=
frag_ipv6 ip6table_filter nf_conntrack_ipv4 ip6_tables nf_defrag_ipv4 xt_st=
ate nf_conntrack snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_hwde=
p snd_seq snd_seq_device snd_pcm i7core_edac edac_core snd_timer tg3 snd iT=
CO_wdt iTCO_vendor_support hp_wmi soundcore pcspkr snd_page_alloc floppy sp=
arse_keymap rfkill serio_raw tpm_infineon microcode vboxnetadp vboxnetflt v=
boxdrv firewire_ohci firewire_core crc_itu_t nouveau ttm drm_kms_helper drm=
 i2c_algo_bit i2c_core mxm_wmi wmi video [last unloaded: tuner_xc2028]
> > [34884.712113]=20
> > [34884.713599] Pid: 7448, comm: v4l_id Tainted: G        W   3.0.0+ #1 =
Hewlett-Packard HP Z400 Workstation/0AE4h
> > [34884.723513] EIP: 0060:[<f8c4ceea>] EFLAGS: 00010246 CPU: 0
> > [34884.728983] EIP is at tm6000_reset+0xd7/0x11c [tm6000]
> > [34884.734104] EAX: f676c800 EBX: e38e5800 ECX: 00000000 EDX: 00000003
> > [34884.740349] ESI: 00000000 EDI: efc3c400 EBP: efc19f18 ESP: efc19f04
> > [34884.746594]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
> > [34884.751974] Process v4l_id (pid: 7448, ti=3Defc18000 task=3Df6608000=
 task.ti=3Defc18000)
> > [34884.759517] Stack:
> > [34884.761519]  f2b51c00 efc19f18 f8be3f96 e38e5800 f2b51c00 efc19f44 f=
8c4e6e5 f1b75a40
> > [34884.769318]  efc19f2c c0429397 efc19f34 c0810501 efc19f44 efc3c400 e=
b4b8cc0 00000010
> > [34884.777121]  efc19f54 f8bb619d eb4b8cc0 f66ffe08 efc19f84 c04e9eaf 0=
0000001 00000000
> > [34884.784918] Call Trace:
> > [34884.787360]  [<f8be3f96>] ? __videobuf_free+0x10c/0x112 [videobuf_co=
re]
> > [34884.793958]  [<f8c4e6e5>] tm6000_release+0xc7/0xf3 [tm6000]
> > [34884.799513]  [<c0429397>] ? should_resched+0xd/0x27
> > [34884.804378]  [<c0810501>] ? _cond_resched+0xd/0x21
> > [34884.809158]  [<f8bb619d>] v4l2_release+0x35/0x52 [videodev]
> > [34884.814713]  [<c04e9eaf>] fput+0x100/0x1a5
> > [34884.818798]  [<c04e75a1>] filp_close+0x5c/0x64
> > [34884.823228]  [<c04e7608>] sys_close+0x5f/0x93
> > [34884.827571]  [<c081745f>] sysenter_do_call+0x12/0x28
> > [34884.832519] Code: 24 04 40 10 c5 f8 c7 04 24 56 1d c5 f8 89 44 24 08=
 eb 4b b8 05 00 00 00 e8 b2 a7 7f c7 8b 83 44 06 00 00 8b 8b 78 06 00 00 8b=
 10 <0f> b6 49 02 c1 e2 08 83 e1 0f 81 ca 80 00 00 40 c1 e1 0f 09 ca=20
> > [34884.851965] EIP: [<f8c4ceea>] tm6000_reset+0xd7/0x11c [tm6000] SS:ES=
P 0068:efc19f04
> > [34884.859623] CR2: 0000000000000002
> >=20
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-media" =
in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20
>=20

--zaRBsRFn0XYhEU69
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk5fFxsACgkQZ+BJyKLjJp+uMACdEVamrRHWbzdYtC8mUWmD5jKg
DdkAnig0qWUT4anPDbAtPFg6mQRewzl0
=qxWe
-----END PGP SIGNATURE-----

--zaRBsRFn0XYhEU69--
