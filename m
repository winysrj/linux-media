Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:61638 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755473AbaHUXIP (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 21 Aug 2014 19:08:15 -0400
Date: Fri, 22 Aug 2014 07:07:34 +0800
From: kbuild test robot <fengguang.wu@intel.com>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: linux-media@vger.kernel.org, kbuild-all@01.org
Subject: [linuxtv-media:devel 496/499]
 drivers/media/platform/ti-vpe/vpdma.c:587:21: warning: format '%x' expects
 argument of type 'unsigned int', but argument 3 has type 'dma_addr_t'
Message-ID: <53f67bb6.1FhmuW/pi6lEcrXI%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

tree:   git://linuxtv.org/media_tree.git devel
head:   2558eeda5cd75649a1159aadca530a990b81c4ee
commit: 3a29cde494f90301499ea7ed318643982f812f7f [496/499] [media] enable COMPILE_TEST for ti-vbe
config: make ARCH=s390 allmodconfig

All warnings:

   drivers/media/platform/ti-vpe/vpdma.c: In function 'vpdma_alloc_desc_buf':
   drivers/media/platform/ti-vpe/vpdma.c:332:28: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]
     WARN_ON((u32) buf->addr & VPDMA_DESC_ALIGN);
                               ^
   drivers/media/platform/ti-vpe/vpdma.c: In function 'dump_dtd':
>> drivers/media/platform/ti-vpe/vpdma.c:587:21: warning: format '%x' expects argument of type 'unsigned int', but argument 3 has type 'dma_addr_t' [-Wformat=]
     pr_debug("word2: start_addr = 0x%08x\n", dtd->start_addr);
                        ^

vim +587 drivers/media/platform/ti-vpe/vpdma.c

213b8ee4 Archit Taneja 2013-10-16  571  	dir = dtd_get_dir(dtd);
213b8ee4 Archit Taneja 2013-10-16  572  	chan = dtd_get_chan(dtd);
213b8ee4 Archit Taneja 2013-10-16  573  
213b8ee4 Archit Taneja 2013-10-16  574  	pr_debug("%s data transfer descriptor for channel %d\n",
213b8ee4 Archit Taneja 2013-10-16  575  		dir == DTD_DIR_OUT ? "outbound" : "inbound", chan);
213b8ee4 Archit Taneja 2013-10-16  576  
213b8ee4 Archit Taneja 2013-10-16  577  	pr_debug("word0: data_type = %d, notify = %d, field = %d, 1D = %d, "
213b8ee4 Archit Taneja 2013-10-16  578  		"even_ln_skp = %d, odd_ln_skp = %d, line_stride = %d\n",
213b8ee4 Archit Taneja 2013-10-16  579  		dtd_get_data_type(dtd), dtd_get_notify(dtd), dtd_get_field(dtd),
213b8ee4 Archit Taneja 2013-10-16  580  		dtd_get_1d(dtd), dtd_get_even_line_skip(dtd),
213b8ee4 Archit Taneja 2013-10-16  581  		dtd_get_odd_line_skip(dtd), dtd_get_line_stride(dtd));
213b8ee4 Archit Taneja 2013-10-16  582  
213b8ee4 Archit Taneja 2013-10-16  583  	if (dir == DTD_DIR_IN)
213b8ee4 Archit Taneja 2013-10-16  584  		pr_debug("word1: line_length = %d, xfer_height = %d\n",
213b8ee4 Archit Taneja 2013-10-16  585  			dtd_get_line_length(dtd), dtd_get_xfer_height(dtd));
213b8ee4 Archit Taneja 2013-10-16  586  
213b8ee4 Archit Taneja 2013-10-16 @587  	pr_debug("word2: start_addr = 0x%08x\n", dtd->start_addr);
213b8ee4 Archit Taneja 2013-10-16  588  
213b8ee4 Archit Taneja 2013-10-16  589  	pr_debug("word3: pkt_type = %d, mode = %d, dir = %d, chan = %d, "
213b8ee4 Archit Taneja 2013-10-16  590  		"pri = %d, next_chan = %d\n", dtd_get_pkt_type(dtd),
213b8ee4 Archit Taneja 2013-10-16  591  		dtd_get_mode(dtd), dir, chan, dtd_get_priority(dtd),
213b8ee4 Archit Taneja 2013-10-16  592  		dtd_get_next_chan(dtd));
213b8ee4 Archit Taneja 2013-10-16  593  
213b8ee4 Archit Taneja 2013-10-16  594  	if (dir == DTD_DIR_IN)
213b8ee4 Archit Taneja 2013-10-16  595  		pr_debug("word4: frame_width = %d, frame_height = %d\n",

:::::: The code at line 587 was first introduced by commit
:::::: 213b8ee4001895dd60910c440f76682fb881b5cc [media] v4l: ti-vpe: Add helpers for creating VPDMA descriptors

:::::: TO: Archit Taneja <archit@ti.com>
:::::: CC: Mauro Carvalho Chehab <m.chehab@samsung.com>

---
0-DAY kernel build testing backend              Open Source Technology Center
http://lists.01.org/mailman/listinfo/kbuild                 Intel Corporation
