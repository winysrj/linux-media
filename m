Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:24132 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751826AbbHRNeC (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 18 Aug 2015 09:34:02 -0400
Date: Tue, 18 Aug 2015 21:30:52 +0800
From: kbuild test robot <fengguang.wu@intel.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: kbuild-all@01.org, Mauro Carvalho Chehab <m.chehab@samsung.com>,
	linux-media@vger.kernel.org
Subject: [linux-next:master 7177/9424]
 drivers/media/i2c/s5c73m3/s5c73m3-core.c:170:39: sparse: incorrect type in
 argument 1 (different base types)
Message-ID: <201508182149.sj1COrop%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

tree:   git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
head:   ebe96538f4817c765690e28fcd33dc1da1504d26
commit: 5cc596c66fe7c725ec049ae2093e7242034c97d6 [7177/9424] [media] i2c: Make all i2c devices visible if COMPILE_TEST=y
reproduce:
  # apt-get install sparse
  git checkout 5cc596c66fe7c725ec049ae2093e7242034c97d6
  make ARCH=x86_64 allmodconfig
  make C=1 CF=-D__CHECK_ENDIAN__


sparse warnings: (new ones prefixed by >>)

>> drivers/media/i2c/s5c73m3/s5c73m3-core.c:170:39: sparse: incorrect type in argument 1 (different base types)
   drivers/media/i2c/s5c73m3/s5c73m3-core.c:170:39:    expected restricted __be16 const [usertype] *p
   drivers/media/i2c/s5c73m3/s5c73m3-core.c:170:39:    got unsigned short [usertype] *<noident>

vim +170 drivers/media/i2c/s5c73m3/s5c73m3-core.c

cac47f18 Andrzej Hajda 2012-11-22  154  			.flags = 0,
cac47f18 Andrzej Hajda 2012-11-22  155  			.len = sizeof(wbuf),
cac47f18 Andrzej Hajda 2012-11-22  156  			.buf = wbuf
cac47f18 Andrzej Hajda 2012-11-22  157  		}, {
cac47f18 Andrzej Hajda 2012-11-22  158  			.addr = client->addr,
cac47f18 Andrzej Hajda 2012-11-22  159  			.flags = I2C_M_RD,
cac47f18 Andrzej Hajda 2012-11-22  160  			.len = sizeof(rbuf),
cac47f18 Andrzej Hajda 2012-11-22  161  			.buf = rbuf
cac47f18 Andrzej Hajda 2012-11-22  162  		}
cac47f18 Andrzej Hajda 2012-11-22  163  	};
cac47f18 Andrzej Hajda 2012-11-22  164  	/*
cac47f18 Andrzej Hajda 2012-11-22  165  	 * Issue repeated START after writing 2 address bytes and
cac47f18 Andrzej Hajda 2012-11-22  166  	 * just one STOP only after reading the data bytes.
cac47f18 Andrzej Hajda 2012-11-22  167  	 */
cac47f18 Andrzej Hajda 2012-11-22  168  	ret = i2c_transfer(client->adapter, msg, 2);
cac47f18 Andrzej Hajda 2012-11-22  169  	if (ret == 2) {
cac47f18 Andrzej Hajda 2012-11-22 @170  		*data = be16_to_cpup((u16 *)rbuf);
cac47f18 Andrzej Hajda 2012-11-22  171  		v4l2_dbg(4, s5c73m3_dbg, client,
cac47f18 Andrzej Hajda 2012-11-22  172  			 "%s: addr: 0x%04x, data: 0x%04x\n",
cac47f18 Andrzej Hajda 2012-11-22  173  			 __func__, addr, *data);
cac47f18 Andrzej Hajda 2012-11-22  174  		return 0;
cac47f18 Andrzej Hajda 2012-11-22  175  	}
cac47f18 Andrzej Hajda 2012-11-22  176  
cac47f18 Andrzej Hajda 2012-11-22  177  	v4l2_err(client, "I2C read failed: addr: %04x, (%d)\n", addr, ret);
cac47f18 Andrzej Hajda 2012-11-22  178  

:::::: The code at line 170 was first introduced by commit
:::::: cac47f1822fcb97018e24b05a7fb31f11a6bc28c [media] V4L: Add S5C73M3 camera driver

:::::: TO: Andrzej Hajda <a.hajda@samsung.com>
:::::: CC: Mauro Carvalho Chehab <mchehab@redhat.com>

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
