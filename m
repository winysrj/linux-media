Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:37043 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752039AbdEDO1f (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 4 May 2017 10:27:35 -0400
Date: Thu, 4 May 2017 16:27:30 +0200
From: Sebastian Reichel <sebastian.reichel@collabora.co.uk>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        pavel@ucw.cz
Subject: Re: [RFC 1/3] dt: bindings: Add a binding for flash devices
 associated to a sensor
Message-ID: <20170504142730.tq4k3paofmyk5jul@earth>
References: <1493720749-31509-1-git-send-email-sakari.ailus@linux.intel.com>
 <1493720749-31509-2-git-send-email-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="nfnej6heq332xss3"
Content-Disposition: inline
In-Reply-To: <1493720749-31509-2-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--nfnej6heq332xss3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Sakari,

On Tue, May 02, 2017 at 01:25:47PM +0300, Sakari Ailus wrote:
> Camera flash drivers (and LEDs) are separate from the sensor devices in
> DT. In order to make an association between the two, provide the
> association information to the software.
>=20
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> ---
>  Documentation/devicetree/bindings/media/video-interfaces.txt | 11 ++++++=
+++++
>  1 file changed, 11 insertions(+)
>=20
> diff --git a/Documentation/devicetree/bindings/media/video-interfaces.txt=
 b/Documentation/devicetree/bindings/media/video-interfaces.txt
> index 9cd2a36..d6c62bc 100644
> --- a/Documentation/devicetree/bindings/media/video-interfaces.txt
> +++ b/Documentation/devicetree/bindings/media/video-interfaces.txt
> @@ -67,6 +67,17 @@ are required in a relevant parent node:
>  		    identifier, should be 1.
>   - #size-cells    : should be zero.
> =20
> +
> +Optional properties
> +-------------------
> +
> +- flash: An array of phandles that refer to the flash light sources
> +  related to an image sensor. These could be e.g. LEDs. In case the LED
> +  driver drives more than a single LED, then the phandles here refer to
> +  the child nodes of the LED driver describing individual LEDs. Only
> +  valid for device nodes that are related to an image sensor.

s/driver/controller/g - DT describes HW. Otherwise

Reviewed-by: Sebastian Reichel <sebastian.reichel@collabora.co.uk>

-- Sebastian

--nfnej6heq332xss3
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEE72YNB0Y/i3JqeVQT2O7X88g7+poFAlkLOlIACgkQ2O7X88g7
+por8BAAlQQRcQ+jFHXsbbUlmSNQjawbXssH4D/s8drzn2t4kNnCAhDeWUcbeL6u
sedolCO5BjCK4TEGqAj7Ouw+Ua9f8lRsAypw5ytRioCNkQ5vbbcYYNhUQRSoeVC3
Sky7HSBa8xTiRV541u2/e0niiS0DkLY5CBoLf6s5mh99z3eJ+Za11MjT38b/wlqw
34VAd2yLepfdkkXxXfBdec+IY7/dv/9dzUTWrrKfovaEPGDBbtoXklbk0/Npr/Qe
JTR1OibVTy7P/5tIf8KVXqbtey3MJY+zwAeT9+8Qe6+AiYc0oGSpWFPwQfkEIO9O
ifh3RtabeffE/nIr15d3VbEbzsdYXvxHfzxJZBkZZVDP8cYs7fxwgQd91HL7cQbL
9fnzu87P/hdcouIyFPy13BZBU2a7r7hXpf476NEOkijtdBNIdOKORIwAZC56f5M9
VyfAJCDaW5t1GG/ds/4rIpfAFlQhsim8vGV2mTEV60ZZ7RjB4izV7fafcrtvE8/l
2BiOEVXTTwDK4WltfUbcDee45SP5jhwP9H/VT+04VJMP4qoNwfYuTVtzhX18h8uR
kz8xy6++KXRk0+/3+USOsE9uQpKeZ4WwIhrkqFz2F0tJviBOFdIIuBiBq1t7TATW
Q082xUp5taXDVrYo9a4Z0p98OhOgLaiIBket6WYkBnG+YZBnESo=
=FVIr
-----END PGP SIGNATURE-----

--nfnej6heq332xss3--
