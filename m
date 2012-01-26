Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:44311 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751410Ab2AZRL5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 26 Jan 2012 12:11:57 -0500
Received: from euspt1 (mailout1.w1.samsung.com [210.118.77.11])
 by mailout1.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0LYF000OM13V3L@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 26 Jan 2012 17:11:56 +0000 (GMT)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LYF00DRU13VFN@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 26 Jan 2012 17:11:55 +0000 (GMT)
Date: Thu, 26 Jan 2012 18:11:49 +0100
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: [PATCH 0/3] Updates to S5P-TV drivers
To: linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, t.stanislaws@samsung.com,
	kyungmin.park@samsung.com, hverkuil@xs4all.nl,
	laurent.pinchart@ideasonboard.com
Message-id: <1327597912-30105-1-git-send-email-t.stanislaws@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Everyone,
This patchset introduces SII9234 driver for MHL interface for latest Samsung
boards from Exynos family.  It also adds support for platform data in S5P-HDMI
driver. Finally S5P-HDMI is integrated with SII9234.

Regards,
Tomasz Stanislawski


Tomasz Stanislawski (3):
  v4l: s5p-tv: add sii9234 driver
  v4l: s5p-tv: hdmi: add support for platform data
  v4l: s5p-tv: hdmi: integrate with MHL

 drivers/media/video/s5p-tv/Kconfig       |   10 +
 drivers/media/video/s5p-tv/Makefile      |    2 +
 drivers/media/video/s5p-tv/hdmi_drv.c    |   86 ++++--
 drivers/media/video/s5p-tv/sii9234_drv.c |  432 ++++++++++++++++++++++++++++++
 include/media/s5p_hdmi.h                 |   35 +++
 include/media/sii9234.h                  |   24 ++
 6 files changed, 563 insertions(+), 26 deletions(-)
 create mode 100644 drivers/media/video/s5p-tv/sii9234_drv.c
 create mode 100644 include/media/s5p_hdmi.h
 create mode 100644 include/media/sii9234.h

-- 
1.7.5.4

