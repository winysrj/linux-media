Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud6.xs4all.net ([194.109.24.24]:41162 "EHLO
	lb1-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751004AbbFGKcu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 7 Jun 2015 06:32:50 -0400
Received: from tschai.fritz.box (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id 08DEF2A00C8
	for <linux-media@vger.kernel.org>; Sun,  7 Jun 2015 12:32:36 +0200 (CEST)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: [PATCH 0/6] adv7511/adv7604: logging improvements
Date: Sun,  7 Jun 2015 12:32:29 +0200
Message-Id: <1433673155-20179-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The first two patches fix type inconsistencies, but make no other changes.
The next two add support for logging InfoFrames to both drivers.
The last two patches fix a logging bug and log two more pieces of information
regarding the colorspace handling of the adv76xx.

Regards,

	Hans

Hans Verkuil (6):
  adv7511: replace uintX_t by uX for consistency
  adv7842: replace uintX_t by uX for consistency
  adv7511: log the currently set infoframes
  adv7604: log infoframes
  adv7604: fix broken saturator check
  adv7604: log alt-gamma and HDMI colorspace

 drivers/media/i2c/Kconfig                |   2 +
 drivers/media/i2c/adv7511.c              | 155 +++++++++++++++++++++++++++----
 drivers/media/i2c/adv7604.c              | 103 +++++++++++++-------
 drivers/media/i2c/adv7842.c              |  22 ++---
 drivers/media/pci/cobalt/cobalt-driver.c |   1 +
 include/media/adv7511.h                  |   7 +-
 include/media/adv7842.h                  |  50 +++++-----
 7 files changed, 251 insertions(+), 89 deletions(-)

-- 
2.1.4

