Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:54404 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1757337AbcHaMVT (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 31 Aug 2016 08:21:19 -0400
Date: Wed, 31 Aug 2016 14:21:12 +0200
From: Sebastian Reichel <sre@kernel.org>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH 0/5] smiapp cleanups, retry probe if getting clock fails
Message-ID: <20160831122112.2jtdvy54jhq3z2ak@earth>
References: <1472629325-30875-1-git-send-email-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="mfxcy67aza45hxvn"
Content-Disposition: inline
In-Reply-To: <1472629325-30875-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--mfxcy67aza45hxvn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,

On Wed, Aug 31, 2016 at 10:42:00AM +0300, Sakari Ailus wrote:
> These patches contain cleanups for the smiapp driver and return
> -EPROBE_DEFER if getting the clock fails.

Apart from comments on patches 3 & 5 the patchset is

Reviewed-By: Sebastian Reichel <sre@kernel.org>

-- Sebastian

--mfxcy67aza45hxvn
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCgAGBQJXxsu4AAoJENju1/PIO/qayWEQAKUi/z0twBL7dw6XFmP2xhtQ
vRLLfj0rOMT0J84QgeSvRgMtLQPOs1uy9bcC8CdULSg6FsznLMnn2rHFjqZSCNUH
E4NprfR+2VTD2l5st3OQ2NNnz6ISHimFWNDs7OXlTge97cjiN0qrzD2rMspmCgFM
mEB+NpdkhsqtD/Qzp+g9NbyCqvRthnJIqxsHJp72bhNi+cMSHUB12L/1KEbipQRo
oerF1AvN9cLWvT2dQJOFnYkSk6s3M6ULb5wxxoR82sMrg0Oz5lrwcAycopyEpzSR
ALeWU2gaB6iYK7FLe2Ckn7BoFEsLhbjmDunBmrpdYedx0ueb5JcxlQ/rHX3Tzw7F
1Ou0GWpnH8y5KbWA/A7T2knarN6pr6XU7UakXGmVqFVRhT8/lIvMAF0FjQJnlUc3
hV0uCM1DHTTBbCrHW0lkSVd6IdyqGyWDz0upwBCi+ClJ0hAYZFvU/Jmj+hf42HWv
pjCEdTqzfF3EmsARM1MFa1AjN7al0AYYmgGLJtYoAW4reWMI9JWvU10EmJ13aNG6
rRjNvnCMBncu7YP52k7xyJ/eAy+p11tvucw2dSef/SvXDBOcvMphIEHE83IlNtAD
tD2EbSvkRolNhkB8WWFt05/LQ94TYgQ4hbJfvXrbYOsowvBM804Acu2TcXk/LF10
jbhRbFsTF9Lp+Fy1Bx07
=7qaz
-----END PGP SIGNATURE-----

--mfxcy67aza45hxvn--
