Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:49782 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758122Ab2HJOQH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 10 Aug 2012 10:16:07 -0400
Received: by eaac11 with SMTP id c11so519125eaa.19
        for <linux-media@vger.kernel.org>; Fri, 10 Aug 2012 07:16:06 -0700 (PDT)
From: Sangwook Lee <sangwook.lee@linaro.org>
To: linux-media@vger.kernel.org
Cc: mchehab@infradead.org, laurent.pinchart@ideasonboard.com,
	sakari.ailus@maxwell.research.nokia.com, suapapa@insignal.co.kr,
	quartz.jang@samsung.com, linaro-dev@lists.linaro.org,
	patches@linaro.org, usman.ahmad@linaro.org,
	Sangwook Lee <sangwook.lee@linaro.org>
Subject: [PATCH v4 0/2] Add v4l2 subdev driver for S5K4ECGX sensor with embedded SoC ISP 
Date: Fri, 10 Aug 2012 15:14:54 +0100
Message-Id: <1344608096-22059-1-git-send-email-sangwook.lee@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following 2 patches add driver for S5K4ECGX sensor with embedded ISP SoC,
and minor v4l2 control API enhancement. S5K4ECGX is 5M CMOS Image sensor from Samsung

Changes since v3:
- used request_firmware to configure initial settings
- added parsing functions to read initial settings
- updated regulator API
- reduced preview setting tables by experiment 

Changes since v2:
- added GPIO (reset/stby) and regulators
- updated I2C read/write, based on s5k6aa datasheet
- fixed set_fmt errors
- reduced register tables a bit
- removed vmalloc

Changes since v1:
- fixed s_stream(0) when it called twice
- changed mutex_X position to be used when strictly necessary
- add additional s_power(0) in case that error happens
- update more accurate debugging statements
- remove dummy else

Sangwook Lee (2):
  v4l: Add factory register values form S5K4ECGX sensor
  v4l: Add v4l2 subdev driver for S5K4ECGX sensor

 drivers/media/video/Kconfig         |    8 +
 drivers/media/video/Makefile        |    1 +
 drivers/media/video/s5k4ecgx.c      |  941 +++++++++++++++++++++++++++++++++++
 drivers/media/video/s5k4ecgx_regs.h |  138 +++++
 include/media/s5k4ecgx.h            |   37 ++
 5 files changed, 1125 insertions(+)
 create mode 100644 drivers/media/video/s5k4ecgx.c
 create mode 100644 drivers/media/video/s5k4ecgx_regs.h
 create mode 100644 include/media/s5k4ecgx.h

-- 
1.7.9.5

