Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga18.intel.com ([134.134.136.126]:40837 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751298AbeDFTan (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 6 Apr 2018 15:30:43 -0400
Date: Sat, 7 Apr 2018 03:29:58 +0800
From: kbuild test robot <lkp@intel.com>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: kbuild-all@01.org,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        linux-omap@vger.kernel.org, linux-fbdev@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Subject: Re: [PATCH v2 15/19] omap2: omapfb: allow building it with
 COMPILE_TEST
Message-ID: <201804070300.5aL1duqY%fengguang.wu@intel.com>
References: <f0947227675df4a774949500b6ee4cac1485b494.1522959716.git.mchehab@s-opensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f0947227675df4a774949500b6ee4cac1485b494.1522959716.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

I love your patch! Perhaps something to improve:

[auto build test WARNING on linuxtv-media/master]
[also build test WARNING on v4.16 next-20180406]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/Mauro-Carvalho-Chehab/Make-all-media-drivers-build-with-COMPILE_TEST/20180406-163048
base:   git://linuxtv.org/media_tree.git master
reproduce:
        # apt-get install sparse
        make ARCH=x86_64 allmodconfig
        make C=1 CF=-D__CHECK_ENDIAN__


sparse warnings: (new ones prefixed by >>)

>> drivers/video/fbdev/omap2/omapfb/displays/panel-sony-acx565akm.c:230:23: sparse: cast to restricted __be32
>> drivers/video/fbdev/omap2/omapfb/displays/panel-sony-acx565akm.c:230:23: sparse: cast to restricted __be32
>> drivers/video/fbdev/omap2/omapfb/displays/panel-sony-acx565akm.c:230:23: sparse: cast to restricted __be32
>> drivers/video/fbdev/omap2/omapfb/displays/panel-sony-acx565akm.c:230:23: sparse: cast to restricted __be32
>> drivers/video/fbdev/omap2/omapfb/displays/panel-sony-acx565akm.c:230:23: sparse: cast to restricted __be32
>> drivers/video/fbdev/omap2/omapfb/displays/panel-sony-acx565akm.c:230:23: sparse: cast to restricted __be32
--
>> drivers/video/fbdev/omap2/omapfb/dss/dispc.c:289:9: sparse: context imbalance in 'mgr_fld_write' - different lock contexts for basic block

vim +230 drivers/video/fbdev/omap2/omapfb/displays/panel-sony-acx565akm.c

f76ee892 Tomi Valkeinen 2015-12-09  222  
f76ee892 Tomi Valkeinen 2015-12-09  223  static int panel_enabled(struct panel_drv_data *ddata)
f76ee892 Tomi Valkeinen 2015-12-09  224  {
f76ee892 Tomi Valkeinen 2015-12-09  225  	u32 disp_status;
f76ee892 Tomi Valkeinen 2015-12-09  226  	int enabled;
f76ee892 Tomi Valkeinen 2015-12-09  227  
f76ee892 Tomi Valkeinen 2015-12-09  228  	acx565akm_read(ddata, MIPID_CMD_READ_DISP_STATUS,
f76ee892 Tomi Valkeinen 2015-12-09  229  			(u8 *)&disp_status, 4);
f76ee892 Tomi Valkeinen 2015-12-09 @230  	disp_status = __be32_to_cpu(disp_status);
f76ee892 Tomi Valkeinen 2015-12-09  231  	enabled = (disp_status & (1 << 17)) && (disp_status & (1 << 10));
f76ee892 Tomi Valkeinen 2015-12-09  232  	dev_dbg(&ddata->spi->dev,
f76ee892 Tomi Valkeinen 2015-12-09  233  		"LCD panel %senabled by bootloader (status 0x%04x)\n",
f76ee892 Tomi Valkeinen 2015-12-09  234  		enabled ? "" : "not ", disp_status);
f76ee892 Tomi Valkeinen 2015-12-09  235  	return enabled;
f76ee892 Tomi Valkeinen 2015-12-09  236  }
f76ee892 Tomi Valkeinen 2015-12-09  237  

:::::: The code at line 230 was first introduced by commit
:::::: f76ee892a99e68b55402b8d4b8aeffcae2aff34d omapfb: copy omapdss & displays for omapfb

:::::: TO: Tomi Valkeinen <tomi.valkeinen@ti.com>
:::::: CC: Tomi Valkeinen <tomi.valkeinen@ti.com>

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
