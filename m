Return-path: <linux-media-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:46392 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751622AbaCEJax (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 5 Mar 2014 04:30:53 -0500
Date: Wed, 5 Mar 2014 12:29:46 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: kbuild@01.org, Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
	linux-media@vger.kernel.org
Subject: [linuxtv-media:master 467/499]
 drivers/media/dvb-frontends/drx39xyj/drxj.c:20041 drxj_close() warn:
 variable dereferenced before check 'demod' (see line 20036)
Message-ID: <20140305092946.GV27552@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

FYI, there are new smatch warnings show up in

tree:   git://linuxtv.org/media_tree.git master
head:   59432be1c7fbf2a4f608850855ff649bee0f7b3b
commit: b78359a6894ac3451bec3fde5d0499fba87b8b67 [467/499] [media] drx-j: get rid of the remaining drx generic functions

New smatch warnings:
drivers/media/dvb-frontends/drx39xyj/drxj.c:20041 drxj_close() warn: variable dereferenced before check 'demod' (see line 20036)

Old smatch warnings:
drivers/media/dvb-frontends/drx39xyj/drxj.c:1145 mult32() warn: missing break? reassigning '*h'
drivers/media/dvb-frontends/drx39xyj/drxj.c:20435 drx_ctrl_u_code() warn: variable dereferenced before check 'mc_info' (see line 20432)

git remote add linuxtv-media git://linuxtv.org/media_tree.git
git remote update linuxtv-media
git checkout b78359a6894ac3451bec3fde5d0499fba87b8b67
vim +/demod +20041 drivers/media/dvb-frontends/drx39xyj/drxj.c

38b2df95 Devin Heitmueller     2012-08-13  20030  * \brief Close the demod instance, power down the device
38b2df95 Devin Heitmueller     2012-08-13  20031  * \return Status_t Return status.
38b2df95 Devin Heitmueller     2012-08-13  20032  *
38b2df95 Devin Heitmueller     2012-08-13  20033  */
1bfc9e15 Mauro Carvalho Chehab 2014-01-16  20034  int drxj_close(struct drx_demod_instance *demod)
38b2df95 Devin Heitmueller     2012-08-13  20035  {
4d7bb0eb Mauro Carvalho Chehab 2014-01-16 @20036  	struct i2c_device_addr *dev_addr = demod->my_i2c_dev_addr;
1bfc9e15 Mauro Carvalho Chehab 2014-01-16  20037  	struct drx_common_attr *common_attr = demod->my_common_attr;
068e94ea Mauro Carvalho Chehab 2014-01-16  20038  	int rc;
1bfc9e15 Mauro Carvalho Chehab 2014-01-16  20039  	enum drx_power_mode power_mode = DRX_POWER_UP;
38b2df95 Devin Heitmueller     2012-08-13  20040  
b78359a6 Mauro Carvalho Chehab 2014-01-24 @20041  	if ((demod == NULL) ||
b78359a6 Mauro Carvalho Chehab 2014-01-24  20042  	    (demod->my_common_attr == NULL) ||
b78359a6 Mauro Carvalho Chehab 2014-01-24  20043  	    (demod->my_ext_attr == NULL) ||
b78359a6 Mauro Carvalho Chehab 2014-01-24  20044  	    (demod->my_i2c_dev_addr == NULL) ||

---
0-DAY kernel build testing backend              Open Source Technology Center
http://lists.01.org/mailman/listinfo/kbuild                 Intel Corporation
