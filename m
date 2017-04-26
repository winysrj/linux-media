Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-io0-f182.google.com ([209.85.223.182]:35885 "EHLO
        mail-io0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753938AbdDZTgH (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 26 Apr 2017 15:36:07 -0400
Received: by mail-io0-f182.google.com with SMTP id p80so9537787iop.3
        for <linux-media@vger.kernel.org>; Wed, 26 Apr 2017 12:36:07 -0700 (PDT)
Message-ID: <1493235364.29587.17.camel@ndufresne.ca>
Subject: Re: [RFC 0/4] Exynos DRM: add Picture Processor extension
From: Nicolas Dufresne <nicolas@ndufresne.ca>
To: Tobias Jakobi <tjakobi@math.uni-bielefeld.de>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        dri-devel@lists.freedesktop.org, linux-samsung-soc@vger.kernel.org,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Seung-Woo Kim <sw0312.kim@samsung.com>,
        Sakari Ailus <sakari.ailus@intel.com>,
        linux-media@vger.kernel.org
Date: Wed, 26 Apr 2017 15:36:04 -0400
In-Reply-To: <d9087a2a-ec14-ef93-9961-30d166d24994@math.uni-bielefeld.de>
References: <CGME20170420091406eucas1p24c50a0015545105081257d880727386c@eucas1p2.samsung.com>
         <1492679620-12792-1-git-send-email-m.szyprowski@samsung.com>
         <2541347.TzHdYYQVhG@avalon>
         <711bf4a5-7e57-6720-d00b-66e97a81e5ec@samsung.com>
         <20170425222124.GA7456@valkosipuli.retiisi.org.uk>
         <1493218407.29587.9.camel@ndufresne.ca>
         <d597e386-4a6d-61d9-8e4b-61926d7a42c2@math.uni-bielefeld.de>
         <1493234339.29587.15.camel@ndufresne.ca>
         <d9087a2a-ec14-ef93-9961-30d166d24994@math.uni-bielefeld.de>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
        boundary="=-J60uOx/mFRponmisUaBT"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-J60uOx/mFRponmisUaBT
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Le mercredi 26 avril 2017 =C3=A0 21:31 +0200, Tobias Jakobi a =C3=A9crit=C2=
=A0:
> I'm pretty sure you have misread Marek's description of the patchset.
> The picture processor API should replaced/deprecate the IPP API that is
> currently implemented in the Exynos DRM.
>=20
> In particular this affects the following files:
> - drivers/gpu/drm/exynos/exynos_drm_ipp.{c,h}
> - drivers/gpu/drm/exynos/exynos_drm_fimc.{c,h}
> - drivers/gpu/drm/exynos/exynos_drm_gsc.{c,h}
> - drivers/gpu/drm/exynos/exynos_drm_rotator.{c,h}
>=20
> I know only two places where the IPP API is actually used. Tizen and my
> experimental mpv backend.

Sorry for the noise then.

regards,
Nicolas
--=-J60uOx/mFRponmisUaBT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iEYEABECAAYFAlkA9qQACgkQcVMCLawGqBwlrwCbB3l7aeO9a13GJuUiGSBYIUPX
4lsAnRTX2dKlZkDoPfCw1X3DgALaMrKD
=ZfUX
-----END PGP SIGNATURE-----

--=-J60uOx/mFRponmisUaBT--
