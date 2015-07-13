Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:47537 "EHLO
	lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751019AbbGMLiJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 13 Jul 2015 07:38:09 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id CBA522A066F
	for <linux-media@vger.kernel.org>; Mon, 13 Jul 2015 13:37:13 +0200 (CEST)
Message-ID: <55A3A2E9.3040606@xs4all.nl>
Date: Mon, 13 Jul 2015 13:37:13 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [GIT PULL FOR v4.3] Add Toshiba TC358743 HDMI to CSI-2 bridge
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add the new Toshiba TC358743 HDMI to CSI-2 bridge driver.

Regards,

	Hans

The following changes since commit 8783b9c50400c6279d7c3b716637b98e83d3c933:

  [media] SMI PCIe IR driver for DVBSky cards (2015-07-06 08:26:16 -0300)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git tc358743

for you to fetch changes up to e0a725a60fde6b634e1213d1a9fc061f94fcf678:

  Driver for Toshiba TC358743 HDMI to CSI-2 bridge (2015-07-13 13:17:50 +0200)

----------------------------------------------------------------
Mats Randgaard (1):
      Driver for Toshiba TC358743 HDMI to CSI-2 bridge

 MAINTAINERS                        |    7 +
 drivers/media/i2c/Kconfig          |    9 +
 drivers/media/i2c/Makefile         |    1 +
 drivers/media/i2c/tc358743.c       | 1778 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/media/i2c/tc358743_regs.h  |  681 ++++++++++++++++++++++++++++++++++
 include/media/tc358743.h           |  131 +++++++
 include/uapi/linux/v4l2-controls.h |    4 +
 7 files changed, 2611 insertions(+)
 create mode 100644 drivers/media/i2c/tc358743.c
 create mode 100644 drivers/media/i2c/tc358743_regs.h
 create mode 100644 include/media/tc358743.h
