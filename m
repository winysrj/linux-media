Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f173.google.com ([209.85.212.173]:41253 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751552AbaDDXiN (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 4 Apr 2014 19:38:13 -0400
Received: by mail-wi0-f173.google.com with SMTP id z2so2176589wiv.6
        for <linux-media@vger.kernel.org>; Fri, 04 Apr 2014 16:38:12 -0700 (PDT)
From: James Hogan <james.hogan@imgtec.com>
To: David =?ISO-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>
Cc: linux-media@vger.kernel.org, m.chehab@samsung.com
Subject: Re: [PATCH 3/3] rc-core: remove generic scancode filter
Date: Sat, 05 Apr 2014 00:38:02 +0100
Message-ID: <1947949.i8Ms2jkE72@radagast>
In-Reply-To: <20140404220606.5068.13356.stgit@zeus.muc.hardeman.nu>
References: <20140404220404.5068.3669.stgit@zeus.muc.hardeman.nu> <20140404220606.5068.13356.stgit@zeus.muc.hardeman.nu>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart3304532.d6mLlxoHJY"; micalg="pgp-sha1"; protocol="application/pgp-signature"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--nextPart3304532.d6mLlxoHJY
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"

On Saturday 05 April 2014 00:06:06 David H=E4rdeman wrote:
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
> v2: correct dev->s_filter check
>=20
> v3: move some parts over from the previous patch
>=20
> Signed-off-by: David H=E4rdeman <david@hardeman.nu>

Acked-by: James Hogan <james.hogan@imgtec.com>

Thanks
James

> ---
>  drivers/media/rc/rc-main.c |   88
> +++++++++++++++++++++++++++----------------- include/media/rc-core.h =
   | =20
>  2 +
>  2 files changed, 55 insertions(+), 35 deletions(-)
>=20
> diff --git a/drivers/media/rc/rc-main.c b/drivers/media/rc/rc-main.c
> index ecbc20c..970b93d 100644
> --- a/drivers/media/rc/rc-main.c
> +++ b/drivers/media/rc/rc-main.c
> @@ -633,19 +633,13 @@ EXPORT_SYMBOL_GPL(rc_repeat);
>  static void ir_do_keydown(struct rc_dev *dev, int scancode,
>  =09=09=09  u32 keycode, u8 toggle)
>  {
> -=09struct rc_scancode_filter *filter;
> -=09bool new_event =3D !dev->keypressed ||
> -=09=09=09 dev->last_scancode !=3D scancode ||
> -=09=09=09 dev->last_toggle !=3D toggle;
> +=09bool new_event =3D (!dev->keypressed=09=09 ||
> +=09=09=09  dev->last_scancode !=3D scancode ||
> +=09=09=09  dev->last_toggle !=3D toggle);
>=20
>  =09if (new_event && dev->keypressed)
>  =09=09ir_do_keyup(dev, false);
>=20
> -=09/* Generic scancode filtering */
> -=09filter =3D &dev->scancode_filters[RC_FILTER_NORMAL];
> -=09if (filter->mask && ((scancode ^ filter->data) & filter->mask))
> -=09=09return;
> -
>  =09input_event(dev->input_dev, EV_MSC, MSC_SCAN, scancode);
>=20
>  =09if (new_event && keycode !=3D KEY_RESERVED) {
> @@ -1011,14 +1005,11 @@ static ssize_t store_protocols(struct device
> *device, set_filter =3D (fattr->type =3D=3D RC_FILTER_NORMAL)
>  =09=09? dev->s_filter : dev->s_wakeup_filter;
>=20
> -=09if (old_type !=3D type && filter->mask) {
> +=09if (set_filter && old_type !=3D type && filter->mask) {
>  =09=09local_filter =3D *filter;
>  =09=09if (!type) {
>  =09=09=09/* no protocol =3D> clear filter */
>  =09=09=09ret =3D -1;
> -=09=09} else if (!set_filter) {
> -=09=09=09/* generic filtering =3D> accept any filter */
> -=09=09=09ret =3D 0;
>  =09=09} else {
>  =09=09=09/* hardware filtering =3D> try setting, otherwise clear */
>  =09=09=09ret =3D set_filter(dev, &local_filter);
> @@ -1027,8 +1018,7 @@ static ssize_t store_protocols(struct device *d=
evice,
>  =09=09=09/* clear the filter */
>  =09=09=09local_filter.data =3D 0;
>  =09=09=09local_filter.mask =3D 0;
> -=09=09=09if (set_filter)
> -=09=09=09=09set_filter(dev, &local_filter);
> +=09=09=09set_filter(dev, &local_filter);
>  =09=09}
>=20
>  =09=09/* commit the new filter */
> @@ -1072,7 +1062,10 @@ static ssize_t show_filter(struct device *devi=
ce,
>  =09=09return -EINVAL;
>=20
>  =09mutex_lock(&dev->lock);
> -=09if (fattr->mask)
> +=09if ((fattr->type =3D=3D RC_FILTER_NORMAL && !dev->s_filter) ||
> +=09    (fattr->type =3D=3D RC_FILTER_WAKEUP && !dev->s_wakeup_filter=
))
> +=09=09val =3D 0;
> +=09else if (fattr->mask)
>  =09=09val =3D dev->scancode_filters[fattr->type].mask;
>  =09else
>  =09=09val =3D dev->scancode_filters[fattr->type].data;
> @@ -1120,12 +1113,11 @@ static ssize_t store_filter(struct device *de=
vice,
>  =09if (ret < 0)
>  =09=09return ret;
>=20
> +=09/* Can the scancode filter be set? */
>  =09set_filter =3D (fattr->type =3D=3D RC_FILTER_NORMAL) ? dev->s_fil=
ter :
>  =09=09=09=09=09=09=09 dev->s_wakeup_filter;
> -
> -=09/* Scancode filter not supported (but still accept 0) */
> -=09if (!set_filter && fattr->type =3D=3D RC_FILTER_WAKEUP)
> -=09=09return val ? -EINVAL : count;
> +=09if (!set_filter)
> +=09=09return -EINVAL;
>=20
>  =09mutex_lock(&dev->lock);
>=20
> @@ -1143,11 +1135,9 @@ static ssize_t store_filter(struct device *dev=
ice,
>  =09=09goto unlock;
>  =09}
>=20
> -=09if (set_filter) {
> -=09=09ret =3D set_filter(dev, &local_filter);
> -=09=09if (ret < 0)
> -=09=09=09goto unlock;
> -=09}
> +=09ret =3D set_filter(dev, &local_filter);
> +=09if (ret < 0)
> +=09=09goto unlock;
>=20
>  =09/* Success, commit the new filter */
>  =09*filter =3D local_filter;
> @@ -1199,27 +1189,45 @@ static RC_FILTER_ATTR(wakeup_filter,
> S_IRUGO|S_IWUSR, static RC_FILTER_ATTR(wakeup_filter_mask, S_IRUGO|S_=
IWUSR,
>  =09=09      show_filter, store_filter, RC_FILTER_WAKEUP, true);
>=20
> -static struct attribute *rc_dev_attrs[] =3D {
> +static struct attribute *rc_dev_protocol_attrs[] =3D {
>  =09&dev_attr_protocols.attr.attr,
> +=09NULL,
> +};
> +
> +static struct attribute_group rc_dev_protocol_attr_grp =3D {
> +=09.attrs=09=3D rc_dev_protocol_attrs,
> +};
> +
> +static struct attribute *rc_dev_wakeup_protocol_attrs[] =3D {
>  =09&dev_attr_wakeup_protocols.attr.attr,
> +=09NULL,
> +};
> +
> +static struct attribute_group rc_dev_wakeup_protocol_attr_grp =3D {
> +=09.attrs=09=3D rc_dev_wakeup_protocol_attrs,
> +};
> +
> +static struct attribute *rc_dev_filter_attrs[] =3D {
>  =09&dev_attr_filter.attr.attr,
>  =09&dev_attr_filter_mask.attr.attr,
> -=09&dev_attr_wakeup_filter.attr.attr,
> -=09&dev_attr_wakeup_filter_mask.attr.attr,
>  =09NULL,
>  };
>=20
> -static struct attribute_group rc_dev_attr_grp =3D {
> -=09.attrs=09=3D rc_dev_attrs,
> +static struct attribute_group rc_dev_filter_attr_grp =3D {
> +=09.attrs=09=3D rc_dev_filter_attrs,
>  };
>=20
> -static const struct attribute_group *rc_dev_attr_groups[] =3D {
> -=09&rc_dev_attr_grp,
> -=09NULL
> +static struct attribute *rc_dev_wakeup_filter_attrs[] =3D {
> +=09&dev_attr_wakeup_filter.attr.attr,
> +=09&dev_attr_wakeup_filter_mask.attr.attr,
> +=09NULL,
> +};
> +
> +static struct attribute_group rc_dev_wakeup_filter_attr_grp =3D {
> +=09.attrs=09=3D rc_dev_wakeup_filter_attrs,
>  };
>=20
>  static struct device_type rc_dev_type =3D {
> -=09.groups=09=09=3D rc_dev_attr_groups,
>  =09.release=09=3D rc_dev_release,
>  =09.uevent=09=09=3D rc_dev_uevent,
>  };
> @@ -1276,7 +1284,7 @@ int rc_register_device(struct rc_dev *dev)
>  =09static bool raw_init =3D false; /* raw decoders loaded? */
>  =09struct rc_map *rc_map;
>  =09const char *path;
> -=09int rc, devno;
> +=09int rc, devno, attr =3D 0;
>=20
>  =09if (!dev || !dev->map_name)
>  =09=09return -EINVAL;
> @@ -1304,6 +1312,16 @@ int rc_register_device(struct rc_dev *dev)
>  =09=09=09return -ENOMEM;
>  =09} while (test_and_set_bit(devno, ir_core_dev_number));
>=20
> +=09dev->dev.groups =3D dev->sysfs_groups;
> +=09dev->sysfs_groups[attr++] =3D &rc_dev_protocol_attr_grp;
> +=09if (dev->s_filter)
> +=09=09dev->sysfs_groups[attr++] =3D &rc_dev_filter_attr_grp;
> +=09if (dev->s_wakeup_filter)
> +=09=09dev->sysfs_groups[attr++] =3D &rc_dev_wakeup_filter_attr_grp;
> +=09if (dev->change_wakeup_protocol)
> +=09=09dev->sysfs_groups[attr++] =3D &rc_dev_wakeup_protocol_attr_grp=
;
> +=09dev->sysfs_groups[attr++] =3D NULL;
> +
>  =09/*
>  =09 * Take the lock here, as the device sysfs node will appear
>  =09 * when device_add() is called, which may trigger an ir-keytable =
udev
> diff --git a/include/media/rc-core.h b/include/media/rc-core.h
> index 6dbc7c1..fde142e 100644
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
> @@ -117,6 +118,7 @@ enum rc_filter_type {
>   */
>  struct rc_dev {
>  =09struct device=09=09=09dev;
> +=09const struct attribute_group=09*sysfs_groups[5];
>  =09const char=09=09=09*input_name;
>  =09const char=09=09=09*input_phys;
>  =09struct input_id=09=09=09input_id;
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media=
" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--nextPart3304532.d6mLlxoHJY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAABAgAGBQJTP0JhAAoJEKHZs+irPybflgoP/jbbHk4X5vpLHzrAjfs5XDuI
/MUpLiWVU1hZOsglEeGEKENKHhkyvTR7AYhNKCZT97M303SpSzeFMBATeWP+wBDK
i2ZQWlONW8uv0YPr9ZaHTpYKDa1dFI6xces3mKrrqIF5uYchYLMeJojC9VjBdF80
2BTU/F1LN7M6MGHoGhBbmWcBWcefUJ/gfWpHeUeQeQRM2SjSqxDkEP4RBAhE1TdG
lWF8Cezmtyl3rym/AwxsdUuF81Atkk5s/0QK+bhGCMJwcv0ESMopfIX67JwBO8qJ
cyPSYzSS1ZdkyNBBrP77eOQIufz4rRUODgT0KPZI0smcPFJQFRvScSb90NqPxpw5
OWmAH0LHOx910q7F9N4qDTfhbjBRg5ZwrkO98tE+DFarwpzjGBIavlf+reoXtPZa
2gfA6nc8O6GSpIasFV946Tsguc4pspUFCI1PGs9N0KHMkjfVfkMfWI14w2qmc5/B
dSmFHHEolWXXBHthDsaOQUFUkMBta6UzjC8dskSa9RGDm0c7OZt2aeQHmU9gBHH7
7A4Qg9pmj+fnIuBVkHbETLwyLLyEXCzpgfZt8en//qBcHRS5JtvEvS81bV49N0Un
5tLnG7LTfPIDcNxmgD7kq0DS2Nim/z39fLA9fbHq40EjWNw7TMGNuP+mkD5HrIQb
7yHLCr22sWBxRuwv/l6F
=+Lz0
-----END PGP SIGNATURE-----

--nextPart3304532.d6mLlxoHJY--

