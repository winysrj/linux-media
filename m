Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:60009 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753601Ab2CMNfW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 13 Mar 2012 09:35:22 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Received: from euspt1 ([210.118.77.13]) by mailout3.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0M0T00HQWSEV3D90@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 13 Mar 2012 13:35:19 +0000 (GMT)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0M0T00C3TSEUSK@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 13 Mar 2012 13:35:19 +0000 (GMT)
Date: Tue, 13 Mar 2012 14:35:08 +0100
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: [PATCH 0/6] Update to S5P-TV drivers
To: linux-media@vger.kernel.org
Cc: sachin.kamat@linaro.org, m.szyprowski@samsung.com,
	t.stanislaws@samsung.com, kyungmin.park@samsung.com,
	hverkuil@xs4all.nl, laurent.pinchart@ideasonboard.com
Message-id: <1331645714-24535-1-git-send-email-t.stanislaws@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patchset contains latest fixes and improvement to S5P-TV drivers.  The
most important new feature is a support for a variety of new DV presets
including interlaced ones.

Sachin Kamat (1):
  s5p-tv: Fix section mismatch warning in mixer_video.c

Tomasz Stanislawski (5):
  v4l: s5p-tv: mixer: fix compilation warning
  v4l: s5p-tv: hdmiphy: add support for per-platform variants
  v4l: s5p-tv: hdmi: parametrize DV timings
  v4l: s5p-tv: hdmi: fix mode synchronization
  v4l: s5p-tv: mixer: fix handling of interlaced modes

 drivers/media/video/s5p-tv/hdmi_drv.c    |  480 ++++++++++++++----------------
 drivers/media/video/s5p-tv/hdmiphy_drv.c |  227 ++++++++++++---
 drivers/media/video/s5p-tv/mixer.h       |    3 +-
 drivers/media/video/s5p-tv/mixer_reg.c   |   15 +-
 drivers/media/video/s5p-tv/mixer_video.c |    4 +-
 drivers/media/video/s5p-tv/regs-hdmi.h   |    1 +
 6 files changed, 424 insertions(+), 306 deletions(-)

-- 
1.7.5.4

