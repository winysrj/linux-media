Return-path: <linux-media-owner@vger.kernel.org>
Received: from leonov.paulk.fr ([185.233.101.22]:32902 "EHLO leonov.paulk.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727264AbeJDTkB (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 4 Oct 2018 15:40:01 -0400
Message-ID: <f1fa989b372b514f0a7534057de80b0c453cc8a3.camel@paulk.fr>
Subject: Re: [RFC PATCH v2] media: docs-rst: Document m2m stateless video
 decoder interface
From: Paul Kocialkowski <contact@paulk.fr>
To: Alexandre Courbot <acourbot@chromium.org>,
        Tomasz Figa <tfiga@chromium.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Pawel Osciak <posciak@chromium.org>,
        linux-media@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Date: Thu, 04 Oct 2018 14:47:15 +0200
In-Reply-To: <20181004081119.102575-1-acourbot@chromium.org>
References: <20181004081119.102575-1-acourbot@chromium.org>
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-l7yD+FRf9c6VTMlKiqgB"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-l7yD+FRf9c6VTMlKiqgB
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

Here are a few minor suggestion about H.264 controls.

Le jeudi 04 octobre 2018 =C3=A0 17:11 +0900, Alexandre Courbot a =C3=A9crit=
 :
> diff --git a/Documentation/media/uapi/v4l/extended-controls.rst b/Documen=
tation/media/uapi/v4l/extended-controls.rst
> index a9252225b63e..9d06d853d4ff 100644
> --- a/Documentation/media/uapi/v4l/extended-controls.rst
> +++ b/Documentation/media/uapi/v4l/extended-controls.rst
> @@ -810,6 +810,31 @@ enum v4l2_mpeg_video_bitrate_mode -
>      otherwise the decoder expects a single frame in per buffer.
>      Applicable to the decoder, all codecs.
> =20
> +.. _v4l2-mpeg-h264:
> +
> +``V4L2_CID_MPEG_VIDEO_H264_SPS``
> +    Instance of struct v4l2_ctrl_h264_sps, containing the SPS of to use =
with
> +    the next queued frame. Applicable to the H.264 stateless decoder.
> +
> +``V4L2_CID_MPEG_VIDEO_H264_PPS``
> +    Instance of struct v4l2_ctrl_h264_pps, containing the PPS of to use =
with
> +    the next queued frame. Applicable to the H.264 stateless decoder.
> +
> +``V4L2_CID_MPEG_VIDEO_H264_SCALING_MATRIX``

For consistency with MPEG-2 and upcoming JPEG, I think we should call
this "H264_QUANTIZATION".

> +    Instance of struct v4l2_ctrl_h264_scaling_matrix, containing the sca=
ling
> +    matrix to use when decoding the next queued frame. Applicable to the=
 H.264
> +    stateless decoder.
> +
> +``V4L2_CID_MPEG_VIDEO_H264_SLICE_PARAM``

Ditto with "H264_SLICE_PARAMS".

> +    Array of struct v4l2_ctrl_h264_slice_param, containing at least as m=
any
> +    entries as there are slices in the corresponding ``OUTPUT`` buffer.
> +    Applicable to the H.264 stateless decoder.
> +
> +``V4L2_CID_MPEG_VIDEO_H264_DECODE_PARAM``
> +    Instance of struct v4l2_ctrl_h264_decode_param, containing the high-=
level
> +    decoding parameters for a H.264 frame. Applicable to the H.264 state=
less
> +    decoder.

Since we require all the macroblocks to decode one frame to be held in
the same OUTPUT buffer, it probably doesn't make sense to keep
DECODE_PARAM and SLICE_PARAM distinct.

I would suggest merging both in "SLICE_PARAMS", similarly to what I
have proposed for H.265: https://patchwork.kernel.org/patch/10578023/

What do you think?

Cheers,

Paul

>  ``V4L2_CID_MPEG_VIDEO_H264_VUI_SAR_ENABLE (boolean)``
>      Enable writing sample aspect ratio in the Video Usability
>      Information. Applicable to the H264 encoder.
> diff --git a/Documentation/media/uapi/v4l/pixfmt-compressed.rst b/Documen=
tation/media/uapi/v4l/pixfmt-compressed.rst
> index a86b59f770dd..a03637fda8f9 100644
> --- a/Documentation/media/uapi/v4l/pixfmt-compressed.rst
> +++ b/Documentation/media/uapi/v4l/pixfmt-compressed.rst
> @@ -35,6 +35,42 @@ Compressed Formats
>        - ``V4L2_PIX_FMT_H264``
>        - 'H264'
>        - H264 video elementary stream with start codes.
> +    * .. _V4L2-PIX-FMT-H264-SLICE:
> +
> +      - ``V4L2_PIX_FMT_H264_SLICE``
> +      - 'H264'
> +      - H264 parsed slice data, as extracted from the H264 bitstream.
> +        This format is adapted for stateless video decoders using the M2=
M and
> +        Request APIs.
> +
> +        ``OUTPUT`` buffers must contain all the macroblock slices of a g=
iven
> +        frame, i.e. if a frame requires several macroblock slices to be =
entirely
> +        decoded, then all these slices must be provided. In addition, th=
e
> +        following metadata controls must be set on the request for each =
frame:
> +
> +        V4L2_CID_MPEG_VIDEO_H264_SPS
> +           Instance of struct v4l2_ctrl_h264_sps, containing the SPS of =
to use
> +           with the frame.
> +
> +        V4L2_CID_MPEG_VIDEO_H264_PPS
> +           Instance of struct v4l2_ctrl_h264_pps, containing the PPS of =
to use
> +           with the frame.
> +
> +        V4L2_CID_MPEG_VIDEO_H264_SCALING_MATRIX
> +           Instance of struct v4l2_ctrl_h264_scaling_matrix, containing =
the
> +           scaling matrix to use when decoding the frame.
> +
> +        V4L2_CID_MPEG_VIDEO_H264_SLICE_PARAM
> +           Array of struct v4l2_ctrl_h264_slice_param, containing at lea=
st as
> +           many entries as there are slices in the corresponding ``OUTPU=
T``
> +           buffer.
> +
> +        V4L2_CID_MPEG_VIDEO_H264_DECODE_PARAM
> +           Instance of struct v4l2_ctrl_h264_decode_param, containing th=
e
> +           high-level decoding parameters for a H.264 frame.
> +
> +        See the :ref:`associated Codec Control IDs <v4l2-mpeg-h264>` for=
 the
> +        format of these controls.
>      * .. _V4L2-PIX-FMT-H264-NO-SC:
> =20
>        - ``V4L2_PIX_FMT_H264_NO_SC``
> @@ -67,10 +103,20 @@ Compressed Formats
>        - MPEG-2 parsed slice data, as extracted from the MPEG-2 bitstream=
.
>  	This format is adapted for stateless video decoders that implement a
>  	MPEG-2 pipeline (using the Memory to Memory and Media Request APIs).
> -	Metadata associated with the frame to decode is required to be passed
> -	through the ``V4L2_CID_MPEG_VIDEO_MPEG2_SLICE_PARAMS`` control and
> -	quantization matrices can optionally be specified through the
> -	``V4L2_CID_MPEG_VIDEO_MPEG2_QUANTIZATION`` control.
> +
> +        ``OUTPUT`` buffers must contain all the macroblock slices of a g=
iven
> +        frame, i.e. if a frame requires several macroblock slices to be =
entirely
> +        decoded, then all these slices must be provided. In addition, th=
e
> +        following metadata controls must be set on the request for each =
frame:
> +
> +        V4L2_CID_MPEG_VIDEO_MPEG2_SLICE_PARAMS
> +          Slice parameters (one per slice) for the current frame.
> +
> +        Optional controls:
> +
> +        V4L2_CID_MPEG_VIDEO_MPEG2_QUANTIZATION
> +          Quantization matrices for the current frame.
> +
>  	See the :ref:`associated Codec Control IDs <v4l2-mpeg-mpeg2>`.
>  	Buffers associated with this pixel format must contain the appropriate
>  	number of macroblocks to decode a full corresponding frame.

--=20
Developer of free digital technology and hardware support.

Website: https://www.paulk.fr/
Coding blog: https://code.paulk.fr/
Git repositories: https://git.paulk.fr/ https://git.code.paulk.fr/

--=-l7yD+FRf9c6VTMlKiqgB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEAbcMXZQMtj1fphLChP3B6o/ulQwFAlu2C9MACgkQhP3B6o/u
lQyF8g/7BcJzpArDhXm3SdS567/6MloaMKK6coAlzMCGLKNJ5K4ncI8FxHhuPVHa
UKRgxVFC1tHSleBRBCx35g8Nzf2TA9DTmlz/9gOP6/3jnQtznIB2kcrlGeZlKgxx
L+gtjy3HNJwhiofw+i22e/GDRp41udey9zlZgbk95tgufovhMRy9VwUQH9mLICh2
x/jw4tVpkinvlaksCZsKKFNIdRhSS//UTn8tvUxQ9AUAgVndTCDumzpwxAkY8YyU
jZ1f3cqOZd998huACwzGsd4FBXmulhTAr0kHh29mQ4Nq93BvvAvebaIf1VI6jaol
WyoihZa+MdsGZKWSIK1BYzmURqGjCcfsvG8idndwf0jhGD61FnEi8PwSmw5Ntabf
rnojKCJFNogGrd4gBiwoOtLNUccpqFFpGB//fJxQtTz/FZDxHhUkO5LnbbwdGTlK
b2lZQU3v4cv5Sxipkc9g/UhpU4AMujF+61H7fXAITHrfRycJCXuF9wHSenIeMDqt
S0UbY6apLod3E7UVaK8wH9qHwI3D5qJ4KKgWeK4PyBg8j0/k/kDvkQ3497h0S0X9
Ltpn616vZepxdlwqxp8KsTFmsBkqJMyvQ8KObUihf99FipAr9P41hZb1AqkYTgBG
853GfpTPOIkP7v+c3atdGbJXdgL1kHrXpCvunSDuA+uN4v/qSDU=
=1x/v
-----END PGP SIGNATURE-----

--=-l7yD+FRf9c6VTMlKiqgB--
