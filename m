Return-path: <linux-media-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:48499 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754460AbZCDP3a (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 4 Mar 2009 10:29:30 -0500
From: "Hiremath, Vaibhav" <hvaibhav@ti.com>
To: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
CC: "Aguirre Rodriguez, Sergio Alberto" <saaguirre@ti.com>,
	Toivonen Tuukka Olli Artturi <tuukka.o.toivonen@nokia.com>,
	Hiroshi DOYU <Hiroshi.DOYU@nokia.com>,
	DongSoo Kim <dongsoo.kim@gmail.com>
Date: Wed, 4 Mar 2009 20:58:57 +0530
Subject: RE: [RFC 0/9] OMAP3 ISP and camera drivers
Message-ID: <19F8576C6E063C45BE387C64729E73940427BCA193@dbde02.ent.ti.com>
In-Reply-To: <49AD0128.5090503@maxwell.research.nokia.com>
Content-Language: en-US
Content-Type: multipart/mixed;
	boundary="_002_19F8576C6E063C45BE387C64729E73940427BCA193dbde02enttico_"
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--_002_19F8576C6E063C45BE387C64729E73940427BCA193dbde02enttico_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable



Thanks,
Vaibhav Hiremath

> -----Original Message-----
> From: linux-media-owner@vger.kernel.org [mailto:linux-media-
> owner@vger.kernel.org] On Behalf Of Sakari Ailus
> Sent: Tuesday, March 03, 2009 3:37 PM
> To: linux-media@vger.kernel.org; linux-omap@vger.kernel.org
> Cc: Aguirre Rodriguez, Sergio Alberto; Toivonen Tuukka Olli Artturi;
> Hiroshi DOYU; DongSoo Kim
> Subject: [RFC 0/9] OMAP3 ISP and camera drivers
>=20
> Hi,
>=20
> So here's the patchset for OMAP 3 ISP and camera drivers plus the
> associated V4L changes. Sergio Aguirre has been posting a related
> patchset earlier, containing also sensor and lens driver used on
> SDP.
> This patchset is agains the linux-omap tree:
>=20
> <URL:http://www.muru.com/linux/omap/README_OMAP_GIT>
>=20
[Hiremath, Vaibhav] Sakari, Let me ask you basic question, have you tested/=
verified these patch-sets?

The reason I am asking this question is, for me it was not working. I had t=
o debug this and found that -=20

	- Changes missing in devices.c file, so isp_probe function will not be cal=
led at all, keeping omap3isp =3D NULL. You will end up into kernel crash in=
 omap34xxcam_device_register.

	- The patches from Hiroshi DOYU doesn't build as is, you need to add one i=
nclude line #include <linux/hardirq.h> in iovmmu.c
(I am using the patches submitted on 16th Jan 2009)

I have attached "git diff" output here with this mail for reference.

Am I missing any patches here? I am not sure how Sergio is able to use thes=
e patches?
If I am not missing anything, then I think you should mention all these iss=
ues clearly in the patch so that anybody who might want to use will not suf=
fer.

> So I and Sergio have synchronised our versions of the ISP and camera
> drivers and this is the end result. There is still a lot of work to
> do,
> though. You can find some comments in individual patch descriptions.
> If
> the todo list for a patch is empty it doesn't mean there wouldn't be
> anything left to do. ;)
>=20
> There's at least one major change to Sergio Aguirre's earlier
> patches
> which is that the ISP driver now uses the IOMMU from Hiroshi Doyu.
> Hiroshi is away for some time now so there are just some hacks on
> top of
> Hiroshi's older iommu patches to use with current linux-omap.
>=20
> This patchset does not contain the resizer or preview wrappers from
> TI
> but they have been left intentionally out. A proper interface (V4L)
> should be used for those and the camera driver should be somehow
> involved --- the wrappers are just duplicating much of the camera
> driver's functionality.
>=20
> I don't have any sensor or lens drivers to publish at this time.
>=20
> This patchset should work with the SDP and OMAPZoom boards although
> you
> need the associated sensor drivers + the board code from Sergio
> Aguirre
> to use it. You'll also need the IOMMU patchset from Hiroshi Doyu.
> Everything except the sensor / board stuff is available here:
>=20
> <URL:http://www.gitorious.org/projects/omap3camera>
>=20
> In short, on linux-omap:
>=20
> $ git pull http://git.gitorious.org/omap3camera/mainline.git v4l \
>    iommu omap3camera base
>=20
> Hiroshi's original iommu tree is here (branch iommu):
>=20
> <URL:http://git.gitorious.org/lk/mainline.git>
>=20
> Some of the camera and ISP driver development history is available,
> too.
> See the first link.
>=20
> Any feedback is appreciated.
>=20
> Sincerely,
>=20
> --
> Sakari Ailus
> sakari.ailus@maxwell.research.nokia.com
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-
> media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--_002_19F8576C6E063C45BE387C64729E73940427BCA193dbde02enttico_
Content-Type: application/octet-stream; name="isp_patch_fix.patch"
Content-Description: isp_patch_fix.patch
Content-Disposition: attachment; filename="isp_patch_fix.patch"; size=4377;
	creation-date="Wed, 04 Mar 2009 20:55:16 GMT";
	modification-date="Wed, 04 Mar 2009 20:55:16 GMT"
