Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:37072 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754704AbdEDOiI (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 4 May 2017 10:38:08 -0400
Date: Thu, 4 May 2017 16:38:04 +0200
From: Sebastian Reichel <sebastian.reichel@collabora.co.uk>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        pavel@ucw.cz
Subject: Re: [RFC 3/3] dt: bindings: Add a binding for referencing EEPROM
 from camera sensors
Message-ID: <20170504143803.f5pndnvm73jjfe7i@earth>
References: <1493720749-31509-1-git-send-email-sakari.ailus@linux.intel.com>
 <1493720749-31509-4-git-send-email-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="2cbe63unft4ia63v"
Content-Disposition: inline
In-Reply-To: <1493720749-31509-4-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--2cbe63unft4ia63v
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, May 02, 2017 at 01:25:49PM +0300, Sakari Ailus wrote:
> Many camera sensor devices contain EEPROM chips that describe the
> properties of a given unit --- the data is specific to a given unit can
> thus is not stored e.g. in user space or the driver.
>=20
> Some sensors embed the EEPROM chip and it can be accessed through the
> sensor's I=B2C interface. This property is to be used for devices where t=
he
> EEPROM chip is accessed through a different I=B2C address than the sensor.
>=20
> The intent is to later provide this information to the user space.
>=20
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> ---
>  Documentation/devicetree/bindings/media/video-interfaces.txt | 3 +++
>  1 file changed, 3 insertions(+)
>=20
> diff --git a/Documentation/devicetree/bindings/media/video-interfaces.txt=
 b/Documentation/devicetree/bindings/media/video-interfaces.txt
> index e52aefc..9bd2005 100644
> --- a/Documentation/devicetree/bindings/media/video-interfaces.txt
> +++ b/Documentation/devicetree/bindings/media/video-interfaces.txt
> @@ -80,6 +80,9 @@ Optional properties
>  - lens-focus: A phandle to the node of the lens. Only valid for device
>    nodes that are related to an image sensor.
> =20
> +- eeprom: A phandle to the node of the related EEPROM. Only valid for
> +  device nodes that are related to an image sensor.

Here it's even more obvious, that the second sentence is redundant.
The requirement is already in the first sentence :) Instead it
should be mentioned, that this is to be used by devices not having
their own embedded eeprom. How about:

eeprom: A phandle to the node of the EEPROM describing the camera
sensor (i.e. device specific calibration data), in case it differs
=66rom the sensor node.

-- Sebastian

--2cbe63unft4ia63v
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEE72YNB0Y/i3JqeVQT2O7X88g7+poFAlkLPMsACgkQ2O7X88g7
+poNfw//RirP+W4JLW1Y6TyiW+it4GMLWleoA9cP5ezAgva9lq3ADYC5fcsNbj59
AqEIQ/FC7lMIY1CTOwmhZXr9zP5c2nXC2EcxgqgLakmEV18O0VywnhkuseJLdnP3
qzLDtBwHrPm3rWznR9D675oK4W14JKEf5+7m5D0TMtLPR9IFepHRi85mpL6JS1id
FaEzC1BQ0GIDYmQ2i6/4GS9F9j/migqybtKk/Ek1n/QPuVINfD+j1O0L2lD+8lla
4lN79R1MmvtqrlG58xPKlMYaFlOLDU8QNfeZb9pMepQSZzSmJy10L1afNwJ8gd6b
JqJslLI1IaSluBJ2punCkdQalc/Hcf+tnex9piOWFVeruHptcIwjKD5fbd3ie/tg
TUcvDBdJhRt5erNaH0DjUDhEvTon2dc0HBqkLa97UW8s2yxD9ZAY1PZCuDnjWHWX
bBh87fUTC4TeLZy1ee/wSMM9qFA5dAbljb3DUMNP269XvRQh02s3z0bpGfayK4S9
llo6agqvuFKNYC+UCizJN7yGqb8msGF+SkPa8Ii7mS41gS5RKtuzZarmQZ0NoxBf
3iZRLB/DMWyJa+S5TGUsnv2vIdzUhoE/48oYX9bm4aLd69Qdyaj5RwoHKtoVr4/o
+q6W4Urtu1w+qFjB8XIK18/4dvMhDpNv4S/E0hqT5O/u3kc+N/E=
=MyG2
-----END PGP SIGNATURE-----

--2cbe63unft4ia63v--
