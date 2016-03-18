Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:53229 "EHLO
	lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752128AbcCRKc6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 18 Mar 2016 06:32:58 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Armin Weiss <weii@zhaw.ch>
Subject: [RFCv1 PATCH 0/2] Driver for the Toshiba tc358840 HDMI-to-CSI2 bridge
Date: Fri, 18 Mar 2016 11:32:50 +0100
Message-Id: <1458297172-31867-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

This is an initial version for the Toshiba tc358840 HDMI-to-CSI2 bridge.

The original code was contributed by Armin Weiss and I have cleaned it up,
rebased it to our media tree, finalized the 4k support and added CEC
support (this is a separate patch and sits on top of the CEC v13 patch series
which will be posted soon).

My git tree containing the CEC v13 patches + these tc358840 patches is here:

http://git.linuxtv.org/hverkuil/media_tree.git/log/?h=tc358840

This will be rebased every so often! You're warned :-)

There are various things that need cleaning up before this is ready for mainlining:

- The device tree properties are messy and need to be cleaned up and properly
  documented.
- There are a lot of FIXMEs that have to be checked (especially writes to registers
  where it is not clear if that should be done or not).
- The isr has a bunch of mdelay calls: I need to verify which of these (if any) is
  really necessary and basically figure out what is going on there.

Note for Armin: the EDID isn't set in this driver. It is userspace (or possibly the
V4L2 driver) that has to set it. This is not something that this driver can decide.

The v4l2-ctl utility can set predefined EDIDs using --set-edid. That said, it needs
to be updated so it can set EDIDs suitable for 4k formats. I'll work on that.

Regards,

	Hans

Hans Verkuil (2):
  tc358840: add Toshiba HDMI-to-CSI bridge driver
  tc358840: add CEC support

 .../devicetree/bindings/media/i2c/tc358840.txt     |   50 +
 MAINTAINERS                                        |    7 +
 drivers/media/i2c/Kconfig                          |   10 +
 drivers/media/i2c/Makefile                         |    1 +
 drivers/media/i2c/tc358840.c                       | 2529 ++++++++++++++++++++
 drivers/media/i2c/tc358840_regs.h                  |  815 +++++++
 include/media/i2c/tc358840.h                       |   89 +
 7 files changed, 3501 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/i2c/tc358840.txt
 create mode 100644 drivers/media/i2c/tc358840.c
 create mode 100644 drivers/media/i2c/tc358840_regs.h
 create mode 100644 include/media/i2c/tc358840.h

-- 
2.7.0

