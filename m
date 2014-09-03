Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:29874 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932677AbaICPav (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 3 Sep 2014 11:30:51 -0400
Date: Wed, 03 Sep 2014 23:29:49 +0800
From: kbuild test robot <fengguang.wu@intel.com>
To: Hans Verkuil <hans.verkuil@cisco.com>
Cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	kbuild-all@01.org
Subject: [linuxtv-media:master 472/499]
 drivers/media/pci/ngene/ngene-dvb.c:62:48: sparse: incorrect type in
 argument 2 (different address spaces)
Message-ID: <540733ed.oP1QyJUJb3MBkYE1%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

tree:   git://linuxtv.org/media_tree.git master
head:   fe10b84e7f6c4c8c3dc8cf63be324bc13f5acd68
commit: c463c9797c43dd66b72daa397716d6c6675087b8 [472/499] [media] ngene: fix sparse warnings
reproduce: make C=1 CF=-D__CHECK_ENDIAN__


sparse warnings: (new ones prefixed by >>)

>> drivers/media/pci/ngene/ngene-dvb.c:62:48: sparse: incorrect type in argument 2 (different address spaces)
   drivers/media/pci/ngene/ngene-dvb.c:62:48:    expected unsigned char const [usertype] *buf
   drivers/media/pci/ngene/ngene-dvb.c:62:48:    got char const [noderef] <asn:1>*buf

vim +62 drivers/media/pci/ngene/ngene-dvb.c

1899e97c drivers/media/dvb/ngene/ngene-dvb.c Devin Heitmueller 2010-03-13  46  /****************************************************************************/
1899e97c drivers/media/dvb/ngene/ngene-dvb.c Devin Heitmueller 2010-03-13  47  /* COMMAND API interface ****************************************************/
1899e97c drivers/media/dvb/ngene/ngene-dvb.c Devin Heitmueller 2010-03-13  48  /****************************************************************************/
1899e97c drivers/media/dvb/ngene/ngene-dvb.c Devin Heitmueller 2010-03-13  49  
c463c979 drivers/media/pci/ngene/ngene-dvb.c Hans Verkuil      2014-08-20  50  static ssize_t ts_write(struct file *file, const char __user *buf,
0f0b270f drivers/media/dvb/ngene/ngene-dvb.c Ralph Metzler     2011-01-10  51  			size_t count, loff_t *ppos)
0f0b270f drivers/media/dvb/ngene/ngene-dvb.c Ralph Metzler     2011-01-10  52  {
0f0b270f drivers/media/dvb/ngene/ngene-dvb.c Ralph Metzler     2011-01-10  53  	struct dvb_device *dvbdev = file->private_data;
0f0b270f drivers/media/dvb/ngene/ngene-dvb.c Ralph Metzler     2011-01-10  54  	struct ngene_channel *chan = dvbdev->priv;
0f0b270f drivers/media/dvb/ngene/ngene-dvb.c Ralph Metzler     2011-01-10  55  	struct ngene *dev = chan->dev;
0f0b270f drivers/media/dvb/ngene/ngene-dvb.c Ralph Metzler     2011-01-10  56  
0f0b270f drivers/media/dvb/ngene/ngene-dvb.c Ralph Metzler     2011-01-10  57  	if (wait_event_interruptible(dev->tsout_rbuf.queue,
0f0b270f drivers/media/dvb/ngene/ngene-dvb.c Ralph Metzler     2011-01-10  58  				     dvb_ringbuffer_free
0f0b270f drivers/media/dvb/ngene/ngene-dvb.c Ralph Metzler     2011-01-10  59  				     (&dev->tsout_rbuf) >= count) < 0)
0f0b270f drivers/media/dvb/ngene/ngene-dvb.c Ralph Metzler     2011-01-10  60  		return 0;
0f0b270f drivers/media/dvb/ngene/ngene-dvb.c Ralph Metzler     2011-01-10  61  
0f0b270f drivers/media/dvb/ngene/ngene-dvb.c Ralph Metzler     2011-01-10 @62  	dvb_ringbuffer_write(&dev->tsout_rbuf, buf, count);
0f0b270f drivers/media/dvb/ngene/ngene-dvb.c Ralph Metzler     2011-01-10  63  
0f0b270f drivers/media/dvb/ngene/ngene-dvb.c Ralph Metzler     2011-01-10  64  	return count;
0f0b270f drivers/media/dvb/ngene/ngene-dvb.c Ralph Metzler     2011-01-10  65  }
0f0b270f drivers/media/dvb/ngene/ngene-dvb.c Ralph Metzler     2011-01-10  66  
c463c979 drivers/media/pci/ngene/ngene-dvb.c Hans Verkuil      2014-08-20  67  static ssize_t ts_read(struct file *file, char __user *buf,
0f0b270f drivers/media/dvb/ngene/ngene-dvb.c Ralph Metzler     2011-01-10  68  		       size_t count, loff_t *ppos)
0f0b270f drivers/media/dvb/ngene/ngene-dvb.c Ralph Metzler     2011-01-10  69  {
0f0b270f drivers/media/dvb/ngene/ngene-dvb.c Ralph Metzler     2011-01-10  70  	struct dvb_device *dvbdev = file->private_data;

:::::: The code at line 62 was first introduced by commit
:::::: 0f0b270f905bbb0c8e75988ceaf10ff9a401e712 [media] ngene: CXD2099AR Common Interface driver

:::::: TO: Ralph Metzler <rjkm@metzlerbros.de>
:::::: CC: Mauro Carvalho Chehab <mchehab@redhat.com>

---
0-DAY kernel build testing backend              Open Source Technology Center
http://lists.01.org/mailman/listinfo/kbuild                 Intel Corporation
