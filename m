Return-Path: <SRS0=h5dj=RI=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_NEOMUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0372CC43381
	for <linux-media@archiver.kernel.org>; Tue,  5 Mar 2019 11:16:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C620E208E4
	for <linux-media@archiver.kernel.org>; Tue,  5 Mar 2019 11:16:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727698AbfCELQc (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 5 Mar 2019 06:16:32 -0500
Received: from relay2-d.mail.gandi.net ([217.70.183.194]:57133 "EHLO
        relay2-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727424AbfCELQb (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 5 Mar 2019 06:16:31 -0500
X-Originating-IP: 90.88.147.150
Received: from localhost (aaubervilliers-681-1-27-150.w90-88.abo.wanadoo.fr [90.88.147.150])
        (Authenticated sender: maxime.ripard@bootlin.com)
        by relay2-d.mail.gandi.net (Postfix) with ESMTPSA id DEFFD4000E;
        Tue,  5 Mar 2019 11:16:25 +0000 (UTC)
Date:   Tue, 5 Mar 2019 12:16:25 +0100
From:   Maxime Ripard <maxime.ripard@bootlin.com>
To:     Tomasz Figa <tfiga@chromium.org>
Cc:     Hans Verkuil <hans.verkuil@cisco.com>,
        Alexandre Courbot <acourbot@chromium.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Pawel Osciak <posciak@chromium.org>,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Chen-Yu Tsai <wens@csie.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "list@263.net:IOMMU DRIVERS <iommu@lists.linux-foundation.org>, Joerg
        Roedel <joro@8bytes.org>," <linux-arm-kernel@lists.infradead.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Nicolas Dufresne <nicolas.dufresne@collabora.com>,
        jenskuske@gmail.com, Jernej Skrabec <jernej.skrabec@gmail.com>,
        Jonas Karlman <jonas@kwiboo.se>,
        Ezequiel Garcia <ezequiel@collabora.com>,
        linux-sunxi@googlegroups.com,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Guenter Roeck <groeck@chromium.org>
Subject: Re: [PATCH v4 1/2] media: uapi: Add H264 low-level decoder API
 compound controls.
Message-ID: <20190305111625.or44y4k7or25v44s@flea>
References: <cover.1862a43851950ddee041d53669f8979aba863c38.1550672228.git-series.maxime.ripard@bootlin.com>
 <9817c9875638ed2484d61e6e128e2551cf3bda4c.1550672228.git-series.maxime.ripard@bootlin.com>
 <CAAFQd5D3CVQQDkP3uKM6dYkmfsLohXcdjG0wMMLukFf-D=TCsw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="uuwvzyhdb64wixaa"
Content-Disposition: inline
In-Reply-To: <CAAFQd5D3CVQQDkP3uKM6dYkmfsLohXcdjG0wMMLukFf-D=TCsw@mail.gmail.com>
User-Agent: NeoMutt/20180716
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org


--uuwvzyhdb64wixaa
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Feb 22, 2019 at 04:46:17PM +0900, Tomasz Figa wrote:
> Hi Maxime,
>=20
> On Wed, Feb 20, 2019 at 11:17 PM Maxime Ripard
> <maxime.ripard@bootlin.com> wrote:
> >
> > From: Pawel Osciak <posciak@chromium.org>
> >
> > Stateless video codecs will require both the H264 metadata and slices in
> > order to be able to decode frames.
> >
> > This introduces the definitions for a new pixel format for H264 slices =
that
> > have been parsed, as well as the structures used to pass the metadata f=
rom
> > the userspace to the kernel.
> >
> > Co-Developped-by: Maxime Ripard <maxime.ripard@bootlin.com>
> > Signed-off-by: Pawel Osciak <posciak@chromium.org>
> > Signed-off-by: Guenter Roeck <groeck@chromium.org>
> > Signed-off-by: Maxime Ripard <maxime.ripard@bootlin.com>
>=20
> Thanks for the patch. Some comments inline.
>=20
> [snip]
> > +``V4L2_CID_MPEG_VIDEO_H264_SLICE_PARAMS (struct)``
> > +    Specifies the slice parameters (as extracted from the bitstream)
> > +    for the associated H264 slice data. This includes the necessary
> > +    parameters for configuring a stateless hardware decoding pipeline
> > +    for H264.  The bitstream parameters are defined according to
> > +    :ref:`h264`. Unless there's a specific comment, refer to the
> > +    specification for the documentation of these fields, section 7.4.3
> > +    "Slice Header Semantics".
>=20
> Note that this is expected to be an array, with entries for all the
> slices included in the bitstream buffer.
>=20
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
> > +    * - __u8
> > +      - ``redundant_pic_cnt``
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
> > +    * - __u8
> > +      - ``num_ref_idx_l0_active_minus1``
> > +      -
> > +    * - __u8
> > +      - ``num_ref_idx_l1_active_minus1``
> > +      -
> > +    * - __u32
> > +      - ``slice_group_change_cycle``
> > +      -
> > +    * - __u8
> > +      - ``ref_pic_list0[32]``
> > +      -
> > +    * - __u8
> > +      - ``ref_pic_list1[32]``
> > +      -
>=20
> Should we explicitly document that these are the lists after applying
> the per-slice modifications, as opposed to the original order from
> v4l2_ctrl_h264_decode_param?
>=20
> [snip]
> > +    * .. _V4L2-PIX-FMT-H264-SLICE:
> > +
> > +      - ``V4L2_PIX_FMT_H264_SLICE``
> > +      - 'S264'
> > +      - H264 parsed slice data, as extracted from the H264 bitstream.
> > +       This format is adapted for stateless video decoders that
> > +       implement an H264 pipeline (using the :ref:`codec` and
> > +       :ref:`media-request-api`).  Metadata associated with the frame
> > +       to decode are required to be passed through the
> > +       ``V4L2_CID_MPEG_VIDEO_H264_SPS``,
> > +       ``V4L2_CID_MPEG_VIDEO_H264_PPS``,
> > +       ``V4L2_CID_MPEG_VIDEO_H264_SLICE_PARAMS`` and
> > +       ``V4L2_CID_MPEG_VIDEO_H264_DECODE_PARAMS`` controls and
> > +       scaling matrices can optionally be specified through the
> > +       ``V4L2_CID_MPEG_VIDEO_H264_SCALING_MATRIX`` control.  See the
> > +       :ref:`associated Codec Control IDs <v4l2-mpeg-h264>`.
> > +       Exactly one output and one capture buffer must be provided for
> > +       use with this pixel format. The output buffer must contain the
> > +       appropriate number of macroblocks to decode a full
> > +       corresponding frame to the matching capture buffer.
>=20
> What does it mean that a control can be optionally specified? A
> control always has a value, so how do we decide that it was specified
> or not? Should we have another control (or flag) that selects whether
> to use the control? How is it better than just having the control
> initialized with the default scaling matrix and always using it?

Ok, I'll change it.

> > diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videod=
ev2.h
> > index 9a920f071ff9..6443ae53597f 100644
> > --- a/include/uapi/linux/videodev2.h
> > +++ b/include/uapi/linux/videodev2.h
> > @@ -653,6 +653,7 @@ struct v4l2_pix_format {
> >  #define V4L2_PIX_FMT_H264     v4l2_fourcc('H', '2', '6', '4') /* H264 =
with start codes */
> >  #define V4L2_PIX_FMT_H264_NO_SC v4l2_fourcc('A', 'V', 'C', '1') /* H26=
4 without start codes */
> >  #define V4L2_PIX_FMT_H264_MVC v4l2_fourcc('M', '2', '6', '4') /* H264 =
MVC */
> > +#define V4L2_PIX_FMT_H264_SLICE v4l2_fourcc('S', '2', '6', '4') /* H26=
4 parsed slices */
>=20
> Are we okay with adding here already, without going through staging first?

This is what we did for MPEG-2 already (the format is public but the
controls are not), so I'm not sure this is causing any issue.

Thanks!
Maxime

--=20
Maxime Ripard, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com

--uuwvzyhdb64wixaa
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRcEzekXsqa64kGDp7j7w1vZxhRxQUCXH5aiQAKCRDj7w1vZxhR
xQaDAPwIoVWR1TeT+e5bf+LEb/U2rgJXDTwx9jFMhcytq2st5AEAmizIpWf0N2Yg
FG30mptGQpK4Z+e3nj9EK8Z5VcL3Qwg=
=mZv8
-----END PGP SIGNATURE-----

--uuwvzyhdb64wixaa--
