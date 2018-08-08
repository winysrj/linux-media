Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:57891 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726733AbeHHORA (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 8 Aug 2018 10:17:00 -0400
Message-ID: <cc8a91347e03d85ecbb9ff2dcb765cc4e2411284.camel@bootlin.com>
Subject: Re: [PATCH v6 1/8] media: v4l: Add definitions for MPEG2 slice
 format and metadata
From: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
To: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devel@driverdev.osuosl.org
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Chen-Yu Tsai <wens@csie.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        linux-sunxi@googlegroups.com,
        Hugues Fruchet <hugues.fruchet@st.com>,
        Randy Li <ayaka@soulik.info>,
        Ezequiel Garcia <ezequiel@collabora.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Alexandre Courbot <acourbot@chromium.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Date: Wed, 08 Aug 2018 13:57:25 +0200
In-Reply-To: <cf07a5d1-9179-44af-de11-61f02bbcf904@xs4all.nl>
References: <20180725100256.22833-1-paul.kocialkowski@bootlin.com>
         <20180725100256.22833-2-paul.kocialkowski@bootlin.com>
         <cf07a5d1-9179-44af-de11-61f02bbcf904@xs4all.nl>
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-D31xMAXsK/g9Q3eW+EJt"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-D31xMAXsK/g9Q3eW+EJt
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Hans,

On Sat, 2018-08-04 at 13:35 +0200, Hans Verkuil wrote:
> Hi Paul,
>=20
> Some comments below. It looks pretty good, it's mostly small things that =
I
> commented upon.

And thanks for the review!

> On 07/25/2018 12:02 PM, Paul Kocialkowski wrote:
> > Stateless video decoding engines require both the MPEG slices and
> > associated metadata from the video stream in order to decode frames.
> >=20
> > This introduces definitions for a new pixel format, describing buffers
> > with MPEG2 slice data, as well as a control structure for passing the
> > frame metadata to drivers.
> >=20
> > This is based on work from both Florent Revest and Hugues Fruchet.
> >=20
> > Signed-off-by: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
> > ---
> >  .../media/uapi/v4l/extended-controls.rst      | 122 ++++++++++++++++++
> >  .../media/uapi/v4l/pixfmt-compressed.rst      |   5 +
> >  drivers/media/v4l2-core/v4l2-ctrls.c          |  54 ++++++++
> >  drivers/media/v4l2-core/v4l2-ioctl.c          |   1 +
> >  include/media/v4l2-ctrls.h                    |  18 ++-
> >  include/uapi/linux/v4l2-controls.h            |  43 ++++++
> >  include/uapi/linux/videodev2.h                |   5 +
> >  7 files changed, 241 insertions(+), 7 deletions(-)
> >=20
> > diff --git a/Documentation/media/uapi/v4l/extended-controls.rst b/Docum=
entation/media/uapi/v4l/extended-controls.rst
> > index 9f7312bf3365..4a29d89fd9ac 100644
> > --- a/Documentation/media/uapi/v4l/extended-controls.rst
> > +++ b/Documentation/media/uapi/v4l/extended-controls.rst
> > @@ -1497,6 +1497,128 @@ enum v4l2_mpeg_video_h264_hierarchical_coding_t=
ype -
> > =20
> > =20
> > =20
> > +.. _v4l2-mpeg-mpeg2:
> > +
> > +``V4L2_CID_MPEG_VIDEO_MPEG2_SLICE_PARAMS (struct)``
> > +    Specifies the slice parameters (also known as slice header) for th=
e
> > +    associated MPEG-2 slice data. This includes all the necessary
> > +    parameters for configuring a hardware decoder pipeline for MPEG-2.
>=20
> This seems to be mostly a representation of the MPEG-2 "Picture coding
> extension" (6.2.3.1 in ISO/IEC 13818-2: 1995).
> ISO/IEC 13818-2
> Is that correct? I think some references to the standard should be added
> were appropriate.

The structure does contain fields from the picture coding extension, but
also takes some bits from other parts of the bitstream. I have added
references to the specs and split out the different parts of the
structure for the next revision. I also took the occasion to add/rename
some fields to stick closer to the bitstream fields.

> > +
> > +.. tabularcolumns:: |p{2.0cm}|p{4.0cm}|p{11.0cm}|
> > +
> > +.. c:type:: v4l2_ctrl_mpeg2_slice_params
> > +
> > +.. cssclass:: longtable
> > +
> > +.. flat-table:: struct v4l2_ctrl_mpeg2_slice_params
> > +    :header-rows:  0
> > +    :stub-columns: 0
> > +    :widths:       1 1 2
> > +
> > +    * - __u32
> > +      - ``slice_len``
> > +      - Length (in bits) of the current slice data.
> > +    * - __u32
> > +      - ``slice_pos``
> > +      - Position (in bits) of the current slice data, relative to the
> > +        frame start.
> > +    * - __u16
> > +      - ``width``
> > +      - Width of the corresponding output frame for the current slice.
> > +    * - __u16
> > +      - ``height``
> > +      - Height of the corresponding output frame for the current slice=
.
> > +    * - __u8
> > +      - ``slice_type``
> > +      - Picture coding type for the frame covered by the current slice
> > +        (V4L2_MPEG2_SLICE_TYPE_I, V4L2_MPEG2_SLICE_TYPE_P or
> > +        V4L2_MPEG2_SLICE_PCT_B).
> > +    * - __u8
> > +      - ``f_code[2][2]``
> > +      - Motion vector codes.
> > +    * - __u8
> > +      - ``intra_dc_precision``
> > +      - Precision of Discrete Cosine transform (0: 8 bits precision,
> > +        1: 9 bits precision, 2: 10 bits precision, 11: 11 bits precisi=
on).
> > +    * - __u8
> > +      - ``picture_structure``
> > +      - Picture structure (1: interlaced top field,
> > +        2: interlaced bottom field, 3: progressive frame).
> > +    * - __u8
> > +      - ``top_field_first``
> > +      - If set to 1 and interlaced stream, top field is output first.
> > +    * - __u8
> > +      - ``frame_pred_frame_dct``
> > +      - If set to 1, only frame-DCT and frame prediction are used.
> > +    * - __u8
> > +      - ``concealment_motion_vectors``
> > +      -  If set to 1, motion vectors are coded for intra macroblocks.
> > +    * - __u8
> > +      - ``q_scale_type``
> > +      - This flag affects the inverse quantisation process.
>=20
> quantization
>=20
> The american spelling appears to be the standard in our documentation, so
> let's stick to that.

I see, that makes sense.

> > +    * - __u8
> > +      - ``intra_vlc_format``
> > +      - This flag affects the decoding of transform coefficient data.
> > +    * - __u8
> > +      - ``alternate_scan``
> > +      - This flag affects the decoding of transform coefficient data.
> > +    * - __u8
> > +      - ``backward_ref_index``
> > +      - Index for the V4L2 buffer to use as backward reference, used w=
ith
> > +        B-coded and P-coded frames.
> > +    * - __u8
> > +      - ``forward_ref_index``
> > +      - Index for the V4L2 buffer to use as forward reference, used wi=
th
> > +        P-coded frames.
> > +    * - :cspan:`2`
> > +
> > +``V4L2_CID_MPEG_VIDEO_MPEG2_QUANTIZATION (struct)``
> > +    Specifies quantization matrices for the associated MPEG-2 slice da=
ta.
> > +
> > +.. tabularcolumns:: |p{2.0cm}|p{4.0cm}|p{11.0cm}|
> > +
> > +.. c:type:: v4l2_ctrl_mpeg2_quantization
> > +
> > +.. cssclass:: longtable
> > +
> > +.. flat-table:: struct v4l2_ctrl_mpeg2_quantization
> > +    :header-rows:  0
> > +    :stub-columns: 0
> > +    :widths:       1 1 2
> > +
> > +    * - __u8
> > +      - ``load_intra_quantiser_matrix``
> > +      - One bit to indicate whether to load the intra quantiser matrix=
.
>=20
> So the MPEG-2 spec appears to follow the British spelling, so for consist=
ency
> with that spec we should stick to that for the field name.
>=20
> I'm not sure what is better in the description: stick to quantiser or cha=
nge
> it to the US quantizer. I think we should keep quantiser since it looks w=
eird
> otherwise.

Or I could just reformulate it to mention the ``intra_quantiser_matrix``
field directly, instead of breaking it down into words.

> > +    * - __u32
> > +      - ``load_non_intra_quantiser_matrix``
> > +      - One bit to indicate whether to load the non-intra quantiser ma=
trix.
> > +    * - __u32
> > +      - ``load_chroma_intra_quantiser_matrix``
> > +      - One bit to indicate whether to load the chroma intra quantiser=
 matrix,
> > +        only relevant for non-4:2:0 YUV formats.
> > +    * - __u32
> > +      - ``load_chroma_non_intra_quantiser_matrix``
> > +      - One bit to indicate whether to load the non-chroma intra quant=
iser
> > +        matrix, only relevant for non-4:2:0 YUV formats.
> > +    * - __u32
> > +      - ``intra_quantiser_matrix[64]``
> > +      - The intra quantiser matrix coefficients, in zigzag scanning or=
der.
> > +        It is relevant for both luma and chroma components, although i=
t can be
> > +        superseded by the chroma-specific matrix for non-4:2:0 YUV for=
mats.
> > +    * - __u32
> > +      - ``non_intra_quantiser_matrix[64]``
> > +      - The non-intra quantiser matrix coefficients, in zigzag scannin=
g order.
> > +        It is relevant for both luma and chroma components, although i=
t can be
> > +        superseded by the chroma-specific matrix for non-4:2:0 YUV for=
mats.
> > +    * - __u32
> > +      - ``chroma_intra_quantiser_matrix[64]``
> > +      - The intra quantiser matrix coefficients for the chroma YUV com=
ponent,
> > +        in zigzag scanning order. Only relevant for non-4:2:0 YUV form=
ats.
> > +    * - __u32
> > +      - ``chroma_non_intra_quantiser_matrix[64]``
> > +      - The non-intra quantiser matrix coefficients for the chroma YUV=
 component,
> > +        in zigzag scanning order. Only relevant for non-4:2:0 YUV form=
ats.
>=20
> According to the MPEG-2 spec (6.3.11) these are all unsigned 8 bit values=
, so why
> use __u32?

Woops, that was purely a mistake. It's all __u8 indeed.

> > +    * - :cspan:`2`
> > =20
> >  MFC 5.1 MPEG Controls
> >  ---------------------
> > diff --git a/Documentation/media/uapi/v4l/pixfmt-compressed.rst b/Docum=
entation/media/uapi/v4l/pixfmt-compressed.rst
> > index abec03937bb3..4e73f62b5163 100644
> > --- a/Documentation/media/uapi/v4l/pixfmt-compressed.rst
> > +++ b/Documentation/media/uapi/v4l/pixfmt-compressed.rst
> > @@ -60,6 +60,11 @@ Compressed Formats
> >        - ``V4L2_PIX_FMT_MPEG2``
> >        - 'MPG2'
> >        - MPEG2 video elementary stream.
> > +    * .. _V4L2-PIX-FMT-MPEG2-SLICE:
> > +
> > +      - ``V4L2_PIX_FMT_MPEG2_SLICE``
> > +      - 'MG2S'
> > +      - MPEG2 parsed slice data, as extracted from the MPEG2 bitstream=
.
> >      * .. _V4L2-PIX-FMT-MPEG4:
> > =20
> >        - ``V4L2_PIX_FMT_MPEG4``
> > diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-=
core/v4l2-ctrls.c
> > index 3610dce3a4f8..22483d894259 100644
> > --- a/drivers/media/v4l2-core/v4l2-ctrls.c
> > +++ b/drivers/media/v4l2-core/v4l2-ctrls.c
> > @@ -844,6 +844,8 @@ const char *v4l2_ctrl_get_name(u32 id)
> >  	case V4L2_CID_MPEG_VIDEO_MV_V_SEARCH_RANGE:		return "Vertical MV Sear=
ch Range";
> >  	case V4L2_CID_MPEG_VIDEO_REPEAT_SEQ_HEADER:		return "Repeat Sequence =
Header";
> >  	case V4L2_CID_MPEG_VIDEO_FORCE_KEY_FRAME:		return "Force Key Frame";
> > +	case V4L2_CID_MPEG_VIDEO_MPEG2_SLICE_PARAMS:		return "MPEG2 Slice Hea=
der";
> > +	case V4L2_CID_MPEG_VIDEO_MPEG2_QUANTIZATION:		return "MPEG2 Quantizat=
ion Matrices";
> > =20
> >  	/* VPX controls */
> >  	case V4L2_CID_MPEG_VIDEO_VPX_NUM_PARTITIONS:		return "VPX Number of P=
artitions";
> > @@ -1292,6 +1294,12 @@ void v4l2_ctrl_fill(u32 id, const char **name, e=
num v4l2_ctrl_type *type,
> >  	case V4L2_CID_RDS_TX_ALT_FREQS:
> >  		*type =3D V4L2_CTRL_TYPE_U32;
> >  		break;
> > +	case V4L2_CID_MPEG_VIDEO_MPEG2_SLICE_PARAMS:
> > +		*type =3D V4L2_CTRL_TYPE_MPEG2_SLICE_PARAMS;
> > +		break;
> > +	case V4L2_CID_MPEG_VIDEO_MPEG2_QUANTIZATION:
> > +		*type =3D V4L2_CTRL_TYPE_MPEG2_QUANTIZATION;
> > +		break;
> >  	default:
> >  		*type =3D V4L2_CTRL_TYPE_INTEGER;
> >  		break;
> > @@ -1550,6 +1558,7 @@ static void std_log(const struct v4l2_ctrl *ctrl)
> >  static int std_validate(const struct v4l2_ctrl *ctrl, u32 idx,
> >  			union v4l2_ctrl_ptr ptr)
> >  {
> > +	struct v4l2_ctrl_mpeg2_slice_params *p_mpeg2_slice_params;
> >  	size_t len;
> >  	u64 offset;
> >  	s64 val;
> > @@ -1612,6 +1621,45 @@ static int std_validate(const struct v4l2_ctrl *=
ctrl, u32 idx,
> >  			return -ERANGE;
> >  		return 0;
> > =20
> > +	case V4L2_CTRL_TYPE_MPEG2_SLICE_PARAMS:
> > +		p_mpeg2_slice_params =3D ptr.p;
> > +
> > +		switch (p_mpeg2_slice_params->intra_dc_precision) {
> > +		case 0: /* 8 bits */
> > +		case 1: /* 9 bits */
> > +		case 11: /* 11 bits */
> > +			break;
> > +		default:
> > +			return -EINVAL;
> > +		}
> > +
> > +		switch (p_mpeg2_slice_params->picture_structure) {
> > +		case 1: /* interlaced top field */
> > +		case 2: /* interlaced bottom field */
> > +		case 3: /* progressive */
> > +			break;
> > +		default:
> > +			return -EINVAL;
> > +		}
> > +
> > +		switch (p_mpeg2_slice_params->slice_type) {
> > +		case V4L2_MPEG2_SLICE_TYPE_I:
> > +		case V4L2_MPEG2_SLICE_TYPE_P:
> > +		case V4L2_MPEG2_SLICE_TYPE_B:
> > +			break;
> > +		default:
> > +			return -EINVAL;
> > +		}
> > +
> > +		if (p_mpeg2_slice_params->backward_ref_index > VIDEO_MAX_FRAME ||
> > +		    p_mpeg2_slice_params->forward_ref_index > VIDEO_MAX_FRAME)
>=20
> Should be >=3D

Noted, thanks.

> > +			return -EINVAL;
> > +
> > +		return 0;
> > +
> > +	case V4L2_CTRL_TYPE_MPEG2_QUANTIZATION:
> > +		return 0;
> > +
> >  	default:
> >  		return -EINVAL;
> >  	}
> > @@ -2186,6 +2234,12 @@ static struct v4l2_ctrl *v4l2_ctrl_new(struct v4=
l2_ctrl_handler *hdl,
> >  	case V4L2_CTRL_TYPE_U32:
> >  		elem_size =3D sizeof(u32);
> >  		break;
> > +	case V4L2_CTRL_TYPE_MPEG2_SLICE_PARAMS:
> > +		elem_size =3D sizeof(struct v4l2_ctrl_mpeg2_slice_params);
> > +		break;
> > +	case V4L2_CTRL_TYPE_MPEG2_QUANTIZATION:
> > +		elem_size =3D sizeof(struct v4l2_ctrl_mpeg2_quantization);
> > +		break;
> >  	default:
> >  		if (type < V4L2_CTRL_COMPOUND_TYPES)
> >  			elem_size =3D sizeof(s32);
> > diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-=
core/v4l2-ioctl.c
> > index 44fc0102221f..68e914b83a03 100644
> > --- a/drivers/media/v4l2-core/v4l2-ioctl.c
> > +++ b/drivers/media/v4l2-core/v4l2-ioctl.c
> > @@ -1304,6 +1304,7 @@ static void v4l_fill_fmtdesc(struct v4l2_fmtdesc =
*fmt)
> >  		case V4L2_PIX_FMT_H263:		descr =3D "H.263"; break;
> >  		case V4L2_PIX_FMT_MPEG1:	descr =3D "MPEG-1 ES"; break;
> >  		case V4L2_PIX_FMT_MPEG2:	descr =3D "MPEG-2 ES"; break;
> > +		case V4L2_PIX_FMT_MPEG2_SLICE:	descr =3D "MPEG-2 parsed slice data";=
 break;
>=20
> "MPEG-2 Parsed Slice Data"

Will do.

> >  		case V4L2_PIX_FMT_MPEG4:	descr =3D "MPEG-4 part 2 ES"; break;
> >  		case V4L2_PIX_FMT_XVID:		descr =3D "Xvid"; break;
> >  		case V4L2_PIX_FMT_VC1_ANNEX_G:	descr =3D "VC-1 (SMPTE 412M Annex G)"=
; break;
> > diff --git a/include/media/v4l2-ctrls.h b/include/media/v4l2-ctrls.h
> > index 34ee3167d7dd..83eff6f91ed2 100644
> > --- a/include/media/v4l2-ctrls.h
> > +++ b/include/media/v4l2-ctrls.h
> > @@ -35,13 +35,15 @@ struct poll_table_struct;
> > =20
> >  /**
> >   * union v4l2_ctrl_ptr - A pointer to a control value.
> > - * @p_s32:	Pointer to a 32-bit signed value.
> > - * @p_s64:	Pointer to a 64-bit signed value.
> > - * @p_u8:	Pointer to a 8-bit unsigned value.
> > - * @p_u16:	Pointer to a 16-bit unsigned value.
> > - * @p_u32:	Pointer to a 32-bit unsigned value.
> > - * @p_char:	Pointer to a string.
> > - * @p:		Pointer to a compound value.
> > + * @p_s32:			Pointer to a 32-bit signed value.
> > + * @p_s64:			Pointer to a 64-bit signed value.
> > + * @p_u8:			Pointer to a 8-bit unsigned value.
> > + * @p_u16:			Pointer to a 16-bit unsigned value.
> > + * @p_u32:			Pointer to a 32-bit unsigned value.
> > + * @p_char:			Pointer to a string.
> > + * @p_mpeg2_slice_params:	Pointer to a MPEG2 slice parameters structur=
e.
> > + * @p_mpeg2_quantization:	Pointer to a MPEG2 quantization data structu=
re.
> > + * @p:				Pointer to a compound value.
> >   */
> >  union v4l2_ctrl_ptr {
> >  	s32 *p_s32;
> > @@ -50,6 +52,8 @@ union v4l2_ctrl_ptr {
> >  	u16 *p_u16;
> >  	u32 *p_u32;
> >  	char *p_char;
> > +	struct v4l2_ctrl_mpeg2_slice_params *p_mpeg2_slice_params;
> > +	struct v4l2_ctrl_mpeg2_quantization *p_mpeg2_quantization;
> >  	void *p;
> >  };
> > =20
> > diff --git a/include/uapi/linux/v4l2-controls.h b/include/uapi/linux/v4=
l2-controls.h
> > index e4ee10ee917d..ce6de781037a 100644
> > --- a/include/uapi/linux/v4l2-controls.h
> > +++ b/include/uapi/linux/v4l2-controls.h
> > @@ -557,6 +557,9 @@ enum v4l2_mpeg_video_mpeg4_profile {
> >  };
> >  #define V4L2_CID_MPEG_VIDEO_MPEG4_QPEL		(V4L2_CID_MPEG_BASE+407)
> > =20
> > +#define V4L2_CID_MPEG_VIDEO_MPEG2_SLICE_PARAMS	(V4L2_CID_MPEG_BASE+450=
)
>=20
> I would insert this at V4L2_CID_MPEG_BASE+250
>=20
> That is close to the existing MPEG2 controls, which makes sense.

Agreed, will change for the next version.

> > +#define V4L2_CID_MPEG_VIDEO_MPEG2_QUANTIZATION	(V4L2_CID_MPEG_BASE+451=
)
>=20
> and this becomes +251 of course.
>=20
> > +
> >  /*  Control IDs for VP8 streams
> >   *  Although VP8 is not part of MPEG we add these controls to the MPEG=
 class
> >   *  as that class is already handling other video compression standard=
s
> > @@ -1092,4 +1095,44 @@ enum v4l2_detect_md_mode {
> >  #define V4L2_CID_DETECT_MD_THRESHOLD_GRID	(V4L2_CID_DETECT_CLASS_BASE =
+ 3)
> >  #define V4L2_CID_DETECT_MD_REGION_GRID		(V4L2_CID_DETECT_CLASS_BASE + =
4)
> > =20
> > +#define V4L2_MPEG2_SLICE_TYPE_I			1
> > +#define V4L2_MPEG2_SLICE_TYPE_P			2
> > +#define V4L2_MPEG2_SLICE_TYPE_B			3
> > +#define V4L2_MPEG2_SLICE_TYPE_D			4
> > +
> > +struct v4l2_ctrl_mpeg2_slice_params {
> > +	__u32	slice_len;
> > +	__u32	slice_pos;
> > +
> > +	__u16	width;
> > +	__u16	height;
> > +
> > +	__u8	slice_type;
> > +	__u8	f_code[2][2];
> > +
> > +	__u8	intra_dc_precision;
> > +	__u8	picture_structure;
> > +	__u8	top_field_first;
> > +	__u8	frame_pred_frame_dct;
> > +	__u8	concealment_motion_vectors;
> > +	__u8	q_scale_type;
> > +	__u8	intra_vlc_format;
> > +	__u8	alternate_scan;
> > +
> > +	__u8	backward_ref_index;
> > +	__u8	forward_ref_index;
>=20
> How certain are you that this is all that's needed? Should we add
> a reserved field?

There is a limited number of parameters that the bitstream offers and
only a subset of these parameters affects the decoding process.

VAAPI defines such a subset, so we used it as a base to figure out what
fields from the bitstream are involved. I also went through the
specification in detail to check whether we missed some relevant fields
(and I found a few while preparing the next revision of this series).

Still, I doubt that the result is perfect and it's hard to know whether
a future decoder driver will require some specific field not required by
Cedrus and that we missed, so adding reserved fields seems like the
safest approach.

On the other hand, I think that specific extensions should be added as
separate controls, like it's done for the quantization matrices, so this
should limit the relevant number of reserved fields to add. Something
like 4-6 __u8 values seems reasonable IMO.

> > +};
> > +
> > +struct v4l2_ctrl_mpeg2_quantization {
> > +	__u8	load_intra_quantiser_matrix : 1;
> > +	__u8	load_non_intra_quantiser_matrix : 1;
> > +	__u8	load_chroma_intra_quantiser_matrix : 1;
> > +	__u8	load_chroma_non_intra_quantiser_matrix : 1;
>=20
> I wouldn't use bitfields here. It doesn't add anything.

Okay, then I'll drop bitfields from future patches as well.

Cheers,

Paul

> > +
> > +	__u8	intra_quantiser_matrix[64];
> > +	__u8	non_intra_quantiser_matrix[64];
> > +	__u8	chroma_intra_quantiser_matrix[64];
> > +	__u8	chroma_non_intra_quantiser_matrix[64];
> > +};
> > +
> >  #endif
> > diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videod=
ev2.h
> > index 1f6c4b52baae..d171361ed9b3 100644
> > --- a/include/uapi/linux/videodev2.h
> > +++ b/include/uapi/linux/videodev2.h
> > @@ -629,6 +629,7 @@ struct v4l2_pix_format {
> >  #define V4L2_PIX_FMT_H263     v4l2_fourcc('H', '2', '6', '3') /* H263 =
         */
> >  #define V4L2_PIX_FMT_MPEG1    v4l2_fourcc('M', 'P', 'G', '1') /* MPEG-=
1 ES     */
> >  #define V4L2_PIX_FMT_MPEG2    v4l2_fourcc('M', 'P', 'G', '2') /* MPEG-=
2 ES     */
> > +#define V4L2_PIX_FMT_MPEG2_SLICE v4l2_fourcc('M', 'G', '2', 'S') /* MP=
EG-2 parsed slice data */
> >  #define V4L2_PIX_FMT_MPEG4    v4l2_fourcc('M', 'P', 'G', '4') /* MPEG-=
4 part 2 ES */
> >  #define V4L2_PIX_FMT_XVID     v4l2_fourcc('X', 'V', 'I', 'D') /* Xvid =
          */
> >  #define V4L2_PIX_FMT_VC1_ANNEX_G v4l2_fourcc('V', 'C', '1', 'G') /* SM=
PTE 421M Annex G compliant stream */
> > @@ -1587,6 +1588,8 @@ struct v4l2_ext_control {
> >  		__u8 __user *p_u8;
> >  		__u16 __user *p_u16;
> >  		__u32 __user *p_u32;
> > +		struct v4l2_ctrl_mpeg2_slice_params __user *p_mpeg2_slice_params;
> > +		struct v4l2_ctrl_mpeg2_quantization __user *p_mpeg2_quantization;
> >  		void __user *ptr;
> >  	};
> >  } __attribute__ ((packed));
> > @@ -1632,6 +1635,8 @@ enum v4l2_ctrl_type {
> >  	V4L2_CTRL_TYPE_U8	     =3D 0x0100,
> >  	V4L2_CTRL_TYPE_U16	     =3D 0x0101,
> >  	V4L2_CTRL_TYPE_U32	     =3D 0x0102,
> > +	V4L2_CTRL_TYPE_MPEG2_SLICE_PARAMS =3D 0x0103,
> > +	V4L2_CTRL_TYPE_MPEG2_QUANTIZATION =3D 0x0104,
> >  };
> > =20
> >=20

> Regards,
>=20
> 	Hans
--=20
Paul Kocialkowski, Bootlin (formerly Free Electrons)
Embedded Linux and kernel engineering
https://bootlin.com

--=-D31xMAXsK/g9Q3eW+EJt
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEJZpWjZeIetVBefti3cLmz3+fv9EFAltq2qUACgkQ3cLmz3+f
v9EfUgf7B8T73oWHPJUPAweoLWOZfNrqlhsdLvxvpp4s9LwcOgsR19V2IVGUfXGZ
9tKd9IaQ8Lketv0XEbSGl/JgWPfFJwYptdeBXWSo4PKMPmbnttsH9e9R6gMiZ1vS
6QDnQJhASji9zPo2YZRjN1kGgMGdHCjSOyty600CmWD/PsxLXTAqPWBH/P3xHHmS
AJ+xgCRsXFXbbSAqhM7JEfwSfAYt45UcFbeB/VWNP4Tp11ZNkyAOTjUxo/CXQ9Ie
JFWgoRl76JvIBDpHLCiGOxYWSviQ/dOroYzVHZo28A931bYFVRWSHMzaR0ocmaB+
d4p3DUcEG8tQFgkfJ0kLMf7XqYs3bA==
=NO3U
-----END PGP SIGNATURE-----

--=-D31xMAXsK/g9Q3eW+EJt--
