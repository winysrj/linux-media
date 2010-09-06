Return-path: <mchehab@gaivota>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:25805 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752441Ab0IFGxy (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 6 Sep 2010 02:53:54 -0400
Received: from eu_spt2 (mailout1.w1.samsung.com [210.118.77.11])
 by mailout1.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0L8B00297CHS60@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 06 Sep 2010 07:53:52 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0L8B009H3CHS9N@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 06 Sep 2010 07:53:52 +0100 (BST)
Date: Mon, 06 Sep 2010 08:53:42 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: [PATCH] various bugfixes for 2.6.36-rc3
To: linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, kyungmin.park@samsung.com,
	p.osciak@samsung.com, s.nawrocki@samsung.com
Message-id: <1283756030-28634-1-git-send-email-m.szyprowski@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Hello,

This patch series fixes a bunch of minor bugs in s5p-fimc driver,
videobuf and si470x radio driver.

This patch series has been prepared against linus/2.6.36-rc3 kernel
tree. I would like to get it merged soon to be sure that they will be
included in the final 2.6.36 release.

The complete list of patches:

[PATCH 1/8] v4l: s5p-fimc: Fix return value on probe() failure
[PATCH 2/8] v4l: s5p-fimc: Fix 3-planar formats handling and pixel offset error on S5PV210 SoCs
[PATCH 3/8] v4l: s5p-fimc: Register definition cleanup
[PATCH 4/8] v4l: videobuf: Fail streamon on an output device when no buffers queued
[PATCH 5/8] v4l: videobuf: prevent passing a NULL to dma_free_coherent()
[PATCH 6/8] v4l: videobuf: remove unused is_userptr variable
[PATCH 7/8] v4l: Add EBUSY error description for VIDIOC_STREAMON
[PATCH 8/8] v4l: radio: si470x: fix unneeded free_irq() call

Best regards
-- 
Marek Szyprowski
Samsung Poland R&D Center
