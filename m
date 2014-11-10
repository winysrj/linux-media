Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:41240 "EHLO
	lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752553AbaKJLE4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Nov 2014 06:04:56 -0500
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id F0EF22A0377
	for <linux-media@vger.kernel.org>; Mon, 10 Nov 2014 12:04:50 +0100 (CET)
Message-ID: <54609BD2.8070200@xs4all.nl>
Date: Mon, 10 Nov 2014 12:04:50 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [GIT PULL FOR v3.19] Various fixes
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Sparse fixes for saa7164, adv EDID fixes and si4713 improvements in preparation
for adding DT support. Tested the si4713 with my USB dev board.

Regards,

	Hans

The following changes since commit 4895cc47a072dcb32d3300d0a46a251a8c6db5f1:

  [media] s5p-mfc: fix sparse error (2014-11-05 08:29:27 -0200)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git for-v3.19f

for you to fetch changes up to 017f179ebd74ec3bd3f2484c3cc0fe48c306a36e:

  si4713: use managed irq request (2014-11-10 12:03:30 +0100)

----------------------------------------------------------------
Hans Verkuil (4):
      adv7842: fix G/S_EDID behavior
      adv7511: fix G/S_EDID behavior
      adv7604: Correct G/S_EDID behaviour
      saa7164: fix sparse warnings

Sebastian Reichel (4):
      si4713: switch to devm regulator API
      si4713: switch reset gpio to devm_gpiod API
      si4713: use managed memory allocation
      si4713: use managed irq request

 drivers/media/i2c/adv7511.c                |  21 ++++++++-----
 drivers/media/i2c/adv7604.c                |  37 +++++++++++------------
 drivers/media/i2c/adv7842.c                |  34 ++++++++++++---------
 drivers/media/pci/saa7164/saa7164-buffer.c |   4 +--
 drivers/media/pci/saa7164/saa7164-bus.c    | 101 +++++++++++++++++++++++++++++++++++--------------------------
 drivers/media/pci/saa7164/saa7164-core.c   |  13 ++++----
 drivers/media/pci/saa7164/saa7164-fw.c     |   6 ++--
 drivers/media/pci/saa7164/saa7164-types.h  |   4 +--
 drivers/media/pci/saa7164/saa7164.h        |   4 +--
 drivers/media/radio/si4713/si4713.c        | 133 ++++++++++++++++++++++++++++++++++++++++++++++-----------------------------------
 drivers/media/radio/si4713/si4713.h        |   9 +++---
 11 files changed, 206 insertions(+), 160 deletions(-)
