Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:58621 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752828AbbEANFw (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 1 May 2015 09:05:52 -0400
Date: Fri, 1 May 2015 21:05:02 +0800
From: kbuild test robot <fengguang.wu@intel.com>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: kbuild-all@01.org, linux-media@vger.kernel.org
Subject: [linuxtv-media:master 841/883]
 drivers/media/pci/saa7164/saa7164-dvb.c:704 saa7164_dvb_register() error:
 potential null dereference 'client_demod'.  (i2c_new_device returns null)
Message-ID: <201505012101.TIMaSxDo%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

tree:   git://linuxtv.org/media_tree.git master
head:   ebf984bb151e9952cccd060d3aba0b4d30a87e81
commit: 3600433f19f59410010770d61ead509d785b8a6e [841/883] saa7164: Fix CodingStyle issues added on previous patches

drivers/media/pci/saa7164/saa7164-dvb.c:704 saa7164_dvb_register() error: potential null dereference 'client_demod'.  (i2c_new_device returns null)

vim +/client_demod +704 drivers/media/pci/saa7164/saa7164-dvb.c

504b29cbb0 Steven Toth           2015-03-23  688  		} else {
504b29cbb0 Steven Toth           2015-03-23  689  			/* attach frontend */
504b29cbb0 Steven Toth           2015-03-23  690  			memset(&si2168_config, 0, sizeof(si2168_config));
504b29cbb0 Steven Toth           2015-03-23  691  			si2168_config.i2c_adapter = &adapter;
504b29cbb0 Steven Toth           2015-03-23  692  			si2168_config.fe = &port->dvb.frontend;
504b29cbb0 Steven Toth           2015-03-23  693  			si2168_config.ts_mode = SI2168_TS_SERIAL;
504b29cbb0 Steven Toth           2015-03-23  694  			memset(&info, 0, sizeof(struct i2c_board_info));
504b29cbb0 Steven Toth           2015-03-23  695  			strlcpy(info.type, "si2168", I2C_NAME_SIZE);
504b29cbb0 Steven Toth           2015-03-23  696  			info.addr = 0xcc >> 1;
504b29cbb0 Steven Toth           2015-03-23  697  			info.platform_data = &si2168_config;
504b29cbb0 Steven Toth           2015-03-23  698  			request_module(info.type);
3600433f19 Mauro Carvalho Chehab 2015-05-01  699  			client_demod = i2c_new_device(&dev->i2c_bus[2].i2c_adap,
3600433f19 Mauro Carvalho Chehab 2015-05-01  700  						      &info);
3600433f19 Mauro Carvalho Chehab 2015-05-01  701  			if (!client_tuner || !client_tuner->dev.driver)
504b29cbb0 Steven Toth           2015-03-23  702  				goto frontend_detach;
3600433f19 Mauro Carvalho Chehab 2015-05-01  703  
504b29cbb0 Steven Toth           2015-03-23 @704  			if (!try_module_get(client_demod->dev.driver->owner)) {
504b29cbb0 Steven Toth           2015-03-23  705  				i2c_unregister_device(client_demod);
504b29cbb0 Steven Toth           2015-03-23  706  				goto frontend_detach;
504b29cbb0 Steven Toth           2015-03-23  707  			}
504b29cbb0 Steven Toth           2015-03-23  708  			port->i2c_client_demod = client_demod;
504b29cbb0 Steven Toth           2015-03-23  709  
504b29cbb0 Steven Toth           2015-03-23  710  			/* attach tuner */
504b29cbb0 Steven Toth           2015-03-23  711  			memset(&si2157_config, 0, sizeof(si2157_config));
504b29cbb0 Steven Toth           2015-03-23  712  			si2157_config.fe = port->dvb.frontend;

:::::: The code at line 704 was first introduced by commit
:::::: 504b29cbb0cc0fb7169c276054a72110b57660c0 [media] saa7164: Add Digital TV support for the HVR2255 and HVR2205

:::::: TO: Steven Toth <stoth@kernellabs.com>
:::::: CC: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

---
0-DAY kernel test infrastructure                Open Source Technology Center
http://lists.01.org/mailman/listinfo/kbuild                 Intel Corporation
