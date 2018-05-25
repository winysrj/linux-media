Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:33892 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S936124AbeEYOFG (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 25 May 2018 10:05:06 -0400
Date: Fri, 25 May 2018 16:05:03 +0200
From: Sebastian Reichel <sebastian.reichel@collabora.co.uk>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        andy.yeh@intel.com
Subject: Re: [PATCH v2 1/2] dt-bindings: media: Define "rotation" property
 for sensors
Message-ID: <20180525140503.5hd3lvweu3y46mo2@earth.universe>
References: <20180525122726.3409-1-sakari.ailus@linux.intel.com>
 <20180525122726.3409-2-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="qecg7urzfxzhcbd2"
Content-Disposition: inline
In-Reply-To: <20180525122726.3409-2-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--qecg7urzfxzhcbd2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Fri, May 25, 2018 at 03:27:25PM +0300, Sakari Ailus wrote:
> Sensors are occasionally mounted upside down to systems such as mobile
> phones or tablets. In order to use such a sensor without having to turn
> every image upside down, most camera sensors support reversing the readout
> order by setting both horizontal and vertical flipping.
>=20
> This patch documents the "rotation" property for camera sensors, mirroring
> what is defined for displays in
> Documentation/devicetree/bindings/display/panel/panel.txt .
>=20
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> ---

Reviewed-by: Sebastian Reichel <sebastian.reichel@collabora.co.uk>

-- Sebastian

>  Documentation/devicetree/bindings/media/video-interfaces.txt | 4 ++++
>  1 file changed, 4 insertions(+)
>=20
> diff --git a/Documentation/devicetree/bindings/media/video-interfaces.txt=
 b/Documentation/devicetree/bindings/media/video-interfaces.txt
> index 258b8dfddf48..52b7c7b57842 100644
> --- a/Documentation/devicetree/bindings/media/video-interfaces.txt
> +++ b/Documentation/devicetree/bindings/media/video-interfaces.txt
> @@ -85,6 +85,10 @@ Optional properties
> =20
>  - lens-focus: A phandle to the node of the focus lens controller.
> =20
> +- rotation: The device, typically an image sensor, is not mounted uprigh=
t,
> +  but a number of degrees counter clockwise. Typical values are 0 and 180
> +  (upside down).
> +
> =20
>  Optional endpoint properties
>  ----------------------------
> --=20
> 2.11.0
>=20

--qecg7urzfxzhcbd2
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEE72YNB0Y/i3JqeVQT2O7X88g7+poFAlsIGAgACgkQ2O7X88g7
+prWhw//dLECFnenXB5tt9ugTSmxIbZjBxAeom2S1I+wZiOLuE8iMZGdF50ptpYo
/jg6gpK1NJ3qQnHEjlUqaz2mK60nfslcdGgXu7B2P7R6btlyrjUD4oo8q7yK9SHW
lc29Ys9D0al/bbkaKRvrT9d4mfWFRJH3vkfiZiElATLdK24W/EEDkCnK7ahosBFb
2/ksnCpHQrOiGLayaOvCCgCm9XzvSIZ6gDvNheO/nnFLP9HKpFlE0nHSwMSRPCJg
07eODEqqGCdjuPu1/CZrt16OUB2HiLkmOw4AD5T+xH6zEg8sM1lkLH0bJ5ZrYl/e
TZgGRaU4Ov8Goy5n5Vrv9j0afSH11Tmxv1/L4kBvjQW3d3Vaj3wr64eVp5cR+OEc
NuB91x+LBPoxNX5L91O4JT8U8scehtxRx39I/RiBb0M2xJ2efT4UpAjTCoQI0mkF
wyxmabB0FvI4357ZbUtm5inE0qekvXBDdEuLhEHjXSwEbLoc6G8g65FudP7dT+CB
lE0mMiWHaEijRGHLaDCwHATSIMEyL3wajPyCIRaWHMznN/AVueT3y9r+m8E/MsJg
8CUYnv2Ag5t6Yh5FvZVnHhHEwqvevCdW6f20ZAkMcEiuwc/ERINjieJvcLMvb8IJ
xNbWui4lxejbHSB8R2JGyIcXTgnhyNPeqV7zM/onNY4jQ+RifqA=
=4d8O
-----END PGP SIGNATURE-----

--qecg7urzfxzhcbd2--
