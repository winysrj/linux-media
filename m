Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-io0-f180.google.com ([209.85.223.180]:34397 "EHLO
        mail-io0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751023AbdGIAcj (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sat, 8 Jul 2017 20:32:39 -0400
Received: by mail-io0-f180.google.com with SMTP id r36so11258911ioi.1
        for <linux-media@vger.kernel.org>; Sat, 08 Jul 2017 17:32:38 -0700 (PDT)
Message-ID: <1499560355.10149.1.camel@ndufresne.ca>
Subject: Re: [PATCH v6 1/3] [media] v4l: add parsed MPEG-2 support
From: Nicolas Dufresne <nicolas@ndufresne.ca>
To: ayaka <ayaka@soulik.info>
Cc: Hugues FRUCHET <hugues.fruchet@st.com>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Jean Christophe TROTIN <jean-christophe.trotin@st.com>
Date: Sat, 08 Jul 2017 20:32:35 -0400
In-Reply-To: <105c6305-8b39-8519-414a-ba80d075f5f4@soulik.info>
References: <1493385949-2962-1-git-send-email-hugues.fruchet@st.com>
         <1493385949-2962-2-git-send-email-hugues.fruchet@st.com>
         <a04de6cc-6775-9564-44c2-664c6f234f12@soulik.info>
         <ff94471e-5f38-f0a6-5ff6-271acef2eea7@st.com>
         <44ac1d87-a86d-1d6c-f162-e859533c9566@soulik.info>
         <1499452436.31895.5.camel@ndufresne.ca>
         <105c6305-8b39-8519-414a-ba80d075f5f4@soulik.info>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
        boundary="=-CxIz3PeNrEzyfz+BK1Fd"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-CxIz3PeNrEzyfz+BK1Fd
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Le samedi 08 juillet 2017 =C3=A0 13:16 +0800, ayaka a =C3=A9crit :
>=20
> On 07/08/2017 02:33 AM, Nicolas Dufresne wrote:
> > Le samedi 08 juillet 2017 =C3=A0 01:29 +0800, ayaka a =C3=A9crit :
> > > On 07/04/2017 05:29 PM, Hugues FRUCHET wrote:
> > > > Hi Randy,
> > > > Thanks for review, and sorry for late reply, answers inline.
> > > > BR,
> > > > Hugues.
> > > >=20
> > > > On 06/11/2017 01:41 PM, ayaka wrote:
> > > > > On 04/28/2017 09:25 PM, Hugues Fruchet wrote:
> > > > > > Add "parsed MPEG-2" pixel format & related controls
> > > > > > needed by stateless video decoders.
> > > > > > In order to decode the video bitstream chunk provided
> > > > > > by user on output queue, stateless decoders require
> > > > > > also some extra data resulting from this video bitstream
> > > > > > chunk parsing.
> > > > > > Those parsed extra data have to be set by user through
> > > > > > control framework using the dedicated mpeg video extended
> > > > > > controls introduced in this patchset.
> > > > >=20
> > > > > I have compared those v4l2 controls with the registers of the roc=
kchip
> > > > > video IP.
> > > > >=20
> > > > > Most of them are met, but only lacks of sw_init_qp.
> > > >=20
> > > > In case of MPEG-1/2, this register seems forced to 1, please double
> > > > check the on2 headers parsing library related to MPEG2. Nevertheles=
s, I
> > > > see this hardware register used with VP8/H264.
> > >=20
> > > Yes, it is forced to be 1. We can skip this field for MPEG1/2
> > > > Hence, no need to put this field on MPEG-2 interface, but should co=
me
> > > > with VP8/H264.
> > > >=20
> > > > > Here is the full translation table of the registers of the rockch=
ip
> > > > > video IP.
> > > > >=20
> > > > > q_scale_type
> > > > > sw_qscale_type
> > > > > concealment_motion_vectors                        sw_con_mv_e
> > > > > intra_dc_precision                                          sw_in=
tra_dc_prec
> > > > > intra_vlc_format
> > > > > sw_intra_vlc_tab
> > > > > frame_pred_frame_dct                                  sw_frame_pr=
ed_dct
> > > > >=20
> > > > > alternate_scan
> > > > > sw_alt_scan_flag_e
> > > > >=20
> > > > > f_code
> > > > > sw_fcode_bwd_ver
> > > > >                                                                  =
        =20
> > > > > sw_fcode_bwd_hor
> > > > >                                                                  =
        =20
> > > > > sw_fcode_fwd_ver
> > > > >                                                                  =
        =20
> > > > > sw_fcode_fwd_hor
> > > > > full_pel_forward_vector                                  sw_mv_ac=
curacy_fwd
> > > > > full_pel_backward_vector                               sw_mv_accu=
racy_bwd
> > > > >=20
> > > > >=20
> > > > > I also saw you add two format for parsed MPEG-2/MPEG-1 format, I =
would
> > > > > not recommand to do that.
> > > >=20
> > > > We need to differentiate MPEG-1/MPEG-2, not all the fields are
> > > > applicable depending on version.
> > >=20
> > > Usually the MPEG-2 decoder could support MPEG-1, as I know, the synta=
x
> > > of byte stream of them are the same.
> > > > > That is what google does, because for a few video format and some
> > > > > hardware, they just request a offsets from the original video byt=
e stream.
> > > >=20
> > > > I don't understand your comment, perhaps have you some as a basis o=
f
> > > > discussion ?
> > >=20
> > > I mean
> > >=20
> > > V4L2-PIX-FMT-MPEG2-PARSED V4L2-PIX-FMT-MPEG1-PARSED I wonder whether =
you
> > > want use the new format to inform the userspace that this device is f=
or
> > > stateless video decoder, as google defined something like
> > > V4L2_PIX_FMT_H264_SLICE. I think the driver registers some controls i=
s
> > > enough for the userspace to detect whether it is a stateless device. =
Or
> > > it will increase the work of the userspace(I mean Gstreamer).
> >=20
> > Just a note that SLICE has nothing to do with PARSED here. You could
> > have an H264 decoder that is stateless and support handling slices
> > rather then full frames (e.g. V4L2_PIX_FMT_H264_SLICE_PARSED could be
> > valid).
>=20
> Actually, they have the same meanings, the H264_SLICE is not a slice, it=
=20
> is an access unit in the rockchip vpu driver for Google.

Let's make sure this never get into mainline unmodified. H264_SLICE
should indicate that encoded buffer need to contains at least one
slice. We already have a format that indicates that a complete AU must
be passed. I do have active project going on where we really want to
pass slice for low latency cases and I would really appreciate if that
name can be used.

> >=20
> > I would not worry to much about Gst, as we will likely use this device
> > through the libv4l2 here, hence will only notice the "emulated"
> > V4L2_PIX_FMT_MPEG2 and ignore the _PARSED variant. And without libv4l2,
> > we'd just ignore this driver completely. I doubt we will implement per-
> > device parsing inside Gst itself if it's already done in an external
> > library for us. libv4l2 might need some fixing, but hopefully it's not
> > beyond repair.
>=20
> As Gstreamer has merged the VA-API before, I would like to merge it into=
=20
> Gstreamer directly.
> Also for performance reason and my experience, the buffer management=20
> would be a big problem, we need to increase the another layer to v4l2=20
> plugins then.
> When the parser is split from its caller, it would be hard to add a path=
=20
> for error handing or something else.

I totally fail to understand your point here. Existing driver have a
separate core that do hide all the parsing and error handling, yet it
works relatively well this way. GStreamer is pretty high level user of
CODECS, fine grained errors and having to recover these only increase
the complexity. Same apply for Chrome. If a software library hides the
parsing, what's the difference ? If a new API inside libv4l2 is needed,
I'm sure it can be added, but Hugues proposal does not seem to indicate
that.

>=20
> P.S I have dropped my original plan about writing a new v4l2 driver for=
=20
> rockchip, but reuse the v4l2 logic from google and rewrite the hal part=
=20
> and rewrite what I need to save the time. It would comes soon
> >=20
> > > > Offset from the beginning of original video bitstream is supported
> > > > within proposed interface, see v4l2_mpeg_video_mpeg2_pic_hd->offset=
 field.
> > > >=20
> > > > > > > > > > Signed-off-by: Hugues Fruchet<hugues.fruchet@st.com>
> > > > > >=20
> > > > > > ---
> > > > > >     Documentation/media/uapi/v4l/extended-controls.rst | 363 ++=
+++++++++++++++++++
> > > > > >     Documentation/media/uapi/v4l/pixfmt-013.rst        |  10 +
> > > > > >     Documentation/media/uapi/v4l/vidioc-queryctrl.rst  |  38 ++=
-
> > > > > >     Documentation/media/videodev2.h.rst.exceptions     |   6 +
> > > > > >     drivers/media/v4l2-core/v4l2-ctrls.c               |  53 ++=
+
> > > > > >     drivers/media/v4l2-core/v4l2-ioctl.c               |   2 +
> > > > > >     include/uapi/linux/v4l2-controls.h                 |  94 ++=
++++
> > > > > >     include/uapi/linux/videodev2.h                     |   8 +
> > > > > >     8 files changed, 572 insertions(+), 2 deletions(-)
> > > > > >=20
> > > > > > diff --git a/Documentation/media/uapi/v4l/extended-controls.rst=
 b/Documentation/media/uapi/v4l/extended-controls.rst
> > > > > > index abb1057..b48eac9 100644
> > > > > > --- a/Documentation/media/uapi/v4l/extended-controls.rst
> > > > > > +++ b/Documentation/media/uapi/v4l/extended-controls.rst
> > > > > > @@ -1827,6 +1827,369 @@ enum v4l2_mpeg_cx2341x_video_median_fil=
ter_type -
> > > > > >         not insert, 1 =3D insert packets.
> > > > > >    =20
> > > > > >    =20
> > > > > > +MPEG-2 Parsed Control Reference
> > > > > > +---------------------------------
> > > > > > +
> > > > > > +The MPEG-2 parsed decoding controls are needed by stateless vi=
deo decoders.
> > > > > > +Those decoders expose :ref:`Compressed formats <compressed-for=
mats>` :ref:`V4L2_PIX_FMT_MPEG1_PARSED<V4L2-PIX-FMT-MPEG1-PARSED>` or :ref:=
`V4L2_PIX_FMT_MPEG2_PARSED<V4L2-PIX-FMT-MPEG2-PARSED>`.
> > > > > > +In order to decode the video bitstream chunk provided by user =
on output queue,
> > > > > > +stateless decoders require also some extra data resulting from=
 this video
> > > > > > +bitstream chunk parsing. Those parsed extra data have to be se=
t by user
> > > > > > +through control framework using the mpeg video extended contro=
ls defined
> > > > > > +in this section. Those controls have been defined based on MPE=
G-2 standard
> > > > > > +ISO/IEC 13818-2, and so derive directly from the MPEG-2 video =
bitstream syntax
> > > > > > +including how it is coded inside bitstream (enumeration values=
 for ex.).
> > > > > > +
> > > > > > +MPEG-2 Parsed Control IDs
> > > > > > +^^^^^^^^^^^^^^^^^^^^^^^^^^^
> > > > > > +
> > > > > > +.. _mpeg2-parsed-control-id:
> > > > > > +
> > > > > > +.. c:type:: V4L2_CID_MPEG_VIDEO_MPEG2_SEQ_HDR
> > > > > > +    (enum)
> > > > > > +
> > > > > > +.. tabularcolumns:: |p{4.0cm}|p{2.5cm}|p{11.0cm}|
> > > > > > +
> > > > > > +.. c:type:: v4l2_mpeg_video_mpeg2_seq_hdr
> > > > > > +
> > > > > > +.. cssclass:: longtable
> > > > > > +
> > > > > > +.. flat-table:: struct v4l2_mpeg_video_mpeg2_seq_hdr
> > > > > > +    :header-rows:  0
> > > > > > +    :stub-columns: 0
> > > > > > +    :widths:       1 1 2
> > > > > > +
> > > > > > +    * - __u16
> > > > > > +      - ``width``
> > > > > > +      - Video width in pixels.
> > > > > > +    * - __u16
> > > > > > +      - ``height``
> > > > > > +      - Video height in pixels.
> > > > > > +    * - __u8
> > > > > > +      - ``aspect_ratio_info``
> > > > > > +      - Aspect ratio code as in the bitstream (1: 1:1 square p=
ixels,
> > > > > > +        2: 4:3 display, 3: 16:9 display, 4: 2.21:1 display)
> > > > > > +    * - __u8
> > > > > > +      - ``framerate code``
> > > > > > +      - Framerate code as in the bitstream
> > > > > > +        (1: 24000/1001.0 '23.976 fps, 2: 24.0, 3: 25.0,
> > > > > > +        4: 30000/1001.0 '29.97, 5: 30.0, 6: 50.0, 7: 60000/100=
1.0,
> > > > > > +        8: 60.0)
> > > > > > +    * - __u16
> > > > > > +      - ``vbv_buffer_size``
> > > > > > +      -  Video Buffering Verifier size, expressed in 16KBytes =
unit.
> > > > > > +    * - __u32
> > > > > > +      - ``bitrate_value``
> > > > > > +      - Bitrate value as in the bitstream, expressed in 400bps=
 unit
> > > > > > +    * - __u16
> > > > > > +      - ``constrained_parameters_flag``
> > > > > > +      - Set to 1 if this bitstream uses constrained parameters=
.
> > > > > > +    * - __u8
> > > > > > +      - ``load_intra_quantiser_matrix``
> > > > > > +      - If set to 1, ``intra_quantiser_matrix`` table is to be=
 used for
> > > > > > +        decoding.
> > > > > > +    * - __u8
> > > > > > +      - ``load_non_intra_quantiser_matrix``
> > > > > > +      - If set to 1, ``non_intra_quantiser_matrix`` table is t=
o be used for
> > > > > > +        decoding.
> > > > > > +    * - __u8
> > > > > > +      - ``intra_quantiser_matrix[64]``
> > > > > > +      - Intra quantization table, in zig-zag scan order.
> > > > > > +    * - __u8
> > > > > > +      - ``non_intra_quantiser_matrix[64]``
> > > > > > +      - Non-intra quantization table, in zig-zag scan order.
> > > > > > +    * - __u32
> > > > > > +      - ``par_w``
> > > > > > +      - Pixel aspect ratio width in pixels.
> > > > > > +    * - __u32
> > > > > > +      - ``par_h``
> > > > > > +      - Pixel aspect ratio height in pixels.
> > > > > > +    * - __u32
> > > > > > +      - ``fps_n``
> > > > > > +      - Framerate nominator.
> > > > > > +    * - __u32
> > > > > > +      - ``fps_d``
> > > > > > +      - Framerate denominator.
> > > > > > +    * - __u32
> > > > > > +      - ``bitrate``
> > > > > > +      - Bitrate in bps if constant bitrate, 0 otherwise.
> > > > > > +    * - :cspan:`2`
> > > > > > +
> > > > > > +
> > > > > > +.. c:type:: V4L2_CID_MPEG_VIDEO_MPEG2_SEQ_EXT
> > > > > > +    (enum)
> > > > > > +
> > > > > > +.. tabularcolumns:: |p{4.0cm}|p{2.5cm}|p{11.0cm}|
> > > > > > +
> > > > > > +.. c:type:: v4l2_mpeg_video_mpeg2_seq_ext
> > > > > > +
> > > > > > +.. cssclass:: longtable
> > > > > > +
> > > > > > +.. flat-table:: struct v4l2_mpeg_video_mpeg2_seq_ext
> > > > > > +    :header-rows:  0
> > > > > > +    :stub-columns: 0
> > > > > > +    :widths:       1 1 2
> > > > > > +
> > > > > > +    * - __u8
> > > > > > +      - ``profile``
> > > > > > +      - Encoding profile used to encode this bitstream.
> > > > > > +        (1: High Profile, 2: Spatially Scalable Profile,
> > > > > > +        3: SNR Scalable Profile, 4: Main Profile, 5: Simple Pr=
ofile).
> > > > > > +    * - __u8
> > > > > > +      - ``level``
> > > > > > +      - Encoding level used to encode this bitstream
> > > > > > +        (4: High Level, 6: High 1440 Level, 8: Main Level, 10:=
 Low Level).
> > > > > > +    * - __u8
> > > > > > +      - ``progressive``
> > > > > > +      - Set to 1 if frames are progressive (vs interlaced).
> > > > > > +    * - __u8
> > > > > > +      - ``chroma_format``
> > > > > > +      - Chrominance format (1: 420, 2: 422, 3: 444).
> > > > > > +    * - __u8
> > > > > > +      - ``horiz_size_ext``
> > > > > > +      - Horizontal size extension. This value is to be shifted=
 12 bits left
> > > > > > +        and added to ''seq_hdr->width'' to get the final video=
 width:
> > > > > > +        `width =3D seq_hdr->width + seq_ext->horiz_size_ext <<=
 12`
> > > > > > +    * - __u8
> > > > > > +      - ``vert_size_ext``
> > > > > > +      - Vertical size extension. This value is to be shifted 1=
2 bits left
> > > > > > +        and added to ''seq_hdr->height'' to get the final vide=
o height:
> > > > > > +        `height =3D seq_hdr->height + seq_ext->vert_size_ext <=
< 12`
> > > > > > +    * - __u16
> > > > > > +      - ``bitrate_ext``
> > > > > > +      -  Bitrate extension. This value, expressed in 400bps un=
it, is to be
> > > > > > +         shifted 18 bits left and added to ''seq_hdr->bitrate'=
' to get the
> > > > > > +         final bitrate:
> > > > > > +         `bitrate =3D seq_hdr->bitrate + (seq_ext->bitrate_ext=
 << 18) * 400`
> > > > > > +    * - __u8
> > > > > > +      - ``vbv_buffer_size_ext``
> > > > > > +      -  Video Buffering Verifier size extension in bits.
> > > > > > +    * - __u8
> > > > > > +      - ``low_delay``
> > > > > > +      -  Low delay. Set to 1 if no B pictures are present.
> > > > > > +    * - __u8
> > > > > > +      - ``fps_n_ext``
> > > > > > +      -  Framerate extension nominator. This value is to be in=
cremented and
> > > > > > +         multiplied by ''seq_hdr->fps_n'' to get the final fra=
merate
> > > > > > +         nominator:
> > > > > > +         `fps_n =3D seq_hdr->fps_n * (seq_ext->fps_n_ext + 1)`
> > > > > > +    * - __u8
> > > > > > +      - ``fps_d_ext``
> > > > > > +      -  Framerate extension denominator. This value is to be =
incremented and
> > > > > > +         multiplied by ''seq_hdr->fps_d'' to get the final fra=
merate
> > > > > > +         denominator:
> > > > > > +         `fps_d =3D seq_hdr->fps_d * (seq_ext->fps_d_ext + 1)`
> > > > > > +    * - :cspan:`2`
> > > > > > +
> > > > > > +
> > > > > > +.. c:type:: V4L2_CID_MPEG_VIDEO_MPEG2_SEQ_DISPLAY_EXT
> > > > > > +    (enum)
> > > > > > +
> > > > > > +.. tabularcolumns:: |p{4.0cm}|p{2.5cm}|p{11.0cm}|
> > > > > > +
> > > > > > +.. c:type:: v4l2_mpeg_video_mpeg2_seq_display_ext
> > > > > > +
> > > > > > +.. cssclass:: longtable
> > > > > > +
> > > > > > +.. flat-table:: struct v4l2_mpeg_video_mpeg2_seq_display_ext
> > > > > > +    :header-rows:  0
> > > > > > +    :stub-columns: 0
> > > > > > +    :widths:       1 1 2
> > > > > > +
> > > > > > +    * - __u16
> > > > > > +      - ``display_horizontal_size``, ``display_vertical_size``
> > > > > > +      - Dimensions of the video to be displayed. If those dime=
nsions
> > > > > > +        are smaller than the final video dimensions, only this=
 area
> > > > > > +        must be displayed.
> > > > > > +    * - __u8
> > > > > > +      - ``video_format``
> > > > > > +      - Video standard (0: Components, 1: PAL, 2: NTSC, 3: SEC=
AM, 4:MAC)
> > > > > > +    * - __u8
> > > > > > +      - ``colour_description_flag``
> > > > > > +      - If set to 1, ''colour_primaries'', ''transfer_characte=
ristics'',
> > > > > > +        ''matrix_coefficients'' are to be used for decoding.
> > > > > > +    * - __u8
> > > > > > +      - ``colour_primaries``
> > > > > > +      - Colour coding standard (1: ITU-R Rec. 709 (1990),
> > > > > > +        4: ITU-R Rec. 624-4 System M, 5: ITU-R Rec. 624-4 Syst=
em B, G,
> > > > > > +        6: SMPTE 170M, 7: SMPTE 240M (1987))
> > > > > > +    * - __u8
> > > > > > +      - ``transfer_characteristics``
> > > > > > +      - Transfer characteristics coding standard (1: ITU-R Rec=
. 709 (1990),
> > > > > > +        4: ITU-R Rec. 624-4 System M, 5: ITU-R Rec. 624-4 Syst=
em B, G,
> > > > > > +        6: SMPTE 170M, 7: SMPTE 240M (1987))
> > > > > > +    * - __u8
> > > > > > +      - ``matrix_coefficients``
> > > > > > +      - Matrix coefficients coding standard (1: ITU-R Rec. 709=
 (1990),
> > > > > > +        4: FCC, 5: ITU-R Rec. 624-4 System B, G, 6: SMPTE 170M=
,
> > > > > > +        7: SMPTE 240M (1987))
> > > > > > +    * - :cspan:`2`
> > > > > > +
> > > > > > +
> > > > > > +.. c:type:: V4L2_CID_MPEG_VIDEO_MPEG2_SEQ_MATRIX_EXT
> > > > > > +    (enum)
> > > > > > +
> > > > > > +.. tabularcolumns:: |p{4.0cm}|p{2.5cm}|p{11.0cm}|
> > > > > > +
> > > > > > +.. c:type:: v4l2_mpeg_video_mpeg2_seq_matrix_ext
> > > > > > +
> > > > > > +.. cssclass:: longtable
> > > > > > +
> > > > > > +.. flat-table:: struct v4l2_mpeg_video_mpeg2_seq_matrix_ext
> > > > > > +    :header-rows:  0
> > > > > > +    :stub-columns: 0
> > > > > > +    :widths:       1 1 2
> > > > > > +
> > > > > > +    * - __u8
> > > > > > +      - ``load_intra_quantiser_matrix``
> > > > > > +      - If set to 1, ``intra_quantiser_matrix`` table is to be=
 used for
> > > > > > +        decoding.
> > > > > > +    * - __u8
> > > > > > +      - ``intra_quantiser_matrix[64]``
> > > > > > +      - Intra quantization table, in zig-zag scan order.
> > > > > > +    * - __u8
> > > > > > +      - ``load_non_intra_quantiser_matrix``
> > > > > > +      - If set to 1, ``non_intra_quantiser_matrix`` table is t=
o be used for
> > > > > > +        decoding.
> > > > > > +    * - __u8
> > > > > > +      - ``non_intra_quantiser_matrix[64]``
> > > > > > +      - Non-intra quantization table, in zig-zag scan order.
> > > > > > +    * - __u8
> > > > > > +      - ``load_chroma_intra_quantiser_matrix``
> > > > > > +      - If set to 1, ``chroma_intra_quantiser_matrix`` table i=
s to be used for
> > > > > > +        decoding.
> > > > > > +    * - __u8
> > > > > > +      - ``chroma_intra_quantiser_matrix[64]``
> > > > > > +      - Chroma intra quantization table, in zig-zag scan order=
.
> > > > > > +    * - __u8
> > > > > > +      - ``load_chroma_non_intra_quantiser_matrix``
> > > > > > +      - If set to 1, ``chroma_non_intra_quantiser_matrix`` tab=
le is to be used for
> > > > > > +        decoding.
> > > > > > +    * - __u8
> > > > > > +      - ``chroma_non_intra_quantiser_matrix[64]``
> > > > > > +      - Chroma non-intra quantization table, in zig-zag scan o=
rder.
> > > > > > +    * - :cspan:`2`
> > > > > > +
> > > > > > +
> > > > > > +.. c:type:: V4L2_CID_MPEG_VIDEO_MPEG2_PIC_HDR
> > > > > > +    (enum)
> > > > > > +
> > > > > > +.. tabularcolumns:: |p{4.0cm}|p{2.5cm}|p{11.0cm}|
> > > > > > +
> > > > > > +.. c:type:: v4l2_mpeg_video_mpeg2_pic_hdr
> > > > > > +
> > > > > > +.. cssclass:: longtable
> > > > > > +
> > > > > > +.. flat-table:: struct v4l2_mpeg_video_mpeg2_pic_hdr
> > > > > > +    :header-rows:  0
> > > > > > +    :stub-columns: 0
> > > > > > +    :widths:       1 1 2
> > > > > > +
> > > > > > +    * - __u32
> > > > > > +      - ``offset``
> > > > > > +      - Offset in bytes of the slice data from the beginning o=
f packet.
> > > > > > +    * - __u16
> > > > > > +      - ``tsn``
> > > > > > +      - Temporal Sequence Number: order in which the frames mu=
st be displayed.
> > > > > > +    * - __u16
> > > > > > +      - ``vbv_delay``
> > > > > > +      - Video Buffering Verifier delay, in 90KHz cycles unit.
> > > > > > +    * - __u8
> > > > > > +      - ``pic_type``
> > > > > > +      - Picture coding type (1: Intra, 2: Predictive,
> > > > > > +        3: B, Bidirectionally Predictive, 4: D, DC Intra).
> > > > > > +    * - __u8
> > > > > > +      - ``full_pel_forward_vector``
> > > > > > +      - If set to 1, forward vectors are expressed in full pix=
el unit instead
> > > > > > +        half pixel unit.
> > > > > > +    * - __u8
> > > > > > +      - ``full_pel_backward_vector``
> > > > > > +      - If set to 1, backward vectors are expressed in full pi=
xel unit instead
> > > > > > +        half pixel unit.
> > > > > > +    * - __u8
> > > > > > +      - ``f_code[2][2]``
> > > > > > +      - Motion vectors code.
> > > > > > +    * - :cspan:`2`
> > > > > > +
> > > > > > +
> > > > > > +.. c:type:: V4L2_CID_MPEG_VIDEO_MPEG2_PIC_EXT
> > > > > > +    (enum)
> > > > > > +
> > > > > > +.. tabularcolumns:: |p{4.0cm}|p{2.5cm}|p{11.0cm}|
> > > > > > +
> > > > > > +.. c:type:: v4l2_mpeg_video_mpeg2_pic_ext
> > > > > > +
> > > > > > +.. cssclass:: longtable
> > > > > > +
> > > > > > +.. flat-table:: struct v4l2_mpeg_video_mpeg2_pic_ext
> > > > > > +    :header-rows:  0
> > > > > > +    :stub-columns: 0
> > > > > > +    :widths:       1 1 2
> > > > > > +
> > > > > > +    * - __u8
> > > > > > +      - ``f_code[2][2]``
> > > > > > +      - Motion vectors code.
> > > > > > +    * - __u8
> > > > > > +      - ``intra_dc_precision``
> > > > > > +      - Precision of Discrete Cosine transform (0: 8 bits prec=
ision,
> > > > > > +        1: 9 bits precision, 2: 10 bits precision, 11: 11 bits=
 precision).
> > > > > > +    * - __u8
> > > > > > +      - ``picture_structure``
> > > > > > +      - Picture structure (1: interlaced top field,
> > > > > > +        2: interlaced bottom field, 3: progressive frame).
> > > > > > +    * - __u8
> > > > > > +      - ``top_field_first``
> > > > > > +      - If set to 1 and interlaced stream, top field is output=
 first.
> > > > > > +    * - __u8
> > > > > > +      - ``frame_pred_frame_dct``
> > > > > > +      - If set to 1, only frame-DCT and frame prediction are u=
sed.
> > > > > > +    * - __u8
> > > > > > +      - ``concealment_motion_vectors``
> > > > > > +      -  If set to 1, motion vectors are coded for intra macro=
blocks.
> > > > > > +    * - __u8
> > > > > > +      - ``q_scale_type``
> > > > > > +      - This flag affects the inverse quantisation process.
> > > > > > +    * - __u8
> > > > > > +      - ``intra_vlc_format``
> > > > > > +      - This flag affects the decoding of transform coefficien=
t data.
> > > > > > +    * - __u8
> > > > > > +      - ``alternate_scan``
> > > > > > +      - This flag affects the decoding of transform coefficien=
t data.
> > > > > > +    * - __u8
> > > > > > +      - ``repeat_first_field``
> > > > > > +      - This flag affects how the frames or fields are output =
by decoder.
> > > > > > +    * - __u8
> > > > > > +      - ``chroma_420_type``
> > > > > > +      - Set the same as ``progressive_frame``. Exists for hist=
orical reasons.
> > > > > > +    * - __u8
> > > > > > +      - ``progressive_frame``
> > > > > > +      - If this flag is set to 0, the two fields of a frame ar=
e two interlaced fields,
> > > > > > +        ``repeat_first_field`` must be 0 (two field duration).=
 If the flag is set to 1,
> > > > > > +        the two fields are merged into one frame, ``picture_st=
ructure`` is so set to "Frame"
> > > > > > +        and ``frame_pred_frame_dct`` to 1.
> > > > > > +    * - __u8
> > > > > > +      - ``composite_display``
> > > > > > +      - This flag is set to 1 if pictures are encoded as (anal=
og) composite video.
> > > > > > +    * - __u8
> > > > > > +      - ``v_axis``
> > > > > > +      - Used only when pictures are encoded according to PAL s=
ystems. This flag is set to 1
> > > > > > +        on a positive sign, 0 otherwise.
> > > > > > +    * - __u8
> > > > > > +      - ``field_sequence``
> > > > > > +      - Specifies the number of the field of an eight Field Se=
quence for a PAL system or
> > > > > > +        a five Field Sequence for a NTSC system
> > > > > > +    * - __u8
> > > > > > +      - ``sub_carrier``
> > > > > > +      - If the flag is set to 0, the sub-carrier/line-frequenc=
y relationship is correct.
> > > > > > +    * - __u8
> > > > > > +      - ``burst_amplitude``
> > > > > > +      - Specifies the burst amplitude for PAL and NTSC.
> > > > > > +    * - __u8
> > > > > > +      - ``sub_carrier_phase``
> > > > > > +      - Specifies the phase of the reference sub-carrier for t=
he field synchronization.
> > > > > > +    * - :cspan:`2`
> > > > > > +
> > > > > > +
> > > > > >     VPX Control Reference
> > > > > >     ---------------------
> > > > > >    =20
> > > > > > diff --git a/Documentation/media/uapi/v4l/pixfmt-013.rst b/Docu=
mentation/media/uapi/v4l/pixfmt-013.rst
> > > > > > index 728d7ed..32c9ef7 100644
> > > > > > --- a/Documentation/media/uapi/v4l/pixfmt-013.rst
> > > > > > +++ b/Documentation/media/uapi/v4l/pixfmt-013.rst
> > > > > > @@ -55,11 +55,21 @@ Compressed Formats
> > > > > >           - ``V4L2_PIX_FMT_MPEG1``
> > > > > >           - 'MPG1'
> > > > > >           - MPEG1 video elementary stream.
> > > > > > +    * .. _V4L2-PIX-FMT-MPEG1-PARSED:
> > > > > > +
> > > > > > +      - ``V4L2_PIX_FMT_MPEG1_PARSED``
> > > > > > +      - 'MG1P'
> > > > > > +      - MPEG-1 with parsing metadata given through controls, s=
ee :ref:`MPEG-2 Parsed Control IDs<mpeg2-parsed-control-id>`.
> > > > > >         * .. _V4L2-PIX-FMT-MPEG2:
> > > > > >    =20
> > > > > >           - ``V4L2_PIX_FMT_MPEG2``
> > > > > >           - 'MPG2'
> > > > > >           - MPEG2 video elementary stream.
> > > > > > +    * .. _V4L2-PIX-FMT-MPEG2-PARSED:
> > > > > > +
> > > > > > +      - ``V4L2_PIX_FMT_MPEG2_PARSED``
> > > > > > +      - 'MG2P'
> > > > > > +      - MPEG-2 with parsing metadata given through controls, s=
ee :ref:`MPEG-2 Parsed Control IDs<mpeg2-parsed-control-id>`.
> > > > > >         * .. _V4L2-PIX-FMT-MPEG4:
> > > > > >    =20
> > > > > >           - ``V4L2_PIX_FMT_MPEG4``
> > > > > > diff --git a/Documentation/media/uapi/v4l/vidioc-queryctrl.rst =
b/Documentation/media/uapi/v4l/vidioc-queryctrl.rst
> > > > > > index 41c5744..467f498 100644
> > > > > > --- a/Documentation/media/uapi/v4l/vidioc-queryctrl.rst
> > > > > > +++ b/Documentation/media/uapi/v4l/vidioc-queryctrl.rst
> > > > > > @@ -422,8 +422,42 @@ See also the examples in :ref:`control`.
> > > > > >           - any
> > > > > >           - An unsigned 32-bit valued control ranging from mini=
mum to maximum
> > > > > > > > > >     	inclusive. The step value indicates the increment =
between values.
> > > > > >=20
> > > > > > -
> > > > > > -
> > > > > > +    * - ``V4L2_CTRL_TYPE_MPEG2_SEQ_HDR``
> > > > > > +      - n/a
> > > > > > +      - n/a
> > > > > > +      - n/a
> > > > > > +      - Type of control
> > > > > > > > > > +	:c:type:`V4L2_CID_MPEG_VIDEO_MPEG2_SEQ_HDR`.
> > > > > >=20
> > > > > > +    * - ``V4L2_CTRL_TYPE_MPEG2_SEQ_EXT``
> > > > > > +      - n/a
> > > > > > +      - n/a
> > > > > > +      - n/a
> > > > > > +      - Type of control
> > > > > > > > > > +	:c:type:`V4L2_CID_MPEG_VIDEO_MPEG2_SEQ_EXT`.
> > > > > >=20
> > > > > > +    * - ``V4L2_CTRL_TYPE_MPEG2_SEQ_DISPLAY_EXT``
> > > > > > +      - n/a
> > > > > > +      - n/a
> > > > > > +      - n/a
> > > > > > +      - Type of control
> > > > > > > > > > +	:c:type:`V4L2_CID_MPEG_VIDEO_MPEG2_SEQ_DISPLAY_EXT`.
> > > > > >=20
> > > > > > +    * - ``V4L2_CTRL_TYPE_MPEG2_SEQ_MATRIX_EXT``
> > > > > > +      - n/a
> > > > > > +      - n/a
> > > > > > +      - n/a
> > > > > > +      - Type of control
> > > > > > > > > > +	:c:type:`V4L2_CID_MPEG_VIDEO_MPEG2_SEQ_MATRIX_EXT`.
> > > > > >=20
> > > > > > +    * - ``V4L2_CTRL_TYPE_MPEG2_PIC_HDR``
> > > > > > +      - n/a
> > > > > > +      - n/a
> > > > > > +      - n/a
> > > > > > +      - Type of control
> > > > > > > > > > +	:c:type:`V4L2_CID_MPEG_VIDEO_MPEG2_PIC_HDR`.
> > > > > >=20
> > > > > > +    * - ``V4L2_CTRL_TYPE_MPEG2_PIC_EXT``
> > > > > > +      - n/a
> > > > > > +      - n/a
> > > > > > +      - n/a
> > > > > > +      - Type of control
> > > > > > > > > > +	:c:type:`V4L2_CID_MPEG_VIDEO_MPEG2_PIC_EXT`.
> > > > > >=20
> > > > > >    =20
> > > > > >     .. tabularcolumns:: |p{6.6cm}|p{2.2cm}|p{8.7cm}|
> > > > > >    =20
> > > > > > diff --git a/Documentation/media/videodev2.h.rst.exceptions b/D=
ocumentation/media/videodev2.h.rst.exceptions
> > > > > > index a5cb0a8..b2e2844 100644
> > > > > > --- a/Documentation/media/videodev2.h.rst.exceptions
> > > > > > +++ b/Documentation/media/videodev2.h.rst.exceptions
> > > > > > @@ -129,6 +129,12 @@ replace symbol V4L2_CTRL_TYPE_STRING :c:ty=
pe:`v4l2_ctrl_type`
> > > > > >     replace symbol V4L2_CTRL_TYPE_U16 :c:type:`v4l2_ctrl_type`
> > > > > >     replace symbol V4L2_CTRL_TYPE_U32 :c:type:`v4l2_ctrl_type`
> > > > > >     replace symbol V4L2_CTRL_TYPE_U8 :c:type:`v4l2_ctrl_type`
> > > > > > +replace symbol V4L2_CTRL_TYPE_MPEG2_SEQ_HDR :c:type:`v4l2-ctrl=
-type-mpeg2-seq-hdr`
> > > > > > +replace symbol V4L2_CTRL_TYPE_MPEG2_SEQ_EXT :c:type:`v4l2-ctrl=
-type-mpeg2-seq-ext`
> > > > > > +replace symbol V4L2_CTRL_TYPE_MPEG2_SEQ_DISPLAY_EXT :c:type:`v=
4l2-ctrl-type-mpeg2-seq-display-ext`
> > > > > > +replace symbol V4L2_CTRL_TYPE_MPEG2_SEQ_MATRIX_EXT :c:type:`v4=
l2-ctrl-type-mpeg2-seq-matrix-ext`
> > > > > > +replace symbol V4L2_CTRL_TYPE_MPEG2_PIC_HDR :c:type:`v4l2-ctrl=
-type-mpeg2-pic-hdr`
> > > > > > +replace symbol V4L2_CTRL_TYPE_MPEG2_PIC_EXT :c:type:`v4l2-ctrl=
-type-mpeg2-pic-ext`
> > > > > >    =20
> > > > > >     # V4L2 capability defines
> > > > > >     replace define V4L2_CAP_VIDEO_CAPTURE device-capabilities
> > > > > > diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/med=
ia/v4l2-core/v4l2-ctrls.c
> > > > > > index ec42872..163b122 100644
> > > > > > --- a/drivers/media/v4l2-core/v4l2-ctrls.c
> > > > > > +++ b/drivers/media/v4l2-core/v4l2-ctrls.c
> > > > > > @@ -760,6 +760,13 @@ const char *v4l2_ctrl_get_name(u32 id)
> > > > > > > > > > > > > >     	case V4L2_CID_MPEG_VIDEO_MV_V_SEARCH_RANGE=
:		return "Vertical MV Search Range";
> > > > > > > > > > > > > >     	case V4L2_CID_MPEG_VIDEO_REPEAT_SEQ_HEADER=
:		return "Repeat Sequence Header";
> > > > > > > > > > > > > >     	case V4L2_CID_MPEG_VIDEO_FORCE_KEY_FRAME:	=
	return "Force Key Frame";
> > > > > > > > > >=20
> > > > > > > > > > +	/* parsed MPEG-2 controls */
> > > > > > > > > > > > > > +	case V4L2_CID_MPEG_VIDEO_MPEG2_SEQ_HDR:			ret=
urn "MPEG-2 Sequence Header";
> > > > > > > > > > > > > > +	case V4L2_CID_MPEG_VIDEO_MPEG2_SEQ_EXT:			ret=
urn "MPEG-2 Sequence Extension";
> > > > > > > > > > > > > > +	case V4L2_CID_MPEG_VIDEO_MPEG2_SEQ_DISPLAY_EX=
T:		return "MPEG-2 Sequence Display Extension";
> > > > > > > > > > > > > > +	case V4L2_CID_MPEG_VIDEO_MPEG2_SEQ_MATRIX_EXT=
:		return "MPEG-2 Sequence Quantization Matrix";
> > > > > > > > > > > > > > +	case V4L2_CID_MPEG_VIDEO_MPEG2_PIC_HDR:			ret=
urn "MPEG-2 Picture Header";
> > > > > > > > > > > > > > +	case V4L2_CID_MPEG_VIDEO_MPEG2_PIC_EXT:			ret=
urn "MPEG-2 Picture Extension";
> > > > > >=20
> > > > > >    =20
> > > > > > > > > >     	/* VPX controls */
> > > > > > > > > > > > > >     	case V4L2_CID_MPEG_VIDEO_VPX_NUM_PARTITION=
S:		return "VPX Number of Partitions";
> > > > > >=20
> > > > > > @@ -1150,6 +1157,24 @@ void v4l2_ctrl_fill(u32 id, const char *=
*name, enum v4l2_ctrl_type *type,
> > > > > > > > > >     	case V4L2_CID_RDS_TX_ALT_FREQS:
> > > > > > > > > >     		*type =3D V4L2_CTRL_TYPE_U32;
> > > > > > > > > >     		break;
> > > > > > > > > > +	case V4L2_CID_MPEG_VIDEO_MPEG2_SEQ_HDR:
> > > > > > > > > > +		*type =3D V4L2_CTRL_TYPE_MPEG2_SEQ_HDR;
> > > > > > > > > > +		break;
> > > > > > > > > > +	case V4L2_CID_MPEG_VIDEO_MPEG2_SEQ_EXT:
> > > > > > > > > > +		*type =3D V4L2_CTRL_TYPE_MPEG2_SEQ_EXT;
> > > > > > > > > > +		break;
> > > > > > > > > > +	case V4L2_CID_MPEG_VIDEO_MPEG2_SEQ_DISPLAY_EXT:
> > > > > > > > > > +		*type =3D V4L2_CTRL_TYPE_MPEG2_SEQ_DISPLAY_EXT;
> > > > > > > > > > +		break;
> > > > > > > > > > +	case V4L2_CID_MPEG_VIDEO_MPEG2_SEQ_MATRIX_EXT:
> > > > > > > > > > +		*type =3D V4L2_CTRL_TYPE_MPEG2_SEQ_MATRIX_EXT;
> > > > > > > > > > +		break;
> > > > > > > > > > +	case V4L2_CID_MPEG_VIDEO_MPEG2_PIC_HDR:
> > > > > > > > > > +		*type =3D V4L2_CTRL_TYPE_MPEG2_PIC_HDR;
> > > > > > > > > > +		break;
> > > > > > > > > > +	case V4L2_CID_MPEG_VIDEO_MPEG2_PIC_EXT:
> > > > > > > > > > +		*type =3D V4L2_CTRL_TYPE_MPEG2_PIC_EXT;
> > > > > > > > > > +		break;
> > > > > > > > > >     	default:
> > > > > > > > > >     		*type =3D V4L2_CTRL_TYPE_INTEGER;
> > > > > > > > > >     		break;
> > > > > >=20
> > > > > > @@ -1460,6 +1485,14 @@ static int std_validate(const struct v4l=
2_ctrl *ctrl, u32 idx,
> > > > > > > > > >     			return -ERANGE;
> > > > > > > > > >     		return 0;
> > > > > >=20
> > > > > >    =20
> > > > > > > > > > +	case V4L2_CTRL_TYPE_MPEG2_SEQ_HDR:
> > > > > > > > > > +	case V4L2_CTRL_TYPE_MPEG2_SEQ_EXT:
> > > > > > > > > > +	case V4L2_CTRL_TYPE_MPEG2_SEQ_DISPLAY_EXT:
> > > > > > > > > > +	case V4L2_CTRL_TYPE_MPEG2_SEQ_MATRIX_EXT:
> > > > > > > > > > +	case V4L2_CTRL_TYPE_MPEG2_PIC_HDR:
> > > > > > > > > > +	case V4L2_CTRL_TYPE_MPEG2_PIC_EXT:
> > > > > > > > > > +		return 0;
> > > > > >=20
> > > > > > +
> > > > > > > > > >     	default:
> > > > > > > > > >     		return -EINVAL;
> > > > > > > > > >     	}
> > > > > >=20
> > > > > > @@ -1979,6 +2012,26 @@ static struct v4l2_ctrl *v4l2_ctrl_new(s=
truct v4l2_ctrl_handler *hdl,
> > > > > > > > > >     	case V4L2_CTRL_TYPE_U32:
> > > > > > > > > >     		elem_size =3D sizeof(u32);
> > > > > > > > > >     		break;
> > > > > > > > > > +	case V4L2_CTRL_TYPE_MPEG2_SEQ_HDR:
> > > > > > > > > > +		elem_size =3D sizeof(struct v4l2_mpeg_video_mpeg2_se=
q_hdr);
> > > > > > > > > > +		break;
> > > > > > > > > > +	case V4L2_CTRL_TYPE_MPEG2_SEQ_EXT:
> > > > > > > > > > +		elem_size =3D sizeof(struct v4l2_mpeg_video_mpeg2_se=
q_ext);
> > > > > > > > > > +		break;
> > > > > > > > > > +	case V4L2_CTRL_TYPE_MPEG2_SEQ_DISPLAY_EXT:
> > > > > > > > > > +		elem_size =3D
> > > > > > > > > > +			sizeof(struct v4l2_mpeg_video_mpeg2_seq_display_ext=
);
> > > > > > > > > > +		break;
> > > > > > > > > > +	case V4L2_CTRL_TYPE_MPEG2_SEQ_MATRIX_EXT:
> > > > > > > > > > +		elem_size =3D
> > > > > > > > > > +			sizeof(struct v4l2_mpeg_video_mpeg2_seq_matrix_ext)=
;
> > > > > > > > > > +		break;
> > > > > > > > > > +	case V4L2_CTRL_TYPE_MPEG2_PIC_HDR:
> > > > > > > > > > +		elem_size =3D sizeof(struct v4l2_mpeg_video_mpeg2_pi=
c_hdr);
> > > > > > > > > > +		break;
> > > > > > > > > > +	case V4L2_CTRL_TYPE_MPEG2_PIC_EXT:
> > > > > > > > > > +		elem_size =3D sizeof(struct v4l2_mpeg_video_mpeg2_pi=
c_ext);
> > > > > > > > > > +		break;
> > > > > > > > > >     	default:
> > > > > > > > > >     		if (type < V4L2_CTRL_COMPOUND_TYPES)
> > > > > > > > > >     			elem_size =3D sizeof(s32);
> > > > > >=20
> > > > > > diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/med=
ia/v4l2-core/v4l2-ioctl.c
> > > > > > index e5a2187..394e636 100644
> > > > > > --- a/drivers/media/v4l2-core/v4l2-ioctl.c
> > > > > > +++ b/drivers/media/v4l2-core/v4l2-ioctl.c
> > > > > > @@ -1250,7 +1250,9 @@ static void v4l_fill_fmtdesc(struct v4l2_=
fmtdesc *fmt)
> > > > > > > > > > > > > >     		case V4L2_PIX_FMT_H264_MVC:	descr =3D "H.=
264 MVC"; break;
> > > > > > > > > > > > > >     		case V4L2_PIX_FMT_H263:		descr =3D "H.263=
"; break;
> > > > > > > > > > > > > >     		case V4L2_PIX_FMT_MPEG1:	descr =3D "MPEG-=
1 ES"; break;
> > > > > > > > > > > > > > +		case V4L2_PIX_FMT_MPEG1_PARSED:	descr =3D "M=
PEG-1 with parsing metadata"; break;
> > > > > > > > > > > > > >     		case V4L2_PIX_FMT_MPEG2:	descr =3D "MPEG-=
2 ES"; break;
> > > > > > > > > > > > > > +		case V4L2_PIX_FMT_MPEG2_PARSED:	descr =3D "M=
PEG-2 with parsing metadata"; break;
> > > > > > > > > > > > > >     		case V4L2_PIX_FMT_MPEG4:	descr =3D "MPEG-=
4 part 2 ES"; break;
> > > > > > > > > > > > > >     		case V4L2_PIX_FMT_XVID:		descr =3D "Xvid"=
; break;
> > > > > > > > > > > > > >     		case V4L2_PIX_FMT_VC1_ANNEX_G:	descr =3D =
"VC-1 (SMPTE 412M Annex G)"; break;
> > > > > >=20
> > > > > > diff --git a/include/uapi/linux/v4l2-controls.h b/include/uapi/=
linux/v4l2-controls.h
> > > > > > index 0d2e1e0..2be9db2 100644
> > > > > > --- a/include/uapi/linux/v4l2-controls.h
> > > > > > +++ b/include/uapi/linux/v4l2-controls.h
> > > > > > @@ -547,6 +547,100 @@ enum v4l2_mpeg_video_mpeg4_profile {
> > > > > >     };
> > > > > > > > > >     #define V4L2_CID_MPEG_VIDEO_MPEG4_QPEL		(V4L2_CID_M=
PEG_BASE+407)
> > > > > >=20
> > > > > >    =20
> > > > > > +/*
> > > > > > + * parsed MPEG-2 controls
> > > > > > + * (needed by stateless video decoders)
> > > > > > + * Those controls have been defined based on MPEG-2 standard I=
SO/IEC 13818-2,
> > > > > > + * and so derive directly from the MPEG-2 video bitstream synt=
ax including
> > > > > > + * how it is coded inside bitstream (enumeration values for ex=
.).
> > > > > > + */
> > > > > > > > > > +#define MPEG2_QUANTISER_MATRIX_SIZE	64
> > > > > > > > > > +#define V4L2_CID_MPEG_VIDEO_MPEG2_SEQ_HDR		(V4L2_CID_M=
PEG_BASE+450)
> > > > > >=20
> > > > > > +struct v4l2_mpeg_video_mpeg2_seq_hdr {
> > > > > > > > > > > > > > +	__u16	width;
> > > > > > > > > > > > > > +	__u16	height;
> > > > > > > > > > > > > > +	__u8	aspect_ratio_info;
> > > > > > > > > > > > > > +	__u8	frame_rate_code;
> > > > > > > > > > > > > > +	__u16	vbv_buffer_size;
> > > > > > > > > > > > > > +	__u32	bitrate_value;
> > > > > > > > > > > > > > +	__u16	constrained_parameters_flag;
> > > > > > > > > > > > > > +	__u8	load_intra_quantiser_matrix;
> > > > > > > > > > > > > > +	__u8	load_non_intra_quantiser_matrix;
> > > > > > > > > > > > > > +	__u8	intra_quantiser_matrix[MPEG2_QUANTISER_M=
ATRIX_SIZE];
> > > > > > > > > > > > > > +	__u8	non_intra_quantiser_matrix[MPEG2_QUANTIS=
ER_MATRIX_SIZE];
> > > > > > > > > > > > > > +	__u32	par_w;
> > > > > > > > > > > > > > +	__u32	par_h;
> > > > > > > > > > > > > > +	__u32	fps_n;
> > > > > > > > > > > > > > +	__u32	fps_d;
> > > > > > > > > > > > > > +	__u32	bitrate;
> > > > > >=20
> > > > > > +};
> > > > > > > > > > +#define V4L2_CID_MPEG_VIDEO_MPEG2_SEQ_EXT		(V4L2_CID_M=
PEG_BASE+451)
> > > > > >=20
> > > > > > +struct v4l2_mpeg_video_mpeg2_seq_ext {
> > > > > > > > > > > > > > +	__u8	profile;
> > > > > > > > > > > > > > +	__u8	level;
> > > > > > > > > > > > > > +	__u8	progressive;
> > > > > > > > > > > > > > +	__u8	chroma_format;
> > > > > > > > > > > > > > +	__u8	horiz_size_ext;
> > > > > > > > > > > > > > +	__u8	vert_size_ext;
> > > > > > > > > > > > > > +	__u16	bitrate_ext;
> > > > > > > > > > > > > > +	__u8	vbv_buffer_size_ext;
> > > > > > > > > > > > > > +	__u8	low_delay;
> > > > > > > > > > > > > > +	__u8	fps_n_ext;
> > > > > > > > > > > > > > +	__u8	fps_d_ext;
> > > > > >=20
> > > > > > +};
> > > > > > > > > > +#define V4L2_CID_MPEG_VIDEO_MPEG2_SEQ_DISPLAY_EXT	(V4L=
2_CID_MPEG_BASE+452)
> > > > > >=20
> > > > > > +struct v4l2_mpeg_video_mpeg2_seq_display_ext {
> > > > > > > > > > > > > > +	__u16	display_horizontal_size;
> > > > > > > > > > > > > > +	__u16	display_vertical_size;
> > > > > > > > > > > > > > +	__u8	video_format;
> > > > > > > > > > > > > > +	__u8	colour_description_flag;
> > > > > > > > > > > > > > +	__u8	colour_primaries;
> > > > > > > > > > > > > > +	__u8	transfer_characteristics;
> > > > > > > > > > > > > > +	__u8	matrix_coefficients;
> > > > > >=20
> > > > > > +};
> > > > > > > > > > +#define V4L2_CID_MPEG_VIDEO_MPEG2_SEQ_MATRIX_EXT	(V4L2=
_CID_MPEG_BASE+453)
> > > > > >=20
> > > > > > +struct v4l2_mpeg_video_mpeg2_seq_matrix_ext {
> > > > > > > > > > > > > > +	__u8	load_intra_quantiser_matrix;
> > > > > > > > > > > > > > +	__u8	intra_quantiser_matrix[MPEG2_QUANTISER_M=
ATRIX_SIZE];
> > > > > > > > > > > > > > +	__u8	load_non_intra_quantiser_matrix;
> > > > > > > > > > > > > > +	__u8	non_intra_quantiser_matrix[MPEG2_QUANTIS=
ER_MATRIX_SIZE];
> > > > > > > > > > > > > > +	__u8	load_chroma_intra_quantiser_matrix;
> > > > > > > > > > > > > > +	__u8	chroma_intra_quantiser_matrix[MPEG2_QUAN=
TISER_MATRIX_SIZE];
> > > > > > > > > > > > > > +	__u8	load_chroma_non_intra_quantiser_matrix;
> > > > > > > > > > > > > > +	__u8	chroma_non_intra_quantiser_matrix[MPEG2_=
QUANTISER_MATRIX_SIZE];
> > > > > >=20
> > > > > > +};
> > > > > > > > > > +#define V4L2_CID_MPEG_VIDEO_MPEG2_PIC_HDR		(V4L2_CID_M=
PEG_BASE+454)
> > > > > >=20
> > > > > > +struct v4l2_mpeg_video_mpeg2_pic_hdr {
> > > > > > > > > > > > > > +	__u32	offset;
> > > > > > > > > > > > > > +	__u16	tsn;
> > > > > > > > > > > > > > +	__u16	vbv_delay;
> > > > > > > > > > > > > > +	__u8	pic_type;
> > > > > > > > > > > > > > +	__u8	full_pel_forward_vector;
> > > > > > > > > > > > > > +	__u8	full_pel_backward_vector;
> > > > > > > > > > > > > > +	__u8	f_code[2][2];
> > > > > >=20
> > > > > > +};
> > > > > > > > > > +#define V4L2_CID_MPEG_VIDEO_MPEG2_PIC_EXT		(V4L2_CID_M=
PEG_BASE+455)
> > > > > >=20
> > > > > > +struct v4l2_mpeg_video_mpeg2_pic_ext {
> > > > > > > > > > > > > > +	__u8	f_code[2][2];
> > > > > > > > > > > > > > +	__u8	intra_dc_precision;
> > > > > > > > > > > > > > +	__u8	picture_structure;
> > > > > > > > > > > > > > +	__u8	top_field_first;
> > > > > > > > > > > > > > +	__u8	frame_pred_frame_dct;
> > > > > > > > > > > > > > +	__u8	concealment_motion_vectors;
> > > > > > > > > > > > > > +	__u8	q_scale_type;
> > > > > > > > > > > > > > +	__u8	intra_vlc_format;
> > > > > > > > > > > > > > +	__u8	alternate_scan;
> > > > > > > > > > > > > > +	__u8	repeat_first_field;
> > > > > > > > > > > > > > +	__u8	chroma_420_type;
> > > > > > > > > > > > > > +	__u8	progressive_frame;
> > > > > > > > > > > > > > +	__u8	composite_display;
> > > > > > > > > > > > > > +	__u8	v_axis;
> > > > > > > > > > > > > > +	__u8	field_sequence;
> > > > > > > > > > > > > > +	__u8	sub_carrier;
> > > > > > > > > > > > > > +	__u8	burst_amplitude;
> > > > > > > > > > > > > > +	__u8	sub_carrier_phase;
> > > > > >=20
> > > > > > +};
> > > > > > +
> > > > > >     /*  Control IDs for VP8 streams
> > > > > >      *  Although VP8 is not part of MPEG we add these controls =
to the MPEG class
> > > > > >      *  as that class is already handling other video compressi=
on standards
> > > > > > diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linu=
x/videodev2.h
> > > > > > index 2b8feb8..abf05f49 100644
> > > > > > --- a/include/uapi/linux/videodev2.h
> > > > > > +++ b/include/uapi/linux/videodev2.h
> > > > > > @@ -622,7 +622,9 @@ struct v4l2_pix_format {
> > > > > >     #define V4L2_PIX_FMT_H264_MVC v4l2_fourcc('M', '2', '6', '4=
') /* H264 MVC */
> > > > > >     #define V4L2_PIX_FMT_H263     v4l2_fourcc('H', '2', '6', '3=
') /* H263          */
> > > > > >     #define V4L2_PIX_FMT_MPEG1    v4l2_fourcc('M', 'P', 'G', '1=
') /* MPEG-1 ES     */
> > > > > > +#define V4L2_PIX_FMT_MPEG1_PARSED v4l2_fourcc('M', 'G', '1', '=
P') /* MPEG1 with parsing metadata given through controls */
> > > > > >     #define V4L2_PIX_FMT_MPEG2    v4l2_fourcc('M', 'P', 'G', '2=
') /* MPEG-2 ES     */
> > > > > > +#define V4L2_PIX_FMT_MPEG2_PARSED v4l2_fourcc('M', 'G', '2', '=
P') /* MPEG2 with parsing metadata given through controls */
> > > > > >     #define V4L2_PIX_FMT_MPEG4    v4l2_fourcc('M', 'P', 'G', '4=
') /* MPEG-4 part 2 ES */
> > > > > >     #define V4L2_PIX_FMT_XVID     v4l2_fourcc('X', 'V', 'I', 'D=
') /* Xvid           */
> > > > > >     #define V4L2_PIX_FMT_VC1_ANNEX_G v4l2_fourcc('V', 'C', '1',=
 'G') /* SMPTE 421M Annex G compliant stream */
