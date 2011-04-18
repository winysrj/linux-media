Return-path: <mchehab@pedra>
Received: from smtp205.alice.it ([82.57.200.101]:56104 "EHLO smtp205.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753507Ab1DRKZ6 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Apr 2011 06:25:58 -0400
Date: Mon, 18 Apr 2011 12:25:40 +0200
From: Antonio Ospite <ospite@studenti.unina.it>
To: Hans de Goede <hdegoede@redhat.com>
Cc: linux-media@vger.kernel.org, Steven Toth <stoth@kernellabs.com>
Subject: Re: [RFC, PATCH] libv4lconvert: Add support for Y10B grey format
 (V4L2_PIX_FMT_Y10BPACK)
Message-Id: <20110418122540.dbbe9b06.ospite@studenti.unina.it>
In-Reply-To: <4DA36D98.40607@redhat.com>
References: <1302192989-7747-1-git-send-email-ospite@studenti.unina.it>
	<4DA36D98.40607@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__18_Apr_2011_12_25_40_+0200_YsmsvZxCbB91DqQn"
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

--Signature=_Mon__18_Apr_2011_12_25_40_+0200_YsmsvZxCbB91DqQn
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, 11 Apr 2011 23:07:36 +0200
Hans de Goede <hdegoede@redhat.com> wrote:

[...]
> > I don't know libv4l yet, so I am asking for advice providing some code =
to
> > discuss on; looking at the last hunk of the patch: can I allocate a tem=
porary
> > buffer only once per device (and not per frame as I am horribly doing n=
ow) and
> > reuse it in the conversion routines?
>=20
> libv4l has a mechanism for doing this, you can "simply" do:
>=20
> unpacked_buffer =3D v4lconvert_alloc_buffer(width * height * sizeof(unsig=
ned short),
>                                            &data->convert_pixfmt_buf,
>                                            &data->convert_pixfmt_buf_size=
);
>=20
> v4lconvert_alloc_buffer will remember the buffer (and its size) and retur=
n the
> same buffer each call. Freeing it on closing of the device is also taken =
care
> of. You should still check for a NULL return.
>

Thanks that works fine: I am still not sure I like passing=20
'v4l2convert_data' to the pixelformat conversion routines but we'll=20
discuss that on the next review round.

> What has me worried more, is how libv4l will decide between asking
> Y10B grey versus raw bayer from the device when an app is asking for say =
RGB24.
> libv4l normally does this automatically on a best match basis (together w=
ith
> preferring compressed formats over uncompressed for high resolutions). Bu=
t this
> won't work in the kinect case. If we prioritize one over the other we will
> always end up giving the app the one we prioritize.
>

Mmh, I tried to materialize your worries, these are the native modes=20
supported:
  - GRBG mode at 640x480 and 1280x1024
  - UYVY mode ay 640x480
  - Y10B mode at 640x488 and 1280x1024
                       ^

and this is the behavior I am observing in qv4l2 when in _wrapped_ mode:
  - If I choose the RGB3 output format all the three different
    resolutions are selectable:
      + at 640x480 I get the color image, as there is no greyscale=20
        format at the same resolution,
      + at 640x488 I get the grayscale image, as there is no color=20
        format at the same resolution,
      + if I choose 1280x1024 I get the grayscale image indeed, and I=20
        loose the possibility of using the color image.

Everything works fine in _raw_ mode of course where only the native
formats are shown.

Ah, a strange thing (to me at least) happens in _wrapped_ mode even for=20
GRBG (which is supposed to be a _native_ color format for the device):
I get the grayscale image at 1280x1024 instead of the color image; can=20
this just be a bug somewhere in qv4l2 or lib4vl?

> The only thing I can think of is adding a v4l2 control (like a brightness
> control) for choosing which format to prioritize...
>

and this control would be created by libv4l when in wrapped mode?

Thanks,
   Antonio

--=20
Antonio Ospite
http://ao2.it

PGP public key ID: 0x4553B001

A: Because it messes up the order in which people normally read text.
   See http://en.wikipedia.org/wiki/Posting_style
Q: Why is top-posting such a bad thing?

--Signature=_Mon__18_Apr_2011_12_25_40_+0200_YsmsvZxCbB91DqQn
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk2sEaQACgkQ5xr2akVTsAEzogCfZNijeVDFrBbykw7DYeCWTklW
4EAAn39KGq5F9QNxMaiRXqhOhOYhCtoQ
=2yfN
-----END PGP SIGNATURE-----

--Signature=_Mon__18_Apr_2011_12_25_40_+0200_YsmsvZxCbB91DqQn--
