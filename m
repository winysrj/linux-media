Return-path: <linux-media-owner@vger.kernel.org>
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:48062 "EHLO
        mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753088AbcJZLwV (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 26 Oct 2016 07:52:21 -0400
Date: Wed, 26 Oct 2016 12:51:49 +0100
From: Mark Brown <broonie@kernel.org>
To: Todor Tomov <todor.tomov@linaro.org>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        mchehab@osg.samsung.com, hverkuil@xs4all.nl, geert@linux-m68k.org,
        matrandg@cisco.com, sakari.ailus@iki.fi,
        linux-media@vger.kernel.org
Message-ID: <20161026115149.GD17252@sirena.org.uk>
References: <1473326035-25228-1-git-send-email-todor.tomov@linaro.org>
 <1739314.RkalEXrcbu@avalon>
 <5800C80D.4000006@linaro.org>
 <2757849.cqAmgViGfT@avalon>
 <58109035.5030000@linaro.org>
 <5810931B.4070101@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="qXCixuLMVvZDruUh"
Content-Disposition: inline
In-Reply-To: <5810931B.4070101@linaro.org>
Subject: Re: [PATCH v6 2/2] media: Add a driver for the ov5645 camera sensor.
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--qXCixuLMVvZDruUh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 26, 2016 at 02:27:23PM +0300, Todor Tomov wrote:

> And using Mark Brown's correct address...

This is an *enormous* e-mail quoted to multiple levels with top posting
and very little editing which makes it incredibly hard to find any
relevant content.

> >> I believe it should be an API guarantee, otherwise many drivers using =
the bulk=20
> >> API would break. Mark, could you please comment on that ?

> > Ok, let's wait for a response from Mark.

Why would this be guaranteed by the API given that it's not documented
and why would many drivers break?  It's fairly rare for devices other
than SoCs to have strict power on sequencing requirements as it is hard
to achieve in practical systems.

--qXCixuLMVvZDruUh
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBCAAGBQJYEJjUAAoJECTWi3JdVIfQa2YH/3xb8J/RlAnrEflNYpoTBX+4
F6F7tPCrXqxq295yRF3XhGI8vksFKkf/SXnkeAMeWPNJkdxwKhQZxlwIR3AIOVuL
45OzHovphVZ6fKIKd/QtXTQL5L7KQnUijWvd5+WU6l7rBg8p96AMHrv+L8N8+ovz
IsnoETQy78ZaLg7HMvxsBY3TK1Gplk1Vse0gNMWO/UqAaYAoZVaTqPVzE0LpdNhC
c7e5uoEVsHAYbZ5xAMkTb4b4AnpiZ07N28OiCYRFdVGFxrgIBYku8r6PYV8/l6Q8
AK+Gy3CPcaKdCBfHN5aPO8YwNl0thQ0uwiKF5rZLTktSw8NVwDUHMuS5yCq5Se8=
=Ux/I
-----END PGP SIGNATURE-----

--qXCixuLMVvZDruUh--
