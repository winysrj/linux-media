Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:35714 "EHLO
	lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965108AbaKNKVj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 14 Nov 2014 05:21:39 -0500
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id 48DF72A0091
	for <linux-media@vger.kernel.org>; Fri, 14 Nov 2014 11:21:27 +0100 (CET)
Message-ID: <5465D7A7.3060701@xs4all.nl>
Date: Fri, 14 Nov 2014 11:21:27 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [GIT PULL FOR v3.19] si4713 improvements and vb2_start_streaming_called()
 helper
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

This is the full si4713 patch series (with some small changes to fix compiler
warnings), and two patches to use the vb2_start_streaming_called() helper
where appropriate.

Regards,

	Hans

The following changes since commit dd0a6fe2bc3055cd61e369f97982c88183b1f0a0:

  [media] dvb-usb-dvbsky: fix i2c adapter for sp2 device (2014-11-11 12:55:32 -0200)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git for-v3.19g

for you to fetch changes up to 6058ab17af213b8b3f226c4ed620af5de42030fe:

  media: cx88: use vb2_start_streaming_called() helper (2014-11-14 11:17:21 +0100)

----------------------------------------------------------------
Prabhakar Lad (2):
      media: vivid: use vb2_start_streaming_called() helper
      media: cx88: use vb2_start_streaming_called() helper

Sebastian Reichel (8):
      si4713: switch to devm regulator API
      si4713: switch reset gpio to devm_gpiod API
      si4713: use managed memory allocation
      si4713: use managed irq request
      si4713: add device tree support
      si4713: add DT binding documentation
      ARM: OMAP2: RX-51: update si4713 platform data
      si4713: cleanup platform data

 Documentation/devicetree/bindings/media/si4713.txt |  30 ++++++++++++++
 arch/arm/mach-omap2/board-rx51-peripherals.c       |  69 ++++++++++++++-----------------
 drivers/media/pci/cx88/cx88-blackbird.c            |   2 +-
 drivers/media/platform/vivid/vivid-ctrls.c         |  10 ++---
 drivers/media/radio/si4713/radio-platform-si4713.c |  28 +++----------
 drivers/media/radio/si4713/si4713.c                | 164 +++++++++++++++++++++++++++++++++++++++++++++++--------------------------
 drivers/media/radio/si4713/si4713.h                |  15 ++++---
 include/media/radio-si4713.h                       |  30 --------------
 include/media/si4713.h                             |   4 +-
 9 files changed, 189 insertions(+), 163 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/media/si4713.txt
 delete mode 100644 include/media/radio-si4713.h
