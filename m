Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f49.google.com ([209.85.220.49]:37543 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753298AbaLANPP (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 1 Dec 2014 08:15:15 -0500
Received: by mail-pa0-f49.google.com with SMTP id eu11so11059964pac.36
        for <linux-media@vger.kernel.org>; Mon, 01 Dec 2014 05:15:14 -0800 (PST)
Date: Mon, 1 Dec 2014 14:15:10 +0100
From: Thierry Reding <thierry.reding@gmail.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, marbugge@cisco.com,
	Thierry Reding <thierry.reding@avionic-design.de>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	dri-devel@lists.freedesktop.org
Subject: Re: [PATCH 2/3] hdmi: added unpack and logging functions for
 InfoFrames
Message-ID: <20141201131507.GB11763@ulmo.nvidia.com>
References: <1417186251-6542-1-git-send-email-hverkuil@xs4all.nl>
 <1417186251-6542-3-git-send-email-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="jq0ap7NbKX2Kqbes"
Content-Disposition: inline
In-Reply-To: <1417186251-6542-3-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--jq0ap7NbKX2Kqbes
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 28, 2014 at 03:50:50PM +0100, Hans Verkuil wrote:
> From: Martin Bugge <marbugge@cisco.com>
>=20
> When receiving video it is very useful to be able to unpack the InfoFrame=
s.
> Logging is useful as well, both for transmitters and receivers.
>=20
> Especially when implementing the VIDIOC_LOG_STATUS ioctl (supported by ma=
ny
> V4L2 drivers) for a receiver it is important to be able to easily log what
> the InfoFrame contains. This greatly simplifies debugging.
>=20
> Signed-off-by: Martin Bugge <marbugge@cisco.com>
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>  drivers/video/hdmi.c | 622 +++++++++++++++++++++++++++++++++++++++++++++=
+++++-
>  include/linux/hdmi.h |   3 +
>  2 files changed, 618 insertions(+), 7 deletions(-)
>=20
> diff --git a/drivers/video/hdmi.c b/drivers/video/hdmi.c
> index 9e758a8..9f0f554 100644
> --- a/drivers/video/hdmi.c
> +++ b/drivers/video/hdmi.c
> @@ -27,10 +27,10 @@
>  #include <linux/export.h>
>  #include <linux/hdmi.h>
>  #include <linux/string.h>
> +#include <linux/device.h>
> =20
> -static void hdmi_infoframe_checksum(void *buffer, size_t size)
> +static u8 hdmi_infoframe_calc_checksum(u8 *ptr, size_t size)

I'd personally keep the name here.

> @@ -434,3 +441,604 @@ hdmi_infoframe_pack(union hdmi_infoframe *frame, vo=
id *buffer, size_t size)
>  	return length;
>  }
>  EXPORT_SYMBOL(hdmi_infoframe_pack);
> +
> +static const char *hdmi_infoframe_type_txt(enum hdmi_infoframe_type type)

Perhaps: hdmi_infoframe_type_get_name()?

> +{
> +	switch (type) {
> +	case HDMI_INFOFRAME_TYPE_VENDOR: return "Vendor";
> +	case HDMI_INFOFRAME_TYPE_AVI: return "Auxiliary Video Information (AVI)=
";
> +	case HDMI_INFOFRAME_TYPE_SPD: return "Source Product Description (SPD)";
> +	case HDMI_INFOFRAME_TYPE_AUDIO: return "Audio";

I'd prefer "case ...:" and "return ...;" on separate lines for
readability.

> +	}
> +	return "Invalid/Unknown";
> +}

Maybe include the numerical value here? Of course that either means that
callers must pass in a buffer or we sacrifice thread-safety. The buffer
could be optional, somewhat like this:

	const char *hdmi_infoframe_get_name(char *buffer, size_t length,
					    enum hdmi_infoframe_type type)
	{
		const char *name =3D NULL;

		switch (type) {
		case HDMI_INFOFRAME_TYPE_VENDOR:
			name =3D "Vendor";
			break;
		...
		}

		if (buffer) {
			if (!name)
				snprintf(buffer, length, "unknown (%d)", type);
			else
				snprintf(buffer, length, name);

			name =3D buffer;
		}

		return name;
	}

That way the function would be generally useful and could even be made
publicly available.

> +static void hdmi_infoframe_log_header(struct device *dev, void *f)
> +{
> +	struct hdmi_any_infoframe *frame =3D f;
> +	dev_info(dev, "HDMI infoframe: %s, version %d, length %d\n",
> +		hdmi_infoframe_type_txt(frame->type), frame->version, frame->length);
> +}
> +
> +static const char *hdmi_colorspace_txt(enum hdmi_colorspace colorspace)
> +{
> +	switch (colorspace) {
> +	case HDMI_COLORSPACE_RGB: return "RGB";
> +	case HDMI_COLORSPACE_YUV422: return "YCbCr 4:2:2";
> +	case HDMI_COLORSPACE_YUV444: return "YCbCr 4:4:4";
> +	case HDMI_COLORSPACE_YUV420: return "YCbCr 4:2:0";
> +	case HDMI_COLORSPACE_IDO_DEFINED: return "IDO Defined";
> +	}
> +	return "Future";
> +}

Similar comments as for the above.

> +static const char *hdmi_scan_mode_txt(enum hdmi_scan_mode scan_mode)
> +{
> +	switch(scan_mode) {
> +	case HDMI_SCAN_MODE_NONE: return "No Data";
> +	case HDMI_SCAN_MODE_OVERSCAN: return "Composed for overscanned display";
> +	case HDMI_SCAN_MODE_UNDERSCAN: return "Composed for underscanned displa=
y";
> +	}
> +	return "Future";
> +}

This isn't really a name any more, I think it should either stick to
names like "None", "Overscan", "Underscan" or it should return a
description, in which case hdmi_scan_mode_get_description() might be
more accurate for a name.

> +static const char *hdmi_colorimetry_txt(enum hdmi_colorimetry colorimetr=
y)
> +{
> +	switch(colorimetry) {
> +	case HDMI_COLORIMETRY_NONE: return "No Data";
> +	case HDMI_COLORIMETRY_ITU_601: return "ITU601";
> +	case HDMI_COLORIMETRY_ITU_709: return "ITU709";
> +	case HDMI_COLORIMETRY_EXTENDED: return "Extended";
> +	}
> +	return "Invalid/Unknown";
> +}

These are names again, so same comments as for the infoframe type. And
perhaps "No Data" -> "None" in that case.

> +
> +static const char *hdmi_picture_aspect_txt(enum hdmi_picture_aspect pict=
ure_aspect)
> +{
> +	switch (picture_aspect) {
> +	case HDMI_PICTURE_ASPECT_NONE: return "No Data";
> +	case HDMI_PICTURE_ASPECT_4_3: return "4:3";
> +	case HDMI_PICTURE_ASPECT_16_9: return "16:9";
> +	}
> +	return "Future";
> +}

Same here.

> +static const char *hdmi_quantization_range_txt(enum hdmi_quantization_ra=
nge quantization_range)
> +{
> +	switch (quantization_range) {
> +	case HDMI_QUANTIZATION_RANGE_DEFAULT: return "Default (depends on video=
 format)";

I think "Default" would do here ("depends on video format" can be
derived from the reading of the specification). Generally I think these
should focus on providing a human-readable version of the infoframes,
not be a replacement for reading the specification.

> +/**
> + * hdmi_avi_infoframe_log() - log info of HDMI AVI infoframe
> + * @dev: device
> + * @frame: HDMI AVI infoframe
> + */
> +static void hdmi_avi_infoframe_log(struct device *dev, struct hdmi_avi_i=
nfoframe *frame)

Perhaps allow this to take a log level? I can imagine drivers wanting to
use this with dev_dbg() instead.

> +/**
> + * hdmi_vendor_infoframe_log() - log info of HDMI VENDOR infoframe
> + * @dev: device
> + * @frame: HDMI VENDOR infoframe
> + */
> +static void hdmi_vendor_any_infoframe_log(struct device *dev, union hdmi=
_vendor_any_infoframe *frame)
> +{
> +	struct hdmi_vendor_infoframe *hvf =3D &frame->hdmi;
> +
> +	hdmi_infoframe_log_header(dev, frame);
> +
> +	if (frame->any.oui !=3D HDMI_IEEE_OUI) {
> +		dev_info(dev, "    not a HDMI vendor infoframe\n");
> +		return;
> +	}
> +	if (hvf->vic =3D=3D 0 && hvf->s3d_struct =3D=3D HDMI_3D_STRUCTURE_INVAL=
ID) {
> +		dev_info(dev, "    empty frame\n");
> +		return;
> +	}
> +
> +	if (hvf->vic) {
> +		dev_info(dev, "    Hdmi Vic: %d\n", hvf->vic);

"HDMI VIC"?

> +	}

No need for these braces.

> +/**
> + * hdmi_infoframe_log() - log info of HDMI infoframe
> + * @dev: device
> + * @frame: HDMI infoframe
> + */
> +void hdmi_infoframe_log(struct device *dev, union hdmi_infoframe *frame)
> +{
> +	switch (frame->any.type) {
> +	case HDMI_INFOFRAME_TYPE_AVI:
> +		hdmi_avi_infoframe_log(dev, &frame->avi);
> +		break;
> +	case HDMI_INFOFRAME_TYPE_SPD:
> +		hdmi_spd_infoframe_log(dev, &frame->spd);
> +		break;
> +	case HDMI_INFOFRAME_TYPE_AUDIO:
> +		hdmi_audio_infoframe_log(dev, &frame->audio);
> +		break;
> +	case HDMI_INFOFRAME_TYPE_VENDOR:
> +		hdmi_vendor_any_infoframe_log(dev, &frame->vendor);
> +		break;
> +	default:
> +		WARN(1, "Bad infoframe type %d\n", frame->any.type);

Does it make sense for this to be WARN? It's perfectly legal for future
devices to expose new types of infoframes. Perhaps even expected. But if
we want to keep this here to help get bug reports so that we don't
forget to update this code, then maybe we should do the same wherever we
query the name of enum values above.

> +/**
> + * hdmi_avi_infoframe_unpack() - unpack binary buffer to a HDMI AVI info=
frame
> + * @buffer: source buffer
> + * @frame: HDMI AVI infoframe
> + *
> + * Unpacks the information contained in binary @buffer into a structured
> + * @frame of the HDMI Auxiliary Video (AVI) information frame.
> + * Also verifies the checksum as required by section 5.3.5 of the HDMI 1=
=2E4 specification.
> + *
> + * Returns 0 on success or a negative error code on failure.
> + */
> +static int hdmi_avi_infoframe_unpack(void *buffer, struct hdmi_avi_infof=
rame *frame)

I'm on the fence about ordering of arguments here. I think I'd slightly
prefer the infoframe to be the first, to make the API more object-
oriented.

> +{
> +	u8 *ptr =3D buffer;
> +	int ret;
> +
> +	if (ptr[0] !=3D HDMI_INFOFRAME_TYPE_AVI ||
> +	    ptr[1] !=3D 2 ||
> +	    ptr[2] !=3D HDMI_AVI_INFOFRAME_SIZE) {
> +		return -EINVAL;
> +	}

No need for the braces.

Thierry

--jq0ap7NbKX2Kqbes
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUfGnbAAoJEN0jrNd/PrOh1OIP/0V/H3LCr2tzYx3ET5wsI9qO
ZxcJo/9Ek2KLJVRkmvw5TD7ljk6Yo6NQFkIuPQR7eRHOxOZzAQiny+wzpQpNalCm
4leyjMBNDZPwD6aHPDlh6faxDbjw6z+KSw0tsgF1ESM1fnit6cCToKwAq8LnJXLz
hf5A1UWz/klL3yYunCb4ZPK8pxa9YR23JRbXmYuUh8vC+GrmdRuh8ooTo7FFsJUu
XLXiuVhGwJQ45gWUQVFum2anmTrvgmvQI+gqASsbZMiGxSG2rAQ2E3mDxL3aIDXk
uWHZW5Q2Cr7RfUgB6aH30zTS/HT1rO6nwEEhx8ItqOtIy+BNMUsUYGtf61wVaALA
WhOWaO8XNyOis69RtdtfNnCe7J6MzbvW1jIZxJ5ucbQwB5WvZeFL4UTKAO2DxrHI
ImA74z/VDbMrSpXoiqSd+7c+QRwECoDOE57M3GM3RfrzW6DtbijeaXFBwew54o0a
bVdGQBPJ+6Tb1Jfz61EcLP8Dc56viSkA1yuuIxCEF69/iwdTeX2b036PZUra5EzC
naw9+EO4l1oTrhnT7/CQroRvYpCXZmIAgv0mkaMpgKGH0k/urbgeFpdNZTIpCutA
Zpb41jijrKHSliwYiUEPIrElmRCUkxpc6J2UucmlLMN6AAKEMwdlgYA3yOjts9DV
2ik2iHnT/FKwKZw3WdeU
=Sx9C
-----END PGP SIGNATURE-----

--jq0ap7NbKX2Kqbes--
