Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-it0-f68.google.com ([209.85.214.68]:36448 "EHLO
        mail-it0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750940AbdBJCJB (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 9 Feb 2017 21:09:01 -0500
Received: by mail-it0-f68.google.com with SMTP id f200so3167367itf.3
        for <linux-media@vger.kernel.org>; Thu, 09 Feb 2017 18:07:57 -0800 (PST)
Message-ID: <1486692473.5749.3.camel@ndufresne.ca>
Subject: Re: [PATCH v3 1/3] [media] v4l: add parsed MPEG-2 support
From: Nicolas Dufresne <nicolas@ndufresne.ca>
To: Hugues Fruchet <hugues.fruchet@st.com>,
        linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>
Cc: kernel@stlinux.com,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Jean-Christophe Trotin <jean-christophe.trotin@st.com>
Date: Thu, 09 Feb 2017 21:07:53 -0500
In-Reply-To: <1486660025-25678-2-git-send-email-hugues.fruchet@st.com>
References: <1486660025-25678-1-git-send-email-hugues.fruchet@st.com>
         <1486660025-25678-2-git-send-email-hugues.fruchet@st.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
        boundary="=-TXDuOEM/HnTZi0wwtysE"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-TXDuOEM/HnTZi0wwtysE
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Le jeudi 09 f=C3=A9vrier 2017 =C3=A0 18:07 +0100, Hugues Fruchet a =C3=A9cr=
it=C2=A0:
> Add "parsed MPEG-2" pixel format & related controls
> needed by stateless video decoders.
> In order to decode the video bitstream chunk provided
> by user on output queue, stateless decoders require
> also some extra data resulting from this video bitstream
> chunk parsing.
> Those parsed extra data have to be set by user through
> control framework using the dedicated mpeg video extended
> controls introduced in this patchset.
>=20
> Signed-off-by: Hugues Fruchet <hugues.fruchet@st.com>
> ---
> =C2=A0Documentation/media/uapi/v4l/extended-controls.rst | 363
> +++++++++++++++++++++
> =C2=A0Documentation/media/uapi/v4l/pixfmt-013.rst=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0|=C2=A0=C2=A010 +
> =C2=A0drivers/media/v4l2-core/v4l2-ctrls.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0|=C2=A0=C2=A053=
 +++
> =C2=A0drivers/media/v4l2-core/v4l2-ioctl.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0|=C2=A0=C2=A0=
=C2=A02 +
> =C2=A0include/uapi/linux/v4l2-controls.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0|=C2=
=A0=C2=A086 +++++
> =C2=A0include/uapi/linux/videodev2.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0|=C2=A0=C2=A0=C2=A08 +
> =C2=A06 files changed, 522 insertions(+)
>=20
> diff --git a/Documentation/media/uapi/v4l/extended-controls.rst
> b/Documentation/media/uapi/v4l/extended-controls.rst
> index abb1057..cd1a8d6 100644
> --- a/Documentation/media/uapi/v4l/extended-controls.rst
> +++ b/Documentation/media/uapi/v4l/extended-controls.rst
> @@ -1827,6 +1827,369 @@ enum
> v4l2_mpeg_cx2341x_video_median_filter_type -
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0not insert, 1 =3D insert packets.
> =C2=A0
> =C2=A0
> +MPEG-2 Parsed Control Reference
> +---------------------------------
> +
> +The MPEG-2 parsed decoding controls are needed by stateless video
> decoders.
> +Those decoders expose :ref:`Compressed formats <compressed-formats>`=20
> :ref:`V4L2_PIX_FMT_MPEG1_PARSED<V4L2-PIX-FMT-MPEG1-PARSED>` or
> :ref:`V4L2_PIX_FMT_MPEG2_PARSED<V4L2-PIX-FMT-MPEG2-PARSED>`.
> +In order to decode the video bitstream chunk provided by user on
> output queue,
> +stateless decoders require also some extra data resulting from this
> video
> +bitstream chunk parsing. Those parsed extra data have to be set by
> user
> +through control framework using the mpeg video extended controls
> defined
> +in this section. Those controls have been defined based on MPEG-2
> standard
> +ISO/IEC 13818-2, and so derive directly from the MPEG-2 video
> bitstream syntax
> +including how it is coded inside bitstream (enumeration values for
> ex.).
> +
> +MPEG-2 Parsed Control IDs
> +^^^^^^^^^^^^^^^^^^^^^^^^^^^
> +
> +.. _mpeg2-parsed-control-id:
> +
> +``V4L2_CID_MPEG_VIDEO_MPEG2_SEQ_HDR``
> +=C2=A0=C2=A0=C2=A0=C2=A0(enum)
> +
> +.. tabularcolumns:: |p{4.0cm}|p{2.5cm}|p{11.0cm}|
> +
> +.. c:type:: v4l2_mpeg_video_mpeg2_seq_hdr
> +
> +.. cssclass:: longtable
> +
> +.. flat-table:: struct v4l2_mpeg_video_mpeg2_seq_hdr
> +=C2=A0=C2=A0=C2=A0=C2=A0:header-rows:=C2=A0=C2=A00
> +=C2=A0=C2=A0=C2=A0=C2=A0:stub-columns: 0
> +=C2=A0=C2=A0=C2=A0=C2=A0:widths:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A01 1 2
> +
> +=C2=A0=C2=A0=C2=A0=C2=A0* - __u16
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- ``width``
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- Video width in pixels.
> +=C2=A0=C2=A0=C2=A0=C2=A0* - __u16
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- ``height``
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- Video height in pixels.
> +=C2=A0=C2=A0=C2=A0=C2=A0* - __u8
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- ``aspect_ratio_info``
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- Aspect ratio code as in the bitstr=
eam (1: 1:1 square pixels,
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A02: 4:3 display, 3: 16:9 =
display, 4: 2.21:1 display)
> +=C2=A0=C2=A0=C2=A0=C2=A0* - __u8
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- ``framerate code``
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- Framerate code as in the bitstream
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0(1: 24000/1001.0 '23.976=
 fps, 2: 24.0, 3: 25.0,
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A04: 30000/1001.0 '29.97, =
5: 30.0, 6: 50.0, 7: 60000/1001.0,
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A08: 60.0)
> +=C2=A0=C2=A0=C2=A0=C2=A0* - __u32
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- ``bitrate_value``
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- Bitrate value as in the bitstream,=
 expressed in 400bps unit
> +=C2=A0=C2=A0=C2=A0=C2=A0* - __u16
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- ``vbv_buffer_size``
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0-=C2=A0=C2=A0Video Buffering Verifie=
r size, expressed in 16KBytes unit.
> +=C2=A0=C2=A0=C2=A0=C2=A0* - __u8
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- ``constrained_parameters_flag``
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- Set to 1 if this bitstream uses co=
nstrained parameters.
> +=C2=A0=C2=A0=C2=A0=C2=A0* - __u8
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- ``load_intra_quantiser_matrix``
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- If set to 1, ``intra_quantiser_mat=
rix`` table is to be used
> for
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0decoding.
> +=C2=A0=C2=A0=C2=A0=C2=A0* - __u8
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- ``load_non_intra_quantiser_matrix`=
`
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- If set to 1, ``non_intra_quantiser=
_matrix`` table is to be
> used for
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0decoding.
> +=C2=A0=C2=A0=C2=A0=C2=A0* - __u8
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- ``intra_quantiser_matrix[64]``
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- Intra quantization table, in zig-z=
ag scan order.
> +=C2=A0=C2=A0=C2=A0=C2=A0* - __u8
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- ``non_intra_quantiser_matrix[64]``
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- Non-intra quantization table, in z=
ig-zag scan order.
> +=C2=A0=C2=A0=C2=A0=C2=A0* - __u32
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- ``par_w``
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- Pixel aspect ratio width in pixels=
.
> +=C2=A0=C2=A0=C2=A0=C2=A0* - __u32
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- ``par_h``
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- Pixel aspect ratio height in pixel=
s.
> +=C2=A0=C2=A0=C2=A0=C2=A0* - __u32
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- ``fps_n``
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- Framerate nominator.
> +=C2=A0=C2=A0=C2=A0=C2=A0* - __u32
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- ``fps_d``
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- Framerate denominator.
> +=C2=A0=C2=A0=C2=A0=C2=A0* - __u32
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- ``bitrate``
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- Bitrate in bps if constant bitrate=
, 0 otherwise.
> +=C2=A0=C2=A0=C2=A0=C2=A0* - :cspan:`2`
> +
> +
> +``V4L2_CID_MPEG_VIDEO_MPEG2_SEQ_EXT``
> +=C2=A0=C2=A0=C2=A0=C2=A0(enum)
> +
> +.. tabularcolumns:: |p{4.0cm}|p{2.5cm}|p{11.0cm}|
> +
> +.. c:type:: v4l2_mpeg_video_mpeg2_seq_ext
> +
> +.. cssclass:: longtable
> +
> +.. flat-table:: struct v4l2_mpeg_video_mpeg2_seq_ext
> +=C2=A0=C2=A0=C2=A0=C2=A0:header-rows:=C2=A0=C2=A00
> +=C2=A0=C2=A0=C2=A0=C2=A0:stub-columns: 0
> +=C2=A0=C2=A0=C2=A0=C2=A0:widths:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A01 1 2
> +
> +=C2=A0=C2=A0=C2=A0=C2=A0* - __u8
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- ``profile``
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- Encoding profile used to encode th=
is bitstream.
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0(1: High Profile, 2: Spa=
tially Scalable Profile,
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A03: SNR Scalable Profile,=
 4: Main Profile, 5: Simple
> Profile).
> +=C2=A0=C2=A0=C2=A0=C2=A0* - __u8
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- ``level``
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- Encoding level used to encode this=
 bitstream
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0(4: High Level, 6: High =
1440 Level, 8: Main Level, 10: Low
> Level).
> +=C2=A0=C2=A0=C2=A0=C2=A0* - __u8
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- ``progressive``
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- Set to 1 if frames are progressive=
 (vs interlaced).
> +=C2=A0=C2=A0=C2=A0=C2=A0* - __u8
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- ``chroma_format``
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- Chrominance format (1: 420, 2: 422=
, 3: 444).
> +=C2=A0=C2=A0=C2=A0=C2=A0* - __u8
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- ``horiz_size_ext``
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- Horizontal size extension. This va=
lue is to be shifted 12
> bits left
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0and added to ''seq_hdr->=
width'' to get the final video
> width:
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0`width =3D seq_hdr->widt=
h + seq_ext->horiz_size_ext << 12`
> +=C2=A0=C2=A0=C2=A0=C2=A0* - __u8
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- ``vert_size_ext``
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- Vertical size extension. This valu=
e is to be shifted 12 bits
> left
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0and added to ''seq_hdr->=
height'' to get the final video
> height:
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0`height =3D seq_hdr->hei=
ght + seq_ext->vert_size_ext << 12`
> +=C2=A0=C2=A0=C2=A0=C2=A0* - __u16
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- ``bitrate_ext``
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0-=C2=A0=C2=A0Bitrate extension. This=
 value, expressed in 400bps unit, is
> to be
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0shifted 18 bits le=
ft and added to ''seq_hdr->bitrate'' to
> get the
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0final bitrate:
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0`bitrate =3D seq_h=
dr->bitrate + (seq_ext->bitrate_ext << 18)
> * 400`
> +=C2=A0=C2=A0=C2=A0=C2=A0* - __u8
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- ``vbv_buffer_size_ext``
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0-=C2=A0=C2=A0Video Buffering Verifie=
r size extension in bits.
> +=C2=A0=C2=A0=C2=A0=C2=A0* - __u8
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- ``low_delay``
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0-=C2=A0=C2=A0Low delay. Set to 1 if =
no B pictures are present.
> +=C2=A0=C2=A0=C2=A0=C2=A0* - __u8
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- ``fps_n_ext``
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0-=C2=A0=C2=A0Framerate extension nom=
inator. This value is to be
> incremented and
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0multiplied by ''se=
q_hdr->fps_n'' to get the final framerate
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0nominator:
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0`fps_n =3D seq_hdr=
->fps_n * (seq_ext->fps_n_ext + 1)`
> +=C2=A0=C2=A0=C2=A0=C2=A0* - __u8
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- ``fps_d_ext``
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0-=C2=A0=C2=A0Framerate extension den=
ominator. This value is to be
> incremented and
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0multiplied by ''se=
q_hdr->fps_d'' to get the final framerate
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0denominator:
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0`fps_d =3D seq_hdr=
->fps_d * (seq_ext->fps_d_ext + 1)`
> +=C2=A0=C2=A0=C2=A0=C2=A0* - :cspan:`2`
> +
> +
> +``V4L2_CID_MPEG_VIDEO_MPEG2_SEQ_DISPLAY_EXT``
> +=C2=A0=C2=A0=C2=A0=C2=A0(enum)
> +
> +.. tabularcolumns:: |p{4.0cm}|p{2.5cm}|p{11.0cm}|
> +
> +.. c:type:: v4l2_mpeg_video_mpeg2_seq_display_ext
> +
> +.. cssclass:: longtable
> +
> +.. flat-table:: struct v4l2_mpeg_video_mpeg2_seq_ext
> +=C2=A0=C2=A0=C2=A0=C2=A0:header-rows:=C2=A0=C2=A00
> +=C2=A0=C2=A0=C2=A0=C2=A0:stub-columns: 0
> +=C2=A0=C2=A0=C2=A0=C2=A0:widths:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A01 1 2
> +
> +=C2=A0=C2=A0=C2=A0=C2=A0* - __u8
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- ``video_format``
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- Video standard (0: Components, 1: =
PAL, 2: NTSC, 3: SECAM,
> 4:MAC)
> +=C2=A0=C2=A0=C2=A0=C2=A0* - __u8
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- ``colour_description_flag``
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- If set to 1, ''colour_primaries'',
> ''transfer_characteristics'',
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0''matrix_coefficients'' =
are to be used for decoding.
> +=C2=A0=C2=A0=C2=A0=C2=A0* - __u8
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- ``colour_primaries``
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- Colour coding standard (1: ITU-R R=
ec. 709 (1990),
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A04: ITU-R Rec. 624-4 Syst=
em M, 5: ITU-R Rec. 624-4 System B,
> G,
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A06: SMPTE 170M, 7: SMPTE =
240M (1987))
> +=C2=A0=C2=A0=C2=A0=C2=A0* - __u8
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- ``transfer_characteristics``
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- Transfer characteristics coding st=
andard (1: ITU-R Rec. 709
> (1990),
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A04: ITU-R Rec. 624-4 Syst=
em M, 5: ITU-R Rec. 624-4 System B,
> G,
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A06: SMPTE 170M, 7: SMPTE =
240M (1987))
> +=C2=A0=C2=A0=C2=A0=C2=A0* - __u8
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- ``matrix_coefficients``
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- Matrix coefficients coding standar=
d (1: ITU-R Rec. 709
> (1990),
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A04: FCC, 5: ITU-R Rec. 62=
4-4 System B, G, 6: SMPTE 170M,
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A07: SMPTE 240M (1987))
> +=C2=A0=C2=A0=C2=A0=C2=A0* - __u16
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- ``display_horizontal_size``, ``dis=
play_vertical_size``
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- Dimensions of the video to be disp=
layed. If those dimensions
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0are smaller than the fin=
al video dimensions, only this area
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0must be displayed.
> +=C2=A0=C2=A0=C2=A0=C2=A0* - :cspan:`2`
> +
> +
> +``V4L2_CID_MPEG_VIDEO_MPEG2_SEQ_MATRIX_EXT``
> +=C2=A0=C2=A0=C2=A0=C2=A0(enum)
> +
> +.. tabularcolumns:: |p{4.0cm}|p{2.5cm}|p{11.0cm}|
> +
> +.. c:type:: v4l2_mpeg_video_mpeg2_seq_matrix_ext
> +
> +.. cssclass:: longtable
> +
> +.. flat-table:: struct v4l2_mpeg_video_mpeg2_seq_matrix_ext
> +=C2=A0=C2=A0=C2=A0=C2=A0:header-rows:=C2=A0=C2=A00
> +=C2=A0=C2=A0=C2=A0=C2=A0:stub-columns: 0
> +=C2=A0=C2=A0=C2=A0=C2=A0:widths:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A01 1 2
> +
> +=C2=A0=C2=A0=C2=A0=C2=A0* - __u8
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- ``load_intra_quantiser_matrix``
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- If set to 1, ``intra_quantiser_mat=
rix`` table is to be used
> for
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0decoding.
> +=C2=A0=C2=A0=C2=A0=C2=A0* - __u8
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- ``intra_quantiser_matrix[64]``
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- Intra quantization table, in zig-z=
ag scan order.
> +=C2=A0=C2=A0=C2=A0=C2=A0* - __u8
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- ``load_non_intra_quantiser_matrix`=
`
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- If set to 1, ``non_intra_quantiser=
_matrix`` table is to be
> used for
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0decoding.
> +=C2=A0=C2=A0=C2=A0=C2=A0* - __u8
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- ``non_intra_quantiser_matrix[64]``
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- Non-intra quantization table, in z=
ig-zag scan order.
> +=C2=A0=C2=A0=C2=A0=C2=A0* - __u8
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- ``load_chroma_intra_quantiser_matr=
ix``
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- If set to 1, ``chroma_intra_quanti=
ser_matrix`` table is to
> be used for
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0decoding.
> +=C2=A0=C2=A0=C2=A0=C2=A0* - __u8
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- ``chroma_intra_quantiser_matrix[64=
]``
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- Chroma intra quantization table, i=
n zig-zag scan order.
> +=C2=A0=C2=A0=C2=A0=C2=A0* - __u8
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- ``load_chroma_non_intra_quantiser_=
matrix``
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- If set to 1, ``chroma_non_intra_qu=
antiser_matrix`` table is
> to be used for
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0decoding.
> +=C2=A0=C2=A0=C2=A0=C2=A0* - __u8
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- ``chroma_non_intra_quantiser_matri=
x[64]``
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- Chroma non-intra quantization tabl=
e, in zig-zag scan order.
> +=C2=A0=C2=A0=C2=A0=C2=A0* - :cspan:`2`
> +
> +
> +``V4L2_CID_MPEG_VIDEO_MPEG2_PIC_HDR``
> +=C2=A0=C2=A0=C2=A0=C2=A0(enum)
> +
> +.. tabularcolumns:: |p{4.0cm}|p{2.5cm}|p{11.0cm}|
> +
> +.. c:type:: v4l2_mpeg_video_mpeg2_pic_hdr
> +
> +.. cssclass:: longtable
> +
> +.. flat-table:: struct v4l2_mpeg_video_mpeg2_pic_hdr
> +=C2=A0=C2=A0=C2=A0=C2=A0:header-rows:=C2=A0=C2=A00
> +=C2=A0=C2=A0=C2=A0=C2=A0:stub-columns: 0
> +=C2=A0=C2=A0=C2=A0=C2=A0:widths:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A01 1 2
> +
> +=C2=A0=C2=A0=C2=A0=C2=A0* - __u32
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- ``offset``
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- Offset in bytes of the slice data =
from the beginning of
> packet.
> +=C2=A0=C2=A0=C2=A0=C2=A0* - __u16
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- ``tsn``
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- Temporal Sequence Number: order in=
 which the frames must be
> displayed.
> +=C2=A0=C2=A0=C2=A0=C2=A0* - __u8
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- ``pic_type``
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- Picture coding type (1: Intra, 2: =
Predictive,
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A03: B, Bidirectionally Pr=
edictive, 4: D, DC Intra).
> +=C2=A0=C2=A0=C2=A0=C2=A0* - __u16
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- ``vbv_delay``
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- Video Buffering Verifier delay, in=
 90KHz cycles unit.
> +=C2=A0=C2=A0=C2=A0=C2=A0* - __u8
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- ``full_pel_forward_vector``
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- If set to 1, forward vectors are e=
xpressed in full pixel
> unit instead
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0half pixel unit.
> +=C2=A0=C2=A0=C2=A0=C2=A0* - __u8
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- ``full_pel_backward_vector``
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- If set to 1, backward vectors are =
expressed in full pixel
> unit instead
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0half pixel unit.
> +=C2=A0=C2=A0=C2=A0=C2=A0* - __u8
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- ``f_code[2][2]``
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- Motion vectors code.
> +=C2=A0=C2=A0=C2=A0=C2=A0* - :cspan:`2`
> +
> +
> +``V4L2_CID_MPEG_VIDEO_MPEG2_PIC_EXT``
> +=C2=A0=C2=A0=C2=A0=C2=A0(enum)
> +
> +.. tabularcolumns:: |p{4.0cm}|p{2.5cm}|p{11.0cm}|
> +
> +.. c:type:: v4l2_mpeg_video_mpeg2_pic_ext
> +
> +.. cssclass:: longtable
> +
> +.. flat-table:: struct v4l2_mpeg_video_mpeg2_pic_ext
> +=C2=A0=C2=A0=C2=A0=C2=A0:header-rows:=C2=A0=C2=A00
> +=C2=A0=C2=A0=C2=A0=C2=A0:stub-columns: 0
> +=C2=A0=C2=A0=C2=A0=C2=A0:widths:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A01 1 2
> +
> +=C2=A0=C2=A0=C2=A0=C2=A0* - __u8
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- ``f_code[2][2]``
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- Motion vectors code.
> +=C2=A0=C2=A0=C2=A0=C2=A0* - __u8
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- ``intra_dc_precision``
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- Precision of Discrete Cosine trans=
form (0: 8 bits precision,
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A01: 9 bits precision, 2: =
10 bits precision, 11: 11 bits
> precision).
> +=C2=A0=C2=A0=C2=A0=C2=A0* - __u8
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- ``picture_structure``
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- Picture structure (1: interlaced t=
op field,
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A02: interlaced bottom fie=
ld, 3: progressive frame).
> +=C2=A0=C2=A0=C2=A0=C2=A0* - __u8
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- ``top_field_first``
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- If set to 1 and interlaced stream,=
 top field is output
> first.
> +=C2=A0=C2=A0=C2=A0=C2=A0* - __u8
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- ``frame_pred_frame_dct``
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- If set to 1, only frame-DCT and fr=
ame prediction are used.
> +=C2=A0=C2=A0=C2=A0=C2=A0* - __u8
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- ``concealment_motion_vectors``
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0-=C2=A0=C2=A0If set to 1, motion vec=
tors are coded for intra
> macroblocks.
> +=C2=A0=C2=A0=C2=A0=C2=A0* - __u8
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- ``q_scale_type``
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- This flag affects the inverse quan=
tisation process.
> +=C2=A0=C2=A0=C2=A0=C2=A0* - __u8
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- ``intra_vlc_format``
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- This flag affects the decoding of =
transform coefficient
> data.
> +=C2=A0=C2=A0=C2=A0=C2=A0* - __u8
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- ``alternate_scan``
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- This flag affects the decoding of =
transform coefficient
> data.
> +=C2=A0=C2=A0=C2=A0=C2=A0* - __u8
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- ``repeat_first_field``
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- This flag affects how the frames o=
r fields are output by
> decoder.
> +=C2=A0=C2=A0=C2=A0=C2=A0* - __u8
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- ``chroma_420_type``
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- Set the same as ``progressive_fram=
e``. Exists for historical
> reasons.
> +=C2=A0=C2=A0=C2=A0=C2=A0* - __u8
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- ``progressive_frame``
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- If this flag is set to 0, the two =
fields of a frame are two
> interlaced fields,
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0``repeat_first_field`` m=
ust be 0 (two field duration). If
> the flag is set to 1,
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0the two fields are merge=
d into one frame,
> ``picture_structure`` is so set to "Frame"
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0and ``frame_pred_frame_d=
ct`` to 1.
> +=C2=A0=C2=A0=C2=A0=C2=A0* - __u8
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- ``composite_display``
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- This flag is set to 1 if pictures =
are encoded as (analog)
> composite video.
> +=C2=A0=C2=A0=C2=A0=C2=A0* - __u8
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- ``v_axis``
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- Used only when pictures are encode=
d according to PAL
> systems. This flag is set to 1
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0on a positive sign, 0 ot=
herwise.
> +=C2=A0=C2=A0=C2=A0=C2=A0* - __u8
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- ``field_sequence``
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- Specifies the number of the field =
of an eight Field Sequence
> for a PAL system or
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0a five Field Sequence fo=
r a NTSC system
> +=C2=A0=C2=A0=C2=A0=C2=A0* - __u8
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- ``sub_carrier``
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- If the flag is set to 0, the sub-c=
arrier/line-frequency
> relationship is correct.
> +=C2=A0=C2=A0=C2=A0=C2=A0* - __u8
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- ``burst_amplitude``
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- Specifies the burst amplitude for =
PAL and NTSC.
> +=C2=A0=C2=A0=C2=A0=C2=A0* - __u8
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- ``sub_carrier_phase``
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- Specifies the phase of the referen=
ce sub-carrier for the
> field synchronization.
> +=C2=A0=C2=A0=C2=A0=C2=A0* - :cspan:`2`
> +
> +
> =C2=A0VPX Control Reference
> =C2=A0---------------------
> =C2=A0
> diff --git a/Documentation/media/uapi/v4l/pixfmt-013.rst
> b/Documentation/media/uapi/v4l/pixfmt-013.rst
> index 728d7ed..32c9ef7 100644
> --- a/Documentation/media/uapi/v4l/pixfmt-013.rst
> +++ b/Documentation/media/uapi/v4l/pixfmt-013.rst
> @@ -55,11 +55,21 @@ Compressed Formats
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- ``V4L2_PIX_FMT_MPEG1``
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- 'MPG1'
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- MPEG1 video elementary stream=
.
> +=C2=A0=C2=A0=C2=A0=C2=A0* .. _V4L2-PIX-FMT-MPEG1-PARSED:
> +
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- ``V4L2_PIX_FMT_MPEG1_PARSED``
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- 'MG1P'
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- MPEG-1 with parsing metadata given=
 through controls, see
> :ref:`MPEG-2 Parsed Control IDs<mpeg2-parsed-control-id>`.
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0* .. _V4L2-PIX-FMT-MPEG2:
> =C2=A0
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- ``V4L2_PIX_FMT_MPEG2``
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- 'MPG2'
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- MPEG2 video elementary stream=
.
> +=C2=A0=C2=A0=C2=A0=C2=A0* .. _V4L2-PIX-FMT-MPEG2-PARSED:
> +
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- ``V4L2_PIX_FMT_MPEG2_PARSED``
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- 'MG2P'
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- MPEG-2 with parsing metadata given=
 through controls, see
> :ref:`MPEG-2 Parsed Control IDs<mpeg2-parsed-control-id>`.
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0* .. _V4L2-PIX-FMT-MPEG4:
> =C2=A0
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- ``V4L2_PIX_FMT_MPEG4``
> diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c
> b/drivers/media/v4l2-core/v4l2-ctrls.c
> index 47001e2..5d02818 100644
> --- a/drivers/media/v4l2-core/v4l2-ctrls.c
> +++ b/drivers/media/v4l2-core/v4l2-ctrls.c
> @@ -760,6 +760,13 @@ const char *v4l2_ctrl_get_name(u32 id)
> =C2=A0	case V4L2_CID_MPEG_VIDEO_MV_V_SEARCH_RANGE:		r
> eturn "Vertical MV Search Range";
> =C2=A0	case V4L2_CID_MPEG_VIDEO_REPEAT_SEQ_HEADER:		r
> eturn "Repeat Sequence Header";
> =C2=A0	case V4L2_CID_MPEG_VIDEO_FORCE_KEY_FRAME:		ret
> urn "Force Key Frame";
> +	/* parsed MPEG-2 controls */
> +	case V4L2_CID_MPEG_VIDEO_MPEG2_SEQ_HDR:		=09
> return "MPEG-2 sequence header";
> +	case V4L2_CID_MPEG_VIDEO_MPEG2_SEQ_EXT:		=09
> return "MPEG-2 sequence extension";
> +	case V4L2_CID_MPEG_VIDEO_MPEG2_SEQ_DISPLAY_EXT:	=09
> return "MPEG-2 sequence display extension";
> +	case V4L2_CID_MPEG_VIDEO_MPEG2_SEQ_MATRIX_EXT:	=09
> return "MPEG-2 sequence quantization matrix";
> +	case V4L2_CID_MPEG_VIDEO_MPEG2_PIC_HDR:		=09
> return "MPEG-2 picture header";
> +	case V4L2_CID_MPEG_VIDEO_MPEG2_PIC_EXT:		=09
> return "MPEG-2 picture extension";
> =C2=A0
> =C2=A0	/* VPX controls */
> =C2=A0	case V4L2_CID_MPEG_VIDEO_VPX_NUM_PARTITIONS:	=09
> return "VPX Number of Partitions";
> @@ -1146,6 +1153,24 @@ void v4l2_ctrl_fill(u32 id, const char **name,
> enum v4l2_ctrl_type *type,
> =C2=A0	case V4L2_CID_RDS_TX_ALT_FREQS:
> =C2=A0		*type =3D V4L2_CTRL_TYPE_U32;
> =C2=A0		break;
> +	case V4L2_CID_MPEG_VIDEO_MPEG2_SEQ_HDR:
> +		*type =3D V4L2_CTRL_TYPE_MPEG2_SEQ_HDR;
> +		break;
> +	case V4L2_CID_MPEG_VIDEO_MPEG2_SEQ_EXT:
> +		*type =3D V4L2_CTRL_TYPE_MPEG2_SEQ_EXT;
> +		break;
> +	case V4L2_CID_MPEG_VIDEO_MPEG2_SEQ_DISPLAY_EXT:
> +		*type =3D V4L2_CTRL_TYPE_MPEG2_SEQ_DISPLAY_EXT;
> +		break;
> +	case V4L2_CID_MPEG_VIDEO_MPEG2_SEQ_MATRIX_EXT:
> +		*type =3D V4L2_CTRL_TYPE_MPEG2_SEQ_MATRIX_EXT;
> +		break;
> +	case V4L2_CID_MPEG_VIDEO_MPEG2_PIC_HDR:
> +		*type =3D V4L2_CTRL_TYPE_MPEG2_PIC_HDR;
> +		break;
> +	case V4L2_CID_MPEG_VIDEO_MPEG2_PIC_EXT:
> +		*type =3D V4L2_CTRL_TYPE_MPEG2_PIC_EXT;
> +		break;
> =C2=A0	default:
> =C2=A0		*type =3D V4L2_CTRL_TYPE_INTEGER;
> =C2=A0		break;
> @@ -1456,6 +1481,14 @@ static int std_validate(const struct v4l2_ctrl
> *ctrl, u32 idx,
> =C2=A0			return -ERANGE;
> =C2=A0		return 0;
> =C2=A0
> +	case V4L2_CTRL_TYPE_MPEG2_SEQ_HDR:
> +	case V4L2_CTRL_TYPE_MPEG2_SEQ_EXT:
> +	case V4L2_CTRL_TYPE_MPEG2_SEQ_DISPLAY_EXT:
> +	case V4L2_CTRL_TYPE_MPEG2_SEQ_MATRIX_EXT:
> +	case V4L2_CTRL_TYPE_MPEG2_PIC_HDR:
> +	case V4L2_CTRL_TYPE_MPEG2_PIC_EXT:
> +		return 0;
> +
> =C2=A0	default:
> =C2=A0		return -EINVAL;
> =C2=A0	}
> @@ -1975,6 +2008,26 @@ static struct v4l2_ctrl *v4l2_ctrl_new(struct
> v4l2_ctrl_handler *hdl,
> =C2=A0	case V4L2_CTRL_TYPE_U32:
> =C2=A0		elem_size =3D sizeof(u32);
> =C2=A0		break;
> +	case V4L2_CTRL_TYPE_MPEG2_SEQ_HDR:
> +		elem_size =3D sizeof(struct
> v4l2_mpeg_video_mpeg2_seq_hdr);
> +		break;
> +	case V4L2_CTRL_TYPE_MPEG2_SEQ_EXT:
> +		elem_size =3D sizeof(struct
> v4l2_mpeg_video_mpeg2_seq_ext);
> +		break;
> +	case V4L2_CTRL_TYPE_MPEG2_SEQ_DISPLAY_EXT:
> +		elem_size =3D
> +			sizeof(struct
> v4l2_mpeg_video_mpeg2_seq_display_ext);
> +		break;
> +	case V4L2_CTRL_TYPE_MPEG2_SEQ_MATRIX_EXT:
> +		elem_size =3D
> +			sizeof(struct
> v4l2_mpeg_video_mpeg2_seq_matrix_ext);
> +		break;
> +	case V4L2_CTRL_TYPE_MPEG2_PIC_HDR:
> +		elem_size =3D sizeof(struct
> v4l2_mpeg_video_mpeg2_pic_hdr);
> +		break;
> +	case V4L2_CTRL_TYPE_MPEG2_PIC_EXT:
> +		elem_size =3D sizeof(struct
> v4l2_mpeg_video_mpeg2_pic_ext);
> +		break;
> =C2=A0	default:
> =C2=A0		if (type < V4L2_CTRL_COMPOUND_TYPES)
> =C2=A0			elem_size =3D sizeof(s32);
> diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c
> b/drivers/media/v4l2-core/v4l2-ioctl.c
> index 0c3f238..55be85d 100644
> --- a/drivers/media/v4l2-core/v4l2-ioctl.c
> +++ b/drivers/media/v4l2-core/v4l2-ioctl.c
> @@ -1232,7 +1232,9 @@ static void v4l_fill_fmtdesc(struct
> v4l2_fmtdesc *fmt)
> =C2=A0		case V4L2_PIX_FMT_H264_MVC:	descr =3D "H.264
> MVC"; break;
> =C2=A0		case V4L2_PIX_FMT_H263:		descr =3D
> "H.263"; break;
> =C2=A0		case V4L2_PIX_FMT_MPEG1:	descr =3D "MPEG-1 ES";
> break;
> +		case V4L2_PIX_FMT_MPEG1_PARSED:	descr =3D
> "MPEG-1 with parsing metadata"; break;
> =C2=A0		case V4L2_PIX_FMT_MPEG2:	descr =3D "MPEG-2 ES";
> break;
> +		case V4L2_PIX_FMT_MPEG2_PARSED:	descr =3D
> "MPEG-2 with parsing metadata"; break;
> =C2=A0		case V4L2_PIX_FMT_MPEG4:	descr =3D "MPEG-4 part
> 2 ES"; break;
> =C2=A0		case V4L2_PIX_FMT_XVID:		descr =3D
> "Xvid"; break;
> =C2=A0		case V4L2_PIX_FMT_VC1_ANNEX_G:	descr =3D "VC-1
> (SMPTE 412M Annex G)"; break;
> diff --git a/include/uapi/linux/v4l2-controls.h
> b/include/uapi/linux/v4l2-controls.h
> index 0d2e1e0..deff646 100644
> --- a/include/uapi/linux/v4l2-controls.h
> +++ b/include/uapi/linux/v4l2-controls.h
> @@ -547,6 +547,92 @@ enum v4l2_mpeg_video_mpeg4_profile {
> =C2=A0};
> =C2=A0#define V4L2_CID_MPEG_VIDEO_MPEG4_QPEL		(V4L2_CID_MPEG
> _BASE+407)
> =C2=A0
> +/* parsed MPEG-2 controls
> + * (needed by stateless video decoders)
> + * Those controls have been defined based on MPEG-2 standard ISO/IEC
> 13818-2,
> + * and so derive directly from the MPEG-2 video bitstream syntax
> including
> + * how it is coded inside bitstream (enumeration values for ex.).
> + */

There is a format for comment so they can be used to generate
documentation. See videodev2.h structures for details.

> +#define MPEG2_QUANTISER_MATRIX_SIZE	64
> +#define V4L2_CID_MPEG_VIDEO_MPEG2_SEQ_HDR		(V4L2_CID_M
> PEG_BASE+450)
> +struct v4l2_mpeg_video_mpeg2_seq_hdr {
> +	__u16	width, height;

I do believe you should have one attribute per line.

> +	__u8	aspect_ratio_info;
> +	__u8	frame_rate_code;
> +	__u32	bitrate_value;
> +	__u16	vbv_buffer_size;
> +	__u8	constrained_parameters_flag;
> +	__u8	load_intra_quantiser_matrix,
> load_non_intra_quantiser_matrix;
> +	__u8	intra_quantiser_matrix[MPEG2_QUANTISER_MATRIX_SI
> ZE];
> +	__u8	non_intra_quantiser_matrix[MPEG2_QUANTISER_MATRI
> X_SIZE];
> +	__u32	par_w, par_h;
> +	__u32	fps_n, fps_d;
> +	__u32	bitrate;
> +};
> +#define V4L2_CID_MPEG_VIDEO_MPEG2_SEQ_EXT		(V4L2_CID_M
> PEG_BASE+451)
> +struct v4l2_mpeg_video_mpeg2_seq_ext {
> +	__u8	profile;
> +	__u8	level;
> +	__u8	progressive;
> +	__u8	chroma_format;
> +	__u8	horiz_size_ext, vert_size_ext;
> +	__u16	bitrate_ext;
> +	__u8	vbv_buffer_size_ext;
> +	__u8	low_delay;
> +	__u8	fps_n_ext, fps_d_ext;
> +};
> +#define V4L2_CID_MPEG_VIDEO_MPEG2_SEQ_DISPLAY_EXT	(V4L2_CID_M
> PEG_BASE+452)
> +struct v4l2_mpeg_video_mpeg2_seq_display_ext {
> +	__u8	video_format;
> +	__u8	colour_description_flag;
> +	__u8	colour_primaries;
> +	__u8	transfer_characteristics;
> +	__u8	matrix_coefficients;
> +	__u16	display_horizontal_size;
> +	__u16	display_vertical_size;
> +};
> +#define V4L2_CID_MPEG_VIDEO_MPEG2_SEQ_MATRIX_EXT	(V4L2_CID_MP
> EG_BASE+453)
> +struct v4l2_mpeg_video_mpeg2_seq_matrix_ext {
> +	__u8	load_intra_quantiser_matrix;
> +	__u8	intra_quantiser_matrix[MPEG2_QUANTISER_MATRIX_SI
> ZE];
> +	__u8	load_non_intra_quantiser_matrix;
> +	__u8	non_intra_quantiser_matrix[MPEG2_QUANTISER_MATRI
> X_SIZE];
> +	__u8	load_chroma_intra_quantiser_matrix;
> +	__u8	chroma_intra_quantiser_matrix[MPEG2_QUANTISER_MA
> TRIX_SIZE];
> +	__u8	load_chroma_non_intra_quantiser_matrix;
> +	__u8	chroma_non_intra_quantiser_matrix[MPEG2_QUANTISE
> R_MATRIX_SIZE];
> +};
> +#define V4L2_CID_MPEG_VIDEO_MPEG2_PIC_HDR		(V4L2_CID_M
> PEG_BASE+454)
> +struct v4l2_mpeg_video_mpeg2_pic_hdr {
> +	__u32	offset;
> +	__u16	tsn;
> +	__u8	pic_type;
> +	__u16	vbv_delay;
> +	__u8	full_pel_forward_vector,
> full_pel_backward_vector;
> +	__u8	f_code[2][2];
> +};
> +#define V4L2_CID_MPEG_VIDEO_MPEG2_PIC_EXT		(V4L2_CID_M
> PEG_BASE+455)
> +struct v4l2_mpeg_video_mpeg2_pic_ext {
> +	__u8	f_code[2][2];
> +	__u8	intra_dc_precision;
> +	__u8	picture_structure;
> +	__u8	top_field_first;
> +	__u8	frame_pred_frame_dct;
> +	__u8	concealment_motion_vectors;
> +	__u8	q_scale_type;
> +	__u8	intra_vlc_format;
> +	__u8	alternate_scan;
> +	__u8	repeat_first_field;
> +	__u8	chroma_420_type;
> +	__u8	progressive_frame;
> +	__u8	composite_display;
> +	__u8	v_axis;
> +	__u8	field_sequence;
> +	__u8	sub_carrier;
> +	__u8	burst_amplitude;
> +	__u8	sub_carrier_phase;
> +};
> +
> =C2=A0/*=C2=A0=C2=A0Control IDs for VP8 streams
> =C2=A0 *=C2=A0=C2=A0Although VP8 is not part of MPEG we add these control=
s to the
> MPEG class
> =C2=A0 *=C2=A0=C2=A0as that class is already handling other video compres=
sion
> standards
> diff --git a/include/uapi/linux/videodev2.h
> b/include/uapi/linux/videodev2.h
> index 46e8a2e3..ada8a62 100644
> --- a/include/uapi/linux/videodev2.h
> +++ b/include/uapi/linux/videodev2.h
> @@ -623,7 +623,9 @@ struct v4l2_pix_format {
> =C2=A0#define V4L2_PIX_FMT_H264_MVC v4l2_fourcc('M', '2', '6', '4') /*
> H264 MVC */
> =C2=A0#define V4L2_PIX_FMT_H263=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0v4l2_fourcc(=
'H', '2', '6', '3') /*
> H263=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0*/
> =C2=A0#define V4L2_PIX_FMT_MPEG1=C2=A0=C2=A0=C2=A0=C2=A0v4l2_fourcc('M', =
'P', 'G', '1') /*
> MPEG-1 ES=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0*/
> +#define V4L2_PIX_FMT_MPEG1_PARSED v4l2_fourcc('M', 'G', '1', 'P') /*
> MPEG1 with parsing metadata given through controls */
> =C2=A0#define V4L2_PIX_FMT_MPEG2=C2=A0=C2=A0=C2=A0=C2=A0v4l2_fourcc('M', =
'P', 'G', '2') /*
> MPEG-2 ES=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0*/
> +#define V4L2_PIX_FMT_MPEG2_PARSED v4l2_fourcc('M', 'G', '2', 'P') /*
> MPEG2 with parsing metadata given through controls */
> =C2=A0#define V4L2_PIX_FMT_MPEG4=C2=A0=C2=A0=C2=A0=C2=A0v4l2_fourcc('M', =
'P', 'G', '4') /*
> MPEG-4 part 2 ES */
> =C2=A0#define V4L2_PIX_FMT_XVID=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0v4l2_fourcc(=
'X', 'V', 'I', 'D') /*
> Xvid=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0*/
> =C2=A0#define V4L2_PIX_FMT_VC1_ANNEX_G v4l2_fourcc('V', 'C', '1', 'G') /*
> SMPTE 421M Annex G compliant stream */
> @@ -1601,6 +1603,12 @@ enum v4l2_ctrl_type {
> =C2=A0	V4L2_CTRL_TYPE_U8	=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=3D 0x0100,
> =C2=A0	V4L2_CTRL_TYPE_U16	=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=3D 0x0101,
> =C2=A0	V4L2_CTRL_TYPE_U32	=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=3D 0x0102,
> +	V4L2_CTRL_TYPE_MPEG2_SEQ_HDR=C2=A0=C2=A0=3D 0x0109,
> +	V4L2_CTRL_TYPE_MPEG2_SEQ_EXT=C2=A0=C2=A0=3D 0x010A,
> +	V4L2_CTRL_TYPE_MPEG2_SEQ_DISPLAY_EXT=C2=A0=C2=A0=3D 0x010B,
> +	V4L2_CTRL_TYPE_MPEG2_SEQ_MATRIX_EXT=C2=A0=C2=A0=3D 0x010C,
> +	V4L2_CTRL_TYPE_MPEG2_PIC_HDR=C2=A0=C2=A0=3D 0x010D,
> +	V4L2_CTRL_TYPE_MPEG2_PIC_EXT=C2=A0=C2=A0=3D 0x010E,
> =C2=A0};
> =C2=A0
> =C2=A0/*=C2=A0=C2=A0Used in the VIDIOC_QUERYCTRL ioctl for querying contr=
ols */
--=-TXDuOEM/HnTZi0wwtysE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iEYEABECAAYFAlidIHoACgkQcVMCLawGqBwgMwCg1Al8qInoHDB15N1r7AGTYxYn
6XkAniybQ64oU6vGsqMEggXjCLsFn5Dc
=00LH
-----END PGP SIGNATURE-----

--=-TXDuOEM/HnTZi0wwtysE--

