Return-path: <mchehab@pedra>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:36665 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752690Ab1CJM3V (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Mar 2011 07:29:21 -0500
Received: from spt2.w1.samsung.com (mailout1.w1.samsung.com [210.118.77.11])
 by mailout1.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0LHU00K2PDCU54@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 10 Mar 2011 12:29:19 +0000 (GMT)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LHU00HBVDCU0Z@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 10 Mar 2011 12:29:18 +0000 (GMT)
Date: Thu, 10 Mar 2011 13:28:39 +0100
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: [PATCH 0/3] Another set of videobuf2 hotfixes
To: linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, kyungmin.park@samsung.com,
	andrzej.p@samsung.com, pawel@osciak.com
Message-id: <1299760122-29493-1-git-send-email-m.szyprowski@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hello!

This is one more set of hotfixes for videobuf2 framework.  I hope they
can be applied to staging/for-2.6.39 kernel tree once vb2 finally gets
into Linus tree.

Best regards
--
Marek Szyprowski
Samsung Poland R&D Center


Andrzej Pietrasiewicz (1):
  v4l2: vb2-dma-sg: fix potential security hole

Marek Szyprowski (2):
  v4l2: vb2: one more fix for REQBUFS()
  v4l2: vb2: simplify __vb2_queue_free function

 drivers/media/video/videobuf2-core.c   |   15 +++++++++------
 drivers/media/video/videobuf2-dma-sg.c |    2 +-
 2 files changed, 10 insertions(+), 7 deletions(-)

-- 
1.7.1.569.g6f426
