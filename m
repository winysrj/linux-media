Return-path: <mchehab@pedra>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:24662 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753151Ab1FBHwU (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 2 Jun 2011 03:52:20 -0400
Received: from spt2.w1.samsung.com (mailout2.w1.samsung.com [210.118.77.12])
 by mailout2.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0LM500C00KJ3M7@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 02 Jun 2011 08:52:15 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LM500IK0KJ147@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 02 Jun 2011 08:52:14 +0100 (BST)
Date: Thu, 02 Jun 2011 09:52:07 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: [PATCH] MAINTAINERS: Add videobuf2 maintainers
To: linux-media@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Pawel Osciak <pawel@osciak.com>
Message-id: <1307001127-11757-1-git-send-email-m.szyprowski@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Add maintainers for the videobuf2 V4L2 driver framework.

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 MAINTAINERS |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 29801f7..63be58b 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6720,6 +6720,15 @@ S:	Maintained
 F:	Documentation/filesystems/vfat.txt
 F:	fs/fat/
 
+VIDEOBUF2 FRAMEWORK
+M:	Pawel Osciak <pawel@osciak.com>
+M:	Marek Szyprowski <m.szyprowski@samsung.com>
+M:	Kyungmin Park <kyungmin.park@samsung.com>
+L:	linux-media@vger.kernel.org
+S:	Maintained
+F:	drivers/media/video/videobuf2-*
+F:	include/media/videobuf2-*
+
 VIRTIO CONSOLE DRIVER
 M:	Amit Shah <amit.shah@redhat.com>
 L:	virtualization@lists.linux-foundation.org
-- 
1.7.1.569.g6f426

