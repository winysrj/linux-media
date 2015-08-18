Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:58658 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751727AbbHRNuW (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 18 Aug 2015 09:50:22 -0400
Date: Tue, 18 Aug 2015 21:47:24 +0800
From: kbuild test robot <fengguang.wu@intel.com>
To: Kozlov Sergey <serjk@netup.ru>
Cc: kbuild-all@01.org, Mauro Carvalho Chehab <m.chehab@samsung.com>,
	linux-media@vger.kernel.org
Subject: [linux-next:master 7256/9424]
 drivers/media/pci/netup_unidvb/netup_unidvb_core.c:191:41: sparse: incorrect
 type in argument 2 (different address spaces)
Message-ID: <201508182121.KZ2AwguW%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

tree:   git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
head:   ebe96538f4817c765690e28fcd33dc1da1504d26
commit: 52b1eaf4c59a3bbd07afbb4ab4f43418a807d02e [7256/9424] [media] netup_unidvb: NetUP Universal DVB-S/S2/T/T2/C PCI-E card driver
reproduce:
  # apt-get install sparse
  git checkout 52b1eaf4c59a3bbd07afbb4ab4f43418a807d02e
  make ARCH=x86_64 allmodconfig
  make C=1 CF=-D__CHECK_ENDIAN__


sparse warnings: (new ones prefixed by >>)

>> drivers/media/pci/netup_unidvb/netup_unidvb_core.c:191:41: sparse: incorrect type in argument 2 (different address spaces)
   drivers/media/pci/netup_unidvb/netup_unidvb_core.c:191:41:    expected void volatile [noderef] <asn:2>*addr
   drivers/media/pci/netup_unidvb/netup_unidvb_core.c:191:41:    got restricted __le32 *<noident>
>> drivers/media/pci/netup_unidvb/netup_unidvb_core.c:193:26: sparse: cast removes address space of expression
>> drivers/media/pci/netup_unidvb/netup_unidvb_core.c:193:26: sparse: incorrect type in argument 2 (different address spaces)
   drivers/media/pci/netup_unidvb/netup_unidvb_core.c:193:26:    expected void volatile [noderef] <asn:2>*addr
   drivers/media/pci/netup_unidvb/netup_unidvb_core.c:193:26:    got unsigned short [usertype] *<noident>
   drivers/media/pci/netup_unidvb/netup_unidvb_core.c:195:41: sparse: incorrect type in argument 2 (different address spaces)
   drivers/media/pci/netup_unidvb/netup_unidvb_core.c:195:41:    expected void volatile [noderef] <asn:2>*addr
   drivers/media/pci/netup_unidvb/netup_unidvb_core.c:195:41:    got restricted __le32 *<noident>
   drivers/media/pci/netup_unidvb/netup_unidvb_core.c:197:26: sparse: cast removes address space of expression
   drivers/media/pci/netup_unidvb/netup_unidvb_core.c:197:26: sparse: incorrect type in argument 2 (different address spaces)
   drivers/media/pci/netup_unidvb/netup_unidvb_core.c:197:26:    expected void volatile [noderef] <asn:2>*addr
   drivers/media/pci/netup_unidvb/netup_unidvb_core.c:197:26:    got unsigned short [usertype] *<noident>
>> drivers/media/pci/netup_unidvb/netup_unidvb_core.c:209:37: sparse: incorrect type in argument 1 (different address spaces)
   drivers/media/pci/netup_unidvb/netup_unidvb_core.c:209:37:    expected void const volatile [noderef] <asn:2>*addr
   drivers/media/pci/netup_unidvb/netup_unidvb_core.c:209:37:    got restricted __le32 *<noident>
   drivers/media/pci/netup_unidvb/netup_unidvb_core.c:210:32: sparse: incorrect type in argument 1 (different address spaces)
   drivers/media/pci/netup_unidvb/netup_unidvb_core.c:210:32:    expected void const volatile [noderef] <asn:2>*addr
   drivers/media/pci/netup_unidvb/netup_unidvb_core.c:210:32:    got restricted __le32 *<noident>
   drivers/media/pci/netup_unidvb/netup_unidvb_core.c:212:33: sparse: incorrect type in argument 2 (different address spaces)
   drivers/media/pci/netup_unidvb/netup_unidvb_core.c:212:33:    expected void volatile [noderef] <asn:2>*addr
   drivers/media/pci/netup_unidvb/netup_unidvb_core.c:212:33:    got restricted __le32 *<noident>
>> drivers/media/pci/netup_unidvb/netup_unidvb_core.c:525:49: sparse: incorrect type in argument 2 (different address spaces)
   drivers/media/pci/netup_unidvb/netup_unidvb_core.c:525:49:    expected void const volatile [noderef] <asn:2>*src
   drivers/media/pci/netup_unidvb/netup_unidvb_core.c:525:49:    got unsigned char [usertype] *
   drivers/media/pci/netup_unidvb/netup_unidvb_core.c:538:49: sparse: incorrect type in argument 2 (different address spaces)
   drivers/media/pci/netup_unidvb/netup_unidvb_core.c:538:49:    expected void const volatile [noderef] <asn:2>*src
   drivers/media/pci/netup_unidvb/netup_unidvb_core.c:538:49:    got unsigned char [usertype] *
>> drivers/media/pci/netup_unidvb/netup_unidvb_core.c:644:22: sparse: incorrect type in argument 1 (different address spaces)
   drivers/media/pci/netup_unidvb/netup_unidvb_core.c:644:22:    expected void volatile [noderef] <asn:2>*addr
   drivers/media/pci/netup_unidvb/netup_unidvb_core.c:644:22:    got unsigned char [usertype] *addr_virt
   drivers/media/pci/netup_unidvb/netup_unidvb_core.c:647:22: sparse: cast removes address space of expression
   drivers/media/pci/netup_unidvb/netup_unidvb_core.c:651:59: sparse: incorrect type in argument 2 (different address spaces)
   drivers/media/pci/netup_unidvb/netup_unidvb_core.c:651:59:    expected void volatile [noderef] <asn:2>*addr
   drivers/media/pci/netup_unidvb/netup_unidvb_core.c:651:59:    got restricted __le32 *<noident>
   drivers/media/pci/netup_unidvb/netup_unidvb_core.c:652:56: sparse: incorrect type in argument 2 (different address spaces)
   drivers/media/pci/netup_unidvb/netup_unidvb_core.c:652:56:    expected void volatile [noderef] <asn:2>*addr
   drivers/media/pci/netup_unidvb/netup_unidvb_core.c:652:56:    got restricted __le32 *<noident>
   drivers/media/pci/netup_unidvb/netup_unidvb_core.c:653:23: sparse: incorrect type in argument 2 (different address spaces)
   drivers/media/pci/netup_unidvb/netup_unidvb_core.c:653:23:    expected void volatile [noderef] <asn:2>*addr
   drivers/media/pci/netup_unidvb/netup_unidvb_core.c:653:23:    got restricted __le32 *<noident>
   drivers/media/pci/netup_unidvb/netup_unidvb_core.c:655:31: sparse: incorrect type in argument 2 (different address spaces)
   drivers/media/pci/netup_unidvb/netup_unidvb_core.c:655:31:    expected void volatile [noderef] <asn:2>*addr
   drivers/media/pci/netup_unidvb/netup_unidvb_core.c:655:31:    got restricted __le32 *<noident>
   drivers/media/pci/netup_unidvb/netup_unidvb_core.c:657:33: sparse: incorrect type in argument 2 (different address spaces)
   drivers/media/pci/netup_unidvb/netup_unidvb_core.c:657:33:    expected void volatile [noderef] <asn:2>*addr
   drivers/media/pci/netup_unidvb/netup_unidvb_core.c:657:33:    got restricted __le32 *<noident>
--
>> drivers/media/pci/netup_unidvb/netup_unidvb_i2c.c:81:25: sparse: incorrect type in argument 1 (different address spaces)
   drivers/media/pci/netup_unidvb/netup_unidvb_i2c.c:81:25:    expected void const volatile [noderef] <asn:2>*addr
   drivers/media/pci/netup_unidvb/netup_unidvb_i2c.c:81:25:    got restricted __le16 *<noident>
>> drivers/media/pci/netup_unidvb/netup_unidvb_i2c.c:82:38: sparse: incorrect type in argument 2 (different address spaces)
   drivers/media/pci/netup_unidvb/netup_unidvb_i2c.c:82:38:    expected void volatile [noderef] <asn:2>*addr
   drivers/media/pci/netup_unidvb/netup_unidvb_i2c.c:82:38:    got restricted __le16 *<noident>
   drivers/media/pci/netup_unidvb/netup_unidvb_i2c.c:104:33: sparse: incorrect type in argument 1 (different address spaces)
   drivers/media/pci/netup_unidvb/netup_unidvb_i2c.c:104:33:    expected void const volatile [noderef] <asn:2>*addr
   drivers/media/pci/netup_unidvb/netup_unidvb_i2c.c:104:33:    got restricted __le16 *<noident>
   drivers/media/pci/netup_unidvb/netup_unidvb_i2c.c:105:47: sparse: incorrect type in argument 2 (different address spaces)
   drivers/media/pci/netup_unidvb/netup_unidvb_i2c.c:105:47:    expected void volatile [noderef] <asn:2>*addr
   drivers/media/pci/netup_unidvb/netup_unidvb_i2c.c:105:47:    got restricted __le16 *<noident>
   drivers/media/pci/netup_unidvb/netup_unidvb_i2c.c:112:33: sparse: incorrect type in argument 1 (different address spaces)
   drivers/media/pci/netup_unidvb/netup_unidvb_i2c.c:112:33:    expected void const volatile [noderef] <asn:2>*addr
   drivers/media/pci/netup_unidvb/netup_unidvb_i2c.c:112:33:    got restricted __le16 *<noident>
   drivers/media/pci/netup_unidvb/netup_unidvb_i2c.c:113:47: sparse: incorrect type in argument 2 (different address spaces)
   drivers/media/pci/netup_unidvb/netup_unidvb_i2c.c:113:47:    expected void volatile [noderef] <asn:2>*addr
   drivers/media/pci/netup_unidvb/netup_unidvb_i2c.c:113:47:    got restricted __le16 *<noident>
   drivers/media/pci/netup_unidvb/netup_unidvb_i2c.c:132:36: sparse: incorrect type in argument 2 (different address spaces)
   drivers/media/pci/netup_unidvb/netup_unidvb_i2c.c:132:36:    expected void volatile [noderef] <asn:2>*addr
   drivers/media/pci/netup_unidvb/netup_unidvb_i2c.c:132:36:    got restricted __le16 *<noident>
   drivers/media/pci/netup_unidvb/netup_unidvb_i2c.c:133:32: sparse: incorrect type in argument 2 (different address spaces)
   drivers/media/pci/netup_unidvb/netup_unidvb_i2c.c:133:32:    expected void volatile [noderef] <asn:2>*addr
   drivers/media/pci/netup_unidvb/netup_unidvb_i2c.c:133:32:    got restricted __le16 *<noident>
   drivers/media/pci/netup_unidvb/netup_unidvb_i2c.c:134:32: sparse: incorrect type in argument 2 (different address spaces)
   drivers/media/pci/netup_unidvb/netup_unidvb_i2c.c:134:32:    expected void volatile [noderef] <asn:2>*addr
   drivers/media/pci/netup_unidvb/netup_unidvb_i2c.c:134:32:    got restricted __le16 *<noident>
   drivers/media/pci/netup_unidvb/netup_unidvb_i2c.c:135:32: sparse: incorrect type in argument 2 (different address spaces)
   drivers/media/pci/netup_unidvb/netup_unidvb_i2c.c:135:32:    expected void volatile [noderef] <asn:2>*addr
   drivers/media/pci/netup_unidvb/netup_unidvb_i2c.c:135:32:    got restricted __le16 *<noident>
   drivers/media/pci/netup_unidvb/netup_unidvb_i2c.c:136:27: sparse: incorrect type in argument 2 (different address spaces)
   drivers/media/pci/netup_unidvb/netup_unidvb_i2c.c:136:27:    expected void volatile [noderef] <asn:2>*addr
   drivers/media/pci/netup_unidvb/netup_unidvb_i2c.c:136:27:    got restricted __le16 *<noident>
   drivers/media/pci/netup_unidvb/netup_unidvb_i2c.c:137:27: sparse: incorrect type in argument 2 (different address spaces)
   drivers/media/pci/netup_unidvb/netup_unidvb_i2c.c:137:27:    expected void volatile [noderef] <asn:2>*addr
   drivers/media/pci/netup_unidvb/netup_unidvb_i2c.c:137:27:    got restricted __le16 *<noident>
   drivers/media/pci/netup_unidvb/netup_unidvb_i2c.c:144:28: sparse: incorrect type in argument 1 (different address spaces)
   drivers/media/pci/netup_unidvb/netup_unidvb_i2c.c:144:28:    expected void const volatile [noderef] <asn:2>*addr
   drivers/media/pci/netup_unidvb/netup_unidvb_i2c.c:144:28:    got restricted __le16 *<noident>
>> drivers/media/pci/netup_unidvb/netup_unidvb_i2c.c:150:34: sparse: incorrect type in argument 2 (different address spaces)
   drivers/media/pci/netup_unidvb/netup_unidvb_i2c.c:150:34:    expected void volatile [noderef] <asn:2>*addr
   drivers/media/pci/netup_unidvb/netup_unidvb_i2c.c:150:34:    got unsigned char *<noident>
   drivers/media/pci/netup_unidvb/netup_unidvb_i2c.c:157:34: sparse: incorrect type in argument 1 (different address spaces)
   drivers/media/pci/netup_unidvb/netup_unidvb_i2c.c:157:34:    expected void const volatile [noderef] <asn:2>*addr
   drivers/media/pci/netup_unidvb/netup_unidvb_i2c.c:157:34:    got restricted __le16 *<noident>
   drivers/media/pci/netup_unidvb/netup_unidvb_i2c.c:158:29: sparse: incorrect type in argument 2 (different address spaces)
   drivers/media/pci/netup_unidvb/netup_unidvb_i2c.c:158:29:    expected void volatile [noderef] <asn:2>*addr
   drivers/media/pci/netup_unidvb/netup_unidvb_i2c.c:158:29:    got restricted __le16 *<noident>
   drivers/media/pci/netup_unidvb/netup_unidvb_i2c.c:165:35: sparse: incorrect type in argument 1 (different address spaces)
   drivers/media/pci/netup_unidvb/netup_unidvb_i2c.c:165:35:    expected void const volatile [noderef] <asn:2>*addr
   drivers/media/pci/netup_unidvb/netup_unidvb_i2c.c:165:35:    got restricted __le16 *<noident>
>> drivers/media/pci/netup_unidvb/netup_unidvb_i2c.c:170:34: sparse: incorrect type in argument 1 (different address spaces)
   drivers/media/pci/netup_unidvb/netup_unidvb_i2c.c:170:34:    expected void const volatile [noderef] <asn:2>*addr
   drivers/media/pci/netup_unidvb/netup_unidvb_i2c.c:170:34:    got unsigned char *<noident>
   drivers/media/pci/netup_unidvb/netup_unidvb_i2c.c:181:34: sparse: incorrect type in argument 1 (different address spaces)
   drivers/media/pci/netup_unidvb/netup_unidvb_i2c.c:181:34:    expected void const volatile [noderef] <asn:2>*addr
   drivers/media/pci/netup_unidvb/netup_unidvb_i2c.c:181:34:    got restricted __le16 *<noident>
   drivers/media/pci/netup_unidvb/netup_unidvb_i2c.c:182:29: sparse: incorrect type in argument 2 (different address spaces)
   drivers/media/pci/netup_unidvb/netup_unidvb_i2c.c:182:29:    expected void volatile [noderef] <asn:2>*addr
   drivers/media/pci/netup_unidvb/netup_unidvb_i2c.c:182:29:    got restricted __le16 *<noident>
   drivers/media/pci/netup_unidvb/netup_unidvb_i2c.c:189:29: sparse: incorrect type in argument 1 (different address spaces)
   drivers/media/pci/netup_unidvb/netup_unidvb_i2c.c:189:29:    expected void const volatile [noderef] <asn:2>*addr
   drivers/media/pci/netup_unidvb/netup_unidvb_i2c.c:189:29:    got restricted __le16 *<noident>
   drivers/media/pci/netup_unidvb/netup_unidvb_i2c.c:191:37: sparse: incorrect type in argument 2 (different address spaces)
   drivers/media/pci/netup_unidvb/netup_unidvb_i2c.c:191:37:    expected void volatile [noderef] <asn:2>*addr
   drivers/media/pci/netup_unidvb/netup_unidvb_i2c.c:191:37:    got restricted __le16 *<noident>
   drivers/media/pci/netup_unidvb/netup_unidvb_i2c.c:192:35: sparse: incorrect type in argument 2 (different address spaces)
   drivers/media/pci/netup_unidvb/netup_unidvb_i2c.c:192:35:    expected void volatile [noderef] <asn:2>*addr
   drivers/media/pci/netup_unidvb/netup_unidvb_i2c.c:192:35:    got restricted __le16 *<noident>
   drivers/media/pci/netup_unidvb/netup_unidvb_i2c.c:194:21: sparse: incorrect type in argument 2 (different address spaces)
   drivers/media/pci/netup_unidvb/netup_unidvb_i2c.c:194:21:    expected void volatile [noderef] <asn:2>*addr
   drivers/media/pci/netup_unidvb/netup_unidvb_i2c.c:194:21:    got restricted __le16 *<noident>
   drivers/media/pci/netup_unidvb/netup_unidvb_i2c.c:195:9: sparse: incorrect type in argument 1 (different address spaces)
   drivers/media/pci/netup_unidvb/netup_unidvb_i2c.c:195:9:    expected void const volatile [noderef] <asn:2>*addr
   drivers/media/pci/netup_unidvb/netup_unidvb_i2c.c:195:9:    got restricted __le16 *<noident>
   drivers/media/pci/netup_unidvb/netup_unidvb_i2c.c:195:9: sparse: incorrect type in argument 1 (different address spaces)
   drivers/media/pci/netup_unidvb/netup_unidvb_i2c.c:195:9:    expected void const volatile [noderef] <asn:2>*addr
   drivers/media/pci/netup_unidvb/netup_unidvb_i2c.c:195:9:    got restricted __le16 *<noident>
   drivers/media/pci/netup_unidvb/netup_unidvb_i2c.c:195:9: sparse: incorrect type in argument 1 (different address spaces)
   drivers/media/pci/netup_unidvb/netup_unidvb_i2c.c:195:9:    expected void const volatile [noderef] <asn:2>*addr
   drivers/media/pci/netup_unidvb/netup_unidvb_i2c.c:195:9:    got restricted __le16 *<noident>
   drivers/media/pci/netup_unidvb/netup_unidvb_i2c.c:205:47: sparse: incorrect type in argument 1 (different address spaces)
   drivers/media/pci/netup_unidvb/netup_unidvb_i2c.c:205:47:    expected void const volatile [noderef] <asn:2>*addr
   drivers/media/pci/netup_unidvb/netup_unidvb_i2c.c:205:47:    got restricted __le16 *<noident>
   drivers/media/pci/netup_unidvb/netup_unidvb_i2c.c:206:29: sparse: incorrect type in argument 2 (different address spaces)
   drivers/media/pci/netup_unidvb/netup_unidvb_i2c.c:206:29:    expected void volatile [noderef] <asn:2>*addr
   drivers/media/pci/netup_unidvb/netup_unidvb_i2c.c:206:29:    got restricted __le16 *<noident>
   drivers/media/pci/netup_unidvb/netup_unidvb_i2c.c:272:53: sparse: incorrect type in argument 1 (different address spaces)
   drivers/media/pci/netup_unidvb/netup_unidvb_i2c.c:272:53:    expected void const volatile [noderef] <asn:2>*addr
   drivers/media/pci/netup_unidvb/netup_unidvb_i2c.c:272:53:    got restricted __le16 *<noident>
   drivers/media/pci/netup_unidvb/netup_unidvb_i2c.c:274:53: sparse: incorrect type in argument 2 (different address spaces)
   drivers/media/pci/netup_unidvb/netup_unidvb_i2c.c:274:53:    expected void volatile [noderef] <asn:2>*addr
   drivers/media/pci/netup_unidvb/netup_unidvb_i2c.c:274:53:    got restricted __le16 *<noident>
>> drivers/media/pci/netup_unidvb/netup_unidvb_i2c.c:323:22: sparse: cast removes address space of expression
--
>> drivers/media/pci/netup_unidvb/netup_unidvb_ci.c:229:38: sparse: cast removes address space of expression
>> drivers/media/pci/netup_unidvb/netup_unidvb_ci.c:229:38: sparse: incorrect type in argument 2 (different address spaces)
   drivers/media/pci/netup_unidvb/netup_unidvb_ci.c:229:38:    expected void volatile [noderef] <asn:2>*addr
   drivers/media/pci/netup_unidvb/netup_unidvb_ci.c:229:38:    got unsigned short [usertype] *<noident>
>> drivers/media/pci/netup_unidvb/netup_unidvb_ci.c:150:40: sparse: dereference of noderef expression
   drivers/media/pci/netup_unidvb/netup_unidvb_ci.c:165:31: sparse: dereference of noderef expression
   drivers/media/pci/netup_unidvb/netup_unidvb_ci.c:174:36: sparse: dereference of noderef expression
   drivers/media/pci/netup_unidvb/netup_unidvb_ci.c:189:27: sparse: dereference of noderef expression
--
>> drivers/media/pci/netup_unidvb/netup_unidvb_spi.c:89:25: sparse: incorrect type in argument 1 (different address spaces)
   drivers/media/pci/netup_unidvb/netup_unidvb_spi.c:89:25:    expected void const volatile [noderef] <asn:2>*addr
   drivers/media/pci/netup_unidvb/netup_unidvb_spi.c:89:25:    got restricted __le16 *<noident>
>> drivers/media/pci/netup_unidvb/netup_unidvb_spi.c:96:46: sparse: incorrect type in argument 2 (different address spaces)
   drivers/media/pci/netup_unidvb/netup_unidvb_spi.c:96:46:    expected void volatile [noderef] <asn:2>*addr
   drivers/media/pci/netup_unidvb/netup_unidvb_spi.c:96:46:    got restricted __le16 *<noident>
   drivers/media/pci/netup_unidvb/netup_unidvb_spi.c:97:25: sparse: incorrect type in argument 1 (different address spaces)
   drivers/media/pci/netup_unidvb/netup_unidvb_spi.c:97:25:    expected void const volatile [noderef] <asn:2>*addr
   drivers/media/pci/netup_unidvb/netup_unidvb_spi.c:97:25:    got restricted __le16 *<noident>
   drivers/media/pci/netup_unidvb/netup_unidvb_spi.c:98:49: sparse: incorrect type in argument 2 (different address spaces)
   drivers/media/pci/netup_unidvb/netup_unidvb_spi.c:98:49:    expected void volatile [noderef] <asn:2>*addr
   drivers/media/pci/netup_unidvb/netup_unidvb_spi.c:98:49:    got restricted __le16 *<noident>
   drivers/media/pci/netup_unidvb/netup_unidvb_spi.c:116:44: sparse: incorrect type in argument 2 (different address spaces)
   drivers/media/pci/netup_unidvb/netup_unidvb_spi.c:116:44:    expected void volatile [noderef] <asn:2>*addr
   drivers/media/pci/netup_unidvb/netup_unidvb_spi.c:116:44:    got restricted __le16 *<noident>
   drivers/media/pci/netup_unidvb/netup_unidvb_spi.c:117:23: sparse: incorrect type in argument 2 (different address spaces)
   drivers/media/pci/netup_unidvb/netup_unidvb_spi.c:117:23:    expected void volatile [noderef] <asn:2>*addr
   drivers/media/pci/netup_unidvb/netup_unidvb_spi.c:117:23:    got restricted __le16 *<noident>
>> drivers/media/pci/netup_unidvb/netup_unidvb_spi.c:132:48: sparse: incorrect type in argument 1 (different address spaces)
   drivers/media/pci/netup_unidvb/netup_unidvb_spi.c:132:48:    expected void volatile [noderef] <asn:2>*dst
   drivers/media/pci/netup_unidvb/netup_unidvb_spi.c:132:48:    got unsigned char *<noident>
>> drivers/media/pci/netup_unidvb/netup_unidvb_spi.c:136:46: sparse: incorrect type in argument 1 (different address spaces)
   drivers/media/pci/netup_unidvb/netup_unidvb_spi.c:136:46:    expected void volatile [noderef] <asn:2>*addr
   drivers/media/pci/netup_unidvb/netup_unidvb_spi.c:136:46:    got unsigned char *<noident>
   drivers/media/pci/netup_unidvb/netup_unidvb_spi.c:144:37: sparse: incorrect type in argument 2 (different address spaces)
   drivers/media/pci/netup_unidvb/netup_unidvb_spi.c:144:37:    expected void volatile [noderef] <asn:2>*addr
   drivers/media/pci/netup_unidvb/netup_unidvb_spi.c:144:37:    got restricted __le16 *<noident>
   drivers/media/pci/netup_unidvb/netup_unidvb_spi.c:145:25: sparse: incorrect type in argument 1 (different address spaces)
   drivers/media/pci/netup_unidvb/netup_unidvb_spi.c:145:25:    expected void const volatile [noderef] <asn:2>*addr
   drivers/media/pci/netup_unidvb/netup_unidvb_spi.c:145:25:    got restricted __le16 *<noident>
>> drivers/media/pci/netup_unidvb/netup_unidvb_spi.c:154:52: sparse: incorrect type in argument 2 (different address spaces)
   drivers/media/pci/netup_unidvb/netup_unidvb_spi.c:154:52:    expected void const volatile [noderef] <asn:2>*src
   drivers/media/pci/netup_unidvb/netup_unidvb_spi.c:154:52:    got unsigned char *<noident>
>> drivers/media/pci/netup_unidvb/netup_unidvb_spi.c:205:23: sparse: cast removes address space of expression
   drivers/media/pci/netup_unidvb/netup_unidvb_spi.c:206:24: sparse: incorrect type in argument 2 (different address spaces)
   drivers/media/pci/netup_unidvb/netup_unidvb_spi.c:206:24:    expected void volatile [noderef] <asn:2>*addr
   drivers/media/pci/netup_unidvb/netup_unidvb_spi.c:206:24:    got restricted __le16 *<noident>
   drivers/media/pci/netup_unidvb/netup_unidvb_spi.c:243:25: sparse: incorrect type in argument 1 (different address spaces)
   drivers/media/pci/netup_unidvb/netup_unidvb_spi.c:243:25:    expected void const volatile [noderef] <asn:2>*addr
   drivers/media/pci/netup_unidvb/netup_unidvb_spi.c:243:25:    got restricted __le16 *<noident>
   drivers/media/pci/netup_unidvb/netup_unidvb_spi.c:244:46: sparse: incorrect type in argument 2 (different address spaces)
   drivers/media/pci/netup_unidvb/netup_unidvb_spi.c:244:46:    expected void volatile [noderef] <asn:2>*addr
   drivers/media/pci/netup_unidvb/netup_unidvb_spi.c:244:46:    got restricted __le16 *<noident>
   drivers/media/pci/netup_unidvb/netup_unidvb_spi.c:245:25: sparse: incorrect type in argument 1 (different address spaces)
   drivers/media/pci/netup_unidvb/netup_unidvb_spi.c:245:25:    expected void const volatile [noderef] <asn:2>*addr
   drivers/media/pci/netup_unidvb/netup_unidvb_spi.c:245:25:    got restricted __le16 *<noident>
   drivers/media/pci/netup_unidvb/netup_unidvb_spi.c:246:49: sparse: incorrect type in argument 2 (different address spaces)
   drivers/media/pci/netup_unidvb/netup_unidvb_spi.c:246:49:    expected void volatile [noderef] <asn:2>*addr
   drivers/media/pci/netup_unidvb/netup_unidvb_spi.c:246:49:    got restricted __le16 *<noident>

vim +191 drivers/media/pci/netup_unidvb/netup_unidvb_core.c

   185		u32 irq_mask = (dma->num == 0 ?
   186			NETUP_UNIDVB_IRQ_DMA1 : NETUP_UNIDVB_IRQ_DMA2);
   187	
   188		dev_dbg(&dma->ndev->pci_dev->dev,
   189			"%s(): DMA%d enable %d\n", __func__, dma->num, enable);
   190		if (enable) {
 > 191			writel(BIT_DMA_RUN, &dma->regs->ctrlstat_set);
   192			writew(irq_mask,
 > 193				(u16 *)(dma->ndev->bmmio0 + REG_IMASK_SET));
   194		} else {
   195			writel(BIT_DMA_RUN, &dma->regs->ctrlstat_clear);
   196			writew(irq_mask,
   197				(u16 *)(dma->ndev->bmmio0 + REG_IMASK_CLEAR));
   198		}
   199	}
   200	
   201	static irqreturn_t netup_dma_interrupt(struct netup_dma *dma)
   202	{
   203		u64 addr_curr;
   204		u32 size;
   205		unsigned long flags;
   206		struct device *dev = &dma->ndev->pci_dev->dev;
   207	
   208		spin_lock_irqsave(&dma->lock, flags);
 > 209		addr_curr = ((u64)readl(&dma->regs->curr_addr_hi) << 32) |
   210			(u64)readl(&dma->regs->curr_addr_lo) | dma->high_addr;
   211		/* clear IRQ */
 > 212		writel(BIT_DMA_IRQ, &dma->regs->ctrlstat_clear);
   213		/* sanity check */
   214		if (addr_curr < dma->addr_phys ||
   215				addr_curr > dma->addr_phys +  dma->ring_buffer_size) {

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
