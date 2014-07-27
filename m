Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:3400 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752546AbaG0Vp0 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 27 Jul 2014 17:45:26 -0400
Date: Mon, 28 Jul 2014 05:46:27 +0800
From: kbuild test robot <fengguang.wu@intel.com>
To: Matthias Schwarzott <zzam@gentoo.org>
Cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	kbuild-all@01.org
Subject: [linuxtv-media:master 491/499]
 drivers/media/usb/cx231xx/cx231xx-dvb.c:736:57: sparse: Using plain integer as NULL pointer
Message-ID: <53d57333.t2tfrMIjA1X+YD5H%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

tree:   git://linuxtv.org/media_tree.git master
head:   0a12830893e8b111189e9019848ead054b0f85b3
commit: dd2e7dd20cf482bc2fd989bfbd0354476ae904c2 [491/499] [media] cx231xx: Add digital support for HVR 930c-HD model 1113xx
reproduce: make C=1 CF=-D__CHECK_ENDIAN__


sparse warnings: (new ones prefixed by >>)

>> drivers/media/usb/cx231xx/cx231xx-dvb.c:736:57: sparse: Using plain integer as NULL pointer

vim +736 drivers/media/usb/cx231xx/cx231xx-dvb.c

   720			break;
   721	
   722		case CX231XX_BOARD_HAUPPAUGE_930C_HD_1113xx:
   723	
   724			dev->dvb->frontend = dvb_attach(si2165_attach,
   725				&hauppauge_930C_HD_1113xx_si2165_config,
   726				&dev->i2c_bus[dev->board.tuner_i2c_master].i2c_adap
   727				);
   728	
   729			if (dev->dvb->frontend == NULL) {
   730				printk(DRIVER_NAME
   731				       ": Failed to attach SI2165 front end\n");
   732				result = -EINVAL;
   733				goto out_free;
   734			}
   735	
 > 736			dev->dvb->frontend->ops.i2c_gate_ctrl = 0;
   737	
   738			/* define general-purpose callback pointer */
   739			dvb->frontend->callback = cx231xx_tuner_callback;
   740	
   741			dvb_attach(tda18271_attach, dev->dvb->frontend,
   742				0x60,
   743				&dev->i2c_bus[dev->board.tuner_i2c_master].i2c_adap,
   744				&hcw_tda18271_config);

---
0-DAY kernel build testing backend              Open Source Technology Center
http://lists.01.org/mailman/listinfo/kbuild                 Intel Corporation
