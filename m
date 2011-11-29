Return-path: <linux-media-owner@vger.kernel.org>
Received: from na3sys009aog102.obsmtp.com ([74.125.149.69]:47679 "EHLO
	na3sys009aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754671Ab1K2QNe (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 29 Nov 2011 11:13:34 -0500
Subject: Re: drm pixel formats update
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: dri-devel@lists.freedesktop.org, ville.syrjala@linux.intel.com,
	linux-fbdev@vger.kernel.org, linux-media@vger.kernel.org
In-Reply-To: <201111291310.36589.laurent.pinchart@ideasonboard.com>
References: <1321468945-28224-1-git-send-email-ville.syrjala@linux.intel.com>
	 <201111291310.36589.laurent.pinchart@ideasonboard.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-z3v8gCpLmUyq26DXkzIu"
Date: Tue, 29 Nov 2011 18:13:27 +0200
Message-ID: <1322583207.1869.194.camel@deskari>
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-z3v8gCpLmUyq26DXkzIu
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2011-11-29 at 13:10 +0100, Laurent Pinchart wrote:

> To make it perfectly clear, I want to emphasize that I'm not trying to re=
place=20
> DRM, FBDEV and V4L2 with a new shared subsystem. What I would like to see=
 in=20
> the (near future) is collaboration and sharing of core features that make=
=20
> sense to share. I believe we should address this from a "pain point" poin=
t of=20
> view. The one that lead me to writing this e-mail is that developing a dr=
iver=20
> that implements both the DRM and FBDEV APIs for video output currently=
=20
> requires various similar structures, and code to translate between all of=
=20
> them. That code can't be shared between multiple drivers, is error-prone,=
 and=20
> painful to maintin.

We've been in the same situation with OMAP display driver for years. The
same low level display driver is used by FB, V4L2 and now DRM drivers,
so I didn't have much choice but to implement omapdss versions for
things like video timings and color formats.

I've been planning to write code for this almost as long as omapdss has
had this problem, but there's always been
yet-another-important-thing-to-do. So good that somebody finally brought
this up =3D).

I'm happy to test any code related to this with omapdss.

 Tomi


--=-z3v8gCpLmUyq26DXkzIu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJO1QSnAAoJEPo9qoy8lh71X24P/0XGlVuXd2O0ouJ9bZB2vI+u
ho0VLx7hOZlfyOwa/cJu2dylcSnK86/N9RiRlb/5iyCmqazVeJXhUTvlTiPS30kL
KRgv4ScrNFVfDUHZc3mgH7bI/sXKOi2jXC8dOIiQ9MDLYcpzPWtEW0Wq32Q5uufY
9yztLCQXF8G0DGfyIMjNPNiRbZm8v37YbPG9yRgaiZn8yhAG2eb9vJt7U5xGtYo9
XYhrbKLhwgvyAjjQaPW7OP2huXmUNCf4mT0pI9Y+4hzT5TgCI7qwDCOFzdnSxQEV
s2KBxLP3hUmp+OWKoKUOg3XXZCfEsqh5AMbRSPAaiB/ewyDvQpF8hQYpANTA7C3L
8v02zuKYFyzUj+1BuUtq1yU+UgrFWWf9eJgL28x0gS0Hexz33IBEBq9gdpmPFUzh
Hr0mKWrXIaMZPTTGuqtJma6kccDAXc2ka5Rb1EmAVTCjdrKmQ21o4PeY/uyYfPVW
CP61tkBmt+1RGhJ3qk3vRf6TIwv/Zned8YQunN5ZSSrhSGrFqua3Tec7h7QIIDWM
s3J/A4AndDjkJoTUnSp4ms+muywavtSej9hV5cEuM8mT/K054skIryTMHX+FF2VZ
bwFYcttwFe9gODLwAiWOD/N8oXJnkOCMz+GSBmvyhH7TooK26l5lKguzY3kC1hHl
QQMsX/JYBOA/b6jH3xjz
=mIIU
-----END PGP SIGNATURE-----

--=-z3v8gCpLmUyq26DXkzIu--

