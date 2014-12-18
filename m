Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f169.google.com ([209.85.212.169]:62081 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751423AbaLRITc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 18 Dec 2014 03:19:32 -0500
Received: by mail-wi0-f169.google.com with SMTP id r20so731552wiv.4
        for <linux-media@vger.kernel.org>; Thu, 18 Dec 2014 00:19:31 -0800 (PST)
Date: Thu, 18 Dec 2014 09:19:29 +0100
From: Thierry Reding <thierry.reding@gmail.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, marbugge@cisco.com,
	dri-devel@lists.freedesktop.org,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCHv2 2/3] hdmi: added unpack and logging functions for
 InfoFrames
Message-ID: <20141218081927.GA29856@ulmo>
References: <1417522126-31771-1-git-send-email-hverkuil@xs4all.nl>
 <1417522126-31771-3-git-send-email-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="VS++wcV0S1rZb1Fb"
Content-Disposition: inline
In-Reply-To: <1417522126-31771-3-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--VS++wcV0S1rZb1Fb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 02, 2014 at 01:08:45PM +0100, Hans Verkuil wrote:
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
>  drivers/video/hdmi.c | 819 +++++++++++++++++++++++++++++++++++++++++++++=
+++++-
>  include/linux/hdmi.h |   4 +
>  2 files changed, 816 insertions(+), 7 deletions(-)
>=20
> diff --git a/drivers/video/hdmi.c b/drivers/video/hdmi.c
> index 9e758a8..5f7ab47 100644
> --- a/drivers/video/hdmi.c
> +++ b/drivers/video/hdmi.c
> @@ -27,10 +27,12 @@
>  #include <linux/export.h>
>  #include <linux/hdmi.h>
>  #include <linux/string.h>
> +#include <linux/device.h>
> =20
> -static void hdmi_infoframe_checksum(void *buffer, size_t size)
> +#define hdmi_log(fmt, ...) dev_printk(level, dev, fmt, ##__VA_ARGS__)

I personally dislike macros like these that make assumptions about the
environment. While somewhat longer, directly using dev_printk() would in
my opinion be clearer.

But I realize this is somewhat bikesheddy, so don't consider it a hard
objection.

