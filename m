Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:33243 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751316AbeEDIhr (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 4 May 2018 04:37:47 -0400
Date: Fri, 4 May 2018 16:37:08 +0800
From: kbuild test robot <lkp@intel.com>
To: Jan Luebbe <jlu@pengutronix.de>
Cc: kbuild-all@01.org, linux-media@vger.kernel.org,
        Jan Luebbe <jlu@pengutronix.de>, slongerbeam@gmail.com,
        p.zabel@pengutronix.de
Subject: Re: [PATCH 2/2] media: imx: add support for RGB565_2X8 on parallel
 bus
Message-ID: <201805041608.ATVwBBFF%fengguang.wu@intel.com>
References: <20180503164120.9912-3-jlu@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180503164120.9912-3-jlu@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jan,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on linuxtv-media/master]
[also build test WARNING on v4.17-rc3 next-20180503]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/Jan-Luebbe/media-imx-add-capture-support-for-RGB565_2X8-on-parallel-bus/20180504-120003
base:   git://linuxtv.org/media_tree.git master
reproduce:
        # apt-get install sparse
        make ARCH=x86_64 allmodconfig
        make C=1 CF=-D__CHECK_ENDIAN__


sparse warnings: (new ones prefixed by >>)


vim +652 drivers/staging/media/imx/imx-media-csi.c

   640	
   641	/* Update the CSI whole sensor and active windows */
   642	static int csi_setup(struct csi_priv *priv)
   643	{
   644		struct v4l2_mbus_framefmt *infmt, *outfmt;
   645		struct v4l2_mbus_config mbus_cfg;
   646		struct v4l2_mbus_framefmt if_fmt;
   647		struct imx_media_pixfmt *outcc;
   648		struct v4l2_rect crop;
   649	
   650		infmt = &priv->format_mbus[CSI_SINK_PAD];
   651		outfmt = &priv->format_mbus[priv->active_output_pad];
 > 652		outcc = priv->cc[priv->active_output_pad];
   653	
   654		/* compose mbus_config from the upstream endpoint */
   655		mbus_cfg.type = priv->upstream_ep.bus_type;
   656		mbus_cfg.flags = (priv->upstream_ep.bus_type == V4L2_MBUS_CSI2) ?
   657			priv->upstream_ep.bus.mipi_csi2.flags :
   658			priv->upstream_ep.bus.parallel.flags;
   659	
   660		/*
   661		 * we need to pass input frame to CSI interface, but
   662		 * with translated field type from output format
   663		 */
   664		if_fmt = *infmt;
   665		if_fmt.field = outfmt->field;
   666		crop = priv->crop;
   667	
   668		/*
   669		 * if cycles is set, we need to handle this over multiple cycles as
   670		 * generic/bayer data
   671		 */
   672		if ((priv->upstream_ep.bus_type != V4L2_MBUS_CSI2) && outcc->cycles) {
   673			if_fmt.width *= outcc->cycles;
   674			crop.width *= outcc->cycles;
   675		}
   676	
   677		ipu_csi_set_window(priv->csi, &crop);
   678	
   679		ipu_csi_set_downsize(priv->csi,
   680				     priv->crop.width == 2 * priv->compose.width,
   681				     priv->crop.height == 2 * priv->compose.height);
   682	
   683		ipu_csi_init_interface(priv->csi, &mbus_cfg, &if_fmt);
   684	
   685		ipu_csi_set_dest(priv->csi, priv->dest);
   686	
   687		if (priv->dest == IPU_CSI_DEST_IDMAC)
   688			ipu_csi_set_skip_smfc(priv->csi, priv->skip->skip_smfc,
   689					      priv->skip->max_ratio - 1, 0);
   690	
   691		ipu_csi_dump(priv->csi);
   692	
   693		return 0;
   694	}
   695	

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
