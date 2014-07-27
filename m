Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:4044 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752546AbaG0VaH (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 27 Jul 2014 17:30:07 -0400
Date: Mon, 28 Jul 2014 05:31:43 +0800
From: kbuild test robot <fengguang.wu@intel.com>
To: Matthias Schwarzott <zzam@gentoo.org>
Cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	kbuild-all@01.org
Subject: [linuxtv-media:master 489/499]
 drivers/media/pci/cx23885/cx23885-dvb.c:1494:72: sparse: Using plain
 integer as NULL pointer
Message-ID: <53d56fbf.CfjKmZiJCrJMuNte%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

tree:   git://linuxtv.org/media_tree.git master
head:   0a12830893e8b111189e9019848ead054b0f85b3
commit: 36efec48e2e6016e05364906720a0ec350a5d768 [489/499] [media] cx23885: Add si2165 support for HVR-5500
reproduce: make C=1 CF=-D__CHECK_ENDIAN__


sparse warnings: (new ones prefixed by >>)

>> drivers/media/dvb-frontends/si2165.c:329:16: sparse: odd constant _Bool cast (ffffffffffffffea becomes 1)
--
>> drivers/media/pci/cx23885/cx23885-dvb.c:1494:72: sparse: Using plain integer as NULL pointer

vim +1494 drivers/media/pci/cx23885/cx23885-dvb.c

  1478				fe0->dvb.frontend = dvb_attach(tda10071_attach,
  1479							&hauppauge_tda10071_config,
  1480							&i2c_bus->i2c_adap);
  1481				if (fe0->dvb.frontend != NULL) {
  1482					if (!dvb_attach(a8293_attach, fe0->dvb.frontend,
  1483							&i2c_bus->i2c_adap,
  1484							&hauppauge_a8293_config))
  1485						goto frontend_detach;
  1486				}
  1487				break;
  1488			/* port c */
  1489			case 2:
  1490				fe0->dvb.frontend = dvb_attach(si2165_attach,
  1491						&hauppauge_hvr4400_si2165_config,
  1492						&i2c_bus->i2c_adap);
  1493				if (fe0->dvb.frontend != NULL) {
> 1494					fe0->dvb.frontend->ops.i2c_gate_ctrl = 0;
  1495					if (!dvb_attach(tda18271_attach,
  1496							fe0->dvb.frontend,
  1497							0x60, &i2c_bus2->i2c_adap,
  1498						  &hauppauge_hvr4400_tuner_config))
  1499						goto frontend_detach;
  1500				}
  1501				break;
  1502			}

---
0-DAY kernel build testing backend              Open Source Technology Center
http://lists.01.org/mailman/listinfo/kbuild                 Intel Corporation
