Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:49791 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752554AbaGQX5d (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Jul 2014 19:57:33 -0400
Date: Fri, 18 Jul 2014 07:56:52 +0800
From: kbuild test robot <fengguang.wu@intel.com>
To: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	kbuild-all@01.org
Subject: [linuxtv-media:master 447/499]
 drivers/media/common/saa7146/saa7146_fops.c:536:13: sparse: incorrect type
 in assignment (different base types)
Message-ID: <53c862c4.axXMxgoD8CYYkiCj%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

tree:   git://linuxtv.org/media_tree.git master
head:   0ca1ba2aac5f6b26672099b13040c5b40db93486
commit: d52e23813672c3c72f92e7b39c7408d4b9a40a96 [447/499] [media] v4l: Support extending the v4l2_pix_format structure
reproduce: make C=1 CF=-D__CHECK_ENDIAN__


sparse warnings: (new ones prefixed by >>)

>> drivers/media/common/saa7146/saa7146_fops.c:536:13: sparse: incorrect type in assignment (different base types)
   drivers/media/common/saa7146/saa7146_fops.c:536:13:    expected struct v4l2_pix_format *fmt
   drivers/media/common/saa7146/saa7146_fops.c:536:13:    got struct <noident> *<noident>
   drivers/media/common/saa7146/saa7146_fops.c: In function 'saa7146_vv_init':
   drivers/media/common/saa7146/saa7146_fops.c:536:6: warning: assignment from incompatible pointer type [enabled by default]
     fmt = &vv->ov_fb.fmt;
         ^

vim +536 drivers/media/common/saa7146/saa7146_fops.c

^1da177e4 drivers/media/common/saa7146_fops.c Linus Torvalds        2005-04-16  520  	   configuration data) */
^1da177e4 drivers/media/common/saa7146_fops.c Linus Torvalds        2005-04-16  521  	dev->ext_vv_data = ext_vv;
afd1a0c9a drivers/media/common/saa7146_fops.c Mauro Carvalho Chehab 2005-12-12  522  
afd1a0c9a drivers/media/common/saa7146_fops.c Mauro Carvalho Chehab 2005-12-12  523  	vv->d_clipping.cpu_addr = pci_alloc_consistent(dev->pci, SAA7146_CLIPPING_MEM, &vv->d_clipping.dma_handle);
^1da177e4 drivers/media/common/saa7146_fops.c Linus Torvalds        2005-04-16  524  	if( NULL == vv->d_clipping.cpu_addr ) {
44d0b80e5 drivers/media/common/saa7146_fops.c Joe Perches           2011-08-21  525  		ERR("out of memory. aborting.\n");
^1da177e4 drivers/media/common/saa7146_fops.c Linus Torvalds        2005-04-16  526  		kfree(vv);
6e65ca942 drivers/media/common/saa7146_fops.c Hans Verkuil          2012-04-29  527  		v4l2_ctrl_handler_free(hdl);
^1da177e4 drivers/media/common/saa7146_fops.c Linus Torvalds        2005-04-16  528  		return -1;
^1da177e4 drivers/media/common/saa7146_fops.c Linus Torvalds        2005-04-16  529  	}
^1da177e4 drivers/media/common/saa7146_fops.c Linus Torvalds        2005-04-16  530  	memset(vv->d_clipping.cpu_addr, 0x0, SAA7146_CLIPPING_MEM);
^1da177e4 drivers/media/common/saa7146_fops.c Linus Torvalds        2005-04-16  531  
^1da177e4 drivers/media/common/saa7146_fops.c Linus Torvalds        2005-04-16  532  	saa7146_video_uops.init(dev,vv);
5b0fa4fff drivers/media/common/saa7146_fops.c Oliver Endriss        2006-01-09  533  	if (dev->ext_vv_data->capabilities & V4L2_CAP_VBI_CAPTURE)
5b0fa4fff drivers/media/common/saa7146_fops.c Oliver Endriss        2006-01-09  534  		saa7146_vbi_uops.init(dev,vv);
afd1a0c9a drivers/media/common/saa7146_fops.c Mauro Carvalho Chehab 2005-12-12  535  
5da545ad0 drivers/media/common/saa7146_fops.c Hans Verkuil          2012-05-01 @536  	fmt = &vv->ov_fb.fmt;
5da545ad0 drivers/media/common/saa7146_fops.c Hans Verkuil          2012-05-01  537  	fmt->width = vv->standard->h_max_out;
5da545ad0 drivers/media/common/saa7146_fops.c Hans Verkuil          2012-05-01  538  	fmt->height = vv->standard->v_max_out;
5da545ad0 drivers/media/common/saa7146_fops.c Hans Verkuil          2012-05-01  539  	fmt->pixelformat = V4L2_PIX_FMT_RGB565;
5da545ad0 drivers/media/common/saa7146_fops.c Hans Verkuil          2012-05-01  540  	fmt->bytesperline = 2 * fmt->width;
5da545ad0 drivers/media/common/saa7146_fops.c Hans Verkuil          2012-05-01  541  	fmt->sizeimage = fmt->bytesperline * fmt->height;
5da545ad0 drivers/media/common/saa7146_fops.c Hans Verkuil          2012-05-01  542  	fmt->colorspace = V4L2_COLORSPACE_SRGB;
fd74d6eb4 drivers/media/common/saa7146_fops.c Hans Verkuil          2012-05-01  543  
fd74d6eb4 drivers/media/common/saa7146_fops.c Hans Verkuil          2012-05-01  544  	fmt = &vv->video_fmt;

:::::: The code at line 536 was first introduced by commit
:::::: 5da545ad08a3c6ea71d3ba074adc7582e7e9a024 [media] saa7146: move overlay information from saa7146_fh into saa7146_vv

:::::: TO: Hans Verkuil <hans.verkuil@cisco.com>
:::::: CC: Mauro Carvalho Chehab <mchehab@redhat.com>

---
0-DAY kernel build testing backend              Open Source Technology Center
http://lists.01.org/mailman/listinfo/kbuild                 Intel Corporation
