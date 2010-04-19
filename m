Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:16700 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754692Ab0DSMaX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 19 Apr 2010 08:30:23 -0400
Received: from eu_spt2 (mailout2.w1.samsung.com [210.118.77.12])
 by mailout2.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0L14005U1IQLQT@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 19 Apr 2010 13:30:21 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0L14007ZSIQK0J@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 19 Apr 2010 13:30:21 +0100 (BST)
Date: Mon, 19 Apr 2010 14:30:16 +0200
From: Pawel Osciak <p.osciak@samsung.com>
Subject: [PATCH v4 0/2] Mem-to-mem device framework
To: linux-media@vger.kernel.org
Cc: p.osciak@samsung.com, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, hvaibhav@ti.com
Message-id: <1271680218-32395-1-git-send-email-p.osciak@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

this is the fourth version of the mem-to-mem device framework.

Changes in v4:
- v4l2_m2m_poll() now also reports POLLOUT | POLLWRNORM when an output
  buffer is ready to be dequeued
- more cleaning up, addressing most of the comments to v3

Vaibhav: your clean-up patch didn't apply after my changes. I incorporated most
of your clean-up changes. If you prefer it to be separate, we will have
to prepare another one somehow. Also, sorry, but I cannot agree with changing
unsigned types into u32, I do not see any reason to use fixed-width types there.

This series contains:
[PATCH v4 1/2] v4l: Add memory-to-memory device helper framework for videobuf.
[PATCH v4 2/2] v4l: Add a mem-to-mem videobuf framework test device.

Best regards
--
Pawel Osciak
Linux Platform Group
Samsung Poland R&D Center
