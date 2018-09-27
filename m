Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga06.intel.com ([134.134.136.31]:40847 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727015AbeI0JUf (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 27 Sep 2018 05:20:35 -0400
Date: Thu, 27 Sep 2018 10:59:19 +0800
From: kbuild test robot <lkp@intel.com>
To: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
Cc: kbuild-all@01.org, linux-media@vger.kernel.org,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Hans Verkuil <hverkuil@xs4all.nl>
Subject: [linuxtv-media:request_api 77/77]
 drivers/staging/media/sunxi/cedrus/cedrus.c:93 cedrus_init_ctrls() error:
 potential null dereference 'ctx->ctrls'.  (kzalloc returns null)
Message-ID: <201809271018.4tzPg0aH%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

tree:   git://linuxtv.org/media_tree.git request_api
head:   50e761516f2b8c0cdeb31a8c6ca1b4ef98cd13f1
commit: 50e761516f2b8c0cdeb31a8c6ca1b4ef98cd13f1 [77/77] media: platform: Add Cedrus VPU decoder driver

smatch warnings:
drivers/staging/media/sunxi/cedrus/cedrus.c:93 cedrus_init_ctrls() error: potential null dereference 'ctx->ctrls'.  (kzalloc returns null)

vim +93 drivers/staging/media/sunxi/cedrus/cedrus.c

    57	
    58	static int cedrus_init_ctrls(struct cedrus_dev *dev, struct cedrus_ctx *ctx)
    59	{
    60		struct v4l2_ctrl_handler *hdl = &ctx->hdl;
    61		struct v4l2_ctrl *ctrl;
    62		unsigned int ctrl_size;
    63		unsigned int i;
    64	
    65		v4l2_ctrl_handler_init(hdl, CEDRUS_CONTROLS_COUNT);
    66		if (hdl->error) {
    67			v4l2_err(&dev->v4l2_dev,
    68				 "Failed to initialize control handler\n");
    69			return hdl->error;
    70		}
    71	
    72		ctrl_size = sizeof(ctrl) * CEDRUS_CONTROLS_COUNT + 1;
    73	
    74		ctx->ctrls = kzalloc(ctrl_size, GFP_KERNEL);
    75		memset(ctx->ctrls, 0, ctrl_size);
    76	
    77		for (i = 0; i < CEDRUS_CONTROLS_COUNT; i++) {
    78			struct v4l2_ctrl_config cfg = { 0 };
    79	
    80			cfg.elem_size = cedrus_controls[i].elem_size;
    81			cfg.id = cedrus_controls[i].id;
    82	
    83			ctrl = v4l2_ctrl_new_custom(hdl, &cfg, NULL);
    84			if (hdl->error) {
    85				v4l2_err(&dev->v4l2_dev,
    86					 "Failed to create new custom control\n");
    87	
    88				v4l2_ctrl_handler_free(hdl);
    89				kfree(ctx->ctrls);
    90				return hdl->error;
    91			}
    92	
  > 93			ctx->ctrls[i] = ctrl;
    94		}
    95	
    96		ctx->fh.ctrl_handler = hdl;
    97		v4l2_ctrl_handler_setup(hdl);
    98	
    99		return 0;
   100	}
   101	

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
