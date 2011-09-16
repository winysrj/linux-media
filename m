Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:57743 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755467Ab1IPRFg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 16 Sep 2011 13:05:36 -0400
Received: from euspt2 (mailout1.w1.samsung.com [210.118.77.11])
 by mailout1.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0LRM003O9KTAZP@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 16 Sep 2011 18:05:34 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LRM00KN0KTAAI@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 16 Sep 2011 18:05:34 +0100 (BST)
Date: Fri, 16 Sep 2011 19:05:27 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH 0/3] Add v4l2 subdev driver for S5K6AAFX sensor with embedded
 ISP
To: linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, kyungmin.park@samsung.com,
	laurent.pinchart@ideasonboard.com, s.nawrocki@samsung.com,
	sw0312.kim@samsung.com, riverful.kim@samsung.com
Message-id: <1316192730-18099-1-git-send-email-s.nawrocki@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

The following 3 patches add the S5K6AAFX sensor with embedded ISP driver and
minor enhancement of v4l2 control API. This is not a complete work and I thought
I'd publish this to get some feedback as early as possible.

In particular this driver depends on planned R/G/B component gain controls. 

Sylwester Nawrocki (3):
  v4l: Extend V4L2_CID_COLORFX control with AQUA effect
  v4l: Add AUTO option for the V4L2_CID_POWER_LINE_FREQUENCY control
  v4l: Add S5K6AA(FX) sensor driver

 Documentation/DocBook/media/v4l/controls.xml |   10 +-
 drivers/media/video/Kconfig                  |    6 +
 drivers/media/video/Makefile                 |    1 +
 drivers/media/video/s5k6aa.c                 | 1578 ++++++++++++++++++++++++++
 drivers/media/video/v4l2-ctrls.c             |    1 +
 include/linux/videodev2.h                    |    2 +
 include/media/s5k6aa.h                       |   51 +
 7 files changed, 1645 insertions(+), 4 deletions(-)
 create mode 100644 drivers/media/video/s5k6aa.c
 create mode 100644 include/media/s5k6aa.h


Regards,
--
Sylwester Nawrocki
Samsung Poland R&D Center
