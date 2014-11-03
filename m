Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:19473 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752144AbaKCTno (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 3 Nov 2014 14:43:44 -0500
Date: Tue, 4 Nov 2014 03:43:32 +0800
From: kbuild test robot <fengguang.wu@intel.com>
To: Olli Salonen <olli.salonen@iki.fi>
Cc: kbuild-all@01.org, Mauro Carvalho Chehab <m.chehab@samsung.com>,
	linux-media@vger.kernel.org, Antti Palosaari <crope@iki.fi>
Subject: drivers/media/dvb-frontends/sp2.c:269:5: sparse: symbol 'sp2_init'
 was not declared. Should it be static?
Message-ID: <201411040318.niuibqCw%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

tree:   git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master
head:   0df1f2487d2f0d04703f142813d53615d62a1da4
commit: 868736ad3404b205794bc04233eca58293818dea [media] sp2: Add I2C driver for CIMaX SP2 common interface module
date:   9 weeks ago
reproduce:
  # apt-get install sparse
  git checkout 868736ad3404b205794bc04233eca58293818dea
  make ARCH=x86_64 allmodconfig
  make C=1 CF=-D__CHECK_ENDIAN__


sparse warnings: (new ones prefixed by >>)

>> drivers/media/dvb-frontends/sp2.c:269:5: sparse: symbol 'sp2_init' was not declared. Should it be static?
>> drivers/media/dvb-frontends/sp2.c:351:5: sparse: symbol 'sp2_exit' was not declared. Should it be static?

Please review and possibly fold the followup patch.

---
0-DAY kernel test infrastructure                Open Source Technology Center
http://lists.01.org/mailman/listinfo/kbuild                 Intel Corporation
