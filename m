Return-path: <linux-media-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:25306 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751544AbaCEIrA (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 5 Mar 2014 03:47:00 -0500
Date: Wed, 5 Mar 2014 11:46:40 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: kbuild@01.org, Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
	linux-media@vger.kernel.org
Subject: [linuxtv-media:master 463/499]
 drivers/media/dvb-frontends/drx39xyj/drxj.c:20803 drx_ctrl_u_code() warn:
 variable dereferenced before check 'mc_info' (see line 20800)
Message-ID: <20140305084640.GS27552@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

FYI, there are new smatch warnings show up in

tree:   git://linuxtv.org/media_tree.git master
head:   59432be1c7fbf2a4f608850855ff649bee0f7b3b
commit: b240eacdd536bac23c9d48dfc3d527ed6870ddad [463/499] [media] drx-j: get rid of drx_driver.c

New smatch warnings:
drivers/media/dvb-frontends/drx39xyj/drxj.c:20803 drx_ctrl_u_code() warn: variable dereferenced before check 'mc_info' (see line 20800)

Old smatch warnings:
drivers/media/dvb-frontends/drx39xyj/drxj.c:1218 mult32() warn: missing break? reassigning '*h'

git remote add linuxtv-media git://linuxtv.org/media_tree.git
git remote update linuxtv-media
git checkout b240eacdd536bac23c9d48dfc3d527ed6870ddad
vim +/mc_info +20803 drivers/media/dvb-frontends/drx39xyj/drxj.c

b240eacd Mauro Carvalho Chehab 2014-01-24  20794  	u16 i = 0;
b240eacd Mauro Carvalho Chehab 2014-01-24  20795  	u16 mc_nr_of_blks = 0;
b240eacd Mauro Carvalho Chehab 2014-01-24  20796  	u16 mc_magic_word = 0;
b240eacd Mauro Carvalho Chehab 2014-01-24  20797  	const u8 *mc_data_init = NULL;
b240eacd Mauro Carvalho Chehab 2014-01-24  20798  	u8 *mc_data = NULL;
b240eacd Mauro Carvalho Chehab 2014-01-24  20799  	unsigned size;
b240eacd Mauro Carvalho Chehab 2014-01-24 @20800  	char *mc_file = mc_info->mc_file;
b240eacd Mauro Carvalho Chehab 2014-01-24  20801  
b240eacd Mauro Carvalho Chehab 2014-01-24  20802  	/* Check arguments */
b240eacd Mauro Carvalho Chehab 2014-01-24 @20803  	if (!mc_info || !mc_file)
b240eacd Mauro Carvalho Chehab 2014-01-24  20804  		return -EINVAL;
b240eacd Mauro Carvalho Chehab 2014-01-24  20805  
b240eacd Mauro Carvalho Chehab 2014-01-24  20806  	if (!demod->firmware) {

---
0-DAY kernel build testing backend              Open Source Technology Center
http://lists.01.org/mailman/listinfo/kbuild                 Intel Corporation
