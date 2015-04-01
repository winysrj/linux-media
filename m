Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:36699 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750848AbbDALIo (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 1 Apr 2015 07:08:44 -0400
Date: Wed, 1 Apr 2015 19:07:56 +0800
From: kbuild test robot <fengguang.wu@intel.com>
To: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: kbuild-all@01.org, Mauro Carvalho Chehab <m.chehab@samsung.com>,
	linux-media@vger.kernel.org, Kamil Debski <k.debski@samsung.com>
Subject: [linuxtv-media:fixes 12/13]
 drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:1859:23: sparse: incorrect
 type in argument 2 (different address spaces)
Message-ID: <201504011954.HvJf0ZzV%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

tree:   git://linuxtv.org/media_tree.git fixes
head:   f3a4cf07c937f9133c27169b62a229c406db04b7
commit: 3ff634bac7d2049283018e65b472e4af7e2ae228 [12/13] [media] media: s5p-mfc: fix broken pointer cast on 64bit arch
reproduce:
  # apt-get install sparse
  git checkout 3ff634bac7d2049283018e65b472e4af7e2ae228
  make ARCH=x86_64 allmodconfig
  make C=1 CF=-D__CHECK_ENDIAN__


sparse warnings: (new ones prefixed by >>)

>> drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:1859:23: sparse: incorrect type in argument 2 (different address spaces)
   drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:1859:23:    expected void volatile [noderef] <asn:2>*addr
   drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:1859:23:    got void *<noident>
>> drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:1869:22: sparse: incorrect type in argument 1 (different address spaces)
   drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:1869:22:    expected void const volatile [noderef] <asn:2>*addr
   drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:1869:22:    got void *<noident>

vim +1859 drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c

  1853	}
  1854	
  1855	static void s5p_mfc_write_info_v6(struct s5p_mfc_ctx *ctx, unsigned int data,
  1856			unsigned int ofs)
  1857	{
  1858		s5p_mfc_clock_on();
> 1859		writel(data, (void *)((unsigned long)ofs));
  1860		s5p_mfc_clock_off();
  1861	}
  1862	
  1863	static unsigned int
  1864	s5p_mfc_read_info_v6(struct s5p_mfc_ctx *ctx, unsigned long ofs)
  1865	{
  1866		int ret;
  1867	
  1868		s5p_mfc_clock_on();
> 1869		ret = readl((void *)ofs);
  1870		s5p_mfc_clock_off();
  1871	
  1872		return ret;

---
0-DAY kernel test infrastructure                Open Source Technology Center
http://lists.01.org/mailman/listinfo/kbuild                 Intel Corporation
