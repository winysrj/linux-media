Return-path: <linux-media-owner@vger.kernel.org>
Received: from butterbrot.org ([176.9.106.16]:54728 "EHLO butterbrot.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752006AbaLSOa0 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Dec 2014 09:30:26 -0500
Message-ID: <54943680.3020007@butterbrot.org>
Date: Fri, 19 Dec 2014 15:30:24 +0100
From: Florian Echtler <floe@butterbrot.org>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>,
	linux-input <linux-input@vger.kernel.org>,
	linux-media@vger.kernel.org
Subject: Re: [RFC] [Patch] implement video driver for sur40
References: <5492D7E8.504@butterbrot.org> <5492E091.1060404@xs4all.nl>
In-Reply-To: <5492E091.1060404@xs4all.nl>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="MsVvbF7WB0h77CXdGla16it12WeArOUDd"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--MsVvbF7WB0h77CXdGla16it12WeArOUDd
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 18.12.2014 15:11, Hans Verkuil wrote:
> Run as 'v4l2-compliance -s' (-s starts streaming tests as well and it
> assumes you have a valid input signal).
> Mail if you have any questions about the v4l2-compliance output. The fa=
ilure
> messages expect you to look at the v4l2-compliance source code as well,=

> but even than it is not always clear what is going on.
Ran the most recent version from git master, got a total of 6 fails, 4
of which are probably easy fixes:

> fail: v4l2-compliance.cpp(306): missing bus_info prefix ('USB:1')
> test VIDIOC_QUERYCAP: FAIL
Changed the relevant code to:
  usb_make_path(sur40->usbdev, cap->bus_info, sizeof(cap->bus_info));
=09
> fail: v4l2-test-input-output.cpp(455): could set input to invalid input=
 1
> test VIDIOC_G/S/ENUMINPUT: FAIL
Now returning -EINVAL when S_INPUT called with input !=3D 0.

> fail: v4l2-test-formats.cpp(322): !colorspace
> fail: v4l2-test-formats.cpp(429): testColorspace(pix.pixelformat,
pix.colorspace, pix.ycbcr_enc, pix.quantization)
> test VIDIOC_G_FMT: FAIL
Setting colorspace in v4l2_pix_format to V4L2_COLORSPACE_SRGB.=09

> fail: v4l2-compliance.cpp(365): doioctl(node, VIDIOC_G_PRIORITY, &prio)=

> test VIDIOC_G/S_PRIORITY: FAIL
Don't know how to fix this - does this mean VIDIOC_G/S_PRIORITY _must_
be implemented?

> fail: v4l2-test-buffers.cpp(500): q.has_expbuf(node)
> test VIDIOC_EXPBUF: FAIL
Also not clear how to fix this one.

Could you give some hints on the last two?

Thanks & best regards, Florian
--=20
SENT FROM MY DEC VT50 TERMINAL


--MsVvbF7WB0h77CXdGla16it12WeArOUDd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlSUNoAACgkQ7CzyshGvatjGzQCfTS4PinIvHOUuhaBHSMo7sj1J
0AsAn3O5W6DCVcTd2lgv1r1CvJMjGZZe
=xyRr
-----END PGP SIGNATURE-----

--MsVvbF7WB0h77CXdGla16it12WeArOUDd--
