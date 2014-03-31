Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:39392 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752167AbaCaLHg (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 31 Mar 2014 07:07:36 -0400
Date: Mon, 31 Mar 2014 19:07:31 +0800
From: kbuild test robot <fengguang.wu@intel.com>
To: Antti Palosaari <crope@iki.fi>
Cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	kbuild-all@01.org
Subject: [linuxtv-media:master 499/499]
 drivers/media/usb/em28xx/em28xx-dvb.c:1632:31: error: 'dvb' undeclared
Message-ID: <53394c73.lmpJ44I+UpInrRVo%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

tree:   git://linuxtv.org/media_tree.git master
head:   84bc08734bb2735aa7cac30d3250e07031dac503
commit: 84bc08734bb2735aa7cac30d3250e07031dac503 [499/499] [media] em28xx-dvb: fix PCTV 461e tuner I2C binding
config: make ARCH=mips allmodconfig

All error/warnings:

   drivers/media/usb/em28xx/em28xx-dvb.c: In function 'em28xx_dvb_resume':
>> drivers/media/usb/em28xx/em28xx-dvb.c:1632:31: error: 'dvb' undeclared (first use in this function)
   drivers/media/usb/em28xx/em28xx-dvb.c:1632:31: note: each undeclared identifier is reported only once for each function it appears in

vim +/dvb +1632 drivers/media/usb/em28xx/em28xx-dvb.c

  1626	
  1627		if (!dev->board.has_dvb)
  1628			return 0;
  1629	
  1630		em28xx_info("Resuming DVB extension");
  1631		if (dev->dvb) {
> 1632			struct i2c_client *client = dvb->i2c_client_tuner;
  1633			struct em28xx_dvb *dvb = dev->dvb;
  1634	
  1635			if (dvb->fe[0]) {

---
0-DAY kernel build testing backend              Open Source Technology Center
http://lists.01.org/mailman/listinfo/kbuild                 Intel Corporation
