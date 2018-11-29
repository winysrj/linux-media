Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga17.intel.com ([192.55.52.151]:18831 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726393AbeK3KNd (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 30 Nov 2018 05:13:33 -0500
From: "Zhi, Yong" <yong.zhi@intel.com>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "tfiga@chromium.org" <tfiga@chromium.org>,
        "mchehab@kernel.org" <mchehab@kernel.org>,
        "hans.verkuil@cisco.com" <hans.verkuil@cisco.com>,
        "laurent.pinchart@ideasonboard.com"
        <laurent.pinchart@ideasonboard.com>,
        "Mani, Rajmohan" <rajmohan.mani@intel.com>,
        "Zheng, Jian Xu" <jian.xu.zheng@intel.com>,
        "Hu, Jerry W" <jerry.w.hu@intel.com>,
        "Toivonen, Tuukka" <tuukka.toivonen@intel.com>,
        "Qiu, Tian Shu" <tian.shu.qiu@intel.com>,
        "Cao, Bingbu" <bingbu.cao@intel.com>,
        "Li, Chao C" <chao.c.li@intel.com>
Subject: RE: [PATCH v7 03/16] v4l: Add Intel IPU3 meta data uAPI
Date: Thu, 29 Nov 2018 23:06:23 +0000
Message-ID: <C193D76D23A22742993887E6D207B54D3DB335C2@ORSMSX106.amr.corp.intel.com>
References: <1540851790-1777-1-git-send-email-yong.zhi@intel.com>
 <1540851790-1777-4-git-send-email-yong.zhi@intel.com>
 <20181102130237.yotr2y7ddrrzqphn@paasikivi.fi.intel.com>
 <C193D76D23A22742993887E6D207B54D3DB3111C@ORSMSX106.amr.corp.intel.com>
 <20181129224548.qwbkau6suipt2veq@kekkonen.localdomain>
In-Reply-To: <20181129224548.qwbkau6suipt2veq@kekkonen.localdomain>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi, Sakari,

> -----Original Message-----
> From: Sakari Ailus [mailto:sakari.ailus@linux.intel.com]
> Sent: Thursday, November 29, 2018 4:46 PM
> To: Zhi, Yong <yong.zhi@intel.com>
> Cc: linux-media@vger.kernel.org; tfiga@chromium.org;
> mchehab@kernel.org; hans.verkuil@cisco.com;
> laurent.pinchart@ideasonboard.com; Mani, Rajmohan
> <rajmohan.mani@intel.com>; Zheng, Jian Xu <jian.xu.zheng@intel.com>; Hu,
> Jerry W <jerry.w.hu@intel.com>; Toivonen, Tuukka
> <tuukka.toivonen@intel.com>; Qiu, Tian Shu <tian.shu.qiu@intel.com>; Cao,
> Bingbu <bingbu.cao@intel.com>; Li, Chao C <chao.c.li@intel.com>
> Subject: Re: [PATCH v7 03/16] v4l: Add Intel IPU3 meta data uAPI
> 
> Hi Yong,
> 
> On Fri, Nov 16, 2018 at 10:37:00PM +0000, Zhi, Yong wrote:
> ...
> > > > +/**
> > > > + * struct ipu3_uapi_shd_grid_config - Bayer shading(darkening)
> > > > +correction
> > > > + *
> > > > + * @width:	Grid horizontal dimensions, u8, [8, 128], default 73
> > > > + * @height:	Grid vertical dimensions, u8, [8, 128], default 56
> > > > + * @block_width_log2:	Log2 of the width of the grid cell in pixel
> > > count
> > > > + *			u4, [0, 15], default value 5.
> > > > + * @__reserved0:	reserved
> > > > + * @block_height_log2:	Log2 of the height of the grid cell in pixel
> > > count
> > > > + *			u4, [0, 15], default value 6.
> > > > + * @__reserved1:	reserved
> > > > + * @grid_height_per_slice:	SHD_MAX_CELLS_PER_SET/width.
> > > > + *				(with SHD_MAX_CELLS_PER_SET =
> 146).
> > > > + * @x_start:	X value of top left corner of sensor relative to ROI
> > > > + *		u12, [-4096, 0]. default 0, only negative values.
> > > > + * @y_start:	Y value of top left corner of sensor relative to ROI
> > > > + *		u12, [-4096, 0]. default 0, only negative values.
> > >
> > > I suppose u12 is incorrect here, if the value is signed --- and
> > > negative (sign bit) if not 0?
> > >
> >
> > The value will be written to 13 bit register, should use s12.0.
> 
> If you have s12, that means the most significant bit is the sign bit. So if the
> smallest value is -4096, you'd need s13.
> 
> But where is the sign bit, i.e. is this either s13 or s16?
> 

The notation of s12.0 means 13 bit with fraction bit as 0 right? 

> >
> > > > + */
> > > > +struct ipu3_uapi_shd_grid_config {
> > > > +	/* reg 0 */
> > > > +	__u8 width;
> > > > +	__u8 height;
> > > > +	__u8 block_width_log2:3;
> > > > +	__u8 __reserved0:1;
> > > > +	__u8 block_height_log2:3;
> > > > +	__u8 __reserved1:1;
> > > > +	__u8 grid_height_per_slice;
> > > > +	/* reg 1 */
> > > > +	__s16 x_start;
> > > > +	__s16 y_start;
> > > > +} __packed;
> 
> ...
> 
> > > > +/**
> > > > + * struct ipu3_uapi_iefd_cux2_1 - Calculate power of non-directed
> denoise
> > > > + *				  element apply.
> > > > + * @x0: X0 point of Config Unit, u9.0, default 0.
> > > > + * @x1: X1 point of Config Unit, u9.0, default 0.
> > > > + * @a01: Slope A of Config Unit, s4.4, default 0.
> > >
> > > The field is marked unsigned below. Which one is correct?
> > >
> >
> > They are both correct, however, s4.4 is the internal representation
> > used by CU, the inputs are unsigned, I will add a note in v8, same
> > applies to the few other places as you commented.
> 
> I still find this rather confusing. Is there a sign bit or is there not?
> 

It's unsigned number from driver perspective, all CU inputs are unsigned, however, they will be "converted" to signed for FW/HW to use. I have to consult FW expert if more clarification is needed.

> >
> > > > + * @__reserved1: reserved
> > > > + * @b01: offset B0 of Config Unit, u7.0, default 0.
> > > > + * @__reserved2: reserved
> > > > + */
> > > > +struct ipu3_uapi_iefd_cux2_1 {
> > > > +	__u32 x0:9;
> > > > +	__u32 x1:9;
> > > > +	__u32 a01:9;
> > > > +	__u32 __reserved1:5;
> > > > +
> > > > +	__u32 b01:8;
> > > > +	__u32 __reserved2:24;
> > > > +} __packed;
> > > > +
> > > > +/**
> > > > + * struct ipu3_uapi_iefd_cux4 - Calculate power of non-directed
> > > sharpening
> > > > + *				element.
> > > > + *
> > > > + * @x0:	X0 point of Config Unit, u9.0, default 0.
> > > > + * @x1:	X1 point of Config Unit, u9.0, default 0.
> > > > + * @x2:	X2 point of Config Unit, u9.0, default 0.
> > > > + * @__reserved0:	reserved
> > > > + * @x3:	X3 point of Config Unit, u9.0, default 0.
> > > > + * @a01:	Slope A0 of Config Unit, s4.4, default 0.
> > > > + * @a12:	Slope A1 of Config Unit, s4.4, default 0.
> > >
> > > Same here, suggest __s32 below if this is signed.
> > >
> >
> > Ack, same reason as ipu3_uapi_iefd_cux2_1, will add a comments.
> >
> > > > + * @__reserved1:	reserved
> > > > + * @a23:	Slope A2 of Config Unit, s4.4, default 0.
> > > > + * @b01:	Offset B0 of Config Unit, s7.0, default 0.
> > > > + * @b12:	Offset B1 of Config Unit, s7.0, default 0.
> > > > + * @__reserved2:	reserved
> > > > + * @b23:	Offset B2 of Config Unit, s7.0, default 0.
> > > > + * @__reserved3: reserved
> > > > + */
> > > > +struct ipu3_uapi_iefd_cux4 {
> > > > +	__u32 x0:9;
> > > > +	__u32 x1:9;
> > > > +	__u32 x2:9;
> > > > +	__u32 __reserved0:5;
> > > > +
> > > > +	__u32 x3:9;
> > > > +	__u32 a01:9;
> > > > +	__u32 a12:9;
> > > > +	__u32 __reserved1:5;
> > > > +
> > > > +	__u32 a23:9;
> > > > +	__u32 b01:8;
> > > > +	__u32 b12:8;
> > > > +	__u32 __reserved2:7;
> > > > +
> > > > +	__u32 b23:8;
> > > > +	__u32 __reserved3:24;
> > > > +} __packed;
> > > > +
> > > > +/**
> > > > + * struct ipu3_uapi_iefd_cux6_rad - Radial Config Unit (CU)
> > > > + *
> > > > + * @x0:	x0 points of Config Unit radial, u8.0
> > > > + * @x1:	x1 points of Config Unit radial, u8.0
> > > > + * @x2:	x2 points of Config Unit radial, u8.0
> > > > + * @x3:	x3 points of Config Unit radial, u8.0
> > > > + * @x4:	x4 points of Config Unit radial, u8.0
> > > > + * @x5:	x5 points of Config Unit radial, u8.0
> > > > + * @__reserved1: reserved
> > > > + * @a01:	Slope A of Config Unit radial, s7.8
> > > > + * @a12:	Slope A of Config Unit radial, s7.8
> > > > + * @a23:	Slope A of Config Unit radial, s7.8
> > > > + * @a34:	Slope A of Config Unit radial, s7.8
> > > > + * @a45:	Slope A of Config Unit radial, s7.8
> > > > + * @__reserved2: reserved
> > > > + * @b01:	Slope B of Config Unit radial, s9.0
> > > > + * @b12:	Slope B of Config Unit radial, s9.0
> > > > + * @b23:	Slope B of Config Unit radial, s9.0
> > > > + * @__reserved4: reserved
> > > > + * @b34:	Slope B of Config Unit radial, s9.0
> > > > + * @b45:	Slope B of Config Unit radial, s9.0
> > > > + * @__reserved5: reserved
> > > > + */
> > > > +struct ipu3_uapi_iefd_cux6_rad {
> > > > +	__u32 x0:8;
> > > > +	__u32 x1:8;
> > > > +	__u32 x2:8;
> > > > +	__u32 x3:8;
> > > > +
> > > > +	__u32 x4:8;
> > > > +	__u32 x5:8;
> > > > +	__u32 __reserved1:16;
> > > > +
> > > > +	__u32 a01:16;
> > > > +	__u32 a12:16;
> > > > +
> > > > +	__u32 a23:16;
> > > > +	__u32 a34:16;
> > > > +
> > > > +	__u32 a45:16;
> > > > +	__u32 __reserved2:16;
> > > > +
> > > > +	__u32 b01:10;
> > > > +	__u32 b12:10;
> > > > +	__u32 b23:10;
> > > > +	__u32 __reserved4:2;
> > > > +
> > > > +	__u32 b34:10;
> > > > +	__u32 b45:10;
> > > > +	__u32 __reserved5:12;
> > > > +} __packed;
> > > > +
> > > > +/**
> > > > + * struct ipu3_uapi_yuvp1_iefd_cfg_units - IEFd Config Units
> > > > +parameters
> > > > + *
> > > > + * @cu_1: calculate weight for blending directed and
> > > > + *	  non-directed denoise elements. See &ipu3_uapi_iefd_cux2
> > > > + * @cu_ed: calculate power of non-directed sharpening element, see
> > > > + *	   &ipu3_uapi_iefd_cux6_ed
> > > > + * @cu_3: calculate weight for blending directed and
> > > > + *	  non-directed denoise elements. A &ipu3_uapi_iefd_cux2
> > > > + * @cu_5: calculate power of non-directed denoise element apply, use
> > > > + *	  &ipu3_uapi_iefd_cux2_1
> > > > + * @cu_6: calculate power of non-directed sharpening element. See
> > > > + *	  &ipu3_uapi_iefd_cux4
> > > > + * @cu_7: calculate weight for blending directed and
> > > > + *	  non-directed denoise elements. Use &ipu3_uapi_iefd_cux2
> > > > + * @cu_unsharp: Config Unit of unsharp &ipu3_uapi_iefd_cux4
> > > > + * @cu_radial: Config Unit of radial &ipu3_uapi_iefd_cux6_rad
> > > > + * @cu_vssnlm: Config Unit of vssnlm &ipu3_uapi_iefd_cux2  */
> > > > +struct ipu3_uapi_yuvp1_iefd_cfg_units {
> > > > +	struct ipu3_uapi_iefd_cux2 cu_1;
> > > > +	struct ipu3_uapi_iefd_cux6_ed cu_ed;
> > > > +	struct ipu3_uapi_iefd_cux2 cu_3;
> > > > +	struct ipu3_uapi_iefd_cux2_1 cu_5;
> > > > +	struct ipu3_uapi_iefd_cux4 cu_6;
> > > > +	struct ipu3_uapi_iefd_cux2 cu_7;
> > > > +	struct ipu3_uapi_iefd_cux4 cu_unsharp;
> > > > +	struct ipu3_uapi_iefd_cux6_rad cu_radial;
> > > > +	struct ipu3_uapi_iefd_cux2 cu_vssnlm; } __packed;
> > > > +
> > > > +/**
> > > > + * struct ipu3_uapi_yuvp1_iefd_config_s - IEFd config
> > > > + *
> > > > + * @horver_diag_coeff: Gradiant compensation, coefficient that
> > > compensates for
> > > > + *		       different distance for vertical / horizontal and
> diagonal
> > > > + *		       * gradient calculation (~1/sqrt(2)).
> > > > + * @__reserved0: reserved
> > > > + * @clamp_stitch: Slope to stitch between clamped and unclamped
> > > > + edge
> > > values
> > > > + * @__reserved1: reserved
> > > > + * @direct_metric_update: Update coeff for direction metric
> > > > + * @__reserved2: reserved
> > > > + * @ed_horver_diag_coeff: Radial Coefficient that compensates for
> > > > + *			  different distance for vertical/horizontal and
> > > > + *			  diagonal gradient calculation (~1/sqrt(2))
> > > > + * @__reserved3: reserved
> > > > + */
> > > > +struct ipu3_uapi_yuvp1_iefd_config_s {
> > > > +	__u32 horver_diag_coeff:7;
> > > > +	__u32 __reserved0:1;
> > > > +	__u32 clamp_stitch:6;
> > > > +	__u32 __reserved1:2;
> > > > +	__u32 direct_metric_update:5;
> > > > +	__u32 __reserved2:3;
> > > > +	__u32 ed_horver_diag_coeff:7;
> > > > +	__u32 __reserved3:1;
> > > > +} __packed;
> > > > +
> > > > +/**
> > > > + * struct ipu3_uapi_yuvp1_iefd_control - IEFd control
> > > > + *
> > > > + * @iefd_en:	Enable IEFd
> > > > + * @denoise_en:	Enable denoise
> > > > + * @direct_smooth_en:	Enable directional smooth
> > > > + * @rad_en:	Enable radial update
> > > > + * @vssnlm_en:	Enable VSSNLM output filter
> > > > + * @__reserved:	reserved
> > > > + */
> > > > +struct ipu3_uapi_yuvp1_iefd_control {
> > > > +	__u32 iefd_en:1;
> > > > +	__u32 denoise_en:1;
> > > > +	__u32 direct_smooth_en:1;
> > > > +	__u32 rad_en:1;
> > > > +	__u32 vssnlm_en:1;
> > > > +	__u32 __reserved:27;
> > > > +} __packed;
> > > > +
> > > > +/**
> > > > + * struct ipu3_uapi_sharp_cfg - Sharpening config
> > > > + *
> > > > + * @nega_lmt_txt: Sharpening limit for negative overshoots for texture.
> > > > + * @__reserved0: reserved
> > > > + * @posi_lmt_txt: Sharpening limit for positive overshoots for texture.
> > > > + * @__reserved1: reserved
> > > > + * @nega_lmt_dir: Sharpening limit for negative overshoots for
> > > > +direction
> > > (edge).
> > > > + * @__reserved2: reserved
> > > > + * @posi_lmt_dir: Sharpening limit for positive overshoots for
> > > > + direction
> > > (edge).
> > > > + * @__reserved3: reserved
> > > > + *
> > > > + * Fixed point type u13.0, range [0, 8191].
> > > > + */
> > > > +struct ipu3_uapi_sharp_cfg {
> > > > +	__u32 nega_lmt_txt:13;
> > > > +	__u32 __reserved0:19;
> > > > +	__u32 posi_lmt_txt:13;
> > > > +	__u32 __reserved1:19;
> > > > +	__u32 nega_lmt_dir:13;
> > > > +	__u32 __reserved2:19;
> > > > +	__u32 posi_lmt_dir:13;
> > > > +	__u32 __reserved3:19;
> > > > +} __packed;
> > > > +
> > > > +/**
> > > > + * struct struct ipu3_uapi_far_w - Sharpening config for far
> > > > +sub-group
> > > > + *
> > > > + * @dir_shrp:	Weight of wide direct sharpening, u1.6, range [0, 64],
> > > default 64.
> > > > + * @__reserved0:	reserved
> > > > + * @dir_dns:	Weight of wide direct denoising, u1.6, range [0, 64],
> > > default 0.
> > > > + * @__reserved1:	reserved
> > > > + * @ndir_dns_powr:	Power of non-direct denoising,
> > > > + *			Precision u1.6, range [0, 64], default 64.
> > > > + * @__reserved2:	reserved
> > > > + */
> > > > +struct ipu3_uapi_far_w {
> > > > +	__u32 dir_shrp:7;
> > > > +	__u32 __reserved0:1;
> > > > +	__u32 dir_dns:7;
> > > > +	__u32 __reserved1:1;
> > > > +	__u32 ndir_dns_powr:7;
> > > > +	__u32 __reserved2:9;
> > > > +} __packed;
> > > > +
> > > > +/**
> > > > + * struct struct ipu3_uapi_unsharp_cfg - Unsharp config
> > > > + *
> > > > + * @unsharp_weight: Unsharp mask blending weight.
> > > > + *		    u1.6, range [0, 64], default 16.
> > > > + *		    0 - disabled, 64 - use only unsharp.
> > > > + * @__reserved0: reserved
> > > > + * @unsharp_amount: Unsharp mask amount, u4.5, range [0, 511],
> > > default 0.
> > > > + * @__reserved1: reserved
> > > > + */
> > > > +struct ipu3_uapi_unsharp_cfg {
> > > > +	__u32 unsharp_weight:7;
> > > > +	__u32 __reserved0:1;
> > > > +	__u32 unsharp_amount:9;
> > > > +	__u32 __reserved1:15;
> > > > +} __packed;
> > > > +
> > > > +/**
> > > > + * struct ipu3_uapi_yuvp1_iefd_shrp_cfg - IEFd sharpness config
> > > > + *
> > > > + * @cfg: sharpness config &ipu3_uapi_sharp_cfg
> > > > + * @far_w: wide range config, value as specified by &ipu3_uapi_far_w:
> > > > + *	The 5x5 environment is separated into 2 sub-groups, the 3x3
> nearest
> > > > + *	neighbors (8 pixels called Near), and the second order
> neighborhood
> > > > + *	around them (16 pixels called Far).
> > > > + * @unshrp_cfg: unsharpness config. &ipu3_uapi_unsharp_cfg  */
> > > > +struct ipu3_uapi_yuvp1_iefd_shrp_cfg {
> > > > +	struct ipu3_uapi_sharp_cfg cfg;
> > > > +	struct ipu3_uapi_far_w far_w;
> > > > +	struct ipu3_uapi_unsharp_cfg unshrp_cfg; } __packed;
> > > > +
> > > > +/**
> > > > + * struct ipu3_uapi_unsharp_coef0 - Unsharp mask coefficients
> > > > + *
> > > > + * @c00: Coeff11, s0.8, range [-255, 255], default 1.
> > > > + * @c01: Coeff12, s0.8, range [-255, 255], default 5.
> > > > + * @c02: Coeff13, s0.8, range [-255, 255], default 9.
> > > > + * @__reserved: reserved
> > > > + *
> > > > + * Configurable registers for common sharpening support.
> > > > + */
> > > > +struct ipu3_uapi_unsharp_coef0 {
> > > > +	__u32 c00:9;
> > > > +	__u32 c01:9;
> > > > +	__u32 c02:9;
> > > > +	__u32 __reserved:5;
> > >
> > > __s32?
> > >
> >
> > Will add a note, same as ipu3_uapi_iefd_cux2_1.
> >
> > > > +} __packed;
> > > > +
> > > > +/**
> > > > + * struct ipu3_uapi_unsharp_coef1 - Unsharp mask coefficients
> > > > + *
> > > > + * @c11: Coeff22, s0.8, range [-255, 255], default 29.
> > > > + * @c12: Coeff23, s0.8, range [-255, 255], default 55.
> > > > + * @c22: Coeff33, s0.8, range [-255, 255], default 96.
> > > > + * @__reserved: reserved
> > > > + */
> > > > +struct ipu3_uapi_unsharp_coef1 {
> > > > +	__u32 c11:9;
> > > > +	__u32 c12:9;
> > > > +	__u32 c22:9;
> > >
> > > __s32?
> > >
> >
> > Ack.
> >
> > > > +	__u32 __reserved:5;
> > > > +} __packed;
> > > > +
> > > > +/**
> > > > + * struct ipu3_uapi_yuvp1_iefd_unshrp_cfg - Unsharp mask config
> > > > + *
> > > > + * @unsharp_coef0: unsharp coefficient 0 config. See
> > > &ipu3_uapi_unsharp_coef0
> > > > + * @unsharp_coef1: unsharp coefficient 1 config. See
> > > &ipu3_uapi_unsharp_coef1
> > > > + */
> > > > +struct ipu3_uapi_yuvp1_iefd_unshrp_cfg {
> > > > +	struct ipu3_uapi_unsharp_coef0 unsharp_coef0;
> > > > +	struct ipu3_uapi_unsharp_coef1 unsharp_coef1; } __packed;
> > > > +
> > >
> > > ...
> > >
> > > > +/**
> > > > + * struct ipu3_uapi_isp_lin_vmem_params - Linearization
> > > > +parameters
> > > > + *
> > > > + * @lin_lutlow_gr: linearization look-up table for GR channel
> interpolation.
> > > > + * @lin_lutlow_r: linearization look-up table for R channel
> interpolation.
> > > > + * @lin_lutlow_b: linearization look-up table for B channel
> interpolation.
> > > > + * @lin_lutlow_gb: linearization look-up table for GB channel
> interpolation.
> > > > + *			lin_lutlow_gr / lin_lutlow_gr / lin_lutlow_gr /
> > >
> > > Copy & paste issue here? Should the postfixes be gr, r, b and gb instead?
> > >
> >
> > Ack.
> >
> > It's a long file, thanks a lot for your time.
> >
> > Yong
> >
> > > > + *			lin_lutlow_gr <= LIN_MAX_VALUE - 1.
> > > > + * @lin_lutdif_gr:	lin_lutlow_gr[i+1] - lin_lutlow_gr[i].
> > > > + * @lin_lutdif_r:	lin_lutlow_r[i+1] - lin_lutlow_r[i].
> > > > + * @lin_lutdif_b:	lin_lutlow_b[i+1] - lin_lutlow_b[i].
> > > > + * @lin_lutdif_gb:	lin_lutlow_gb[i+1] - lin_lutlow_gb[i].
> > > > + */
> > > > +struct ipu3_uapi_isp_lin_vmem_params {
> > > > +	__s16 lin_lutlow_gr[IPU3_UAPI_LIN_LUT_SIZE];
> > > > +	__s16 lin_lutlow_r[IPU3_UAPI_LIN_LUT_SIZE];
> > > > +	__s16 lin_lutlow_b[IPU3_UAPI_LIN_LUT_SIZE];
> > > > +	__s16 lin_lutlow_gb[IPU3_UAPI_LIN_LUT_SIZE];
> > > > +	__s16 lin_lutdif_gr[IPU3_UAPI_LIN_LUT_SIZE];
> > > > +	__s16 lin_lutdif_r[IPU3_UAPI_LIN_LUT_SIZE];
> > > > +	__s16 lin_lutdif_b[IPU3_UAPI_LIN_LUT_SIZE];
> > > > +	__s16 lin_lutdif_gb[IPU3_UAPI_LIN_LUT_SIZE];
> > > > +} __packed;
> > >
> > > --
> > > Kind regards,
> > >
> > > Sakari Ailus
> > > sakari.ailus@linux.intel.com
> 
> --
> Regards,
> 
> Sakari Ailus
> sakari.ailus@linux.intel.com
