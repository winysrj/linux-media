Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud6.xs4all.net ([194.109.24.28]:36226 "EHLO
	lb2-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752364AbbBBMCq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 2 Feb 2015 07:02:46 -0500
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id A83E82A0080
	for <linux-media@vger.kernel.org>; Mon,  2 Feb 2015 13:02:07 +0100 (CET)
Message-ID: <54CF673F.1010804@xs4all.nl>
Date: Mon, 02 Feb 2015 13:02:07 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [GIT PULL FOR v3.20] adv7180 improvements
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following changes since commit a5f43c18fceb2b96ec9fddb4348f5282a71cf2b0:

  [media] Documentation/video4linux: remove obsolete text files (2015-01-29 19:16:30 -0200)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git for-v3.20d

for you to fetch changes up to f35d0d068fe717b7c6c84e376e47ccfec7f07051:

  Add MAINTAINERS entry for the adv7180 (2015-02-02 12:57:37 +0100)

----------------------------------------------------------------
Lars-Peter Clausen (15):
      adv7180: Do not request the IRQ again during resume
      adv7180: Pass correct flags to request_threaded_irq()
      adv7180: Use inline function instead of macro
      adv7180: Cleanup register define naming
      adv7180: Do implicit register paging
      adv7180: Reset the device before initialization
      adv7180: Add media controller support
      adv7180: Consolidate video mode setting
      adv7180: Prepare for multi-chip support
      adv7180: Add support for the adv7182
      adv7180: Add support for the adv7280/adv7281/adv7282
      adv7180: Add support for the adv7280-m/adv7281-m/adv7281-ma/adv7282-m
      adv7180: Add I2P support
      adv7180: Add fast switch support
      Add MAINTAINERS entry for the adv7180

 MAINTAINERS                        |    7 +
 drivers/media/i2c/Kconfig          |    2 +-
 drivers/media/i2c/adv7180.c        | 1016 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++------------------
 drivers/media/pci/sta2x11/Kconfig  |    1 +
 drivers/media/platform/Kconfig     |    2 +-
 include/uapi/linux/v4l2-controls.h |    4 +
 6 files changed, 831 insertions(+), 201 deletions(-)
