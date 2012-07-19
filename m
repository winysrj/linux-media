Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:61667 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752895Ab2GSMPQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 19 Jul 2012 08:15:16 -0400
Received: by wgbdr13 with SMTP id dr13so2395986wgb.1
        for <linux-media@vger.kernel.org>; Thu, 19 Jul 2012 05:15:15 -0700 (PDT)
From: Sangwook Lee <sangwook.lee@linaro.org>
To: linux-media@vger.kernel.org
Cc: mchehab@infradead.org, laurent.pinchart@ideasonboard.com,
	sakari.ailus@maxwell.research.nokia.com, suapapa@insignal.co.kr,
	quartz.jang@samsung.com, linaro-dev@lists.linaro.org,
	patches@linaro.org, usman.ahmad@linaro.org,
	david.a.cohen@linux.intel.com,
	Sangwook Lee <sangwook.lee@linaro.org>
Subject: [PATCH v2 0/2] Add v4l2 subdev driver for S5K4ECGX sensor with embedded SoC ISP
Date: Thu, 19 Jul 2012 13:14:05 +0100
Message-Id: <1342700047-31806-1-git-send-email-sangwook.lee@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following 2 patches add driver for S5K4ECGX sensor with embedded ISP SoC,
and minor v4l2 control API enhancement. S5K4ECGX is 5M CMOS Image sensor from Samsung.

Changes since v1:
- fixed s_stream(0) when it called twice
- changed mutex_X position to be used when strictly necessary
- add additional s_power(0) in case that error happens
- update more accurate debugging statements
- remove dummy else 

Sangwook Lee (2):
  v4l: Add factory register values form S5K4ECGX sensor
  v4l: Add v4l2 subdev driver for S5K4ECGX sensor

 drivers/media/video/Kconfig         |    7 +
 drivers/media/video/Makefile        |    1 +
 drivers/media/video/s5k4ecgx.c      |  881 ++++++++++
 drivers/media/video/s5k4ecgx_regs.h | 3121 +++++++++++++++++++++++++++++++++++
 include/media/s5k4ecgx.h            |   29 +
 5 files changed, 4039 insertions(+)
 create mode 100644 drivers/media/video/s5k4ecgx.c
 create mode 100644 drivers/media/video/s5k4ecgx_regs.h
 create mode 100644 include/media/s5k4ecgx.h

-- 
1.7.9.5

