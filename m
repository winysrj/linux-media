Return-path: <linux-media-owner@vger.kernel.org>
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:42598 "EHLO
        mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750955AbdFBROs (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 2 Jun 2017 13:14:48 -0400
Date: Fri, 2 Jun 2017 18:14:28 +0100
From: Mark Brown <broonie@kernel.org>
To: Takashi Iwai <tiwai@suse.de>
Cc: alsa-devel@alsa-project.org,
        Takashi Sakamoto <o-takashi@sakamocchi.jp>,
        Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        Felipe Balbi <balbi@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org
Message-ID: <20170602171428.6ludtml23vfpcygp@sirena.org.uk>
References: <20170601205850.24993-1-tiwai@suse.de>
 <20170601205850.24993-3-tiwai@suse.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="tkkk7d7hsv6owojv"
Content-Disposition: inline
In-Reply-To: <20170601205850.24993-3-tiwai@suse.de>
Subject: Re: [PATCH v2 02/27] ALSA: pcm: Introduce copy_user, copy_kernel and
 fill_silence ops
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--tkkk7d7hsv6owojv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jun 01, 2017 at 10:58:25PM +0200, Takashi Iwai wrote:
> For supporting the explicit in-kernel copy of PCM buffer data, and
> also for further code refactoring, three new PCM ops, copy_user,
> copy_kernel and fill_silence, are introduced.  The old copy and
> silence ops will be deprecated and removed later once when all callers
> are converted.

Acked-by: Mark Brown <broonie@kernel.org>

--tkkk7d7hsv6owojv
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAlkxnPQACgkQJNaLcl1U
h9C1Ygf+Lf9E11DcpSKgUfS/g8SE5RYlcK5oYhJP/IWFBYAhWt2dgmanzHabGW4a
mWH8IEDT+th1fC4xAempj+Ws58GQWTaEkbThITbV72fcwSL2+6hZKmbUkEm+YTIX
axirqG88s6wlfvgKw79ImhtoFEs5mv0/gmBjq/fxaLBv1VO0xB1/yNSt4ZDng1RQ
IG0faFsM4oJrPCbZQmCsXn35tau0mSc9ujx5MIkVi76HV2mzq08FMvlEhUKyu/Yg
aIR+SUvOU1rKeFqzMtFvk871XYOMJISV5RbM4reNUT6zrjOSansg7i7lka6njLHx
moxQAJgji9LvdiM157WMostMr2uFpw==
=OwXh
-----END PGP SIGNATURE-----

--tkkk7d7hsv6owojv--
