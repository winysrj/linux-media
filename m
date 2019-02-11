Return-Path: <SRS0=8Y7M=QS=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2558DC169C4
	for <linux-media@archiver.kernel.org>; Mon, 11 Feb 2019 17:16:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B047D21B1A
	for <linux-media@archiver.kernel.org>; Mon, 11 Feb 2019 17:16:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ndufresne-ca.20150623.gappssmtp.com header.i=@ndufresne-ca.20150623.gappssmtp.com header.b="sc0SZyXL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728229AbfBKRQ2 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 11 Feb 2019 12:16:28 -0500
Received: from mail-qt1-f196.google.com ([209.85.160.196]:43804 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727643AbfBKRQ1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 11 Feb 2019 12:16:27 -0500
Received: by mail-qt1-f196.google.com with SMTP id y4so13002477qtc.10
        for <linux-media@vger.kernel.org>; Mon, 11 Feb 2019 09:16:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ndufresne-ca.20150623.gappssmtp.com; s=20150623;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version;
        bh=h20M80aetaBu3leP8wPUvUFMRFDOXCqldMYvJwsXIDc=;
        b=sc0SZyXL2qBRuX0RW7WK3IhbAP6KNwkosKh5iHrZSlz9sswOBCTva6kfBf5HJfltuA
         YDmqm3HOHCC3nfoC0moByPviifriqgC/SISRBRQz7Fv9Nvs7XjPL3spFl/GiMzvmoX0b
         VjQEf4qObev/MU7PX0tZzUbmLcDc0Z7WJdDGP/ld1WDeqgwfVkW1Qza4Dlqw3rYEM1SL
         XpgLCuT7MZNxb2AIZlbAlb8R6FAb7C1MXO/QtrRiLZj/6ctGfcuXh182rnNtBv4hkGLR
         q9/Af7Hsj4ISwTE9/HuQK5GDFo50NlJiyfiGby3JjiOXlHgneJAHnR6rZCgeuPRHoVWU
         t7uA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version;
        bh=h20M80aetaBu3leP8wPUvUFMRFDOXCqldMYvJwsXIDc=;
        b=AkRGE4cxWhTutPkzsXuRAcHmNveRUJ3pQKIJD0OVd4lw/yMjzpE70f+8E7nG3A8vGe
         TKMTj5VKoXd/CHG6E3BbjrSzntK2iGqKccnBcA9uZqHc0BmAsrtkdqjHilgOyG3iOUex
         FYNpbFrCFQXqXUr1yRkxXRu4elq46bTUkLSqyYv8u4LaD0Sp61l8AVAdH1UY6odFkHqP
         V58lqoMV3BvgYp2FH0TzkU5W2sf/b+s6qjdNiwdqy518FSKt6vVaFOvRJGrRRavw5GKi
         5q2DFXBWbkv4kxwx8fFLMxbK/IFBu8BSjbYQpLD1wokSrMW2begQyXjAcfnos5EWTnlh
         VP7A==
X-Gm-Message-State: AHQUAuaJdHIRNMXB/zpwusyDPc6+uoIVne4xr+DHlq5yuXUtf7bMg5WN
        qNQEyfkR2cIahI//oZKtkmm8uA==
X-Google-Smtp-Source: AHgI3IaM/ZXdNikw9zXZ/jriHt0cJMBgdeCxL3BB24yFNzf1zJGjxHofQSB+mTt/dnHQkHJ7bOseVg==
X-Received: by 2002:ac8:4547:: with SMTP id z7mr28159948qtn.37.1549905386445;
        Mon, 11 Feb 2019 09:16:26 -0800 (PST)
Received: from tpx230-nicolas.collaboramtl (modemcable154.55-37-24.static.videotron.ca. [24.37.55.154])
        by smtp.gmail.com with ESMTPSA id e49sm13139854qta.0.2019.02.11.09.16.24
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 11 Feb 2019 09:16:25 -0800 (PST)
Message-ID: <6ec22799669a0bd50d50ec4092e17384269f71a0.camel@ndufresne.ca>
Subject: Re: [PATCH v3 1/2] media: uapi: Add H264 low-level decoder API
 compound controls.
From:   Nicolas Dufresne <nicolas@ndufresne.ca>
To:     Hans Verkuil <hverkuil@xs4all.nl>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        hans.verkuil@cisco.com, acourbot@chromium.org,
        sakari.ailus@linux.intel.com,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc:     tfiga@chromium.org, posciak@chromium.org,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Chen-Yu Tsai <wens@csie.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        jenskuske@gmail.com, jernej.skrabec@gmail.com, jonas@kwiboo.se,
        ezequiel@collabora.com, linux-sunxi@googlegroups.com,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Guenter Roeck <groeck@chromium.org>
Date:   Mon, 11 Feb 2019 12:16:23 -0500
In-Reply-To: <716ae1ff-8e62-c723-5b5a-0b018cf6af6a@xs4all.nl>
References: <cover.d3bb4d93da91ed5668025354ee1fca656e7d5b8b.1549895062.git-series.maxime.ripard@bootlin.com>
         <562aefcd53a1a30d034e97f177096d70fb705f2b.1549895062.git-series.maxime.ripard@bootlin.com>
         <716ae1ff-8e62-c723-5b5a-0b018cf6af6a@xs4all.nl>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
        boundary="=-jejBamhJyQs8HUSHEKyK"
User-Agent: Evolution 3.30.4 (3.30.4-1.fc29) 
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org


--=-jejBamhJyQs8HUSHEKyK
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Le lundi 11 f=C3=A9vrier 2019 =C3=A0 16:16 +0100, Hans Verkuil a =C3=A9crit=
 :
> Hi Maxime,
>=20
> A quick review below. Note that I am no expert on the codec details, so
> I leave that to others. I'm mainly concentrating on the structs, flags, e=
tc.
>=20
> On 2/11/19 3:39 PM, Maxime Ripard wrote:
> > From: Pawel Osciak <posciak@chromium.org>
> >=20
> > Stateless video codecs will require both the H264 metadata and slices i=
n
> > order to be able to decode frames.
> >=20
> > This introduces the definitions for a new pixel format for H264 slices =
that
> > have been parsed, as well as the structures used to pass the metadata f=
rom
> > the userspace to the kernel.
> >=20
> > Co-Developed-by: Maxime Ripard <maxime.ripard@bootlin.com>
> > Signed-off-by: Pawel Osciak <posciak@chromium.org>
> > Signed-off-by: Guenter Roeck <groeck@chromium.org>
> > Signed-off-by: Maxime Ripard <maxime.ripard@bootlin.com>
> > ---
> >  Documentation/media/uapi/v4l/biblio.rst            |   9 +-
> >  Documentation/media/uapi/v4l/extended-controls.rst | 530 +++++++++++++=
+-
> >  Documentation/media/uapi/v4l/pixfmt-compressed.rst |  20 +-
> >  Documentation/media/uapi/v4l/vidioc-queryctrl.rst  |  30 +-
> >  Documentation/media/videodev2.h.rst.exceptions     |   5 +-
> >  drivers/media/v4l2-core/v4l2-ctrls.c               |  42 +-
> >  drivers/media/v4l2-core/v4l2-ioctl.c               |   1 +-
> >  include/media/h264-ctrls.h                         | 179 +++++-
> >  include/media/v4l2-ctrls.h                         |  13 +-
> >  include/uapi/linux/videodev2.h                     |   1 +-
> >  10 files changed, 829 insertions(+), 1 deletion(-)
> >  create mode 100644 include/media/h264-ctrls.h
> >=20
> > diff --git a/Documentation/media/uapi/v4l/biblio.rst b/Documentation/me=
dia/uapi/v4l/biblio.rst
> > index ec33768c055e..3fc3f7ff338a 100644
> > --- a/Documentation/media/uapi/v4l/biblio.rst
> > +++ b/Documentation/media/uapi/v4l/biblio.rst
> > @@ -122,6 +122,15 @@ ITU BT.1119
> > =20
> >  :author:    International Telecommunication Union (http://www.itu.ch)
> > =20
> > +.. _h264:
> > +
> > +ITU H.264
> > +=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > +
> > +:title:     ITU-T Recommendation H.264 "Advanced Video Coding for Gene=
ric Audiovisual Services"
> > +
> > +:author:    International Telecommunication Union (http://www.itu.ch)
> > +
> >  .. _jfif:
> > =20
> >  JFIF
> > diff --git a/Documentation/media/uapi/v4l/extended-controls.rst b/Docum=
entation/media/uapi/v4l/extended-controls.rst
> > index af4273aa5e85..7e306aa0d0a6 100644
> > --- a/Documentation/media/uapi/v4l/extended-controls.rst
> > +++ b/Documentation/media/uapi/v4l/extended-controls.rst
> > @@ -1703,6 +1703,536 @@ enum v4l2_mpeg_video_h264_hierarchical_coding_t=
ype -
> >  	non-intra-coded frames, in zigzag scanning order. Only relevant for
> >  	non-4:2:0 YUV formats.
> > =20
> > +.. _v4l2-mpeg-h264:
> > +
> > +``V4L2_CID_MPEG_VIDEO_H264_SPS (struct)``
> > +    Specifies the sequence parameter set (as extracted from the
> > +    bitstream) for the associated H264 slice data. This includes the
> > +    necessary parameters for configuring a stateless hardware decoding
> > +    pipeline for H264.  The bitstream parameters are defined according
> > +    to :ref:`h264`. Unless there's a specific comment, refer to the
> > +    specification for the documentation of these fields, section 7.4.2=
.1.1
> > +    "Sequence Parameter Set Data Semantics".
> > +
> > +    .. note::
> > +
> > +       This compound control is not yet part of the public kernel API =
and
> > +       it is expected to change.
> > +
> > +.. c:type:: v4l2_ctrl_h264_sps
> > +
> > +.. cssclass:: longtable
> > +
> > +.. flat-table:: struct v4l2_ctrl_h264_sps
> > +    :header-rows:  0
> > +    :stub-columns: 0
> > +    :widths:       1 1 2
> > +
> > +    * - __u8
> > +      - ``profile_idc``
> > +      -
> > +    * - __u8
> > +      - ``constraint_set_flags``
> > +      - See :ref:`Sequence Parameter Set Constraints Set Flags <h264_s=
ps_constraints_set_flags>`
> > +    * - __u8
> > +      - ``level_idc``
> > +      -
> > +    * - __u8
> > +      - ``seq_parameter_set_id``
> > +      -
> > +    * - __u8
> > +      - ``chroma_format_idc``
> > +      -
> > +    * - __u8
> > +      - ``bit_depth_luma_minus8``
> > +      -
> > +    * - __u8
> > +      - ``bit_depth_chroma_minus8``
> > +      -
> > +    * - __u8
> > +      - ``log2_max_frame_num_minus4``
> > +      -
> > +    * - __u8
> > +      - ``pic_order_cnt_type``
> > +      -
> > +    * - __u8
> > +      - ``log2_max_pic_order_cnt_lsb_minus4``
> > +      -
> > +    * - __u8
> > +      - ``max_num_ref_frames``
> > +      -
> > +    * - __u8
> > +      - ``num_ref_frames_in_pic_order_cnt_cycle``
> > +      -
> > +    * - __s32
> > +      - ``offset_for_ref_frame[255]``
> > +      -
> > +    * - __s32
> > +      - ``offset_for_non_ref_pic``
> > +      -
> > +    * - __s32
> > +      - ``offset_for_top_to_bottom_field``
> > +      -
> > +    * - __u16
> > +      - ``pic_width_in_mbs_minus1``
> > +      -
> > +    * - __u16
> > +      - ``pic_height_in_map_units_minus1``
> > +      -
> > +    * - __u32
> > +      - ``flags``
> > +      - See :ref:`Sequence Parameter Set Flags <h264_sps_flags>`
> > +
> > +.. _h264_sps_constraints_set_flags:
> > +
> > +``Sequence Parameter Set Constraints Set Flags``
> > +
> > +.. cssclass:: longtable
> > +
> > +.. flat-table::
> > +    :header-rows:  0
> > +    :stub-columns: 0
> > +    :widths:       1 1 2
> > +
> > +    * - ``V4L2_H264_SPS_CONSTRAINT_SET0_FLAG``
> > +      - 0x00000001
> > +      -
> > +    * - ``V4L2_H264_SPS_CONSTRAINT_SET1_FLAG``
> > +      - 0x00000002
> > +      -
> > +    * - ``V4L2_H264_SPS_CONSTRAINT_SET2_FLAG``
> > +      - 0x00000004
> > +      -
> > +    * - ``V4L2_H264_SPS_CONSTRAINT_SET3_FLAG``
> > +      - 0x00000008
> > +      -
> > +    * - ``V4L2_H264_SPS_CONSTRAINT_SET4_FLAG``
> > +      - 0x00000010
> > +      -
> > +    * - ``V4L2_H264_SPS_CONSTRAINT_SET5_FLAG``
> > +      - 0x00000020
> > +      -
> > +
> > +.. _h264_sps_flags:
> > +
> > +``Sequence Parameter Set Flags``
> > +
> > +.. cssclass:: longtable
> > +
> > +.. flat-table::
> > +    :header-rows:  0
> > +    :stub-columns: 0
> > +    :widths:       1 1 2
> > +
> > +    * - ``V4L2_H264_SPS_FLAG_SEPARATE_COLOUR_PLANE``
> > +      - 0x00000001
> > +      -
> > +    * - ``V4L2_H264_SPS_FLAG_QPPRIME_Y_ZERO_TRANSFORM_BYPASS``
> > +      - 0x00000002
> > +      -
> > +    * - ``V4L2_H264_SPS_FLAG_DELTA_PIC_ORDER_ALWAYS_ZERO``
> > +      - 0x00000004
> > +      -
> > +    * - ``V4L2_H264_SPS_FLAG_GAPS_IN_FRAME_NUM_VALUE_ALLOWED``
> > +      - 0x00000008
> > +      -
> > +    * - ``V4L2_H264_SPS_FLAG_FRAME_MBS_ONLY``
> > +      - 0x00000010
> > +      -
> > +    * - ``V4L2_H264_SPS_FLAG_MB_ADAPTIVE_FRAME_FIELD``
> > +      - 0x00000020
> > +      -
> > +    * - ``V4L2_H264_SPS_FLAG_DIRECT_8X8_INFERENCE``
> > +      - 0x00000040
> > +      -
> > +
> > +``V4L2_CID_MPEG_VIDEO_H264_PPS (struct)``
> > +    Specifies the picture parameter set (as extracted from the
> > +    bitstream) for the associated H264 slice data. This includes the
> > +    necessary parameters for configuring a stateless hardware decoding
> > +    pipeline for H264.  The bitstream parameters are defined according
> > +    to :ref:`h264`. Unless there's a specific comment, refer to the
> > +    specification for the documentation of these fields, section 7.4.2=
.2
> > +    "Picture Parameter Set RBSP Semantics".
> > +
> > +    .. note::
> > +
> > +       This compound control is not yet part of the public kernel API =
and
> > +       it is expected to change.
> > +
> > +.. c:type:: v4l2_ctrl_h264_pps
> > +
> > +.. cssclass:: longtable
> > +
> > +.. flat-table:: struct v4l2_ctrl_h264_pps
> > +    :header-rows:  0
> > +    :stub-columns: 0
> > +    :widths:       1 1 2
> > +
> > +    * - __u8
> > +      - ``pic_parameter_set_id``
> > +      -
> > +    * - __u8
> > +      - ``seq_parameter_set_id``
> > +      -
> > +    * - __u8
> > +      - ``num_slice_groups_minus1``
> > +      -
> > +    * - __u8
> > +      - ``num_ref_idx_l0_default_active_minus1``
> > +      -
> > +    * - __u8
> > +      - ``num_ref_idx_l1_default_active_minus1``
> > +      -
> > +    * - __u8
> > +      - ``weighted_bipred_idc``
> > +      -
> > +    * - __s8
> > +      - ``pic_init_qp_minus26``
> > +      -
> > +    * - __s8
> > +      - ``pic_init_qs_minus26``
> > +      -
> > +    * - __s8
> > +      - ``chroma_qp_index_offset``
> > +      -
> > +    * - __s8
> > +      - ``second_chroma_qp_index_offset``
> > +      -
> > +    * - __u16
> > +      - ``flags``
> > +      - See :ref:`Picture Parameter Set Flags <h264_pps_flags>`
> > +
> > +.. _h264_pps_flags:
> > +
> > +``Picture Parameter Set Flags``
> > +
> > +.. cssclass:: longtable
> > +
> > +.. flat-table::
> > +    :header-rows:  0
> > +    :stub-columns: 0
> > +    :widths:       1 1 2
> > +
> > +    * - ``V4L2_H264_PPS_FLAG_ENTROPY_CODING_MODE``
> > +      - 0x00000001
> > +      -
> > +    * - ``V4L2_H264_PPS_FLAG_BOTTOM_FIELD_PIC_ORDER_IN_FRAME_PRESENT``
> > +      - 0x00000002
> > +      -
> > +    * - ``V4L2_H264_PPS_FLAG_WEIGHTED_PRED``
> > +      - 0x00000004
> > +      -
> > +    * - ``V4L2_H264_PPS_FLAG_DEBLOCKING_FILTER_CONTROL_PRESENT``
> > +      - 0x00000008
> > +      -
> > +    * - ``V4L2_H264_PPS_FLAG_CONSTRAINED_INTRA_PRED``
> > +      - 0x00000010
> > +      -
> > +    * - ``V4L2_H264_PPS_FLAG_REDUNDANT_PIC_CNT_PRESENT``
> > +      - 0x00000020
> > +      -
> > +    * - ``V4L2_H264_PPS_FLAG_TRANSFORM_8X8_MODE``
> > +      - 0x00000040
> > +      -
> > +    * - ``V4L2_H264_PPS_FLAG_PIC_SCALING_MATRIX_PRESENT``
> > +      - 0x00000080
> > +      -
> > +
> > +``V4L2_CID_MPEG_VIDEO_H264_SCALING_MATRIX (struct)``
> > +    Specifies the scaling matrix (as extracted from the bitstream) for
> > +    the associated H264 slice data. The bitstream parameters are
> > +    defined according to :ref:`h264`. Unless there's a specific
> > +    comment, refer to the specification for the documentation of these
> > +    fields, section 7.4.2.1.1.1  "Scaling List Semantics".
> > +
> > +    .. note::
> > +
> > +       This compound control is not yet part of the public kernel API =
and
> > +       it is expected to change.
> > +
> > +.. c:type:: v4l2_ctrl_h264_scaling_matrix
> > +
> > +.. cssclass:: longtable
> > +
> > +.. flat-table:: struct v4l2_ctrl_h264_scaling_matrix
> > +    :header-rows:  0
> > +    :stub-columns: 0
> > +    :widths:       1 1 2
> > +
> > +    * - __u8
> > +      - ``scaling_list_4x4[6][16]``
> > +      -
> > +    * - __u8
> > +      - ``scaling_list_8x8[6][64]``
> > +      -
> > +
> > +``V4L2_CID_MPEG_VIDEO_H264_SLICE_PARAMS (struct)``
> > +    Specifies the slice parameters (as extracted from the bitstream)
> > +    for the associated H264 slice data. This includes the necessary
> > +    parameters for configuring a stateless hardware decoding pipeline
> > +    for H264.  The bitstream parameters are defined according to
> > +    :ref:`h264`. Unless there's a specific comment, refer to the
> > +    specification for the documentation of these fields, section 7.4.3
> > +    "Slice Header Semantics".
> > +
> > +    .. note::
> > +
> > +       This compound control is not yet part of the public kernel API =
and
> > +       it is expected to change.
> > +
> > +.. c:type:: v4l2_ctrl_h264_slice_param
> > +
> > +.. cssclass:: longtable
> > +
> > +.. flat-table:: struct v4l2_ctrl_h264_slice_param
> > +    :header-rows:  0
> > +    :stub-columns: 0
> > +    :widths:       1 1 2
> > +
> > +    * - __u32
> > +      - ``size``
> > +      -
> > +    * - __u32
> > +      - ``header_bit_size``
> > +      -
> > +    * - __u16
> > +      - ``first_mb_in_slice``
> > +      -
> > +    * - __u8
> > +      - ``slice_type``
> > +      -
> > +    * - __u8
> > +      - ``pic_parameter_set_id``
> > +      -
> > +    * - __u8
> > +      - ``colour_plane_id``
> > +      -
> > +    * - __u16
> > +      - ``frame_num``
> > +      -
> > +    * - __u16
> > +      - ``idr_pic_id``
> > +      -
> > +    * - __u16
> > +      - ``pic_order_cnt_lsb``
> > +      -
> > +    * - __s32
> > +      - ``delta_pic_order_cnt_bottom``
> > +      -
> > +    * - __s32
> > +      - ``delta_pic_order_cnt0``
> > +      -
> > +    * - __s32
> > +      - ``delta_pic_order_cnt1``
> > +      -
> > +    * - __u8
> > +      - ``redundant_pic_cnt``
>=20
> This should be moved to just before 'frame_num' as per the actual struct.
>=20
> > +      -
> > +    * - struct :c:type:`v4l2_h264_pred_weight_table`
> > +      - ``pred_weight_table``
> > +      -
> > +    * - __u32
> > +      - ``dec_ref_pic_marking_bit_size``
> > +      -
> > +    * - __u32
> > +      - ``pic_order_cnt_bit_size``
> > +      -
> > +    * - __u8
> > +      - ``cabac_init_idc``
> > +      -
> > +    * - __s8
> > +      - ``slice_qp_delta``
> > +      -
> > +    * - __s8
> > +      - ``slice_qs_delta``
> > +      -
> > +    * - __u8
> > +      - ``disable_deblocking_filter_idc``
> > +      -
> > +    * - __s8
> > +      - ``slice_alpha_c0_offset_div2``
> > +      -
> > +    * - __s8
> > +      - ``slice_beta_offset_div2``
> > +      -
> > +    * - __u32
> > +      - ``slice_group_change_cycle``
> > +      -
> > +    * - __u8
> > +      - ``num_ref_idx_l0_active_minus1``
> > +      -
> > +    * - __u8
> > +      - ``num_ref_idx_l1_active_minus1``
>=20
> These two fields should be moved to just before the slice_group_change_cy=
cle
> field as per the actual struct.
>=20
> > +      -
> > +    * - __u8
> > +      - ``ref_pic_list0[32]``
> > +      -
> > +    * - __u8
> > +      - ``ref_pic_list1[32]``
> > +      -
> > +    * - __u32
> > +      - ``flags``
> > +      - See :ref:`Slice Parameter Flags <h264_slice_flags>`
> > +
> > +.. _h264_slice_flags:
> > +
> > +``Slice Parameter Set Flags``
> > +
> > +.. cssclass:: longtable
> > +
> > +.. flat-table::
> > +    :header-rows:  0
> > +    :stub-columns: 0
> > +    :widths:       1 1 2
> > +
> > +    * - ``V4L2_H264_SLICE_FLAG_FIELD_PIC``
> > +      - 0x00000001
> > +      -
> > +    * - ``V4L2_H264_SLICE_FLAG_BOTTOM_FIELD``
> > +      - 0x00000002
> > +      -
> > +    * - ``V4L2_H264_SLICE_FLAG_DIRECT_SPATIAL_MV_PRED``
> > +      - 0x00000004
> > +      -
> > +    * - ``V4L2_H264_SLICE_FLAG_SP_FOR_SWITCH``
> > +      - 0x00000008
> > +      -
> > +
> > +``Prediction Weight Table``
> > +
> > +    Unless there's a specific comment, refer to the specification for
> > +    the documentation of these fields, section 7.4.3.2 "Prediction
> > +    Weight Table Semantics".
> > +
> > +.. c:type:: v4l2_h264_pred_weight_table
> > +
> > +.. cssclass:: longtable
> > +
> > +.. flat-table:: struct v4l2_h264_pred_weight_table
> > +    :header-rows:  0
> > +    :stub-columns: 0
> > +    :widths:       1 1 2
> > +
> > +    * - __u16
> > +      - ``luma_log2_weight_denom``
> > +      -
> > +    * - __u16
> > +      - ``chroma_log2_weight_denom``
> > +      -
> > +    * - struct :c:type:`v4l2_h264_weight_factors`
> > +      - ``weight_factors[2]``
> > +      -
> > +
> > +.. c:type:: v4l2_h264_weight_factors
> > +
> > +.. cssclass:: longtable
> > +
> > +.. flat-table:: struct v4l2_h264_weight_factors
> > +    :header-rows:  0
> > +    :stub-columns: 0
> > +    :widths:       1 1 2
> > +
> > +    * - __s8
> > +      - ``luma_weight[32]``
> > +      -
> > +    * - __s8
> > +      - ``luma_offset[32]``
> > +      -
> > +    * - __s8
> > +      - ``chroma_weight[32][2]``
> > +      -
> > +    * - __s8
> > +      - ``chroma_offset[32][2]``
> > +      -
> > +
> > +``V4L2_CID_MPEG_VIDEO_H264_DECODE_PARAMS (struct)``
> > +    Specifies the decode parameters (as extracted from the bitstream)
> > +    for the associated H264 slice data. This includes the necessary
> > +    parameters for configuring a stateless hardware decoding pipeline
> > +    for H264.  The bitstream parameters are defined according to
> > +    :ref:`h264`. Unless there's a specific comment, refer to the
> > +    specification for the documentation of these fields.
> > +
> > +    .. note::
> > +
> > +       This compound control is not yet part of the public kernel API =
and
> > +       it is expected to change.
> > +
> > +.. c:type:: v4l2_ctrl_h264_decode_param
> > +
> > +.. cssclass:: longtable
> > +
> > +.. flat-table:: struct v4l2_ctrl_h264_decode_param
> > +    :header-rows:  0
> > +    :stub-columns: 0
> > +    :widths:       1 1 2
> > +
> > +    * - __u32
> > +      - ``num_slices``
> > +      - Number of slices needed to decode the current frame
> > +    * - __u16
> > +      - ``idr_pic_flag``
> > +      - Is the picture an IDR picture?
> > +    * - __u16
> > +      - ``nal_ref_idc``
> > +      - NAL reference ID value coming from the NAL Unit header
> > +    * - __s32
> > +      - ``top_field_order_cnt``
> > +      - Picture Order Count for the coded top field
> > +    * - __s32
> > +      - ``bottom_field_order_cnt``
> > +      - Picture Order Count for the coded bottom field
> > +    * - struct :c:type:`v4l2_h264_dpb_entry`
> > +      - ``dpb[16]``
> > +      -
> > +
> > +.. c:type:: v4l2_h264_dpb_entry
> > +
> > +.. cssclass:: longtable
> > +
> > +.. flat-table:: struct v4l2_h264_dpb_entry
> > +    :header-rows:  0
> > +    :stub-columns: 0
> > +    :widths:       1 1 2
> > +
> > +    * - __u32
> > +      - ``tag``
> > +      - tag to identify the buffer containing the reference frame
>=20
> This is outdated: it's a __u64 timestamp.
>=20
> You can copy the struct backward_ref_ts documentation from struct
> v4l2_ctrl_mpeg2_slice_params and edit it a bit for H.264.
>=20
> > +    * - __u16
> > +      - ``frame_num``
> > +      -
> > +    * - __u16
> > +      - ``pic_num``
> > +      -
> > +    * - __s32
> > +      - ``top_field_order_cnt``
> > +      -
> > +    * - __s32
> > +      - ``bottom_field_order_cnt``
> > +      -
> > +    * - __u32
> > +      - ``flags``
> > +      - See :ref:`DPB Entry Flags <h264_dpb_flags>`
> > +
> > +.. _h264_dpb_flags:
> > +
> > +``DPB Entries Flags``
> > +
> > +.. cssclass:: longtable
> > +
> > +.. flat-table::
> > +    :header-rows:  0
> > +    :stub-columns: 0
> > +    :widths:       1 1 2
> > +
> > +    * - ``V4L2_H264_DPB_ENTRY_FLAG_VALID``
> > +      - 0x00000001
> > +      -
> > +    * - ``V4L2_H264_DPB_ENTRY_FLAG_ACTIVE``
> > +      - 0x00000002
> > +      -
> > +
> >  MFC 5.1 MPEG Controls
> >  ---------------------
> > =20
> > diff --git a/Documentation/media/uapi/v4l/pixfmt-compressed.rst b/Docum=
entation/media/uapi/v4l/pixfmt-compressed.rst
> > index e4c5e456df59..95905b967693 100644
> > --- a/Documentation/media/uapi/v4l/pixfmt-compressed.rst
> > +++ b/Documentation/media/uapi/v4l/pixfmt-compressed.rst
> > @@ -52,6 +52,26 @@ Compressed Formats
> >        - ``V4L2_PIX_FMT_H264_MVC``
> >        - 'M264'
> >        - H264 MVC video elementary stream.
> > +    * .. _V4L2-PIX-FMT-H264-SLICE:
> > +
> > +      - ``V4L2_PIX_FMT_H264_SLICE``
> > +      - 'S264'
> > +      - H264 parsed slice data, as extracted from the H264 bitstream.
> > +	This format is adapted for stateless video decoders that
> > +	implement an H264 pipeline (using the :ref:`codec` and
> > +	:ref:`media-request-api`).  Metadata associated with the frame
> > +	to decode are required to be passed through the
> > +	``V4L2_CID_MPEG_VIDEO_H264_SPS``,
> > +	``V4L2_CID_MPEG_VIDEO_H264_PPS``,
> > +	``V4L2_CID_MPEG_VIDEO_H264_SLICE_PARAMS`` and
> > +	``V4L2_CID_MPEG_VIDEO_H264_DECODE_PARAMS`` controls and
> > +	scaling matrices can optionally be specified through the
> > +	``V4L2_CID_MPEG_VIDEO_H264_SCALING_MATRIX`` control.  See the
> > +	:ref:`associated Codec Control IDs <v4l2-mpeg-h264>`.
> > +	Exactly one output and one capture buffer must be provided for
> > +	use with this pixel format. The output buffer must contain the
> > +	appropriate number of macroblocks to decode a full
> > +	corresponding frame to the matching capture buffer.
> >      * .. _V4L2-PIX-FMT-H263:
> > =20
> >        - ``V4L2_PIX_FMT_H263``
> > diff --git a/Documentation/media/uapi/v4l/vidioc-queryctrl.rst b/Docume=
ntation/media/uapi/v4l/vidioc-queryctrl.rst
> > index f824162d0ea9..bf29dc5b9758 100644
> > --- a/Documentation/media/uapi/v4l/vidioc-queryctrl.rst
> > +++ b/Documentation/media/uapi/v4l/vidioc-queryctrl.rst
> > @@ -443,6 +443,36 @@ See also the examples in :ref:`control`.
> >        - n/a
> >        - A struct :c:type:`v4l2_ctrl_mpeg2_quantization`, containing MP=
EG-2
> >  	quantization matrices for stateless video decoders.
> > +    * - ``V4L2_CTRL_TYPE_H264_SPS``
> > +      - n/a
> > +      - n/a
> > +      - n/a
> > +      - A struct :c:type:`v4l2_ctrl_h264_sps`, containing H264
> > +	sequence parameters for stateless video decoders.
> > +    * - ``V4L2_CTRL_TYPE_H264_PPS``
> > +      - n/a
> > +      - n/a
> > +      - n/a
> > +      - A struct :c:type:`v4l2_ctrl_h264_pps`, containing H264
> > +	picture parameters for stateless video decoders.
> > +    * - ``V4L2_CTRL_TYPE_H264_SCALING_MATRIX``
> > +      - n/a
> > +      - n/a
> > +      - n/a
> > +      - A struct :c:type:`v4l2_ctrl_h264_scaling_matrix`, containing H=
264
> > +	scaling matrices for stateless video decoders.
> > +    * - ``V4L2_CTRL_TYPE_H264_SLICE_PARAMS``
> > +      - n/a
> > +      - n/a
> > +      - n/a
> > +      - A struct :c:type:`v4l2_ctrl_h264_slice_param`, containing H264
> > +	slice parameters for stateless video decoders.
> > +    * - ``V4L2_CTRL_TYPE_H264_DECODE_PARAMS``
> > +      - n/a
> > +      - n/a
> > +      - n/a
> > +      - A struct :c:type:`v4l2_ctrl_h264_decode_param`, containing H26=
4
> > +	decode parameters for stateless video decoders.
> > =20
> >  .. tabularcolumns:: |p{6.6cm}|p{2.2cm}|p{8.7cm}|
> > =20
> > diff --git a/Documentation/media/videodev2.h.rst.exceptions b/Documenta=
tion/media/videodev2.h.rst.exceptions
> > index 64d348e67df9..55cbe324b9fc 100644
> > --- a/Documentation/media/videodev2.h.rst.exceptions
> > +++ b/Documentation/media/videodev2.h.rst.exceptions
> > @@ -136,6 +136,11 @@ replace symbol V4L2_CTRL_TYPE_U32 :c:type:`v4l2_ct=
rl_type`
> >  replace symbol V4L2_CTRL_TYPE_U8 :c:type:`v4l2_ctrl_type`
> >  replace symbol V4L2_CTRL_TYPE_MPEG2_SLICE_PARAMS :c:type:`v4l2_ctrl_ty=
pe`
> >  replace symbol V4L2_CTRL_TYPE_MPEG2_QUANTIZATION :c:type:`v4l2_ctrl_ty=
pe`
> > +replace symbol V4L2_CTRL_TYPE_H264_SPS :c:type:`v4l2_ctrl_type`
> > +replace symbol V4L2_CTRL_TYPE_H264_PPS :c:type:`v4l2_ctrl_type`
> > +replace symbol V4L2_CTRL_TYPE_H264_SCALING_MATRIX :c:type:`v4l2_ctrl_t=
ype`
> > +replace symbol V4L2_CTRL_TYPE_H264_SLICE_PARAMS :c:type:`v4l2_ctrl_typ=
e`
> > +replace symbol V4L2_CTRL_TYPE_H264_DECODE_PARAMS :c:type:`v4l2_ctrl_ty=
pe`
> > =20
> >  # V4L2 capability defines
> >  replace define V4L2_CAP_VIDEO_CAPTURE device-capabilities
> > diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-=
core/v4l2-ctrls.c
> > index e3bd441fa29a..fe9f9447caba 100644
> > --- a/drivers/media/v4l2-core/v4l2-ctrls.c
> > +++ b/drivers/media/v4l2-core/v4l2-ctrls.c
> > @@ -825,6 +825,11 @@ const char *v4l2_ctrl_get_name(u32 id)
> >  	case V4L2_CID_MPEG_VIDEO_H264_HIERARCHICAL_CODING_LAYER:return "H264 =
Number of HC Layers";
> >  	case V4L2_CID_MPEG_VIDEO_H264_HIERARCHICAL_CODING_LAYER_QP:
> >  								return "H264 Set QP Value for HC Layers";
> > +	case V4L2_CID_MPEG_VIDEO_H264_SPS:			return "H264 Sequence Parameter =
Set";
> > +	case V4L2_CID_MPEG_VIDEO_H264_PPS:			return "H264 Picture Parameter S=
et";
> > +	case V4L2_CID_MPEG_VIDEO_H264_SCALING_MATRIX:		return "H264 Scaling M=
atrix";
> > +	case V4L2_CID_MPEG_VIDEO_H264_SLICE_PARAMS:		return "H264 Slice Param=
eters";
> > +	case V4L2_CID_MPEG_VIDEO_H264_DECODE_PARAMS:		return "H264 Decode Par=
ameters";
> >  	case V4L2_CID_MPEG_VIDEO_MPEG4_I_FRAME_QP:		return "MPEG4 I-Frame QP =
Value";
> >  	case V4L2_CID_MPEG_VIDEO_MPEG4_P_FRAME_QP:		return "MPEG4 P-Frame QP =
Value";
> >  	case V4L2_CID_MPEG_VIDEO_MPEG4_B_FRAME_QP:		return "MPEG4 B-Frame QP =
Value";
> > @@ -1300,6 +1305,21 @@ void v4l2_ctrl_fill(u32 id, const char **name, e=
num v4l2_ctrl_type *type,
> >  	case V4L2_CID_MPEG_VIDEO_MPEG2_QUANTIZATION:
> >  		*type =3D V4L2_CTRL_TYPE_MPEG2_QUANTIZATION;
> >  		break;
> > +	case V4L2_CID_MPEG_VIDEO_H264_SPS:
> > +		*type =3D V4L2_CTRL_TYPE_H264_SPS;
> > +		break;
> > +	case V4L2_CID_MPEG_VIDEO_H264_PPS:
> > +		*type =3D V4L2_CTRL_TYPE_H264_PPS;
> > +		break;
> > +	case V4L2_CID_MPEG_VIDEO_H264_SCALING_MATRIX:
> > +		*type =3D V4L2_CTRL_TYPE_H264_SCALING_MATRIX;
> > +		break;
> > +	case V4L2_CID_MPEG_VIDEO_H264_SLICE_PARAMS:
> > +		*type =3D V4L2_CTRL_TYPE_H264_SLICE_PARAMS;
> > +		break;
> > +	case V4L2_CID_MPEG_VIDEO_H264_DECODE_PARAMS:
> > +		*type =3D V4L2_CTRL_TYPE_H264_DECODE_PARAMS;
> > +		break;
> >  	default:
> >  		*type =3D V4L2_CTRL_TYPE_INTEGER;
> >  		break;
> > @@ -1666,6 +1686,13 @@ static int std_validate(const struct v4l2_ctrl *=
ctrl, u32 idx,
> >  	case V4L2_CTRL_TYPE_MPEG2_QUANTIZATION:
> >  		return 0;
> > =20
> > +	case V4L2_CTRL_TYPE_H264_SPS:
> > +	case V4L2_CTRL_TYPE_H264_PPS:
> > +	case V4L2_CTRL_TYPE_H264_SCALING_MATRIX:
> > +	case V4L2_CTRL_TYPE_H264_SLICE_PARAMS:
> > +	case V4L2_CTRL_TYPE_H264_DECODE_PARAMS:
> > +		return 0;
> > +
> >  	default:
> >  		return -EINVAL;
> >  	}
> > @@ -2246,6 +2273,21 @@ static struct v4l2_ctrl *v4l2_ctrl_new(struct v4=
l2_ctrl_handler *hdl,
> >  	case V4L2_CTRL_TYPE_MPEG2_QUANTIZATION:
> >  		elem_size =3D sizeof(struct v4l2_ctrl_mpeg2_quantization);
> >  		break;
> > +	case V4L2_CTRL_TYPE_H264_SPS:
> > +		elem_size =3D sizeof(struct v4l2_ctrl_h264_sps);
> > +		break;
> > +	case V4L2_CTRL_TYPE_H264_PPS:
> > +		elem_size =3D sizeof(struct v4l2_ctrl_h264_pps);
> > +		break;
> > +	case V4L2_CTRL_TYPE_H264_SCALING_MATRIX:
> > +		elem_size =3D sizeof(struct v4l2_ctrl_h264_scaling_matrix);
> > +		break;
> > +	case V4L2_CTRL_TYPE_H264_SLICE_PARAMS:
> > +		elem_size =3D sizeof(struct v4l2_ctrl_h264_slice_param);
> > +		break;
> > +	case V4L2_CTRL_TYPE_H264_DECODE_PARAMS:
> > +		elem_size =3D sizeof(struct v4l2_ctrl_h264_decode_param);
> > +		break;
> >  	default:
> >  		if (type < V4L2_CTRL_COMPOUND_TYPES)
> >  			elem_size =3D sizeof(s32);
> > diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-=
core/v4l2-ioctl.c
> > index 1441a73ce64c..f42d6e7049eb 100644
> > --- a/drivers/media/v4l2-core/v4l2-ioctl.c
> > +++ b/drivers/media/v4l2-core/v4l2-ioctl.c
> > @@ -1313,6 +1313,7 @@ static void v4l_fill_fmtdesc(struct v4l2_fmtdesc =
*fmt)
> >  		case V4L2_PIX_FMT_H264:		descr =3D "H.264"; break;
> >  		case V4L2_PIX_FMT_H264_NO_SC:	descr =3D "H.264 (No Start Codes)"; br=
eak;
> >  		case V4L2_PIX_FMT_H264_MVC:	descr =3D "H.264 MVC"; break;
> > +		case V4L2_PIX_FMT_H264_SLICE:	descr =3D "H.264 Parsed Slice Data"; b=
reak;
> >  		case V4L2_PIX_FMT_H263:		descr =3D "H.263"; break;
> >  		case V4L2_PIX_FMT_MPEG1:	descr =3D "MPEG-1 ES"; break;
> >  		case V4L2_PIX_FMT_MPEG2:	descr =3D "MPEG-2 ES"; break;
> > diff --git a/include/media/h264-ctrls.h b/include/media/h264-ctrls.h
> > new file mode 100644
> > index 000000000000..7b0563dfa05f
> > --- /dev/null
> > +++ b/include/media/h264-ctrls.h
> > @@ -0,0 +1,179 @@
> > +/* SPDX-License-Identifier: GPL-2.0 */
> > +/*
> > + * These are the H.264 state controls for use with stateless H.264
> > + * codec drivers.
> > + *
> > + * It turns out that these structs are not stable yet and will undergo
> > + * more changes. So keep them private until they are stable and ready =
to
> > + * become part of the official public API.
> > + */
> > +
> > +#ifndef _H264_CTRLS_H_
> > +#define _H264_CTRLS_H_
> > +
> > +#define V4L2_CID_MPEG_VIDEO_H264_SPS		(V4L2_CID_MPEG_BASE+383)
> > +#define V4L2_CID_MPEG_VIDEO_H264_PPS		(V4L2_CID_MPEG_BASE+384)
> > +#define V4L2_CID_MPEG_VIDEO_H264_SCALING_MATRIX	(V4L2_CID_MPEG_BASE+38=
5)
> > +#define V4L2_CID_MPEG_VIDEO_H264_SLICE_PARAMS	(V4L2_CID_MPEG_BASE+386)
> > +#define V4L2_CID_MPEG_VIDEO_H264_DECODE_PARAMS	(V4L2_CID_MPEG_BASE+387=
)
> > +
> > +/* enum v4l2_ctrl_type type values */
> > +#define V4L2_CTRL_TYPE_H264_SPS 0x0105
> > +#define	V4L2_CTRL_TYPE_H264_PPS 0x0106
> > +#define	V4L2_CTRL_TYPE_H264_SCALING_MATRIX 0x0107
> > +#define	V4L2_CTRL_TYPE_H264_SLICE_PARAMS 0x0108
> > +#define	V4L2_CTRL_TYPE_H264_DECODE_PARAMS 0x0109
> > +
> > +#define V4L2_H264_SPS_CONSTRAINT_SET0_FLAG			0x01
> > +#define V4L2_H264_SPS_CONSTRAINT_SET1_FLAG			0x02
> > +#define V4L2_H264_SPS_CONSTRAINT_SET2_FLAG			0x04
> > +#define V4L2_H264_SPS_CONSTRAINT_SET3_FLAG			0x08
> > +#define V4L2_H264_SPS_CONSTRAINT_SET4_FLAG			0x10
> > +#define V4L2_H264_SPS_CONSTRAINT_SET5_FLAG			0x20
> > +
> > +#define V4L2_H264_SPS_FLAG_SEPARATE_COLOUR_PLANE		0x01
> > +#define V4L2_H264_SPS_FLAG_QPPRIME_Y_ZERO_TRANSFORM_BYPASS	0x02
> > +#define V4L2_H264_SPS_FLAG_DELTA_PIC_ORDER_ALWAYS_ZERO		0x04
> > +#define V4L2_H264_SPS_FLAG_GAPS_IN_FRAME_NUM_VALUE_ALLOWED	0x08
> > +#define V4L2_H264_SPS_FLAG_FRAME_MBS_ONLY			0x10
> > +#define V4L2_H264_SPS_FLAG_MB_ADAPTIVE_FRAME_FIELD		0x20
> > +#define V4L2_H264_SPS_FLAG_DIRECT_8X8_INFERENCE			0x40
> > +
> > +struct v4l2_ctrl_h264_sps {
> > +	__u8 profile_idc;
> > +	__u8 constraint_set_flags;
> > +	__u8 level_idc;
> > +	__u8 seq_parameter_set_id;
> > +	__u8 chroma_format_idc;
> > +	__u8 bit_depth_luma_minus8;
> > +	__u8 bit_depth_chroma_minus8;
> > +	__u8 log2_max_frame_num_minus4;
> > +	__u8 pic_order_cnt_type;
> > +	__u8 log2_max_pic_order_cnt_lsb_minus4;
> > +	__u8 max_num_ref_frames;
> > +	__u8 num_ref_frames_in_pic_order_cnt_cycle;
> > +	__s32 offset_for_ref_frame[255];
>=20
> Where does 255 come from? Should this be a define?

this is indexed relative to num_ref_frames_in_pic_order_cnt_cycle
(right before), which is defined in 7.4.2.1.1 as being between 0 and
255.

>=20
> If this is not based on the standard but instead a driver limitation, the=
n
> I think that should be documented. In that case I assume that if more is =
needed
> in the future, then that will be done through additional controls.
>=20
> > +	__s32 offset_for_non_ref_pic;
> > +	__s32 offset_for_top_to_bottom_field;
> > +	__u16 pic_width_in_mbs_minus1;
> > +	__u16 pic_height_in_map_units_minus1;
> > +	__u32 flags;
> > +};
> > +
> > +#define V4L2_H264_PPS_FLAG_ENTROPY_CODING_MODE				0x0001
> > +#define V4L2_H264_PPS_FLAG_BOTTOM_FIELD_PIC_ORDER_IN_FRAME_PRESENT	0x0=
002
> > +#define V4L2_H264_PPS_FLAG_WEIGHTED_PRED				0x0004
> > +#define V4L2_H264_PPS_FLAG_DEBLOCKING_FILTER_CONTROL_PRESENT		0x0008
> > +#define V4L2_H264_PPS_FLAG_CONSTRAINED_INTRA_PRED			0x0010
> > +#define V4L2_H264_PPS_FLAG_REDUNDANT_PIC_CNT_PRESENT			0x0020
> > +#define V4L2_H264_PPS_FLAG_TRANSFORM_8X8_MODE				0x0040
> > +#define V4L2_H264_PPS_FLAG_PIC_SCALING_MATRIX_PRESENT			0x0080
> > +
> > +struct v4l2_ctrl_h264_pps {
> > +	__u8 pic_parameter_set_id;
> > +	__u8 seq_parameter_set_id;
> > +	__u8 num_slice_groups_minus1;
> > +	__u8 num_ref_idx_l0_default_active_minus1;
> > +	__u8 num_ref_idx_l1_default_active_minus1;
> > +	__u8 weighted_bipred_idc;
> > +	__s8 pic_init_qp_minus26;
> > +	__s8 pic_init_qs_minus26;
> > +	__s8 chroma_qp_index_offset;
> > +	__s8 second_chroma_qp_index_offset;
> > +	__u16 flags;
> > +};
> > +
> > +struct v4l2_ctrl_h264_scaling_matrix {
> > +	__u8 scaling_list_4x4[6][16];
> > +	__u8 scaling_list_8x8[6][64];
> > +};
> > +
> > +struct v4l2_h264_weight_factors {
> > +	__s8 luma_weight[32];
> > +	__s8 luma_offset[32];
> > +	__s8 chroma_weight[32][2];
> > +	__s8 chroma_offset[32][2];
>=20
> Same question here.

As per 7.4.3.1 the second index refer to Cb (0) and 1 Cr(). And the 32
is the maximum number of RefPicList0, as limited by the range of=20
num_ref_idx_l0_active_minus1 (if I read properly). This will never
change, so if we add defines it would only be for documentation purpose
I think.

>=20
> > +};
> > +
> > +struct v4l2_h264_pred_weight_table {
> > +	__u16 luma_log2_weight_denom;
> > +	__u16 chroma_log2_weight_denom;
> > +	struct v4l2_h264_weight_factors weight_factors[2];
>=20
> I assume [0] is for luma and [1] is for chroma? Should be documented.

Yes.

>=20
> > +};
> > +
> > +#define V4L2_H264_SLICE_TYPE_P				0
> > +#define V4L2_H264_SLICE_TYPE_B				1
> > +#define V4L2_H264_SLICE_TYPE_I				2
> > +#define V4L2_H264_SLICE_TYPE_SP				3
> > +#define V4L2_H264_SLICE_TYPE_SI				4
> > +
> > +#define V4L2_H264_SLICE_FLAG_FIELD_PIC			0x01
> > +#define V4L2_H264_SLICE_FLAG_BOTTOM_FIELD		0x02
> > +#define V4L2_H264_SLICE_FLAG_DIRECT_SPATIAL_MV_PRED	0x04
> > +#define V4L2_H264_SLICE_FLAG_SP_FOR_SWITCH		0x08
> > +
> > +struct v4l2_ctrl_h264_slice_param {
> > +	/* Size in bytes, including header */
> > +	__u32 size;
> > +	/* Offset in bits to slice_data() from the beginning of this slice. *=
/
> > +	__u32 header_bit_size;
> > +
> > +	__u16 first_mb_in_slice;
> > +	__u8 slice_type;
> > +	__u8 pic_parameter_set_id;
> > +	__u8 colour_plane_id;
> > +	__u8 redundant_pic_cnt;
> > +	__u16 frame_num;
> > +	__u16 idr_pic_id;
> > +	__u16 pic_order_cnt_lsb;
> > +	__s32 delta_pic_order_cnt_bottom;
> > +	__s32 delta_pic_order_cnt0;
> > +	__s32 delta_pic_order_cnt1;
> > +
> > +	struct v4l2_h264_pred_weight_table pred_weight_table;
> > +	/* Size in bits of dec_ref_pic_marking() syntax element. */
> > +	__u32 dec_ref_pic_marking_bit_size;
> > +	/* Size in bits of pic order count syntax. */
> > +	__u32 pic_order_cnt_bit_size;
> > +
> > +	__u8 cabac_init_idc;
> > +	__s8 slice_qp_delta;
> > +	__s8 slice_qs_delta;
> > +	__u8 disable_deblocking_filter_idc;
> > +	__s8 slice_alpha_c0_offset_div2;
> > +	__s8 slice_beta_offset_div2;
> > +	__u8 num_ref_idx_l0_active_minus1;
> > +	__u8 num_ref_idx_l1_active_minus1;
> > +	__u32 slice_group_change_cycle;
> > +
> > +	/*  Entries on each list are indices
> > +	 *  into v4l2_ctrl_h264_decode_param.dpb[]. */
> > +	__u8 ref_pic_list0[32];
> > +	__u8 ref_pic_list1[32];
>=20
> Where does 32 come from?

It's the range of num_ref_idx_l0_active_minus1,=20

>=20
> > +
> > +	__u32 flags;
> > +};
> > +
> > +#define V4L2_H264_DPB_ENTRY_FLAG_VALID		0x01
> > +#define V4L2_H264_DPB_ENTRY_FLAG_ACTIVE		0x02
> > +
> > +struct v4l2_h264_dpb_entry {
> > +	__u64 timestamp;
> > +	__u16 frame_num;
> > +	__u16 pic_num;
> > +	/* Note that field is indicated by v4l2_buffer.field */
> > +	__s32 top_field_order_cnt;
> > +	__s32 bottom_field_order_cnt;
> > +	__u32 flags; /* V4L2_H264_DPB_ENTRY_FLAG_* */
> > +};
> > +
> > +struct v4l2_ctrl_h264_decode_param {
> > +	__u32 num_slices;
> > +	__u16 idr_pic_flag;
> > +	__u16 nal_ref_idc;
> > +	__s32 top_field_order_cnt;
> > +	__s32 bottom_field_order_cnt;
> > +	struct v4l2_h264_dpb_entry dpb[16];
>=20
> And 16?

H264 DPB size cannot exceed 16, that's well known normally.

>=20
> Nothing special needs to be done for those constants that are based on th=
e
> standard. But if it isn't part of the standard but a driver constraint, t=
hen
> that should be documented, and there should be an idea on how it can be
> extended for future drivers without that constraint.
>=20
> I think the API should be designed with 4k video in mind. So if some of
> these constants would be too small when dealing with 4k (even if the
> current HW doesn't support this yet), then these constants would have to
> be increased.
>=20
> And yes, I know 8k video is starting to appear, but I think it is OK
> that additional control(s) would be needed to support 8k.
>=20
> > +};
> > +
> > +#endif
> > diff --git a/include/media/v4l2-ctrls.h b/include/media/v4l2-ctrls.h
> > index d63cf227b0ab..22b6d09c4764 100644
> > --- a/include/media/v4l2-ctrls.h
> > +++ b/include/media/v4l2-ctrls.h
> > @@ -23,10 +23,11 @@
> >  #include <media/media-request.h>
> > =20
> >  /*
> > - * Include the mpeg2 stateless codec compound control definitions.
> > + * Include the stateless codec compound control definitions.
> >   * This will move to the public headers once this API is fully stable.
> >   */
> >  #include <media/mpeg2-ctrls.h>
> > +#include <media/h264-ctrls.h>
> > =20
> >  /* forward references */
> >  struct file;
> > @@ -49,6 +50,11 @@ struct poll_table_struct;
> >   * @p_char:			Pointer to a string.
> >   * @p_mpeg2_slice_params:	Pointer to a MPEG2 slice parameters structur=
e.
> >   * @p_mpeg2_quantization:	Pointer to a MPEG2 quantization data structu=
re.
> > + * @p_h264_sps:			Pointer to a struct v4l2_ctrl_h264_sps.
> > + * @p_h264_pps:			Pointer to a struct v4l2_ctrl_h264_pps.
> > + * @p_h264_scaling_matrix:	Pointer to a struct v4l2_ctrl_h264_scaling_=
matrix.
> > + * @p_h264_slice_param:		Pointer to a struct v4l2_ctrl_h264_slice_para=
m.
> > + * @p_h264_decode_param:	Pointer to a struct v4l2_ctrl_h264_decode_par=
am.
> >   * @p:				Pointer to a compound value.
> >   */
> >  union v4l2_ctrl_ptr {
> > @@ -60,6 +66,11 @@ union v4l2_ctrl_ptr {
> >  	char *p_char;
> >  	struct v4l2_ctrl_mpeg2_slice_params *p_mpeg2_slice_params;
> >  	struct v4l2_ctrl_mpeg2_quantization *p_mpeg2_quantization;
> > +	struct v4l2_ctrl_h264_sps *p_h264_sps;
> > +	struct v4l2_ctrl_h264_pps *p_h264_pps;
> > +	struct v4l2_ctrl_h264_scaling_matrix *p_h264_scaling_matrix;
> > +	struct v4l2_ctrl_h264_slice_param *p_h264_slice_param;
> > +	struct v4l2_ctrl_h264_decode_param *p_h264_decode_param;
> >  	void *p;
> >  };
> > =20
> > diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videod=
ev2.h
> > index d6eed479c3a6..6fc955926bdb 100644
> > --- a/include/uapi/linux/videodev2.h
> > +++ b/include/uapi/linux/videodev2.h
> > @@ -645,6 +645,7 @@ struct v4l2_pix_format {
> >  #define V4L2_PIX_FMT_H264     v4l2_fourcc('H', '2', '6', '4') /* H264 =
with start codes */
> >  #define V4L2_PIX_FMT_H264_NO_SC v4l2_fourcc('A', 'V', 'C', '1') /* H26=
4 without start codes */
> >  #define V4L2_PIX_FMT_H264_MVC v4l2_fourcc('M', '2', '6', '4') /* H264 =
MVC */
> > +#define V4L2_PIX_FMT_H264_SLICE v4l2_fourcc('S', '2', '6', '4') /* H26=
4 parsed slices */
> >  #define V4L2_PIX_FMT_H263     v4l2_fourcc('H', '2', '6', '3') /* H263 =
         */
> >  #define V4L2_PIX_FMT_MPEG1    v4l2_fourcc('M', 'P', 'G', '1') /* MPEG-=
1 ES     */
> >  #define V4L2_PIX_FMT_MPEG2    v4l2_fourcc('M', 'P', 'G', '2') /* MPEG-=
2 ES     */
> >=20
>=20
> Regards,
>=20
> 	Hans

--=-jejBamhJyQs8HUSHEKyK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQSScpfJiL+hb5vvd45xUwItrAaoHAUCXGGt5wAKCRBxUwItrAao
HF7cAJ9YeSX0FvTf5uFLXHhYxMz61sv1egCeP7iAugKJbqSI0vRVou+O6TakVvM=
=+Vhu
-----END PGP SIGNATURE-----

--=-jejBamhJyQs8HUSHEKyK--

