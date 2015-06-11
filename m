Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay1.mentorg.com ([192.94.38.131]:45706 "EHLO
	relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753056AbbFKN2g (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Jun 2015 09:28:36 -0400
From: Vladimir Zapolskiy <vladimir_zapolskiy@mentor.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Philipp Zabel <p.zabel@pengutronix.de>
CC: Shawn Guo <shawn.guo@linaro.org>,
	Sascha Hauer <kernel@pengutronix.de>,
	Nicolas Ferre <nicolas.ferre@atmel.com>,
	Alexandre Belloni <alexandre.belloni@free-electrons.com>,
	Russell King <linux@arm.linux.org.uk>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Vinod Koul <vinod.koul@intel.com>,
	Takashi Iwai <tiwai@suse.de>, Jaroslav Kysela <perex@perex.cz>,
	<dmaengine@vger.kernel.org>, <linux-media@vger.kernel.org>,
	<alsa-devel@alsa-project.org>,
	<linux-arm-kernel@lists.infradead.org>,
	<linux-kernel@vger.kernel.org>
Subject: [PATCH 0/2] genalloc: rename dev_get_gen_pool() and of_get_named_gen_pool()
Date: Thu, 11 Jun 2015 16:26:32 +0300
Message-ID: <1434029192-7082-1-git-send-email-vladimir_zapolskiy@mentor.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Trivial nonfunctional change initially based on discussion
https://lkml.org/lkml/2015/6/8/588

Worth to mention that instead of the assumed new name
dev_gen_pool_get(), this change attempts to be more close to other
in-kernel interfaces and new function name is just gen_pool_get().

The change is based and tested on linux-next.

Vladimir Zapolskiy (2):
  genalloc: rename dev_get_gen_pool() to gen_pool_get()
  genalloc: rename of_get_named_gen_pool() to of_gen_pool_get()

 arch/arm/mach-at91/pm.c                   |  2 +-
 arch/arm/mach-imx/pm-imx5.c               |  2 +-
 arch/arm/mach-imx/pm-imx6.c               |  2 +-
 drivers/dma/mmp_tdma.c                    |  2 +-
 drivers/media/platform/coda/coda-common.c |  4 ++--
 include/linux/genalloc.h                  |  6 +++---
 lib/genalloc.c                            | 14 +++++++-------
 sound/core/memalloc.c                     |  2 +-
 8 files changed, 17 insertions(+), 17 deletions(-)

-- 
2.1.4

