Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:53486 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752233AbeEGNyW (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 7 May 2018 09:54:22 -0400
Message-ID: <cdbf4fd2f97f333d92c30086c85407f2aa246834.camel@bootlin.com>
Subject: Re: [PATCH v3 08/14] media: v4l: Add definitions for MPEG2 frame
 format and header metadata
From: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
To: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Chen-Yu Tsai <wens@csie.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S . Miller" <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Ramesh Shanmugasundaram <ramesh.shanmugasundaram@bp.renesas.com>,
        Yannick Fertre <yannick.fertre@st.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Hugues Fruchet <hugues.fruchet@st.com>,
        Alexandre Courbot <gnurou@gmail.com>,
        Florent Revest <florent.revest@free-electrons.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>,
        Smitha T Murthy <smitha.t@samsung.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Randy Li <ayaka@soulik.info>
Date: Mon, 07 May 2018 15:52:59 +0200
In-Reply-To: <1bd7af5a-c8d5-220c-8471-545eb1835882@xs4all.nl>
References: <20180507124500.20434-1-paul.kocialkowski@bootlin.com>
         <20180507124500.20434-9-paul.kocialkowski@bootlin.com>
         <1bd7af5a-c8d5-220c-8471-545eb1835882@xs4all.nl>
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-9JzsS3pAsZhghBkP4dw0"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-9JzsS3pAsZhghBkP4dw0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Hans,

On Mon, 2018-05-07 at 15:49 +0200, Hans Verkuil wrote:
> On 07/05/18 14:44, Paul Kocialkowski wrote:
> > From: Florent Revest <florent.revest@free-electrons.com>
> >=20
> > Stateless video decoding engines require both the MPEG slices and
> > associated metadata from the video stream in order to decode frames.
> >=20
> > This introduces definitions for a new pixel format, describing
> > buffers
> > with MPEG2 slice data, as well as a control structure for passing
> > the
> > frame header (metadata) to drivers.

Thanks for the review!

I should have made it clear that this patch has not seen any improvement
between v2 and v3. Cleaning up and documenting the MPEG2 headers is
still in the tasks list (presented in the cover letter), as well as the
MB32 NV12 format.

> > Signed-off-by: Florent Revest <florent.revest@free-electrons.com>
> > Signed-off-by: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
> > ---
> >  drivers/media/v4l2-core/v4l2-ctrls.c | 10 ++++++++++
> >  drivers/media/v4l2-core/v4l2-ioctl.c |  1 +
> >  include/uapi/linux/v4l2-controls.h   | 26
> > ++++++++++++++++++++++++++
> >  include/uapi/linux/videodev2.h       |  3 +++
> >  4 files changed, 40 insertions(+)
> >=20
> > diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c
> > b/drivers/media/v4l2-core/v4l2-ctrls.c
> > index df58a23eb731..cdf860c8e3d8 100644
> > --- a/drivers/media/v4l2-core/v4l2-ctrls.c
> > +++ b/drivers/media/v4l2-core/v4l2-ctrls.c
> > @@ -826,6 +826,7 @@ const char *v4l2_ctrl_get_name(u32 id)
> >  	case V4L2_CID_MPEG_VIDEO_MV_V_SEARCH_RANGE:	=09
> > return "Vertical MV Search Range";
> >  	case V4L2_CID_MPEG_VIDEO_REPEAT_SEQ_HEADER:	=09
> > return "Repeat Sequence Header";
> >  	case V4L2_CID_MPEG_VIDEO_FORCE_KEY_FRAME:		re
> > turn "Force Key Frame";
> > +	case V4L2_CID_MPEG_VIDEO_MPEG2_FRAME_HDR:		re
> > turn "MPEG2 Frame Header";
>=20
> This compound control needs to be documented in the V4l2 spec.
>=20
> > =20
> >  	/* VPX controls */
> >  	case V4L2_CID_MPEG_VIDEO_VPX_NUM_PARTITIONS:	=09
> > return "VPX Number of Partitions";
> > @@ -1271,6 +1272,9 @@ void v4l2_ctrl_fill(u32 id, const char **name,
> > enum v4l2_ctrl_type *type,
> >  	case V4L2_CID_RDS_TX_ALT_FREQS:
> >  		*type =3D V4L2_CTRL_TYPE_U32;
> >  		break;
> > +	case V4L2_CID_MPEG_VIDEO_MPEG2_FRAME_HDR:
> > +		*type =3D V4L2_CTRL_TYPE_MPEG2_FRAME_HDR;
> > +		break;
> >  	default:
> >  		*type =3D V4L2_CTRL_TYPE_INTEGER;
> >  		break;
> > @@ -1591,6 +1595,9 @@ static int std_validate(const struct v4l2_ctrl
> > *ctrl, u32 idx,
> >  			return -ERANGE;
> >  		return 0;
> > =20
> > +	case V4L2_CTRL_TYPE_MPEG2_FRAME_HDR:
> > +		return 0;
> > +
> >  	default:
> >  		return -EINVAL;
> >  	}
> > @@ -2165,6 +2172,9 @@ static struct v4l2_ctrl *v4l2_ctrl_new(struct
> > v4l2_ctrl_handler *hdl,
> >  	case V4L2_CTRL_TYPE_U32:
> >  		elem_size =3D sizeof(u32);
> >  		break;
> > +	case V4L2_CTRL_TYPE_MPEG2_FRAME_HDR:
> > +		elem_size =3D sizeof(struct
> > v4l2_ctrl_mpeg2_frame_hdr);
> > +		break;
> >  	default:
> >  		if (type < V4L2_CTRL_COMPOUND_TYPES)
> >  			elem_size =3D sizeof(s32);
> > diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c
> > b/drivers/media/v4l2-core/v4l2-ioctl.c
> > index 561a1fe3160b..38d318c47c55 100644
> > --- a/drivers/media/v4l2-core/v4l2-ioctl.c
> > +++ b/drivers/media/v4l2-core/v4l2-ioctl.c
> > @@ -1274,6 +1274,7 @@ static void v4l_fill_fmtdesc(struct
> > v4l2_fmtdesc *fmt)
> >  		case V4L2_PIX_FMT_VP8:		descr =3D
> > "VP8"; break;
> >  		case V4L2_PIX_FMT_VP9:		descr =3D
> > "VP9"; break;
> >  		case V4L2_PIX_FMT_HEVC:		descr =3D
> > "HEVC"; break; /* aka H.265 */
> > +		case V4L2_PIX_FMT_MPEG2_FRAME:	descr =3D
> > "MPEG2 Frame"; break;
>=20
> Needs to be documented in the spec.
>=20
> >  		case V4L2_PIX_FMT_CPIA1:	descr =3D "GSPCA CPiA
> > YUV"; break;
> >  		case V4L2_PIX_FMT_WNVA:		descr =3D
> > "WNVA"; break;
> >  		case V4L2_PIX_FMT_SN9C10X:	descr =3D "GSPCA
> > SN9C10X"; break;
> > diff --git a/include/uapi/linux/v4l2-controls.h
> > b/include/uapi/linux/v4l2-controls.h
> > index 8d473c979b61..23da8bfa7e6f 100644
> > --- a/include/uapi/linux/v4l2-controls.h
> > +++ b/include/uapi/linux/v4l2-controls.h
> > @@ -557,6 +557,8 @@ enum v4l2_mpeg_video_mpeg4_profile {
> >  };
> >  #define V4L2_CID_MPEG_VIDEO_MPEG4_QPEL		(V4L2_CID_MPE
> > G_BASE+407)
> > =20
> > +#define
> > V4L2_CID_MPEG_VIDEO_MPEG2_FRAME_HDR     (V4L2_CID_MPEG_BASE+450)
> > +
> >  /*  Control IDs for VP8 streams
> >   *  Although VP8 is not part of MPEG we add these controls to the
> > MPEG class
> >   *  as that class is already handling other video compression
> > standards
> > @@ -1076,4 +1078,28 @@ enum v4l2_detect_md_mode {
> >  #define V4L2_CID_DETECT_MD_THRESHOLD_GRID	(V4L2_CID_DETECT_C
> > LASS_BASE + 3)
> >  #define V4L2_CID_DETECT_MD_REGION_GRID		(V4L2_CID_DET
> > ECT_CLASS_BASE + 4)
> > =20
> > +struct v4l2_ctrl_mpeg2_frame_hdr {
> > +	__u32 slice_len;
> > +	__u32 slice_pos;
> > +	enum { MPEG1, MPEG2 } type;
>=20
> Still an enum?
>
> > +
> > +	__u16 width;
> > +	__u16 height;
> > +
> > +	enum { PCT_I =3D 1, PCT_P, PCT_B, PCT_D }
> > picture_coding_type;
> > +	__u8 f_code[2][2];
> > +
> > +	__u8 intra_dc_precision;
> > +	__u8 picture_structure;
> > +	__u8 top_field_first;
> > +	__u8 frame_pred_frame_dct;
> > +	__u8 concealment_motion_vectors;
> > +	__u8 q_scale_type;
> > +	__u8 intra_vlc_format;
> > +	__u8 alternate_scan;
> > +
> > +	__u8 backward_ref_index;
> > +	__u8 forward_ref_index;
> > +};
> > +
> >  #endif
> > diff --git a/include/uapi/linux/videodev2.h
> > b/include/uapi/linux/videodev2.h
> > index 1f6c4b52baae..d8f9b59d90d7 100644
> > --- a/include/uapi/linux/videodev2.h
> > +++ b/include/uapi/linux/videodev2.h
> > @@ -636,6 +636,7 @@ struct v4l2_pix_format {
> >  #define V4L2_PIX_FMT_VP8      v4l2_fourcc('V', 'P', '8', '0') /*
> > VP8 */
> >  #define V4L2_PIX_FMT_VP9      v4l2_fourcc('V', 'P', '9', '0') /*
> > VP9 */
> >  #define V4L2_PIX_FMT_HEVC     v4l2_fourcc('H', 'E', 'V', 'C') /*
> > HEVC aka H.265 */
> > +#define V4L2_PIX_FMT_MPEG2_FRAME v4l2_fourcc('M', 'G', '2', 'F') /*
> > MPEG2 frame */
> > =20
> >  /*  Vendor-specific formats   */
> >  #define V4L2_PIX_FMT_CPIA1    v4l2_fourcc('C', 'P', 'I', 'A') /*
> > cpia1 YUV */
> > @@ -1587,6 +1588,7 @@ struct v4l2_ext_control {
> >  		__u8 __user *p_u8;
> >  		__u16 __user *p_u16;
> >  		__u32 __user *p_u32;
> > +		struct v4l2_ctrl_mpeg2_frame_hdr __user
> > *p_mpeg2_frame_hdr;
> >  		void __user *ptr;
> >  	};
> >  } __attribute__ ((packed));
> > @@ -1632,6 +1634,7 @@ enum v4l2_ctrl_type {
> >  	V4L2_CTRL_TYPE_U8	     =3D 0x0100,
> >  	V4L2_CTRL_TYPE_U16	     =3D 0x0101,
> >  	V4L2_CTRL_TYPE_U32	     =3D 0x0102,
> > +	V4L2_CTRL_TYPE_MPEG2_FRAME_HDR =3D 0x0109,
> >  };
> > =20
> >  /*  Used in the VIDIOC_QUERYCTRL ioctl for querying controls */
> >=20
>=20
> Regards,
>=20
> 	Hans
--=20
Paul Kocialkowski, Bootlin (formerly Free Electrons)
Embedded Linux and kernel engineering
https://bootlin.com
--=-9JzsS3pAsZhghBkP4dw0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQEyBAABCAAdFiEEJZpWjZeIetVBefti3cLmz3+fv9EFAlrwWjsACgkQ3cLmz3+f
v9Gyrwf3V5yvxv/l2Da3foXw3I091oCdd5cMbCtIxIZqYK6TanHcbN1wBS8aQ5fE
io70ljBZ60sNV886MA32wGffFqwjA8UDflFdfZcfEnL0aBRZCgwfcr3Hf3jeId2w
UDTntqJhDGzkzQ45wMSLrEQgOt3AKx1iJZkx264QUDrMJkFzrTl5JKI4r9UgJ8g6
bIFGIN6PBAxsJm3Eb+ZdvL8xgbESm1a2s0UQy4bQA8VgE/BS8z1qn9IzDYFUu/gf
jBdtxuE0EG+VEJ8Auiv4lBWMagvmcvwtBmcV/p1DGG0i7PceEOFRCpxIcb54a7Qg
790X4VT1XAkIr0hrIsi38SiQjTbr
=3r+H
-----END PGP SIGNATURE-----

--=-9JzsS3pAsZhghBkP4dw0--
