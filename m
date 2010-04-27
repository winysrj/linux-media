Return-path: <linux-media-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:40958 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754467Ab0D0S5X (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 27 Apr 2010 14:57:23 -0400
From: "Aguirre, Sergio" <saaguirre@ti.com>
To: "Hiremath, Vaibhav" <hvaibhav@ti.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
CC: "mchehab@redhat.com" <mchehab@redhat.com>,
	"Karicheri, Muralidharan" <m-karicheri2@ti.com>,
	"hverkuil@xs4all.nl" <hverkuil@xs4all.nl>
Date: Tue, 27 Apr 2010 13:57:12 -0500
Subject: RE: [PATCH-V7] OMAP2/3 V4L2: Add support for OMAP2/3 V4L2 driver on
 top of DSS2
Message-ID: <A24693684029E5489D1D202277BE894454F77EAB@dlee02.ent.ti.com>
References: <hvaibhav@ti.com>
 <1270634430-5549-2-git-send-email-hvaibhav@ti.com>
In-Reply-To: <1270634430-5549-2-git-send-email-hvaibhav@ti.com>
Content-Language: en-US
Content-Type: multipart/mixed;
	boundary="_004_A24693684029E5489D1D202277BE894454F77EABdlee02entticom_"
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--_004_A24693684029E5489D1D202277BE894454F77EABdlee02entticom_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Vaibhav,

> -----Original Message-----
> From: linux-media-owner@vger.kernel.org [mailto:linux-media-
> owner@vger.kernel.org] On Behalf Of Hiremath, Vaibhav
> Sent: Wednesday, April 07, 2010 5:01 AM
> To: linux-media@vger.kernel.org
> Cc: mchehab@redhat.com; Karicheri, Muralidharan; hverkuil@xs4all.nl;
> Hiremath, Vaibhav
> Subject: [PATCH-V7] OMAP2/3 V4L2: Add support for OMAP2/3 V4L2 driver on
> top of DSS2
>=20
> From: Vaibhav Hiremath <hvaibhav@ti.com>
>=20
> Features Supported -
> 	1. Provides V4L2 user interface for the video pipelines of DSS
> 	2. Basic streaming working on LCD, DVI and TV.
> 	3. Works on latest DSS2 library from Tomi
> 	4. Support for various pixel formats like YUV, UYVY, RGB32, RGB24,
> 	   RGB565
> 	5. Supports Alpha blending.
> 	6. Supports Color keying both source and destination.
> 	7. Supports rotation.
> 	8. Supports cropping.
> 	9. Supports Background color setting.
> 	10. Allocated buffers to only needed size
>=20

This patch is broken in latest kernel. There are 2 main problems:

1. ARCH_OMAP24XX and ARCH_OMAP34XX doesn't exist anymore in latest kernel.

Tony has left only ARCH_OMAP2420, ARCH_OMAP2430 and ARCH_OMAP3430. So, I di=
d the change represented in patch #0001.

2. It doesn't compile.

See attached log.

I was able to partially fix some problems:

drivers/media/video/omap/omap_vout.c: In function 'vidioc_reqbufs':
drivers/media/video/omap/omap_vout.c:1841: error: implicit declaration of f=
unction 'kfree'
drivers/media/video/omap/omap_vout.c: In function 'omap_vout_create_video_d=
evices':
drivers/media/video/omap/omap_vout.c:2375: error: implicit declaration of f=
unction 'kmalloc'
...
drivers/media/video/omap/omap_vout.c: In function 'omap_vout_probe':
drivers/media/video/omap/omap_vout.c:2514: error: implicit declaration of f=
unction 'kzalloc'
drivers/media/video/omap/omap_vout.c:2514: warning: assignment makes pointe=
r from integer without a cast

With the attached patch #0002. But still the other problems are related to =
latest DSS2 framework changes.

Can you please take a look at those?

Regards,
Sergio

> Signed-off-by: Vaibhav Hiremath <hvaibhav@ti.com>
> ---
>  drivers/media/video/Kconfig             |    2 +
>  drivers/media/video/Makefile            |    2 +
>  drivers/media/video/omap/Kconfig        |   11 +
>  drivers/media/video/omap/Makefile       |    7 +
>  drivers/media/video/omap/omap_vout.c    | 2644
> +++++++++++++++++++++++++++++++
>  drivers/media/video/omap/omap_voutdef.h |  147 ++
>  drivers/media/video/omap/omap_voutlib.c |  293 ++++
>  drivers/media/video/omap/omap_voutlib.h |   34 +
>  8 files changed, 3140 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/media/video/omap/Kconfig
>  create mode 100644 drivers/media/video/omap/Makefile
>  create mode 100644 drivers/media/video/omap/omap_vout.c
>  create mode 100644 drivers/media/video/omap/omap_voutdef.h
>  create mode 100644 drivers/media/video/omap/omap_voutlib.c
>  create mode 100644 drivers/media/video/omap/omap_voutlib.h
>=20

<snip>

--_004_A24693684029E5489D1D202277BE894454F77EABdlee02entticom_
Content-Type: text/plain; name="log_forVaibhav_20100427.txt"
Content-Description: log_forVaibhav_20100427.txt
Content-Disposition: attachment; filename="log_forVaibhav_20100427.txt";
	size=2408; creation-date="Tue, 27 Apr 2010 12:16:35 GMT";
	modification-date="Tue, 27 Apr 2010 12:16:35 GMT"
Content-Transfer-Encoding: base64

eDAwOTEzNTlAZHR4MDA5MTM1OS11YnVudHUtMTp+L29tYXB6b29tL2xpbnV4LW9tYXAtY2FtZXJh
JCBtYWtlIEFSQ0g9YXJtIC1qMyB1SW1hZ2UgPi9kZXYvbnVsbApkcml2ZXJzL21lZGlhL3ZpZGVv
L29tYXAvb21hcF92b3V0LmM6IEluIGZ1bmN0aW9uICd2aWRpb2NfcmVxYnVmcyc6CmRyaXZlcnMv
bWVkaWEvdmlkZW8vb21hcC9vbWFwX3ZvdXQuYzoxODQxOiBlcnJvcjogaW1wbGljaXQgZGVjbGFy
YXRpb24gb2YgZnVuY3Rpb24gJ2tmcmVlJwpkcml2ZXJzL21lZGlhL3ZpZGVvL29tYXAvb21hcF92
b3V0LmM6IEluIGZ1bmN0aW9uICdvbWFwX3ZvdXRfY3JlYXRlX3ZpZGVvX2RldmljZXMnOgpkcml2
ZXJzL21lZGlhL3ZpZGVvL29tYXAvb21hcF92b3V0LmM6MjM3NTogZXJyb3I6IGltcGxpY2l0IGRl
Y2xhcmF0aW9uIG9mIGZ1bmN0aW9uICdrbWFsbG9jJwpkcml2ZXJzL21lZGlhL3ZpZGVvL29tYXAv
b21hcF92b3V0LmM6MjM3NTogd2FybmluZzogYXNzaWdubWVudCBtYWtlcyBwb2ludGVyIGZyb20g
aW50ZWdlciB3aXRob3V0IGEgY2FzdApkcml2ZXJzL21lZGlhL3ZpZGVvL29tYXAvb21hcF92b3V0
LmM6IEluIGZ1bmN0aW9uICdvbWFwX3ZvdXRfcmVtb3ZlJzoKZHJpdmVycy9tZWRpYS92aWRlby9v
bWFwL29tYXBfdm91dC5jOjI0OTM6IGVycm9yOiAnc3RydWN0IG9tYXBfZHNzX2RldmljZScgaGFz
IG5vIG1lbWJlciBuYW1lZCAnZGlzYWJsZScKZHJpdmVycy9tZWRpYS92aWRlby9vbWFwL29tYXBf
dm91dC5jOiBJbiBmdW5jdGlvbiAnb21hcF92b3V0X3Byb2JlJzoKZHJpdmVycy9tZWRpYS92aWRl
by9vbWFwL29tYXBfdm91dC5jOjI1MTQ6IGVycm9yOiBpbXBsaWNpdCBkZWNsYXJhdGlvbiBvZiBm
dW5jdGlvbiAna3phbGxvYycKZHJpdmVycy9tZWRpYS92aWRlby9vbWFwL29tYXBfdm91dC5jOjI1
MTQ6IHdhcm5pbmc6IGFzc2lnbm1lbnQgbWFrZXMgcG9pbnRlciBmcm9tIGludGVnZXIgd2l0aG91
dCBhIGNhc3QKZHJpdmVycy9tZWRpYS92aWRlby9vbWFwL29tYXBfdm91dC5jOjI1NTA6IGVycm9y
OiAnc3RydWN0IG9tYXBfZHNzX2RldmljZScgaGFzIG5vIG1lbWJlciBuYW1lZCAnZW5hYmxlJwpk
cml2ZXJzL21lZGlhL3ZpZGVvL29tYXAvb21hcF92b3V0LmM6MjU3MDogZXJyb3I6ICdzdHJ1Y3Qg
b21hcF9kc3NfZGV2aWNlJyBoYXMgbm8gbWVtYmVyIG5hbWVkICdlbmFibGVfdGUnCmRyaXZlcnMv
bWVkaWEvdmlkZW8vb21hcC9vbWFwX3ZvdXQuYzoyNTcxOiBlcnJvcjogJ3N0cnVjdCBvbWFwX2Rz
c19kZXZpY2UnIGhhcyBubyBtZW1iZXIgbmFtZWQgJ2VuYWJsZV90ZScKZHJpdmVycy9tZWRpYS92
aWRlby9vbWFwL29tYXBfdm91dC5jOjI1NzI6IGVycm9yOiAnc3RydWN0IG9tYXBfZHNzX2Rldmlj
ZScgaGFzIG5vIG1lbWJlciBuYW1lZCAnc2V0X3VwZGF0ZV9tb2RlJwpkcml2ZXJzL21lZGlhL3Zp
ZGVvL29tYXAvb21hcF92b3V0LmM6MjU3MzogZXJyb3I6ICdzdHJ1Y3Qgb21hcF9kc3NfZGV2aWNl
JyBoYXMgbm8gbWVtYmVyIG5hbWVkICdzZXRfdXBkYXRlX21vZGUnCmRyaXZlcnMvbWVkaWEvdmlk
ZW8vb21hcC9vbWFwX3ZvdXQuYzoyNTc3OiBlcnJvcjogJ3N0cnVjdCBvbWFwX2Rzc19kZXZpY2Un
IGhhcyBubyBtZW1iZXIgbmFtZWQgJ3NldF91cGRhdGVfbW9kZScKZHJpdmVycy9tZWRpYS92aWRl
by9vbWFwL29tYXBfdm91dC5jOjI1Nzg6IGVycm9yOiAnc3RydWN0IG9tYXBfZHNzX2RldmljZScg
aGFzIG5vIG1lbWJlciBuYW1lZCAnc2V0X3VwZGF0ZV9tb2RlJwpkcml2ZXJzL21lZGlhL3ZpZGVv
L29tYXAvb21hcF92b3V0LmM6MjU5NzogZXJyb3I6ICdzdHJ1Y3Qgb21hcF9kc3NfZGV2aWNlJyBo
YXMgbm8gbWVtYmVyIG5hbWVkICd1cGRhdGUnCmRyaXZlcnMvbWVkaWEvdmlkZW8vb21hcC9vbWFw
X3ZvdXQuYzoyNTk4OiBlcnJvcjogJ3N0cnVjdCBvbWFwX2Rzc19kZXZpY2UnIGhhcyBubyBtZW1i
ZXIgbmFtZWQgJ3VwZGF0ZScKZHJpdmVycy9tZWRpYS92aWRlby9vbWFwL29tYXBfdm91dC5jOjI2
MTQ6IGVycm9yOiAnc3RydWN0IG9tYXBfZHNzX2RldmljZScgaGFzIG5vIG1lbWJlciBuYW1lZCAn
ZGlzYWJsZScKbWFrZVs0XTogKioqIFtkcml2ZXJzL21lZGlhL3ZpZGVvL29tYXAvb21hcF92b3V0
Lm9dIEVycm9yIDEKbWFrZVszXTogKioqIFtkcml2ZXJzL21lZGlhL3ZpZGVvL29tYXBdIEVycm9y
IDIKbWFrZVsyXTogKioqIFtkcml2ZXJzL21lZGlhL3ZpZGVvXSBFcnJvciAyCm1ha2VbMV06ICoq
KiBbZHJpdmVycy9tZWRpYV0gRXJyb3IgMgptYWtlWzFdOiAqKiogV2FpdGluZyBmb3IgdW5maW5p
c2hlZCBqb2JzLi4uLgptYWtlOiAqKiogW2RyaXZlcnNdIEVycm9yIDIKbWFrZTogKioqIFdhaXRp
bmcgZm9yIHVuZmluaXNoZWQgam9icy4uLi4KbWFrZTogKioqIHdhaXQ6IE5vIGNoaWxkIHByb2Nl
c3Nlcy4gIFN0b3AuCgo=

--_004_A24693684029E5489D1D202277BE894454F77EABdlee02entticom_
Content-Type: application/octet-stream;
	name="0002-omap_vout-Include-linux-slab.h-explicitly.patch"
Content-Description: 0002-omap_vout-Include-linux-slab.h-explicitly.patch
Content-Disposition: attachment;
	filename="0002-omap_vout-Include-linux-slab.h-explicitly.patch"; size=1088;
	creation-date="Tue, 27 Apr 2010 13:59:16 GMT";
	modification-date="Tue, 27 Apr 2010 13:59:16 GMT"
Content-Transfer-Encoding: base64

RnJvbSAyZDA2YTdjMThjYThkZWMyOTZjY2NiMDAxYzMxODI0YTJmMzYxNDQ1IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTZXJnaW8gQWd1aXJyZSA8c2FhZ3VpcnJlQHRpLmNvbT4KRGF0
ZTogVHVlLCAyNyBBcHIgMjAxMCAxMjoyMDo1MSAtMDUwMApTdWJqZWN0OiBbUEFUQ0ggMi8yXSBv
bWFwX3ZvdXQ6IEluY2x1ZGUgbGludXgvc2xhYi5oIGV4cGxpY2l0bHkKCkFmdGVyIGNvbW1pdCBJ
RDoKCiAgY29tbWl0IGRlMzgwYjU1ZjkyOTg2YzFhODQxOTgxNDljYjcxYjcyMjhkMTVmYmQKICBB
dXRob3I6IFRlanVuIEhlbyA8dGpAa2VybmVsLm9yZz4KICBEYXRlOiAgIFdlZCBNYXIgMjQgMTc6
MDY6NDMgMjAxMCArMDkwMAoKICAgICAgcGVyY3B1OiBkb24ndCBpbXBsaWNpdGx5IGluY2x1ZGUg
c2xhYi5oIGZyb20gcGVyY3B1LmgKCnNsYWIuaCBpbmNsdWRlIHdhcyBub3QgbG9uZ2VyIGltcGxp
Y2l0bHkgaW5jbHVkZWQuCgpTbywgbm93IHdlIGhhdmUgdG8gaW5jbHVkZSBzbGFiLmggZXhwbGlj
aXRseS4KClNpZ25lZC1vZmYtYnk6IFNlcmdpbyBBZ3VpcnJlIDxzYWFndWlycmVAdGkuY29tPgot
LS0KIGRyaXZlcnMvbWVkaWEvdmlkZW8vb21hcC9vbWFwX3ZvdXQuYyB8ICAgIDEgKwogMSBmaWxl
cyBjaGFuZ2VkLCAxIGluc2VydGlvbnMoKyksIDAgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEv
ZHJpdmVycy9tZWRpYS92aWRlby9vbWFwL29tYXBfdm91dC5jIGIvZHJpdmVycy9tZWRpYS92aWRl
by9vbWFwL29tYXBfdm91dC5jCmluZGV4IGYyMTAwNjcuLmU5N2I2MzUgMTAwNjQ0Ci0tLSBhL2Ry
aXZlcnMvbWVkaWEvdmlkZW8vb21hcC9vbWFwX3ZvdXQuYworKysgYi9kcml2ZXJzL21lZGlhL3Zp
ZGVvL29tYXAvb21hcF92b3V0LmMKQEAgLTM4LDYgKzM4LDcgQEAKICNpbmNsdWRlIDxsaW51eC9k
bWEtbWFwcGluZy5oPgogI2luY2x1ZGUgPGxpbnV4L2lycS5oPgogI2luY2x1ZGUgPGxpbnV4L3Zp
ZGVvZGV2Mi5oPgorI2luY2x1ZGUgPGxpbnV4L3NsYWIuaD4KIAogI2luY2x1ZGUgPG1lZGlhL3Zp
ZGVvYnVmLWRtYS1zZy5oPgogI2luY2x1ZGUgPG1lZGlhL3Y0bDItZGV2aWNlLmg+Ci0tIAoxLjYu
My4zCgo=

--_004_A24693684029E5489D1D202277BE894454F77EABdlee02entticom_
Content-Type: application/octet-stream;
	name="0001-OMAP2-3-V4L2-Remove-deprecated-ARCH_OMAP34XX-and-ARC.patch"
Content-Description: 0001-OMAP2-3-V4L2-Remove-deprecated-ARCH_OMAP34XX-and-ARC.patch
Content-Disposition: attachment;
	filename="0001-OMAP2-3-V4L2-Remove-deprecated-ARCH_OMAP34XX-and-ARC.patch";
	size=926; creation-date="Tue, 27 Apr 2010 13:59:16 GMT";
	modification-date="Tue, 27 Apr 2010 13:59:16 GMT"
Content-Transfer-Encoding: base64

RnJvbSA5NmVkNzgxODI0MzM0YTcwODkyNTU2ODdjMjgwNDcyMjNlOWQxMTQxIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTZXJnaW8gQWd1aXJyZSA8c2FhZ3VpcnJlQHRpLmNvbT4KRGF0
ZTogVHVlLCAyNyBBcHIgMjAxMCAxMTo1NTowOSAtMDUwMApTdWJqZWN0OiBbUEFUQ0ggMS8yXSBP
TUFQMi8zIFY0TDI6IFJlbW92ZSBkZXByZWNhdGVkIEFSQ0hfT01BUDM0WFggYW5kIEFSQ0hfT01B
UDI0WFgKClRoaXMgZGVmaW5lcyBubyBsb25nZXIgZXhpc3RzLCBhbmQgd2l0aG91dCB0aGlzIGNo
YW5nZSwKdGhlIG9wdGlvbiB3b24ndCBldmVuIGFwcGVhciBpbiBtZW51Y29uZmlnLgoKU2lnbmVk
LW9mZi1ieTogU2VyZ2lvIEFndWlycmUgPHNhYWd1aXJyZUB0aS5jb20+Ci0tLQogZHJpdmVycy9t
ZWRpYS92aWRlby9vbWFwL0tjb25maWcgfCAgICAyICstCiAxIGZpbGVzIGNoYW5nZWQsIDEgaW5z
ZXJ0aW9ucygrKSwgMSBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9kcml2ZXJzL21lZGlhL3Zp
ZGVvL29tYXAvS2NvbmZpZyBiL2RyaXZlcnMvbWVkaWEvdmlkZW8vb21hcC9LY29uZmlnCmluZGV4
IDk3YzUzOTQuLmNlYmUyMzYgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvbWVkaWEvdmlkZW8vb21hcC9L
Y29uZmlnCisrKyBiL2RyaXZlcnMvbWVkaWEvdmlkZW8vb21hcC9LY29uZmlnCkBAIC0xLDYgKzEs
NiBAQAogY29uZmlnIFZJREVPX09NQVAyX1ZPVVQKIAl0cmlzdGF0ZSAiT01BUDIvT01BUDMgVjRM
Mi1EaXNwbGF5IGRyaXZlciIKLQlkZXBlbmRzIG9uIEFSQ0hfT01BUDI0WFggfHwgQVJDSF9PTUFQ
MzRYWAorCWRlcGVuZHMgb24gQVJDSF9PTUFQMjQzMCB8fCBBUkNIX09NQVAzNDMwCiAJc2VsZWN0
IFZJREVPQlVGX0dFTgogCXNlbGVjdCBWSURFT0JVRl9ETUFfU0cKIAlzZWxlY3QgT01BUDJfRFNT
Ci0tIAoxLjYuMy4zCgo=

--_004_A24693684029E5489D1D202277BE894454F77EABdlee02entticom_--
