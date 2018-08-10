Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay1-d.mail.gandi.net ([217.70.183.193]:51623 "EHLO
        relay1-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727422AbeHJKBY (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 10 Aug 2018 06:01:24 -0400
Date: Fri, 10 Aug 2018 09:32:40 +0200
From: jacopo mondi <jacopo@jmondi.org>
To: petrcvekcz@gmail.com
Cc: marek.vasut@gmail.com, mchehab@kernel.org,
        linux-media@vger.kernel.org, robert.jarzmik@free.fr,
        slapin@ossfans.org, philipp.zabel@gmail.com
Subject: Re: [PATCH v1 1/5] [media] soc_camera: ov9640: move ov9640 out of
 soc_camera
Message-ID: <20180810073240.GB7060@w540>
References: <cover.1533774451.git.petrcvekcz@gmail.com>
 <3852f6ed6544bfa3d8d0850b993190094eb09999.1533774451.git.petrcvekcz@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="kORqDWCi7qDJ0mEj"
Content-Disposition: inline
In-Reply-To: <3852f6ed6544bfa3d8d0850b993190094eb09999.1533774451.git.petrcvekcz@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--kORqDWCi7qDJ0mEj
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

Hi Petr,
   thanks for the patches,

On Thu, Aug 09, 2018 at 03:39:45AM +0200, petrcvekcz@gmail.com wrote:
> From: Petr Cvek <petrcvekcz@gmail.com>
>
> Initial part of ov9640 transition from soc_camera subsystem to a standalone
> v4l2 subdevice.
>
> Signed-off-by: Petr Cvek <petrcvekcz@gmail.com>
> ---
>  drivers/media/i2c/{soc_camera => }/ov9640.c | 0
>  drivers/media/i2c/{soc_camera => }/ov9640.h | 0
>  2 files changed, 0 insertions(+), 0 deletions(-)
>  rename drivers/media/i2c/{soc_camera => }/ov9640.c (100%)
>  rename drivers/media/i2c/{soc_camera => }/ov9640.h (100%)
>
> diff --git a/drivers/media/i2c/soc_camera/ov9640.c b/drivers/media/i2c/ov9640.c
> similarity index 100%
> rename from drivers/media/i2c/soc_camera/ov9640.c
> rename to drivers/media/i2c/ov9640.c
> diff --git a/drivers/media/i2c/soc_camera/ov9640.h b/drivers/media/i2c/ov9640.h
> similarity index 100%
> rename from drivers/media/i2c/soc_camera/ov9640.h
> rename to drivers/media/i2c/ov9640.h

When I've been recently doing the same for ov772x and other sensor
driver I've been suggested to first copy the driver into
drivers/media/i2c/ and leave the original soc_camera one there, so
they can be bulk removed or moved to staging. I'll let Hans confirm
this, as he's about to take care of this process.

Thanks
   j

> --
> 2.18.0
>

--kORqDWCi7qDJ0mEj
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJbbT+YAAoJEHI0Bo8WoVY8+XEP/RXbWl3kijZ4F3AWba2WJSDF
g3Hz3Z7n4F1zqxKxOzaEYyPahLV9iZMfho3wPAzpoZ9J4GkHKMOVtxSaMYmunEqf
WmeYjHn9DyYIR9B/4X/ZXfHGhoKgB7yzs1SWU2ziOmKbu3cHEJg9tmKdEJNX93sV
n3ARfYededhMv8+o9svWZ89ryGSNxIi7XaqEwxvLY/IjJJtJ25n+JDwuposZnkrN
HLUkEmB0TRnbGWausUlJqnlRyvbub+UbM1V47pj4mXIEIIJ0cu+0xLqoSUwEW1Mp
53ubZgfoNIOIbErJuf1cSCqfcWNhKGYtpkizC+nDRD6NwduxOPpFAO/UvBJHuBjv
dhhvVqyiJfqX+ykm/pBvafbBhaW/BgEPU5ZCvLVPRRiE1H1U3TBOETZkzUMQdpUa
2RdyIpKTpWx2pYlZbwnE6XCqxZCaG/Is0yNjHgZkHfAGK6nnBpvwA1sUyHSPp4B5
MbHic6QJ43qKLLAeAd9Hc+hgwvUfFntfWNqnqoUvl5UzH6TBVDpdmDhgLmw0JoXm
rsIv9clpbvnfB5yMLUuhvUxWS34KnNjBGGseFJMqDp2nIP5Nlz+pwWs6dBz6Kuvm
cMhZCSJFGjYc8oKnInr1oHadgHoMjHCGO63gKEZF7dO6rpYjAQ2hc6ZhjgD2Vz3c
c2Q9oDkwur1sC/bNrlAn
=dMzv
-----END PGP SIGNATURE-----

--kORqDWCi7qDJ0mEj--
