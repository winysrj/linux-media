Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:43812 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932085AbdLOPSE (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 15 Dec 2017 10:18:04 -0500
From: "Zhi, Yong" <yong.zhi@intel.com>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Sakari Ailus <sakari.ailus@iki.fi>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "Mani, Rajmohan" <rajmohan.mani@intel.com>
Subject: RE: [RESEND GIT PULL for 4.16] Intel IPU3 CIO2 CSI-2 receiver driver
Date: Fri, 15 Dec 2017 15:18:02 +0000
Message-ID: <C193D76D23A22742993887E6D207B54D1AE4CDA2@ORSMSX106.amr.corp.intel.com>
References: <20171201143135.c6r2e2iaoxcvyxpi@valkosipuli.retiisi.org.uk>
 <20171208125937.07bb3302@vento.lan>,<C193D76D23A22742993887E6D207B54D1AE4A17B@ORSMSX106.amr.corp.intel.com>
In-Reply-To: <C193D76D23A22742993887E6D207B54D1AE4A17B@ORSMSX106.amr.corp.intel.com>
Content-Language: en-US
Content-Type: multipart/mixed;
        boundary="_002_C193D76D23A22742993887E6D207B54D1AE4CDA2ORSMSX106amrcor_"
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--_002_C193D76D23A22742993887E6D207B54D1AE4CDA2ORSMSX106amrcor_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Hi, Mauro and Sakari,

Sorry for the late response, the fix of the 2 warnings is attached.

Best regards,

Yong
________________________________________
From: Zhi, Yong
Sent: Friday, December 08, 2017 3:32 PM
To: Mauro Carvalho Chehab; Sakari Ailus
Cc: linux-media@vger.kernel.org; Mani, Rajmohan
Subject: RE: [RESEND GIT PULL for 4.16] Intel IPU3 CIO2 CSI-2 receiver driv=
er

Hi, Mauro,

> -----Original Message-----
> From: Mauro Carvalho Chehab [mailto:mchehab@s-opensource.com]
> Sent: Friday, December 8, 2017 7:00 AM
> To: Sakari Ailus <sakari.ailus@iki.fi>
> Cc: linux-media@vger.kernel.org; Mani, Rajmohan
> <rajmohan.mani@intel.com>; Zhi, Yong <yong.zhi@intel.com>
> Subject: Re: [RESEND GIT PULL for 4.16] Intel IPU3 CIO2 CSI-2 receiver dr=
iver
>
> Em Fri, 1 Dec 2017 16:31:36 +0200
> Sakari Ailus <sakari.ailus@iki.fi> escreveu:
>
> > Hi Mauro,
> >
> > Here's the Intel IPU3 CIO2 CSI-2 receiver driver, with the
> > accompanying format definitions.
>
> This patch generates two warnings:
>
> drivers/media/pci/intel/ipu3/ipu3-cio2.c:1899:16: warning: Variable lengt=
h
> array is used.
> drivers/media/pci/intel/ipu3/ipu3-cio2.c: In function 'cio2_pci_probe':
> drivers/media/pci/intel/ipu3/ipu3-cio2.c:1726:14: warning: variable 'phys=
'
> set but not used [-Wunused-but-set-variable]
>   phys_addr_t phys;
>               ^~~~
>
> We should never use variable-length array on Kernel, as Linux stack is ve=
ry
> limited, and we have static analyzers to check for it at compilation time=
.
>
> Also, the logic should check if pci_resource_start() succeeded, instead o=
f
> just ignoring it.
>
> Please fix.
>

Thanks for catching the warnings, for the variable size array, from the cod=
e context,
the size is limited to 128 bytes, maybe this language feature itself is not=
 recommended,
we will send a patch to address above soon.

>
> >
> > Please pull.
> >
> >
> > The following changes since commit
> be9b53c83792e3898755dce90f8c632d40e7c83e:
> >
> >   media: dvb-frontends: complete kernel-doc markups (2017-11-30
> > 04:19:05 -0500)
> >
> > are available in the git repository at:
> >
> >   ssh://linuxtv.org/git/sailus/media_tree.git ipu3
> >
> > for you to fetch changes up to
> f178207daa68e817ab6fd702d81ed7c8637ab72c:
> >
> >   intel-ipu3: cio2: add new MIPI-CSI2 driver (2017-11-30 14:19:47
> > +0200)
> >
> > ----------------------------------------------------------------
> > Yong Zhi (3):
> >       videodev2.h, v4l2-ioctl: add IPU3 raw10 color format
> >       doc-rst: add IPU3 raw10 bayer pixel format definitions
> >       intel-ipu3: cio2: add new MIPI-CSI2 driver
> >
> >  Documentation/media/uapi/v4l/pixfmt-rgb.rst        |    1 +
> >  .../media/uapi/v4l/pixfmt-srggb10-ipu3.rst         |  335 ++++
> >  MAINTAINERS                                        |    8 +
> >  drivers/media/pci/Kconfig                          |    2 +
> >  drivers/media/pci/Makefile                         |    3 +-
> >  drivers/media/pci/intel/Makefile                   |    5 +
> >  drivers/media/pci/intel/ipu3/Kconfig               |   19 +
> >  drivers/media/pci/intel/ipu3/Makefile              |    1 +
> >  drivers/media/pci/intel/ipu3/ipu3-cio2.c           | 2052
> ++++++++++++++++++++
> >  drivers/media/pci/intel/ipu3/ipu3-cio2.h           |  449 +++++
> >  drivers/media/v4l2-core/v4l2-ioctl.c               |    4 +
> >  include/uapi/linux/videodev2.h                     |    6 +
> >  12 files changed, 2884 insertions(+), 1 deletion(-)  create mode
> > 100644 Documentation/media/uapi/v4l/pixfmt-srggb10-ipu3.rst
> >  create mode 100644 drivers/media/pci/intel/Makefile  create mode
> > 100644 drivers/media/pci/intel/ipu3/Kconfig
> >  create mode 100644 drivers/media/pci/intel/ipu3/Makefile
> >  create mode 100644 drivers/media/pci/intel/ipu3/ipu3-cio2.c
> >  create mode 100644 drivers/media/pci/intel/ipu3/ipu3-cio2.h
> >
>
>
>
> Thanks,
> Mauro

--_002_C193D76D23A22742993887E6D207B54D1AE4CDA2ORSMSX106amrcor_
Content-Type: text/x-patch;
	name="0001-PATCH-v8-intel-ipu3-cio2-fix-two-warnings-in-the-cod.patch"
Content-Description: 0001-PATCH-v8-intel-ipu3-cio2-fix-two-warnings-in-the-cod.patch
Content-Disposition: attachment;
	filename="0001-PATCH-v8-intel-ipu3-cio2-fix-two-warnings-in-the-cod.patch";
	size=2402; creation-date="Fri, 15 Dec 2017 15:15:58 GMT";
	modification-date="Fri, 15 Dec 2017 15:15:58 GMT"
Content-Transfer-Encoding: base64

RnJvbSBkN2U5YmFmMTNiMWE4YzgzMDg5MDZhN2VkMjEzZjc1ZDEyNzU2YzI0IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBZb25nIFpoaSA8eW9uZy56aGlAaW50ZWwuY29tPgpEYXRlOiBU
dWUsIDEyIERlYyAyMDE3IDEwOjE2OjMxIC0wNjAwClN1YmplY3Q6IFtQQVRDSF0gW1BBVENIIHY4
XSBpbnRlbC1pcHUzOiBjaW8yOiBmaXggdHdvIHdhcm5pbmdzIGluIHRoZSBjb2RlCgpGaXggdHdv
IHdhcm5pbmdzIHJlcG9ydGVkIGJ5IE1hdXJvIENhcnZhbGhvIENoZWhhYjoKCmlwdTMtY2lvMi5j
OjE4OTk6MTY6IHdhcm5pbmc6IFZhcmlhYmxlIGxlbmd0aCBhcnJheSBpcyB1c2VkLgoKSW4gZnVu
Y3Rpb24gJ2NpbzJfcGNpX3Byb2JlJzoKaXB1My1jaW8yLmM6MTcyNjoxNDogd2FybmluZzogdmFy
aWFibGUgJ3BoeXMnIHNldApidXQgbm90IHVzZWQgWy1XdW51c2VkLWJ1dC1zZXQtdmFyaWFibGVd
CgpIaSwgU2FrYXJpLCBjYW4geW91IHNxdWFzaCB0aGUgcGF0Y2ggdG8geW91ciB0cmVlPwoKU2ln
bmVkLW9mZi1ieTogWW9uZyBaaGkgPHlvbmcuemhpQGludGVsLmNvbT4KLS0tCiBkcml2ZXJzL21l
ZGlhL3BjaS9pbnRlbC9pcHUzL2lwdTMtY2lvMi5jIHwgMTYgKysrKysrLS0tLS0tLS0tLQogMSBm
aWxlIGNoYW5nZWQsIDYgaW5zZXJ0aW9ucygrKSwgMTAgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0
IGEvZHJpdmVycy9tZWRpYS9wY2kvaW50ZWwvaXB1My9pcHUzLWNpbzIuYyBiL2RyaXZlcnMvbWVk
aWEvcGNpL2ludGVsL2lwdTMvaXB1My1jaW8yLmMKaW5kZXggNDI5NWJkYjhiMTkyLi45NDFjYWE5
ODdkYWIgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvbWVkaWEvcGNpL2ludGVsL2lwdTMvaXB1My1jaW8y
LmMKKysrIGIvZHJpdmVycy9tZWRpYS9wY2kvaW50ZWwvaXB1My9pcHUzLWNpbzIuYwpAQCAtMTcy
Myw3ICsxNzIzLDYgQEAgc3RhdGljIGludCBjaW8yX3BjaV9wcm9iZShzdHJ1Y3QgcGNpX2RldiAq
cGNpX2RldiwKIAkJCSAgY29uc3Qgc3RydWN0IHBjaV9kZXZpY2VfaWQgKmlkKQogewogCXN0cnVj
dCBjaW8yX2RldmljZSAqY2lvMjsKLQlwaHlzX2FkZHJfdCBwaHlzOwogCXZvaWQgX19pb21lbSAq
Y29uc3QgKmlvbWFwOwogCWludCByOwogCkBAIC0xNzQxLDggKzE3NDAsNiBAQCBzdGF0aWMgaW50
IGNpbzJfcGNpX3Byb2JlKHN0cnVjdCBwY2lfZGV2ICpwY2lfZGV2LAogCWRldl9pbmZvKCZwY2lf
ZGV2LT5kZXYsICJkZXZpY2UgMHgleCAocmV2OiAweCV4KVxuIiwKIAkJIHBjaV9kZXYtPmRldmlj
ZSwgcGNpX2Rldi0+cmV2aXNpb24pOwogCi0JcGh5cyA9IHBjaV9yZXNvdXJjZV9zdGFydChwY2lf
ZGV2LCBDSU8yX1BDSV9CQVIpOwotCiAJciA9IHBjaW1faW9tYXBfcmVnaW9ucyhwY2lfZGV2LCAx
IDw8IENJTzJfUENJX0JBUiwgcGNpX25hbWUocGNpX2RldikpOwogCWlmIChyKSB7CiAJCWRldl9l
cnIoJnBjaV9kZXYtPmRldiwgImZhaWxlZCB0byByZW1hcCBJL08gbWVtb3J5ICglZClcbiIsIHIp
OwpAQCAtMTg5Niw3ICsxODkzLDYgQEAgc3RhdGljIHZvaWQgYXJyYW5nZSh2b2lkICpwdHIsIHNp
emVfdCBlbGVtX3NpemUsIHNpemVfdCBlbGVtcywgc2l6ZV90IHN0YXJ0KQogCQl7IDAsIHN0YXJ0
IC0gMSB9LAogCQl7IHN0YXJ0LCBlbGVtcyAtIDEgfSwKIAl9OwotCXU4IHRtcFtlbGVtX3NpemVd
OwogCiAjZGVmaW5lIGFycl9zaXplKGEpICgoYSktPmVuZCAtIChhKS0+YmVnaW4gKyAxKQogCkBA
IC0xOTE1LDEyICsxOTExLDEyIEBAIHN0YXRpYyB2b2lkIGFycmFuZ2Uodm9pZCAqcHRyLCBzaXpl
X3QgZWxlbV9zaXplLCBzaXplX3QgZWxlbXMsIHNpemVfdCBzdGFydCkKIAogCQkvKiBTd2FwIHRo
ZSBlbnRyaWVzIGluIHR3byBwYXJ0cyBvZiB0aGUgYXJyYXkuICovCiAJCWZvciAoaSA9IDA7IGkg
PCBzaXplMDsgaSsrKSB7Ci0JCQltZW1jcHkodG1wLCBwdHIgKyBlbGVtX3NpemUgKiAoYXJyWzFd
LmJlZ2luICsgaSksCi0JCQkgICAgICAgZWxlbV9zaXplKTsKLQkJCW1lbWNweShwdHIgKyBlbGVt
X3NpemUgKiAoYXJyWzFdLmJlZ2luICsgaSksCi0JCQkgICAgICAgcHRyICsgZWxlbV9zaXplICog
KGFyclswXS5iZWdpbiArIGkpLCBlbGVtX3NpemUpOwotCQkJbWVtY3B5KHB0ciArIGVsZW1fc2l6
ZSAqIChhcnJbMF0uYmVnaW4gKyBpKSwgdG1wLAotCQkJICAgICAgIGVsZW1fc2l6ZSk7CisJCQl1
OCAqZCA9IHB0ciArIGVsZW1fc2l6ZSAqIChhcnJbMV0uYmVnaW4gKyBpKTsKKwkJCXU4ICpzID0g
cHRyICsgZWxlbV9zaXplICogKGFyclswXS5iZWdpbiArIGkpOworCQkJc2l6ZV90IGo7CisKKwkJ
CWZvciAoaiA9IDA7IGogPCBlbGVtX3NpemU7IGorKykKKwkJCQlzd2FwKGRbal0sIHNbal0pOwog
CQl9CiAKIAkJaWYgKGFycl9zaXplKCZhcnJbMF0pID4gYXJyX3NpemUoJmFyclsxXSkpIHsKLS0g
CjIuNy40Cgo=

--_002_C193D76D23A22742993887E6D207B54D1AE4CDA2ORSMSX106amrcor_--
