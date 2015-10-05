Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:48150 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750781AbbJEKvq (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 5 Oct 2015 06:51:46 -0400
Date: Mon, 5 Oct 2015 18:50:47 +0800
From: kbuild test robot <lkp@intel.com>
To: Benjamin Gaignard <benjamin.gaignard@linaro.org>
Cc: kbuild-all@01.org, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
	daniel.vetter@ffwll.ch, robdclark@gmail.com, treding@nvidia.com,
	sumit.semwal@linaro.org, tom.cooksey@arm.com,
	daniel.stone@collabora.com, linux-security-module@vger.kernel.org,
	xiaoquan.li@vivantecorp.com, tom.gall@linaro.org,
	linaro-mm-sig@lists.linaro.org,
	Benjamin Gaignard <benjamin.gaignard@linaro.org>
Subject: Re: [PATCH v4 2/2] SMAF: add CMA allocator
Message-ID: <201510051847.pHUoDbfg%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1444039898-7927-3-git-send-email-benjamin.gaignard@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Benjamin,

[auto build test WARNING on v4.3-rc4 -- if it's inappropriate base, please ignore]

reproduce:
        # apt-get install sparse
        make ARCH=x86_64 allmodconfig
        make C=1 CF=-D__CHECK_ENDIAN__


sparse warnings: (new ones prefixed by >>)

>> drivers/smaf/smaf-cma.c:178:23: sparse: symbol 'smaf_cma' was not declared. Should it be static?

Please review and possibly fold the followup patch.

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