> > > > > > @@ -1605,6 +1607,12 @@ enum v4l2_ctrl_type {
> > > > > > > > > > > > > >     	V4L2_CTRL_TYPE_U8	     =3D 0x0100,
> > > > > > > > > > > > > >     	V4L2_CTRL_TYPE_U16	     =3D 0x0101,
> > > > > > > > > > > > > >     	V4L2_CTRL_TYPE_U32	     =3D 0x0102,
> > > > > > > > > >=20
> > > > > > > > > > +	V4L2_CTRL_TYPE_MPEG2_SEQ_HDR  =3D 0x0109,
> > > > > > > > > > +	V4L2_CTRL_TYPE_MPEG2_SEQ_EXT  =3D 0x010A,
> > > > > > > > > > +	V4L2_CTRL_TYPE_MPEG2_SEQ_DISPLAY_EXT  =3D 0x010B,
> > > > > > > > > > +	V4L2_CTRL_TYPE_MPEG2_SEQ_MATRIX_EXT  =3D 0x010C,
> > > > > > > > > > +	V4L2_CTRL_TYPE_MPEG2_PIC_HDR  =3D 0x010D,
> > > > > > > > > > +	V4L2_CTRL_TYPE_MPEG2_PIC_EXT  =3D 0x010E,
> > > > > >=20
> > > > > >     };
> > > > > >    =20
> > > > > >     /*  Used in the VIDIOC_QUERYCTRL ioctl for querying control=
s */
>=20
>=20
--=-CxIz3PeNrEzyfz+BK1Fd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQSScpfJiL+hb5vvd45xUwItrAaoHAUCWWF5owAKCRBxUwItrAao
HCKQAKDHeSuMPKyMDV7WeWWVU2+HCuSaegCgxwgLMN9npURzlEqVeuWEhSDiJr8=
=bZtI
-----END PGP SIGNATURE-----

--=-CxIz3PeNrEzyfz+BK1Fd--
