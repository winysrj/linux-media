Return-path: <linux-media-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:53302 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754333AbZJ2Fvq (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 29 Oct 2009 01:51:46 -0400
Received: from dbdp20.itg.ti.com ([172.24.170.38])
	by bear.ext.ti.com (8.13.7/8.13.7) with ESMTP id n9T5pnB6012748
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Thu, 29 Oct 2009 00:51:51 -0500
Received: from dbde71.ent.ti.com (localhost [127.0.0.1])
	by dbdp20.itg.ti.com (8.13.8/8.13.8) with ESMTP id n9T5pmJ0012161
	for <linux-media@vger.kernel.org>; Thu, 29 Oct 2009 11:21:48 +0530 (IST)
From: "Hiremath, Vaibhav" <hvaibhav@ti.com>
To: "Hiremath, Vaibhav" <hvaibhav@ti.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Date: Thu, 29 Oct 2009 11:21:44 +0530
Subject: RE: [PATCH 1/1] v4l2 doc: Added S/G_ROTATE, S/G_BG_COLOR information
Message-ID: <19F8576C6E063C45BE387C64729E73940436EEAF51@dbde02.ent.ti.com>
References: <hvaibhav@ti.com>
 <1256794977-32473-1-git-send-email-hvaibhav@ti.com>
In-Reply-To: <1256794977-32473-1-git-send-email-hvaibhav@ti.com>
Content-Language: en-US
Content-Type: multipart/mixed;
	boundary="_002_19F8576C6E063C45BE387C64729E73940436EEAF51dbde02enttico_"
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--_002_19F8576C6E063C45BE387C64729E73940436EEAF51dbde02enttico_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Oops, below patch had wrong subject line (S/G). I just fixed the subject li=
ne (to CID_) and attached here.


Thanks,
Vaibhav Hiremath
Platform Support Products
Texas Instruments Inc
Ph: +91-80-25099927

> -----Original Message-----
> From: Hiremath, Vaibhav
> Sent: Thursday, October 29, 2009 11:13 AM
> To: linux-media@vger.kernel.org
> Cc: Hiremath, Vaibhav
> Subject: [PATCH 1/1] v4l2 doc: Added S/G_ROTATE, S/G_BG_COLOR
> information
>=20
> From: Vaibhav Hiremath <hvaibhav@ti.com>
>=20
>=20
> Signed-off-by: Vaibhav Hiremath <hvaibhav@ti.com>
> ---
>  v4l2-spec/controls.sgml |   20 +++++++++++++++++++-
>  1 files changed, 19 insertions(+), 1 deletions(-)
>=20
> diff --git a/v4l2-spec/controls.sgml b/v4l2-spec/controls.sgml
> index 477a970..a675f30 100644
> --- a/v4l2-spec/controls.sgml
> +++ b/v4l2-spec/controls.sgml
> @@ -281,10 +281,28 @@ minimum value disables backlight
> compensation.</entry>
>  <constant>V4L2_COLORFX_SEPIA</constant> (2).</entry>
>  	  </row>
>  	  <row>
> +	    <entry><constant>V4L2_CID_ROTATE</constant></entry>
> +	    <entry>integer</entry>
> +	    <entry>Rotates the image by specified angle. Common angles
> are 90,
> +	    270 and 180. Rotating the image to 90 and 270 will reverse
> the height
> +	    and width of the display window. It is necessary to set
> the new height and
> +	    width of the picture using S_FMT ioctl, see <xref
> linkend=3D"vidioc-g-fmt"> according to
> +	    the rotation angle selected.</entry>
> +	  </row>
> +	  <row>
> +	    <entry><constant>V4L2_CID_BG_COLOR</constant></entry>
> +	    <entry>integer</entry>
> +	    <entry>Sets the background color on the current output
> device.
> +	    Background color needs to be specified in the RGB24
> format. The
> +	    supplied 32 bit value is interpreted as bits 0-7 Red color
> information,
> +	    bits 8-15 Green color information, bits 16-23 Blue color
> +	    information and bits 24-31 must be zero.</entry>
> +	  </row>
> +	  <row>
>  	    <entry><constant>V4L2_CID_LASTP1</constant></entry>
>  	    <entry></entry>
>  	    <entry>End of the predefined control IDs (currently
> -<constant>V4L2_CID_COLORFX</constant> + 1).</entry>
> +<constant>V4L2_CID_BG_COLOR</constant> + 1).</entry>
>  	  </row>
>  	  <row>
>  	    <entry><constant>V4L2_CID_PRIVATE_BASE</constant></entry>
> --
> 1.6.2.4


