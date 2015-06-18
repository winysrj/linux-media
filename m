Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay1.mentorg.com ([192.94.38.131]:45456 "EHLO
	relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752896AbbFRP01 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 18 Jun 2015 11:26:27 -0400
From: Vladimir Zapolskiy <vladimir_zapolskiy@mentor.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Russell King <linux@arm.linux.org.uk>,
	Nicolas Ferre <nicolas.ferre@atmel.com>,
	Alexandre Belloni <alexandre.belloni@free-electrons.com>,
	Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
	Shawn Guo <shawnguo@kernel.org>,
	Sascha Hauer <kernel@pengutronix.de>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Arnd Bergmann <arnd@arndb.de>
CC: <linux-arm-kernel@lists.infradead.org>,
	<linux-media@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 0/2] genalloc: add support of multiple gen_pools per device
Date: Thu, 18 Jun 2015 18:26:02 +0300
Message-ID: <1434641162-23908-1-git-send-email-vladimir_zapolskiy@mentor.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is continuation of development of a proposed earlier
functionality to have multiple gen_pools per device, see
https://lkml.org/lkml/2015/6/8/588 discussion.

The main difference with the originally sent change is that instead of
adding two new interfaces gen_pool_get_named() and
devm_gen_pool_create_named(), it is considered better to change
signatures of the existing exported functions, because
devm_gen_pool_create() may be misused -- it is permitted to create
several gen_pool objects assigned to the same device and
gen_pool_get() returns only the first found object from device devres
data due to missing devres_match helper, fortunately currently
existing genalloc clients are not tainted -- at the moment the sole
user of devm_gen_pool_create() is drivers/misc/sram.c.

The change is split into two parts:
- update gen_pool_get() and devm_gen_pool_create() interfaces
  on client side
- implement proper handling of new gen_pool "name" argument
  and extend of_gen_pool_get() functionality based on it

Both changes are backward compatible in sense of functionality.

The lib/genalloc.c changes are based on two patches from -mm tree:
- http://ozlabs.org/~akpm/mmots/broken-out/genalloc-rename-dev_get_gen_pool-to-gen_pool_get.patch
- http://ozlabs.org/~akpm/mmots/broken-out/genalloc-rename-of_get_named_gen_pool-to-of_gen_pool_get.patch

The client side changes are based on linux-next/master branch.

Changes from v1 to v2:
- addressed Andrew's valuable review comments, namely
-- devm_gen_pool_create() is aware of attempts to register ambiguously
   addressed gen_pool objects and now it returns ERR_PTR() on error,
-- memory management to store gen_pool name literal is done on
   genalloc side,
-- replaced -1 with NUMA_NO_NODE in nid argument description,
- minor updates in of_gen_pool_get() change to respect OF_DYNAMIC
- instead of adding two new functions the existing functions
  gen_pool_get() (at91, imx5m, imx6 and CODA driver clients) and
  devm_gen_pool_create() (sram client) are updated.

Vladimir Zapolskiy (2):
  genalloc: add name arg to gen_pool_get() and devm_gen_pool_create()
  genalloc: add support of multiple gen_pools per device

 arch/arm/mach-at91/pm.c                   |  2 +-
 arch/arm/mach-imx/pm-imx5.c               |  2 +-
 arch/arm/mach-imx/pm-imx6.c               |  2 +-
 drivers/media/platform/coda/coda-common.c |  2 +-
 drivers/misc/sram.c                       |  8 +--
 include/linux/genalloc.h                  |  6 +-
 lib/genalloc.c                            | 99 +++++++++++++++++++++++--------
 7 files changed, 85 insertions(+), 36 deletions(-)

-- 
2.1.4