Content-Transfer-Encoding: base64

ZGlmZiAtLWdpdCBhL2FyY2gvYXJtL21hY2gtb21hcDIvZGV2aWNlcy5jIGIvYXJjaC9hcm0vbWFj
aC1vbWFwMi9kZXZpY2VzLmMKb2xkIG1vZGUgMTAwNjQ0Cm5ldyBtb2RlIDEwMDc1NQppbmRleCBk
YWQ0NTI4Li4yNTY4YjBjCi0tLSBhL2FyY2gvYXJtL21hY2gtb21hcDIvZGV2aWNlcy5jCisrKyBi
L2FyY2gvYXJtL21hY2gtb21hcDIvZGV2aWNlcy5jCkBAIC01NiwxMCArNTYsNjAgQEAgc3RhdGlj
IGlubGluZSB2b2lkIG9tYXBfaW5pdF9jYW1lcmEodm9pZCkKIAogI2VsaWYgZGVmaW5lZChDT05G
SUdfVklERU9fT01BUDMpIHx8IGRlZmluZWQoQ09ORklHX1ZJREVPX09NQVAzX01PRFVMRSkKIAot
c3RhdGljIHN0cnVjdCByZXNvdXJjZSBjYW1fcmVzb3VyY2VzW10gPSB7CitzdGF0aWMgc3RydWN0
IHJlc291cmNlIG9tYXAzaXNwX3Jlc291cmNlc1tdID0geworCXsKKwkJLnN0YXJ0CQk9IE9NQVAz
NDMwX0lTUF9CQVNFLAorCQkuZW5kCQk9IE9NQVAzNDMwX0lTUF9FTkQsCisJCS5mbGFncwkJPSBJ
T1JFU09VUkNFX01FTSwKKwl9LAorCXsKKwkJLnN0YXJ0CQk9IE9NQVAzNDMwX0lTUF9DQlVGRl9C
QVNFLAorCQkuZW5kCQk9IE9NQVAzNDMwX0lTUF9DQlVGRl9FTkQsCisJCS5mbGFncwkJPSBJT1JF
U09VUkNFX01FTSwKKwl9LAorCXsKKwkJLnN0YXJ0CQk9IE9NQVAzNDMwX0lTUF9DQ1AyX0JBU0Us
CisJCS5lbmQJCT0gT01BUDM0MzBfSVNQX0NDUDJfRU5ELAorCQkuZmxhZ3MJCT0gSU9SRVNPVVJD
RV9NRU0sCisJfSwKIAl7Ci0JCS5zdGFydAkJPSBPTUFQMzRYWF9DQU1FUkFfQkFTRSwKLQkJLmVu
ZAkJPSBPTUFQMzRYWF9DQU1FUkFfQkFTRSArIDB4MUI3MCwKKwkJLnN0YXJ0CQk9IE9NQVAzNDMw
X0lTUF9DQ0RDX0JBU0UsCisJCS5lbmQJCT0gT01BUDM0MzBfSVNQX0NDRENfRU5ELAorCQkuZmxh
Z3MJCT0gSU9SRVNPVVJDRV9NRU0sCisJfSwKKwl7CisJCS5zdGFydAkJPSBPTUFQMzQzMF9JU1Bf
SElTVF9CQVNFLAorCQkuZW5kCQk9IE9NQVAzNDMwX0lTUF9ISVNUX0VORCwKKwkJLmZsYWdzCQk9
IElPUkVTT1VSQ0VfTUVNLAorCX0sCisJeworCQkuc3RhcnQJCT0gT01BUDM0MzBfSVNQX0gzQV9C
QVNFLAorCQkuZW5kCQk9IE9NQVAzNDMwX0lTUF9IM0FfRU5ELAorCQkuZmxhZ3MJCT0gSU9SRVNP
VVJDRV9NRU0sCisJfSwKKwl7CisJCS5zdGFydAkJPSBPTUFQMzQzMF9JU1BfUFJFVl9CQVNFLAor
CQkuZW5kCQk9IE9NQVAzNDMwX0lTUF9QUkVWX0VORCwKKwkJLmZsYWdzCQk9IElPUkVTT1VSQ0Vf
TUVNLAorCX0sCisJeworCQkuc3RhcnQJCT0gT01BUDM0MzBfSVNQX1JFU1pfQkFTRSwKKwkJLmVu
ZAkJPSBPTUFQMzQzMF9JU1BfUkVTWl9FTkQsCisJCS5mbGFncwkJPSBJT1JFU09VUkNFX01FTSwK
Kwl9LAorCXsKKwkJLnN0YXJ0CQk9IE9NQVAzNDMwX0lTUF9TQkxfQkFTRSwKKwkJLmVuZAkJPSBP
TUFQMzQzMF9JU1BfU0JMX0VORCwKKwkJLmZsYWdzCQk9IElPUkVTT1VSQ0VfTUVNLAorCX0sCisJ
eworCQkuc3RhcnQJCT0gT01BUDM0MzBfSVNQX0NTSTJBX0JBU0UsCisJCS5lbmQJCT0gT01BUDM0
MzBfSVNQX0NTSTJBX0VORCwKKwkJLmZsYWdzCQk9IElPUkVTT1VSQ0VfTUVNLAorCX0sCisJewor
CQkuc3RhcnQJCT0gT01BUDM0MzBfSVNQX0NTSTJQSFlfQkFTRSwKKwkJLmVuZAkJPSBPTUFQMzQz
MF9JU1BfQ1NJMlBIWV9FTkQsCiAJCS5mbGFncwkJPSBJT1JFU09VUkNFX01FTSwKIAl9LAogCXsK
QEAgLTY4LDE2ICsxMTgsMTYgQEAgc3RhdGljIHN0cnVjdCByZXNvdXJjZSBjYW1fcmVzb3VyY2Vz
W10gPSB7CiAJfQogfTsKIAotc3RhdGljIHN0cnVjdCBwbGF0Zm9ybV9kZXZpY2Ugb21hcF9jYW1f
ZGV2aWNlID0gewotCS5uYW1lCQk9ICJvbWFwMzR4eGNhbSIsCitzdGF0aWMgc3RydWN0IHBsYXRm
b3JtX2RldmljZSBvbWFwM2lzcF9kZXZpY2UgPSB7CisJLm5hbWUJCT0gIm9tYXAzaXNwIiwKIAku
aWQJCT0gLTEsCi0JLm51bV9yZXNvdXJjZXMJPSBBUlJBWV9TSVpFKGNhbV9yZXNvdXJjZXMpLAot
CS5yZXNvdXJjZQk9IGNhbV9yZXNvdXJjZXMsCisJLm51bV9yZXNvdXJjZXMJPSBBUlJBWV9TSVpF
KG9tYXAzaXNwX3Jlc291cmNlcyksCisJLnJlc291cmNlCT0gb21hcDNpc3BfcmVzb3VyY2VzLAog
fTsKIAogc3RhdGljIGlubGluZSB2b2lkIG9tYXBfaW5pdF9jYW1lcmEodm9pZCkKIHsKLQlwbGF0
Zm9ybV9kZXZpY2VfcmVnaXN0ZXIoJm9tYXBfY2FtX2RldmljZSk7CisJcGxhdGZvcm1fZGV2aWNl
X3JlZ2lzdGVyKCZvbWFwM2lzcF9kZXZpY2UpOwogfQogI2Vsc2UKIHN0YXRpYyBpbmxpbmUgdm9p
ZCBvbWFwX2luaXRfY2FtZXJhKHZvaWQpCmRpZmYgLS1naXQgYS9hcmNoL2FybS9wbGF0LW9tYXAv
aW5jbHVkZS9tYWNoL29tYXAzNHh4LmggYi9hcmNoL2FybS9wbGF0LW9tYXAvaW5jbHVkZS9tYWNo
L29tYXAzNHh4LmgKb2xkIG1vZGUgMTAwNjQ0Cm5ldyBtb2RlIDEwMDc1NQppbmRleCAyN2ExZTQ1
Li45YTE2Yzk2Ci0tLSBhL2FyY2gvYXJtL3BsYXQtb21hcC9pbmNsdWRlL21hY2gvb21hcDM0eHgu
aAorKysgYi9hcmNoL2FybS9wbGF0LW9tYXAvaW5jbHVkZS9tYWNoL29tYXAzNHh4LmgKQEAgLTQ5
LDYgKzQ5LDMzIEBACiAjZGVmaW5lIE9NQVAzNDNYX0NUUkxfQkFTRQlPTUFQMzQzWF9TQ01fQkFT
RQogCiAjZGVmaW5lIE9NQVAzNFhYX0lDX0JBU0UJMHg0ODIwMDAwMAorCisjZGVmaW5lIE9NQVAz
NDMwX0lTUF9CQVNFCQkoTDRfMzRYWF9CQVNFICsgMHhCQzAwMCkKKyNkZWZpbmUgT01BUDM0MzBf
SVNQX0NCVUZGX0JBU0UJCShPTUFQMzQzMF9JU1BfQkFTRSArIDB4MDEwMCkKKyNkZWZpbmUgT01B
UDM0MzBfSVNQX0NDUDJfQkFTRQkJKE9NQVAzNDMwX0lTUF9CQVNFICsgMHgwNDAwKQorI2RlZmlu
ZSBPTUFQMzQzMF9JU1BfQ0NEQ19CQVNFCQkoT01BUDM0MzBfSVNQX0JBU0UgKyAweDA2MDApCisj
ZGVmaW5lIE9NQVAzNDMwX0lTUF9ISVNUX0JBU0UJCShPTUFQMzQzMF9JU1BfQkFTRSArIDB4MEEw
MCkKKyNkZWZpbmUgT01BUDM0MzBfSVNQX0gzQV9CQVNFCQkoT01BUDM0MzBfSVNQX0JBU0UgKyAw
eDBDMDApCisjZGVmaW5lIE9NQVAzNDMwX0lTUF9QUkVWX0JBU0UJCShPTUFQMzQzMF9JU1BfQkFT
RSArIDB4MEUwMCkKKyNkZWZpbmUgT01BUDM0MzBfSVNQX1JFU1pfQkFTRQkJKE9NQVAzNDMwX0lT
UF9CQVNFICsgMHgxMDAwKQorI2RlZmluZSBPTUFQMzQzMF9JU1BfU0JMX0JBU0UJCShPTUFQMzQz
MF9JU1BfQkFTRSArIDB4MTIwMCkKKyNkZWZpbmUgT01BUDM0MzBfSVNQX01NVV9CQVNFCQkoT01B
UDM0MzBfSVNQX0JBU0UgKyAweDE0MDApCisjZGVmaW5lIE9NQVAzNDMwX0lTUF9DU0kyQV9CQVNF
CQkoT01BUDM0MzBfSVNQX0JBU0UgKyAweDE4MDApCisjZGVmaW5lIE9NQVAzNDMwX0lTUF9DU0ky
UEhZX0JBU0UJKE9NQVAzNDMwX0lTUF9CQVNFICsgMHgxOTcwKQorCisjZGVmaW5lIE9NQVAzNDMw
X0lTUF9FTkQJCShPTUFQMzQzMF9JU1BfQkFTRSAgICAgICAgICsgMHgwNkYpCisjZGVmaW5lIE9N
QVAzNDMwX0lTUF9DQlVGRl9FTkQJCShPTUFQMzQzMF9JU1BfQ0JVRkZfQkFTRSAgICsgMHgwNzcp
CisjZGVmaW5lIE9NQVAzNDMwX0lTUF9DQ1AyX0VORAkJKE9NQVAzNDMwX0lTUF9DQ1AyX0JBU0Ug
ICAgKyAweDFFRikKKyNkZWZpbmUgT01BUDM0MzBfSVNQX0NDRENfRU5ECQkoT01BUDM0MzBfSVNQ
X0NDRENfQkFTRSAgICArIDB4MEE3KQorI2RlZmluZSBPTUFQMzQzMF9JU1BfSElTVF9FTkQJCShP
TUFQMzQzMF9JU1BfSElTVF9CQVNFICAgICsgMHgwNDcpCisjZGVmaW5lIE9NQVAzNDMwX0lTUF9I
M0FfRU5ECQkoT01BUDM0MzBfSVNQX0gzQV9CQVNFICAgICArIDB4MDVGKQorI2RlZmluZSBPTUFQ
MzQzMF9JU1BfUFJFVl9FTkQJCShPTUFQMzQzMF9JU1BfUFJFVl9CQVNFICAgICsgMHgwOUYpCisj
ZGVmaW5lIE9NQVAzNDMwX0lTUF9SRVNaX0VORAkJKE9NQVAzNDMwX0lTUF9SRVNaX0JBU0UgICAg
KyAweDBBQikKKyNkZWZpbmUgT01BUDM0MzBfSVNQX1NCTF9FTkQJCShPTUFQMzQzMF9JU1BfU0JM
X0JBU0UgICAgICsgMHgwRkIpCisjZGVmaW5lIE9NQVAzNDMwX0lTUF9NTVVfRU5ECQkoT01BUDM0
MzBfSVNQX01NVV9CQVNFICAgICArIDB4MDZGKQorI2RlZmluZSBPTUFQMzQzMF9JU1BfQ1NJMkFf
RU5ECQkoT01BUDM0MzBfSVNQX0NTSTJBX0JBU0UgICArIDB4MTZGKQorI2RlZmluZSBPTUFQMzQz
MF9JU1BfQ1NJMlBIWV9FTkQJKE9NQVAzNDMwX0lTUF9DU0kyUEhZX0JBU0UgKyAweDAwNykKKwog
I2RlZmluZSBPTUFQMzRYWF9JVkFfSU5UQ19CQVNFCTB4NDAwMDAwMDAKICNkZWZpbmUgT01BUDM0
WFhfSFNVU0JfT1RHX0JBU0UJKEw0XzM0WFhfQkFTRSArIDB4QUIwMDApCiAjZGVmaW5lIE9NQVAz
NFhYX0hTVVNCX0hPU1RfQkFTRQkoTDRfMzRYWF9CQVNFICsgMHg2NDAwMCkK

--_002_19F8576C6E063C45BE387C64729E73940427BCA193dbde02enttico_--
