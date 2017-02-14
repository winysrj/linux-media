Return-path: <linux-media-owner@vger.kernel.org>
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:50954 "EHLO
        mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754829AbdBNQqJ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 14 Feb 2017 11:46:09 -0500
Date: Tue, 14 Feb 2017 16:45:39 +0000
From: Mark Brown <broonie@kernel.org>
To: Laura Abbott <labbott@redhat.com>
Cc: Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        linaro-kernel@lists.linaro.org, arnd@arndb.de,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org, daniel.vetter@ffwll.ch,
        laurent.pinchart@ideasonboard.com, robdclark@gmail.com,
        akpm@linux-foundation.org, hverkuil@xs4all.nl
Message-ID: <20170214164539.aifbrbnpj45xlco5@sirena.org.uk>
References: <1486997106-23277-1-git-send-email-benjamin.gaignard@linaro.org>
 <20170213181842.tn3nf7ogrwnzje2p@sirena.org.uk>
 <8d85ac42-9e42-ba1b-9d98-8e08a44572da@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="ca3cbzductlmj3xw"
Content-Disposition: inline
In-Reply-To: <8d85ac42-9e42-ba1b-9d98-8e08a44572da@redhat.com>
Subject: Re: [RFC simple allocator v2 0/2] Simple allocator
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--ca3cbzductlmj3xw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Feb 13, 2017 at 11:01:14AM -0800, Laura Abbott wrote:
> On 02/13/2017 10:18 AM, Mark Brown wrote:

> > The software defined networking people seemed to think they had a use
> > case for this as well.  They're not entirely upstream of course but
> > still...

> This is the first I've heard of anything like this. Do you have any more
> details/reading?

No, unfortunately it was in a meeting and I was asking for more details
on what specifically the hardware was doing myself.  My understanding is
that it's very similar to the GPU/video needs.

--ca3cbzductlmj3xw
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAlijNDIACgkQJNaLcl1U
h9B3lQf7BUa+Dh1H02meI/cTEqRm1tepa5VRX/5rcGCANcapSOHKBSR3fiAxwLGB
+FEPnbzS3UkMemzlNsTmEwVWlcoETmUSM+QbhnVjj8y5q+GeaIPFhKTFYhX4DwlW
2o3eSXdGx+ANjxb+MAadzhdQPdqGh9kWy7cQQM+m+HG/uWC6UlTQVdgIX7lVxi29
fs3IFcwszTxGC6zWxE/FTDUET8UXVOFdOE2qxrZUMC5AsKZJFokuBkOFj4QLZm71
LXDkTshnT3C+nK/rzy0P8lSjC0w1yqVE4ldVD570VJbIUV4lmpjA8ys2AjKdgPmj
36VAlDvR8cs2B1GF6VhweAk9ol6sZw==
=SWXD
-----END PGP SIGNATURE-----

--ca3cbzductlmj3xw--
