Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:9882 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752150AbdHMBFn (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 12 Aug 2017 21:05:43 -0400
Date: Sun, 13 Aug 2017 09:04:44 +0800
From: kbuild test robot <lkp@intel.com>
To: Jacob Chen <jacob-chen@iotwrt.com>
Cc: kbuild-all@01.org, linux-rockchip@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        heiko@sntech.de, mchehab@kernel.org, linux-media@vger.kernel.org,
        laurent.pinchart+renesas@ideasonboard.com, hans.verkuil@cisco.com,
        tfiga@chromium.org, nicolas@ndufresne.ca,
        Jacob Chen <jacob-chen@iotwrt.com>
Subject: Re: [PATCH v7] rockchip/rga: v4l2 m2m support
Message-ID: <201708130912.x1Jda6gx%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="MGYHOYXEY6WxJCY8"
Content-Disposition: inline
In-Reply-To: <1501737812-24171-1-git-send-email-jacob-chen@iotwrt.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--MGYHOYXEY6WxJCY8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Jacob,

[auto build test ERROR on rockchip/for-next]
[also build test ERROR on v4.13-rc4 next-20170811]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/Jacob-Chen/rockchip-rga-v4l2-m2m-support/20170803-234713
base:   https://git.kernel.org/pub/scm/linux/kernel/git/mmind/linux-rockchip.git for-next
config: s390-allmodconfig (attached as .config)
compiler: s390x-linux-gnu-gcc (Debian 6.1.1-9) 6.1.1 20160705
reproduce:
        wget https://raw.githubusercontent.com/01org/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # save the attached .config to linux build tree
        make.cross ARCH=s390 

All errors (new ones prefixed by >>):

   drivers/media/platform/rockchip-rga/rga-hw.c: In function 'rga_cmd_set_trans_info':
   drivers/media/platform/rockchip-rga/rga-hw.c:237:17: error: 'V4L2_PORTER_DUFF_CLEAR' undeclared (first use in this function)
     if (ctx->op == V4L2_PORTER_DUFF_CLEAR) {
                    ^~~~~~~~~~~~~~~~~~~~~~
   drivers/media/platform/rockchip-rga/rga-hw.c:237:17: note: each undeclared identifier is reported only once for each function it appears in
   drivers/media/platform/rockchip-rga/rga-hw.c: In function 'rga_cmd_set_mode':
   drivers/media/platform/rockchip-rga/rga-hw.c:391:7: error: 'V4L2_PORTER_DUFF_CLEAR' undeclared (first use in this function)
     case V4L2_PORTER_DUFF_CLEAR:
          ^~~~~~~~~~~~~~~~~~~~~~
>> drivers/media/platform/rockchip-rga/rga-hw.c:397:7: error: 'V4L2_PORTER_DUFF_DST' undeclared (first use in this function)
     case V4L2_PORTER_DUFF_DST:
          ^~~~~~~~~~~~~~~~~~~~
   drivers/media/platform/rockchip-rga/rga-hw.c:398:7: error: 'V4L2_PORTER_DUFF_DSTATOP' undeclared (first use in this function)
     case V4L2_PORTER_DUFF_DSTATOP:
          ^~~~~~~~~~~~~~~~~~~~~~~~
   drivers/media/platform/rockchip-rga/rga-hw.c:399:7: error: 'V4L2_PORTER_DUFF_DSTIN' undeclared (first use in this function)
     case V4L2_PORTER_DUFF_DSTIN:
          ^~~~~~~~~~~~~~~~~~~~~~
   drivers/media/platform/rockchip-rga/rga-hw.c:400:7: error: 'V4L2_PORTER_DUFF_DSTOUT' undeclared (first use in this function)
     case V4L2_PORTER_DUFF_DSTOUT:
          ^~~~~~~~~~~~~~~~~~~~~~~
>> drivers/media/platform/rockchip-rga/rga-hw.c:401:7: error: 'V4L2_PORTER_DUFF_DSTOVER' undeclared (first use in this function)
     case V4L2_PORTER_DUFF_DSTOVER:
          ^~~~~~~~~~~~~~~~~~~~~~~~
   drivers/media/platform/rockchip-rga/rga-hw.c:402:7: error: 'V4L2_PORTER_DUFF_SRCATOP' undeclared (first use in this function)
     case V4L2_PORTER_DUFF_SRCATOP:
          ^~~~~~~~~~~~~~~~~~~~~~~~
   drivers/media/platform/rockchip-rga/rga-hw.c:403:7: error: 'V4L2_PORTER_DUFF_SRCIN' undeclared (first use in this function)
     case V4L2_PORTER_DUFF_SRCIN:
          ^~~~~~~~~~~~~~~~~~~~~~
   drivers/media/platform/rockchip-rga/rga-hw.c:404:7: error: 'V4L2_PORTER_DUFF_SRCOUT' undeclared (first use in this function)
     case V4L2_PORTER_DUFF_SRCOUT:
          ^~~~~~~~~~~~~~~~~~~~~~~
   drivers/media/platform/rockchip-rga/rga-hw.c:405:7: error: 'V4L2_PORTER_DUFF_SRCOVER' undeclared (first use in this function)
     case V4L2_PORTER_DUFF_SRCOVER:
          ^~~~~~~~~~~~~~~~~~~~~~~~
   drivers/media/platform/rockchip-rga/rga-hw.c: In function 'rga_cmd_set':
   drivers/media/platform/rockchip-rga/rga-hw.c:623:17: error: 'V4L2_PORTER_DUFF_CLEAR' undeclared (first use in this function)
     if (ctx->op != V4L2_PORTER_DUFF_CLEAR) {
                    ^~~~~~~~~~~~~~~~~~~~~~

vim +/V4L2_PORTER_DUFF_DST +397 drivers/media/platform/rockchip-rga/rga-hw.c

   168	
   169	static void rga_cmd_set_trans_info(struct rga_ctx *ctx)
   170	{
   171		struct rockchip_rga *rga = ctx->rga;
   172		u32 *dest = rga->cmdbuf_virt;
   173		unsigned int scale_dst_w, scale_dst_h;
   174		unsigned int src_h, src_w, src_x, src_y, dst_h, dst_w, dst_x, dst_y;
   175		union rga_src_info src_info;
   176		union rga_dst_info dst_info;
   177		union rga_src_x_factor x_factor;
   178		union rga_src_y_factor y_factor;
   179		union rga_src_vir_info src_vir_info;
   180		union rga_src_act_info src_act_info;
   181		union rga_dst_vir_info dst_vir_info;
   182		union rga_dst_act_info dst_act_info;
   183	
   184		struct rga_addr_offset *dst_offset;
   185		struct rga_corners_addr_offset offsets;
   186		struct rga_corners_addr_offset src_offsets;
   187	
   188		src_h = ctx->in.crop.height;
   189		src_w = ctx->in.crop.width;
   190		src_x = ctx->in.crop.left;
   191		src_y = ctx->in.crop.top;
   192		dst_h = ctx->out.crop.height;
   193		dst_w = ctx->out.crop.width;
   194		dst_x = ctx->out.crop.left;
   195		dst_y = ctx->out.crop.top;
   196	
   197		src_info.val = dest[(RGA_SRC_INFO - RGA_MODE_BASE_REG) >> 2];
   198		dst_info.val = dest[(RGA_DST_INFO - RGA_MODE_BASE_REG) >> 2];
   199		x_factor.val = dest[(RGA_SRC_X_FACTOR - RGA_MODE_BASE_REG) >> 2];
   200		y_factor.val = dest[(RGA_SRC_Y_FACTOR - RGA_MODE_BASE_REG) >> 2];
   201		src_vir_info.val = dest[(RGA_SRC_VIR_INFO - RGA_MODE_BASE_REG) >> 2];
   202		src_act_info.val = dest[(RGA_SRC_ACT_INFO - RGA_MODE_BASE_REG) >> 2];
   203		dst_vir_info.val = dest[(RGA_DST_VIR_INFO - RGA_MODE_BASE_REG) >> 2];
   204		dst_act_info.val = dest[(RGA_DST_ACT_INFO - RGA_MODE_BASE_REG) >> 2];
   205	
   206		src_info.data.format = ctx->in.fmt->hw_format;
   207		src_info.data.swap = ctx->in.fmt->color_swap;
   208		dst_info.data.format = ctx->out.fmt->hw_format;
   209		dst_info.data.swap = ctx->out.fmt->color_swap;
   210	
   211		if (ctx->in.fmt->hw_format >= RGA_COLOR_FMT_YUV422SP) {
   212			if (ctx->out.fmt->hw_format < RGA_COLOR_FMT_YUV422SP) {
   213				switch (ctx->in.colorspace) {
   214				case V4L2_COLORSPACE_REC709:
   215					src_info.data.csc_mode =
   216						RGA_SRC_CSC_MODE_BT709_R0;
   217					break;
   218				default:
   219					src_info.data.csc_mode =
   220						RGA_SRC_CSC_MODE_BT601_R0;
   221					break;
   222				}
   223			}
   224		}
   225	
   226		if (ctx->out.fmt->hw_format >= RGA_COLOR_FMT_YUV422SP) {
   227			switch (ctx->out.colorspace) {
   228			case V4L2_COLORSPACE_REC709:
   229				dst_info.data.csc_mode = RGA_SRC_CSC_MODE_BT709_R0;
   230				break;
   231			default:
   232				dst_info.data.csc_mode = RGA_DST_CSC_MODE_BT601_R0;
   233				break;
   234			}
   235		}
   236	
 > 237		if (ctx->op == V4L2_PORTER_DUFF_CLEAR) {
   238			/*
   239			 * Configure the target color to foreground color.
   240			 */
   241			dest[(RGA_SRC_FG_COLOR - RGA_MODE_BASE_REG) >> 2] =
   242				ctx->fill_color;
   243			dst_vir_info.data.vir_stride = ctx->out.stride >> 2;
   244			dst_act_info.data.act_height = dst_h - 1;
   245			dst_act_info.data.act_width = dst_w - 1;
   246	
   247			offsets = rga_get_addr_offset(&ctx->out, dst_x, dst_y,
   248						      dst_w, dst_h);
   249			dst_offset = &offsets.left_top;
   250	
   251			goto write_dst;
   252		}
   253	
   254		if (ctx->vflip)
   255			src_info.data.mir_mode |= RGA_SRC_MIRR_MODE_X;
   256	
   257		if (ctx->hflip)
   258			src_info.data.mir_mode |= RGA_SRC_MIRR_MODE_Y;
   259	
   260		switch (ctx->rotate) {
   261		case 90:
   262			src_info.data.rot_mode = RGA_SRC_ROT_MODE_90_DEGREE;
   263			break;
   264		case 180:
   265			src_info.data.rot_mode = RGA_SRC_ROT_MODE_180_DEGREE;
   266			break;
   267		case 270:
   268			src_info.data.rot_mode = RGA_SRC_ROT_MODE_270_DEGREE;
   269			break;
   270		default:
   271			src_info.data.rot_mode = RGA_SRC_ROT_MODE_0_DEGREE;
   272			break;
   273		}
   274	
   275		/*
   276		 * Cacluate the up/down scaling mode/factor.
   277		 *
   278		 * RGA used to scale the picture first, and then rotate second,
   279		 * so we need to swap the w/h when rotate degree is 90/270.
   280		 */
   281		if (src_info.data.rot_mode == RGA_SRC_ROT_MODE_90_DEGREE ||
   282		    src_info.data.rot_mode == RGA_SRC_ROT_MODE_270_DEGREE) {
   283			if (rga->version.major == 0 || rga->version.minor == 0) {
   284				if (dst_w == src_h)
   285					src_h -= 8;
   286				if (abs(src_w - dst_h) < 16)
   287					src_w -= 16;
   288			}
   289	
   290			scale_dst_h = dst_w;
   291			scale_dst_w = dst_h;
   292		} else {
   293			scale_dst_w = dst_w;
   294			scale_dst_h = dst_h;
   295		}
   296	
   297		if (src_w == scale_dst_w) {
   298			src_info.data.hscl_mode = RGA_SRC_HSCL_MODE_NO;
   299			x_factor.val = 0;
   300		} else if (src_w > scale_dst_w) {
   301			src_info.data.hscl_mode = RGA_SRC_HSCL_MODE_DOWN;
   302			x_factor.data.down_scale_factor =
   303				rga_get_scaling(src_w, scale_dst_w) + 1;
   304		} else {
   305			src_info.data.hscl_mode = RGA_SRC_HSCL_MODE_UP;
   306			x_factor.data.up_scale_factor =
   307				rga_get_scaling(src_w - 1, scale_dst_w - 1);
   308		}
   309	
   310		if (src_h == scale_dst_h) {
   311			src_info.data.vscl_mode = RGA_SRC_VSCL_MODE_NO;
   312			y_factor.val = 0;
   313		} else if (src_h > scale_dst_h) {
   314			src_info.data.vscl_mode = RGA_SRC_VSCL_MODE_DOWN;
   315			y_factor.data.down_scale_factor =
   316				rga_get_scaling(src_h, scale_dst_h) + 1;
   317		} else {
   318			src_info.data.vscl_mode = RGA_SRC_VSCL_MODE_UP;
   319			y_factor.data.up_scale_factor =
   320				rga_get_scaling(src_h - 1, scale_dst_h - 1);
   321		}
   322	
   323		/*
   324		 * Cacluate the framebuffer virtual strides and active size,
   325		 * note that the step of vir_stride / vir_width is 4 byte words
   326		 */
   327		src_vir_info.data.vir_stride = ctx->in.stride >> 2;
   328		src_vir_info.data.vir_width = ctx->in.stride >> 2;
   329	
   330		src_act_info.data.act_height = src_h - 1;
   331		src_act_info.data.act_width = src_w - 1;
   332	
   333		dst_vir_info.data.vir_stride = ctx->out.stride >> 2;
   334		dst_act_info.data.act_height = dst_h - 1;
   335		dst_act_info.data.act_width = dst_w - 1;
   336	
   337		/*
   338		 * Cacluate the source framebuffer base address with offset pixel.
   339		 */
   340		src_offsets = rga_get_addr_offset(&ctx->in, src_x, src_y,
   341						  src_w, src_h);
   342	
   343		/*
   344		 * Configure the dest framebuffer base address with pixel offset.
   345		 */
   346		offsets = rga_get_addr_offset(&ctx->out, dst_x, dst_y, dst_w, dst_h);
   347		dst_offset = rga_lookup_draw_pos(&offsets, src_info.data.rot_mode,
   348						 src_info.data.mir_mode);
   349	
   350		dest[(RGA_SRC_Y_RGB_BASE_ADDR - RGA_MODE_BASE_REG) >> 2] =
   351			src_offsets.left_top.y_off;
   352		dest[(RGA_SRC_CB_BASE_ADDR - RGA_MODE_BASE_REG) >> 2] =
   353			src_offsets.left_top.u_off;
   354		dest[(RGA_SRC_CR_BASE_ADDR - RGA_MODE_BASE_REG) >> 2] =
   355			src_offsets.left_top.v_off;
   356	
   357		dest[(RGA_SRC_X_FACTOR - RGA_MODE_BASE_REG) >> 2] = x_factor.val;
   358		dest[(RGA_SRC_Y_FACTOR - RGA_MODE_BASE_REG) >> 2] = y_factor.val;
   359		dest[(RGA_SRC_VIR_INFO - RGA_MODE_BASE_REG) >> 2] = src_vir_info.val;
   360		dest[(RGA_SRC_ACT_INFO - RGA_MODE_BASE_REG) >> 2] = src_act_info.val;
   361	
   362		dest[(RGA_SRC_INFO - RGA_MODE_BASE_REG) >> 2] = src_info.val;
   363	
   364	write_dst:
   365		dest[(RGA_DST_Y_RGB_BASE_ADDR - RGA_MODE_BASE_REG) >> 2] =
   366			dst_offset->y_off;
   367		dest[(RGA_DST_CB_BASE_ADDR - RGA_MODE_BASE_REG) >> 2] =
   368			dst_offset->u_off;
   369		dest[(RGA_DST_CR_BASE_ADDR - RGA_MODE_BASE_REG) >> 2] =
   370			dst_offset->v_off;
   371	
   372		dest[(RGA_DST_VIR_INFO - RGA_MODE_BASE_REG) >> 2] = dst_vir_info.val;
   373		dest[(RGA_DST_ACT_INFO - RGA_MODE_BASE_REG) >> 2] = dst_act_info.val;
   374	
   375		dest[(RGA_DST_INFO - RGA_MODE_BASE_REG) >> 2] = dst_info.val;
   376	}
   377	
   378	static void rga_cmd_set_mode(struct rga_ctx *ctx)
   379	{
   380		struct rockchip_rga *rga = ctx->rga;
   381		u32 *dest = rga->cmdbuf_virt;
   382		union rga_mode_ctrl mode;
   383		union rga_alpha_ctrl0 alpha_ctrl0;
   384		union rga_alpha_ctrl1 alpha_ctrl1;
   385	
   386		mode.val = 0;
   387		alpha_ctrl0.val = 0;
   388		alpha_ctrl1.val = 0;
   389	
   390		switch (ctx->op) {
   391		case V4L2_PORTER_DUFF_CLEAR:
   392			mode.data.gradient_sat = 1;
   393			mode.data.render = RGA_MODE_RENDER_RECTANGLE_FILL;
   394			mode.data.cf_rop4_pat = RGA_MODE_CF_ROP4_SOLID;
   395			mode.data.bitblt = RGA_MODE_BITBLT_MODE_SRC_TO_DST;
   396			break;
 > 397		case V4L2_PORTER_DUFF_DST:
 > 398		case V4L2_PORTER_DUFF_DSTATOP:
   399		case V4L2_PORTER_DUFF_DSTIN:
   400		case V4L2_PORTER_DUFF_DSTOUT:
 > 401		case V4L2_PORTER_DUFF_DSTOVER:
   402		case V4L2_PORTER_DUFF_SRCATOP:
   403		case V4L2_PORTER_DUFF_SRCIN:
   404		case V4L2_PORTER_DUFF_SRCOUT:
   405		case V4L2_PORTER_DUFF_SRCOVER:
   406			mode.data.gradient_sat = 1;
   407			mode.data.render = RGA_MODE_RENDER_BITBLT;
   408			mode.data.bitblt = RGA_MODE_BITBLT_MODE_SRC_TO_DST;
   409	
   410			alpha_ctrl0.data.rop_en = 1;
   411			alpha_ctrl0.data.rop_mode = RGA_ALPHA_ROP_MODE_3;
   412			alpha_ctrl0.data.rop_select = RGA_ALPHA_SELECT_ALPHA;
   413	
   414			alpha_ctrl1.data.dst_alpha_cal_m0 = RGA_ALPHA_CAL_NORMAL;
   415			alpha_ctrl1.data.src_alpha_cal_m0 = RGA_ALPHA_CAL_NORMAL;
   416			alpha_ctrl1.data.dst_alpha_cal_m1 = RGA_ALPHA_CAL_NORMAL;
   417			alpha_ctrl1.data.src_alpha_cal_m1 = RGA_ALPHA_CAL_NORMAL;
   418			break;
   419		default:
   420			mode.data.gradient_sat = 1;
   421			mode.data.render = RGA_MODE_RENDER_BITBLT;
   422			mode.data.bitblt = RGA_MODE_BITBLT_MODE_SRC_TO_DST;
   423			break;
   424		}
   425	
   426		switch (ctx->op) {
   427		case V4L2_PORTER_DUFF_DST:
   428			/* A=Dst.a */
   429			alpha_ctrl1.data.src_factor_m1 = RGA_ALPHA_FACTOR_ZERO;
   430	
   431			alpha_ctrl1.data.dst_alpha_m1 = RGA_ALPHA_NORMAL;
   432			alpha_ctrl1.data.dst_blend_m1 = RGA_ALPHA_BLEND_NORMAL;
   433			alpha_ctrl1.data.dst_factor_m1 = RGA_ALPHA_FACTOR_ONE;
   434	
   435			/* C=Dst.c */
   436			alpha_ctrl1.data.src_factor_m0 = RGA_ALPHA_FACTOR_ZERO;
   437	
   438			alpha_ctrl1.data.dst_color_m0 = RGA_ALPHA_COLOR_NORMAL;
   439			alpha_ctrl1.data.dst_alpha_m0 = RGA_ALPHA_NORMAL;
   440			alpha_ctrl1.data.dst_blend_m0 = RGA_ALPHA_BLEND_NORMAL;
   441			alpha_ctrl1.data.dst_factor_m0 = RGA_ALPHA_FACTOR_ONE;
   442			break;
   443		case V4L2_PORTER_DUFF_DSTATOP:
   444			/* A=Src.a */
   445			alpha_ctrl1.data.src_alpha_m1 = RGA_ALPHA_NORMAL;
   446			alpha_ctrl1.data.src_blend_m1 = RGA_ALPHA_BLEND_NORMAL;
   447			alpha_ctrl1.data.src_factor_m1 = RGA_ALPHA_FACTOR_ONE;
   448	
   449			alpha_ctrl1.data.dst_factor_m1 = RGA_ALPHA_FACTOR_ZERO;
   450	
   451			/* C=Src.a*Dst.c+Src.c*(1.0-Dst.a) */
   452			alpha_ctrl1.data.src_color_m0 = RGA_ALPHA_COLOR_NORMAL;
   453			alpha_ctrl1.data.src_alpha_m0 = RGA_ALPHA_NORMAL;
   454			alpha_ctrl1.data.src_blend_m0 = RGA_ALPHA_BLEND_NORMAL;
   455			alpha_ctrl1.data.src_factor_m0 = RGA_ALPHA_FACTOR_OTHER_REVERSE;
   456	
   457			alpha_ctrl1.data.dst_color_m0 = RGA_ALPHA_COLOR_NORMAL;
   458			alpha_ctrl1.data.dst_alpha_m0 = RGA_ALPHA_NORMAL;
   459			alpha_ctrl1.data.dst_blend_m0 = RGA_ALPHA_BLEND_NORMAL;
   460			alpha_ctrl1.data.dst_factor_m0 = RGA_ALPHA_FACTOR_OTHER;
   461			break;
   462		case V4L2_PORTER_DUFF_DSTIN:
   463			/* A=Dst.a*Src.a */
   464			alpha_ctrl1.data.src_alpha_m1 = RGA_ALPHA_NORMAL;
   465			alpha_ctrl1.data.src_blend_m1 = RGA_ALPHA_BLEND_NORMAL;
   466			alpha_ctrl1.data.src_factor_m1 = RGA_ALPHA_FACTOR_ZERO;
   467	
   468			alpha_ctrl1.data.dst_alpha_m1 = RGA_ALPHA_NORMAL;
   469			alpha_ctrl1.data.dst_blend_m1 = RGA_ALPHA_BLEND_NORMAL;
   470			alpha_ctrl1.data.dst_factor_m1 = RGA_ALPHA_FACTOR_OTHER;
   471	
   472			/* C=Dst.c*Src.a */
   473			alpha_ctrl1.data.src_color_m0 = RGA_ALPHA_COLOR_NORMAL;
   474			alpha_ctrl1.data.src_alpha_m0 = RGA_ALPHA_NORMAL;
   475			alpha_ctrl1.data.src_blend_m0 = RGA_ALPHA_BLEND_NORMAL;
   476			alpha_ctrl1.data.src_factor_m0 = RGA_ALPHA_FACTOR_ZERO;
   477	
   478			alpha_ctrl1.data.dst_color_m0 = RGA_ALPHA_COLOR_NORMAL;
   479			alpha_ctrl1.data.dst_alpha_m0 = RGA_ALPHA_NORMAL;
   480			alpha_ctrl1.data.dst_blend_m0 = RGA_ALPHA_BLEND_NORMAL;
   481			alpha_ctrl1.data.dst_factor_m0 = RGA_ALPHA_FACTOR_OTHER;
   482			break;
   483		case V4L2_PORTER_DUFF_DSTOUT:
   484			/* A=Dst.a*(1.0-Src.a) */
   485			alpha_ctrl1.data.src_alpha_m1 = RGA_ALPHA_NORMAL;
   486			alpha_ctrl1.data.src_blend_m1 = RGA_ALPHA_BLEND_NORMAL;
   487			alpha_ctrl1.data.src_factor_m1 = RGA_ALPHA_FACTOR_ZERO;
   488	
   489			alpha_ctrl1.data.dst_alpha_m1 = RGA_ALPHA_NORMAL;
   490			alpha_ctrl1.data.dst_blend_m1 = RGA_ALPHA_BLEND_NORMAL;
   491			alpha_ctrl1.data.dst_factor_m1 = RGA_ALPHA_FACTOR_OTHER_REVERSE;
   492	
   493			/* C=Dst.c*(1.0-Src.a) */
   494			alpha_ctrl1.data.src_color_m0 = RGA_ALPHA_COLOR_NORMAL;
   495			alpha_ctrl1.data.src_alpha_m0 = RGA_ALPHA_NORMAL;
   496			alpha_ctrl1.data.src_blend_m0 = RGA_ALPHA_BLEND_NORMAL;
   497			alpha_ctrl1.data.src_factor_m0 = RGA_ALPHA_FACTOR_ZERO;
   498	
   499			alpha_ctrl1.data.dst_color_m0 = RGA_ALPHA_COLOR_NORMAL;
   500			alpha_ctrl1.data.dst_alpha_m0 = RGA_ALPHA_NORMAL;
   501			alpha_ctrl1.data.dst_blend_m0 = RGA_ALPHA_BLEND_NORMAL;
   502			alpha_ctrl1.data.dst_factor_m0 = RGA_ALPHA_FACTOR_OTHER_REVERSE;
   503			break;
   504		case V4L2_PORTER_DUFF_DSTOVER:
   505			/* A=Src.a+Dst.a*(1.0-Src.a) */
   506			alpha_ctrl1.data.src_alpha_m1 = RGA_ALPHA_NORMAL;
   507			alpha_ctrl1.data.src_blend_m1 = RGA_ALPHA_BLEND_NORMAL;
   508			alpha_ctrl1.data.src_factor_m1 = RGA_ALPHA_FACTOR_ONE;
   509	
   510			alpha_ctrl1.data.dst_alpha_m1 = RGA_ALPHA_NORMAL;
   511			alpha_ctrl1.data.dst_blend_m1 = RGA_ALPHA_BLEND_NORMAL;
   512			alpha_ctrl1.data.dst_factor_m1 = RGA_ALPHA_FACTOR_OTHER_REVERSE;
   513	
   514			/* C=Dst.c+Src.c*(1.0-Dst.a) */
   515			alpha_ctrl1.data.src_color_m0 = RGA_ALPHA_COLOR_NORMAL;
   516			alpha_ctrl1.data.src_alpha_m0 = RGA_ALPHA_NORMAL;
   517			alpha_ctrl1.data.src_blend_m0 = RGA_ALPHA_BLEND_NORMAL;
   518			alpha_ctrl1.data.src_factor_m0 = RGA_ALPHA_FACTOR_OTHER_REVERSE;
   519	
   520			alpha_ctrl1.data.dst_color_m0 = RGA_ALPHA_COLOR_NORMAL;
   521			alpha_ctrl1.data.dst_alpha_m0 = RGA_ALPHA_NORMAL;
   522			alpha_ctrl1.data.dst_blend_m0 = RGA_ALPHA_BLEND_NORMAL;
   523			alpha_ctrl1.data.dst_factor_m0 = RGA_ALPHA_FACTOR_ONE;
   524			break;
   525		case V4L2_PORTER_DUFF_SRCATOP:
   526			/* A=Dst.a */
   527			alpha_ctrl1.data.src_factor_m1 = RGA_ALPHA_FACTOR_ZERO;
   528	
   529			alpha_ctrl1.data.dst_alpha_m1 = RGA_ALPHA_NORMAL;
   530			alpha_ctrl1.data.dst_blend_m1 = RGA_ALPHA_BLEND_NORMAL;
   531			alpha_ctrl1.data.dst_factor_m1 = RGA_ALPHA_FACTOR_ONE;
   532	
   533			/* C=Dst.a*Src.c+Dst.c*(1.0-Src.a) */
   534			alpha_ctrl1.data.src_color_m0 = RGA_ALPHA_COLOR_NORMAL;
   535			alpha_ctrl1.data.src_alpha_m0 = RGA_ALPHA_NORMAL;
   536			alpha_ctrl1.data.src_blend_m0 = RGA_ALPHA_BLEND_NORMAL;
   537			alpha_ctrl1.data.src_factor_m0 = RGA_ALPHA_FACTOR_OTHER;
   538	
   539			alpha_ctrl1.data.dst_color_m0 = RGA_ALPHA_COLOR_NORMAL;
   540			alpha_ctrl1.data.dst_alpha_m0 = RGA_ALPHA_NORMAL;
   541			alpha_ctrl1.data.dst_blend_m0 = RGA_ALPHA_BLEND_NORMAL;
   542			alpha_ctrl1.data.dst_factor_m0 = RGA_ALPHA_FACTOR_OTHER_REVERSE;
   543			break;
   544		case V4L2_PORTER_DUFF_SRCIN:
   545			/* A=Src.a*Dst.a */
   546			alpha_ctrl1.data.src_alpha_m1 = RGA_ALPHA_NORMAL;
   547			alpha_ctrl1.data.src_blend_m1 = RGA_ALPHA_BLEND_NORMAL;
   548			alpha_ctrl1.data.src_factor_m1 = RGA_ALPHA_FACTOR_ZERO;
   549	
   550			alpha_ctrl1.data.dst_alpha_m1 = RGA_ALPHA_NORMAL;
   551			alpha_ctrl1.data.dst_blend_m1 = RGA_ALPHA_BLEND_NORMAL;
   552			alpha_ctrl1.data.dst_factor_m1 = RGA_ALPHA_FACTOR_OTHER;
   553	
   554			/* C=Src.c*Dst.a */
   555			alpha_ctrl1.data.src_color_m0 = RGA_ALPHA_COLOR_NORMAL;
   556			alpha_ctrl1.data.src_alpha_m0 = RGA_ALPHA_NORMAL;
   557			alpha_ctrl1.data.src_blend_m0 = RGA_ALPHA_BLEND_NORMAL;
   558			alpha_ctrl1.data.src_factor_m0 = RGA_ALPHA_FACTOR_OTHER;
   559	
   560			alpha_ctrl1.data.dst_color_m0 = RGA_ALPHA_COLOR_NORMAL;
   561			alpha_ctrl1.data.dst_alpha_m0 = RGA_ALPHA_NORMAL;
   562			alpha_ctrl1.data.dst_blend_m0 = RGA_ALPHA_BLEND_NORMAL;
   563			alpha_ctrl1.data.dst_factor_m0 = RGA_ALPHA_FACTOR_ZERO;
   564			break;
   565		case V4L2_PORTER_DUFF_SRCOUT:
   566			/* A=Src.a*(1.0-Dst.a) */
   567			alpha_ctrl1.data.src_alpha_m1 = RGA_ALPHA_NORMAL;
   568			alpha_ctrl1.data.src_blend_m1 = RGA_ALPHA_BLEND_NORMAL;
   569			alpha_ctrl1.data.src_factor_m1 = RGA_ALPHA_FACTOR_OTHER_REVERSE;
   570	
   571			alpha_ctrl1.data.dst_alpha_m1 = RGA_ALPHA_NORMAL;
   572			alpha_ctrl1.data.dst_blend_m1 = RGA_ALPHA_BLEND_NORMAL;
   573			alpha_ctrl1.data.dst_factor_m1 = RGA_ALPHA_FACTOR_ZERO;
   574	
   575			/* C=Src.c*(1.0-Dst.a) */
   576			alpha_ctrl1.data.src_color_m0 = RGA_ALPHA_COLOR_NORMAL;
   577			alpha_ctrl1.data.src_alpha_m0 = RGA_ALPHA_NORMAL;
   578			alpha_ctrl1.data.src_blend_m0 = RGA_ALPHA_BLEND_NORMAL;
   579			alpha_ctrl1.data.src_factor_m0 = RGA_ALPHA_FACTOR_OTHER_REVERSE;
   580	
   581			alpha_ctrl1.data.dst_color_m0 = RGA_ALPHA_COLOR_NORMAL;
   582			alpha_ctrl1.data.dst_alpha_m0 = RGA_ALPHA_NORMAL;
   583			alpha_ctrl1.data.dst_blend_m0 = RGA_ALPHA_BLEND_NORMAL;
   584			alpha_ctrl1.data.dst_factor_m0 = RGA_ALPHA_FACTOR_ZERO;
   585			break;
   586		case V4L2_PORTER_DUFF_SRCOVER:
   587			/* A=Src.a+Dst.a*(1.0-Src.a) */
   588			alpha_ctrl1.data.src_alpha_m1 = RGA_ALPHA_NORMAL;
   589			alpha_ctrl1.data.src_blend_m1 = RGA_ALPHA_BLEND_NORMAL;
   590			alpha_ctrl1.data.src_factor_m1 = RGA_ALPHA_FACTOR_ONE;
   591	
   592			alpha_ctrl1.data.dst_alpha_m1 = RGA_ALPHA_NORMAL;
   593			alpha_ctrl1.data.dst_blend_m1 = RGA_ALPHA_BLEND_NORMAL;
   594			alpha_ctrl1.data.dst_factor_m1 = RGA_ALPHA_FACTOR_OTHER_REVERSE;
   595	
   596			/* C=Src.c+Dst.c*(1.0-Src.a) */
   597			alpha_ctrl1.data.src_color_m0 = RGA_ALPHA_COLOR_NORMAL;
   598			alpha_ctrl1.data.src_alpha_m0 = RGA_ALPHA_NORMAL;
   599			alpha_ctrl1.data.src_blend_m0 = RGA_ALPHA_BLEND_NORMAL;
   600			alpha_ctrl1.data.src_factor_m0 = RGA_ALPHA_FACTOR_ONE;
   601	
   602			alpha_ctrl1.data.dst_color_m0 = RGA_ALPHA_COLOR_NORMAL;
   603			alpha_ctrl1.data.dst_alpha_m0 = RGA_ALPHA_NORMAL;
   604			alpha_ctrl1.data.dst_blend_m0 = RGA_ALPHA_BLEND_NORMAL;
   605			alpha_ctrl1.data.dst_factor_m0 = RGA_ALPHA_FACTOR_OTHER_REVERSE;
   606			break;
   607		default:
   608			break;
   609		}
   610	
   611		dest[(RGA_ALPHA_CTRL0 - RGA_MODE_BASE_REG) >> 2] = alpha_ctrl0.val;
   612		dest[(RGA_ALPHA_CTRL1 - RGA_MODE_BASE_REG) >> 2] = alpha_ctrl1.val;
   613	
   614		dest[(RGA_MODE_CTRL - RGA_MODE_BASE_REG) >> 2] = mode.val;
   615	}
   616	

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation

--MGYHOYXEY6WxJCY8
Content-Type: application/gzip
Content-Disposition: attachment; filename=".config.gz"
Content-Transfer-Encoding: base64

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
AgA=

--MGYHOYXEY6WxJCY8--
