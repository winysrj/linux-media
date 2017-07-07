Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-io0-f175.google.com ([209.85.223.175]:35051 "EHLO
        mail-io0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751089AbdGGSeB (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 7 Jul 2017 14:34:01 -0400
Received: by mail-io0-f175.google.com with SMTP id h134so350575iof.2
        for <linux-media@vger.kernel.org>; Fri, 07 Jul 2017 11:34:00 -0700 (PDT)
Message-ID: <1499452436.31895.5.camel@ndufresne.ca>
Subject: Re: [PATCH v6 1/3] [media] v4l: add parsed MPEG-2 support
From: Nicolas Dufresne <nicolas@ndufresne.ca>
To: ayaka <ayaka@soulik.info>, Hugues FRUCHET <hugues.fruchet@st.com>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Jean Christophe TROTIN <jean-christophe.trotin@st.com>
Date: Fri, 07 Jul 2017 14:33:56 -0400
In-Reply-To: <44ac1d87-a86d-1d6c-f162-e859533c9566@soulik.info>
References: <1493385949-2962-1-git-send-email-hugues.fruchet@st.com>
         <1493385949-2962-2-git-send-email-hugues.fruchet@st.com>
         <a04de6cc-6775-9564-44c2-664c6f234f12@soulik.info>
         <ff94471e-5f38-f0a6-5ff6-271acef2eea7@st.com>
         <44ac1d87-a86d-1d6c-f162-e859533c9566@soulik.info>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
        boundary="=-LFiYlyFxKBF4FxO00ce1"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-LFiYlyFxKBF4FxO00ce1
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Le samedi 08 juillet 2017 =C3=A0 01:29 +0800, ayaka a =C3=A9crit=C2=A0:
>=20
> On 07/04/2017 05:29 PM, Hugues FRUCHET wrote:
> > Hi Randy,
> > Thanks for review, and sorry for late reply, answers inline.
> > BR,
> > Hugues.
> >=20
> > On 06/11/2017 01:41 PM, ayaka wrote:
> > >=20
> > > On 04/28/2017 09:25 PM, Hugues Fruchet wrote:
> > > > Add "parsed MPEG-2" pixel format & related controls
> > > > needed by stateless video decoders.
> > > > In order to decode the video bitstream chunk provided
> > > > by user on output queue, stateless decoders require
> > > > also some extra data resulting from this video bitstream
> > > > chunk parsing.
> > > > Those parsed extra data have to be set by user through
> > > > control framework using the dedicated mpeg video extended
> > > > controls introduced in this patchset.
> > >=20
> > > I have compared those v4l2 controls with the registers of the rockchi=
p
> > > video IP.
> > >=20
> > > Most of them are met, but only lacks of sw_init_qp.
> >=20
> > In case of MPEG-1/2, this register seems forced to 1, please double
> > check the on2 headers parsing library related to MPEG2. Nevertheless, I
> > see this hardware register used with VP8/H264.
>=20
> Yes, it is forced to be 1. We can skip this field for MPEG1/2
> >=20
> > Hence, no need to put this field on MPEG-2 interface, but should come
> > with VP8/H264.
> >=20
> > >=20
> > > Here is the full translation table of the registers of the rockchip
> > > video IP.
> > >=20
> > > q_scale_type
> > > sw_qscale_type
> > > concealment_motion_vectors=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0sw_con_mv_e
> > > intra_dc_precision=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0sw_intra_dc_prec
> > > intra_vlc_format
> > > sw_intra_vlc_tab
> > > frame_pred_frame_dct=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0sw_frame_pred_dct
> > >=20
> > > alternate_scan
> > > sw_alt_scan_flag_e
> > >=20
> > > f_code
> > > sw_fcode_bwd_ver
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0
> > > sw_fcode_bwd_hor
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0
> > > sw_fcode_fwd_ver
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0
> > > sw_fcode_fwd_hor
> > > full_pel_forward_vector=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0sw_mv_accuracy_fwd
> > > full_pel_backward_vector=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0sw_mv_acc=
uracy_bwd
> > >=20
> > >=20
> > > I also saw you add two format for parsed MPEG-2/MPEG-1 format, I woul=
d
> > > not recommand to do that.
> >=20
> > We need to differentiate MPEG-1/MPEG-2, not all the fields are
> > applicable depending on version.
>=20
> Usually the MPEG-2 decoder could support MPEG-1, as I know, the syntax=C2=
=A0
> of byte stream of them are the same.
> > > That is what google does, because for a few video format and some
> > > hardware, they just request a offsets from the original video byte st=
ream.
> >=20
> > I don't understand your comment, perhaps have you some as a basis of
> > discussion ?
>=20
> I mean
>=20
> V4L2-PIX-FMT-MPEG2-PARSED V4L2-PIX-FMT-MPEG1-PARSED I wonder whether you=
=C2=A0
> want use the new format to inform the userspace that this device is for=
=C2=A0
> stateless video decoder, as google defined something like=C2=A0
> V4L2_PIX_FMT_H264_SLICE. I think the driver registers some controls is=C2=
=A0
> enough for the userspace to detect whether it is a stateless device. Or=
=C2=A0
> it will increase the work of the userspace(I mean Gstreamer).

Just a note that SLICE has nothing to do with PARSED here. You could
have an H264 decoder that is stateless and support handling slices
rather then full frames (e.g. V4L2_PIX_FMT_H264_SLICE_PARSED could be
valid).

I would not worry to much about Gst, as we will likely use this device
through the libv4l2 here, hence will only notice the "emulated"
V4L2_PIX_FMT_MPEG2 and ignore the _PARSED variant. And without libv4l2,
we'd just ignore this driver completely. I doubt we will implement per-
device parsing inside Gst itself if it's already done in an external
library for us. libv4l2 might need some fixing, but hopefully it's not
beyond repair.

>=20
> > Offset from the beginning of original video bitstream is supported
> > within proposed interface, see v4l2_mpeg_video_mpeg2_pic_hd->offset fie=
ld.
> >=20
> > > > > > > > Signed-off-by: Hugues Fruchet<hugues.fruchet@st.com>
> > > > ---
> > > > =C2=A0=C2=A0=C2=A0Documentation/media/uapi/v4l/extended-controls.rs=
t | 363 +++++++++++++++++++++
> > > > =C2=A0=C2=A0=C2=A0Documentation/media/uapi/v4l/pixfmt-013.rst=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0|=C2=A0=C2=A010 +
> > > > =C2=A0=C2=A0=C2=A0Documentation/media/uapi/v4l/vidioc-queryctrl.rst=
=C2=A0=C2=A0|=C2=A0=C2=A038 ++-
> > > > =C2=A0=C2=A0=C2=A0Documentation/media/videodev2.h.rst.exceptions=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0|=C2=A0=C2=A0=C2=A06 +
> > > > =C2=A0=C2=A0=C2=A0drivers/media/v4l2-core/v4l2-ctrls.c=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0|=C2=A0=C2=A053 +++
> > > > =C2=A0=C2=A0=C2=A0drivers/media/v4l2-core/v4l2-ioctl.c=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0|=C2=A0=C2=A0=C2=A02 +
> > > > =C2=A0=C2=A0=C2=A0include/uapi/linux/v4l2-controls.h=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0|=C2=A0=C2=A094 ++++++
> > > > =C2=A0=C2=A0=C2=A0include/uapi/linux/videodev2.h=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0|=C2=A0=C2=A0=C2=A08 +
> > > > =C2=A0=C2=A0=C2=A08 files changed, 572 insertions(+), 2 deletions(-=
)
> > > >=20
> > > > diff --git a/Documentation/media/uapi/v4l/extended-controls.rst b/D=
ocumentation/media/uapi/v4l/extended-controls.rst
> > > > index abb1057..b48eac9 100644
> > > > --- a/Documentation/media/uapi/v4l/extended-controls.rst
> > > > +++ b/Documentation/media/uapi/v4l/extended-controls.rst
> > > > @@ -1827,6 +1827,369 @@ enum v4l2_mpeg_cx2341x_video_median_filter_=
type -
> > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0not insert, 1 =3D insert =
packets.
> > > > =C2=A0=C2=A0=C2=A0
> > > > =C2=A0=C2=A0=C2=A0
> > > > +MPEG-2 Parsed Control Reference
> > > > +---------------------------------
> > > > +
> > > > +The MPEG-2 parsed decoding controls are needed by stateless video =
decoders.
> > > > +Those decoders expose :ref:`Compressed formats <compressed-formats=
>` :ref:`V4L2_PIX_FMT_MPEG1_PARSED<V4L2-PIX-FMT-MPEG1-PARSED>` or :ref:`V4L=
2_PIX_FMT_MPEG2_PARSED<V4L2-PIX-FMT-MPEG2-PARSED>`.
> > > > +In order to decode the video bitstream chunk provided by user on o=
utput queue,
> > > > +stateless decoders require also some extra data resulting from thi=
s video
> > > > +bitstream chunk parsing. Those parsed extra data have to be set by=
 user
> > > > +through control framework using the mpeg video extended controls d=
efined
> > > > +in this section. Those controls have been defined based on MPEG-2 =
standard
> > > > +ISO/IEC 13818-2, and so derive directly from the MPEG-2 video bits=
tream syntax
> > > > +including how it is coded inside bitstream (enumeration values for=
 ex.).
> > > > +
> > > > +MPEG-2 Parsed Control IDs
> > > > +^^^^^^^^^^^^^^^^^^^^^^^^^^^
> > > > +
> > > > +.. _mpeg2-parsed-control-id:
> > > > +
> > > > +.. c:type:: V4L2_CID_MPEG_VIDEO_MPEG2_SEQ_HDR
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0(enum)
> > > > +
> > > > +.. tabularcolumns:: |p{4.0cm}|p{2.5cm}|p{11.0cm}|
> > > > +
> > > > +.. c:type:: v4l2_mpeg_video_mpeg2_seq_hdr
> > > > +
> > > > +.. cssclass:: longtable
> > > > +
> > > > +.. flat-table:: struct v4l2_mpeg_video_mpeg2_seq_hdr
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0:header-rows:=C2=A0=C2=A00
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0:stub-columns: 0
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0:widths:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A01 1 2
> > > > +
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0* - __u16
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- ``width``
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- Video width in pixels.
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0* - __u16
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- ``height``
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- Video height in pixels.
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0* - __u8
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- ``aspect_ratio_info``
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- Aspect ratio code as in the =
bitstream (1: 1:1 square pixels,
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A02: 4:3 display, 3:=
 16:9 display, 4: 2.21:1 display)
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0* - __u8
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- ``framerate code``
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- Framerate code as in the bit=
stream
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0(1: 24000/1001.0 '=
23.976 fps, 2: 24.0, 3: 25.0,
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A04: 30000/1001.0 '2=
9.97, 5: 30.0, 6: 50.0, 7: 60000/1001.0,
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A08: 60.0)
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0* - __u16
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- ``vbv_buffer_size``
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0-=C2=A0=C2=A0Video Buffering V=
erifier size, expressed in 16KBytes unit.
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0* - __u32
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- ``bitrate_value``
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- Bitrate value as in the bits=
tream, expressed in 400bps unit
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0* - __u16
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- ``constrained_parameters_fla=
g``
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- Set to 1 if this bitstream u=
ses constrained parameters.
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0* - __u8
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- ``load_intra_quantiser_matri=
x``
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- If set to 1, ``intra_quantis=
er_matrix`` table is to be used for
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0decoding.
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0* - __u8
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- ``load_non_intra_quantiser_m=
atrix``
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- If set to 1, ``non_intra_qua=
ntiser_matrix`` table is to be used for
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0decoding.
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0* - __u8
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- ``intra_quantiser_matrix[64]=
``
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- Intra quantization table, in=
 zig-zag scan order.
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0* - __u8
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- ``non_intra_quantiser_matrix=
[64]``
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- Non-intra quantization table=
, in zig-zag scan order.
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0* - __u32
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- ``par_w``
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- Pixel aspect ratio width in =
pixels.
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0* - __u32
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- ``par_h``
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- Pixel aspect ratio height in=
 pixels.
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0* - __u32
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- ``fps_n``
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- Framerate nominator.
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0* - __u32
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- ``fps_d``
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- Framerate denominator.
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0* - __u32
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- ``bitrate``
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- Bitrate in bps if constant b=
itrate, 0 otherwise.
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0* - :cspan:`2`
> > > > +
> > > > +
> > > > +.. c:type:: V4L2_CID_MPEG_VIDEO_MPEG2_SEQ_EXT
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0(enum)
> > > > +
> > > > +.. tabularcolumns:: |p{4.0cm}|p{2.5cm}|p{11.0cm}|
> > > > +
> > > > +.. c:type:: v4l2_mpeg_video_mpeg2_seq_ext
> > > > +
> > > > +.. cssclass:: longtable
> > > > +
> > > > +.. flat-table:: struct v4l2_mpeg_video_mpeg2_seq_ext
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0:header-rows:=C2=A0=C2=A00
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0:stub-columns: 0
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0:widths:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A01 1 2
> > > > +
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0* - __u8
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- ``profile``
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- Encoding profile used to enc=
ode this bitstream.
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0(1: High Profile, =
2: Spatially Scalable Profile,
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A03: SNR Scalable Pr=
ofile, 4: Main Profile, 5: Simple Profile).
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0* - __u8
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- ``level``
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- Encoding level used to encod=
e this bitstream
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0(4: High Level, 6:=
 High 1440 Level, 8: Main Level, 10: Low Level).
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0* - __u8
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- ``progressive``
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- Set to 1 if frames are progr=
essive (vs interlaced).
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0* - __u8
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- ``chroma_format``
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- Chrominance format (1: 420, =
2: 422, 3: 444).
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0* - __u8
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- ``horiz_size_ext``
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- Horizontal size extension. T=
his value is to be shifted 12 bits left
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0and added to ''seq=
_hdr->width'' to get the final video width:
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0`width =3D seq_hdr=
->width + seq_ext->horiz_size_ext << 12`
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0* - __u8
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- ``vert_size_ext``
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- Vertical size extension. Thi=
s value is to be shifted 12 bits left
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0and added to ''seq=
_hdr->height'' to get the final video height:
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0`height =3D seq_hd=
r->height + seq_ext->vert_size_ext << 12`
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0* - __u16
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- ``bitrate_ext``
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0-=C2=A0=C2=A0Bitrate extension=
. This value, expressed in 400bps unit, is to be
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0shifted 18 b=
its left and added to ''seq_hdr->bitrate'' to get the
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0final bitrat=
e:
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0`bitrate =3D=
 seq_hdr->bitrate + (seq_ext->bitrate_ext << 18) * 400`
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0* - __u8
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- ``vbv_buffer_size_ext``
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0-=C2=A0=C2=A0Video Buffering V=
erifier size extension in bits.
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0* - __u8
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- ``low_delay``
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0-=C2=A0=C2=A0Low delay. Set to=
 1 if no B pictures are present.
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0* - __u8
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- ``fps_n_ext``
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0-=C2=A0=C2=A0Framerate extensi=
on nominator. This value is to be incremented and
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0multiplied b=
y ''seq_hdr->fps_n'' to get the final framerate
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0nominator:
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0`fps_n =3D s=
eq_hdr->fps_n * (seq_ext->fps_n_ext + 1)`
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0* - __u8
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- ``fps_d_ext``
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0-=C2=A0=C2=A0Framerate extensi=
on denominator. This value is to be incremented and
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0multiplied b=
y ''seq_hdr->fps_d'' to get the final framerate
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0denominator:
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0`fps_d =3D s=
eq_hdr->fps_d * (seq_ext->fps_d_ext + 1)`
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0* - :cspan:`2`
> > > > +
> > > > +
> > > > +.. c:type:: V4L2_CID_MPEG_VIDEO_MPEG2_SEQ_DISPLAY_EXT
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0(enum)
> > > > +
> > > > +.. tabularcolumns:: |p{4.0cm}|p{2.5cm}|p{11.0cm}|
> > > > +
> > > > +.. c:type:: v4l2_mpeg_video_mpeg2_seq_display_ext
> > > > +
> > > > +.. cssclass:: longtable
> > > > +
> > > > +.. flat-table:: struct v4l2_mpeg_video_mpeg2_seq_display_ext
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0:header-rows:=C2=A0=C2=A00
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0:stub-columns: 0
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0:widths:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A01 1 2
> > > > +
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0* - __u16
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- ``display_horizontal_size``,=
 ``display_vertical_size``
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- Dimensions of the video to b=
e displayed. If those dimensions
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0are smaller than t=
he final video dimensions, only this area
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0must be displayed.
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0* - __u8
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- ``video_format``
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- Video standard (0: Component=
s, 1: PAL, 2: NTSC, 3: SECAM, 4:MAC)
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0* - __u8
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- ``colour_description_flag``
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- If set to 1, ''colour_primar=
ies'', ''transfer_characteristics'',
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0''matrix_coefficie=
nts'' are to be used for decoding.
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0* - __u8
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- ``colour_primaries``
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- Colour coding standard (1: I=
TU-R Rec. 709 (1990),
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A04: ITU-R Rec. 624-=
4 System M, 5: ITU-R Rec. 624-4 System B, G,
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A06: SMPTE 170M, 7: =
SMPTE 240M (1987))
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0* - __u8
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- ``transfer_characteristics``
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- Transfer characteristics cod=
ing standard (1: ITU-R Rec. 709 (1990),
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A04: ITU-R Rec. 624-=
4 System M, 5: ITU-R Rec. 624-4 System B, G,
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A06: SMPTE 170M, 7: =
SMPTE 240M (1987))
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0* - __u8
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- ``matrix_coefficients``
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- Matrix coefficients coding s=
tandard (1: ITU-R Rec. 709 (1990),
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A04: FCC, 5: ITU-R R=
ec. 624-4 System B, G, 6: SMPTE 170M,
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A07: SMPTE 240M (198=
7))
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0* - :cspan:`2`
> > > > +
> > > > +
> > > > +.. c:type:: V4L2_CID_MPEG_VIDEO_MPEG2_SEQ_MATRIX_EXT
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0(enum)
> > > > +
> > > > +.. tabularcolumns:: |p{4.0cm}|p{2.5cm}|p{11.0cm}|
> > > > +
> > > > +.. c:type:: v4l2_mpeg_video_mpeg2_seq_matrix_ext
> > > > +
> > > > +.. cssclass:: longtable
> > > > +
> > > > +.. flat-table:: struct v4l2_mpeg_video_mpeg2_seq_matrix_ext
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0:header-rows:=C2=A0=C2=A00
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0:stub-columns: 0
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0:widths:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A01 1 2
> > > > +
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0* - __u8
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- ``load_intra_quantiser_matri=
x``
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- If set to 1, ``intra_quantis=
er_matrix`` table is to be used for
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0decoding.
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0* - __u8
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- ``intra_quantiser_matrix[64]=
``
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- Intra quantization table, in=
 zig-zag scan order.
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0* - __u8
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- ``load_non_intra_quantiser_m=
atrix``
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- If set to 1, ``non_intra_qua=
ntiser_matrix`` table is to be used for
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0decoding.
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0* - __u8
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- ``non_intra_quantiser_matrix=
[64]``
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- Non-intra quantization table=
, in zig-zag scan order.
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0* - __u8
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- ``load_chroma_intra_quantise=
r_matrix``
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- If set to 1, ``chroma_intra_=
quantiser_matrix`` table is to be used for
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0decoding.
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0* - __u8
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- ``chroma_intra_quantiser_mat=
rix[64]``
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- Chroma intra quantization ta=
ble, in zig-zag scan order.
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0* - __u8
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- ``load_chroma_non_intra_quan=
tiser_matrix``
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- If set to 1, ``chroma_non_in=
tra_quantiser_matrix`` table is to be used for
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0decoding.
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0* - __u8
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- ``chroma_non_intra_quantiser=
_matrix[64]``
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- Chroma non-intra quantizatio=
n table, in zig-zag scan order.
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0* - :cspan:`2`
> > > > +
> > > > +
> > > > +.. c:type:: V4L2_CID_MPEG_VIDEO_MPEG2_PIC_HDR
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0(enum)
> > > > +
> > > > +.. tabularcolumns:: |p{4.0cm}|p{2.5cm}|p{11.0cm}|
> > > > +
> > > > +.. c:type:: v4l2_mpeg_video_mpeg2_pic_hdr
> > > > +
> > > > +.. cssclass:: longtable
> > > > +
> > > > +.. flat-table:: struct v4l2_mpeg_video_mpeg2_pic_hdr
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0:header-rows:=C2=A0=C2=A00
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0:stub-columns: 0
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0:widths:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A01 1 2
> > > > +
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0* - __u32
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- ``offset``
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- Offset in bytes of the slice=
 data from the beginning of packet.
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0* - __u16
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- ``tsn``
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- Temporal Sequence Number: or=
der in which the frames must be displayed.
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0* - __u16
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- ``vbv_delay``
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- Video Buffering Verifier del=
ay, in 90KHz cycles unit.
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0* - __u8
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- ``pic_type``
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- Picture coding type (1: Intr=
a, 2: Predictive,
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A03: B, Bidirectiona=
lly Predictive, 4: D, DC Intra).
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0* - __u8
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- ``full_pel_forward_vector``
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- If set to 1, forward vectors=
 are expressed in full pixel unit instead
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0half pixel unit.
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0* - __u8
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- ``full_pel_backward_vector``
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- If set to 1, backward vector=
s are expressed in full pixel unit instead
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0half pixel unit.
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0* - __u8
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- ``f_code[2][2]``
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- Motion vectors code.
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0* - :cspan:`2`
> > > > +
> > > > +
> > > > +.. c:type:: V4L2_CID_MPEG_VIDEO_MPEG2_PIC_EXT
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0(enum)
> > > > +
> > > > +.. tabularcolumns:: |p{4.0cm}|p{2.5cm}|p{11.0cm}|
> > > > +
> > > > +.. c:type:: v4l2_mpeg_video_mpeg2_pic_ext
> > > > +
> > > > +.. cssclass:: longtable
> > > > +
> > > > +.. flat-table:: struct v4l2_mpeg_video_mpeg2_pic_ext
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0:header-rows:=C2=A0=C2=A00
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0:stub-columns: 0
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0:widths:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A01 1 2
> > > > +
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0* - __u8
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- ``f_code[2][2]``
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- Motion vectors code.
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0* - __u8
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- ``intra_dc_precision``
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- Precision of Discrete Cosine=
 transform (0: 8 bits precision,
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A01: 9 bits precisio=
n, 2: 10 bits precision, 11: 11 bits precision).
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0* - __u8
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- ``picture_structure``
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- Picture structure (1: interl=
aced top field,
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A02: interlaced bott=
om field, 3: progressive frame).
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0* - __u8
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- ``top_field_first``
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- If set to 1 and interlaced s=
tream, top field is output first.
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0* - __u8
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- ``frame_pred_frame_dct``
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- If set to 1, only frame-DCT =
and frame prediction are used.
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0* - __u8
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- ``concealment_motion_vectors=
``
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0-=C2=A0=C2=A0If set to 1, moti=
on vectors are coded for intra macroblocks.
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0* - __u8
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- ``q_scale_type``
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- This flag affects the invers=
e quantisation process.
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0* - __u8
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- ``intra_vlc_format``
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- This flag affects the decodi=
ng of transform coefficient data.
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0* - __u8
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- ``alternate_scan``
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- This flag affects the decodi=
ng of transform coefficient data.
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0* - __u8
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- ``repeat_first_field``
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- This flag affects how the fr=
ames or fields are output by decoder.
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0* - __u8
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- ``chroma_420_type``
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- Set the same as ``progressiv=
e_frame``. Exists for historical reasons.
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0* - __u8
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- ``progressive_frame``
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- If this flag is set to 0, th=
e two fields of a frame are two interlaced fields,
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0``repeat_first_fie=
ld`` must be 0 (two field duration). If the flag is set to 1,
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0the two fields are=
 merged into one frame, ``picture_structure`` is so set to "Frame"
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0and ``frame_pred_f=
rame_dct`` to 1.
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0* - __u8
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- ``composite_display``
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- This flag is set to 1 if pic=
tures are encoded as (analog) composite video.
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0* - __u8
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- ``v_axis``
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- Used only when pictures are =
encoded according to PAL systems. This flag is set to 1
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0on a positive sign=
, 0 otherwise.
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0* - __u8
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- ``field_sequence``
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- Specifies the number of the =
field of an eight Field Sequence for a PAL system or
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0a five Field Seque=
nce for a NTSC system
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0* - __u8
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- ``sub_carrier``
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- If the flag is set to 0, the=
 sub-carrier/line-frequency relationship is correct.
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0* - __u8
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- ``burst_amplitude``
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- Specifies the burst amplitud=
e for PAL and NTSC.
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0* - __u8
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- ``sub_carrier_phase``
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- Specifies the phase of the r=
eference sub-carrier for the field synchronization.
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0* - :cspan:`2`
> > > > +
> > > > +
> > > > =C2=A0=C2=A0=C2=A0VPX Control Reference
> > > > =C2=A0=C2=A0=C2=A0---------------------
> > > > =C2=A0=C2=A0=C2=A0
> > > > diff --git a/Documentation/media/uapi/v4l/pixfmt-013.rst b/Document=
ation/media/uapi/v4l/pixfmt-013.rst
> > > > index 728d7ed..32c9ef7 100644
> > > > --- a/Documentation/media/uapi/v4l/pixfmt-013.rst
> > > > +++ b/Documentation/media/uapi/v4l/pixfmt-013.rst
> > > > @@ -55,11 +55,21 @@ Compressed Formats
> > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- ``V4L2_PIX_=
FMT_MPEG1``
> > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- 'MPG1'
> > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- MPEG1 video=
 elementary stream.
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0* .. _V4L2-PIX-FMT-MPEG1-PARSED:
> > > > +
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- ``V4L2_PIX_FMT_MPEG1_PARSED`=
`
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- 'MG1P'
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- MPEG-1 with parsing metadata=
 given through controls, see :ref:`MPEG-2 Parsed Control IDs<mpeg2-parsed-c=
ontrol-id>`.
> > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0* .. _V4L2-PIX-FMT-MPEG2:
> > > > =C2=A0=C2=A0=C2=A0
> > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- ``V4L2_PIX_=
FMT_MPEG2``
> > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- 'MPG2'
> > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- MPEG2 video=
 elementary stream.
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0* .. _V4L2-PIX-FMT-MPEG2-PARSED:
> > > > +
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- ``V4L2_PIX_FMT_MPEG2_PARSED`=
`
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- 'MG2P'
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- MPEG-2 with parsing metadata=
 given through controls, see :ref:`MPEG-2 Parsed Control IDs<mpeg2-parsed-c=
ontrol-id>`.
> > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0* .. _V4L2-PIX-FMT-MPEG4:
> > > > =C2=A0=C2=A0=C2=A0
> > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- ``V4L2_PIX_=
FMT_MPEG4``
> > > > diff --git a/Documentation/media/uapi/v4l/vidioc-queryctrl.rst b/Do=
cumentation/media/uapi/v4l/vidioc-queryctrl.rst
> > > > index 41c5744..467f498 100644
> > > > --- a/Documentation/media/uapi/v4l/vidioc-queryctrl.rst
> > > > +++ b/Documentation/media/uapi/v4l/vidioc-queryctrl.rst
> > > > @@ -422,8 +422,42 @@ See also the examples in :ref:`control`.
> > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- any
> > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- An unsigned=
 32-bit valued control ranging from minimum to maximum
> > > > > > > > =C2=A0=C2=A0=C2=A0	inclusive. The step value indicates the =
increment between values.
> > > > -
> > > > -
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0* - ``V4L2_CTRL_TYPE_MPEG2_SEQ_HDR``
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- n/a
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- n/a
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- n/a
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- Type of control
> > > > > > > > +	:c:type:`V4L2_CID_MPEG_VIDEO_MPEG2_SEQ_HDR`.
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0* - ``V4L2_CTRL_TYPE_MPEG2_SEQ_EXT``
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- n/a
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- n/a
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- n/a
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- Type of control
> > > > > > > > +	:c:type:`V4L2_CID_MPEG_VIDEO_MPEG2_SEQ_EXT`.
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0* - ``V4L2_CTRL_TYPE_MPEG2_SEQ_DISPLAY_EXT=
``
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- n/a
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- n/a
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- n/a
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- Type of control
> > > > > > > > +	:c:type:`V4L2_CID_MPEG_VIDEO_MPEG2_SEQ_DISPLAY_EXT`.
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0* - ``V4L2_CTRL_TYPE_MPEG2_SEQ_MATRIX_EXT`=
`
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- n/a
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- n/a
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- n/a
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- Type of control
> > > > > > > > +	:c:type:`V4L2_CID_MPEG_VIDEO_MPEG2_SEQ_MATRIX_EXT`.
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0* - ``V4L2_CTRL_TYPE_MPEG2_PIC_HDR``
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- n/a
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- n/a
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- n/a
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- Type of control
> > > > > > > > +	:c:type:`V4L2_CID_MPEG_VIDEO_MPEG2_PIC_HDR`.
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0* - ``V4L2_CTRL_TYPE_MPEG2_PIC_EXT``
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- n/a
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- n/a
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- n/a
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- Type of control
> > > > > > > > +	:c:type:`V4L2_CID_MPEG_VIDEO_MPEG2_PIC_EXT`.
> > > > =C2=A0=C2=A0=C2=A0
> > > > =C2=A0=C2=A0=C2=A0.. tabularcolumns:: |p{6.6cm}|p{2.2cm}|p{8.7cm}|
> > > > =C2=A0=C2=A0=C2=A0
> > > > diff --git a/Documentation/media/videodev2.h.rst.exceptions b/Docum=
entation/media/videodev2.h.rst.exceptions
> > > > index a5cb0a8..b2e2844 100644
> > > > --- a/Documentation/media/videodev2.h.rst.exceptions
> > > > +++ b/Documentation/media/videodev2.h.rst.exceptions
> > > > @@ -129,6 +129,12 @@ replace symbol V4L2_CTRL_TYPE_STRING :c:type:`=
v4l2_ctrl_type`
> > > > =C2=A0=C2=A0=C2=A0replace symbol V4L2_CTRL_TYPE_U16 :c:type:`v4l2_c=
trl_type`
> > > > =C2=A0=C2=A0=C2=A0replace symbol V4L2_CTRL_TYPE_U32 :c:type:`v4l2_c=
trl_type`
> > > > =C2=A0=C2=A0=C2=A0replace symbol V4L2_CTRL_TYPE_U8 :c:type:`v4l2_ct=
rl_type`
> > > > +replace symbol V4L2_CTRL_TYPE_MPEG2_SEQ_HDR :c:type:`v4l2-ctrl-typ=
e-mpeg2-seq-hdr`
> > > > +replace symbol V4L2_CTRL_TYPE_MPEG2_SEQ_EXT :c:type:`v4l2-ctrl-typ=
e-mpeg2-seq-ext`
> > > > +replace symbol V4L2_CTRL_TYPE_MPEG2_SEQ_DISPLAY_EXT :c:type:`v4l2-=
ctrl-type-mpeg2-seq-display-ext`
> > > > +replace symbol V4L2_CTRL_TYPE_MPEG2_SEQ_MATRIX_EXT :c:type:`v4l2-c=
trl-type-mpeg2-seq-matrix-ext`
> > > > +replace symbol V4L2_CTRL_TYPE_MPEG2_PIC_HDR :c:type:`v4l2-ctrl-typ=
e-mpeg2-pic-hdr`
> > > > +replace symbol V4L2_CTRL_TYPE_MPEG2_PIC_EXT :c:type:`v4l2-ctrl-typ=
e-mpeg2-pic-ext`
> > > > =C2=A0=C2=A0=C2=A0
> > > > =C2=A0=C2=A0=C2=A0# V4L2 capability defines
> > > > =C2=A0=C2=A0=C2=A0replace define V4L2_CAP_VIDEO_CAPTURE device-capa=
bilities
> > > > diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v=
4l2-core/v4l2-ctrls.c
> > > > index ec42872..163b122 100644
> > > > --- a/drivers/media/v4l2-core/v4l2-ctrls.c
> > > > +++ b/drivers/media/v4l2-core/v4l2-ctrls.c
> > > > @@ -760,6 +760,13 @@ const char *v4l2_ctrl_get_name(u32 id)
> > > > > > > > > > > > =C2=A0=C2=A0=C2=A0	case V4L2_CID_MPEG_VIDEO_MV_V_SE=
ARCH_RANGE:		return "Vertical MV Search Range";
> > > > > > > > > > > > =C2=A0=C2=A0=C2=A0	case V4L2_CID_MPEG_VIDEO_REPEAT_=
SEQ_HEADER:		return "Repeat Sequence Header";
> > > > > > > > > > > > =C2=A0=C2=A0=C2=A0	case V4L2_CID_MPEG_VIDEO_FORCE_K=
EY_FRAME:		return "Force Key Frame";
> > > > > > > > +	/* parsed MPEG-2 controls */
> > > > > > > > > > > > +	case V4L2_CID_MPEG_VIDEO_MPEG2_SEQ_HDR:			return =
"MPEG-2 Sequence Header";
> > > > > > > > > > > > +	case V4L2_CID_MPEG_VIDEO_MPEG2_SEQ_EXT:			return =
"MPEG-2 Sequence Extension";
> > > > > > > > > > > > +	case V4L2_CID_MPEG_VIDEO_MPEG2_SEQ_DISPLAY_EXT:		=
return "MPEG-2 Sequence Display Extension";
> > > > > > > > > > > > +	case V4L2_CID_MPEG_VIDEO_MPEG2_SEQ_MATRIX_EXT:		r=
eturn "MPEG-2 Sequence Quantization Matrix";
> > > > > > > > > > > > +	case V4L2_CID_MPEG_VIDEO_MPEG2_PIC_HDR:			return =
"MPEG-2 Picture Header";
> > > > > > > > > > > > +	case V4L2_CID_MPEG_VIDEO_MPEG2_PIC_EXT:			return =
"MPEG-2 Picture Extension";
> > > > =C2=A0=C2=A0=C2=A0
> > > > > > > > =C2=A0=C2=A0=C2=A0	/* VPX controls */
> > > > > > > > > > > > =C2=A0=C2=A0=C2=A0	case V4L2_CID_MPEG_VIDEO_VPX_NUM=
_PARTITIONS:		return "VPX Number of Partitions";
> > > > @@ -1150,6 +1157,24 @@ void v4l2_ctrl_fill(u32 id, const char **nam=
e, enum v4l2_ctrl_type *type,
> > > > > > > > =C2=A0=C2=A0=C2=A0	case V4L2_CID_RDS_TX_ALT_FREQS:
> > > > > > > > =C2=A0=C2=A0=C2=A0		*type =3D V4L2_CTRL_TYPE_U32;
> > > > > > > > =C2=A0=C2=A0=C2=A0		break;
> > > > > > > > +	case V4L2_CID_MPEG_VIDEO_MPEG2_SEQ_HDR:
> > > > > > > > +		*type =3D V4L2_CTRL_TYPE_MPEG2_SEQ_HDR;
> > > > > > > > +		break;
> > > > > > > > +	case V4L2_CID_MPEG_VIDEO_MPEG2_SEQ_EXT:
> > > > > > > > +		*type =3D V4L2_CTRL_TYPE_MPEG2_SEQ_EXT;
> > > > > > > > +		break;
> > > > > > > > +	case V4L2_CID_MPEG_VIDEO_MPEG2_SEQ_DISPLAY_EXT:
> > > > > > > > +		*type =3D V4L2_CTRL_TYPE_MPEG2_SEQ_DISPLAY_EXT;
> > > > > > > > +		break;
> > > > > > > > +	case V4L2_CID_MPEG_VIDEO_MPEG2_SEQ_MATRIX_EXT:
> > > > > > > > +		*type =3D V4L2_CTRL_TYPE_MPEG2_SEQ_MATRIX_EXT;
> > > > > > > > +		break;
> > > > > > > > +	case V4L2_CID_MPEG_VIDEO_MPEG2_PIC_HDR:
> > > > > > > > +		*type =3D V4L2_CTRL_TYPE_MPEG2_PIC_HDR;
> > > > > > > > +		break;
> > > > > > > > +	case V4L2_CID_MPEG_VIDEO_MPEG2_PIC_EXT:
> > > > > > > > +		*type =3D V4L2_CTRL_TYPE_MPEG2_PIC_EXT;
> > > > > > > > +		break;
> > > > > > > > =C2=A0=C2=A0=C2=A0	default:
> > > > > > > > =C2=A0=C2=A0=C2=A0		*type =3D V4L2_CTRL_TYPE_INTEGER;
> > > > > > > > =C2=A0=C2=A0=C2=A0		break;
> > > > @@ -1460,6 +1485,14 @@ static int std_validate(const struct v4l2_ct=
rl *ctrl, u32 idx,
> > > > > > > > =C2=A0=C2=A0=C2=A0			return -ERANGE;
> > > > > > > > =C2=A0=C2=A0=C2=A0		return 0;
> > > > =C2=A0=C2=A0=C2=A0
> > > > > > > > +	case V4L2_CTRL_TYPE_MPEG2_SEQ_HDR:
> > > > > > > > +	case V4L2_CTRL_TYPE_MPEG2_SEQ_EXT:
> > > > > > > > +	case V4L2_CTRL_TYPE_MPEG2_SEQ_DISPLAY_EXT:
> > > > > > > > +	case V4L2_CTRL_TYPE_MPEG2_SEQ_MATRIX_EXT:
> > > > > > > > +	case V4L2_CTRL_TYPE_MPEG2_PIC_HDR:
> > > > > > > > +	case V4L2_CTRL_TYPE_MPEG2_PIC_EXT:
> > > > > > > > +		return 0;
> > > > +
> > > > > > > > =C2=A0=C2=A0=C2=A0	default:
> > > > > > > > =C2=A0=C2=A0=C2=A0		return -EINVAL;
> > > > > > > > =C2=A0=C2=A0=C2=A0	}
> > > > @@ -1979,6 +2012,26 @@ static struct v4l2_ctrl *v4l2_ctrl_new(struc=
t v4l2_ctrl_handler *hdl,
> > > > > > > > =C2=A0=C2=A0=C2=A0	case V4L2_CTRL_TYPE_U32:
> > > > > > > > =C2=A0=C2=A0=C2=A0		elem_size =3D sizeof(u32);
> > > > > > > > =C2=A0=C2=A0=C2=A0		break;
> > > > > > > > +	case V4L2_CTRL_TYPE_MPEG2_SEQ_HDR:
> > > > > > > > +		elem_size =3D sizeof(struct v4l2_mpeg_video_mpeg2_seq_hd=
r);
> > > > > > > > +		break;
> > > > > > > > +	case V4L2_CTRL_TYPE_MPEG2_SEQ_EXT:
> > > > > > > > +		elem_size =3D sizeof(struct v4l2_mpeg_video_mpeg2_seq_ex=
t);
> > > > > > > > +		break;
> > > > > > > > +	case V4L2_CTRL_TYPE_MPEG2_SEQ_DISPLAY_EXT:
> > > > > > > > +		elem_size =3D
> > > > > > > > +			sizeof(struct v4l2_mpeg_video_mpeg2_seq_display_ext);
> > > > > > > > +		break;
> > > > > > > > +	case V4L2_CTRL_TYPE_MPEG2_SEQ_MATRIX_EXT:
> > > > > > > > +		elem_size =3D
> > > > > > > > +			sizeof(struct v4l2_mpeg_video_mpeg2_seq_matrix_ext);
> > > > > > > > +		break;
> > > > > > > > +	case V4L2_CTRL_TYPE_MPEG2_PIC_HDR:
> > > > > > > > +		elem_size =3D sizeof(struct v4l2_mpeg_video_mpeg2_pic_hd=
r);
> > > > > > > > +		break;
> > > > > > > > +	case V4L2_CTRL_TYPE_MPEG2_PIC_EXT:
> > > > > > > > +		elem_size =3D sizeof(struct v4l2_mpeg_video_mpeg2_pic_ex=
t);
> > > > > > > > +		break;
> > > > > > > > =C2=A0=C2=A0=C2=A0	default:
> > > > > > > > =C2=A0=C2=A0=C2=A0		if (type < V4L2_CTRL_COMPOUND_TYPES)
> > > > > > > > =C2=A0=C2=A0=C2=A0			elem_size =3D sizeof(s32);
> > > > diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v=
4l2-core/v4l2-ioctl.c
> > > > index e5a2187..394e636 100644
> > > > --- a/drivers/media/v4l2-core/v4l2-ioctl.c
> > > > +++ b/drivers/media/v4l2-core/v4l2-ioctl.c
> > > > @@ -1250,7 +1250,9 @@ static void v4l_fill_fmtdesc(struct v4l2_fmtd=
esc *fmt)
> > > > > > > > > > > > =C2=A0=C2=A0=C2=A0		case V4L2_PIX_FMT_H264_MVC:	des=
cr =3D "H.264 MVC"; break;
> > > > > > > > > > > > =C2=A0=C2=A0=C2=A0		case V4L2_PIX_FMT_H263:		descr =
=3D "H.263"; break;
> > > > > > > > > > > > =C2=A0=C2=A0=C2=A0		case V4L2_PIX_FMT_MPEG1:	descr =
=3D "MPEG-1 ES"; break;
> > > > > > > > > > > > +		case V4L2_PIX_FMT_MPEG1_PARSED:	descr =3D "MPEG-=
1 with parsing metadata"; break;
> > > > > > > > > > > > =C2=A0=C2=A0=C2=A0		case V4L2_PIX_FMT_MPEG2:	descr =
=3D "MPEG-2 ES"; break;
> > > > > > > > > > > > +		case V4L2_PIX_FMT_MPEG2_PARSED:	descr =3D "MPEG-=
2 with parsing metadata"; break;
> > > > > > > > > > > > =C2=A0=C2=A0=C2=A0		case V4L2_PIX_FMT_MPEG4:	descr =
=3D "MPEG-4 part 2 ES"; break;
> > > > > > > > > > > > =C2=A0=C2=A0=C2=A0		case V4L2_PIX_FMT_XVID:		descr =
=3D "Xvid"; break;
> > > > > > > > > > > > =C2=A0=C2=A0=C2=A0		case V4L2_PIX_FMT_VC1_ANNEX_G:	=
descr =3D "VC-1 (SMPTE 412M Annex G)"; break;
> > > > diff --git a/include/uapi/linux/v4l2-controls.h b/include/uapi/linu=
x/v4l2-controls.h
> > > > index 0d2e1e0..2be9db2 100644
> > > > --- a/include/uapi/linux/v4l2-controls.h
> > > > +++ b/include/uapi/linux/v4l2-controls.h
> > > > @@ -547,6 +547,100 @@ enum v4l2_mpeg_video_mpeg4_profile {
> > > > =C2=A0=C2=A0=C2=A0};
> > > > > > > > =C2=A0=C2=A0=C2=A0#define V4L2_CID_MPEG_VIDEO_MPEG4_QPEL		(=
V4L2_CID_MPEG_BASE+407)
> > > > =C2=A0=C2=A0=C2=A0
> > > > +/*
> > > > + * parsed MPEG-2 controls
> > > > + * (needed by stateless video decoders)
> > > > + * Those controls have been defined based on MPEG-2 standard ISO/I=
EC 13818-2,
> > > > + * and so derive directly from the MPEG-2 video bitstream syntax i=
ncluding
> > > > + * how it is coded inside bitstream (enumeration values for ex.).
> > > > + */
> > > > > > > > +#define MPEG2_QUANTISER_MATRIX_SIZE	64
> > > > > > > > +#define V4L2_CID_MPEG_VIDEO_MPEG2_SEQ_HDR		(V4L2_CID_MPEG_=
BASE+450)
> > > > +struct v4l2_mpeg_video_mpeg2_seq_hdr {
> > > > > > > > > > > > +	__u16	width;
> > > > > > > > > > > > +	__u16	height;
> > > > > > > > > > > > +	__u8	aspect_ratio_info;
> > > > > > > > > > > > +	__u8	frame_rate_code;
> > > > > > > > > > > > +	__u16	vbv_buffer_size;
> > > > > > > > > > > > +	__u32	bitrate_value;
> > > > > > > > > > > > +	__u16	constrained_parameters_flag;
> > > > > > > > > > > > +	__u8	load_intra_quantiser_matrix;
> > > > > > > > > > > > +	__u8	load_non_intra_quantiser_matrix;
> > > > > > > > > > > > +	__u8	intra_quantiser_matrix[MPEG2_QUANTISER_MATRI=
X_SIZE];
> > > > > > > > > > > > +	__u8	non_intra_quantiser_matrix[MPEG2_QUANTISER_M=
ATRIX_SIZE];
> > > > > > > > > > > > +	__u32	par_w;
> > > > > > > > > > > > +	__u32	par_h;
> > > > > > > > > > > > +	__u32	fps_n;
> > > > > > > > > > > > +	__u32	fps_d;
> > > > > > > > > > > > +	__u32	bitrate;
> > > > +};
> > > > > > > > +#define V4L2_CID_MPEG_VIDEO_MPEG2_SEQ_EXT		(V4L2_CID_MPEG_=
BASE+451)
> > > > +struct v4l2_mpeg_video_mpeg2_seq_ext {
> > > > > > > > > > > > +	__u8	profile;
> > > > > > > > > > > > +	__u8	level;
> > > > > > > > > > > > +	__u8	progressive;
> > > > > > > > > > > > +	__u8	chroma_format;
> > > > > > > > > > > > +	__u8	horiz_size_ext;
> > > > > > > > > > > > +	__u8	vert_size_ext;
> > > > > > > > > > > > +	__u16	bitrate_ext;
> > > > > > > > > > > > +	__u8	vbv_buffer_size_ext;
> > > > > > > > > > > > +	__u8	low_delay;
> > > > > > > > > > > > +	__u8	fps_n_ext;
> > > > > > > > > > > > +	__u8	fps_d_ext;
> > > > +};
> > > > > > > > +#define V4L2_CID_MPEG_VIDEO_MPEG2_SEQ_DISPLAY_EXT	(V4L2_CI=
D_MPEG_BASE+452)
> > > > +struct v4l2_mpeg_video_mpeg2_seq_display_ext {
> > > > > > > > > > > > +	__u16	display_horizontal_size;
> > > > > > > > > > > > +	__u16	display_vertical_size;
> > > > > > > > > > > > +	__u8	video_format;
> > > > > > > > > > > > +	__u8	colour_description_flag;
> > > > > > > > > > > > +	__u8	colour_primaries;
> > > > > > > > > > > > +	__u8	transfer_characteristics;
> > > > > > > > > > > > +	__u8	matrix_coefficients;
> > > > +};
> > > > > > > > +#define V4L2_CID_MPEG_VIDEO_MPEG2_SEQ_MATRIX_EXT	(V4L2_CID=
_MPEG_BASE+453)
> > > > +struct v4l2_mpeg_video_mpeg2_seq_matrix_ext {
> > > > > > > > > > > > +	__u8	load_intra_quantiser_matrix;
> > > > > > > > > > > > +	__u8	intra_quantiser_matrix[MPEG2_QUANTISER_MATRI=
X_SIZE];
> > > > > > > > > > > > +	__u8	load_non_intra_quantiser_matrix;
> > > > > > > > > > > > +	__u8	non_intra_quantiser_matrix[MPEG2_QUANTISER_M=
ATRIX_SIZE];
> > > > > > > > > > > > +	__u8	load_chroma_intra_quantiser_matrix;
> > > > > > > > > > > > +	__u8	chroma_intra_quantiser_matrix[MPEG2_QUANTISE=
R_MATRIX_SIZE];
> > > > > > > > > > > > +	__u8	load_chroma_non_intra_quantiser_matrix;
> > > > > > > > > > > > +	__u8	chroma_non_intra_quantiser_matrix[MPEG2_QUAN=
TISER_MATRIX_SIZE];
> > > > +};
> > > > > > > > +#define V4L2_CID_MPEG_VIDEO_MPEG2_PIC_HDR		(V4L2_CID_MPEG_=
BASE+454)
> > > > +struct v4l2_mpeg_video_mpeg2_pic_hdr {
> > > > > > > > > > > > +	__u32	offset;
> > > > > > > > > > > > +	__u16	tsn;
> > > > > > > > > > > > +	__u16	vbv_delay;
> > > > > > > > > > > > +	__u8	pic_type;
> > > > > > > > > > > > +	__u8	full_pel_forward_vector;
> > > > > > > > > > > > +	__u8	full_pel_backward_vector;
> > > > > > > > > > > > +	__u8	f_code[2][2];
> > > > +};
> > > > > > > > +#define V4L2_CID_MPEG_VIDEO_MPEG2_PIC_EXT		(V4L2_CID_MPEG_=
BASE+455)
> > > > +struct v4l2_mpeg_video_mpeg2_pic_ext {
> > > > > > > > > > > > +	__u8	f_code[2][2];
> > > > > > > > > > > > +	__u8	intra_dc_precision;
> > > > > > > > > > > > +	__u8	picture_structure;
> > > > > > > > > > > > +	__u8	top_field_first;
> > > > > > > > > > > > +	__u8	frame_pred_frame_dct;
> > > > > > > > > > > > +	__u8	concealment_motion_vectors;
> > > > > > > > > > > > +	__u8	q_scale_type;
> > > > > > > > > > > > +	__u8	intra_vlc_format;
> > > > > > > > > > > > +	__u8	alternate_scan;
> > > > > > > > > > > > +	__u8	repeat_first_field;
> > > > > > > > > > > > +	__u8	chroma_420_type;
> > > > > > > > > > > > +	__u8	progressive_frame;
> > > > > > > > > > > > +	__u8	composite_display;
> > > > > > > > > > > > +	__u8	v_axis;
> > > > > > > > > > > > +	__u8	field_sequence;
> > > > > > > > > > > > +	__u8	sub_carrier;
> > > > > > > > > > > > +	__u8	burst_amplitude;
> > > > > > > > > > > > +	__u8	sub_carrier_phase;
> > > > +};
> > > > +
> > > > =C2=A0=C2=A0=C2=A0/*=C2=A0=C2=A0Control IDs for VP8 streams
> > > > =C2=A0=C2=A0=C2=A0=C2=A0*=C2=A0=C2=A0Although VP8 is not part of MP=
EG we add these controls to the MPEG class
> > > > =C2=A0=C2=A0=C2=A0=C2=A0*=C2=A0=C2=A0as that class is already handl=
ing other video compression standards
> > > > diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/vi=
deodev2.h
> > > > index 2b8feb8..abf05f49 100644
> > > > --- a/include/uapi/linux/videodev2.h
> > > > +++ b/include/uapi/linux/videodev2.h
> > > > @@ -622,7 +622,9 @@ struct v4l2_pix_format {
> > > > =C2=A0=C2=A0=C2=A0#define V4L2_PIX_FMT_H264_MVC v4l2_fourcc('M', '2=
', '6', '4') /* H264 MVC */
> > > > =C2=A0=C2=A0=C2=A0#define V4L2_PIX_FMT_H263=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0v4l2_fourcc('H', '2', '6', '3') /* H263=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0*/
> > > > =C2=A0=C2=A0=C2=A0#define V4L2_PIX_FMT_MPEG1=C2=A0=C2=A0=C2=A0=C2=
=A0v4l2_fourcc('M', 'P', 'G', '1') /* MPEG-1 ES=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0*/
> > > > +#define V4L2_PIX_FMT_MPEG1_PARSED v4l2_fourcc('M', 'G', '1', 'P') =
/* MPEG1 with parsing metadata given through controls */
> > > > =C2=A0=C2=A0=C2=A0#define V4L2_PIX_FMT_MPEG2=C2=A0=C2=A0=C2=A0=C2=
=A0v4l2_fourcc('M', 'P', 'G', '2') /* MPEG-2 ES=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0*/
> > > > +#define V4L2_PIX_FMT_MPEG2_PARSED v4l2_fourcc('M', 'G', '2', 'P') =
/* MPEG2 with parsing metadata given through controls */
> > > > =C2=A0=C2=A0=C2=A0#define V4L2_PIX_FMT_MPEG4=C2=A0=C2=A0=C2=A0=C2=
=A0v4l2_fourcc('M', 'P', 'G', '4') /* MPEG-4 part 2 ES */
> > > > =C2=A0=C2=A0=C2=A0#define V4L2_PIX_FMT_XVID=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0v4l2_fourcc('X', 'V', 'I', 'D') /* Xvid=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0*/
> > > > =C2=A0=C2=A0=C2=A0#define V4L2_PIX_FMT_VC1_ANNEX_G v4l2_fourcc('V',=
 'C', '1', 'G') /* SMPTE 421M Annex G compliant stream */
