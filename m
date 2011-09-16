Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:26431 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751803Ab1IPQAC (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 16 Sep 2011 12:00:02 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Received: from euspt2 ([210.118.77.14]) by mailout4.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0LRM00LEZHS00P50@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 16 Sep 2011 17:00:00 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LRM00KROHRZAI@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 16 Sep 2011 17:00:00 +0100 (BST)
Date: Fri, 16 Sep 2011 17:59:53 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH v3 0/3] Conversion of the NOON010PC30 sensor driver to media
 controller API
To: linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, kyungmin.park@samsung.com,
	laurent.pinchart@ideasonboard.com, s.nawrocki@samsung.com,
	sw0312.kim@samsung.com, riverful.kim@samsung.com
Message-id: <1316188796-8374-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

The following patch set converts noon010pc30 camera sensor driver to the 
subdev pad level operations and user-space V4L2 subdev API. 
In addition it implements s_stream operation, removes the now unneeded
g_chip_ident op and tags the driver as experimental.

Changes since v1:
- fixed subdev's flags initialization
- corrected s_stream handler so the sensor's sleep mode is used
  for suspending/resuming the output signal
- removed g_chip_indent operation handler

Changes since v2:
- added subdev internal open() operation
- moved registers access to s_power or s_stream so the user space
 calls are supported before/without enabling sensor's power

Sylwester Nawrocki (3):
  noon010pc30: Conversion to the media controller API
  noon010pc30: Improve s_power operation handling
  noon010pc30: Remove g_chip_ident operation handler

 drivers/media/video/Kconfig       |    2 +-
 drivers/media/video/noon010pc30.c |  295 ++++++++++++++++++++++---------------
 include/media/v4l2-chip-ident.h   |    3 -
 3 files changed, 177 insertions(+), 123 deletions(-)


Regards,
--
Sylwester Nawrocki
Samsung Poland R&D Center
