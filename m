Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-out113.alice.it ([85.37.17.113]:3252 "EHLO
	smtp-out113.alice.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755772AbZKSKh1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 19 Nov 2009 05:37:27 -0500
Date: Thu, 19 Nov 2009 11:37:19 +0100
From: Antonio Ospite <ospite@studenti.unina.it>
To: Hans de Goede <hdegoede@redhat.com>
Cc: linux-media@vger.kernel.org, Jean-Francois Moine <moinejf@free.fr>
Subject: Re: [RFC, PATCH] gspca: implement vidioc_enum_frameintervals
Message-Id: <20091119113719.566ba78e.ospite@studenti.unina.it>
In-Reply-To: <4B04FCF6.2060505@redhat.com>
References: <20091117114147.09889427.ospite@studenti.unina.it>
	<4B04FCF6.2060505@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__19_Nov_2009_11_37_19_+0100_SarQtaHnqiS2T+H_"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--Signature=_Thu__19_Nov_2009_11_37_19_+0100_SarQtaHnqiS2T+H_
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, 19 Nov 2009 09:08:22 +0100
Hans de Goede <hdegoede@redhat.com> wrote:

> Hi,
>

Hi, thanks for commenting on this.

> On 11/17/2009 11:41 AM, Antonio Ospite wrote:
> > Hi,
> >
> > gspca does not implement vidioc_enum_frameintervals yet, so even if a
> > camera can support multiple frame rates (or frame intervals) there is
> > still no way to enumerate them from userspace.
> >
> > The following is just a quick and dirty implementation to show the
> > problem and to have something to base the discussion on. In the patch
> > there is also a working example of use with the ov534 subdriver.
> >
> > Someone with a better knowledge of gspca and v4l internals can suggest
> > better solutions.
> >
>=20
>=20
> Does the ov534 driver actually support selecting a framerate from the
> list this patch adds, and does it then honor the selection ?
>

Yes it does, it can set framerates as per the list I added (in fact I
got the list looking at what the driver supports), and I can also see
it honors the framerate setting, from guvcview fps counter in the
capture window title. So only framerate enumeration is missing.

> In my experience framerates with webcams are varying all the time, as
> the lighting conditions change and the cam needs to change its exposure
> setting to match, resulting in changed framerates.
>=20
> So to me this does not seem very useful for webcams.
>

As long as the chips involved (bridge, ISP, sensor) are powerful or
smart enough then the camera won't have problems.
I guess that for ov534/ov538 the usb bandwidth is the limiting factor
for the framerates, as we are using a raw format.

> Regards,
>=20
> Hans

Btw, did you take a look at the patch anyway? Can you suggest a better
place where to put the structures needed for this functionality?

Regards,
   Antonio

--=20
Antonio Ospite
http://ao2.it

PGP public key ID: 0x4553B001

A: Because it messes up the order in which people normally read text.
   See http://en.wikipedia.org/wiki/Posting_style
Q: Why is top-posting such a bad thing?
A: Top-posting.
Q: What is the most annoying thing in e-mail?

--Signature=_Thu__19_Nov_2009_11_37_19_+0100_SarQtaHnqiS2T+H_
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAksFH98ACgkQ5xr2akVTsAEQDwCfU3vrg66YysEbKStravJG9K9s
NYEAoIltMu7Ugv7qNWyyy66U2BAByhCJ
=cLGh
-----END PGP SIGNATURE-----

--Signature=_Thu__19_Nov_2009_11_37_19_+0100_SarQtaHnqiS2T+H_--