> > > > @@ -1605,6 +1607,12 @@ enum v4l2_ctrl_type {
> > > > > > > > > > > > =C2=A0=C2=A0=C2=A0	V4L2_CTRL_TYPE_U8	=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=3D 0x0100,
> > > > > > > > > > > > =C2=A0=C2=A0=C2=A0	V4L2_CTRL_TYPE_U16	=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=3D 0x0101,
> > > > > > > > > > > > =C2=A0=C2=A0=C2=A0	V4L2_CTRL_TYPE_U32	=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=3D 0x0102,
> > > > > > > > +	V4L2_CTRL_TYPE_MPEG2_SEQ_HDR=C2=A0=C2=A0=3D 0x0109,
> > > > > > > > +	V4L2_CTRL_TYPE_MPEG2_SEQ_EXT=C2=A0=C2=A0=3D 0x010A,
> > > > > > > > +	V4L2_CTRL_TYPE_MPEG2_SEQ_DISPLAY_EXT=C2=A0=C2=A0=3D 0x010=
B,
> > > > > > > > +	V4L2_CTRL_TYPE_MPEG2_SEQ_MATRIX_EXT=C2=A0=C2=A0=3D 0x010C=
,
> > > > > > > > +	V4L2_CTRL_TYPE_MPEG2_PIC_HDR=C2=A0=C2=A0=3D 0x010D,
> > > > > > > > +	V4L2_CTRL_TYPE_MPEG2_PIC_EXT=C2=A0=C2=A0=3D 0x010E,
> > > > =C2=A0=C2=A0=C2=A0};
> > > > =C2=A0=C2=A0=C2=A0
> > > > =C2=A0=C2=A0=C2=A0/*=C2=A0=C2=A0Used in the VIDIOC_QUERYCTRL ioctl =
for querying controls */
>=20
>=20
--=-LFiYlyFxKBF4FxO00ce1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iEYEABECAAYFAllf1BQACgkQcVMCLawGqBwfYQCgjg2K/ejr6tyEge7iMJy1DoWs
EkcAn2o1QRm2w8EwEajilfd18OKl0IF3
=JMpG
-----END PGP SIGNATURE-----

--=-LFiYlyFxKBF4FxO00ce1--
