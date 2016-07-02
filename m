Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga04.intel.com ([192.55.52.120]:53740 "EHLO mga04.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750735AbcGBEwS (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 2 Jul 2016 00:52:18 -0400
Date: Sat, 2 Jul 2016 12:50:53 +0800
From: kbuild test robot <lkp@intel.com>
To: Andi Shyti <andi.shyti@samsung.com>
Cc: kbuild-all@01.org, Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Rob Herring <robh+dt@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	devicetree@vger.kernel.org, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org, Andi Shyti <andi.shyti@samsung.com>,
	Andi Shyti <andi@etezian.org>
Subject: Re: [PATCH] [media] rc: ir-spi: add support for IR LEDs connected
 with SPI
Message-ID: <201607021238.UTYJugER%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1467362022-12704-1-git-send-email-andi.shyti@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

[auto build test WARNING on linuxtv-media/master]
[also build test WARNING on v4.7-rc5 next-20160701]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/Andi-Shyti/rc-ir-spi-add-support-for-IR-LEDs-connected-with-SPI/20160702-102955
base:   git://linuxtv.org/media_tree.git master
reproduce:
        # apt-get install sparse
        make ARCH=x86_64 allmodconfig
        make C=1 CF=-D__CHECK_ENDIAN__


sparse warnings: (new ones prefixed by >>)

   include/linux/compiler.h:232:8: sparse: attribute 'no_sanitize_address': unknown attribute
   drivers/media/rc/ir-spi.c:156:14: sparse: undefined identifier 'LIRC_SET_LENGTH'
>> drivers/media/rc/ir-spi.c:156:14: sparse: incompatible types for 'case' statement
   drivers/media/rc/ir-spi.c:156:14: sparse: Expected constant expression in case statement
   drivers/media/rc/ir-spi.c: In function 'ir_spi_chardev_ioctl':
   drivers/media/rc/ir-spi.c:156:7: error: 'LIRC_SET_LENGTH' undeclared (first use in this function)
     case LIRC_SET_LENGTH: {
          ^~~~~~~~~~~~~~~
   drivers/media/rc/ir-spi.c:156:7: note: each undeclared identifier is reported only once for each function it appears in

vim +/case +156 drivers/media/rc/ir-spi.c

   140	
   141	static long ir_spi_chardev_ioctl(struct file *file, unsigned int cmd,
   142							unsigned long arg)
   143	{
   144		__u32 p;
   145		s32 ret;
   146		struct ir_spi_data *idata = file->private_data;
   147	
   148		switch (cmd) {
   149		case LIRC_GET_FEATURES:
   150			return put_user(idata->lirc_driver.features,
   151						(__u32 __user *) arg);
   152	
   153		case LIRC_GET_LENGTH:
   154			return put_user(idata->xfer.len, (__u32 __user *) arg);
   155	
 > 156		case LIRC_SET_LENGTH: {
   157			void *new;
   158	
   159			ret = get_user(p, (__u32 __user *) arg);
   160			if (ret)
   161				return ret;
   162	
   163			/*
   164			 * the user is trying to set the same

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
