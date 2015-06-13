Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:60210 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753534AbbFMBvu (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Jun 2015 21:51:50 -0400
Date: Sat, 13 Jun 2015 09:50:27 +0800
From: kbuild test robot <fengguang.wu@intel.com>
To: Antti Palosaari <crope@iki.fi>
Cc: kbuild-all@01.org, Mauro Carvalho Chehab <m.chehab@samsung.com>,
	linux-media@vger.kernel.org
Subject: drivers/media/dvb-frontends/rtl2832_sdr.c:1435:3-8: No need to set
 .owner here. The core will do it.
Message-ID: <201506130925.Yk1cM7D4%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

tree:   git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master
head:   b85dfd30cb37318587018ee430c2c1cfabf3dabc
commit: 63bdab5d31b987c5ccb81c3c6662016d07cbb5b7 [media] rtl2832_sdr: convert to platform driver
date:   4 months ago


coccinelle warnings: (new ones prefixed by >>)

>> drivers/media/dvb-frontends/rtl2832_sdr.c:1435:3-8: No need to set .owner here. The core will do it.

vim +1435 drivers/media/dvb-frontends/rtl2832_sdr.c

  1419		mutex_lock(&dev->v4l2_lock);
  1420		/* No need to keep the urbs around after disconnection */
  1421		dev->udev = NULL;
  1422		v4l2_device_disconnect(&dev->v4l2_dev);
  1423		video_unregister_device(&dev->vdev);
  1424		mutex_unlock(&dev->v4l2_lock);
  1425		mutex_unlock(&dev->vb_queue_lock);
  1426	
  1427		v4l2_device_put(&dev->v4l2_dev);
  1428	
  1429		return 0;
  1430	}
  1431	
  1432	static struct platform_driver rtl2832_sdr_driver = {
  1433		.driver = {
  1434			.name   = "rtl2832_sdr",
> 1435			.owner  = THIS_MODULE,
  1436		},
  1437		.probe          = rtl2832_sdr_probe,
  1438		.remove         = rtl2832_sdr_remove,
  1439	};
  1440	module_platform_driver(rtl2832_sdr_driver);
  1441	
  1442	MODULE_AUTHOR("Antti Palosaari <crope@iki.fi>");
  1443	MODULE_DESCRIPTION("Realtek RTL2832 SDR driver");

---
0-DAY kernel test infrastructure                Open Source Technology Center
http://lists.01.org/mailman/listinfo/kbuild                 Intel Corporation
