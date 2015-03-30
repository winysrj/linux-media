Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:60948 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752745AbbC3LLK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 30 Mar 2015 07:11:10 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Mats Randgaard <matrandg@cisco.com>
Cc: Hans Verkuil <hansverk@cisco.com>, linux-media@vger.kernel.org,
	kernel@pengutronix.de, Philipp Zabel <p.zabel@pengutronix.de>
Subject: [RFC 00/12] TC358743 async subdev and dt support
Date: Mon, 30 Mar 2015 13:10:44 +0200
Message-Id: <1427713856-10240-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mats,

did you have time to work on the TC358743 driver some more in the meanwhile?
These are the changes I have made locally to v1 to get it to work on i.MX6.

regards
Philipp

Mats Randgaard (1):
  [media] Driver for Toshiba TC358743 CSI-2 to HDMI bridge

Philipp Zabel (11):
  [media] tc358743: register v4l2 asynchronous subdevice
  [media] tc358743: support probe from device tree
  [media] tc358743: fix set_pll to enable PLL with default frequency
  [media] tc358743: fix lane number calculation to include blanking
  [media] tc358743: split set_csi into set_csi and start_csi
  [media] tc358743: also set TCLK_TRAILCNT and TCLK_POSTCNT
  [media] tc358743: parse MIPI CSI-2 endpoint, support noncontinuous
    clock
  [media] tc358743: add direct interrupt handling
  [media] tc358743: detect chip by ChipID instead of IntMask
  [media] tc358743: don't return E2BIG from G_EDID
  [media] tc358743: allow event subscription

 MAINTAINERS                        |    6 +
 drivers/media/i2c/Kconfig          |   12 +
 drivers/media/i2c/Makefile         |    1 +
 drivers/media/i2c/tc358743.c       | 1979 ++++++++++++++++++++++++++++++++++++
 drivers/media/i2c/tc358743_regs.h  |  670 ++++++++++++
 include/media/tc358743.h           |   89 ++
 include/uapi/linux/v4l2-controls.h |    4 +
 7 files changed, 2761 insertions(+)
 create mode 100644 drivers/media/i2c/tc358743.c
 create mode 100644 drivers/media/i2c/tc358743_regs.h
 create mode 100644 include/media/tc358743.h

-- 
2.1.4

