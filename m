Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.186]:52907 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750896Ab1IEFi2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 5 Sep 2011 01:38:28 -0400
Date: Mon, 5 Sep 2011 07:38:21 +0200
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH 15/21] [staging] tm6000: Execute lightweight reset on
 close.
Message-ID: <20110905053821.GA15030@avionic-0098.mockup.avionic-design.de>
References: <1312442059-23935-1-git-send-email-thierry.reding@avionic-design.de>
 <1312442059-23935-16-git-send-email-thierry.reding@avionic-design.de>
 <4E5E9F5C.8030107@redhat.com>
 <4E5EAA41.4060502@redhat.com>
 <20110901052443.GE18473@avionic-0098.mockup.avionic-design.de>
 <4E626116.7050504@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="oyUTqETQ0mS9luUI"
Content-Disposition: inline
In-Reply-To: <4E626116.7050504@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--oyUTqETQ0mS9luUI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

* Mauro Carvalho Chehab wrote:
> Em 01-09-2011 02:24, Thierry Reding escreveu:
> > * Mauro Carvalho Chehab wrote:
> >> Em 31-08-2011 17:53, Mauro Carvalho Chehab escreveu:
> >>> Em 04-08-2011 04:14, Thierry Reding escreveu:
> >>>> When the last user closes the device, perform a lightweight reset of=
 the
