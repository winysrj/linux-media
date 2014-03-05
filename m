Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:41828 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750990AbaCEF2m (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 5 Mar 2014 00:28:42 -0500
Date: Wed, 05 Mar 2014 13:28:39 +0800
From: kbuild test robot <fengguang.wu@intel.com>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: linux-media@vger.kernel.org, kbuild-all@01.org
Subject: [linuxtv-media:master 485/499]
 drivers/media/dvb-frontends/drx39xyj/drxj.c:1672:65: sparse: Using plain
 integer as NULL pointer
Message-ID: <5316b607.tZvy2dEGJe9LO2S/%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

tree:   git://linuxtv.org/media_tree.git master
head:   59432be1c7fbf2a4f608850855ff649bee0f7b3b
commit: 9e4c509d7444e067d39d3ac96a3398721bca4f01 [485/499] [media] drx-j: Use single master mode
reproduce: make C=1 CF=-D__CHECK_ENDIAN__


sparse warnings: (new ones prefixed by >>)

>> drivers/media/dvb-frontends/drx39xyj/drxj.c:1672:65: sparse: Using plain integer as NULL pointer
>> drivers/media/dvb-frontends/drx39xyj/drxj.c:1672:71: sparse: Using plain integer as NULL pointer
>> drivers/media/dvb-frontends/drx39xyj/drxj.c:1674:52: sparse: Using plain integer as NULL pointer
>> drivers/media/dvb-frontends/drx39xyj/drxj.c:1674:58: sparse: Using plain integer as NULL pointer
   drivers/media/dvb-frontends/drx39xyj/drxj.c:905:21: sparse: symbol 'drxj_default_aud_data_g' was not declared. Should it be static?
   drivers/media/dvb-frontends/drx39xyj/drxj.c:20248:25: sparse: cast to restricted __be16
   drivers/media/dvb-frontends/drx39xyj/drxj.c:20248:25: sparse: cast to restricted __be16
   drivers/media/dvb-frontends/drx39xyj/drxj.c:20248:25: sparse: cast to restricted __be16
   drivers/media/dvb-frontends/drx39xyj/drxj.c:20248:25: sparse: cast to restricted __be16
   drivers/media/dvb-frontends/drx39xyj/drxj.c:20250:25: sparse: cast to restricted __be16
   drivers/media/dvb-frontends/drx39xyj/drxj.c:20250:25: sparse: cast to restricted __be16
   drivers/media/dvb-frontends/drx39xyj/drxj.c:20250:25: sparse: cast to restricted __be16
   drivers/media/dvb-frontends/drx39xyj/drxj.c:20250:25: sparse: cast to restricted __be16
   drivers/media/dvb-frontends/drx39xyj/drxj.c:20274:34: sparse: cast to restricted __be32
   drivers/media/dvb-frontends/drx39xyj/drxj.c:20274:34: sparse: cast to restricted __be32
   drivers/media/dvb-frontends/drx39xyj/drxj.c:20274:34: sparse: cast to restricted __be32
   drivers/media/dvb-frontends/drx39xyj/drxj.c:20274:34: sparse: cast to restricted __be32
   drivers/media/dvb-frontends/drx39xyj/drxj.c:20274:34: sparse: cast to restricted __be32
   drivers/media/dvb-frontends/drx39xyj/drxj.c:20274:34: sparse: cast to restricted __be32
   drivers/media/dvb-frontends/drx39xyj/drxj.c:20276:34: sparse: cast to restricted __be16
   drivers/media/dvb-frontends/drx39xyj/drxj.c:20276:34: sparse: cast to restricted __be16
   drivers/media/dvb-frontends/drx39xyj/drxj.c:20276:34: sparse: cast to restricted __be16
   drivers/media/dvb-frontends/drx39xyj/drxj.c:20276:34: sparse: cast to restricted __be16
   drivers/media/dvb-frontends/drx39xyj/drxj.c:20278:35: sparse: cast to restricted __be16
   drivers/media/dvb-frontends/drx39xyj/drxj.c:20278:35: sparse: cast to restricted __be16
   drivers/media/dvb-frontends/drx39xyj/drxj.c:20278:35: sparse: cast to restricted __be16
   drivers/media/dvb-frontends/drx39xyj/drxj.c:20278:35: sparse: cast to restricted __be16
   drivers/media/dvb-frontends/drx39xyj/drxj.c:20280:33: sparse: cast to restricted __be16
   drivers/media/dvb-frontends/drx39xyj/drxj.c:20280:33: sparse: cast to restricted __be16
   drivers/media/dvb-frontends/drx39xyj/drxj.c:20280:33: sparse: cast to restricted __be16
   drivers/media/dvb-frontends/drx39xyj/drxj.c:20280:33: sparse: cast to restricted __be16
   drivers/media/dvb-frontends/drx39xyj/drxj.c:20087:34: sparse: cast to restricted __be16
   drivers/media/dvb-frontends/drx39xyj/drxj.c:20087:34: sparse: cast to restricted __be16
   drivers/media/dvb-frontends/drx39xyj/drxj.c:20087:34: sparse: cast to restricted __be16
   drivers/media/dvb-frontends/drx39xyj/drxj.c:20087:34: sparse: cast to restricted __be16
   drivers/media/dvb-frontends/drx39xyj/drxj.c:20114:29: sparse: cast to restricted __be16
   drivers/media/dvb-frontends/drx39xyj/drxj.c:20114:29: sparse: cast to restricted __be16
   drivers/media/dvb-frontends/drx39xyj/drxj.c:20114:29: sparse: cast to restricted __be16
   drivers/media/dvb-frontends/drx39xyj/drxj.c:20114:29: sparse: cast to restricted __be16
   drivers/media/dvb-frontends/drx39xyj/drxj.c:20132:34: sparse: cast to restricted __be32
   drivers/media/dvb-frontends/drx39xyj/drxj.c:20132:34: sparse: cast to restricted __be32
   drivers/media/dvb-frontends/drx39xyj/drxj.c:20132:34: sparse: cast to restricted __be32
   drivers/media/dvb-frontends/drx39xyj/drxj.c:20132:34: sparse: cast to restricted __be32
   drivers/media/dvb-frontends/drx39xyj/drxj.c:20132:34: sparse: cast to restricted __be32
   drivers/media/dvb-frontends/drx39xyj/drxj.c:20132:34: sparse: cast to restricted __be32
   drivers/media/dvb-frontends/drx39xyj/drxj.c:20134:34: sparse: cast to restricted __be16
   drivers/media/dvb-frontends/drx39xyj/drxj.c:20134:34: sparse: cast to restricted __be16
   drivers/media/dvb-frontends/drx39xyj/drxj.c:20134:34: sparse: cast to restricted __be16
   drivers/media/dvb-frontends/drx39xyj/drxj.c:20134:34: sparse: cast to restricted __be16
   drivers/media/dvb-frontends/drx39xyj/drxj.c:20136:35: sparse: cast to restricted __be16
   drivers/media/dvb-frontends/drx39xyj/drxj.c:20136:35: sparse: cast to restricted __be16
   drivers/media/dvb-frontends/drx39xyj/drxj.c:20136:35: sparse: cast to restricted __be16
   drivers/media/dvb-frontends/drx39xyj/drxj.c:20136:35: sparse: cast to restricted __be16
   drivers/media/dvb-frontends/drx39xyj/drxj.c:20138:33: sparse: cast to restricted __be16
   drivers/media/dvb-frontends/drx39xyj/drxj.c:20138:33: sparse: cast to restricted __be16
   drivers/media/dvb-frontends/drx39xyj/drxj.c:20138:33: sparse: cast to restricted __be16
   drivers/media/dvb-frontends/drx39xyj/drxj.c:20138:33: sparse: cast to restricted __be16
   drivers/media/dvb-frontends/drx39xyj/drxj.c:20152:35: sparse: cast to restricted __be16
   drivers/media/dvb-frontends/drx39xyj/drxj.c:20152:35: sparse: cast to restricted __be16
   drivers/media/dvb-frontends/drx39xyj/drxj.c:20152:35: sparse: cast to restricted __be16
   drivers/media/dvb-frontends/drx39xyj/drxj.c:20152:35: sparse: cast to restricted __be16
   drivers/media/dvb-frontends/drx39xyj/drxj.c:20160:47: sparse: cast to restricted __be32
   drivers/media/dvb-frontends/drx39xyj/drxj.c:20160:47: sparse: cast to restricted __be32
   drivers/media/dvb-frontends/drx39xyj/drxj.c:20160:47: sparse: cast to restricted __be32
   drivers/media/dvb-frontends/drx39xyj/drxj.c:20160:47: sparse: cast to restricted __be32
   drivers/media/dvb-frontends/drx39xyj/drxj.c:20160:47: sparse: cast to restricted __be32
   drivers/media/dvb-frontends/drx39xyj/drxj.c:20160:47: sparse: cast to restricted __be32
   drivers/media/dvb-frontends/drx39xyj/drxj.c:20162:46: sparse: cast to restricted __be32
   drivers/media/dvb-frontends/drx39xyj/drxj.c:20162:46: sparse: cast to restricted __be32
   drivers/media/dvb-frontends/drx39xyj/drxj.c:20162:46: sparse: cast to restricted __be32
   drivers/media/dvb-frontends/drx39xyj/drxj.c:20162:46: sparse: cast to restricted __be32
   drivers/media/dvb-frontends/drx39xyj/drxj.c:20162:46: sparse: cast to restricted __be32
   drivers/media/dvb-frontends/drx39xyj/drxj.c:20162:46: sparse: cast to restricted __be32
   drivers/media/dvb-frontends/drx39xyj/drxj.c:20164:51: sparse: cast to restricted __be32
   drivers/media/dvb-frontends/drx39xyj/drxj.c:20164:51: sparse: cast to restricted __be32
   drivers/media/dvb-frontends/drx39xyj/drxj.c:20164:51: sparse: cast to restricted __be32
   drivers/media/dvb-frontends/drx39xyj/drxj.c:20164:51: sparse: cast to restricted __be32
   drivers/media/dvb-frontends/drx39xyj/drxj.c:20164:51: sparse: cast to restricted __be32
   drivers/media/dvb-frontends/drx39xyj/drxj.c:20164:51: sparse: cast to restricted __be32

vim +1672 drivers/media/dvb-frontends/drx39xyj/drxj.c

73b3fc3d Mauro Carvalho Chehab 2014-01-27  1666  
73b3fc3d Mauro Carvalho Chehab 2014-01-27  1667  #if DRXDAP_SINGLE_MASTER
73b3fc3d Mauro Carvalho Chehab 2014-01-27  1668  		/*
73b3fc3d Mauro Carvalho Chehab 2014-01-27  1669  		 * In single master mode, split the read and write actions.
73b3fc3d Mauro Carvalho Chehab 2014-01-27  1670  		 * No special action is needed for write chunks here.
73b3fc3d Mauro Carvalho Chehab 2014-01-27  1671  		 */
73b3fc3d Mauro Carvalho Chehab 2014-01-27 @1672  		rc = drxbsp_i2c_write_read(dev_addr, bufx, buf, 0, 0, 0);
73b3fc3d Mauro Carvalho Chehab 2014-01-27  1673  		if (rc == 0)
73b3fc3d Mauro Carvalho Chehab 2014-01-27 @1674  			rc = drxbsp_i2c_write_read(0, 0, 0, dev_addr, todo, data);
73b3fc3d Mauro Carvalho Chehab 2014-01-27  1675  #else
73b3fc3d Mauro Carvalho Chehab 2014-01-27  1676  		/* In multi master mode, do everything in one RW action */
73b3fc3d Mauro Carvalho Chehab 2014-01-27  1677  		rc = drxbsp_i2c_write_read(dev_addr, bufx, buf, dev_addr, todo,

:::::: The code at line 1672 was first introduced by commit
:::::: 73b3fc3d74de4ccba5775476d685e062b7774e64 [media] drx-j: get rid of drx_dap_fasi.c

:::::: TO: Mauro Carvalho Chehab <m.chehab@samsung.com>
:::::: CC: Mauro Carvalho Chehab <m.chehab@samsung.com>

---
0-DAY kernel build testing backend              Open Source Technology Center
http://lists.01.org/mailman/listinfo/kbuild                 Intel Corporation
