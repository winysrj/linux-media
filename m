Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:1069 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751748AbbFELYs (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 5 Jun 2015 07:24:48 -0400
Date: Fri, 5 Jun 2015 19:24:26 +0800
From: kbuild test robot <fengguang.wu@intel.com>
To: Aravind Gopalakrishnan <Aravind.Gopalakrishnan@amd.com>
Cc: kbuild-all@01.org, Borislav Petkov <bp@suse.de>,
	Doug Thompson <dougthompson@xmission.com>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	linux-media@vger.kernel.org, linux-edac@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [bp:for-next 15/22] drivers/edac/mce_amd_inj.c:47:21: sparse: symbol
 'inj_type' was not declared. Should it be static?
Message-ID: <201506051907.ofv5fD3p%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

tree:   git://git.kernel.org/pub/scm/linux/kernel/git/bp/bp for-next
head:   6db4e6b99ba0dad4e42612a546a99ccdbd766561
commit: 0451d14d05618e5fcbdc5017a30e3d609ddc8229 [15/22] EDAC, mce_amd_inj: Modify flags attribute to use string arguments
reproduce:
  # apt-get install sparse
  git checkout 0451d14d05618e5fcbdc5017a30e3d609ddc8229
  make ARCH=x86_64 allmodconfig
  make C=1 CF=-D__CHECK_ENDIAN__


sparse warnings: (new ones prefixed by >>)

>> drivers/edac/mce_amd_inj.c:47:21: sparse: symbol 'inj_type' was not declared. Should it be static?
   drivers/edac/mce_amd_inj.c:320:1: sparse: symbol '__UNIQUE_ID_author__COUNTER__' has multiple initializers (originally initialized at drivers/edac/mce_amd_inj.c:319)

Please review and possibly fold the followup patch.

---
0-DAY kernel test infrastructure                Open Source Technology Center
http://lists.01.org/mailman/listinfo/kbuild                 Intel Corporation
