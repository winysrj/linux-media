Return-path: <video4linux-list-bounces@redhat.com>
From: Olivier Lorin <o.lorin@laposte.net>
To: Adam Baker <linux@baker-net.org.uk>, video4linux-list@redhat.com,
	linux-media@vger.kernel.org, Hans de Goede <j.w.r.degoede@hhs.nl>,
	kilgota@banach.math.auburn.edu
Message-ID: <10881714.65429.1232146611248.JavaMail.www@wwinf8219>
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_Part_65427_8766806.1232146611247"
Date: Fri, 16 Jan 2009 23:56:51 +0100 (CET)
Cc: 
Subject: Re: RFC: Where to store camera properties (upside down, needs sw
 whitebalance, etc). ?
Reply-To: Olivier Lorin <o.lorin@laposte.net>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <linux-media.vger.kernel.org>


------=_Part_65427_8766806.1232146611247
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

> <snip discussion of cameras needing image flipping capability in libv4l>
> > The use of the buffer flags makes the life easier as this flag
> > is read for every image. So we can solve for the flip/rotation
> > issues with the help of two new buffer flags: V4L2_BUF_FLAG_NEEDS_HFLIP
> > and V4L2_BUF_FLAG_NEEDS_VFLIP.
> >
> > A driver has to set them properly. Does the rotation or flip(s)
> > apply to every image (e.g. sensor upside down) or change with frames
> > (e.g. Genesys webcams), that no more matters .
> > I can do the patch these days.
> > I do not remember if there is h/v flip functions in the libv4l,
> > maybe they have to be added.
> >
> > Regards,
> > Nol
>=20
> That sounds like a sensible approach. The flip code is already in libv4l =
 but=20
> is currently controlled by a static table (v4lconvert_flags) of cameras t=
hat=20
> need it.
>=20
> It doesn't address the issue of whether libv4l should also provide gamma=
=20
> adjustment, auto white balance and auto gain for cameras that could benef=
it=20
> from it. Again that could be done with a static table but keeping the=20
> knowledge in libv4l in step with the list of supported cameras in the ker=
nel=20
> won't be easy.
>=20
> Adam

For sure the use of buffer flag copes only with the need of 180 deg rotatio=
n=20
(and also hflip or vflip but it is not yet part of libv4l).=20
And once again it handles as well constant orientation status as variable o=
ne=20
as the buffer flag value is requested every image.
Moreover this does not require the maintenance of the static table and need=
s=20
only two new V4L2_BUF_FLAGs.
Post gamma or white balance correction seemed to be more part of the webcam=
=20
capabilities than the image state so that the new API to get these features=
=20
is quite logical.=20

I join a patch to make libv4l-0.5.8 handles 180 degrees image rotation with=
=20
buffer flags. It could be extended to manage hflip and vflip with the addit=
ion=20
of corresponding functions in flip.c.

Nol

 Cr=C3=A9ez votre adresse =C3=A9lectronique prenom.nom@laposte.net=20
 1 Go d'espace de stockage, anti-spam et anti-virus int=C3=A9gr=C3=A9s.

------=_Part_65427_8766806.1232146611247
Content-Type: text/x-diff; name=patch_libv4l_UpsideDown-0.5.8.diff
content-transfer-encoding: base64
Content-Disposition: attachment; size=2017;
	filename=patch_libv4l_UpsideDown-0.5.8.diff

