Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:54665 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753664AbaGQWd1 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Jul 2014 18:33:27 -0400
Date: Fri, 18 Jul 2014 06:32:43 +0800
From: kbuild test robot <fengguang.wu@intel.com>
To: Hans Verkuil <hans.verkuil@cisco.com>
Cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	kbuild-all@01.org
Subject: [linuxtv-media:master 452/499]
 drivers/staging/media/solo6x10/solo6x10-disp.c:225 solo_set_motion_block()
 error: potential null dereference 'buf'.  (kzalloc returns null)
Message-ID: <53c84f0b.qKLV26Cm5gn7fBwa%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

tree:   git://linuxtv.org/media_tree.git master
head:   9409945c7ff7ba39727df8ede2551bd22e76b58b
commit: 761f9aa23f2ac187aa1bed58215f09f3c8456295 [452/499] [media] solo6x10: fix 'dma from stack' warning

drivers/staging/media/solo6x10/solo6x10-disp.c:225 solo_set_motion_block() error: potential null dereference 'buf'.  (kzalloc returns null)

vim +/buf +225 drivers/staging/media/solo6x10/solo6x10-disp.c

dcae5dacb drivers/staging/media/solo6x10/disp.c          Hans Verkuil 2013-03-25  209  				   (ch * SOLO_MOT_THRESH_SIZE * 2),
dcae5dacb drivers/staging/media/solo6x10/disp.c          Hans Verkuil 2013-03-25  210  				   val, SOLO_MOT_THRESH_SIZE);
dcae5dacb drivers/staging/media/solo6x10/disp.c          Hans Verkuil 2013-03-25  211  }
dcae5dacb drivers/staging/media/solo6x10/disp.c          Hans Verkuil 2013-03-25  212  
f5df0b7ff drivers/staging/media/solo6x10/disp.c          Hans Verkuil 2013-03-18  213  int solo_set_motion_block(struct solo_dev *solo_dev, u8 ch,
4063a3c78 drivers/staging/media/solo6x10/solo6x10-disp.c Hans Verkuil 2014-06-10  214  		const u16 *thresholds)
dcae5dacb drivers/staging/media/solo6x10/disp.c          Hans Verkuil 2013-03-25  215  {
761f9aa23 drivers/staging/media/solo6x10/solo6x10-disp.c Hans Verkuil 2014-02-07  216  	const unsigned size = sizeof(u16) * 64;
f5df0b7ff drivers/staging/media/solo6x10/disp.c          Hans Verkuil 2013-03-18  217  	u32 off = SOLO_MOT_FLAG_AREA + ch * SOLO_MOT_THRESH_SIZE * 2;
761f9aa23 drivers/staging/media/solo6x10/solo6x10-disp.c Hans Verkuil 2014-02-07  218  	u16 *buf;
f5df0b7ff drivers/staging/media/solo6x10/disp.c          Hans Verkuil 2013-03-18  219  	int x, y;
f5df0b7ff drivers/staging/media/solo6x10/disp.c          Hans Verkuil 2013-03-18  220  	int ret = 0;
dcae5dacb drivers/staging/media/solo6x10/disp.c          Hans Verkuil 2013-03-25  221  
761f9aa23 drivers/staging/media/solo6x10/solo6x10-disp.c Hans Verkuil 2014-02-07  222  	buf = kzalloc(size, GFP_KERNEL);
f5df0b7ff drivers/staging/media/solo6x10/disp.c          Hans Verkuil 2013-03-18  223  	for (y = 0; y < SOLO_MOTION_SZ; y++) {
f5df0b7ff drivers/staging/media/solo6x10/disp.c          Hans Verkuil 2013-03-18  224  		for (x = 0; x < SOLO_MOTION_SZ; x++)
4063a3c78 drivers/staging/media/solo6x10/solo6x10-disp.c Hans Verkuil 2014-06-10 @225  			buf[x] = cpu_to_le16(thresholds[y * SOLO_MOTION_SZ + x]);
f5df0b7ff drivers/staging/media/solo6x10/disp.c          Hans Verkuil 2013-03-18  226  		ret |= solo_p2m_dma(solo_dev, 1, buf,
761f9aa23 drivers/staging/media/solo6x10/solo6x10-disp.c Hans Verkuil 2014-02-07  227  			SOLO_MOTION_EXT_ADDR(solo_dev) + off + y * size,
761f9aa23 drivers/staging/media/solo6x10/solo6x10-disp.c Hans Verkuil 2014-02-07  228  			size, 0, 0);
f5df0b7ff drivers/staging/media/solo6x10/disp.c          Hans Verkuil 2013-03-18  229  	}
761f9aa23 drivers/staging/media/solo6x10/solo6x10-disp.c Hans Verkuil 2014-02-07  230  	kfree(buf);
f5df0b7ff drivers/staging/media/solo6x10/disp.c          Hans Verkuil 2013-03-18  231  	return ret;
faa4fd2a0 drivers/staging/solo6x10/solo6010-disp.c       Ben Collins  2010-06-17  232  }
faa4fd2a0 drivers/staging/solo6x10/solo6010-disp.c       Ben Collins  2010-06-17  233  

:::::: The code at line 225 was first introduced by commit
:::::: 4063a3c781071e46aaf08e79c99ea822cbc0f089 [media] solo6x10: implement the new motion detection controls

:::::: TO: Hans Verkuil <hans.verkuil@cisco.com>
:::::: CC: Mauro Carvalho Chehab <m.chehab@samsung.com>

---
0-DAY kernel build testing backend              Open Source Technology Center
http://lists.01.org/mailman/listinfo/kbuild                 Intel Corporation
