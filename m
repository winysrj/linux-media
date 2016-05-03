Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:59984 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756496AbcECU2P (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 3 May 2016 16:28:15 -0400
From: Javier Martinez Canillas <javier@osg.samsung.com>
To: linux-kernel@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
	Krzysztof Kozlowski <k.kozlowski@samsung.com>,
	Javier Martinez Canillas <javier@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Kamil Debski <k.debski@samsung.com>,
	Jeongtae Park <jtp.park@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	stable@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-media@vger.kernel.org
Subject: [PATCH 0/3] [media] s5p-mfc: Fixes for issues when module is removed
Date: Tue,  3 May 2016 16:27:15 -0400
Message-Id: <1462307238-21815-1-git-send-email-javier@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

This patch series fixes some issues that I noticed when trying to remove
the s5p-mfc driver when built as a module.

Some of these issues will be fixed once Marek's patches to convert the
custom memory region reservation code is replaced by a generic one that
supports named memory region reservation [0]. But the fixes are trivial
so we can fix the current code until his rework patch lands.

[0]: https://patchwork.linuxtv.org/patch/32287/

Best regards,
Javier


Javier Martinez Canillas (3):
  [media] s5p-mfc: Set device name for reserved memory region devs
  [media] s5p-mfc: Add release callback for memory region devs
  [media] s5p-mfc: Fix race between s5p_mfc_probe() and s5p_mfc_open()

 drivers/media/platform/s5p-mfc/s5p_mfc.c | 50 ++++++++++++++++++++------------
 1 file changed, 32 insertions(+), 18 deletions(-)

-- 
2.5.5

