Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:50001 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753161Ab1ITL7H (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 20 Sep 2011 07:59:07 -0400
Received: from euspt1 (mailout2.w1.samsung.com [210.118.77.12])
 by mailout2.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0LRT009CCLAF7T@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 20 Sep 2011 12:59:03 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LRT00MVQLAELZ@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 20 Sep 2011 12:59:03 +0100 (BST)
Date: Tue, 20 Sep 2011 13:58:56 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH v1 0/3] Add v4l2 subdev driver for S5K6AAFX sensor with
 embedded SoC ISP
To: linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, kyungmin.park@samsung.com,
	laurent.pinchart@ideasonboard.com, sakari.ailus@iki.fi,
	sw0312.kim@samsung.com, riverful.kim@samsung.com,
	s.nawrocki@samsung.com
Message-id: <1316519939-22540-1-git-send-email-s.nawrocki@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

The following 3 patches add driver for S5K6AAFX sensor with embedded ISP SoC,
and minor v4l2 control API enhancement. I've cleaned things up comparing to
the previous RFC version so this should potentially be ready for mainline.
The driver has been tested with the Auto White Balance/RGB gain controls removed,
which I'd like to handle as a next step.

Any commments, Ack (or Nack) are appreciated;)


Sylwester Nawrocki (3):
  v4l: Extend V4L2_CID_COLORFX control with AQUA effect
  v4l: Add AUTO option for the V4L2_CID_POWER_LINE_FREQUENCY control
  v4l: Add v4l2 subdev driver for S5K6AAFX sensor

 Documentation/DocBook/media/v4l/controls.xml |   10 +-
 drivers/media/video/Kconfig                  |    6 +
 drivers/media/video/Makefile                 |    1 +
 drivers/media/video/s5k6aa.c                 | 1483 ++++++++++++++++++++++++++
 drivers/media/video/v4l2-ctrls.c             |    1 +
 include/linux/videodev2.h                    |    2 +
 include/media/s5k6aa.h                       |   51 +
 7 files changed, 1550 insertions(+), 4 deletions(-)
 create mode 100644 drivers/media/video/s5k6aa.c
 create mode 100644 include/media/s5k6aa.h


Thanks,
--
Sylwester Nawrocki
Samsung Poland R&D Center
