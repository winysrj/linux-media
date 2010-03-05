Return-path: <linux-media-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:59549 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751469Ab0CEOzE (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 5 Mar 2010 09:55:04 -0500
From: "Aguirre, Sergio" <saaguirre@ti.com>
To: "laurent.pinchart@ideasonboard.com"
	<laurent.pinchart@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Date: Fri, 5 Mar 2010 08:54:58 -0600
Subject: [omap3camera] Camera bring-up on Zoom3 (OMAP3630)
Message-ID: <A24693684029E5489D1D202277BE894453CC5C3F@dlee02.ent.ti.com>
Content-Language: en-US
Content-Type: multipart/mixed;
	boundary="_002_A24693684029E5489D1D202277BE894453CC5C3Fdlee02entticom_"
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--_002_A24693684029E5489D1D202277BE894453CC5C3Fdlee02entticom_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Hi Laurent, Sakari,

I'm trying to get latest Sakari's tree (gitorious.org/omap3camera)
'devel' branch running on my Zoom3 HW (which has an OMAP3630, and a
Sony IMX046 8MP sensor).

I had first one NULL pointer dereference while the driver was
registering devices and creating entities, which I resolved with
the attached patch. (Is this patch acceptable, or maybe I am missing
something...)

And now, I don't get quite clear on how the created nodes work out.

Now I have /dev/video[0-5], but I don't know how I'm I supposed to handle
them...

Here's my current work-in-progress kernel:

	http://dev.omapzoom.org/?p=3Dsaaguirre/linux-omap-camera.git;a=3Dshortlog;=
h=3Drefs/heads/omap-devel-wip

Can you please give some guidance on it?

Regards,
Sergio

--_002_A24693684029E5489D1D202277BE894453CC5C3Fdlee02entticom_
Content-Type: application/octet-stream;
	name="0001-omap34xxcam-Add-check-for-null-subdev-platform-data.patch"
Content-Description: 0001-omap34xxcam-Add-check-for-null-subdev-platform-data.patch
Content-Disposition: attachment;
	filename="0001-omap34xxcam-Add-check-for-null-subdev-platform-data.patch";
	size=1252; creation-date="Fri, 05 Mar 2010 08:45:37 GMT";
	modification-date="Fri, 05 Mar 2010 08:45:37 GMT"
Content-Transfer-Encoding: base64

RnJvbSAwZWFmM2U5MTkxOWRkYWYyMzA2ZmY2M2FhZmY4OTU1NDc4NjVlMTExIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTZXJnaW8gQWd1aXJyZSA8c2FhZ3VpcnJlQHRpLmNvbT4KRGF0
ZTogRnJpLCA1IE1hciAyMDEwIDA4OjQ0OjU3IC0wNjAwClN1YmplY3Q6IFtQQVRDSF0gb21hcDM0
eHhjYW06IEFkZCBjaGVjayBmb3IgbnVsbCBzdWJkZXYgcGxhdGZvcm0gZGF0YQoKU2lnbmVkLW9m
Zi1ieTogU2VyZ2lvIEFndWlycmUgPHNhYWd1aXJyZUB0aS5jb20+Ci0tLQogZHJpdmVycy9tZWRp
YS92aWRlby9vbWFwMzR4eGNhbS5jIHwgICAgNiArKysrKysKIDEgZmlsZXMgY2hhbmdlZCwgNiBp
bnNlcnRpb25zKCspLCAwIGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2RyaXZlcnMvbWVkaWEv
dmlkZW8vb21hcDM0eHhjYW0uYyBiL2RyaXZlcnMvbWVkaWEvdmlkZW8vb21hcDM0eHhjYW0uYwpp
bmRleCA5ZDlmMGQzLi4xNjY4M2NjIDEwMDY0NAotLS0gYS9kcml2ZXJzL21lZGlhL3ZpZGVvL29t
YXAzNHh4Y2FtLmMKKysrIGIvZHJpdmVycy9tZWRpYS92aWRlby9vbWFwMzR4eGNhbS5jCkBAIC0x
MzY1LDYgKzEzNjUsOSBAQCBzdGF0aWMgaW50IG9tYXAzNHh4Y2FtX3Byb2JlKHN0cnVjdCBwbGF0
Zm9ybV9kZXZpY2UgKnBkZXYpCiAKIAlmb3IgKGkgPSAwOyBpIDwgT01BUDM0WFhDQU1fVklERU9E
RVZTOyBpKyspIHsKIAkJc3RydWN0IG9tYXAzNHh4Y2FtX3ZpZGVvZGV2ICp2ZGV2ID0gJmNhbS0+
dmRldnNbaV07CisJCQorCQlpZiAocGRhdGEtPnN1YmRldnNbaV0gPT0gTlVMTCkKKwkJCWNvbnRp
bnVlOwogCiAJCW11dGV4X2luaXQoJnZkZXYtPm11dGV4KTsKIAkJdmRldi0+aW5kZXggPSBpOwpA
QCAtMTM5Nyw2ICsxNDAwLDkgQEAgc3RhdGljIGludCBvbWFwMzR4eGNhbV9wcm9iZShzdHJ1Y3Qg
cGxhdGZvcm1fZGV2aWNlICpwZGV2KQogCWZvciAoaSA9IDA7IGkgPCBPTUFQMzRYWENBTV9WSURF
T0RFVlM7IGkrKykgewogCQlzdHJ1Y3Qgb21hcDM0eHhjYW1fdmlkZW9kZXYgKnZkZXYgPSAmY2Ft
LT52ZGV2c1tpXTsKIAorCQlpZiAocGRhdGEtPnN1YmRldnNbaV0gPT0gTlVMTCkKKwkJCWNvbnRp
bnVlOworCiAJCXJldCA9IGlzcF92aWRlb19yZWdpc3RlcigmdmRldi0+dmlkZW8sICZ2ZGV2LT5j
YW0tPnY0bDJfZGV2KTsKIAkJaWYgKHJldCA8IDApIHsKIAkJCXByaW50ayhLRVJOX0VSUiAiJXM6
IGNvdWxkIG5vdCByZWdpc3RlciB2aWRlbyBkZXZpY2UgKCVkKVxuIiwKLS0gCjEuNi4zLjMKCg==

--_002_A24693684029E5489D1D202277BE894453CC5C3Fdlee02entticom_--
