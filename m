Return-path: <linux-media-owner@vger.kernel.org>
Received: from aer-iport-2.cisco.com ([173.38.203.52]:46995 "EHLO
	aer-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751966AbbDXN02 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 24 Apr 2015 09:26:28 -0400
From: matrandg@cisco.com
To: linux-media@vger.kernel.org
Cc: hansverk@cisco.com, p.zabel@pengutronix.de, kernel@pengutronix.de,
	Mats Randgaard <matrandg@cisco.com>
Subject: [RCF02] Driver for Toshiba TC358743 CSI-2 to HDMI bridge
Date: Fri, 24 Apr 2015 15:26:22 +0200
Message-Id: <1429881983-4711-1-git-send-email-matrandg@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Mats Randgaard <matrandg@cisco.com>

Hi,
I have finally finished the second RFC for this driver.

Changes since RFC01:
- Improved code based on feedback from Hans and Philipp. For the CSI
  parameters have I only written a set of values that can serve as a
  starting point, since calculation of the parameters in the driver will
  require more work.
- Fixed problem with some sources that are transmitting an unstable signal
  while they are in standby.
- Fixed problem where audio was not received from some sources after
  coming out of standby, reconnecting cable or stopping/starting the
  stream.
- When the stream is enabled a proper lane transition is triggered on the
  CSI interface to ensure that the CSI receiver is ready.
- All CE and IT formats are detected as RGB full quantization range in DVI
  mode.

Philipp, I have not had time to look at your patches, so maybe you can
rebase them on this version of the driver?

Mats Randgaard (1):
  Driver for Toshiba TC358743 CSI-2 to HDMI bridge

 MAINTAINERS                        |    6 +
 drivers/media/i2c/Kconfig          |    9 +
 drivers/media/i2c/Makefile         |    1 +
 drivers/media/i2c/tc358743.c       | 1838 ++++++++++++++++++++++++++++++++++++
 drivers/media/i2c/tc358743_regs.h  |  680 +++++++++++++
 include/media/tc358743.h           |   92 ++
 include/uapi/linux/v4l2-controls.h |    4 +
 7 files changed, 2630 insertions(+)
 create mode 100644 drivers/media/i2c/tc358743.c
 create mode 100644 drivers/media/i2c/tc358743_regs.h
 create mode 100644 include/media/tc358743.h

-- 
2.3.4

