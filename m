Return-path: <mchehab@pedra>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:21550 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751333Ab1GAPEi (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 1 Jul 2011 11:04:38 -0400
Received: from eu_spt1 (mailout2.w1.samsung.com [210.118.77.12])
 by mailout2.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0LNN008PDTVOAX@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 01 Jul 2011 16:04:36 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LNN00058TVM46@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 01 Jul 2011 16:04:35 +0100 (BST)
Date: Fri, 01 Jul 2011 17:04:28 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH v2 0/4] noon010pc30 driver conversion to the pad level
 operations
To: linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, kyungmin.park@samsung.com,
	laurent.pinchart@ideasonboard.com, s.nawrocki@samsung.com,
	sw0312.kim@samsung.com, riverful.kim@samsung.com
Message-id: <1309532672-17920-1-git-send-email-s.nawrocki@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

The following patch set converts noon010pc30 camera sensor driver to the 
subdev pad level operations. Additionally it adds a s_stream operation
and marks driver as experimental as it now uses V4L2 sub-device API.
Now unneeded g_chip_ident op is also removed.

Changes since v1:
- fixed subdev's flags initialization
- corrected s_stream handler so the sensor's sleep mode is used
  for suspending/resuming the output signal
- removed g_chip_indent operation handler

Sylwester Nawrocki (4):
  noon010pc30: Do not ignore errors in initial controls setup
  noon010pc30: Convert to the pad level ops
  noon010pc30: Clean up the s_power callback
  noon010pc30: Remove g_chip_ident operation handler

 drivers/media/video/Kconfig       |    2 +-
 drivers/media/video/noon010pc30.c |  173 +++++++++++++++++++++++--------------
 include/media/v4l2-chip-ident.h   |    3 -
 3 files changed, 109 insertions(+), 69 deletions(-)


Regards,
--
Sylwester Nawrocki
Samsung Poland R&D Center
