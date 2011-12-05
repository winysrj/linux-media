Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.187]:61946 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751338Ab1LEHVr (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 5 Dec 2011 02:21:47 -0500
Date: Mon, 5 Dec 2011 08:21:31 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: linuxtv@stefanringel.de
Cc: linux-media@vger.kernel.org, mchehab@redhat.com,
	d.belimov@gmail.com
Subject: Re: [PATCH 3/5] tm6000: bugfix interrupt reset
Message-ID: <20111205072131.GB7341@avionic-0098.mockup.avionic-design.de>
References: <1322509580-14460-1-git-send-email-linuxtv@stefanringel.de>
 <1322509580-14460-3-git-send-email-linuxtv@stefanringel.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="CdrF4e02JqNVZeln"
Content-Disposition: inline
In-Reply-To: <1322509580-14460-3-git-send-email-linuxtv@stefanringel.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--CdrF4e02JqNVZeln
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

* linuxtv@stefanringel.de wrote:
> From: Stefan Ringel <linuxtv@stefanringel.de>
>=20
> Signed-off-by: Stefan Ringel <linuxtv@stefanringel.de>

Your commit message needs more details. Why do you think this is a bugfix?
Also this commit seems to effectively revert (and then partially reimplemen=
t)
a patch that I posted some months ago.

> ---
>  drivers/media/video/tm6000/tm6000-core.c  |   49 -----------------------=
------
>  drivers/media/video/tm6000/tm6000-video.c |   21 ++++++++++--
>  2 files changed, 17 insertions(+), 53 deletions(-)
>=20
> diff --git a/drivers/media/video/tm6000/tm6000-core.c b/drivers/media/vid=
eo/tm6000/tm6000-core.c
> index c007e6d..920299e 100644
> --- a/drivers/media/video/tm6000/tm6000-core.c
> +++ b/drivers/media/video/tm6000/tm6000-core.c
> @@ -599,55 +599,6 @@ int tm6000_init(struct tm6000_core *dev)
>  	return rc;
>  }
> =20
> -int tm6000_reset(struct tm6000_core *dev)
> -{
> -	int pipe;
> -	int err;
> -
> -	msleep(500);
> -
> -	err =3D usb_set_interface(dev->udev, dev->isoc_in.bInterfaceNumber, 0);
> -	if (err < 0) {
> -		tm6000_err("failed to select interface %d, alt. setting 0\n",
> -				dev->isoc_in.bInterfaceNumber);
> -		return err;
> -	}
> -
> -	err =3D usb_reset_configuration(dev->udev);
> -	if (err < 0) {
> -		tm6000_err("failed to reset configuration\n");
> -		return err;
> -	}
> -
> -	if ((dev->quirks & TM6000_QUIRK_NO_USB_DELAY) =3D=3D 0)
> -		msleep(5);
> -
> -	/*
> -	 * Not all devices have int_in defined
> -	 */
> -	if (!dev->int_in.endp)
> -		return 0;
> -
> -	err =3D usb_set_interface(dev->udev, dev->isoc_in.bInterfaceNumber, 2);
> -	if (err < 0) {
> -		tm6000_err("failed to select interface %d, alt. setting 2\n",
> -				dev->isoc_in.bInterfaceNumber);
> -		return err;
> -	}
> -
> -	msleep(5);
> -
> -	pipe =3D usb_rcvintpipe(dev->udev,
> -			dev->int_in.endp->desc.bEndpointAddress & USB_ENDPOINT_NUMBER_MASK);
> -
> -	err =3D usb_clear_halt(dev->udev, pipe);
> -	if (err < 0) {
> -		tm6000_err("usb_clear_halt failed: %d\n", err);
> -		return err;
> -	}
> -
> -	return 0;
> -}
> =20
>  int tm6000_set_audio_bitrate(struct tm6000_core *dev, int bitrate)
>  {
> diff --git a/drivers/media/video/tm6000/tm6000-video.c b/drivers/media/vi=
deo/tm6000/tm6000-video.c
> index 1e5ace0..4db3535 100644
> --- a/drivers/media/video/tm6000/tm6000-video.c
> +++ b/drivers/media/video/tm6000/tm6000-video.c
> @@ -1609,12 +1609,25 @@ static int tm6000_release(struct file *file)
> =20
>  		tm6000_uninit_isoc(dev);
> =20
> +		/* Stop interrupt USB pipe */
> +		tm6000_ir_int_stop(dev);
> +
> +		usb_reset_configuration(dev->udev);
> +
> +		if (&dev->int_in)

This check is wrong, &dev->int_in will always be true.

> +			usb_set_interface(dev->udev,
> +			dev->isoc_in.bInterfaceNumber,
> +			2);
> +		else
> +			usb_set_interface(dev->udev,
> +			dev->isoc_in.bInterfaceNumber,
> +			0);

This would need better indentation.

> +
> +		/* Start interrupt USB pipe */
> +		tm6000_ir_int_start(dev);
> +

Why do you restart the IR interrupt pipe when the device is being released?

>  		if (!fh->radio)
>  			videobuf_mmap_free(&fh->vb_vidq);
> -
> -		err =3D tm6000_reset(dev);
> -		if (err < 0)
> -			dev_err(&vdev->dev, "reset failed: %d\n", err);
>  	}
> =20
>  	kfree(fh);

I think this whole patch should be much shorter. Something along the lines
of:

@@ -1609,12 +1609,25 @@ static int tm6000_release(struct file *file)
=20
 		tm6000_uninit_isoc(dev);
=20
+		/* Stop interrupt USB pipe */
+		tm6000_ir_int_stop(dev);
+
 		if (!fh->radio)
 			videobuf_mmap_free(&fh->vb_vidq);
=20

Thierry

--CdrF4e02JqNVZeln
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk7ccPsACgkQZ+BJyKLjJp9IOACeNDx70Jfpisi/M/B2HuZG38sx
mXAAn0VssMHo5OGSCPmaCM2FXhQGZNfA
=vHQl
-----END PGP SIGNATURE-----

--CdrF4e02JqNVZeln--
