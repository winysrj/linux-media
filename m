Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:43466 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754378AbaCNO2g (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 14 Mar 2014 10:28:36 -0400
Date: Fri, 14 Mar 2014 22:28:16 +0800
From: kbuild test robot <fengguang.wu@intel.com>
To: Antti Palosaari <crope@iki.fi>
Cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	kbuild-all@01.org
Subject: [linuxtv-media:master 479/499]
 drivers/staging/media/rtl2832u_sdr/rtl2832_sdr.c:181:1: warning:
 'rtl2832_sdr_wr' uses dynamic stack allocation
Message-ID: <53231200.ZJYsLEXrYCIlm6qs%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

tree:   git://linuxtv.org/media_tree.git master
head:   ba35ca07080268af1badeb47de0f9eff28126339
commit: 771138920eafa399f68d3492c8a75dfeea23474b [479/499] [media] rtl2832_sdr: Realtek RTL2832 SDR driver module
config: make ARCH=s390 allmodconfig

All warnings:

   drivers/staging/media/rtl2832u_sdr/rtl2832_sdr.c: In function 'rtl2832_sdr_wr':
>> drivers/staging/media/rtl2832u_sdr/rtl2832_sdr.c:181:1: warning: 'rtl2832_sdr_wr' uses dynamic stack allocation [enabled by default]

vim +/rtl2832_sdr_wr +181 drivers/staging/media/rtl2832u_sdr/rtl2832_sdr.c

   165			}
   166		};
   167	
   168		buf[0] = reg;
   169		memcpy(&buf[1], val, len);
   170	
   171		ret = i2c_transfer(s->i2c, msg, 1);
   172		if (ret == 1) {
   173			ret = 0;
   174		} else {
   175			dev_err(&s->i2c->dev,
   176				"%s: I2C wr failed=%d reg=%02x len=%d\n",
   177				KBUILD_MODNAME, ret, reg, len);
   178			ret = -EREMOTEIO;
   179		}
   180		return ret;
 > 181	}
   182	
   183	/* read multiple hardware registers */
   184	static int rtl2832_sdr_rd(struct rtl2832_sdr_state *s, u8 reg, u8 *val, int len)
   185	{
   186		int ret;
   187		struct i2c_msg msg[2] = {
   188			{
   189				.addr = s->cfg->i2c_addr,

---
0-DAY kernel build testing backend              Open Source Technology Center
http://lists.01.org/mailman/listinfo/kbuild                 Intel Corporation
