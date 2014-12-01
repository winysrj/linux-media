Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f48.google.com ([209.85.220.48]:56322 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752690AbaLALD1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 1 Dec 2014 06:03:27 -0500
Received: by mail-pa0-f48.google.com with SMTP id rd3so10873478pab.7
        for <linux-media@vger.kernel.org>; Mon, 01 Dec 2014 03:03:27 -0800 (PST)
Date: Mon, 1 Dec 2014 12:03:22 +0100
From: Thierry Reding <thierry.reding@gmail.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, marbugge@cisco.com,
	Thierry Reding <thierry.reding@avionic-design.de>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	dri-devel@lists.freedesktop.org
Subject: Re: [PATCH 1/3] hdmi: add new HDMI 2.0 defines
Message-ID: <20141201110321.GA11763@ulmo.nvidia.com>
References: <1417186251-6542-1-git-send-email-hverkuil@xs4all.nl>
 <1417186251-6542-2-git-send-email-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="tKW2IUtsqtDRztdT"
Content-Disposition: inline
In-Reply-To: <1417186251-6542-2-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--tKW2IUtsqtDRztdT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 28, 2014 at 03:50:49PM +0100, Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
>=20
> Add new Video InfoFrame colorspace information introduced in HDMI 2.0
> and new Audio Coding Extension Types, also from HDMI 2.0.
>=20
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>  include/linux/hdmi.h | 20 ++++++++++++++++++++
>  1 file changed, 20 insertions(+)
>=20
> diff --git a/include/linux/hdmi.h b/include/linux/hdmi.h
> index 11c0182..38fd2a0 100644
> --- a/include/linux/hdmi.h
> +++ b/include/linux/hdmi.h
> @@ -37,6 +37,8 @@ enum hdmi_colorspace {
>  	HDMI_COLORSPACE_RGB,
>  	HDMI_COLORSPACE_YUV422,
>  	HDMI_COLORSPACE_YUV444,
> +	HDMI_COLORSPACE_YUV420,
> +	HDMI_COLORSPACE_IDO_DEFINED =3D 7,
>  };
> =20
>  enum hdmi_scan_mode {
> @@ -77,6 +79,10 @@ enum hdmi_extended_colorimetry {
>  	HDMI_EXTENDED_COLORIMETRY_S_YCC_601,
>  	HDMI_EXTENDED_COLORIMETRY_ADOBE_YCC_601,
>  	HDMI_EXTENDED_COLORIMETRY_ADOBE_RGB,
> +
> +	/* The following EC values are only defined in CEA-861-F. */
> +	HDMI_EXTENDED_COLORIMETRY_BT2020_CONST_LUM,
> +	HDMI_EXTENDED_COLORIMETRY_BT2020,
>  };
> =20
>  enum hdmi_quantization_range {
> @@ -201,9 +207,23 @@ enum hdmi_audio_sample_frequency {
> =20
>  enum hdmi_audio_coding_type_ext {
>  	HDMI_AUDIO_CODING_TYPE_EXT_STREAM,
> +
> +	/*
> +	 * The next three CXT values are defined in CEA-861-E only.
> +	 * They do not exist in older versions, and in CEA-861-F they are
> +	 * defined as 'Not in use'.
> +	 */
>  	HDMI_AUDIO_CODING_TYPE_EXT_HE_AAC,
>  	HDMI_AUDIO_CODING_TYPE_EXT_HE_AAC_V2,
>  	HDMI_AUDIO_CODING_TYPE_EXT_MPEG_SURROUND,
> +
> +	/* The following CXT values are only defined in CEA-861-F. */
> +	HDMI_AUDIO_CODING_TYPE_EXT_MPEG4_HE_AAC,
> +	HDMI_AUDIO_CODING_TYPE_EXT_MPEG4_HE_AAC_V2,
> +	HDMI_AUDIO_CODING_TYPE_EXT_MPEG4_AAC_LC,
> +	HDMI_AUDIO_CODING_TYPE_EXT_DRA,
> +	HDMI_AUDIO_CODING_TYPE_EXT_MPEG_HE_AAC_SURROUND,
> +	HDMI_AUDIO_CODING_TYPE_EXT_MPEG_AAC_LC_SURROUND =3D 10,

I think the last two should be MPEG4_{HE_AAC,AAC}_SURROUND, and with
that fixed:

Reviewed-by: Thierry Reding <treding@nvidia.com>

--tKW2IUtsqtDRztdT
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUfEr5AAoJEN0jrNd/PrOhtOQP/jw5xOCfTjH+JdO6CfXP3RDb
o758f8Y6L42q73NkyME1Zkqotxzk1a1MHrhKcyp0hEXFxs0xMBsBlfH+T8inB3tZ
IdIXs2lO1wEjJoMHMQb62IuzdZtbEXuUWdrMd8MJxmBfBdxurmknnW4Srg+3zKbC
pxDPHh+YmqdBHNPGzJLRsgtdAiHg0+rnL8L/jWkVAs/AJM5HjXt6oWHXXoZn6Swm
M9zHRQbjcePmSO5FwcJxqgI+cS2oWwZ/CIDZXaymiv+GPM4RfUqSZV71emuLOrVk
mEKDuK55E3bSVoevlbgJgCrQWkOScxeDDaE5Zu8xIhbBOpC7oXojzC6kxd3FYoCA
MJUD51nq1+aQVwUrANkV3v0TId2Vk9CNTkCBDxqg8AwYR90ur/DKEwA4Z875su46
eN9zUN7OMG4BCgxMMB/b3DHCrFmZ9zF4h238xJCgVk9jSbeqiTI8VpdA7OL8QtVu
EBHp9xXqyIm8D6tuP+yaMANoq6uYhydfVc3Q1ITXbj81YGLspmgnCKteYMKcrdwy
4jm8YUFDvfv9FP372TS2SoHTdUKP57lrhyV8IE5Boildbq3jN6thM2ZqYguS8Xa4
eywL8RoOL0eFms1UPb2/J0RPz8V9URyQyXFiM9zZ0O/r5wsDFgeFw+5Fn6PusIDr
KpWUN/V+fDQlkx4O9Uk8
=4JXG
-----END PGP SIGNATURE-----

--tKW2IUtsqtDRztdT--