> >>>> device to bring it into a well-known state.
> >>>>
> >>>> Note that this is not always enough with the TM6010, which sometimes
> >>>> needs a hard reset to get into a working state again.
> >>>> ---
> >>>>  drivers/staging/tm6000/tm6000-core.c  |   43 ++++++++++++++++++++++=
+++++++++++
> >>>>  drivers/staging/tm6000/tm6000-video.c |    8 +++++-
> >>>>  drivers/staging/tm6000/tm6000.h       |    1 +
> >>>>  3 files changed, 51 insertions(+), 1 deletions(-)
> >>>>
> >>>> diff --git a/drivers/staging/tm6000/tm6000-core.c b/drivers/staging/=
tm6000/tm6000-core.c
> >>>> index 317ab7e..58c1399 100644
> >>>> --- a/drivers/staging/tm6000/tm6000-core.c
> >>>> +++ b/drivers/staging/tm6000/tm6000-core.c
> >>>> @@ -597,6 +597,49 @@ int tm6000_init(struct tm6000_core *dev)
> >>>>  	return rc;
> >>>>  }
> >>>> =20
> >>>> +int tm6000_reset(struct tm6000_core *dev)
> >>>> +{
> >>>> +	int pipe;
> >>>> +	int err;
> >>>> +
> >>>> +	msleep(500);
> >>>> +
> >>>> +	err =3D usb_set_interface(dev->udev, dev->isoc_in.bInterfaceNumber=
, 0);
> >>>> +	if (err < 0) {
> >>>> +		tm6000_err("failed to select interface %d, alt. setting 0\n",
> >>>> +				dev->isoc_in.bInterfaceNumber);
> >>>> +		return err;
> >>>> +	}
> >>>> +
> >>>> +	err =3D usb_reset_configuration(dev->udev);
> >>>> +	if (err < 0) {
> >>>> +		tm6000_err("failed to reset configuration\n");
> >>>> +		return err;
> >>>> +	}
> >>>> +
> >>>> +	msleep(5);
> >>>> +
> >>>> +	err =3D usb_set_interface(dev->udev, dev->isoc_in.bInterfaceNumber=
, 2);
> >>>> +	if (err < 0) {
> >>>> +		tm6000_err("failed to select interface %d, alt. setting 2\n",
> >>>> +				dev->isoc_in.bInterfaceNumber);
> >>>> +		return err;
> >>>> +	}
> >>>> +
> >>>> +	msleep(5);
> >>>> +
> >>>> +	pipe =3D usb_rcvintpipe(dev->udev,
> >>>> +			dev->int_in.endp->desc.bEndpointAddress & USB_ENDPOINT_NUMBER_MA=
SK);
> >>>> +
> >>>> +	err =3D usb_clear_halt(dev->udev, pipe);
> >>>> +	if (err < 0) {
> >>>> +		tm6000_err("usb_clear_halt failed: %d\n", err);
> >>>> +		return err;
> >>>> +	}
> >>>> +
> >>>> +	return 0;
> >>>> +}
> >>>> +
> >>>>  int tm6000_set_audio_bitrate(struct tm6000_core *dev, int bitrate)
> >>>>  {
> >>>>  	int val =3D 0;
> >>>> diff --git a/drivers/staging/tm6000/tm6000-video.c b/drivers/staging=
/tm6000/tm6000-video.c
> >>>> index 492ec73..70fc19e 100644
> >>>> --- a/drivers/staging/tm6000/tm6000-video.c
> >>>> +++ b/drivers/staging/tm6000/tm6000-video.c
> >>>> @@ -1503,7 +1503,6 @@ static int tm6000_open(struct file *file)
> >>>>  	tm6000_get_std_res(dev);
> >>>> =20
> >>>>  	file->private_data =3D fh;
> >>>> -	fh->vdev =3D vdev;
> >>>>  	fh->dev =3D dev;
> >>>>  	fh->radio =3D radio;
> >>>>  	fh->type =3D type;
> >>>> @@ -1606,9 +1605,16 @@ static int tm6000_release(struct file *file)
> >>>>  	dev->users--;
> >>>> =20
> >>>>  	res_free(dev, fh);
> >>>> +
> >>>>  	if (!dev->users) {
> >>>> +		int err;
> >>>> +
> >>>>  		tm6000_uninit_isoc(dev);
> >>>>  		videobuf_mmap_free(&fh->vb_vidq);
> >>>> +
> >>>> +		err =3D tm6000_reset(dev);
> >>>> +		if (err < 0)
> >>>> +			dev_err(&vdev->dev, "reset failed: %d\n", err);
> >>>>  	}
> >>>> =20
> >>>>  	kfree(fh);
> >>>> diff --git a/drivers/staging/tm6000/tm6000.h b/drivers/staging/tm600=
0/tm6000.h
> >>>> index cf57e1e..dac2063 100644
> >>>> --- a/drivers/staging/tm6000/tm6000.h
> >>>> +++ b/drivers/staging/tm6000/tm6000.h
> >>>> @@ -311,6 +311,7 @@ int tm6000_set_reg_mask(struct tm6000_core *dev,=
 u8 req, u16 value,
> >>>>  						u16 index, u16 mask);
> >>>>  int tm6000_i2c_reset(struct tm6000_core *dev, u16 tsleep);
> >>>>  int tm6000_init(struct tm6000_core *dev);
> >>>> +int tm6000_reset(struct tm6000_core *dev);
> >>>> =20
> >>>>  int tm6000_init_analog_mode(struct tm6000_core *dev);
> >>>>  int tm6000_init_digital_mode(struct tm6000_core *dev);
> >>>
> >>> Something went wrong with the patchset. Got an OOPS during device pro=
be.
> >>> Maybe it were caused due to udev, that opens V4L devices, as soon as =
they're
> >>> registered.
> >>
> >> int tm6000_reset(struct tm6000_core *dev)
> >> {
> >> ...=20
> >>         msleep(5);
> >> =20
> >>         pipe =3D usb_rcvintpipe(dev->udev,
> >>                         dev->int_in.endp->desc.bEndpointAddress & USB_=
ENDPOINT_NUMBER_MASK);
> >>
> >>
> >> The bug is on the above line. It seems that usb_rcvintpipe() didn't li=
ke to be
> >> called before the end of the device registration code.
> >=20
> > I fail to see how this can happen. tm6000_reset() is only called when t=
he
> > last user closes the file. Since the file can only be opened in the fir=
st
> > place when the device has been registered, tm6000_reset() should never =
be
> > called before the device is registered.
>=20
> It is quite simple: not all tm5600/6000/6010 devices have int_in endpoint=
s.
>=20
> The enclosed patch fixes it. Tested on a Saphire Wonder TV device (tm5600=
).
>=20
> [media] tm6000: Don't try to use a non-existing interface
>=20
> The dev->int_in USB interfaces is used by some devices for the Remote Con=
troller.
> Not all devices seem to define this interface.
>=20
> Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
>=20
> diff --git a/drivers/staging/tm6000/tm6000-core.c b/drivers/staging/tm600=
0/tm6000-core.c
> index 9cef1d1..b3c4e05 100644
> --- a/drivers/staging/tm6000/tm6000-core.c
> +++ b/drivers/staging/tm6000/tm6000-core.c
> @@ -621,6 +621,12 @@ int tm6000_reset(struct tm6000_core *dev)
> =20
>  	msleep(5);
> =20
> +	/*
> +	 * Not all devices have int_in defined
> +	 */
> +	if (!dev->int_in.endp)
> +		return 0;
> +
>  	err =3D usb_set_interface(dev->udev, dev->isoc_in.bInterfaceNumber, 2);
>  	if (err < 0) {
>  		tm6000_err("failed to select interface %d, alt. setting 2\n",

Wouldn't it make more sense to move this check after the usb_set_interface()
call and right before usb_rcvintpipe()? Note that usb_set_interface() uses
isoc_in, not int_in.

Thierry

--oyUTqETQ0mS9luUI
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk5kYE0ACgkQZ+BJyKLjJp//kACfap76Wde6W3O9lUc/zE8fg36E
CukAnRBat2afLqYVzHEQLv5iURDQmWf7
=V3o+
-----END PGP SIGNATURE-----

--oyUTqETQ0mS9luUI--
