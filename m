Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:22270 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753081AbbEUL6o (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 21 May 2015 07:58:44 -0400
Date: Thu, 21 May 2015 19:57:31 +0800
From: kbuild test robot <fengguang.wu@intel.com>
To: Hans Verkuil <hans.verkuil@cisco.com>
Cc: kbuild-all@01.org, Mauro Carvalho Chehab <m.chehab@samsung.com>,
	linux-media@vger.kernel.org
Subject: [linuxtv-media:master 1023/1029]
 drivers/media/pci/cobalt/cobalt-driver.c:299:32: sparse: Using plain integer
 as NULL pointer
Message-ID: <201505211929.N8zRNMzt%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

tree:   git://linuxtv.org/media_tree.git master
head:   2a80f296422a01178d0a993479369e94f5830127
commit: 85756a069c55e0315ac5990806899cfb607b987f [1023/1029] [media] cobalt: add new driver
reproduce:
  # apt-get install sparse
  git checkout 85756a069c55e0315ac5990806899cfb607b987f
  make ARCH=x86_64 allmodconfig
  make C=1 CF=-D__CHECK_ENDIAN__


sparse warnings: (new ones prefixed by >>)

>> drivers/media/pci/cobalt/cobalt-driver.c:299:32: sparse: Using plain integer as NULL pointer
>> drivers/media/pci/cobalt/cobalt-driver.c:303:32: sparse: Using plain integer as NULL pointer
--
>> drivers/media/pci/cobalt/cobalt-flash.c:39:36: sparse: incorrect type in initializer (different address spaces)
   drivers/media/pci/cobalt/cobalt-flash.c:39:36:    expected struct cobalt *cobalt
   drivers/media/pci/cobalt/cobalt-flash.c:39:36:    got void [noderef] <asn:2>*virt
>> drivers/media/pci/cobalt/cobalt-flash.c:54:36: sparse: incorrect type in initializer (different address spaces)
   drivers/media/pci/cobalt/cobalt-flash.c:54:36:    expected struct cobalt *cobalt
   drivers/media/pci/cobalt/cobalt-flash.c:54:36:    got void [noderef] <asn:2>*virt
>> drivers/media/pci/cobalt/cobalt-flash.c:63:36: sparse: incorrect type in initializer (different address spaces)
   drivers/media/pci/cobalt/cobalt-flash.c:63:36:    expected struct cobalt *cobalt
   drivers/media/pci/cobalt/cobalt-flash.c:63:36:    got void [noderef] <asn:2>*virt
>> drivers/media/pci/cobalt/cobalt-flash.c:82:36: sparse: incorrect type in initializer (different address spaces)
   drivers/media/pci/cobalt/cobalt-flash.c:82:36:    expected struct cobalt *cobalt
   drivers/media/pci/cobalt/cobalt-flash.c:82:36:    got void [noderef] <asn:2>*virt
>> drivers/media/pci/cobalt/cobalt-flash.c:107:19: sparse: incorrect type in assignment (different address spaces)
   drivers/media/pci/cobalt/cobalt-flash.c:107:19:    expected void [noderef] <asn:2>*virt
   drivers/media/pci/cobalt/cobalt-flash.c:107:19:    got struct cobalt *cobalt
--
>> drivers/media/pci/cobalt/cobalt-i2c.c:130:17: sparse: dereference of noderef expression
>> drivers/media/pci/cobalt/cobalt-i2c.c:147:17: sparse: dereference of noderef expression
>> drivers/media/pci/cobalt/cobalt-i2c.c:151:26: sparse: dereference of noderef expression
>> drivers/media/pci/cobalt/cobalt-i2c.c:156:34: sparse: dereference of noderef expression
>> drivers/media/pci/cobalt/cobalt-i2c.c:206:17: sparse: dereference of noderef expression
>> drivers/media/pci/cobalt/cobalt-i2c.c:210:26: sparse: dereference of noderef expression
>> drivers/media/pci/cobalt/cobalt-i2c.c:215:34: sparse: dereference of noderef expression
>> drivers/media/pci/cobalt/cobalt-i2c.c:225:27: sparse: dereference of noderef expression
>> drivers/media/pci/cobalt/cobalt-i2c.c:335:17: sparse: dereference of noderef expression
>> drivers/media/pci/cobalt/cobalt-i2c.c:336:17: sparse: dereference of noderef expression
>> drivers/media/pci/cobalt/cobalt-i2c.c:337:17: sparse: dereference of noderef expression
>> drivers/media/pci/cobalt/cobalt-i2c.c:348:34: sparse: dereference of noderef expression
>> drivers/media/pci/cobalt/cobalt-i2c.c:352:17: sparse: dereference of noderef expression
>> drivers/media/pci/cobalt/cobalt-i2c.c:353:17: sparse: dereference of noderef expression
>> drivers/media/pci/cobalt/cobalt-i2c.c:356:17: sparse: dereference of noderef expression
>> drivers/media/pci/cobalt/cobalt-i2c.c:357:17: sparse: dereference of noderef expression
>> drivers/media/pci/cobalt/cobalt-i2c.c:359:17: sparse: dereference of noderef expression
--
>> drivers/media/pci/cobalt/cobalt-irq.c:62:33: sparse: dereference of noderef expression
>> drivers/media/pci/cobalt/cobalt-irq.c:64:17: sparse: dereference of noderef expression
>> drivers/media/pci/cobalt/cobalt-irq.c:65:23: sparse: dereference of noderef expression
>> drivers/media/pci/cobalt/cobalt-irq.c:72:21: sparse: dereference of noderef expression
>> drivers/media/pci/cobalt/cobalt-irq.c:73:25: sparse: dereference of noderef expression
>> drivers/media/pci/cobalt/cobalt-irq.c:74:25: sparse: dereference of noderef expression
>> drivers/media/pci/cobalt/cobalt-irq.c:82:33: sparse: dereference of noderef expression
>> drivers/media/pci/cobalt/cobalt-irq.c:83:33: sparse: dereference of noderef expression
>> drivers/media/pci/cobalt/cobalt-irq.c:91:25: sparse: dereference of noderef expression
>> drivers/media/pci/cobalt/cobalt-irq.c:94:23: sparse: dereference of noderef expression
>> drivers/media/pci/cobalt/cobalt-irq.c:103:25: sparse: dereference of noderef expression
>> drivers/media/pci/cobalt/cobalt-irq.c:107:17: sparse: dereference of noderef expression
>> drivers/media/pci/cobalt/cobalt-irq.c:109:17: sparse: dereference of noderef expression
>> drivers/media/pci/cobalt/cobalt-irq.c:116:13: sparse: dereference of noderef expression
>> drivers/media/pci/cobalt/cobalt-irq.c:119:17: sparse: dereference of noderef expression
>> drivers/media/pci/cobalt/cobalt-irq.c:120:17: sparse: dereference of noderef expression
>> drivers/media/pci/cobalt/cobalt-irq.c:122:17: sparse: dereference of noderef expression
--
>> drivers/media/pci/cobalt/cobalt-v4l2.c:188:9: sparse: dereference of noderef expression
>> drivers/media/pci/cobalt/cobalt-v4l2.c:190:9: sparse: dereference of noderef expression
>> drivers/media/pci/cobalt/cobalt-v4l2.c:191:9: sparse: dereference of noderef expression
>> drivers/media/pci/cobalt/cobalt-v4l2.c:192:9: sparse: dereference of noderef expression
>> drivers/media/pci/cobalt/cobalt-v4l2.c:193:9: sparse: dereference of noderef expression
>> drivers/media/pci/cobalt/cobalt-v4l2.c:194:9: sparse: dereference of noderef expression
>> drivers/media/pci/cobalt/cobalt-v4l2.c:195:9: sparse: dereference of noderef expression
>> drivers/media/pci/cobalt/cobalt-v4l2.c:196:9: sparse: dereference of noderef expression
>> drivers/media/pci/cobalt/cobalt-v4l2.c:197:9: sparse: dereference of noderef expression
>> drivers/media/pci/cobalt/cobalt-v4l2.c:198:9: sparse: dereference of noderef expression
>> drivers/media/pci/cobalt/cobalt-v4l2.c:200:9: sparse: dereference of noderef expression
>> drivers/media/pci/cobalt/cobalt-v4l2.c:201:9: sparse: dereference of noderef expression
>> drivers/media/pci/cobalt/cobalt-v4l2.c:202:9: sparse: dereference of noderef expression
>> drivers/media/pci/cobalt/cobalt-v4l2.c:233:17: sparse: dereference of noderef expression
>> drivers/media/pci/cobalt/cobalt-v4l2.c:239:17: sparse: dereference of noderef expression
>> drivers/media/pci/cobalt/cobalt-v4l2.c:245:17: sparse: dereference of noderef expression
>> drivers/media/pci/cobalt/cobalt-v4l2.c:265:17: sparse: dereference of noderef expression
>> drivers/media/pci/cobalt/cobalt-v4l2.c:266:17: sparse: dereference of noderef expression
>> drivers/media/pci/cobalt/cobalt-v4l2.c:270:28: sparse: dereference of noderef expression
>> drivers/media/pci/cobalt/cobalt-v4l2.c:274:17: sparse: dereference of noderef expression
>> drivers/media/pci/cobalt/cobalt-v4l2.c:275:17: sparse: dereference of noderef expression
>> drivers/media/pci/cobalt/cobalt-v4l2.c:311:9: sparse: dereference of noderef expression
>> drivers/media/pci/cobalt/cobalt-v4l2.c:312:9: sparse: dereference of noderef expression
>> drivers/media/pci/cobalt/cobalt-v4l2.c:313:9: sparse: dereference of noderef expression
>> drivers/media/pci/cobalt/cobalt-v4l2.c:314:9: sparse: dereference of noderef expression
>> drivers/media/pci/cobalt/cobalt-v4l2.c:316:9: sparse: dereference of noderef expression
>> drivers/media/pci/cobalt/cobalt-v4l2.c:319:9: sparse: dereference of noderef expression
>> drivers/media/pci/cobalt/cobalt-v4l2.c:320:9: sparse: dereference of noderef expression
>> drivers/media/pci/cobalt/cobalt-v4l2.c:320:36: sparse: dereference of noderef expression
>> drivers/media/pci/cobalt/cobalt-v4l2.c:323:9: sparse: dereference of noderef expression
>> drivers/media/pci/cobalt/cobalt-v4l2.c:326:9: sparse: dereference of noderef expression
>> drivers/media/pci/cobalt/cobalt-v4l2.c:327:9: sparse: dereference of noderef expression
>> drivers/media/pci/cobalt/cobalt-v4l2.c:327:34: sparse: dereference of noderef expression
>> drivers/media/pci/cobalt/cobalt-v4l2.c:328:9: sparse: dereference of noderef expression
>> drivers/media/pci/cobalt/cobalt-v4l2.c:330:9: sparse: dereference of noderef expression
>> drivers/media/pci/cobalt/cobalt-v4l2.c:331:9: sparse: dereference of noderef expression
>> drivers/media/pci/cobalt/cobalt-v4l2.c:333:9: sparse: dereference of noderef expression
>> drivers/media/pci/cobalt/cobalt-v4l2.c:334:9: sparse: dereference of noderef expression
>> drivers/media/pci/cobalt/cobalt-v4l2.c:335:9: sparse: dereference of noderef expression
>> drivers/media/pci/cobalt/cobalt-v4l2.c:361:17: sparse: dereference of noderef expression
>> drivers/media/pci/cobalt/cobalt-v4l2.c:366:17: sparse: dereference of noderef expression
>> drivers/media/pci/cobalt/cobalt-v4l2.c:367:17: sparse: dereference of noderef expression
>> drivers/media/pci/cobalt/cobalt-v4l2.c:419:9: sparse: dereference of noderef expression
>> drivers/media/pci/cobalt/cobalt-v4l2.c:420:9: sparse: dereference of noderef expression
>> drivers/media/pci/cobalt/cobalt-v4l2.c:421:9: sparse: dereference of noderef expression
>> drivers/media/pci/cobalt/cobalt-v4l2.c:422:9: sparse: dereference of noderef expression
>> drivers/media/pci/cobalt/cobalt-v4l2.c:515:9: sparse: dereference of noderef expression
>> drivers/media/pci/cobalt/cobalt-v4l2.c:515:9: sparse: dereference of noderef expression
>> drivers/media/pci/cobalt/cobalt-v4l2.c:517:9: sparse: dereference of noderef expression
>> drivers/media/pci/cobalt/cobalt-v4l2.c:517:9: sparse: dereference of noderef expression
>> drivers/media/pci/cobalt/cobalt-v4l2.c:517:9: sparse: dereference of noderef expression
>> drivers/media/pci/cobalt/cobalt-v4l2.c:524:9: sparse: dereference of noderef expression
>> drivers/media/pci/cobalt/cobalt-v4l2.c:524:9: sparse: dereference of noderef expression
>> drivers/media/pci/cobalt/cobalt-v4l2.c:530:9: sparse: dereference of noderef expression
>> drivers/media/pci/cobalt/cobalt-v4l2.c:530:9: sparse: dereference of noderef expression
>> drivers/media/pci/cobalt/cobalt-v4l2.c:530:9: sparse: dereference of noderef expression
>> drivers/media/pci/cobalt/cobalt-v4l2.c:530:9: sparse: dereference of noderef expression
>> drivers/media/pci/cobalt/cobalt-v4l2.c:530:9: sparse: dereference of noderef expression
>> drivers/media/pci/cobalt/cobalt-v4l2.c:530:9: sparse: dereference of noderef expression
>> drivers/media/pci/cobalt/cobalt-v4l2.c:530:9: sparse: dereference of noderef expression
>> drivers/media/pci/cobalt/cobalt-v4l2.c:545:9: sparse: dereference of noderef expression
>> drivers/media/pci/cobalt/cobalt-v4l2.c:545:9: sparse: dereference of noderef expression
>> drivers/media/pci/cobalt/cobalt-v4l2.c:547:9: sparse: dereference of noderef expression
>> drivers/media/pci/cobalt/cobalt-v4l2.c:548:9: sparse: dereference of noderef expression
>> drivers/media/pci/cobalt/cobalt-v4l2.c:549:9: sparse: dereference of noderef expression
>> drivers/media/pci/cobalt/cobalt-v4l2.c:550:9: sparse: dereference of noderef expression
>> drivers/media/pci/cobalt/cobalt-v4l2.c:551:9: sparse: dereference of noderef expression
>> drivers/media/pci/cobalt/cobalt-v4l2.c:552:9: sparse: dereference of noderef expression
>> drivers/media/pci/cobalt/cobalt-v4l2.c:553:9: sparse: dereference of noderef expression
>> drivers/media/pci/cobalt/cobalt-v4l2.c:554:9: sparse: dereference of noderef expression
>> drivers/media/pci/cobalt/cobalt-v4l2.c:555:9: sparse: dereference of noderef expression
>> drivers/media/pci/cobalt/cobalt-v4l2.c:555:9: sparse: dereference of noderef expression
>> drivers/media/pci/cobalt/cobalt-v4l2.c:555:9: sparse: dereference of noderef expression
>> drivers/media/pci/cobalt/cobalt-v4l2.c:562:9: sparse: dereference of noderef expression
>> drivers/media/pci/cobalt/cobalt-v4l2.c:563:9: sparse: dereference of noderef expression
>> drivers/media/pci/cobalt/cobalt-v4l2.c:563:9: sparse: dereference of noderef expression
>> drivers/media/pci/cobalt/cobalt-v4l2.c:568:9: sparse: dereference of noderef expression
>> drivers/media/pci/cobalt/cobalt-v4l2.c:594:16: sparse: dereference of noderef expression
>> drivers/media/pci/cobalt/cobalt-v4l2.c:601:9: sparse: dereference of noderef expression

vim +299 drivers/media/pci/cobalt/cobalt-driver.c

   293	}
   294	
   295	static void cobalt_pci_iounmap(struct cobalt *cobalt, struct pci_dev *pci_dev)
   296	{
   297		if (cobalt->bar0) {
   298			pci_iounmap(pci_dev, cobalt->bar0);
 > 299			cobalt->bar0 = 0;
   300		}
   301		if (cobalt->bar1) {
   302			pci_iounmap(pci_dev, cobalt->bar1);
 > 303			cobalt->bar1 = 0;
   304		}
   305	}
   306	

---
0-DAY kernel test infrastructure                Open Source Technology Center
http://lists.01.org/mailman/listinfo/kbuild                 Intel Corporation
