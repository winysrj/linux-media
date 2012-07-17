Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:58144 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752173Ab2GQQSd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Jul 2012 12:18:33 -0400
Received: by eaak11 with SMTP id k11so237483eaa.19
        for <linux-media@vger.kernel.org>; Tue, 17 Jul 2012 09:18:31 -0700 (PDT)
From: Sangwook Lee <sangwook.lee@linaro.org>
To: linux-media@vger.kernel.org
Cc: mchehab@infradead.org, laurent.pinchart@ideasonboard.com,
	s.nawrocki@samsung.com, kyungmin.park@samsung.com,
	sakari.ailus@maxwell.research.nokia.com, suapapa@insignal.co.kr,
	quartz.jang@samsung.com, linaro-dev@lists.linaro.org,
	patches@linaro.org, Sangwook Lee <sangwook.lee@linaro.org>
Subject: [PATCH 0/2] Add v4l2 subdev driver for S5K4ECGX sensor with embedded SoC ISP
Date: Tue, 17 Jul 2012 17:17:08 +0100
Message-Id: <1342541830-22667-1-git-send-email-sangwook.lee@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following 2 patches add driver for S5K4ECGX sensor with embedded ISP SoC,
and minor v4l2 control API enhancement. S5K4ECGX is 5M CMOS Image sensor from Samsung.

Currenlty ony preview mode is supported. (no capture mode/face detection)

Sangwook Lee (2):
  v4l: Add factory register values form S5K4ECGX sensor
  v4l: Add v4l2 subdev driver for S5K4ECGX sensor

 drivers/media/video/Kconfig         |    7 +
 drivers/media/video/Makefile        |    1 +
 drivers/media/video/s5k4ecgx.c      |  871 ++++++++++
 drivers/media/video/s5k4ecgx_regs.h | 3121 +++++++++++++++++++++++++++++++++++
 include/media/s5k4ecgx.h            |   29 +
 5 files changed, 4029 insertions(+)
 create mode 100644 drivers/media/video/s5k4ecgx.c
 create mode 100644 drivers/media/video/s5k4ecgx_regs.h
 create mode 100644 include/media/s5k4ecgx.h

-- 
1.7.9.5

