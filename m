Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud3.xs4all.net ([194.109.24.22]:60831 "EHLO
	lb1-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753566AbcGDNe6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 4 Jul 2016 09:34:58 -0400
Received: from tschai.fritz.box (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id F1F931800C2
	for <linux-media@vger.kernel.org>; Mon,  4 Jul 2016 15:34:52 +0200 (CEST)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: [PATCH 0/7] adv quantization fixes, doc and zero reserved field
Date: Mon,  4 Jul 2016 15:34:45 +0200
Message-Id: <1467639292-1066-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

This patch series fixes a number of quantization range problems in the
adv drivers. These problems surfaced because of work done to support
different mediabus formats. In the past this was hardcoded via the
platform data, but today this is set by the bridge driver.

As a result the quantization range handling broke since the registers
weren't updated when the mediabus format changed.

The final two patches document the reserved field from v4l2_bt_timings
and zero that field.

This prepares for upcoming work were the timings struct is extended with
the CTA-861 VIC code, which is also needed by these drivers to correctly
setup the AVI InfoFrame.

Regards,

	Hans

Hans Verkuil (7):
  adv7511: drop adv7511_set_IT_content_AVI_InfoFrame
  adv7511: fix quantization range handling
  adv7604/adv7842: fix quantization range handling
  ezkit/cobalt: drop unused op_656_range setting
  adv7604/adv7842: drop unused op_656_range and alt_data_sat fields.
  DocBook media: document the v4l2_bt_timings reserved field
  v4l2-ioctl: zero the v4l2_bt_timings reserved field

 .../DocBook/media/v4l/vidioc-g-dv-timings.xml      |  7 ++++
 arch/blackfin/mach-bf609/boards/ezkit.c            |  2 --
 drivers/media/i2c/adv7511.c                        | 39 ++++++++--------------
 drivers/media/i2c/adv7604.c                        | 27 +++++++++------
 drivers/media/i2c/adv7842.c                        | 26 ++++++++++-----
 drivers/media/pci/cobalt/cobalt-driver.c           |  2 --
 drivers/media/v4l2-core/v4l2-ioctl.c               |  4 +--
 include/media/i2c/adv7604.h                        |  2 --
 include/media/i2c/adv7842.h                        |  2 --
 9 files changed, 56 insertions(+), 55 deletions(-)

-- 
2.8.1

