Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:50894 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753278Ab2DPN7A (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Apr 2012 09:59:00 -0400
Received: from euspt2 (mailout1.w1.samsung.com [210.118.77.11])
 by mailout1.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0M2K00F4BS4CJB@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 16 Apr 2012 14:57:48 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0M2K00D6NS673Y@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 16 Apr 2012 14:58:56 +0100 (BST)
Date: Mon, 16 Apr 2012 15:58:47 +0200
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: [PATCHv2 0/8] Update to S5P-TV drivers
To: linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, t.stanislaws@samsung.com,
	kyungmin.park@samsung.com, laurent.pinchart@ideasonboard.com,
	mchehab@redhat.com, hverkuil@xs4all.nl, sachin.kamat@linaro.org,
	u.kleine-koenig@pengutronix.de
Message-id: <1334584735-12439-1-git-send-email-t.stanislaws@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patchset contains latest fixes and improvement to S5P-TV drivers.  The
most important new feature is a support for a variety of new DV presets
including interlaced ones.

Changelog:

v1:
- fix for computing plane size
- fix for variable linkage
- fix hdmiphy variants to avoid searching for modes
  only from valid platforms

Marek Szyprowski (1):
  media: s5p-tv: fix plane size calculation

Sachin Kamat (1):
  s5p-tv: Fix section mismatch warning in mixer_video.c

Tomasz Stanislawski (5):
  v4l: s5p-tv: mixer: fix compilation warning
  v4l: s5p-tv: hdmiphy: add support for per-platform variants
  v4l: s5p-tv: hdmi: parametrize DV timings
  v4l: s5p-tv: hdmi: fix mode synchronization
  v4l: s5p-tv: mixer: fix handling of interlaced modes

Uwe Kleine-König (1):
  media/video/s5p-tv: mark const init data with __initconst instead of
    __initdata

 drivers/media/video/s5p-tv/hdmi_drv.c    |  480 ++++++++++++++----------------
 drivers/media/video/s5p-tv/hdmiphy_drv.c |  225 ++++++++++++---
 drivers/media/video/s5p-tv/mixer.h       |    3 +-
 drivers/media/video/s5p-tv/mixer_drv.c   |    2 +-
 drivers/media/video/s5p-tv/mixer_reg.c   |   15 +-
 drivers/media/video/s5p-tv/mixer_video.c |    6 +-
 drivers/media/video/s5p-tv/regs-hdmi.h   |    1 +
 7 files changed, 427 insertions(+), 305 deletions(-)

-- 
1.7.5.4

