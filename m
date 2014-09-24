Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:40625 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751533AbaIXMl5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 24 Sep 2014 08:41:57 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 0/4] Remove smatch warnings on s5p-mfc driver
Date: Wed, 24 Sep 2014 09:41:38 -0300
Message-Id: <cover.1411562226.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When compiling s5p-mfc driver with:

make ARCH=i386 C=1 CF=-D__CHECK_ENDIAN__ CONFIG_DEBUG_SECTION_MISMATCH=y W=1 CF=-D__CHECK_ENDIAN__ M=drivers/media

Lots of smatch warnings are produced, because:
	- some static vars were missing 'static';
	- the readl/writel pointers were wrongly declared.

Fix them.

Mauro Carvalho Chehab (4):
  [media] s5p_mfc: use static for some structs
  [media] s5p_mfc_opr_v5: fix smatch warnings
  [media] s5p_mfc_opr_v6: fix wrong type for registers
  [media] s5p_mfc_opr_v6: remove address space removal warnings

 drivers/media/platform/s5p-mfc/s5p_mfc.c        |  24 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_opr.h    | 488 ++++++++++++------------
 drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.c |   4 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c |  12 +-
 4 files changed, 264 insertions(+), 264 deletions(-)

-- 
1.9.3

