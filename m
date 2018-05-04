Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:53002 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751326AbeEDIuX (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 4 May 2018 04:50:23 -0400
Message-ID: <32d299141f48e0faa0c6d8624d365b7958609023.camel@bootlin.com>
Subject: Re: [PATCH v2 05/10] media: v4l: Add definitions for MPEG2 frame
 format and header metadata
From: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
To: linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com
Cc: Hugues FRUCHET <hugues.fruchet@st.com>,
        Randy Li <ayaka@soulik.info>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Chen-Yu Tsai <wens@csie.org>, Pawel Osciak <pawel@osciak.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Arnd Bergmann <arnd@arndb.de>,
        Alexandre Courbot <acourbot@chromium.org>,
        Tomasz Figa <tfiga@chromium.org>
Date: Fri, 04 May 2018 10:48:34 +0200
In-Reply-To: <20180419154536.17846-1-paul.kocialkowski@bootlin.com>
References: <20180419154124.17512-1-paul.kocialkowski@bootlin.com>
         <20180419154536.17846-1-paul.kocialkowski@bootlin.com>
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-uY/2+HKVE4b4GlzRi2oE"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-uY/2+HKVE4b4GlzRi2oE
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2018-04-19 at 17:45 +0200, Paul Kocialkowski wrote:
> Stateless video decoding engines require both the MPEG slices and
> associated metadata from the video stream in order to decode frames.
>=20
> This introduces definitions for a new pixel format, describing buffers
> with MPEG2 slice data, as well as a control structure for passing the
> frame header (metadata) to drivers.

While working on this, I came accross Hugues Fruchet's series that also
adds similar definitions for parsed MPEG2 metadata:
https://patchwork.kernel.org/patch/9704707/

Since that version made it to a v6, I will take the time to read the
discussion and see what needs to be changed in my proposal, so that we
can avoid discussing the same points over a year later.

This will most likely not make it to the next revision of the driver
series, so I will keep the format/controls definitions in their v2 state
(despite all the useful comments received) and take the time to properly
rework things in a future revision.

Cheers,

Paul

> Signed-off-by: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
> Signed-off-by: Florent Revest <florent.revest@free-electrons.com>
> ---
>  drivers/media/v4l2-core/v4l2-ctrls.c | 10 ++++++++++
>  drivers/media/v4l2-core/v4l2-ioctl.c |  1 +
>  include/uapi/linux/v4l2-controls.h   | 26 ++++++++++++++++++++++++++
>  include/uapi/linux/videodev2.h       |  3 +++
>  4 files changed, 40 insertions(+)
>=20
> diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c
> b/drivers/media/v4l2-core/v4l2-ctrls.c
> index ba05a8b9a095..fcdc12b9a9e0 100644
> --- a/drivers/media/v4l2-core/v4l2-ctrls.c
> +++ b/drivers/media/v4l2-core/v4l2-ctrls.c
> @@ -761,6 +761,7 @@ const char *v4l2_ctrl_get_name(u32 id)
>  	case V4L2_CID_MPEG_VIDEO_MV_V_SEARCH_RANGE:		re
> turn "Vertical MV Search Range";
>  	case V4L2_CID_MPEG_VIDEO_REPEAT_SEQ_HEADER:		re
> turn "Repeat Sequence Header";
>  	case V4L2_CID_MPEG_VIDEO_FORCE_KEY_FRAME:		retu
> rn "Force Key Frame";
> +	case V4L2_CID_MPEG_VIDEO_MPEG2_FRAME_HDR:		retu
> rn "MPEG2 Frame Header";
> =20
>  	/* VPX controls */
>  	case V4L2_CID_MPEG_VIDEO_VPX_NUM_PARTITIONS:		r
> eturn "VPX Number of Partitions";
> @@ -1152,6 +1153,9 @@ void v4l2_ctrl_fill(u32 id, const char **name,
> enum v4l2_ctrl_type *type,
>  	case V4L2_CID_RDS_TX_ALT_FREQS:
>  		*type =3D V4L2_CTRL_TYPE_U32;
>  		break;
> +	case V4L2_CID_MPEG_VIDEO_MPEG2_FRAME_HDR:
> +		*type =3D V4L2_CTRL_TYPE_MPEG2_FRAME_HDR;
> +		break;
>  	default:
>  		*type =3D V4L2_CTRL_TYPE_INTEGER;
>  		break;
> @@ -1472,6 +1476,9 @@ static int std_validate(const struct v4l2_ctrl
> *ctrl, u32 idx,
>  			return -ERANGE;
>  		return 0;
> =20
> +	case V4L2_CTRL_TYPE_MPEG2_FRAME_HDR:
> +		return 0;
> +
>  	default:
>  		return -EINVAL;
>  	}
> @@ -2046,6 +2053,9 @@ static struct v4l2_ctrl *v4l2_ctrl_new(struct
> v4l2_ctrl_handler *hdl,
>  	case V4L2_CTRL_TYPE_U32:
>  		elem_size =3D sizeof(u32);
>  		break;
> +	case V4L2_CTRL_TYPE_MPEG2_FRAME_HDR:
> +		elem_size =3D sizeof(struct v4l2_ctrl_mpeg2_frame_hdr);
> +		break;
>  	default:
>  		if (type < V4L2_CTRL_COMPOUND_TYPES)
>  			elem_size =3D sizeof(s32);
> diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c
> b/drivers/media/v4l2-core/v4l2-ioctl.c
> index 468c3c65362d..8070203da5d2 100644
> --- a/drivers/media/v4l2-core/v4l2-ioctl.c
> +++ b/drivers/media/v4l2-core/v4l2-ioctl.c
> @@ -1273,6 +1273,7 @@ static void v4l_fill_fmtdesc(struct v4l2_fmtdesc
> *fmt)
>  		case V4L2_PIX_FMT_VC1_ANNEX_L:	descr =3D "VC-1
> (SMPTE 412M Annex L)"; break;
>  		case V4L2_PIX_FMT_VP8:		descr =3D "VP8";
> break;
>  		case V4L2_PIX_FMT_VP9:		descr =3D "VP9";
> break;
> +		case V4L2_PIX_FMT_MPEG2_FRAME:	descr =3D "MPEG2
> Frame"; break;
>  		case V4L2_PIX_FMT_CPIA1:	descr =3D "GSPCA CPiA
> YUV"; break;
>  		case V4L2_PIX_FMT_WNVA:		descr =3D
> "WNVA"; break;
>  		case V4L2_PIX_FMT_SN9C10X:	descr =3D "GSPCA
> SN9C10X"; break;
> diff --git a/include/uapi/linux/v4l2-controls.h
> b/include/uapi/linux/v4l2-controls.h
> index cbbb750d87d1..8431b2a540c7 100644
> --- a/include/uapi/linux/v4l2-controls.h
> +++ b/include/uapi/linux/v4l2-controls.h
> @@ -557,6 +557,8 @@ enum v4l2_mpeg_video_mpeg4_profile {
>  };
>  #define V4L2_CID_MPEG_VIDEO_MPEG4_QPEL		(V4L2_CID_MPEG_
> BASE+407)
> =20
> +#define
> V4L2_CID_MPEG_VIDEO_MPEG2_FRAME_HDR     (V4L2_CID_MPEG_BASE+450)
> +
>  /*  Control IDs for VP8 streams
>   *  Although VP8 is not part of MPEG we add these controls to the
> MPEG class
>   *  as that class is already handling other video compression
> standards
> @@ -985,4 +987,28 @@ enum v4l2_detect_md_mode {
>  #define V4L2_CID_DETECT_MD_THRESHOLD_GRID	(V4L2_CID_DETECT_CLA
> SS_BASE + 3)
>  #define V4L2_CID_DETECT_MD_REGION_GRID		(V4L2_CID_DETEC
> T_CLASS_BASE + 4)
> =20
> +struct v4l2_ctrl_mpeg2_frame_hdr {
> +	__u32 slice_len;
> +	__u32 slice_pos;
> +	enum { MPEG1, MPEG2 } type;
> +
> +	__u16 width;
> +	__u16 height;
> +
> +	enum { PCT_I =3D 1, PCT_P, PCT_B, PCT_D } picture_coding_type;
> +	__u8 f_code[2][2];
> +
> +	__u8 intra_dc_precision;
> +	__u8 picture_structure;
> +	__u8 top_field_first;
> +	__u8 frame_pred_frame_dct;
> +	__u8 concealment_motion_vectors;
> +	__u8 q_scale_type;
> +	__u8 intra_vlc_format;
> +	__u8 alternate_scan;
> +
> +	__u8 backward_ref_index;
> +	__u8 forward_ref_index;
> +};
> +
>  #endif
> diff --git a/include/uapi/linux/videodev2.h
> b/include/uapi/linux/videodev2.h
> index 31b5728b56e9..4b8336f7bcf0 100644
> --- a/include/uapi/linux/videodev2.h
> +++ b/include/uapi/linux/videodev2.h
> @@ -635,6 +635,7 @@ struct v4l2_pix_format {
>  #define V4L2_PIX_FMT_VC1_ANNEX_L v4l2_fourcc('V', 'C', '1', 'L') /*
> SMPTE 421M Annex L compliant stream */
>  #define V4L2_PIX_FMT_VP8      v4l2_fourcc('V', 'P', '8', '0') /* VP8
> */
>  #define V4L2_PIX_FMT_VP9      v4l2_fourcc('V', 'P', '9', '0') /* VP9
> */
> +#define V4L2_PIX_FMT_MPEG2_FRAME v4l2_fourcc('M', 'G', '2', 'F') /*
> MPEG2 frame */
> =20
>  /*  Vendor-specific formats   */
>  #define V4L2_PIX_FMT_CPIA1    v4l2_fourcc('C', 'P', 'I', 'A') /*
> cpia1 YUV */
> @@ -1586,6 +1587,7 @@ struct v4l2_ext_control {
>  		__u8 __user *p_u8;
>  		__u16 __user *p_u16;
>  		__u32 __user *p_u32;
> +		struct v4l2_ctrl_mpeg2_frame_hdr __user
> *p_mpeg2_frame_hdr;
>  		void __user *ptr;
>  	};
>  } __attribute__ ((packed));
> @@ -1631,6 +1633,7 @@ enum v4l2_ctrl_type {
>  	V4L2_CTRL_TYPE_U8	     =3D 0x0100,
>  	V4L2_CTRL_TYPE_U16	     =3D 0x0101,
>  	V4L2_CTRL_TYPE_U32	     =3D 0x0102,
> +	V4L2_CTRL_TYPE_MPEG2_FRAME_HDR =3D 0x0109,
>  };
> =20
>  /*  Used in the VIDIOC_QUERYCTRL ioctl for querying controls */
--=20
Paul Kocialkowski, Bootlin (formerly Free Electrons)
Embedded Linux and kernel engineering
https://bootlin.com
--=-uY/2+HKVE4b4GlzRi2oE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEJZpWjZeIetVBefti3cLmz3+fv9EFAlrsHmIACgkQ3cLmz3+f
v9HvnAgAlh40WECUrElnBUfXxDgNSw1qqMVmT+qdIAmSzptbkfv2tsFi9CF5+Q3B
01ftOtD+wf75oJ8TnbobO5wXjkNdUMNktb2KIKBjipTwg4BlxhQD0MSWv/Q1xW5s
zXHWhhOmJ6A2WHwU5FYV6hVKgqAj1mZaVwxEVXsPoh4JxAF1q/c7JnNNOmnD71fk
MwiXFgN6QeOI1utmJ1VutlIsCyO5e7eeau227fq3K8kB8kjkdIVy3A/0nZrwQA2V
Mvegb4bS66fhI+yH7Gy5ctnxFhe5orlBisXphUNXWohSoPjbj9X1/rcV9wm1xaaD
69fmDrb3falXyqr586GopFSgHBs1ig==
=24yV
-----END PGP SIGNATURE-----

--=-uY/2+HKVE4b4GlzRi2oE--
