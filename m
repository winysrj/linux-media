Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:53718 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758404AbaGYLAY (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 25 Jul 2014 07:00:24 -0400
Date: Fri, 25 Jul 2014 18:59:51 +0800
From: kbuild test robot <fengguang.wu@intel.com>
To: Hans Verkuil <hans.verkuil@cisco.com>
Cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	kbuild-all@01.org
Subject: [next:master 7707/8903]
 drivers/media/pci/solo6x10/solo6x10-disp.c:221 solo_set_motion_block()
 error: potential null dereference 'buf'.  (kzalloc returns null)
Message-ID: <53d238a7.cWfe7UU8B1D3GsMg%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

tree:   git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
head:   5a7439efd1c5c416f768fc550048ca130cf4bf99
commit: 28cae868cd245b6bb2f27bce807e9d78afcf8ea2 [7707/8903] [media] solo6x10: move out of staging into drivers/media/pci.

drivers/media/pci/solo6x10/solo6x10-disp.c:221 solo_set_motion_block() error: potential null dereference 'buf'.  (kzalloc returns null)

vim +/buf +221 drivers/media/pci/solo6x10/solo6x10-disp.c

dcae5dacb drivers/staging/media/solo6x10/disp.c          Hans Verkuil 2013-03-25  205  				   (ch * SOLO_MOT_THRESH_SIZE * 2),
dcae5dacb drivers/staging/media/solo6x10/disp.c          Hans Verkuil 2013-03-25  206  				   val, SOLO_MOT_THRESH_SIZE);
dcae5dacb drivers/staging/media/solo6x10/disp.c          Hans Verkuil 2013-03-25  207  }
dcae5dacb drivers/staging/media/solo6x10/disp.c          Hans Verkuil 2013-03-25  208  
f5df0b7ff drivers/staging/media/solo6x10/disp.c          Hans Verkuil 2013-03-18  209  int solo_set_motion_block(struct solo_dev *solo_dev, u8 ch,
4063a3c78 drivers/staging/media/solo6x10/solo6x10-disp.c Hans Verkuil 2014-06-10  210  		const u16 *thresholds)
dcae5dacb drivers/staging/media/solo6x10/disp.c          Hans Verkuil 2013-03-25  211  {
761f9aa23 drivers/staging/media/solo6x10/solo6x10-disp.c Hans Verkuil 2014-02-07  212  	const unsigned size = sizeof(u16) * 64;
f5df0b7ff drivers/staging/media/solo6x10/disp.c          Hans Verkuil 2013-03-18  213  	u32 off = SOLO_MOT_FLAG_AREA + ch * SOLO_MOT_THRESH_SIZE * 2;
761f9aa23 drivers/staging/media/solo6x10/solo6x10-disp.c Hans Verkuil 2014-02-07  214  	u16 *buf;
f5df0b7ff drivers/staging/media/solo6x10/disp.c          Hans Verkuil 2013-03-18  215  	int x, y;
f5df0b7ff drivers/staging/media/solo6x10/disp.c          Hans Verkuil 2013-03-18  216  	int ret = 0;
dcae5dacb drivers/staging/media/solo6x10/disp.c          Hans Verkuil 2013-03-25  217  
761f9aa23 drivers/staging/media/solo6x10/solo6x10-disp.c Hans Verkuil 2014-02-07  218  	buf = kzalloc(size, GFP_KERNEL);
f5df0b7ff drivers/staging/media/solo6x10/disp.c          Hans Verkuil 2013-03-18  219  	for (y = 0; y < SOLO_MOTION_SZ; y++) {
f5df0b7ff drivers/staging/media/solo6x10/disp.c          Hans Verkuil 2013-03-18  220  		for (x = 0; x < SOLO_MOTION_SZ; x++)
4063a3c78 drivers/staging/media/solo6x10/solo6x10-disp.c Hans Verkuil 2014-06-10 @221  			buf[x] = cpu_to_le16(thresholds[y * SOLO_MOTION_SZ + x]);
f5df0b7ff drivers/staging/media/solo6x10/disp.c          Hans Verkuil 2013-03-18  222  		ret |= solo_p2m_dma(solo_dev, 1, buf,
761f9aa23 drivers/staging/media/solo6x10/solo6x10-disp.c Hans Verkuil 2014-02-07  223  			SOLO_MOTION_EXT_ADDR(solo_dev) + off + y * size,
761f9aa23 drivers/staging/media/solo6x10/solo6x10-disp.c Hans Verkuil 2014-02-07  224  			size, 0, 0);
f5df0b7ff drivers/staging/media/solo6x10/disp.c          Hans Verkuil 2013-03-18  225  	}
761f9aa23 drivers/staging/media/solo6x10/solo6x10-disp.c Hans Verkuil 2014-02-07  226  	kfree(buf);
f5df0b7ff drivers/staging/media/solo6x10/disp.c          Hans Verkuil 2013-03-18  227  	return ret;
faa4fd2a0 drivers/staging/solo6x10/solo6010-disp.c       Ben Collins  2010-06-17  228  }
faa4fd2a0 drivers/staging/solo6x10/solo6010-disp.c       Ben Collins  2010-06-17  229  

:::::: The code at line 221 was first introduced by commit
:::::: 4063a3c781071e46aaf08e79c99ea822cbc0f089 [media] solo6x10: implement the new motion detection controls

:::::: TO: Hans Verkuil <hans.verkuil@cisco.com>
:::::: CC: Mauro Carvalho Chehab <m.chehab@samsung.com>

---
0-DAY kernel build testing backend              Open Source Technology Center
http://lists.01.org/mailman/listinfo/kbuild                 Intel Corporation
