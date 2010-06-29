Return-path: <linux-media-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:35239 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756223Ab0F2WNw (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 29 Jun 2010 18:13:52 -0400
From: "Aguirre, Sergio" <saaguirre@ti.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Date: Tue, 29 Jun 2010 17:13:43 -0500
Subject: RE: [media-ctl] [omap3camera:devel] How to use the app?
Message-ID: <A24693684029E5489D1D202277BE8944562E943A@dlee02.ent.ti.com>
References: <A24693684029E5489D1D202277BE8944562E8B71@dlee02.ent.ti.com>
 <201006291222.47159.laurent.pinchart@ideasonboard.com>
In-Reply-To: <201006291222.47159.laurent.pinchart@ideasonboard.com>
Content-Language: en-US
Content-Type: multipart/mixed;
	boundary="_002_A24693684029E5489D1D202277BE8944562E943Adlee02entticom_"
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--_002_A24693684029E5489D1D202277BE8944562E943Adlee02entticom_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Hi Laurent,

> -----Original Message-----
> From: Laurent Pinchart [mailto:laurent.pinchart@ideasonboard.com]
> Sent: Tuesday, June 29, 2010 5:23 AM
> To: Aguirre, Sergio
> Cc: Sakari Ailus; linux-media@vger.kernel.org
> Subject: Re: [media-ctl] [omap3camera:devel] How to use the app?
>=20
> Hi Sergio,
>=20
> On Tuesday 29 June 2010 01:34:01 Aguirre, Sergio wrote:
> > Hi Laurent/Sakari,
> >
> > I have been attempting to migrate my IMX046 sensor driver, that I had
> > working on my Zoom3(OMAP3630 ES1.1) with older codebase, to work with
> the
> > latest omap3camera tree, 'devel' branch:
> >
> > http://gitorious.org/omap3camera/mainline/commits/devel
> >
> > And for that, I'm trying to also understand how to use your test tool:
> > "media-ctl":
> >
> > http://git.ideasonboard.org/?p=3Dmedia-ctl.git;a=3Dsummary
> >
> > Now, the thing is that, I don't see any guide to learn how to write the
> > Proper format for some of the parameters, like to build links in
> > interactive mode (-i), or to set formats (-f).
> >
> > Can you please detail about a typical usage for this tool? (example on
> how
> > to build a link, set link format, etc.)
>=20
> I've pushed a new patch to the media-ctl repository that makes the help
> message a bit more verbose when running media-ctl -h. It describes the
> links
> and formats as follows:
>=20
> Links and formats are defined as
> 	link            =3D pad, '->', pad, '[', flags, ']' ;
> 	format          =3D pad, '[', fcc, ' ', size, [ ' ', crop ], ']' ;
> 	pad             =3D entity, ':', pad number ;
> 	entity          =3D entity number | ( '\"', entity name, '\"' ) ;
> 	size            =3D width, 'x', height ;
> 	crop            =3D left, ',', top, '/', size ;
> where the fields are
> 	entity number   Entity numeric identifier
> 	entity name     Entify name (string)
> 	pad number      Pad numeric identifier
> 	flags           Link flags (0: inactive, 1: active)
> 	fcc             Format FourCC
> 	width           Image width in pixels
> 	height          Image height in pixels
>=20
> For instance, to set the CCDC to preview link as active, the link
> specifier
> would be
>=20
> '"OMAP3 ISP CCDC":2 -> "OMAP3 ISP preview":0 [1]'
>=20
> To set the format on the preview output pad to YUYV 1280x720, the format
> specifier would be
>=20
> '"OMAP3 ISP preview":2 [YUYV 1280x720]'
>=20
> Spaces are optional.

Thanks a lot for the explanation, and for the verbose help patch!
That's much better :)

>=20
> > So far, my progress is pushed into this branch:
> >
> > http://dev.omapzoom.org/?p=3Dsaaguirre/linux-omap-
> camera.git;a=3Dshortlog;h=3Dref
> > s/heads/mc_migration_wip
>=20
> Thanks for the link.
>=20
> > And with that, after I boot, I get the following topology:
>=20
> [snip]
>=20
> You will find a set of patches that remove the legacy video nodes attache=
d
> to
> this e-mail. They haven't been applied to the omap3camera tree yet, as we
> still haven't fixed all userspace components yet, but they should get
> there in
> a few weeks hopefully. You should probably apply them to your tree to mak=
e
> sure you don't start using the legacy video nodes by mistake. They also
> remove
> a lot of code, which is always good, and remove the hardcoded number of
> sensors.

I had following compilation error:

drivers/media/video/isp/ispvideo.c: In function 'isp_video_streamon':
drivers/media/video/isp/ispvideo.c:780: error: 'const struct isp_video_oper=
ations' has no member named 'stream_off'
drivers/media/video/isp/ispvideo.c:781: error: 'const struct isp_video_oper=
ations' has no member named 'stream_off'
make[4]: *** [drivers/media/video/isp/ispvideo.o] Error 1
make[3]: *** [drivers/media/video/isp] Error 2
make[3]: *** Waiting for unfinished jobs....
make[2]: *** [drivers/media/video] Error 2
make[1]: *** [drivers/media] Error 2
make: *** [drivers] Error 2

Which I solved with the attached patch. You might want to squash it with yo=
ur patch "omap3isp: video: Remove the init, cleanup and stream_off operatio=
ns"

I'll continue trying to bring up my sensor, and let you know if I have othe=
r query.

Thanks for your time!

Regards,
Sergio

>=20
> --
> Regards,
>=20
> Laurent Pinchart

--_002_A24693684029E5489D1D202277BE8944562E943Adlee02entticom_
Content-Type: application/octet-stream;
	name="0001-SQUASH-omap3isp-video-Remove-the-init-cleanup-and-st.patch"
Content-Description: 0001-SQUASH-omap3isp-video-Remove-the-init-cleanup-and-st.patch
Content-Disposition: attachment;
	filename="0001-SQUASH-omap3isp-video-Remove-the-init-cleanup-and-st.patch";
	size=1121; creation-date="Tue, 29 Jun 2010 17:07:39 GMT";
	modification-date="Tue, 29 Jun 2010 17:07:39 GMT"
Content-Transfer-Encoding: base64

RnJvbSBlNDYwNzRhNmY5MDhhOTUwYzg4YzZmNWMxOTM2ZjYwOTI1MTYyZGFmIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTZXJnaW8gQWd1aXJyZSA8c2FhZ3VpcnJlQHRpLmNvbT4KRGF0
ZTogVHVlLCAyOSBKdW4gMjAxMCAxNzowMToxMSAtMDUwMApTdWJqZWN0OiBbUEFUQ0hdIFNRVUFT
SDogb21hcDNpc3A6IHZpZGVvOiBSZW1vdmUgdGhlIGluaXQsIGNsZWFudXAgYW5kIHN0cmVhbV9v
ZmYgb3BlcmF0aW9ucwoKU2lnbmVkLW9mZi1ieTogU2VyZ2lvIEFndWlycmUgPHNhYWd1aXJyZUB0
aS5jb20+Ci0tLQogZHJpdmVycy9tZWRpYS92aWRlby9pc3AvaXNwdmlkZW8uYyB8ICAgMTAgKysr
LS0tLS0tLQogMSBmaWxlcyBjaGFuZ2VkLCAzIGluc2VydGlvbnMoKyksIDcgZGVsZXRpb25zKC0p
CgpkaWZmIC0tZ2l0IGEvZHJpdmVycy9tZWRpYS92aWRlby9pc3AvaXNwdmlkZW8uYyBiL2RyaXZl
cnMvbWVkaWEvdmlkZW8vaXNwL2lzcHZpZGVvLmMKaW5kZXggNDA3MzY5Ny4uMzFlZDBmNyAxMDA2
NDQKLS0tIGEvZHJpdmVycy9tZWRpYS92aWRlby9pc3AvaXNwdmlkZW8uYworKysgYi9kcml2ZXJz
L21lZGlhL3ZpZGVvL2lzcC9pc3B2aWRlby5jCkBAIC03NzYsMTMgKzc3Niw5IEBAIGlzcF92aWRl
b19zdHJlYW1vbihzdHJ1Y3QgZmlsZSAqZmlsZSwgdm9pZCAqZmgsIGVudW0gdjRsMl9idWZfdHlw
ZSB0eXBlKQogCX0KIAogCXJldCA9IGlzcF92aWRlb19xdWV1ZV9zdHJlYW1vbigmdmZoLT5xdWV1
ZSk7Ci0JaWYgKHJldCA8IDAgJiYgdmlkZW8tPnBpcGUtPmlucHV0ID09IE5VTEwpIHsKLQkJaWYg
KHZpZGVvLT5vcHMtPnN0cmVhbV9vZmYpCi0JCQl2aWRlby0+b3BzLT5zdHJlYW1fb2ZmKHZpZGVv
KTsKLQkJZWxzZQotCQkJaXNwX3BpcGVsaW5lX3NldF9zdHJlYW0odmlkZW8tPmlzcCwgdmlkZW8s
Ci0JCQkJCQlJU1BfUElQRUxJTkVfU1RSRUFNX1NUT1BQRUQpOwotCX0KKwlpZiAocmV0IDwgMCAm
JiB2aWRlby0+cGlwZS0+aW5wdXQgPT0gTlVMTCkKKwkJaXNwX3BpcGVsaW5lX3NldF9zdHJlYW0o
dmlkZW8tPmlzcCwgdmlkZW8sCisJCQkJCUlTUF9QSVBFTElORV9TVFJFQU1fU1RPUFBFRCk7CiAK
IGVycm9yOgogCWlmIChyZXQgPCAwKSB7Ci0tIAoxLjYuMy4zCgo=

--_002_A24693684029E5489D1D202277BE8944562E943Adlee02entticom_--
