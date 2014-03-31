Return-path: <linux-media-owner@vger.kernel.org>
Received: from [217.156.133.130] ([217.156.133.130]:40159 "EHLO
	imgpgp01.kl.imgtec.org" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753737AbaCaJaH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 31 Mar 2014 05:30:07 -0400
Message-ID: <53393591.7060405@imgtec.com>
Date: Mon, 31 Mar 2014 10:29:53 +0100
From: James Hogan <james.hogan@imgtec.com>
MIME-Version: 1.0
To: =?UTF-8?B?RGF2aWQgSMOkcmRlbWFu?= <david@hardeman.nu>
CC: <linux-media@vger.kernel.org>, <m.chehab@samsung.com>
Subject: Re: [PATCH 06/11] rc-core: remove generic scancode filter
References: <20140329160705.13234.60349.stgit@zeus.muc.hardeman.nu> <20140329161116.13234.96485.stgit@zeus.muc.hardeman.nu>
In-Reply-To: <20140329161116.13234.96485.stgit@zeus.muc.hardeman.nu>
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="V0wDNogrXe3vuh4UQ70IlNtaoCW0rGC2J"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--V0wDNogrXe3vuh4UQ70IlNtaoCW0rGC2J
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 29/03/14 16:11, David H=C3=A4rdeman wrote:
> The generic scancode filtering has questionable value and makes it
> impossible to determine from userspace if there is an actual
> scancode hw filter present or not.
>=20
> So revert the generic parts.
>=20
> Based on a patch from James Hogan <james.hogan@imgtec.com>, but this
> version also makes sure that only the valid sysfs files are created
> in the first place.
>=20
> Signed-off-by: David H=C3=A4rdeman <david@hardeman.nu>
> ---
>  drivers/media/rc/rc-main.c |   66 +++++++++++++++++++++++++++++-------=
--------
>  include/media/rc-core.h    |    2 +
>  2 files changed, 45 insertions(+), 23 deletions(-)
>=20
> diff --git a/drivers/media/rc/rc-main.c b/drivers/media/rc/rc-main.c
> index ba955ac..8675e07 100644
> --- a/drivers/media/rc/rc-main.c
> +++ b/drivers/media/rc/rc-main.c
> @@ -634,7 +634,6 @@ EXPORT_SYMBOL_GPL(rc_repeat);
>  static void ir_do_keydown(struct rc_dev *dev, enum rc_type protocol,
>  			  u32 scancode, u32 keycode, u8 toggle)
>  {
> -	struct rc_scancode_filter *filter;
>  	bool new_event =3D (!dev->keypressed		 ||
>  			  dev->last_protocol !=3D protocol ||
>  			  dev->last_scancode !=3D scancode ||
> @@ -643,11 +642,6 @@ static void ir_do_keydown(struct rc_dev *dev, enum=
 rc_type protocol,
>  	if (new_event && dev->keypressed)
>  		ir_do_keyup(dev, false);
> =20
> -	/* Generic scancode filtering */
> -	filter =3D &dev->scancode_filters[RC_FILTER_NORMAL];
> -	if (filter->mask && ((scancode ^ filter->data) & filter->mask))
> -		return;
> -
>  	input_event(dev->input_dev, EV_MSC, MSC_SCAN, scancode);
> =20
>  	if (new_event && keycode !=3D KEY_RESERVED) {
> @@ -1017,14 +1011,11 @@ static ssize_t store_protocols(struct device *d=
evice,
>  	set_filter =3D (fattr->type =3D=3D RC_FILTER_NORMAL)
>  		? dev->s_filter : dev->s_wakeup_filter;
> =20
> -	if (old_type !=3D type && filter->mask) {
> +	if (set_filter && old_type !=3D type && filter->mask) {
>  		local_filter =3D *filter;
>  		if (!type) {
>  			/* no protocol =3D> clear filter */
>  			ret =3D -1;
> -		} else if (!set_filter) {
> -			/* generic filtering =3D> accept any filter */
> -			ret =3D 0;
>  		} else {
>  			/* hardware filtering =3D> try setting, otherwise clear */
>  			ret =3D set_filter(dev, &local_filter);
> @@ -1033,8 +1024,7 @@ static ssize_t store_protocols(struct device *dev=
ice,
>  			/* clear the filter */
>  			local_filter.data =3D 0;
>  			local_filter.mask =3D 0;
> -			if (set_filter)
> -				set_filter(dev, &local_filter);
> +			set_filter(dev, &local_filter);
>  		}
> =20
>  		/* commit the new filter */
> @@ -1078,7 +1068,9 @@ static ssize_t show_filter(struct device *device,=

>  		return -EINVAL;
> =20
>  	mutex_lock(&dev->lock);
> -	if (fattr->mask)
> +	if (!dev->s_filter)
> +		val =3D 0;

I suspect this should take s_wakeup_filter into account depending on
fattr->type. It's probably quite common to have a wakeup filter but no
normal filter.

The rest looks reasonable, though it could easily have been a separate
patch (at least as long as the show/store callbacks don't assume the
presence of the callbacks they use).

Cheers
James

> +	else if (fattr->mask)
>  		val =3D dev->scancode_filters[fattr->type].mask;
>  	else
>  		val =3D dev->scancode_filters[fattr->type].data;
> @@ -1202,27 +1194,45 @@ static RC_FILTER_ATTR(wakeup_filter, S_IRUGO|S_=
IWUSR,
>  static RC_FILTER_ATTR(wakeup_filter_mask, S_IRUGO|S_IWUSR,
>  		      show_filter, store_filter, RC_FILTER_WAKEUP, true);
> =20
> -static struct attribute *rc_dev_attrs[] =3D {
> +static struct attribute *rc_dev_protocol_attrs[] =3D {
>  	&dev_attr_protocols.attr.attr,
> +	NULL,
> +};
> +
> +static struct attribute_group rc_dev_protocol_attr_grp =3D {
> +	.attrs	=3D rc_dev_protocol_attrs,
> +};
> +
> +static struct attribute *rc_dev_wakeup_protocol_attrs[] =3D {
>  	&dev_attr_wakeup_protocols.attr.attr,
> +	NULL,
> +};
> +
> +static struct attribute_group rc_dev_wakeup_protocol_attr_grp =3D {
> +	.attrs	=3D rc_dev_wakeup_protocol_attrs,
> +};
> +
> +static struct attribute *rc_dev_filter_attrs[] =3D {
>  	&dev_attr_filter.attr.attr,
>  	&dev_attr_filter_mask.attr.attr,
> -	&dev_attr_wakeup_filter.attr.attr,
> -	&dev_attr_wakeup_filter_mask.attr.attr,
>  	NULL,
>  };
> =20
> -static struct attribute_group rc_dev_attr_grp =3D {
> -	.attrs	=3D rc_dev_attrs,
> +static struct attribute_group rc_dev_filter_attr_grp =3D {
> +	.attrs	=3D rc_dev_filter_attrs,
> +};
> +
> +static struct attribute *rc_dev_wakeup_filter_attrs[] =3D {
> +	&dev_attr_wakeup_filter.attr.attr,
> +	&dev_attr_wakeup_filter_mask.attr.attr,
> +	NULL,
>  };
> =20
> -static const struct attribute_group *rc_dev_attr_groups[] =3D {
> -	&rc_dev_attr_grp,
> -	NULL
> +static struct attribute_group rc_dev_wakeup_filter_attr_grp =3D {
> +	.attrs	=3D rc_dev_wakeup_filter_attrs,
>  };
> =20
>  static struct device_type rc_dev_type =3D {
> -	.groups		=3D rc_dev_attr_groups,
>  	.release	=3D rc_dev_release,
>  	.uevent		=3D rc_dev_uevent,
>  };
> @@ -1279,7 +1289,7 @@ int rc_register_device(struct rc_dev *dev)
>  	static bool raw_init =3D false; /* raw decoders loaded? */
>  	struct rc_map *rc_map;
>  	const char *path;
> -	int rc, devno;
> +	int rc, devno, attr =3D 0;
> =20
>  	if (!dev || !dev->map_name)
>  		return -EINVAL;
> @@ -1307,6 +1317,16 @@ int rc_register_device(struct rc_dev *dev)
>  			return -ENOMEM;
>  	} while (test_and_set_bit(devno, ir_core_dev_number));
> =20
> +	dev->dev.groups =3D dev->sysfs_groups;
> +	dev->sysfs_groups[attr++] =3D &rc_dev_protocol_attr_grp;
> +	if (dev->s_filter)
> +		dev->sysfs_groups[attr++] =3D &rc_dev_filter_attr_grp;=09
> +	if (dev->s_wakeup_filter)
> +		dev->sysfs_groups[attr++] =3D &rc_dev_wakeup_filter_attr_grp;
> +	if (dev->change_wakeup_protocol)
> +		dev->sysfs_groups[attr++] =3D &rc_dev_wakeup_protocol_attr_grp;
> +	dev->sysfs_groups[attr++] =3D NULL;
> +
>  	/*
>  	 * Take the lock here, as the device sysfs node will appear
>  	 * when device_add() is called, which may trigger an ir-keytable udev=

> diff --git a/include/media/rc-core.h b/include/media/rc-core.h
> index 8c31e4a..2e97b98 100644
> --- a/include/media/rc-core.h
> +++ b/include/media/rc-core.h
> @@ -60,6 +60,7 @@ enum rc_filter_type {
>  /**
>   * struct rc_dev - represents a remote control device
>   * @dev: driver model's view of this device
> + * @sysfs_groups: sysfs attribute groups
>   * @input_name: name of the input child device
>   * @input_phys: physical path to the input child device
>   * @input_id: id of the input child device (struct input_id)
> @@ -118,6 +119,7 @@ enum rc_filter_type {
>   */
>  struct rc_dev {
>  	struct device			dev;
> +	const struct attribute_group	*sysfs_groups[5];
>  	const char			*input_name;
>  	const char			*input_phys;
>  	struct input_id			input_id;
>=20


--V0wDNogrXe3vuh4UQ70IlNtaoCW0rGC2J
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.13 (GNU/Linux)

iQIcBAEBAgAGBQJTOTWRAAoJEGwLaZPeOHZ6+I0P/2Tm0touK6ZdAv4z/dFXDd7c
r95IwNNplrTpNCqoAqyeiLc32HJrieuZ2ox+R52pY72D4FeMvP5W2SKs8PqAl+DJ
TTvdqXR6butp89lWCVo12aCEOBCzuPAGcz09lwTKoPcgDaxwaBKKZ8b9yhpdx+g7
V4C+5ytegXP1z9oCSDdOFOK3Lz0j5pW9z4qxXG2YV4p4vXHNgurmJVG8R+KmPMVM
YvxuuqyaaWqtUEf0kHoT3iWOV4KG3AWA3WDFLD4gftsH9/gLcgOEqYa4tuKB3A6y
mE3OOXarD1ef8lvqFL2zbzUYi0+RlPijSXJQGh4J9RJ1evb4rFeCNuw6gG+Ah/1A
C6P7B9iKZ5Bfr/X40fqtlb/UwjVyqtdsbj9K4J67BWjJ97Rx45qvxfWsON+iq/AW
1TQ4ayKpCaKugtcMHFK1mgN7NNF+JCrBB6rV0WfVj5RHGBArEi/AbYznjRiHs2gQ
W5FSXxnv1Xx0N/GouVHFHRVYbj56KH6iI+n7Z417/ctGmLkNurWIJnXYAaBWS0I0
VuTVstn/+oW+/BL8loee0AQzOkD6cmuV0ueaxLUHdgj67kHEknvcqwvlTCGXzIuA
mwrAxYCFubucQSFmIYoJh6s9yakuj3oy3AwXzUb53YwK0jOnkFlLSRCa7R5zNBq+
JVZBFqMkHQi/dQeBAili
=TKKq
-----END PGP SIGNATURE-----

--V0wDNogrXe3vuh4UQ70IlNtaoCW0rGC2J--
