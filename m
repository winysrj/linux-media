Return-path: <linux-media-owner@vger.kernel.org>
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:55106 "EHLO
        mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751723AbdBOMPu (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 15 Feb 2017 07:15:50 -0500
Date: Wed, 15 Feb 2017 12:15:26 +0000
From: Mark Brown <broonie@kernel.org>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Linaro Kernel Mailman List <linaro-kernel@lists.linaro.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Laura Abbott <labbott@redhat.com>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "Clark, Rob" <robdclark@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <20170215121526.ixtsms7fi4yps5yq@sirena.org.uk>
References: <1486997106-23277-1-git-send-email-benjamin.gaignard@linaro.org>
 <1967325.JRFDDRuil3@avalon>
 <CAKMK7uEoC6vrx-Yi0K0bFaPRctRNLmjgYrZN4thmX6a3Y0KU3A@mail.gmail.com>
 <2684010.GP2h2R50oJ@avalon>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="l2vbm3amjtzaufnd"
Content-Disposition: inline
In-Reply-To: <2684010.GP2h2R50oJ@avalon>
Subject: Re: [RFC simple allocator v2 1/2] Create Simple Allocator module
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--l2vbm3amjtzaufnd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Feb 14, 2017 at 09:59:55PM +0200, Laurent Pinchart wrote:
> On Tuesday 14 Feb 2017 20:44:44 Daniel Vetter wrote:

> > ADF was probably the best example in this. KMS also took a while until =
all
> > the fbdev wheels have been properly reinvented (some are still the same=
 old
> > squeaky onces as fbdev had, e.g. fbcon).

> > And I don't think destaging ION is going to be hard, just a bit of
> > work (could be a nice gsoc or whatever).

> Oh, technically speaking, it would be pretty simple. The main issue is to=
=20
> decide whether we want to commit to the existing ION API. I don't :-)

Right, we need to figure out what people should be doing and let them
work on it.  At the minute anyone who wants to use this stuff in
mainline is kind of stuck as attempts to add ION drivers get pushback

   https://lkml.org/lkml/2016/11/7/806

but so do attempts to do something different (there was a statement in
that thread that new ION drivers could be added if we could ever figure
out bindings but I'm not sure there's any prospect of that).  There's no
clear direction for people to follow if they want to make progress.

--l2vbm3amjtzaufnd
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAlikRl0ACgkQJNaLcl1U
h9CCzwf/fKA2jmq1iGuNtrqJrA/qjCSB88p901pJwN+ftGx6s3qwV/XqHJwE3acy
jV0In7/1IiYnnpK1nCd9cUPILwPNTGb60RrvvWCH8kgeMC/++DZ4usWGDIS2m/Hh
gRvsr/ktFZaipU7EBlMe44pmJHn+JxWz+OVFeWeJmqnHbrFv6ln0zP3UDv0xeE1B
6oUJAKLw6I9haUDmTX7m5y2lSFVeNV10ow7siA9cn5BFFgdLEdbYOppQJ1FbZLlW
DKY2iQWWqq1hPld61LKrjxgMEi20vijpNZc37DwP8sxJ/Kg1H0Fc1BuHJMGIdtc4
0Jo6q5ek0BiabIpxd3vdCb2tt5yhEA==
=l2qZ
-----END PGP SIGNATURE-----

--l2vbm3amjtzaufnd--
