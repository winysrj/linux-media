Return-path: <mchehab@pedra>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:14869 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753930Ab1A1M5K (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 28 Jan 2011 07:57:10 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Received: from spt2.w1.samsung.com ([210.118.77.13]) by mailout3.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0LFQ00JK5HB7AR80@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 28 Jan 2011 12:57:08 +0000 (GMT)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LFQ00JR7HB7NR@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 28 Jan 2011 12:57:07 +0000 (GMT)
Date: Fri, 28 Jan 2011 13:56:38 +0100
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: [PATCH 0/2] Videobuf2 hot fixes
To: linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, pawel@osciak.com,
	kyungmin.park@samsung.com
Message-id: <1296219400-2582-1-git-send-email-m.szyprowski@samsung.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hello!

This is a small set of bugfixes for videobuf2 framework. It looks that
even review done by 3 other developers can miss some minor bugs. I hope
they can be applied to v2.6.38-rcX kernel series once vb2 finally gets
into Linus tree.

Best regards
--
Marek Szyprowski
Samsung Poland R&D Center


Patch summary:

Andrzej Pietrasiewicz (1):
  v4l2: vb2-dma-sg: fix memory leak

Marek Szyprowski (1):
  v4l2: vb2: fix queue reallocation and REQBUFS(0) case

 drivers/media/video/videobuf2-core.c   |    9 ++++++++-
 drivers/media/video/videobuf2-dma-sg.c |    2 ++
 2 files changed, 10 insertions(+), 1 deletions(-)

-- 
1.7.1.569.g6f426

