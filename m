Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:44190 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751076AbdCAPWr (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 1 Mar 2017 10:22:47 -0500
Message-ID: <1488381666.14858.5.camel@collabora.com>
Subject: Re: [PATCH v6 2/2] [media] s5p-mfc: Handle 'v4l2_pix_format:field'
 in try_fmt and g_fmt
From: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Reply-To: Nicolas Dufresne <nicolas.dufresne@collabora.com>
To: Andrzej Hajda <a.hajda@samsung.com>,
        Thibault Saunier <thibault.saunier@osg.samsung.com>,
        linux-kernel@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kukjin Kim <kgene@kernel.org>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Andi Shyti <andi.shyti@samsung.com>,
        linux-media@vger.kernel.org, Shuah Khan <shuahkh@osg.samsung.com>,
        Javier Martinez Canillas <javier@osg.samsung.com>,
        linux-samsung-soc@vger.kernel.org,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Inki Dae <inki.dae@samsung.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        linux-arm-kernel@lists.infradead.org,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Jeongtae Park <jtp.park@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Kamil Debski <kamil@wypas.org>
Date: Wed, 01 Mar 2017 10:21:06 -0500
In-Reply-To: <33dbd3fa-04b2-3d94-5163-0a10589ff1c7@samsung.com>
References: <20170301115108.14187-1-thibault.saunier@osg.samsung.com>
         <CGME20170301115141epcas2p37801b1fbe0951cc37a4e01bf2bcae3da@epcas2p3.samsung.com>
         <20170301115108.14187-3-thibault.saunier@osg.samsung.com>
         <33dbd3fa-04b2-3d94-5163-0a10589ff1c7@samsung.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
        boundary="=-5KLx2Z2sFaHo8dfK52QR"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-5KLx2Z2sFaHo8dfK52QR
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Le mercredi 01 mars 2017 =C3=A0 14:12 +0100, Andrzej Hajda a =C3=A9crit=C2=
=A0:
> - on output side you have encoded bytestream - you cannot say about
> interlacing in such case, so the only valid value is NONE,
> - on capture side you have decoded frames, and in this case it
> depends
> on the device and driver capabilities, if the driver/device does not
> support (de-)interlacing (I suppose this is MFC case), interlace type
> field should be filled according to decoded bytestream header (on
> output
> side), but no direct copying from output side!!!

I think we need some nuance here for this to actually be usable. If the
information is not provided by the driver (yes, hardware is limiting
sometimes), it would make sense to copy over the information that
userspace provided. Setting NONE is just the worst approximation in my
opinion.

About MFC, it will be worth trying to read the DISPLAY_STATUS after the
headers has been processed. It's not clearly stated in the spec if this
will be set or not.

Nicolas
--=-5KLx2Z2sFaHo8dfK52QR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iEYEABECAAYFAli25uIACgkQcVMCLawGqBx/NACfdRcqUkYfV6LuBaShllkq7XMd
ntAAn0UbeFhdrIQCyUame0/p+0d2UwnI
=Vexr
-----END PGP SIGNATURE-----

--=-5KLx2Z2sFaHo8dfK52QR--