--_002_19F8576C6E063C45BE387C64729E73940436EEAF51dbde02enttico_
Content-Type: application/octet-stream; name=
	"0001-v4l2-doc-Added-CID_ROTATE-CID_BG_COLOR-control-information.patch"
Content-Description: 0001-v4l2-doc-Added-CID_ROTATE-CID_BG_COLOR-control-information.patch
Content-Disposition: attachment; filename=
	"0001-v4l2-doc-Added-CID_ROTATE-CID_BG_COLOR-control-information.patch";
	size=1959; creation-date="Thu, 29 Oct 2009 11:17:48 GMT";
	modification-date="Thu, 29 Oct 2009 11:17:48 GMT"
Content-Transfer-Encoding: base64

RnJvbSA3MmJhODY0ODdjYTljZGRjZDRhODZhNjMyNTZhNjk1OGJiMDM3YjE5IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBWYWliaGF2IEhpcmVtYXRoIDxodmFpYmhhdkB0aS5jb20+CkRh
dGU6IFRodSwgMjkgT2N0IDIwMDkgMTE6MDg6MTkgKzA1MzAKU3ViamVjdDogW1BBVENIIDEvMV0g
djRsMiBkb2M6IEFkZGVkIENJRF9ST1RBVEUsIENJRF9CR19DT0xPUiBjb250cm9sIGluZm9ybWF0
aW9uCgoKU2lnbmVkLW9mZi1ieTogVmFpYmhhdiBIaXJlbWF0aCA8aHZhaWJoYXZAdGkuY29tPgot
LS0KIHY0bDItc3BlYy9jb250cm9scy5zZ21sIHwgICAyMCArKysrKysrKysrKysrKysrKysrLQog
MSBmaWxlcyBjaGFuZ2VkLCAxOSBpbnNlcnRpb25zKCspLCAxIGRlbGV0aW9ucygtKQoKZGlmZiAt
LWdpdCBhL3Y0bDItc3BlYy9jb250cm9scy5zZ21sIGIvdjRsMi1zcGVjL2NvbnRyb2xzLnNnbWwK
aW5kZXggNDc3YTk3MC4uYTY3NWYzMCAxMDA2NDQKLS0tIGEvdjRsMi1zcGVjL2NvbnRyb2xzLnNn
bWwKKysrIGIvdjRsMi1zcGVjL2NvbnRyb2xzLnNnbWwKQEAgLTI4MSwxMCArMjgxLDI4IEBAIG1p
bmltdW0gdmFsdWUgZGlzYWJsZXMgYmFja2xpZ2h0IGNvbXBlbnNhdGlvbi48L2VudHJ5PgogPGNv
bnN0YW50PlY0TDJfQ09MT1JGWF9TRVBJQTwvY29uc3RhbnQ+ICgyKS48L2VudHJ5PgogCSAgPC9y
b3c+CiAJICA8cm93PgorCSAgICA8ZW50cnk+PGNvbnN0YW50PlY0TDJfQ0lEX1JPVEFURTwvY29u
c3RhbnQ+PC9lbnRyeT4KKwkgICAgPGVudHJ5PmludGVnZXI8L2VudHJ5PgorCSAgICA8ZW50cnk+
Um90YXRlcyB0aGUgaW1hZ2UgYnkgc3BlY2lmaWVkIGFuZ2xlLiBDb21tb24gYW5nbGVzIGFyZSA5
MCwKKwkgICAgMjcwIGFuZCAxODAuIFJvdGF0aW5nIHRoZSBpbWFnZSB0byA5MCBhbmQgMjcwIHdp
bGwgcmV2ZXJzZSB0aGUgaGVpZ2h0CisJICAgIGFuZCB3aWR0aCBvZiB0aGUgZGlzcGxheSB3aW5k
b3cuIEl0IGlzIG5lY2Vzc2FyeSB0byBzZXQgdGhlIG5ldyBoZWlnaHQgYW5kCisJICAgIHdpZHRo
IG9mIHRoZSBwaWN0dXJlIHVzaW5nIFNfRk1UIGlvY3RsLCBzZWUgPHhyZWYgbGlua2VuZD0idmlk
aW9jLWctZm10Ij4gYWNjb3JkaW5nIHRvCisJICAgIHRoZSByb3RhdGlvbiBhbmdsZSBzZWxlY3Rl
ZC48L2VudHJ5PgorCSAgPC9yb3c+CisJICA8cm93PgorCSAgICA8ZW50cnk+PGNvbnN0YW50PlY0
TDJfQ0lEX0JHX0NPTE9SPC9jb25zdGFudD48L2VudHJ5PgorCSAgICA8ZW50cnk+aW50ZWdlcjwv
ZW50cnk+CisJICAgIDxlbnRyeT5TZXRzIHRoZSBiYWNrZ3JvdW5kIGNvbG9yIG9uIHRoZSBjdXJy
ZW50IG91dHB1dCBkZXZpY2UuCisJICAgIEJhY2tncm91bmQgY29sb3IgbmVlZHMgdG8gYmUgc3Bl
Y2lmaWVkIGluIHRoZSBSR0IyNCBmb3JtYXQuIFRoZQorCSAgICBzdXBwbGllZCAzMiBiaXQgdmFs
dWUgaXMgaW50ZXJwcmV0ZWQgYXMgYml0cyAwLTcgUmVkIGNvbG9yIGluZm9ybWF0aW9uLAorCSAg
ICBiaXRzIDgtMTUgR3JlZW4gY29sb3IgaW5mb3JtYXRpb24sIGJpdHMgMTYtMjMgQmx1ZSBjb2xv
cgorCSAgICBpbmZvcm1hdGlvbiBhbmQgYml0cyAyNC0zMSBtdXN0IGJlIHplcm8uPC9lbnRyeT4K
KwkgIDwvcm93PgorCSAgPHJvdz4KIAkgICAgPGVudHJ5Pjxjb25zdGFudD5WNEwyX0NJRF9MQVNU
UDE8L2NvbnN0YW50PjwvZW50cnk+CiAJICAgIDxlbnRyeT48L2VudHJ5PgogCSAgICA8ZW50cnk+
RW5kIG9mIHRoZSBwcmVkZWZpbmVkIGNvbnRyb2wgSURzIChjdXJyZW50bHkKLTxjb25zdGFudD5W
NEwyX0NJRF9DT0xPUkZYPC9jb25zdGFudD4gKyAxKS48L2VudHJ5PgorPGNvbnN0YW50PlY0TDJf
Q0lEX0JHX0NPTE9SPC9jb25zdGFudD4gKyAxKS48L2VudHJ5PgogCSAgPC9yb3c+CiAJICA8cm93
PgogCSAgICA8ZW50cnk+PGNvbnN0YW50PlY0TDJfQ0lEX1BSSVZBVEVfQkFTRTwvY29uc3RhbnQ+
PC9lbnRyeT4KLS0KMS42LjIuNAoK

--_002_19F8576C6E063C45BE387C64729E73940436EEAF51dbde02enttico_--
