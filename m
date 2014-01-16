Return-path: <linux-media-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:17611 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750836AbaAPHgh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Jan 2014 02:36:37 -0500
Date: Thu, 16 Jan 2014 10:36:30 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>, kbuild@01.org
Cc: linux-media@vger.kernel.org,
	Dan Carpenter <dan.carpenter@oracle.com>
Subject: [linuxtv-media:master 499/499] drivers/media/rc/rc-main.c:1201
 rc_register_device() warn: inconsistent returns mutex:&dev->lock: locked
 (1107 [(-12)]) unlocked (1077 [(-22)], 1083 [(-22)], 1186 [0], 1201
 [s32min-(-1)], 1201 [s32min-(-1),1-s32max], 1201 [s32min-(-1),1-s32max],
 1201 [s32min-(-1),1-s32max])
Message-ID: <20140116073345.GL7499@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

FYI, there are new smatch warnings show up in

tree:   git://linuxtv.org/media_tree.git master
head:   587d1b06e07b4a079453c74ba9edf17d21931049
commit: 587d1b06e07b4a079453c74ba9edf17d21931049 [499/499] [media] rc-core: reuse device numbers

drivers/media/rc/rc-main.c:1201 rc_register_device() warn: inconsistent returns mutex:&dev->lock: locked (1107 [(-12)]) unlocked (1077 [(-22)], 1083 [(-22)], 1186 [0], 1201 [s32min-(-1)], 1201 [s32min-(-1),1-s32max], 1201 [s32min-(-1),1-s32max], 1201 [s32min-(-1),1-s32max])

git remote add linuxtv-media git://linuxtv.org/media_tree.git
git remote update linuxtv-media
git checkout 587d1b06e07b4a079453c74ba9edf17d21931049
vim +1201 drivers/media/rc/rc-main.c

d8b4b5822 David Härdeman       2010-10-29  1185  
bc2a6c571 Mauro Carvalho Chehab 2010-11-09  1186  	return 0;
d8b4b5822 David Härdeman       2010-10-29  1187  
d8b4b5822 David Härdeman       2010-10-29  1188  out_raw:
d8b4b5822 David Härdeman       2010-10-29  1189  	if (dev->driver_type == RC_DRIVER_IR_RAW)
d8b4b5822 David Härdeman       2010-10-29  1190  		ir_raw_event_unregister(dev);
d8b4b5822 David Härdeman       2010-10-29  1191  out_input:
d8b4b5822 David Härdeman       2010-10-29  1192  	input_unregister_device(dev->input_dev);
d8b4b5822 David Härdeman       2010-10-29  1193  	dev->input_dev = NULL;
d8b4b5822 David Härdeman       2010-10-29  1194  out_table:
b088ba658 Mauro Carvalho Chehab 2010-11-17  1195  	ir_free_table(&dev->rc_map);
d8b4b5822 David Härdeman       2010-10-29  1196  out_dev:
d8b4b5822 David Härdeman       2010-10-29  1197  	device_del(&dev->dev);
08aeb7c9a Jarod Wilson          2011-05-11  1198  out_unlock:
08aeb7c9a Jarod Wilson          2011-05-11  1199  	mutex_unlock(&dev->lock);
587d1b06e Mauro Carvalho Chehab 2014-01-14  1200  	clear_bit(dev->devno, ir_core_dev_number);
d8b4b5822 David Härdeman       2010-10-29 @1201  	return rc;
bc2a6c571 Mauro Carvalho Chehab 2010-11-09  1202  }
d8b4b5822 David Härdeman       2010-10-29  1203  EXPORT_SYMBOL_GPL(rc_register_device);
bc2a6c571 Mauro Carvalho Chehab 2010-11-09  1204  
d8b4b5822 David Härdeman       2010-10-29  1205  void rc_unregister_device(struct rc_dev *dev)
bc2a6c571 Mauro Carvalho Chehab 2010-11-09  1206  {
d8b4b5822 David Härdeman       2010-10-29  1207  	if (!dev)
d8b4b5822 David Härdeman       2010-10-29  1208  		return;
bc2a6c571 Mauro Carvalho Chehab 2010-11-09  1209  

---
0-DAY kernel build testing backend              Open Source Technology Center
http://lists.01.org/mailman/listinfo/kbuild                 Intel Corporation
