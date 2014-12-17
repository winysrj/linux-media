Return-path: <linux-media-owner@vger.kernel.org>
Received: from rcdn-iport-5.cisco.com ([173.37.86.76]:47905 "EHLO
	rcdn-iport-5.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750995AbaLQTLf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Dec 2014 14:11:35 -0500
From: "Prashant Laddha (prladdha)" <prladdha@cisco.com>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
CC: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Hans de Goede <hdegoede@redhat.com>,
	"linux-input@vger.kernel.org" <linux-input@vger.kernel.org>
Subject: Re: [RFC PATCHv2] fixp-arith: replace sin/cos table by a better
 precision one
Date: Wed, 17 Dec 2014 19:11:33 +0000
Message-ID: <D0B7BE4F.27E4A%prladdha@cisco.com>
In-Reply-To: <10bb48a8efd28edbd9fea365fe8785e86331f8d2.1418823631.git.mchehab@osg.samsung.com>
Content-Language: en-US
Content-Type: multipart/mixed;
	boundary="_002_D0B7BE4F27E4Aprladdhaciscocom_"
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--_002_D0B7BE4F27E4Aprladdhaciscocom_
Content-Type: text/plain; charset="us-ascii"
Content-ID: <076F75411BFBCD4199DB54C8A5C1F6B1@emea.cisco.com>
Content-Transfer-Encoding: quoted-printable

Hi Mauro,

I was able to test your patch with vivid sdr tone generation. It calls
sin/cos functions with radians as argument. I find that the sine wave
generated using fixp_sin32_rad() show discontinuities, especially around
90, 180 degrees. After debugging it further, these discontinuities seems
to be originating due to division of negative number. Please find it below

On 17/12/14 7:12 pm, "Mauro Carvalho Chehab" <mchehab@osg.samsung.com>
wrote:

>
>+ */
>+static inline s32 fixp_sin32_rad(u32 radians, u32 twopi)
> {
>+	int degrees;
>+	s32 v1, v2, dx, dy;
>+	s64 tmp;
>+	degrees =3D (radians * 360) / twopi;

Not sure if we should use higher precision here. But just a question - in
case, caller function uses higher precision for representing radians,
(radians * 360) can probably overflow, right ? So, could we possibly
specify on max precision for representing radian fraction cannot be more
than 18 bits.=20

>+	v1 =3D fixp_sin32(degrees);
>+	v2 =3D fixp_sin32(degrees + 1);
>+	dx =3D twopi / 360;
>+	dy =3D v2 - v1;
>+	tmp =3D radians - (degrees * twopi) / 360;

Same as above.

>+	tmp *=3D dy;
>+	do_div(tmp, dx);

tmp can go negative. do_div() cannot handle negative number. We could
probably avoid do_div and do tmp / dx here. If we want to use do_div(), we
could still do it by modifying radian to degree calculation.

tmp goes negative when the slope sine waveform is negative, that is 2nd
and 3rd quadrant. We could avoid it by deciding the quadrant based on
radians and then calling fixp_sin32(). I modified the function on lines of
fixp_sin32() and tested. It works fine. Attaching a diff for fixp-arith.h
for with the this change to avoid negative values of tmp in
fixp_sin32_rad().

>2.1.0
>


--_002_D0B7BE4F27E4Aprladdhaciscocom_
Content-Type: application/octet-stream; name="fixp-arith.diff"
Content-Description: fixp-arith.diff
Content-Disposition: attachment; filename="fixp-arith.diff"; size=5055;
	creation-date="Wed, 17 Dec 2014 19:11:33 GMT";
	modification-date="Wed, 17 Dec 2014 19:11:33 GMT"
Content-ID: <E6A59DF2B0D4274BA2266C677D1A4065@emea.cisco.com>
Content-Transfer-Encoding: base64

ZGlmZiAtLWdpdCBhL2luY2x1ZGUvbGludXgvZml4cC1hcml0aC5oIGIvaW5jbHVkZS9saW51eC9m
aXhwLWFyaXRoLmgKaW5kZXggMzA4OWQ3My4uNTk3MzQyOSAxMDA2NDQKLS0tIGEvaW5jbHVkZS9s
aW51eC9maXhwLWFyaXRoLmgKKysrIGIvaW5jbHVkZS9saW51eC9maXhwLWFyaXRoLmgKQEAgLTI5
LDU5ICsyOSwxMTYgQEAKIAogI2luY2x1ZGUgPGxpbnV4L3R5cGVzLmg+CiAKLS8qIFRoZSB0eXBl
IHJlcHJlc2VudGluZyBmaXhlZC1wb2ludCB2YWx1ZXMgKi8KLXR5cGVkZWYgczE2IGZpeHBfdDsK
LQotI2RlZmluZSBGUkFDX04gOAotI2RlZmluZSBGUkFDX01BU0sgKCgxPDxGUkFDX04pLTEpCi0K
LS8qIE5vdCB0byBiZSB1c2VkIGRpcmVjdGx5LiBVc2UgZml4cF97Y29zLHNpbn0gKi8KLXN0YXRp
YyBjb25zdCBmaXhwX3QgY29zX3RhYmxlWzQ2XSA9IHsKLQkweDAxMDAsCTB4MDBGRiwJMHgwMEZG
LAkweDAwRkUsCTB4MDBGRCwJMHgwMEZDLAkweDAwRkEsCTB4MDBGOCwKLQkweDAwRjYsCTB4MDBG
MywJMHgwMEYwLAkweDAwRUQsCTB4MDBFOSwJMHgwMEU2LAkweDAwRTIsCTB4MDBERCwKLQkweDAw
RDksCTB4MDBENCwJMHgwMENGLAkweDAwQzksCTB4MDBDNCwJMHgwMEJFLAkweDAwQjgsCTB4MDBC
MSwKLQkweDAwQUIsCTB4MDBBNCwJMHgwMDlELAkweDAwOTYsCTB4MDA4RiwJMHgwMDg3LAkweDAw
ODAsCTB4MDA3OCwKLQkweDAwNzAsCTB4MDA2OCwJMHgwMDVGLAkweDAwNTcsCTB4MDA0RiwJMHgw
MDQ2LAkweDAwM0QsCTB4MDAzNSwKLQkweDAwMkMsCTB4MDAyMywJMHgwMDFBLAkweDAwMTEsCTB4
MDAwOCwgMHgwMDAwCitzdGF0aWMgY29uc3QgczMyIHNpbl90YWJsZVtdID0geworICAgICAgIDB4
MDAwMDAwMDAsIDB4MDIzYmUxNjUsIDB4MDQ3Nzk2MzIsIDB4MDZiMmYxZDIsIDB4MDhlZGM3YjYs
IDB4MGIyN2ViNWMsCisgICAgICAgMHgwZDYxMzA0ZCwgMHgwZjk5NmEyNiwgMHgxMWQwNmM5Niwg
MHgxNDA2MGI2NywgMHgxNjNhMWE3ZCwgMHgxODZjNmRkZCwKKyAgICAgICAweDFhOWNkOWFjLCAw
eDFjY2IzMjM2LCAweDFlZjc0YmYyLCAweDIxMjBmYjgyLCAweDIzNDgxNWJhLCAweDI1NmM2Zjll
LAorICAgICAgIDB4Mjc4ZGRlNmUsIDB4MjlhYzM3OWYsIDB4MmJjNzUwZTgsIDB4MmRkZjAwM2Ys
IDB4MmZmMzFiZGQsIDB4MzIwMzdhNDQsCisgICAgICAgMHgzNDBmZjI0MSwgMHgzNjE4NWFlZSwg
MHgzODFjOGJiNSwgMHgzYTFjNWM1NiwgMHgzYzE3YTRlNywgMHgzZTBlM2RkYiwKKyAgICAgICAw
eDNmZmZmZmZmLCAweDQxZWNjNDgzLCAweDQzZDQ2NGZhLCAweDQ1YjZiYjVkLCAweDQ3OTNhMjBm
LCAweDQ5NmFmM2UxLAorICAgICAgIDB4NGIzYzhjMTEsIDB4NGQwODQ2NTAsIDB4NGVjZGZlYzYs
IDB4NTA4ZDkyMTAsIDB4NTI0NmRkNDgsIDB4NTNmOWJlMDQsCisgICAgICAgMHg1NWE2MTI1YSwg
MHg1NzRiYjhlNSwgMHg1OGVhOTBjMiwgMHg1YTgyNzk5OSwgMHg1YzEzNTM5OSwgMHg1ZDljZmY4
MiwKKyAgICAgICAweDVmMWY1ZWEwLCAweDYwOWE1MmQxLCAweDYyMGRiZThhLCAweDYzNzk4NGQz
LCAweDY0ZGQ4OTRmLCAweDY2MzliMDM5LAorICAgICAgIDB4Njc4ZGRlNmQsIDB4NjhkOWY5NjMs
IDB4NmExZGU3MzUsIDB4NmI1OThlYTEsIDB4NmM4Y2Q3MGEsIDB4NmRiN2E4NzksCisgICAgICAg
MHg2ZWQ5ZWJhMCwgMHg2ZmYzODlkZSwgMHg3MTA0NmQzYywgMHg3MjBjODA3NCwgMHg3MzBiYWVl
YywgMHg3NDAxZTRiZiwKKyAgICAgICAweDc0ZWYwZWJiLCAweDc1ZDMxYTVmLCAweDc2YWRmNWU1
LCAweDc3N2Y5MDNiLCAweDc4NDdkOTA4LCAweDc5MDZjMGFmLAorICAgICAgIDB4NzliYzM4NGMs
IDB4N2E2ODMxYjgsIDB4N2IwYTlmOGMsIDB4N2JhMzc1MWMsIDB4N2MzMmE2N2MsIDB4N2NiODI4
ODQsCisgICAgICAgMHg3ZDMzZjBjOCwgMHg3ZGE1ZjVhMywgMHg3ZTBlMmUzMSwgMHg3ZTZjOTI0
ZiwgMHg3ZWMxMWFhMywgMHg3ZjBiYzA5NSwKKyAgICAgICAweDdmNGM3ZTUyLCAweDdmODM0ZWNm
LCAweDdmYjAyZGM0LCAweDdmZDMxN2IzLCAweDdmZWMwOWUxLCAweDdmZmIwMjVlLAorICAgICAg
IDB4N2ZmZmZmZmYKIH07CiAKKy8qKgorICogZml4cF9zaW4zMigpIHJldHVybnMgdGhlIHNpbiBv
ZiBhbiBhbmdsZSBpbiBkZWdyZWVzCisgKgorICogQGRlZ3JlZXM6IGFuZ2xlLCBpbiBkZWdyZWVz
LiBJdCBjYW4gYmUgcG9zaXRpdmUgb3IgbmVnYXRpdmUKKyAqCisgKiBUaGUgcmV0dXJuZWQgdmFs
dWUgcmFuZ2VzIGZyb20gLTB4N2ZmZmZmZmYgdG8gKzB4N2ZmZmZmZmYuCisgKi8KIAotLyogYTog
MTIzIC0+IDEyMy4wICovCi1zdGF0aWMgaW5saW5lIGZpeHBfdCBmaXhwX25ldyhzMTYgYSkKK3N0
YXRpYyBpbmxpbmUgczMyIGZpeHBfc2luMzIoaW50IGRlZ3JlZXMpCiB7Ci0JcmV0dXJuIGE8PEZS
QUNfTjsKLX0KKyAgICAgICBzMzIgcmV0OworICAgICAgIGJvb2wgbmVnYXRpdmUgPSBmYWxzZTsK
IAotLyogYTogMHhGRkZGIC0+IC0xLjAKLSAgICAgIDB4ODAwMCAtPiAxLjAKLSAgICAgIDB4MDAw
MCAtPiAwLjAKLSovCi1zdGF0aWMgaW5saW5lIGZpeHBfdCBmaXhwX25ldzE2KHMxNiBhKQotewot
CXJldHVybiAoKHMzMilhKT4+KDE2LUZSQUNfTik7Ci19CisgICAgICAgZGVncmVlcyA9IChkZWdy
ZWVzICUgMzYwICsgMzYwKSAlIDM2MDsKKyAgICAgICBpZiAoZGVncmVlcyA+IDE4MCkgeworICAg
ICAgICAgICAgICAgbmVnYXRpdmUgPSB0cnVlOworICAgICAgICAgICAgICAgZGVncmVlcyAtPSAx
ODA7CisJICAgfQorICAgICAgIGlmIChkZWdyZWVzID4gOTApCisgICAgICAgICAgICAgICBkZWdy
ZWVzID0gMTgwIC0gZGVncmVlczsKIAotc3RhdGljIGlubGluZSBmaXhwX3QgZml4cF9jb3ModW5z
aWduZWQgaW50IGRlZ3JlZXMpCi17Ci0JaW50IHF1YWRyYW50ID0gKGRlZ3JlZXMgLyA5MCkgJiAz
OwotCXVuc2lnbmVkIGludCBpID0gZGVncmVlcyAlIDkwOwotCi0JaWYgKHF1YWRyYW50ID09IDEg
fHwgcXVhZHJhbnQgPT0gMykKLQkJaSA9IDkwIC0gaTsKKyAgICAgICByZXQgPSBzaW5fdGFibGVb
ZGVncmVlc107CiAKLQlpID4+PSAxOworICAgICAgIHJldHVybiBuZWdhdGl2ZSA/IC1yZXQgOiBy
ZXQ7CiAKLQlyZXR1cm4gKHF1YWRyYW50ID09IDEgfHwgcXVhZHJhbnQgPT0gMik/IC1jb3NfdGFi
bGVbaV0gOiBjb3NfdGFibGVbaV07CiB9CiAKLXN0YXRpYyBpbmxpbmUgZml4cF90IGZpeHBfc2lu
KHVuc2lnbmVkIGludCBkZWdyZWVzKQotewotCXJldHVybiAtZml4cF9jb3MoZGVncmVlcyArIDkw
KTsKLX0KKy8qIGNvcyh4KSA9IHNpbih4ICsgOTAgZGVncmVlcykgKi8KKyNkZWZpbmUgZml4cF9j
b3MzMih2KSBmaXhwX3NpbjMyKCh2KSArIDkwKQogCi1zdGF0aWMgaW5saW5lIGZpeHBfdCBmaXhw
X211bHQoZml4cF90IGEsIGZpeHBfdCBiKQorLyoKKyAqIDE2IGJpdHMgdmFyaWFudHMKKyAqCisg
KiBUaGUgcmV0dXJuZWQgdmFsdWUgcmFuZ2VzIGZyb20gLTB4N2ZmZiB0byAweDdmZmYKKyAqLwor
CisjZGVmaW5lIGZpeHBfc2luMTYodikgKGZpeHBfc2luMzIodikgPj4gMTYpCisjZGVmaW5lIGZp
eHBfY29zMTYodikgKGZpeHBfY29zMzIodikgPj4gMTYpCisKKy8qKgorICogZml4cF9zaW4zMl9y
YWQoKSAtIGNhbGN1bGF0ZXMgdGhlIHNpbiBvZiBhbiBhbmdsZSBpbiByYWRpYW5zCisgKgorICog
QHJhZGlhbnM6IGFuZ2xlLCBpbiByYWRpYW5zCisgKiBAdHdvcGk6IHZhbHVlIHRvIGJlIHVzZWQg
Zm9yIDIqcGkKKyAqCisgKiBQcm92aWRlcyBhIHZhcmlhbnQgZm9yIHRoZSBjYXNlcyB3aGVyZSBq
dXN0IDM2MAorICogdmFsdWVzIGlzIG5vdCBlbm91Z2guIFRoaXMgZnVuY3Rpb24gdXNlcyBsaW5l
YXIKKyAqIGludGVycG9sYXRpb24gdG8gYSB3aWRlciByYW5nZSBvZiB2YWx1ZXMgZ2l2ZW4gYnkK
KyAqIHR3b3BpIHZhci4KKyAqCisgKiBFeHBlcmltZW50YWwgdGVzdHMgZ2F2ZSBhIG1heGltdW0g
ZGlmZmVyZW5jZSBvZgorICogMC4wMDAwMzggYmV0d2VlbiB0aGUgdmFsdWUgY2FsY3VsYXRlZCBi
eSBzaW4oKSBhbmQKKyAqIHRoZSBvbmUgcHJvZHVjZWQgYnkgdGhpcyBmdW5jdGlvbiwgd2hlbiB0
d29waSBpcworICogZXF1YWwgdG8gMzYwMDAwLiBUaGF0IHNlZW1zIHRvIGJlIGVub3VnaCBwcmVj
aXNpb24KKyAqIGZvciBwcmFjdGljYWwgcHVycG9zZXMuCisgKi8KK3N0YXRpYyBpbmxpbmUgczMy
IGZpeHBfc2luMzJfcmFkKHUzMiByYWRpYW5zLCB1MzIgdHdvcGkpCiB7Ci0JcmV0dXJuICgoczMy
KShhKmIpKT4+RlJBQ19OOworICAgICAgIGludCBkZWdyZWVzOworICAgICAgIHMzMiB2MSwgdjIs
IGR4LCBkeTsKKyAgICAgICBzNjQgdG1wOworICAgICAgIHUzMiBwaSA9IHR3b3BpIC8gMjsKKyAg
ICAgICBzMzIgcmV0OworICAgICAgIGJvb2wgbmVnYXRpdmUgPSBmYWxzZTsKKworICAgICAgIHJh
ZGlhbnMgPSAocmFkaWFucyAlIHR3b3BpICsgdHdvcGkpICUgdHdvcGk7CisgICAgICAgaWYgKHJh
ZGlhbnMgPiBwaSkgeworICAgICAgICAgICAgICAgbmVnYXRpdmUgPSB0cnVlOworICAgICAgICAg
ICAgICAgcmFkaWFucyAtPSBwaTsKKwkgICB9CisgICAgICAgaWYgKHJhZGlhbnMgPiBwaSAvMikK
KyAgICAgICAgICAgICAgIHJhZGlhbnMgPSBwaSAtIHJhZGlhbnM7CisKKyAgICAgICBkZWdyZWVz
ID0gKHJhZGlhbnMgKiAzNjApIC8gdHdvcGk7CisKKyAgICAgICB2MSA9IGZpeHBfc2luMzIoZGVn
cmVlcyk7CisgICAgICAgdjIgPSBmaXhwX3NpbjMyKGRlZ3JlZXMgKyAxKTsKKworICAgICAgIGR4
ID0gdHdvcGkgLyAzNjA7CisgICAgICAgZHkgPSB2MiAtIHYxOworCisgICAgICAgdG1wID0gcmFk
aWFucyAtIChkZWdyZWVzICogdHdvcGkpIC8gMzYwOworICAgICAgIGRvX2Rpdih0bXAsIGR4KTsK
KyAgICAgICByZXQgPSB2MSArIHRtcDsKKworICAgICAgIHJldHVybiBuZWdhdGl2ZSA/IC1yZXQg
OiByZXQ7CiB9CiAKKy8qIGNvcyh4KSA9IHNpbih4ICsgcGkgLyAyIHJhZGlhbnMpICovCisKKyNk
ZWZpbmUgZml4cF9jb3MzMl9yYWQocmFkLCB0d29waSkgICAgIFwKKyAgICAgICBmaXhwX3NpbjMy
X3JhZChyYWQgKyB0d29waSAvIDQsIHR3b3BpKQorCiAjZW5kaWYK

--_002_D0B7BE4F27E4Aprladdhaciscocom_--
