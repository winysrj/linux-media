Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp3-g21.free.fr ([212.27.42.3]:36182 "EHLO smtp3-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753579Ab0CCIvD (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 3 Mar 2010 03:51:03 -0500
Date: Wed, 3 Mar 2010 09:51:23 +0100
From: Jean-Francois Moine <moinejf@free.fr>
To: linux-media@vger.kernel.org,
	Douglas Schilling Landgraf <dougsland@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [hg:v4l-dvb] gspca - main: Fix a compile error when
 CONFIG_INPUT is not set
Message-ID: <20100303095123.047a4d1e@tele>
In-Reply-To: <E1Nmblu-0007t3-Dm@www.linuxtv.org>
References: <E1Nmblu-0007t3-Dm@www.linuxtv.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="MP_/klHxhX_5w5tQG5zx6SoXK.f"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--MP_/klHxhX_5w5tQG5zx6SoXK.f
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Wed, 03 Mar 2010 00:45:02 +0100
Patch from Jean-Fran?ois Moine  <hg-commit@linuxtv.org> wrote:

> The patch number 14343 was added via Douglas Schilling Landgraf
> <dougsland@redhat.com> to http://linuxtv.org/hg/v4l-dvb master
> development tree.
>=20
> Kernel patches in this development tree may be modified to be backward
> compatible with older kernels. Compatibility modifications will be
> removed before inclusion into the mainstream Kernel
>=20
> If anyone has any objections, please let us know by sending a message
> to: Linux Media Mailing List <linux-media@vger.kernel.org>
>=20
> ------
>=20
> From: Jean-Fran?ois Moine  <moinejf@free.fr>
> gspca - main: Fix a compile error when CONFIG_INPUT is not set
>=20
>=20
> Reported-by: Randy Dunlap <randy.dunlap@oracle.com>
>=20
> Priority: normal
>=20
> [dougsland@redhat.com: patch backported to hg tree]
> Signed-off-by: Jean-Fran?ois Moine <moinejf@free.fr>
> Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
> Signed-off-by: Douglas Schilling Landgraf <dougsland@redhat.com>
>=20
>=20
> ---
>=20
>  linux/drivers/media/video/gspca/gspca.c |    6 ++++++
>  1 file changed, 6 insertions(+)
>=20
> diff -r c533329e3c41 -r 6519c63ecf6d
> linux/drivers/media/video/gspca/gspca.c ---
> a/linux/drivers/media/video/gspca/gspca.c	Tue Mar 02 20:16:17
> 2010 -0300 +++ b/linux/drivers/media/video/gspca/gspca.c	Tue
> Mar 02 20:38:01 2010 -0300 @@ -44,10 +44,12 @@=20
>  #include "gspca.h"
> =20
> +#ifdef CONFIG_INPUT
>  #if LINUX_VERSION_CODE >=3D KERNEL_VERSION(2, 6, 19)
>  #include <linux/input.h>
>  #include <linux/usb/input.h>
>  #endif
> +#endif
> =20
>  /* global values */
>  #define DEF_NURBS 3		/* default number of URBs */
> @@ -2371,9 +2373,11 @@
>  void gspca_disconnect(struct usb_interface *intf)
>  {
>  	struct gspca_dev *gspca_dev =3D usb_get_intfdata(intf);
> +#ifdef CONFIG_INPUT
>  #if LINUX_VERSION_CODE >=3D KERNEL_VERSION(2, 6, 19)
>  	struct input_dev *input_dev;
>  #endif
> +#endif
> =20
>  	PDEBUG(D_PROBE, "%s disconnect",
>  		video_device_node_name(&gspca_dev->vdev));
> @@ -2385,6 +2389,7 @@
>  		wake_up_interruptible(&gspca_dev->wq);
>  	}
> =20
> +#ifdef CONFIG_INPUT
>  #if LINUX_VERSION_CODE >=3D KERNEL_VERSION(2, 6, 19)
>  	gspca_input_destroy_urb(gspca_dev);
>  	input_dev =3D gspca_dev->input_dev;
> @@ -2393,6 +2398,7 @@
>  		input_unregister_device(input_dev);
>  	}
>  #endif
> +#endif
> =20
>  	/* the device is freed at exit of this function */
>  	gspca_dev->dev =3D NULL;
>=20
>=20
> ---
>=20
> Patch is available at:
> http://linuxtv.org/hg/v4l-dvb/rev/6519c63ecf6d4e7e2c1c3d46ac2a161da8d6c6f4

