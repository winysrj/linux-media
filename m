Return-path: <linux-media-owner@vger.kernel.org>
Received: from aer-iport-2.cisco.com ([173.38.203.52]:57745 "EHLO
	aer-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751471AbbGIIzj (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 9 Jul 2015 04:55:39 -0400
From: matrandg@cisco.com
To: linux-media@vger.kernel.org
Cc: hansverk@cisco.com, p.zabel@pengutronix.de, kernel@pengutronix.de,
	Mats Randgaard <matrandg@cisco.com>
Subject: [RFC v04] Driver for Toshiba TC358743
Date: Thu,  9 Jul 2015 10:45:46 +0200
Message-Id: <1436431547-27319-1-git-send-email-matrandg@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Mats Randgaard <matrandg@cisco.com>

Improvements based on feedback from Hans Verkuil:
- Use functions in linux/hdmi.h to print AVI info frames
- Replace private format change event with V4L2_EVENT_SOURCE_CHANGE
- Rewrite set_fmt/get_fmt
- Remove V4L2_SUBDEV_FL_HAS_DEVNODE

Other improvements since the previous version:
- Protect CONFCTL with a mutex since it is written in both process
  context and interrupt context
- Restructure and describe the platform data
- Replace the register that is verified in the probe function with the
  read-only register CHIPID

Mats Randgaard (1):
  Driver for Toshiba TC358743 HDMI to CSI-2 bridge

 MAINTAINERS                        |    7 +
 drivers/media/i2c/Kconfig          |    9 +
 drivers/media/i2c/Makefile         |    1 +
 drivers/media/i2c/tc358743.c       | 1778 ++++++++++++++++++++++++++++++++++++
 drivers/media/i2c/tc358743_regs.h  |  681 ++++++++++++++
 include/media/tc358743.h           |  131 +++
 include/uapi/linux/v4l2-controls.h |    4 +
 7 files changed, 2611 insertions(+)
 create mode 100644 drivers/media/i2c/tc358743.c
 create mode 100644 drivers/media/i2c/tc358743_regs.h
 create mode 100644 include/media/tc358743.h

-- 
2.4.3