> +
> +static u8 hdmi_infoframe_checksum(u8 *ptr, size_t size)
>  {
> -	u8 *ptr =3D buffer;

For consistency with the other functions I'd prefer this to take void *
instead of u8 *. That'd also clean up the diff in this part a little.

>  	u8 csum =3D 0;
>  	size_t i;
> =20
> @@ -38,7 +40,14 @@ static void hdmi_infoframe_checksum(void *buffer, size=
_t size)
>  	for (i =3D 0; i < size; i++)
>  		csum +=3D ptr[i];
> =20
> -	ptr[3] =3D 256 - csum;
> +	return 256 - csum;
> +}
> +
> +static void hdmi_infoframe_set_checksum(void *buffer, size_t size)
> +{
> +	u8 *ptr =3D buffer;
> +	/* update checksum */

I think checkpatch warns these days about missing blank lines after the
declaration block. But perhaps it is tricked by the comment immediately
following.

Nit: I don't think the comment adds any value.

> +static void hdmi_infoframe_log_header(const char *level,
> +				      struct device *dev, void *f)

Perhaps rather than pass a void *, make this take a hdmi_any_infoframe *
and require callers to explicitly cast.

This is an internal API and therefore less likely to be abused, so again
rather bikesheddy.

> +static const char *hdmi_nups_get_name(enum hdmi_nups nups)
> +{
> +	switch (nups) {
> +	case HDMI_NUPS_UNKNOWN:
> +		return "No Known Non-uniform Scaling";

s/No Known/Unknown/?

> +static void hdmi_avi_infoframe_log(const char *level,
> +				   struct device *dev,
> +				   struct hdmi_avi_infoframe *frame)
> +{
> +	hdmi_infoframe_log_header(level, dev, frame);
> +
> +	hdmi_log("    colorspace: %s\n",
> +			hdmi_colorspace_get_name(frame->colorspace));
> +	hdmi_log("    scan mode: %s\n",
> +			hdmi_scan_mode_get_name(frame->scan_mode));
> +	hdmi_log("    colorimetry: %s\n",
> +			hdmi_colorimetry_get_name(frame->colorimetry));
> +	hdmi_log("    picture aspect: %s\n",
> +			hdmi_picture_aspect_get_name(frame->picture_aspect));
> +	hdmi_log("    active aspect: %s\n",
> +			hdmi_active_aspect_get_name(frame->active_aspect));
> +	hdmi_log("    itc: %s\n", frame->itc ? "IT Content" : "No Data");
> +	hdmi_log("    extended colorimetry: %s\n",
> +			hdmi_extended_colorimetry_get_name(frame->extended_colorimetry));
> +	hdmi_log("    quantization range: %s\n",
> +			hdmi_quantization_range_get_name(frame->quantization_range));
> +	hdmi_log("    nups: %s\n", hdmi_nups_get_name(frame->nups));
> +	hdmi_log("    video code: %d\n", frame->video_code);

This could be "%u".

> +	hdmi_log("    ycc quantization range: %s\n",
> +			hdmi_ycc_quantization_range_get_name(frame->ycc_quantization_range));
> +	hdmi_log("    hdmi content type: %s\n",
> +			hdmi_content_type_get_name(frame->content_type));
> +	hdmi_log("    pixel repeat: %d\n", frame->pixel_repeat);
> +	hdmi_log("    bar top %d, bottom %d, left %d, right %d\n",
> +			frame->top_bar, frame->bottom_bar,
> +			frame->left_bar, frame->right_bar);

Same here.

> +static const char *
> +hdmi_audio_coding_type_get_name(enum hdmi_audio_coding_type coding_type)
> +{
> +	switch (coding_type) {
> +	case HDMI_AUDIO_CODING_TYPE_STREAM:
> +		return "Refer to Stream Header";
[...]
> +	case HDMI_AUDIO_CODING_TYPE_CXT:
> +		return "Refer to CXT";

These aren't really names, but I can't come up with anything better.

> +static const char *
> +hdmi_audio_coding_type_ext_get_name(enum hdmi_audio_coding_type_ext ctx)
> +{
> +	if (ctx < 0 || ctx > 0x1f)
> +		return "Invalid";
> +
> +	switch (ctx) {
> +	case HDMI_AUDIO_CODING_TYPE_EXT_STREAM:
> +		return "Stream";

CEA-861-E describes this as: "Refer to Audio Coding Type (CT) field in
Data Byte 1". Maybe "Refer to CT"?

I wonder if we should also update the name of the symbolic constant to
reflect that (HDMI_AUDIO_CODING_TYPE_EXT_CT?).

> +static void hdmi_audio_infoframe_log(const char *level,
> +				     struct device *dev,
> +				     struct hdmi_audio_infoframe *frame)
> +{
> +	hdmi_infoframe_log_header(level, dev, frame);
> +
> +	if (frame->channels)
> +		hdmi_log("    channels: %d ch\n", frame->channels - 1);

I'd leave out the "ch" at the end, also perhaps "%d" -> "%u".

> +	else
> +		hdmi_log("    channels: Refer to stream header\n");
> +	hdmi_log("    coding type: %s\n",
> +			hdmi_audio_coding_type_get_name(frame->coding_type));
> +	hdmi_log("    sample size: %s\n",
> +			hdmi_audio_sample_size_get_name(frame->sample_size));
> +	hdmi_log("    sample frequency: %s\n",
> +			hdmi_audio_sample_frequency_get_name(frame->sample_frequency));
> +	hdmi_log("    coding type ext: %s\n",
> +			hdmi_audio_coding_type_ext_get_name(frame->coding_type_ext));
> +	hdmi_log("    channel allocation: %d\n",
> +			frame->channel_allocation);

The table for this is rather huge, so it's probably not a good idea to
return a string representation, but perhaps printing in hex would make
it easier to relate to the specification?

> +	hdmi_log("    level shift value: %d db\n",
> +			frame->level_shift_value);

Could be "%u" again. Also "db" -> "dB".

> +hdmi_vendor_any_infoframe_log(const char *level,
> +			      struct device *dev,
> +			      union hdmi_vendor_any_infoframe *frame)
> +{
[...]
> +	if (hvf->vic)
> +		hdmi_log("    HDMI VIC: %d\n", hvf->vic);

%u

> +	if (hvf->s3d_struct !=3D HDMI_3D_STRUCTURE_INVALID) {
> +		hdmi_log("    3D structure: %s\n",
> +				hdmi_3d_structure_get_name(hvf->s3d_struct));
> +		if (hvf->s3d_struct >=3D HDMI_3D_STRUCTURE_SIDE_BY_SIDE_HALF)
> +			hdmi_log("    3D extension data: %d\n",
> +					hvf->s3d_ext_data);

%u

> +static int hdmi_avi_infoframe_unpack(struct hdmi_avi_infoframe *frame,
> +				     void *buffer)
> +{
> +	u8 *ptr =3D buffer;
> +	int ret;
> +
> +	if (ptr[0] !=3D HDMI_INFOFRAME_TYPE_AVI ||
> +	    ptr[1] !=3D 2 ||
> +	    ptr[2] !=3D HDMI_AVI_INFOFRAME_SIZE)
> +		return -EINVAL;
> +
> +	if (hdmi_infoframe_checksum(buffer, HDMI_INFOFRAME_SIZE(AVI)) !=3D 0)

You use the parameterized HDMI_INFOFRAME_SIZE() here, but the plain
macro above. Perhaps make those consistent?

> +static int hdmi_spd_infoframe_unpack(struct hdmi_spd_infoframe *frame,
> +				     void *buffer)
> +{
> +	u8 *ptr =3D buffer;
> +	int ret;
> +
> +	if (ptr[0] !=3D HDMI_INFOFRAME_TYPE_SPD ||
> +	    ptr[1] !=3D 1 ||
> +	    ptr[2] !=3D HDMI_SPD_INFOFRAME_SIZE) {
> +		return -EINVAL;
> +	}
> +
> +	if (hdmi_infoframe_checksum(buffer, HDMI_INFOFRAME_SIZE(SPD)) !=3D 0)
> +		return -EINVAL;

Same here.

> +static int hdmi_audio_infoframe_unpack(struct hdmi_audio_infoframe *fram=
e,
> +				       void *buffer)
> +{
> +	u8 *ptr =3D buffer;
> +	int ret;
> +
> +	if (ptr[0] !=3D HDMI_INFOFRAME_TYPE_AUDIO ||
> +	    ptr[1] !=3D 1 ||
> +	    ptr[2] !=3D HDMI_AUDIO_INFOFRAME_SIZE) {
> +		return -EINVAL;
> +	}
> +
> +	if (hdmi_infoframe_checksum(buffer, HDMI_INFOFRAME_SIZE(AUDIO)) !=3D 0)
> +		return -EINVAL;

And here.

> +static int
> +hdmi_vendor_any_infoframe_unpack(union hdmi_vendor_any_infoframe *frame,
> +				 void *buffer)
> +{
[...]
> +	/* HDMI OUI */
> +	if ((ptr[0] !=3D 0x03) ||
> +	    (ptr[1] !=3D 0x0c) ||
> +	    (ptr[2] !=3D 0x00))
> +		return -EINVAL;

It'd be nice if this would actually use the HDMI_IEEE_OUI constant. The
_pack() function hardcodes this too, so I guess it's fine and something
that could be cleaned up later on if somebody cares enough.

Thierry

--VS++wcV0S1rZb1Fb
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUko4PAAoJEN0jrNd/PrOhdygP/3Y+CHksYYc3cbXvLjbn0aVD
+akVBIbH7FNQY9i5vA0iNfSmPtikkpTJbcrAzDjVgTAm7N6+caXxEcpzxUp7tIIL
VuT8ADkVbg5SjOntUXczfq+YT7tonJ5SkJ80jKBiLzX7srbmBI9nXwuXM0TaA5iR
pGey5BwkCJGaYTlzj8QLiM72WnMVV51EkwS+0ujYPc5++Y6ijlN0Za+6rHOBdnpn
hWspdMrJIwuuzug9qcNx1CBNYIgaRVpxXSmUxFtq3hpirk3i9NPY/HIhpjZ+nkS8
XP1rjiJ5c0/Si0SIjD+0vKA4JOlaiCRTQYWnkB1BM8H9RgtHfab/wgk0a+4g23Py
jIfiuPKudssnoNDzLrNN8PObZqE5n2HRCCctY9fwAIojRi7LNNmY4XuE1vkxFyEd
s1tjmoSUo2YtKp0u/8KPX26R46ZG5SRN7fCQXQf5LyZ9HxfhuJRxTmiJvY3V6YbG
tC2ufyXM6YRDcVKjPm/37Tef7Z8dXJLdBkBtt0IDeENmrGN3P3X639aJ66CSzFqu
yXjVj+x1hSC/kSbI+5FgkSbRaV2/d3AbEgQdHbr9lUlP3DZ9qTmdWYgun9JUBS93
G6l56dz4B8DbzLJJgq30XChLIKycDwxz5uCk7ExgDtSfUofYI5RjhVrO4rEUfXIa
aK2sM6nwEJJfwpODVM89
=fflo
-----END PGP SIGNATURE-----

--VS++wcV0S1rZb1Fb--