Hello Douglas,

I do not understand your patch. Do you mean that the input events
cannot be used with kernel < 2.6.19, while CONFIG_INPUT can be set?

Anyway, this patch seems complex. It would have been easier to simply
unset CONFIG_INPUT when kernel < 2.6.19.

I join the diff of gspca.c between v4l-dvb and my repository. This last
one is closer to the git version and there are still other changes done
in git. How do you think I should merge?

Cheers.

--=20
Ken ar c'henta=C3=B1	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/

--MP_/klHxhX_5w5tQG5zx6SoXK.f
Content-Type: application/octet-stream; name=gspca.dif
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename=gspca.dif

LS0tIC90bXAvZ3NwY2EuY35vdGhlci4wd1NTckQJMjAxMC0wMy0wMyAwOToxNzoyOS4wMDAwMDAw
MDAgKzAxMDAKKysrIGxpbnV4L2RyaXZlcnMvbWVkaWEvdmlkZW8vZ3NwY2EvZ3NwY2EuYwkyMDEw
LTAzLTAzIDA5OjE3OjI5LjAwMDAwMDAwMCArMDEwMApAQCAtNDUsMTEgKzQ1LDkgQEAKICNpbmNs
dWRlICJnc3BjYS5oIgogCiAjaWZkZWYgQ09ORklHX0lOUFVUCi0jaWYgTElOVVhfVkVSU0lPTl9D
T0RFID49IEtFUk5FTF9WRVJTSU9OKDIsIDYsIDE5KQogI2luY2x1ZGUgPGxpbnV4L2lucHV0Lmg+
CiAjaW5jbHVkZSA8bGludXgvdXNiL2lucHV0Lmg+CiAjZW5kaWYKLSNlbmRpZgogCiAvKiBnbG9i
YWwgdmFsdWVzICovCiAjZGVmaW5lIERFRl9OVVJCUyAzCQkvKiBkZWZhdWx0IG51bWJlciBvZiBV
UkJzICovCkBAIC0xMjYsOCArMTI0LDExIEBACiAgKiBJbnB1dCBhbmQgaW50ZXJydXB0IGVuZHBv
aW50IGhhbmRsaW5nIGZ1bmN0aW9ucwogICovCiAjaWZkZWYgQ09ORklHX0lOUFVUCi0jaWYgTElO
VVhfVkVSU0lPTl9DT0RFID49IEtFUk5FTF9WRVJTSU9OKDIsIDYsIDE5KQorI2lmIExJTlVYX1ZF
UlNJT05fQ09ERSA8IEtFUk5FTF9WRVJTSU9OKDIsIDYsIDE5KQorc3RhdGljIHZvaWQgaW50X2ly
cShzdHJ1Y3QgdXJiICp1cmIsIHN0cnVjdCBwdF9yZWdzICpyZWdzKQorI2Vsc2UKIHN0YXRpYyB2
b2lkIGludF9pcnEoc3RydWN0IHVyYiAqdXJiKQorI2VuZGlmCiB7CiAJc3RydWN0IGdzcGNhX2Rl
diAqZ3NwY2FfZGV2ID0gKHN0cnVjdCBnc3BjYV9kZXYgKikgdXJiLT5jb250ZXh0OwogCWludCBy
ZXQ7CkBAIC0zMDYsNyArMzA3LDYgQEAKICNkZWZpbmUgZ3NwY2FfaW5wdXRfY3JlYXRlX3VyYihn
c3BjYV9kZXYpCTAKICNkZWZpbmUgZ3NwY2FfaW5wdXRfZGVzdHJveV91cmIoZ3NwY2FfZGV2KQog
I2VuZGlmCi0jZW5kaWYKIAogLyogZ2V0IHRoZSBjdXJyZW50IGlucHV0IGZyYW1lIGJ1ZmZlciAq
Lwogc3RydWN0IGdzcGNhX2ZyYW1lICpnc3BjYV9nZXRfaV9mcmFtZShzdHJ1Y3QgZ3NwY2FfZGV2
ICpnc3BjYV9kZXYpCkBAIC02OTUsMjEgKzY5NSwxMyBAQAogCQkJaSwgZXAtPmRlc2MuYkVuZHBv
aW50QWRkcmVzcyk7CiAJZ3NwY2FfZGV2LT5hbHQgPSBpOwkJLyogbWVtb3JpemUgdGhlIGN1cnJl
bnQgYWx0IHNldHRpbmcgKi8KIAlpZiAoZ3NwY2FfZGV2LT5uYmFsdCA+IDEpIHsKLSNpZiBMSU5V
WF9WRVJTSU9OX0NPREUgPj0gS0VSTkVMX1ZFUlNJT04oMiwgNiwgMTkpCiAJCWdzcGNhX2lucHV0
X2Rlc3Ryb3lfdXJiKGdzcGNhX2Rldik7Ci0jZW5kaWYKIAkJcmV0ID0gdXNiX3NldF9pbnRlcmZh
Y2UoZ3NwY2FfZGV2LT5kZXYsIGdzcGNhX2Rldi0+aWZhY2UsIGkpOwogCQlpZiAocmV0IDwgMCkg
ewogCQkJZXJyKCJzZXQgYWx0ICVkIGVyciAlZCIsIGksIHJldCk7Ci0jaWYgTElOVVhfVkVSU0lP
Tl9DT0RFID49IEtFUk5FTF9WRVJTSU9OKDIsIDYsIDE5KQogCQkJZXAgPSBOVUxMOwotI2Vsc2UK
LQkJCXJldHVybiBOVUxMOwotI2VuZGlmCiAJCX0KLSNpZiBMSU5VWF9WRVJTSU9OX0NPREUgPj0g
S0VSTkVMX1ZFUlNJT04oMiwgNiwgMTkpCiAJCWdzcGNhX2lucHV0X2NyZWF0ZV91cmIoZ3NwY2Ff
ZGV2KTsKLSNlbmRpZgogCX0KIAlyZXR1cm4gZXA7CiB9CkBAIC05MjAsMTMgKzkxMiw5IEBACiAJ
CWlmIChnc3BjYV9kZXYtPnNkX2Rlc2MtPnN0b3BOKQogCQkJZ3NwY2FfZGV2LT5zZF9kZXNjLT5z
dG9wTihnc3BjYV9kZXYpOwogCQlkZXN0cm95X3VyYnMoZ3NwY2FfZGV2KTsKLSNpZiBMSU5VWF9W
RVJTSU9OX0NPREUgPj0gS0VSTkVMX1ZFUlNJT04oMiwgNiwgMTkpCiAJCWdzcGNhX2lucHV0X2Rl
c3Ryb3lfdXJiKGdzcGNhX2Rldik7Ci0jZW5kaWYKIAkJZ3NwY2Ffc2V0X2FsdDAoZ3NwY2FfZGV2
KTsKLSNpZiBMSU5VWF9WRVJTSU9OX0NPREUgPj0gS0VSTkVMX1ZFUlNJT04oMiwgNiwgMTkpCiAJ
CWdzcGNhX2lucHV0X2NyZWF0ZV91cmIoZ3NwY2FfZGV2KTsKLSNlbmRpZgogCX0KIAogCS8qIGFs
d2F5cyBjYWxsIHN0b3AwIHRvIGZyZWUgdGhlIHN1YmRyaXZlcidzIHJlc291cmNlcyAqLwpAQCAt
MjM1MCwxMSArMjMzOCw5IEBACiAJdXNiX3NldF9pbnRmZGF0YShpbnRmLCBnc3BjYV9kZXYpOwog
CVBERUJVRyhEX1BST0JFLCAiJXMgY3JlYXRlZCIsIHZpZGVvX2RldmljZV9ub2RlX25hbWUoJmdz
cGNhX2Rldi0+dmRldikpOwogCi0jaWYgTElOVVhfVkVSU0lPTl9DT0RFID49IEtFUk5FTF9WRVJT
SU9OKDIsIDYsIDE5KQogCXJldCA9IGdzcGNhX2lucHV0X2Nvbm5lY3QoZ3NwY2FfZGV2KTsKIAlp
ZiAocmV0ID09IDApCiAJCXJldCA9IGdzcGNhX2lucHV0X2NyZWF0ZV91cmIoZ3NwY2FfZGV2KTsK
LSNlbmRpZgogCiAJcmV0dXJuIDA7CiBvdXQ6CkBAIC0yMzc0LDEwICsyMzYwLDggQEAKIHsKIAlz
dHJ1Y3QgZ3NwY2FfZGV2ICpnc3BjYV9kZXYgPSB1c2JfZ2V0X2ludGZkYXRhKGludGYpOwogI2lm
ZGVmIENPTkZJR19JTlBVVAotI2lmIExJTlVYX1ZFUlNJT05fQ09ERSA+PSBLRVJORUxfVkVSU0lP
TigyLCA2LCAxOSkKIAlzdHJ1Y3QgaW5wdXRfZGV2ICppbnB1dF9kZXY7CiAjZW5kaWYKLSNlbmRp
ZgogCiAJUERFQlVHKERfUFJPQkUsICIlcyBkaXNjb25uZWN0IiwKIAkJdmlkZW9fZGV2aWNlX25v
ZGVfbmFtZSgmZ3NwY2FfZGV2LT52ZGV2KSk7CkBAIC0yMzkwLDcgKzIzNzQsNiBAQAogCX0KIAog
I2lmZGVmIENPTkZJR19JTlBVVAotI2lmIExJTlVYX1ZFUlNJT05fQ09ERSA+PSBLRVJORUxfVkVS
U0lPTigyLCA2LCAxOSkKIAlnc3BjYV9pbnB1dF9kZXN0cm95X3VyYihnc3BjYV9kZXYpOwogCWlu
cHV0X2RldiA9IGdzcGNhX2Rldi0+aW5wdXRfZGV2OwogCWlmIChpbnB1dF9kZXYpIHsKQEAgLTIz
OTgsNyArMjM4MSw2IEBACiAJCWlucHV0X3VucmVnaXN0ZXJfZGV2aWNlKGlucHV0X2Rldik7CiAJ
fQogI2VuZGlmCi0jZW5kaWYKIAogCS8qIHRoZSBkZXZpY2UgaXMgZnJlZWQgYXQgZXhpdCBvZiB0
aGlzIGZ1bmN0aW9uICovCiAJZ3NwY2FfZGV2LT5kZXYgPSBOVUxMOwpAQCAtMjQyNSw5ICsyNDA3
LDcgQEAKIAlpZiAoZ3NwY2FfZGV2LT5zZF9kZXNjLT5zdG9wTikKIAkJZ3NwY2FfZGV2LT5zZF9k
ZXNjLT5zdG9wTihnc3BjYV9kZXYpOwogCWRlc3Ryb3lfdXJicyhnc3BjYV9kZXYpOwotI2lmIExJ
TlVYX1ZFUlNJT05fQ09ERSA+PSBLRVJORUxfVkVSU0lPTigyLCA2LCAxOSkKIAlnc3BjYV9pbnB1
dF9kZXN0cm95X3VyYihnc3BjYV9kZXYpOwotI2VuZGlmCiAJZ3NwY2Ffc2V0X2FsdDAoZ3NwY2Ff
ZGV2KTsKIAlpZiAoZ3NwY2FfZGV2LT5zZF9kZXNjLT5zdG9wMCkKIAkJZ3NwY2FfZGV2LT5zZF9k
ZXNjLT5zdG9wMChnc3BjYV9kZXYpOwpAQCAtMjQ0MSw5ICsyNDIxLDcgQEAKIAogCWdzcGNhX2Rl
di0+ZnJvemVuID0gMDsKIAlnc3BjYV9kZXYtPnNkX2Rlc2MtPmluaXQoZ3NwY2FfZGV2KTsKLSNp
ZiBMSU5VWF9WRVJTSU9OX0NPREUgPj0gS0VSTkVMX1ZFUlNJT04oMiwgNiwgMTkpCiAJZ3NwY2Ff
aW5wdXRfY3JlYXRlX3VyYihnc3BjYV9kZXYpOwotI2VuZGlmCiAJaWYgKGdzcGNhX2Rldi0+c3Ry
ZWFtaW5nKQogCQlyZXR1cm4gZ3NwY2FfaW5pdF90cmFuc2Zlcihnc3BjYV9kZXYpOwogCXJldHVy
biAwOwo=

--MP_/klHxhX_5w5tQG5zx6SoXK.f--
