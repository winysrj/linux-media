Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f179.google.com ([74.125.82.179]:56696 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753612AbaDJV3M (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Apr 2014 17:29:12 -0400
Received: by mail-we0-f179.google.com with SMTP id x48so4619271wes.10
        for <linux-media@vger.kernel.org>; Thu, 10 Apr 2014 14:29:11 -0700 (PDT)
From: James Hogan <james@albanarts.com>
To: David =?ISO-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>
Cc: linux-media@vger.kernel.org, m.chehab@samsung.com
Subject: Re: [PATCH 41/49] rc-core: rename mutex
Date: Thu, 10 Apr 2014 22:28:56 +0100
Message-ID: <1659184.sbKmMp9I49@radagast>
In-Reply-To: <20140403233443.27099.29952.stgit@zeus.muc.hardeman.nu>
References: <20140403232420.27099.94872.stgit@zeus.muc.hardeman.nu> <20140403233443.27099.29952.stgit@zeus.muc.hardeman.nu>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart6326219.tcyXepKzMc"; micalg="pgp-sha1"; protocol="application/pgp-signature"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--nextPart6326219.tcyXepKzMc
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"

On Friday 04 April 2014 01:34:43 David H=E4rdeman wrote:
> Having a mutex named "lock" is a bit misleading.

Why? A mutex is a type of lock so what's the problem?

A little grep'ing and sed'ing reveals that out of the 1578 unique mutex=
 names=20
in the kernel source I have to hand, 540 contain "lock", and 921 contai=
n=20
"mutex".

Cheers
James

>=20
> Signed-off-by: David H=E4rdeman <david@hardeman.nu>
> ---
>  drivers/media/rc/img-ir/img-ir-hw.c |    4 ++-
>  drivers/media/rc/rc-main.c          |   42
> ++++++++++++++++++----------------- include/media/rc-core.h          =
   | =20
>  5 ++--
>  3 files changed, 25 insertions(+), 26 deletions(-)
>=20
> diff --git a/drivers/media/rc/img-ir/img-ir-hw.c
> b/drivers/media/rc/img-ir/img-ir-hw.c index 5bc7903..a9abbb4 100644
> --- a/drivers/media/rc/img-ir/img-ir-hw.c
> +++ b/drivers/media/rc/img-ir/img-ir-hw.c
> @@ -666,11 +666,11 @@ static void img_ir_set_protocol(struct img_ir_p=
riv
> *priv, u64 proto) {
>  =09struct rc_dev *rdev =3D priv->hw.rdev;
>=20
> -=09mutex_lock(&rdev->lock);
> +=09mutex_lock(&rdev->mutex);
>  =09rdev->enabled_protocols =3D proto;
>  =09rdev->allowed_wakeup_protocols =3D proto;
>  =09rdev->enabled_wakeup_protocols =3D proto;
> -=09mutex_unlock(&rdev->lock);
> +=09mutex_unlock(&rdev->mutex);
>  }
>=20
>  /* Set up IR decoders */
> diff --git a/drivers/media/rc/rc-main.c b/drivers/media/rc/rc-main.c
> index 7caca4f..bd4dfab 100644
> --- a/drivers/media/rc/rc-main.c
> +++ b/drivers/media/rc/rc-main.c
> @@ -109,7 +109,7 @@ int rc_open(struct rc_dev *dev)
>  {
>  =09int err =3D 0;
>=20
> -=09mutex_lock(&dev->lock);
> +=09mutex_lock(&dev->mutex);
>=20
>  =09if (dev->dead)
>  =09=09err =3D -ENODEV;
> @@ -119,7 +119,7 @@ int rc_open(struct rc_dev *dev)
>  =09=09=09dev->users--;
>  =09}
>=20
> -=09mutex_unlock(&dev->lock);
> +=09mutex_unlock(&dev->mutex);
>=20
>  =09return err;
>  }
> @@ -127,12 +127,12 @@ EXPORT_SYMBOL_GPL(rc_open);
>=20
>  void rc_close(struct rc_dev *dev)
>  {
> -=09mutex_lock(&dev->lock);
> +=09mutex_lock(&dev->mutex);
>=20
>  =09if (!dev->dead && !--dev->users && dev->close)
>  =09=09dev->close(dev);
>=20
> -=09mutex_unlock(&dev->lock);
> +=09mutex_unlock(&dev->mutex);
>  }
>  EXPORT_SYMBOL_GPL(rc_close);
>=20
> @@ -322,7 +322,7 @@ struct rc_filter_attribute {
>   * It returns the protocol names of supported protocols.
>   * Enabled protocols are printed in brackets.
>   *
> - * dev->lock is taken to guard against races between store_protocols=
 and
> + * dev->mutex is taken to guard against races between store_protocol=
s and
>   * show_protocols.
>   */
>  static ssize_t show_protocols(struct device *device,
> @@ -339,7 +339,7 @@ static ssize_t show_protocols(struct device *devi=
ce,
>  =09=09return -EINVAL;
>=20
>  =09rc_event(dev, RC_KEY, RC_KEY_REPEAT, 1);
> -=09mutex_lock(&dev->lock);
> +=09mutex_lock(&dev->mutex);
>=20
>  =09if (fattr->type =3D=3D RC_FILTER_NORMAL) {
>  =09=09enabled =3D dev->enabled_protocols;
> @@ -349,7 +349,7 @@ static ssize_t show_protocols(struct device *devi=
ce,
>  =09=09allowed =3D dev->allowed_wakeup_protocols;
>  =09}
>=20
> -=09mutex_unlock(&dev->lock);
> +=09mutex_unlock(&dev->mutex);
>=20
>  =09IR_dprintk(1, "%s: allowed - 0x%llx, enabled - 0x%llx\n",
>  =09=09   __func__, (long long)allowed, (long long)enabled);
> @@ -449,7 +449,7 @@ static int parse_protocol_change(u64 *protocols, =
const
> char *buf) * See parse_protocol_change() for the valid commands.
>   * Returns @len on success or a negative error code.
>   *
> - * dev->lock is taken to guard against races between store_protocols=
 and
> + * dev->mutex is taken to guard against races between store_protocol=
s and
>   * show_protocols.
>   */
>  static ssize_t store_protocols(struct device *device,
> @@ -488,7 +488,7 @@ static ssize_t store_protocols(struct device *dev=
ice,
>  =09=09return -EINVAL;
>  =09}
>=20
> -=09mutex_lock(&dev->lock);
> +=09mutex_lock(&dev->mutex);
>=20
>  =09old_protocols =3D *current_protocols;
>  =09new_protocols =3D old_protocols;
> @@ -532,7 +532,7 @@ static ssize_t store_protocols(struct device *dev=
ice,
>  =09rc =3D len;
>=20
>  out:
> -=09mutex_unlock(&dev->lock);
> +=09mutex_unlock(&dev->mutex);
>  =09return rc;
>  }
>=20
> @@ -550,7 +550,7 @@ out:
>   * Bits of the filter value corresponding to set bits in the filter =
mask
> are * compared against input scancodes and non-matching scancodes are=

> discarded. *
> - * dev->lock is taken to guard against races between store_filter an=
d
> + * dev->mutex is taken to guard against races between store_filter a=
nd
>   * show_filter.
>   */
>  static ssize_t show_filter(struct device *device,
> @@ -571,12 +571,12 @@ static ssize_t show_filter(struct device *devic=
e,
>  =09else
>  =09=09filter =3D &dev->scancode_wakeup_filter;
>=20
> -=09mutex_lock(&dev->lock);
> +=09mutex_lock(&dev->mutex);
>  =09if (fattr->mask)
>  =09=09val =3D filter->mask;
>  =09else
>  =09=09val =3D filter->data;
> -=09mutex_unlock(&dev->lock);
> +=09mutex_unlock(&dev->mutex);
>=20
>  =09return sprintf(buf, "%#x\n", val);
>  }
> @@ -597,7 +597,7 @@ static ssize_t show_filter(struct device *device,=

>   * Bits of the filter value corresponding to set bits in the filter =
mask
> are * compared against input scancodes and non-matching scancodes are=

> discarded. *
> - * dev->lock is taken to guard against races between store_filter an=
d
> + * dev->mutex is taken to guard against races between store_filter a=
nd
>   * show_filter.
>   */
>  static ssize_t store_filter(struct device *device,
> @@ -633,7 +633,7 @@ static ssize_t store_filter(struct device *device=
,
>  =09if (!set_filter)
>  =09=09return -EINVAL;
>=20
> -=09mutex_lock(&dev->lock);
> +=09mutex_lock(&dev->mutex);
>=20
>  =09new_filter =3D *filter;
>  =09if (fattr->mask)
> @@ -654,7 +654,7 @@ static ssize_t store_filter(struct device *device=
,
>  =09*filter =3D new_filter;
>=20
>  unlock:
> -=09mutex_unlock(&dev->lock);
> +=09mutex_unlock(&dev->mutex);
>  =09return (ret < 0) ? ret : len;
>  }
>=20
> @@ -1087,7 +1087,7 @@ static long rc_ioctl(struct file *file, unsigne=
d int
> cmd, unsigned long arg) struct rc_dev *dev =3D client->dev;
>  =09int ret;
>=20
> -=09ret =3D mutex_lock_interruptible(&dev->lock);
> +=09ret =3D mutex_lock_interruptible(&dev->mutex);
>  =09if (ret)
>  =09=09return ret;
>=20
> @@ -1099,7 +1099,7 @@ static long rc_ioctl(struct file *file, unsigne=
d int
> cmd, unsigned long arg) ret =3D rc_do_ioctl(dev, cmd, arg);
>=20
>  out:
> -=09mutex_unlock(&dev->lock);
> +=09mutex_unlock(&dev->mutex);
>  =09return ret;
>  }
>=20
> @@ -1226,7 +1226,7 @@ struct rc_dev *rc_allocate_device(void)
>  =09mutex_init(&dev->txmutex);
>  =09init_waitqueue_head(&dev->txwait);
>  =09init_waitqueue_head(&dev->rxwait);
> -=09mutex_init(&dev->lock);
> +=09mutex_init(&dev->mutex);
>=20
>  =09dev->dev.type =3D &rc_dev_type;
>  =09dev->dev.class =3D &rc_class;
> @@ -1339,9 +1339,9 @@ void rc_unregister_device(struct rc_dev *dev)
>  =09if (!dev)
>  =09=09return;
>=20
> -=09mutex_lock(&dev->lock);
> +=09mutex_lock(&dev->mutex);
>  =09dev->dead =3D true;
> -=09mutex_unlock(&dev->lock);
> +=09mutex_unlock(&dev->mutex);
>=20
>  =09spin_lock(&dev->client_lock);
>  =09list_for_each_entry(client, &dev->client_list, node)
> diff --git a/include/media/rc-core.h b/include/media/rc-core.h
> index 25c1d38..a310e5b 100644
> --- a/include/media/rc-core.h
> +++ b/include/media/rc-core.h
> @@ -268,8 +268,7 @@ enum rc_filter_type {
>   * @driver_name: name of the hardware driver which registered this d=
evice
>   * @map_name: name of the default keymap
>   * @rc_kt: current rc_keytable
> - * @lock: used to ensure we've filled in all protocol details before=

> - *=09anyone can call show_protocols or store_protocols
> + * @mutex: used where a more specific lock/mutex/etc is not availabl=
e
>   * @dead: used to determine if the device is still alive
>   * @client_list: list of clients (processes which have opened the rc=

> chardev) * @client_lock: protects client_list
> @@ -334,7 +333,7 @@ struct rc_dev {
>  =09const char=09=09=09*map_name;
>  =09struct rc_keytable=09=09*keytables[RC_MAX_KEYTABLES];
>  =09struct list_head=09=09keytable_list;
> -=09struct mutex=09=09=09lock;
> +=09struct mutex=09=09=09mutex;
>  =09bool=09=09=09=09dead;
>  =09struct list_head=09=09client_list;
>  =09spinlock_t=09=09=09client_lock;
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media=
" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--nextPart6326219.tcyXepKzMc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAABAgAGBQJTRw0jAAoJEGwLaZPeOHZ6IngQAIZ6Sj7lHoS/4gZDFE3V6oIm
F8LACWaqTfEBd4suEZjin9iL/0fWs8GVklmb9DC7wLohhbfZXNFtDPLJkWUdqXtS
3KMWfQEb+42uEN8otGD6blfGYLNj23YeHOUKTytdcOX9j1srrHb/fkzxcEqB4EPN
glEw8kqVvNmttl4R5HQ0Yl/doEkNJjZALlctKw3NymoB3xxQrho2fyzLsyEJh94v
BPCXAU0KRVh45GML++V1oyuDBDigE9Cvsn0l/7YF/kp9WiEfmeWDPCpQdGGpNzTy
1JTHDZR0ysYSZchNwzGG2UmgGWXI/Bc8JsGVNmcAac3NpjHgfSBjUk8xbrPvaMcH
1jv5tZn2hB9ZCZXZVnIAzZAs/oPm7WPxdV5e7HDldizQJFbM1Mfp6vJxlNntJFCg
R+R1E+7ZmEhFHjFfEGO7ro71iqrUk95IO1CSDsMiX3F4j3VHZAXyB3jWyEso9/Ek
hxUxay+3ro22hYCT59VbeIwGfHcHx0CbUi0mH53GsEAuKZalmlowCfLHpf+hUFAz
fScyH9FBAJIFJPHDjmLmmsye5Eh6snjhKfbdcIRE+ZITG2XiOB3CqACkt6mB7xtP
baSN70HA2VxgmTdVtfZQdcYfmhG4x+UgTsBUossfVVvjBkoEdt8OduqwC5NGnCh3
jSDHSmWNumeLnvq7eh8g
=mNTL
-----END PGP SIGNATURE-----

--nextPart6326219.tcyXepKzMc--

