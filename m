Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:58835 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751125AbaC1WPC (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 28 Mar 2014 18:15:02 -0400
Date: Sat, 29 Mar 2014 06:14:35 +0800
From: kbuild test robot <fengguang.wu@intel.com>
To: Antti Palosaari <crope@iki.fi>
Cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	kbuild-all@01.org
Subject: [linuxtv-media:master 498/499]
 drivers/media/usb/em28xx/em28xx-dvb.c:1644:7: error: 'client' undeclared
Message-ID: <5335f44b.JyrHAUc9hHNV9Qeg%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

tree:   git://linuxtv.org/media_tree.git master
head:   3ec40dcfb413214b2874aec858870502b61c2202
commit: 37571b163c15831cd0a213151c21387363dbf15b [498/499] [media] em28xx-dvb: fix PCTV 461e tuner I2C binding
config: make ARCH=powerpc allmodconfig

All error/warnings:

   drivers/media/usb/em28xx/em28xx-dvb.c: In function 'em28xx_dvb_suspend':
   drivers/media/usb/em28xx/em28xx-dvb.c:1605:22: warning: unused variable 'client' [-Wunused-variable]
      struct i2c_client *client = dvb->i2c_client_tuner;
                         ^
   drivers/media/usb/em28xx/em28xx-dvb.c: In function 'em28xx_dvb_resume':
>> drivers/media/usb/em28xx/em28xx-dvb.c:1644:7: error: 'client' undeclared (first use in this function)
      if (client) {
          ^
   drivers/media/usb/em28xx/em28xx-dvb.c:1644:7: note: each undeclared identifier is reported only once for each function it appears in

vim +/client +1644 drivers/media/usb/em28xx/em28xx-dvb.c

  1599		if (!dev->board.has_dvb)
  1600			return 0;
  1601	
  1602		em28xx_info("Suspending DVB extension");
  1603		if (dev->dvb) {
  1604			struct em28xx_dvb *dvb = dev->dvb;
> 1605			struct i2c_client *client = dvb->i2c_client_tuner;
  1606	
  1607			if (dvb->fe[0]) {
  1608				ret = dvb_frontend_suspend(dvb->fe[0]);
  1609				em28xx_info("fe0 suspend %d", ret);
  1610			}
  1611			if (dvb->fe[1]) {
  1612				dvb_frontend_suspend(dvb->fe[1]);
  1613				em28xx_info("fe1 suspend %d", ret);
  1614			}
  1615		}
  1616	
  1617		return 0;
  1618	}
  1619	
  1620	static int em28xx_dvb_resume(struct em28xx *dev)
  1621	{
  1622		int ret = 0;
  1623	
  1624		if (dev->is_audio_only)
  1625			return 0;
  1626	
  1627		if (!dev->board.has_dvb)
  1628			return 0;
  1629	
  1630		em28xx_info("Resuming DVB extension");
  1631		if (dev->dvb) {
  1632			struct em28xx_dvb *dvb = dev->dvb;
  1633	
  1634			if (dvb->fe[0]) {
  1635				ret = dvb_frontend_resume(dvb->fe[0]);
  1636				em28xx_info("fe0 resume %d", ret);
  1637			}
  1638	
  1639			if (dvb->fe[1]) {
  1640				ret = dvb_frontend_resume(dvb->fe[1]);
  1641				em28xx_info("fe1 resume %d", ret);
  1642			}
  1643			/* remove I2C tuner */
> 1644			if (client) {
  1645				module_put(client->dev.driver->owner);
  1646				i2c_unregister_device(client);
  1647			}

---
0-DAY kernel build testing backend              Open Source Technology Center
http://lists.01.org/mailman/listinfo/kbuild                 Intel Corporation
