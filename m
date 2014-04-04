Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f172.google.com ([74.125.82.172]:64240 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751552AbaDDXgR (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 4 Apr 2014 19:36:17 -0400
Received: by mail-we0-f172.google.com with SMTP id t61so4195074wes.3
        for <linux-media@vger.kernel.org>; Fri, 04 Apr 2014 16:36:16 -0700 (PDT)
From: James Hogan <james.hogan@imgtec.com>
To: David =?ISO-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>
Cc: linux-media@vger.kernel.org, m.chehab@samsung.com
Subject: Re: [PATCH 2/3] rc-core: split dev->s_filter
Date: Sat, 05 Apr 2014 00:36:05 +0100
Message-ID: <1617377.UdHfJ54rRo@radagast>
In-Reply-To: <20140404220601.5068.52062.stgit@zeus.muc.hardeman.nu>
References: <20140404220404.5068.3669.stgit@zeus.muc.hardeman.nu> <20140404220601.5068.52062.stgit@zeus.muc.hardeman.nu>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart2158079.4sJBjkCaIu"; micalg="pgp-sha1"; protocol="application/pgp-signature"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--nextPart2158079.4sJBjkCaIu
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"

On Saturday 05 April 2014 00:06:01 David H=E4rdeman wrote:
> Overloading dev->s_filter to do two different functions (set wakeup f=
ilters
> and generic hardware filters) makes it impossible to tell what the
> hardware actually supports, so create a separate dev->s_wakeup_filter=
 and
> make the distinction explicit.
>=20
> v2: hopefully address James' comments on what should be moved from th=
is to
> the next patch.
>=20
> Signed-off-by: David H=E4rdeman <david@hardeman.nu>

Acked-by: James Hogan <james.hogan@imgtec.com>

Thanks
James

> ---
>  drivers/media/rc/img-ir/img-ir-hw.c |   15 ++++++++++++++-
>  drivers/media/rc/rc-main.c          |   24 +++++++++++++++++-------
>  include/media/rc-core.h             |    6 ++++--
>  3 files changed, 35 insertions(+), 10 deletions(-)
>=20
> diff --git a/drivers/media/rc/img-ir/img-ir-hw.c
> b/drivers/media/rc/img-ir/img-ir-hw.c index 579a52b..0127dd2 100644
> --- a/drivers/media/rc/img-ir/img-ir-hw.c
> +++ b/drivers/media/rc/img-ir/img-ir-hw.c
> @@ -504,6 +504,18 @@ unlock:
>  =09return ret;
>  }
>=20
> +static int img_ir_set_normal_filter(struct rc_dev *dev,
> +=09=09=09=09    struct rc_scancode_filter *sc_filter)
> +{
> +=09return img_ir_set_filter(dev, RC_FILTER_NORMAL, sc_filter);
> +}
> +
> +static int img_ir_set_wakeup_filter(struct rc_dev *dev,
> +=09=09=09=09    struct rc_scancode_filter *sc_filter)
> +{
> +=09return img_ir_set_filter(dev, RC_FILTER_WAKEUP, sc_filter);
> +}
> +
>  /**
>   * img_ir_set_decoder() - Set the current decoder.
>   * @priv:=09IR private data.
> @@ -986,7 +998,8 @@ int img_ir_probe_hw(struct img_ir_priv *priv)
>  =09rdev->map_name =3D RC_MAP_EMPTY;
>  =09rc_set_allowed_protocols(rdev, img_ir_allowed_protos(priv));
>  =09rdev->input_name =3D "IMG Infrared Decoder";
> -=09rdev->s_filter =3D img_ir_set_filter;
> +=09rdev->s_filter =3D img_ir_set_normal_filter;
> +=09rdev->s_wakeup_filter =3D img_ir_set_wakeup_filter;
>=20
>  =09/* Register hardware decoder */
>  =09error =3D rc_register_device(rdev);
> diff --git a/drivers/media/rc/rc-main.c b/drivers/media/rc/rc-main.c
> index 99697aa..ecbc20c 100644
> --- a/drivers/media/rc/rc-main.c
> +++ b/drivers/media/rc/rc-main.c
> @@ -923,6 +923,7 @@ static ssize_t store_protocols(struct device *dev=
ice,
>  =09int rc, i, count =3D 0;
>  =09ssize_t ret;
>  =09int (*change_protocol)(struct rc_dev *dev, u64 *rc_type);
> +=09int (*set_filter)(struct rc_dev *dev, struct rc_scancode_filter *=
filter);
>  =09struct rc_scancode_filter local_filter, *filter;
>=20
>  =09/* Device is being removed */
> @@ -1007,24 +1008,27 @@ static ssize_t store_protocols(struct device
> *device, * Fall back to clearing the filter.
>  =09 */
>  =09filter =3D &dev->scancode_filters[fattr->type];
> +=09set_filter =3D (fattr->type =3D=3D RC_FILTER_NORMAL)
> +=09=09? dev->s_filter : dev->s_wakeup_filter;
> +
>  =09if (old_type !=3D type && filter->mask) {
>  =09=09local_filter =3D *filter;
>  =09=09if (!type) {
>  =09=09=09/* no protocol =3D> clear filter */
>  =09=09=09ret =3D -1;
> -=09=09} else if (!dev->s_filter) {
> +=09=09} else if (!set_filter) {
>  =09=09=09/* generic filtering =3D> accept any filter */
>  =09=09=09ret =3D 0;
>  =09=09} else {
>  =09=09=09/* hardware filtering =3D> try setting, otherwise clear */
> -=09=09=09ret =3D dev->s_filter(dev, fattr->type, &local_filter);
> +=09=09=09ret =3D set_filter(dev, &local_filter);
>  =09=09}
>  =09=09if (ret < 0) {
>  =09=09=09/* clear the filter */
>  =09=09=09local_filter.data =3D 0;
>  =09=09=09local_filter.mask =3D 0;
> -=09=09=09if (dev->s_filter)
> -=09=09=09=09dev->s_filter(dev, fattr->type, &local_filter);
> +=09=09=09if (set_filter)
> +=09=09=09=09set_filter(dev, &local_filter);
>  =09=09}
>=20
>  =09=09/* commit the new filter */
> @@ -1106,6 +1110,7 @@ static ssize_t store_filter(struct device *devi=
ce,
>  =09struct rc_scancode_filter local_filter, *filter;
>  =09int ret;
>  =09unsigned long val;
> +=09int (*set_filter)(struct rc_dev *dev, struct rc_scancode_filter *=
filter);
>=20
>  =09/* Device is being removed */
>  =09if (!dev)
> @@ -1115,8 +1120,11 @@ static ssize_t store_filter(struct device *dev=
ice,
>  =09if (ret < 0)
>  =09=09return ret;
>=20
> +=09set_filter =3D (fattr->type =3D=3D RC_FILTER_NORMAL) ? dev->s_fil=
ter :
> +=09=09=09=09=09=09=09 dev->s_wakeup_filter;
> +
>  =09/* Scancode filter not supported (but still accept 0) */
> -=09if (!dev->s_filter && fattr->type !=3D RC_FILTER_NORMAL)
> +=09if (!set_filter && fattr->type =3D=3D RC_FILTER_WAKEUP)
>  =09=09return val ? -EINVAL : count;
>=20
>  =09mutex_lock(&dev->lock);
> @@ -1128,13 +1136,15 @@ static ssize_t store_filter(struct device *de=
vice,
>  =09=09local_filter.mask =3D val;
>  =09else
>  =09=09local_filter.data =3D val;
> +
>  =09if (!dev->enabled_protocols[fattr->type] && local_filter.mask) {
>  =09=09/* refuse to set a filter unless a protocol is enabled */
>  =09=09ret =3D -EINVAL;
>  =09=09goto unlock;
>  =09}
> -=09if (dev->s_filter) {
> -=09=09ret =3D dev->s_filter(dev, fattr->type, &local_filter);
> +
> +=09if (set_filter) {
> +=09=09ret =3D set_filter(dev, &local_filter);
>  =09=09if (ret < 0)
>  =09=09=09goto unlock;
>  =09}
> diff --git a/include/media/rc-core.h b/include/media/rc-core.h
> index 0b9f890..6dbc7c1 100644
> --- a/include/media/rc-core.h
> +++ b/include/media/rc-core.h
> @@ -112,7 +112,8 @@ enum rc_filter_type {
>   *=09device doesn't interrupt host until it sees IR pulses
>   * @s_learning_mode: enable wide band receiver used for learning
>   * @s_carrier_report: enable carrier reports
> - * @s_filter: set the scancode filter of a given type
> + * @s_filter: set the scancode filter
> + * @s_wakeup_filter: set the wakeup scancode filter
>   */
>  struct rc_dev {
>  =09struct device=09=09=09dev;
> @@ -159,8 +160,9 @@ struct rc_dev {
>  =09int=09=09=09=09(*s_learning_mode)(struct rc_dev *dev, int enable)=
;
>  =09int=09=09=09=09(*s_carrier_report) (struct rc_dev *dev, int enabl=
e);
>  =09int=09=09=09=09(*s_filter)(struct rc_dev *dev,
> -=09=09=09=09=09=09    enum rc_filter_type type,
>  =09=09=09=09=09=09    struct rc_scancode_filter *filter);
> +=09int=09=09=09=09(*s_wakeup_filter)(struct rc_dev *dev,
> +=09=09=09=09=09=09=09   struct rc_scancode_filter *filter);
>  };
>=20
>  #define to_rc_dev(d) container_of(d, struct rc_dev, dev)
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media=
" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--nextPart2158079.4sJBjkCaIu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAABAgAGBQJTP0HsAAoJEKHZs+irPybfbVoP/ig2VLuKu4TzCL31wMA/ql0W
XhJgq7DXjugHWz6MDbvRhh9jMbwXVCRGuoFUPA312+0sdJCSdQZ0S1pY4JxMj/0X
Rv5/q3/Icvh5Mq3BHzBBjhFswBkBQmMF1wkwhJHUPb8QbolAUDBBs2LJ0o3eQscx
rmp2slzx4DZqQZ0JRccX/gzrDbpZ93MKyOmhcxt6Y8Q0lkUtQ1ddjmNdUsfw8cB4
q0nxPAeqTwANOKCJ3XZ3XDMMXbo7PmptimUVS5JMk7GoegqFW4QL/YKkV9Kv6Mf4
f6ZW7BYDwfx5XS4mWHUQNB5+7lBN15rn3oDpTJX2s38JCQMtK+mZebD3PC+44Lrf
HF7V1gAuuk7cXKe4vvQ1dIedlFT9z5RNX1/BPwcLB4RCEd8E/Qg4sUs5/WcGomBS
iIukWgCPOaDBe4cB1iknLHzzFvZBOXX6t2ZOXe38UUlqIjzle+4I4GtszaI1XPfq
0QGZaZgkYnfSK6bgoOWK2yfOb33jPlxUXZ3oq1YS5w82IyRRYPRRw7gEH/713Db5
xS/XnkMF9lVOAJIcoVwCu+2KSckG/EAuGiC2EJWfyo5Ce8MiyNUc+ilzZvk/bTUU
La0asEb+V73rYlwzivUcB2TW/V0Hef5s0OJKU1udbpfAy9Zc3Wjv/TkMSvtYH5UI
bgOZChj2Wr8mUHEITR1Y
=hnRQ
-----END PGP SIGNATURE-----

--nextPart2158079.4sJBjkCaIu--

