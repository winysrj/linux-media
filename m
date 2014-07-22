Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:27470 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755822AbaGVRKq (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Jul 2014 13:10:46 -0400
Date: Wed, 23 Jul 2014 01:05:13 +0800
From: kbuild test robot <fengguang.wu@intel.com>
To: Hans Verkuil <hans.verkuil@cisco.com>
Cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	kbuild-all@01.org
Subject: [linuxtv-media:master 498/499]
 drivers/media/pci/solo6x10/solo6x10-core.c:209:48: sparse: incorrect type
 in argument 3 (different base types)
Message-ID: <53ce99c9.nwegfj2hUx9FwIhf%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

tree:   git://linuxtv.org/media_tree.git master
head:   7955f03d18d14d18188f94581a4ea336c94b1e2d
commit: 28cae868cd245b6bb2f27bce807e9d78afcf8ea2 [498/499] [media] solo6x10: move out of staging into drivers/media/pci.
reproduce: make C=1 CF=-D__CHECK_ENDIAN__


sparse warnings: (new ones prefixed by >>)

>> drivers/media/pci/solo6x10/solo6x10-core.c:209:48: sparse: incorrect type in argument 3 (different base types)
   drivers/media/pci/solo6x10/solo6x10-core.c:209:48:    expected unsigned short [unsigned] data
   drivers/media/pci/solo6x10/solo6x10-core.c:209:48:    got restricted __be16 [usertype] <noident>
>> drivers/media/pci/solo6x10/solo6x10-core.c:226:24: sparse: cast to restricted __be16
>> drivers/media/pci/solo6x10/solo6x10-core.c:226:24: sparse: cast to restricted __be16
>> drivers/media/pci/solo6x10/solo6x10-core.c:226:24: sparse: cast to restricted __be16
>> drivers/media/pci/solo6x10/solo6x10-core.c:226:24: sparse: cast to restricted __be16
--
>> drivers/media/pci/solo6x10/solo6x10-disp.c:184:24: sparse: incorrect type in assignment (different base types)
   drivers/media/pci/solo6x10/solo6x10-disp.c:184:24:    expected unsigned short [unsigned] [short] [usertype] <noident>
   drivers/media/pci/solo6x10/solo6x10-disp.c:184:24:    got restricted __le16 [usertype] <noident>
>> drivers/media/pci/solo6x10/solo6x10-disp.c:221:32: sparse: incorrect type in assignment (different base types)
   drivers/media/pci/solo6x10/solo6x10-disp.c:221:32:    expected unsigned short [unsigned] [short] [usertype] <noident>
   drivers/media/pci/solo6x10/solo6x10-disp.c:221:32:    got restricted __le16 [usertype] <noident>

vim +209 drivers/media/pci/solo6x10/solo6x10-core.c

dcae5dac drivers/staging/media/solo6x10/core.c Hans Verkuil 2013-03-25  203  	}
dcae5dac drivers/staging/media/solo6x10/core.c Hans Verkuil 2013-03-25  204  
dcae5dac drivers/staging/media/solo6x10/core.c Hans Verkuil 2013-03-25  205  	solo_eeprom_ewen(solo_dev, 1);
dcae5dac drivers/staging/media/solo6x10/core.c Hans Verkuil 2013-03-25  206  
dcae5dac drivers/staging/media/solo6x10/core.c Hans Verkuil 2013-03-25  207  	for (i = full_eeprom ? 0 : 32; i < min((int)(full_eeprom ? 64 : 32),
dcae5dac drivers/staging/media/solo6x10/core.c Hans Verkuil 2013-03-25  208  					       (int)(count / 2)); i++)
dcae5dac drivers/staging/media/solo6x10/core.c Hans Verkuil 2013-03-25 @209  		solo_eeprom_write(solo_dev, i, cpu_to_be16(p[i]));
dcae5dac drivers/staging/media/solo6x10/core.c Hans Verkuil 2013-03-25  210  
dcae5dac drivers/staging/media/solo6x10/core.c Hans Verkuil 2013-03-25  211  	solo_eeprom_ewen(solo_dev, 0);
dcae5dac drivers/staging/media/solo6x10/core.c Hans Verkuil 2013-03-25  212  
dcae5dac drivers/staging/media/solo6x10/core.c Hans Verkuil 2013-03-25  213  	return count;
dcae5dac drivers/staging/media/solo6x10/core.c Hans Verkuil 2013-03-25  214  }
dcae5dac drivers/staging/media/solo6x10/core.c Hans Verkuil 2013-03-25  215  
dcae5dac drivers/staging/media/solo6x10/core.c Hans Verkuil 2013-03-25  216  static ssize_t eeprom_show(struct device *dev, struct device_attribute *attr,
dcae5dac drivers/staging/media/solo6x10/core.c Hans Verkuil 2013-03-25  217  			   char *buf)
dcae5dac drivers/staging/media/solo6x10/core.c Hans Verkuil 2013-03-25  218  {
dcae5dac drivers/staging/media/solo6x10/core.c Hans Verkuil 2013-03-25  219  	struct solo_dev *solo_dev =
dcae5dac drivers/staging/media/solo6x10/core.c Hans Verkuil 2013-03-25  220  		container_of(dev, struct solo_dev, dev);
dcae5dac drivers/staging/media/solo6x10/core.c Hans Verkuil 2013-03-25  221  	unsigned short *p = (unsigned short *)buf;
dcae5dac drivers/staging/media/solo6x10/core.c Hans Verkuil 2013-03-25  222  	int count = (full_eeprom ? 128 : 64);
dcae5dac drivers/staging/media/solo6x10/core.c Hans Verkuil 2013-03-25  223  	int i;
dcae5dac drivers/staging/media/solo6x10/core.c Hans Verkuil 2013-03-25  224  
dcae5dac drivers/staging/media/solo6x10/core.c Hans Verkuil 2013-03-25  225  	for (i = (full_eeprom ? 0 : 32); i < (count / 2); i++)
dcae5dac drivers/staging/media/solo6x10/core.c Hans Verkuil 2013-03-25 @226  		p[i] = be16_to_cpu(solo_eeprom_read(solo_dev, i));
dcae5dac drivers/staging/media/solo6x10/core.c Hans Verkuil 2013-03-25  227  
dcae5dac drivers/staging/media/solo6x10/core.c Hans Verkuil 2013-03-25  228  	return count;
dcae5dac drivers/staging/media/solo6x10/core.c Hans Verkuil 2013-03-25  229  }

:::::: The code at line 209 was first introduced by commit
:::::: dcae5dacbce518513abf7776cb450b7bd95d722b [media] solo6x10: sync to latest code from Bluecherry's git repo

:::::: TO: Hans Verkuil <hans.verkuil@cisco.com>
:::::: CC: Mauro Carvalho Chehab <mchehab@redhat.com>

---
0-DAY kernel build testing backend              Open Source Technology Center
http://lists.01.org/mailman/listinfo/kbuild                 Intel Corporation
