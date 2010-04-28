Return-path: <linux-media-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:37075 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752981Ab0D1GRN (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 28 Apr 2010 02:17:13 -0400
From: "Hiremath, Vaibhav" <hvaibhav@ti.com>
To: "Aguirre, Sergio" <saaguirre@ti.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
CC: "mchehab@redhat.com" <mchehab@redhat.com>,
	"Karicheri, Muralidharan" <m-karicheri2@ti.com>,
	"hverkuil@xs4all.nl" <hverkuil@xs4all.nl>
Date: Wed, 28 Apr 2010 11:46:52 +0530
Subject: RE: [PATCH-V7] OMAP2/3 V4L2: Add support for OMAP2/3 V4L2 driver on
 top of DSS2
Message-ID: <19F8576C6E063C45BE387C64729E7394044E2A59ED@dbde02.ent.ti.com>
References: <hvaibhav@ti.com>
 <1270634430-5549-2-git-send-email-hvaibhav@ti.com>
 <A24693684029E5489D1D202277BE894454F77EAB@dlee02.ent.ti.com>
In-Reply-To: <A24693684029E5489D1D202277BE894454F77EAB@dlee02.ent.ti.com>
Content-Language: en-US
Content-Type: multipart/mixed;
	boundary="_002_19F8576C6E063C45BE387C64729E7394044E2A59EDdbde02enttico_"
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--_002_19F8576C6E063C45BE387C64729E7394044E2A59EDdbde02enttico_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

> -----Original Message-----
> From: Aguirre, Sergio
> Sent: Wednesday, April 28, 2010 12:27 AM
> To: Hiremath, Vaibhav; linux-media@vger.kernel.org
> Cc: mchehab@redhat.com; Karicheri, Muralidharan; hverkuil@xs4all.nl
> Subject: RE: [PATCH-V7] OMAP2/3 V4L2: Add support for OMAP2/3 V4L2 driver=
 on
> top of DSS2
>=20
> Vaibhav,
>=20
> > -----Original Message-----
> > From: linux-media-owner@vger.kernel.org [mailto:linux-media-
> > owner@vger.kernel.org] On Behalf Of Hiremath, Vaibhav
> > Sent: Wednesday, April 07, 2010 5:01 AM
> > To: linux-media@vger.kernel.org
> > Cc: mchehab@redhat.com; Karicheri, Muralidharan; hverkuil@xs4all.nl;
> > Hiremath, Vaibhav
> > Subject: [PATCH-V7] OMAP2/3 V4L2: Add support for OMAP2/3 V4L2 driver o=
n
> > top of DSS2
> >
> > From: Vaibhav Hiremath <hvaibhav@ti.com>
> >
> > Features Supported -
> > 	1. Provides V4L2 user interface for the video pipelines of DSS
> > 	2. Basic streaming working on LCD, DVI and TV.
> > 	3. Works on latest DSS2 library from Tomi
> > 	4. Support for various pixel formats like YUV, UYVY, RGB32, RGB24,
> > 	   RGB565
> > 	5. Supports Alpha blending.
> > 	6. Supports Color keying both source and destination.
> > 	7. Supports rotation.
> > 	8. Supports cropping.
> > 	9. Supports Background color setting.
> > 	10. Allocated buffers to only needed size
> >
>=20
> This patch is broken in latest kernel. There are 2 main problems:
[Hiremath, Vaibhav] Sergio,

I do have patch fixing this issue and waiting V4L2 master to get updated fi=
rst. I have attached patch here.

The very first thing is this patch has been created against latest V4L2/mas=
ter branch and not linux-omap branch. So there could be some gap between th=
e merges of 2 branches.

Also on regular basis (almost daily) I am making sure that all the patches =
which are submitted to the list are still get applied cleanly and works, ob=
viously against their respective repositories.

Thanks,
Vaibhav
>=20
> 1. ARCH_OMAP24XX and ARCH_OMAP34XX doesn't exist anymore in latest kernel=
.
>=20
> Tony has left only ARCH_OMAP2420, ARCH_OMAP2430 and ARCH_OMAP3430. So, I =
did
> the change represented in patch #0001.
>=20
> 2. It doesn't compile.
>=20
> See attached log.
>=20
> I was able to partially fix some problems:
>=20
> drivers/media/video/omap/omap_vout.c: In function 'vidioc_reqbufs':
> drivers/media/video/omap/omap_vout.c:1841: error: implicit declaration of
> function 'kfree'
> drivers/media/video/omap/omap_vout.c: In function
> 'omap_vout_create_video_devices':
> drivers/media/video/omap/omap_vout.c:2375: error: implicit declaration of
> function 'kmalloc'
> ...
> drivers/media/video/omap/omap_vout.c: In function 'omap_vout_probe':
> drivers/media/video/omap/omap_vout.c:2514: error: implicit declaration of
> function 'kzalloc'
> drivers/media/video/omap/omap_vout.c:2514: warning: assignment makes poin=
ter
> from integer without a cast
>=20
> With the attached patch #0002. But still the other problems are related t=
o
> latest DSS2 framework changes.
>=20
> Can you please take a look at those?
>=20
> Regards,
> Sergio
>=20
> > Signed-off-by: Vaibhav Hiremath <hvaibhav@ti.com>
> > ---
> >  drivers/media/video/Kconfig             |    2 +
> >  drivers/media/video/Makefile            |    2 +
> >  drivers/media/video/omap/Kconfig        |   11 +
> >  drivers/media/video/omap/Makefile       |    7 +
> >  drivers/media/video/omap/omap_vout.c    | 2644
> > +++++++++++++++++++++++++++++++
> >  drivers/media/video/omap/omap_voutdef.h |  147 ++
> >  drivers/media/video/omap/omap_voutlib.c |  293 ++++
> >  drivers/media/video/omap/omap_voutlib.h |   34 +
> >  8 files changed, 3140 insertions(+), 0 deletions(-)
> >  create mode 100644 drivers/media/video/omap/Kconfig
> >  create mode 100644 drivers/media/video/omap/Makefile
> >  create mode 100644 drivers/media/video/omap/omap_vout.c
> >  create mode 100644 drivers/media/video/omap/omap_voutdef.h
> >  create mode 100644 drivers/media/video/omap/omap_voutlib.c
> >  create mode 100644 drivers/media/video/omap/omap_voutlib.h
> >
>=20
> <snip>

--_002_19F8576C6E063C45BE387C64729E7394044E2A59EDdbde02enttico_
Content-Type: application/octet-stream;
	name="0001-OMAP-V4L2-Display-Rebased-against-latest-DSS2-chang.patch"
Content-Description: 0001-OMAP-V4L2-Display-Rebased-against-latest-DSS2-chang.patch
Content-Disposition: attachment;
	filename="0001-OMAP-V4L2-Display-Rebased-against-latest-DSS2-chang.patch";
	size=4111; creation-date="Wed, 28 Apr 2010 11:44:11 GMT";
	modification-date="Wed, 28 Apr 2010 11:44:11 GMT"
Content-Transfer-Encoding: base64

RnJvbSA2MmUwZjVkMWVmZDgxMjgwZjU4OTZjMWMxOGVkNzE5NzMzYWNhNDFmIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBWYWliaGF2IEhpcmVtYXRoIDxodmFpYmhhdkB0aS5jb20+CkRh
dGU6IFdlZCwgMjggQXByIDIwMTAgMTE6NDE6NDggKzA1MzAKU3ViamVjdDogW1BBVENIXSBPTUFQ
OlY0TDIgRGlzcGxheTogUmViYXNlZCBhZ2FpbnN0IGxhdGVzdCBEU1MyIGNoYW5nZXMKCkNoYW5n
ZXMgLQoJLSBLY29uZmlnIG9wdGlvbiBkZXBlbmRhbmN5IGNoYW5nZWQgdG8gQVJDSF9PTUFQMi8z
IGZyb20KCUFSQ0hfT01BUDI0WFgvMzRYWAoJLSBUaGVyZSBhcmUgc29tZSBtb21lbnRzIG9mIGZ1
bmN0aW9uIGZyb20gb21hcF9kc3NfZGV2aWNlCgl0byBvbWFwX2Rzc19kcml2ZXIuIEluY29ycG9y
YXRlZCBjaGFuZ2VzIGZvciB0aGUgc2FtZS4KClNpZ25lZC1vZmYtYnk6IFZhaWJoYXYgSGlyZW1h
dGggPGh2YWliaGF2QHRpLmNvbT4KLS0tCiBkcml2ZXJzL21lZGlhL3ZpZGVvL29tYXAvS2NvbmZp
ZyAgICAgfCAgICAyICstCiBkcml2ZXJzL21lZGlhL3ZpZGVvL29tYXAvb21hcF92b3V0LmMgfCAg
IDM1ICsrKysrKysrKysrKysrKysrKy0tLS0tLS0tLS0tLS0tLQogMiBmaWxlcyBjaGFuZ2VkLCAy
MCBpbnNlcnRpb25zKCspLCAxNyBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9kcml2ZXJzL21l
ZGlhL3ZpZGVvL29tYXAvS2NvbmZpZyBiL2RyaXZlcnMvbWVkaWEvdmlkZW8vb21hcC9LY29uZmln
CmluZGV4IDk3YzUzOTQuLmMxZDE5MzMgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvbWVkaWEvdmlkZW8v
b21hcC9LY29uZmlnCisrKyBiL2RyaXZlcnMvbWVkaWEvdmlkZW8vb21hcC9LY29uZmlnCkBAIC0x
LDYgKzEsNiBAQAogY29uZmlnIFZJREVPX09NQVAyX1ZPVVQKIAl0cmlzdGF0ZSAiT01BUDIvT01B
UDMgVjRMMi1EaXNwbGF5IGRyaXZlciIKLQlkZXBlbmRzIG9uIEFSQ0hfT01BUDI0WFggfHwgQVJD
SF9PTUFQMzRYWAorCWRlcGVuZHMgb24gQVJDSF9PTUFQMiB8fCBBUkNIX09NQVAzCiAJc2VsZWN0
IFZJREVPQlVGX0dFTgogCXNlbGVjdCBWSURFT0JVRl9ETUFfU0cKIAlzZWxlY3QgT01BUDJfRFNT
CmRpZmYgLS1naXQgYS9kcml2ZXJzL21lZGlhL3ZpZGVvL29tYXAvb21hcF92b3V0LmMgYi9kcml2
ZXJzL21lZGlhL3ZpZGVvL29tYXAvb21hcF92b3V0LmMKaW5kZXggNGMwYWI0OS4uMTU2ZWQyOSAx
MDA2NDQKLS0tIGEvZHJpdmVycy9tZWRpYS92aWRlby9vbWFwL29tYXBfdm91dC5jCisrKyBiL2Ry
aXZlcnMvbWVkaWEvdmlkZW8vb21hcC9vbWFwX3ZvdXQuYwpAQCAtMzgsNiArMzgsNyBAQAogI2lu
Y2x1ZGUgPGxpbnV4L2RtYS1tYXBwaW5nLmg+CiAjaW5jbHVkZSA8bGludXgvaXJxLmg+CiAjaW5j
bHVkZSA8bGludXgvdmlkZW9kZXYyLmg+CisjaW5jbHVkZSA8bGludXgvc2xhYi5oPgogCiAjaW5j
bHVkZSA8bWVkaWEvdmlkZW9idWYtZG1hLXNnLmg+CiAjaW5jbHVkZSA8bWVkaWEvdjRsMi1kZXZp
Y2UuaD4KQEAgLTI0ODksNyArMjQ5MCw3IEBAIHN0YXRpYyBpbnQgb21hcF92b3V0X3JlbW92ZShz
dHJ1Y3QgcGxhdGZvcm1fZGV2aWNlICpwZGV2KQogCiAJZm9yIChrID0gMDsgayA8IHZpZF9kZXYt
Pm51bV9kaXNwbGF5czsgaysrKSB7CiAJCWlmICh2aWRfZGV2LT5kaXNwbGF5c1trXS0+c3RhdGUg
IT0gT01BUF9EU1NfRElTUExBWV9ESVNBQkxFRCkKLQkJCXZpZF9kZXYtPmRpc3BsYXlzW2tdLT5k
aXNhYmxlKHZpZF9kZXYtPmRpc3BsYXlzW2tdKTsKKwkJCXZpZF9kZXYtPmRpc3BsYXlzW2tdLT5k
cml2ZXItPmRpc2FibGUodmlkX2Rldi0+ZGlzcGxheXNba10pOwogCiAJCW9tYXBfZHNzX3B1dF9k
ZXZpY2UodmlkX2Rldi0+ZGlzcGxheXNba10pOwogCX0KQEAgLTI1NDYsNyArMjU0Nyw5IEBAIHN0
YXRpYyBpbnQgX19pbml0IG9tYXBfdm91dF9wcm9iZShzdHJ1Y3QgcGxhdGZvcm1fZGV2aWNlICpw
ZGV2KQogCQkJZGVmX2Rpc3BsYXkgPSBOVUxMOwogCQl9CiAJCWlmIChkZWZfZGlzcGxheSkgewot
CQkJcmV0ID0gZGVmX2Rpc3BsYXktPmVuYWJsZShkZWZfZGlzcGxheSk7CisJCQlzdHJ1Y3Qgb21h
cF9kc3NfZHJpdmVyICpkc3NkcnYgPSBkZWZfZGlzcGxheS0+ZHJpdmVyOworCQkJCisJCQlyZXQg
PSBkc3NkcnYtPmVuYWJsZShkZWZfZGlzcGxheSk7CiAJCQlpZiAocmV0KSB7CiAJCQkJLyogSGVy
ZSB3ZSBhcmUgbm90IGNvbnNpZGVyaW5nIGEgZXJyb3IKIAkJCQkgKiAgYXMgZGlzcGxheSBtYXkg
YmUgZW5hYmxlZCBieSBmcmFtZQpAQCAtMjU2MCwyMSArMjU2MywyMSBAQCBzdGF0aWMgaW50IF9f
aW5pdCBvbWFwX3ZvdXRfcHJvYmUoc3RydWN0IHBsYXRmb3JtX2RldmljZSAqcGRldikKIAkJCWlm
IChkZWZfZGlzcGxheS0+Y2FwcyAmCiAJCQkJCU9NQVBfRFNTX0RJU1BMQVlfQ0FQX01BTlVBTF9V
UERBVEUpIHsKICNpZmRlZiBDT05GSUdfRkJfT01BUDJfRk9SQ0VfQVVUT19VUERBVEUKLQkJCQlp
ZiAoZGVmX2Rpc3BsYXktPmVuYWJsZV90ZSkKLQkJCQkJZGVmX2Rpc3BsYXktPmVuYWJsZV90ZShk
ZWZfZGlzcGxheSwgMSk7Ci0JCQkJaWYgKGRlZl9kaXNwbGF5LT5zZXRfdXBkYXRlX21vZGUpCi0J
CQkJCWRlZl9kaXNwbGF5LT5zZXRfdXBkYXRlX21vZGUoZGVmX2Rpc3BsYXksCisJCQkJaWYgKGRz
c2Rydi0+ZW5hYmxlX3RlKQorCQkJCQlkc3NkcnYtPmVuYWJsZV90ZShkZWZfZGlzcGxheSwgMSk7
CisJCQkJaWYgKGRzc2Rydi0+c2V0X3VwZGF0ZV9tb2RlKQorCQkJCQlkc3NkcnYtPnNldF91cGRh
dGVfbW9kZShkZWZfZGlzcGxheSwKIAkJCQkJCQlPTUFQX0RTU19VUERBVEVfQVVUTyk7CiAjZWxz
ZQkvKiBNQU5VQUxfVVBEQVRFICovCi0JCQkJaWYgKGRlZl9kaXNwbGF5LT5lbmFibGVfdGUpCi0J
CQkJCWRlZl9kaXNwbGF5LT5lbmFibGVfdGUoZGVmX2Rpc3BsYXksIDApOwotCQkJCWlmIChkZWZf
ZGlzcGxheS0+c2V0X3VwZGF0ZV9tb2RlKQotCQkJCQlkZWZfZGlzcGxheS0+c2V0X3VwZGF0ZV9t
b2RlKGRlZl9kaXNwbGF5LAorCQkJCWlmIChkc3NkcnYtPmVuYWJsZV90ZSkKKwkJCQkJZHNzZHJ2
LT5lbmFibGVfdGUoZGVmX2Rpc3BsYXksIDApOworCQkJCWlmIChkc3NkcnYtPnNldF91cGRhdGVf
bW9kZSkKKwkJCQkJZHNzZHJ2LT5zZXRfdXBkYXRlX21vZGUoZGVmX2Rpc3BsYXksCiAJCQkJCQkJ
T01BUF9EU1NfVVBEQVRFX01BTlVBTCk7CiAjZW5kaWYKIAkJCX0gZWxzZSB7Ci0JCQkJaWYgKGRl
Zl9kaXNwbGF5LT5zZXRfdXBkYXRlX21vZGUpCi0JCQkJCWRlZl9kaXNwbGF5LT5zZXRfdXBkYXRl
X21vZGUoZGVmX2Rpc3BsYXksCisJCQkJaWYgKGRzc2Rydi0+c2V0X3VwZGF0ZV9tb2RlKQorCQkJ
CQlkc3NkcnYtPnNldF91cGRhdGVfbW9kZShkZWZfZGlzcGxheSwKIAkJCQkJCQlPTUFQX0RTU19V
UERBVEVfQVVUTyk7CiAJCQl9CiAJCX0KQEAgLTI1OTMsOCArMjU5Niw4IEBAIHN0YXRpYyBpbnQg
X19pbml0IG9tYXBfdm91dF9wcm9iZShzdHJ1Y3QgcGxhdGZvcm1fZGV2aWNlICpwZGV2KQogCWZv
ciAoaSA9IDA7IGkgPCB2aWRfZGV2LT5udW1fZGlzcGxheXM7IGkrKykgewogCQlzdHJ1Y3Qgb21h
cF9kc3NfZGV2aWNlICpkaXNwbGF5ID0gdmlkX2Rldi0+ZGlzcGxheXNbaV07CiAKLQkJaWYgKGRp
c3BsYXktPnVwZGF0ZSkKLQkJCWRpc3BsYXktPnVwZGF0ZShkaXNwbGF5LCAwLCAwLAorCQlpZiAo
ZGlzcGxheS0+ZHJpdmVyLT51cGRhdGUpCisJCQlkaXNwbGF5LT5kcml2ZXItPnVwZGF0ZShkaXNw
bGF5LCAwLCAwLAogCQkJCQlkaXNwbGF5LT5wYW5lbC50aW1pbmdzLnhfcmVzLAogCQkJCQlkaXNw
bGF5LT5wYW5lbC50aW1pbmdzLnlfcmVzKTsKIAl9CkBAIC0yNjA5LDggKzI2MTIsOCBAQCBwcm9i
ZV9lcnIxOgogCQlpZiAob3ZsLT5tYW5hZ2VyICYmIG92bC0+bWFuYWdlci0+ZGV2aWNlKQogCQkJ
ZGVmX2Rpc3BsYXkgPSBvdmwtPm1hbmFnZXItPmRldmljZTsKIAotCQlpZiAoZGVmX2Rpc3BsYXkp
Ci0JCQlkZWZfZGlzcGxheS0+ZGlzYWJsZShkZWZfZGlzcGxheSk7CisJCWlmIChkZWZfZGlzcGxh
eSAmJiBkZWZfZGlzcGxheS0+ZHJpdmVyKQorCQkJZGVmX2Rpc3BsYXktPmRyaXZlci0+ZGlzYWJs
ZShkZWZfZGlzcGxheSk7CiAJfQogcHJvYmVfZXJyMDoKIAlrZnJlZSh2aWRfZGV2KTsKLS0gCjEu
Ni4yLjQKCg==

--_002_19F8576C6E063C45BE387C64729E7394044E2A59EDdbde02enttico_--
