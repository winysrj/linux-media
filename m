Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga18.intel.com ([134.134.136.126]:11104 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728227AbeGaJqO (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 31 Jul 2018 05:46:14 -0400
Date: Tue, 31 Jul 2018 16:06:14 +0800
From: kbuild test robot <lkp@intel.com>
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: kbuild-all@01.org, Mauro Carvalho Chehab <m.chehab@samsung.com>,
        linux-media@vger.kernel.org, Marco Felsch <m.felsch@pengutronix.de>
Subject: [ragnatech:media-tree 311/324] drivers/media/i2c/tvp5150.c:1324:6:
 sparse: symbol 'tvp5150_volatile_reg' was not declared. Should it be static?
Message-ID: <201807311618.wWANbjTp%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

tree:   git://git.ragnatech.se/linux media-tree
head:   1d06352e18ef502e30837cedfe618298816fb48c
commit: 07dff5b8c03053db6fb6e33fd38c3e5d37f67bc5 [311/324] media: tvp5150: convert register access to regmap
reproduce:
        # apt-get install sparse
        git checkout 07dff5b8c03053db6fb6e33fd38c3e5d37f67bc5
        make ARCH=x86_64 allmodconfig
        make C=1 CF=-D__CHECK_ENDIAN__


sparse warnings: (new ones prefixed by >>)

   drivers/media/i2c/tvp5150.c:893:21: sparse: expression using sizeof(void)
   drivers/media/i2c/tvp5150.c:893:21: sparse: expression using sizeof(void)
   drivers/media/i2c/tvp5150.c:893:21: sparse: expression using sizeof(void)
   drivers/media/i2c/tvp5150.c:893:21: sparse: expression using sizeof(void)
   drivers/media/i2c/tvp5150.c:893:21: sparse: expression using sizeof(void)
   drivers/media/i2c/tvp5150.c:893:21: sparse: expression using sizeof(void)
   drivers/media/i2c/tvp5150.c:893:21: sparse: expression using sizeof(void)
   drivers/media/i2c/tvp5150.c:894:20: sparse: expression using sizeof(void)
   drivers/media/i2c/tvp5150.c:894:20: sparse: expression using sizeof(void)
   drivers/media/i2c/tvp5150.c:894:20: sparse: expression using sizeof(void)
   drivers/media/i2c/tvp5150.c:894:20: sparse: expression using sizeof(void)
   drivers/media/i2c/tvp5150.c:894:20: sparse: expression using sizeof(void)
   drivers/media/i2c/tvp5150.c:894:20: sparse: expression using sizeof(void)
   drivers/media/i2c/tvp5150.c:894:20: sparse: expression using sizeof(void)
>> drivers/media/i2c/tvp5150.c:1324:6: sparse: symbol 'tvp5150_volatile_reg' was not declared. Should it be static?

Please review and possibly fold the followup patch.

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
