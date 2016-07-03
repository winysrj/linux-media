Return-path: <linux-media-owner@vger.kernel.org>
Received: from butterbrot.org ([176.9.106.16]:38798 "EHLO butterbrot.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752841AbcGCSMA (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 3 Jul 2016 14:12:00 -0400
Subject: Re: [PATCH v6 11/11] Input: sur40 - use new V4L2 touch input type
To: Nick Dyer <nick@shmanahar.org>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
References: <1467308334-12580-1-git-send-email-nick@shmanahar.org>
 <1467308334-12580-12-git-send-email-nick@shmanahar.org>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org,
	Benjamin Tissoires <benjamin.tissoires@redhat.com>,
	Benson Leung <bleung@chromium.org>,
	Alan Bowens <Alan.Bowens@atmel.com>,
	Javier Martinez Canillas <javier@osg.samsung.com>,
	Chris Healy <cphealy@gmail.com>,
	Henrik Rydberg <rydberg@bitmath.org>,
	Andrew Duggan <aduggan@synaptics.com>,
	James Chen <james.chen@emc.com.tw>,
	Dudley Du <dudl@cypress.com>,
	Andrew de los Reyes <adlr@chromium.org>,
	sheckylin@chromium.org, Peter Hutterer <peter.hutterer@who-t.net>,
	mchehab@osg.samsung.com, jon.older@itdev.co.uk,
	nick.dyer@itdev.co.uk
From: Florian Echtler <floe@butterbrot.org>
Message-ID: <57795554.4040708@butterbrot.org>
Date: Sun, 3 Jul 2016 20:11:32 +0200
MIME-Version: 1.0
In-Reply-To: <1467308334-12580-12-git-send-email-nick@shmanahar.org>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="qqNWlrIK5pKkvtdHigGRBU8MWCRI0t6QJ"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--qqNWlrIK5pKkvtdHigGRBU8MWCRI0t6QJ
Content-Type: multipart/mixed; boundary="SiArtfgQefg25HRWm7GCUqVsSaaPqI7Vr"
From: Florian Echtler <floe@butterbrot.org>
To: Nick Dyer <nick@shmanahar.org>,
 Dmitry Torokhov <dmitry.torokhov@gmail.com>,
 Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-media@vger.kernel.org,
 Benjamin Tissoires <benjamin.tissoires@redhat.com>,
 Benson Leung <bleung@chromium.org>, Alan Bowens <Alan.Bowens@atmel.com>,
 Javier Martinez Canillas <javier@osg.samsung.com>,
 Chris Healy <cphealy@gmail.com>, Henrik Rydberg <rydberg@bitmath.org>,
 Andrew Duggan <aduggan@synaptics.com>, James Chen <james.chen@emc.com.tw>,
 Dudley Du <dudl@cypress.com>, Andrew de los Reyes <adlr@chromium.org>,
 sheckylin@chromium.org, Peter Hutterer <peter.hutterer@who-t.net>,
 mchehab@osg.samsung.com, jon.older@itdev.co.uk, nick.dyer@itdev.co.uk
Message-ID: <57795554.4040708@butterbrot.org>
Subject: Re: [PATCH v6 11/11] Input: sur40 - use new V4L2 touch input type
References: <1467308334-12580-1-git-send-email-nick@shmanahar.org>
 <1467308334-12580-12-git-send-email-nick@shmanahar.org>
In-Reply-To: <1467308334-12580-12-git-send-email-nick@shmanahar.org>

--SiArtfgQefg25HRWm7GCUqVsSaaPqI7Vr
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 30.06.2016 19:38, Nick Dyer wrote:
> Support both V4L2_TCH_FMT_TU08 and V4L2_PIX_FMT_GREY for backwards
> compatibility.
>=20
> Note: I have not tested these changes (I have no access to the hardware=
)
> so not signing off.

I will try to test this ASAP. However, I'm currently ill, so it might
take a while - sorry.

Best, Florian

> ---
>  drivers/input/touchscreen/sur40.c | 121 +++++++++++++++++++++++++++---=
--------
>  1 file changed, 88 insertions(+), 33 deletions(-)
>=20
> diff --git a/drivers/input/touchscreen/sur40.c b/drivers/input/touchscr=
een/sur40.c
> index 880c40b..9ba68cf 100644
> --- a/drivers/input/touchscreen/sur40.c
> +++ b/drivers/input/touchscreen/sur40.c
> @@ -139,6 +139,27 @@ struct sur40_image_header {
>  #define SUR40_GET_STATE   0xc5 /*  4 bytes state (?) */
>  #define SUR40_GET_SENSORS 0xb1 /*  8 bytes sensors   */
> =20
> +static const struct v4l2_pix_format sur40_pix_format[] =3D {
> +	{
> +		.pixelformat =3D V4L2_TCH_FMT_TU08,
> +		.width  =3D SENSOR_RES_X / 2,
> +		.height =3D SENSOR_RES_Y / 2,
> +		.field =3D V4L2_FIELD_NONE,
> +		.colorspace =3D V4L2_COLORSPACE_SRGB,
> +		.bytesperline =3D SENSOR_RES_X / 2,
> +		.sizeimage =3D (SENSOR_RES_X/2) * (SENSOR_RES_Y/2),
> +	},
> +	{
> +		.pixelformat =3D V4L2_PIX_FMT_GREY,
> +		.width  =3D SENSOR_RES_X / 2,
> +		.height =3D SENSOR_RES_Y / 2,
> +		.field =3D V4L2_FIELD_NONE,
> +		.colorspace =3D V4L2_COLORSPACE_SRGB,
> +		.bytesperline =3D SENSOR_RES_X / 2,
> +		.sizeimage =3D (SENSOR_RES_X/2) * (SENSOR_RES_Y/2),
> +	}
> +};
> +
>  /* master device state */
>  struct sur40_state {
> =20
> @@ -149,6 +170,7 @@ struct sur40_state {
>  	struct v4l2_device v4l2;
>  	struct video_device vdev;
>  	struct mutex lock;
> +	struct v4l2_pix_format pix_fmt;
> =20
>  	struct vb2_queue queue;
>  	struct vb2_alloc_ctx *alloc_ctx;
> @@ -170,7 +192,6 @@ struct sur40_buffer {
> =20
>  /* forward declarations */
>  static const struct video_device sur40_video_device;
> -static const struct v4l2_pix_format sur40_video_format;
>  static const struct vb2_queue sur40_queue;
>  static void sur40_process_video(struct sur40_state *sur40);
> =20
> @@ -421,7 +442,7 @@ static void sur40_process_video(struct sur40_state =
*sur40)
>  		goto err_poll;
>  	}
> =20
> -	if (le32_to_cpu(img->size) !=3D sur40_video_format.sizeimage) {
> +	if (le32_to_cpu(img->size) !=3D sur40->pix_fmt.sizeimage) {
>  		dev_err(sur40->dev, "image size mismatch\n");
>  		goto err_poll;
>  	}
> @@ -432,7 +453,7 @@ static void sur40_process_video(struct sur40_state =
*sur40)
> =20
>  	result =3D usb_sg_init(&sgr, sur40->usbdev,
>  		usb_rcvbulkpipe(sur40->usbdev, VIDEO_ENDPOINT), 0,
> -		sgt->sgl, sgt->nents, sur40_video_format.sizeimage, 0);
> +		sgt->sgl, sgt->nents, sur40->pix_fmt.sizeimage, 0);
>  	if (result < 0) {
>  		dev_err(sur40->dev, "error %d in usb_sg_init\n", result);
>  		goto err_poll;
> @@ -593,13 +614,14 @@ static int sur40_probe(struct usb_interface *inte=
rface,
>  		goto err_unreg_v4l2;
>  	}
> =20
> +	sur40->pix_fmt =3D sur40_pix_format[0];
>  	sur40->vdev =3D sur40_video_device;
>  	sur40->vdev.v4l2_dev =3D &sur40->v4l2;
>  	sur40->vdev.lock =3D &sur40->lock;
>  	sur40->vdev.queue =3D &sur40->queue;
>  	video_set_drvdata(&sur40->vdev, sur40);
> =20
> -	error =3D video_register_device(&sur40->vdev, VFL_TYPE_GRABBER, -1);
> +	error =3D video_register_device(&sur40->vdev, VFL_TYPE_TOUCH, -1);
>  	if (error) {
>  		dev_err(&interface->dev,
>  			"Unable to register video subdevice.");
> @@ -662,10 +684,10 @@ static int sur40_queue_setup(struct vb2_queue *q,=

>  	alloc_ctxs[0] =3D sur40->alloc_ctx;
> =20
>  	if (*nplanes)
> -		return sizes[0] < sur40_video_format.sizeimage ? -EINVAL : 0;
> +		return sizes[0] < sur40->pix_fmt.sizeimage ? -EINVAL : 0;
> =20
>  	*nplanes =3D 1;
> -	sizes[0] =3D sur40_video_format.sizeimage;
> +	sizes[0] =3D sur40->pix_fmt.sizeimage;
> =20
>  	return 0;
>  }
> @@ -677,7 +699,7 @@ static int sur40_queue_setup(struct vb2_queue *q,
>  static int sur40_buffer_prepare(struct vb2_buffer *vb)
>  {
>  	struct sur40_state *sur40 =3D vb2_get_drv_priv(vb->vb2_queue);
> -	unsigned long size =3D sur40_video_format.sizeimage;
> +	unsigned long size =3D sur40->pix_fmt.sizeimage;
> =20
>  	if (vb2_plane_size(vb, 0) < size) {
>  		dev_err(&sur40->usbdev->dev, "buffer too small (%lu < %lu)\n",
> @@ -751,7 +773,7 @@ static int sur40_vidioc_querycap(struct file *file,=
 void *priv,
>  	strlcpy(cap->driver, DRIVER_SHORT, sizeof(cap->driver));
>  	strlcpy(cap->card, DRIVER_LONG, sizeof(cap->card));
>  	usb_make_path(sur40->usbdev, cap->bus_info, sizeof(cap->bus_info));
> -	cap->device_caps =3D V4L2_CAP_VIDEO_CAPTURE |
> +	cap->device_caps =3D V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_TOUCH |
>  		V4L2_CAP_READWRITE |
>  		V4L2_CAP_STREAMING;
>  	cap->capabilities =3D cap->device_caps | V4L2_CAP_DEVICE_CAPS;
> @@ -763,7 +785,7 @@ static int sur40_vidioc_enum_input(struct file *fil=
e, void *priv,
>  {
>  	if (i->index !=3D 0)
>  		return -EINVAL;
> -	i->type =3D V4L2_INPUT_TYPE_CAMERA;
> +	i->type =3D V4L2_INPUT_TYPE_TOUCH;
>  	i->std =3D V4L2_STD_UNKNOWN;
>  	strlcpy(i->name, "In-Cell Sensor", sizeof(i->name));
>  	i->capabilities =3D 0;
> @@ -781,20 +803,57 @@ static int sur40_vidioc_g_input(struct file *file=
, void *priv, unsigned int *i)
>  	return 0;
>  }
> =20
> -static int sur40_vidioc_fmt(struct file *file, void *priv,
> +static int sur40_vidioc_try_fmt(struct file *file, void *priv,
>  			    struct v4l2_format *f)
>  {
> -	f->fmt.pix =3D sur40_video_format;
> +	switch (f->fmt.pix.pixelformat) {
> +		case V4L2_PIX_FMT_GREY:
> +			f->fmt.pix =3D sur40_pix_format[1];
> +			break;
> +
> +		default:
> +			f->fmt.pix =3D sur40_pix_format[0];
> +			break;
> +	}
> +
> +	return 0;
> +}
> +
> +static int sur40_vidioc_s_fmt(struct file *file, void *priv,
> +			    struct v4l2_format *f)
> +{
> +	struct sur40_state *sur40 =3D video_drvdata(file);
> +
> +	switch (f->fmt.pix.pixelformat) {
> +		case V4L2_PIX_FMT_GREY:
> +			sur40->pix_fmt =3D sur40_pix_format[1];
> +			break;
> +
> +		default:
> +			sur40->pix_fmt =3D sur40_pix_format[0];
> +			break;
> +	}
> +
> +	f->fmt.pix =3D sur40->pix_fmt;
> +	return 0;
> +}
> +
> +static int sur40_vidioc_g_fmt(struct file *file, void *priv,
> +			    struct v4l2_format *f)
> +{
> +	struct sur40_state *sur40 =3D video_drvdata(file);
> +
> +	f->fmt.pix =3D sur40->pix_fmt;
>  	return 0;
>  }
> =20
>  static int sur40_vidioc_enum_fmt(struct file *file, void *priv,
>  				 struct v4l2_fmtdesc *f)
>  {
> -	if (f->index !=3D 0)
> +	if (f->index >=3D ARRAY_SIZE(sur40_pix_format))
>  		return -EINVAL;
> -	strlcpy(f->description, "8-bit greyscale", sizeof(f->description));
> -	f->pixelformat =3D V4L2_PIX_FMT_GREY;
> +
> +	f->pixelformat =3D sur40_pix_format[f->index].pixelformat;
>  	f->flags =3D 0;
>  	return 0;
>  }
> @@ -802,21 +861,27 @@ static int sur40_vidioc_enum_fmt(struct file *fil=
e, void *priv,
>  static int sur40_vidioc_enum_framesizes(struct file *file, void *priv,=

>  					struct v4l2_frmsizeenum *f)
>  {
> -	if ((f->index !=3D 0) || (f->pixel_format !=3D V4L2_PIX_FMT_GREY))
> +	struct sur40_state *sur40 =3D video_drvdata(file);
> +
> +	if ((f->index !=3D 0) || ((f->pixel_format !=3D V4L2_TCH_FMT_TU08)
> +		&& (f->pixel_format !=3D V4L2_PIX_FMT_GREY)))
>  		return -EINVAL;
> =20
>  	f->type =3D V4L2_FRMSIZE_TYPE_DISCRETE;
> -	f->discrete.width  =3D sur40_video_format.width;
> -	f->discrete.height =3D sur40_video_format.height;
> +	f->discrete.width  =3D sur40->pix_fmt.width;
> +	f->discrete.height =3D sur40->pix_fmt.height;
>  	return 0;
>  }
> =20
>  static int sur40_vidioc_enum_frameintervals(struct file *file, void *p=
riv,
>  					    struct v4l2_frmivalenum *f)
>  {
> -	if ((f->index > 1) || (f->pixel_format !=3D V4L2_PIX_FMT_GREY)
> -		|| (f->width  !=3D sur40_video_format.width)
> -		|| (f->height !=3D sur40_video_format.height))
> +	struct sur40_state *sur40 =3D video_drvdata(file);
> +
> +	if ((f->index > 1) || ((f->pixel_format !=3D V4L2_TCH_FMT_TU08)
> +	        && (f->pixel_format !=3D V4L2_PIX_FMT_GREY))
> +		|| (f->width  !=3D sur40->pix_fmt.width)
> +		|| (f->height !=3D sur40->pix_fmt.height))
>  			return -EINVAL;
> =20
>  	f->type =3D V4L2_FRMIVAL_TYPE_DISCRETE;
> @@ -873,9 +938,9 @@ static const struct v4l2_ioctl_ops sur40_video_ioct=
l_ops =3D {
>  	.vidioc_querycap	=3D sur40_vidioc_querycap,
> =20
>  	.vidioc_enum_fmt_vid_cap =3D sur40_vidioc_enum_fmt,
> -	.vidioc_try_fmt_vid_cap	=3D sur40_vidioc_fmt,
> -	.vidioc_s_fmt_vid_cap	=3D sur40_vidioc_fmt,
> -	.vidioc_g_fmt_vid_cap	=3D sur40_vidioc_fmt,
> +	.vidioc_try_fmt_vid_cap	=3D sur40_vidioc_try_fmt,
> +	.vidioc_s_fmt_vid_cap	=3D sur40_vidioc_s_fmt,
> +	.vidioc_g_fmt_vid_cap	=3D sur40_vidioc_g_fmt,
> =20
>  	.vidioc_enum_framesizes =3D sur40_vidioc_enum_framesizes,
>  	.vidioc_enum_frameintervals =3D sur40_vidioc_enum_frameintervals,
> @@ -902,16 +967,6 @@ static const struct video_device sur40_video_devic=
e =3D {
>  	.release =3D video_device_release_empty,
>  };
> =20
> -static const struct v4l2_pix_format sur40_video_format =3D {
> -	.pixelformat =3D V4L2_PIX_FMT_GREY,
> -	.width  =3D SENSOR_RES_X / 2,
> -	.height =3D SENSOR_RES_Y / 2,
> -	.field =3D V4L2_FIELD_NONE,
> -	.colorspace =3D V4L2_COLORSPACE_SRGB,
> -	.bytesperline =3D SENSOR_RES_X / 2,
> -	.sizeimage =3D (SENSOR_RES_X/2) * (SENSOR_RES_Y/2),
> -};
> -
>  /* USB-specific object needed to register this driver with the USB sub=
system. */
>  static struct usb_driver sur40_driver =3D {
>  	.name =3D DRIVER_SHORT,
>=20


--=20
SENT FROM MY DEC VT50 TERMINAL


--SiArtfgQefg25HRWm7GCUqVsSaaPqI7Vr--

--qqNWlrIK5pKkvtdHigGRBU8MWCRI0t6QJ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iEYEARECAAYFAld5VVcACgkQ7CzyshGvathplACghwq5pTkYiSDCs4GlPUiji7z2
F1kAn01tYrcNK0cTxT2/Vh0V8lQlg3ji
=arkb
-----END PGP SIGNATURE-----

--qqNWlrIK5pKkvtdHigGRBU8MWCRI0t6QJ--