ZGlmZiAtY3IgbGlidjRsLTAuNS44L2xpYnY0bDIvbGlidjRsMi5jIG52X2xpYnY0bC0wLjUuOC9s
aWJ2NGwyL2xpYnY0bDIuYwoqKiogbGlidjRsLTAuNS44L2xpYnY0bDIvbGlidjRsMi5jCTIwMDgt
MTItMDIgMjM6Mzk6NDkuMDAwMDAwMDAwICswMTAwCi0tLSBudl9saWJ2NGwtMC41LjgvbGlidjRs
Mi9saWJ2NGwyLmMJMjAwOS0wMS0xNiAyMzoxNDo1Ny4wMDAwMDAwMDAgKzAxMDAKKioqKioqKioq
KioqKioqCioqKiA2OCw3MyAqKioqCi0tLSA2OCw3NCAtLS0tCiAgI2luY2x1ZGUgPHN5cy9zdGF0
Lmg+CiAgI2luY2x1ZGUgImxpYnY0bDIuaCIKICAjaW5jbHVkZSAibGlidjRsMi1wcml2LmgiCisg
I2luY2x1ZGUgIi4uL2xpYnY0bGNvbnZlcnQvbGlidjRsY29udmVydC1wcml2LmgiCiAgCiAgLyog
Tm90ZSB0aGVzZSBmbGFncyBhcmUgc3RvcmVkIHRvZ2V0aGVyIHdpdGggdGhlIGZsYWdzIHBhc3Nl
ZCB0byB2NGwyX2ZkX29wZW4oKQogICAgIGluIHY0bDJfZGV2X2luZm8ncyBmbGFncyBtZW1iZXIs
IHNvIGNhcmUgc2hvdWxkIGJlIHRha2VuIHRoYXQgdGhlIGRvIG5vdAoqKioqKioqKioqKioqKioK
KioqIDc4LDgzICoqKioKLS0tIDc5LDg5IC0tLS0KICAjZGVmaW5lIFY0TDJfU1VQUE9SVFNfUkVB
RAkJMHgwODAwCiAgI2RlZmluZSBWNEwyX0lTX1VWQwkJCTB4MTAwMAogIAorICNpZm5kZWYgVjRM
Ml9CVUZfRkxBR19ORUVEU19IRkxJUAorIAkjZGVmaW5lIFY0TDJfQlVGX0ZMQUdfTkVFRFNfSEZM
SVAgMHg0MDAKKyAJI2RlZmluZSBWNEwyX0JVRl9GTEFHX05FRURTX1ZGTElQIDB4ODAwCisgI2Vu
ZGlmCisgCiAgI2RlZmluZSBWNEwyX01NQVBfT0ZGU0VUX01BR0lDICAgICAgMHhBQkNERUYwMHUK
ICAKICBzdGF0aWMgcHRocmVhZF9tdXRleF90IHY0bDJfb3Blbl9tdXRleCA9IFBUSFJFQURfTVVU
RVhfSU5JVElBTElaRVI7CioqKioqKioqKioqKioqKgoqKiogMjQ5LDI1NCAqKioqCi0tLSAyNTUs
MjY0IC0tLS0KICAgICAgcmV0dXJuIHJlc3VsdDsKICAgIH0KICAKKyAgIC8vIENoZWNrIGZvciB1
cHNpZGUgZG93biBpbWFnZQorICAgaWYgKCAoYnVmLmZsYWdzICYgVjRMMl9CVUZfRkxBR19ORUVE
U19IRkxJUCkgICYmICAoYnVmLmZsYWdzICYgVjRMMl9CVUZfRkxBR19ORUVEU19WRkxJUCkgKSAK
KyAgICAgZGV2aWNlc1tpbmRleF0uY29udmVydC0+ZmxhZ3MgfD0gVjRMQ09OVkVSVF9ST1RBVEVf
MTgwOyAgZWxzZSAgZGV2aWNlc1tpbmRleF0uY29udmVydC0+ZmxhZ3MgJj0gflY0TENPTlZFUlRf
Uk9UQVRFXzE4MDsKKyAKICAgIGRldmljZXNbaW5kZXhdLmZyYW1lX3F1ZXVlZCB8PSAxIDw8IGJ1
ZmZlcl9pbmRleDsKICAgIHJldHVybiAwOwogIH0K
------=_Part_65427_8766806.1232146611247
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
------=_Part_65427_8766806.1232146611247--
