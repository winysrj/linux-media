Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud6.xs4all.net ([194.109.24.24]:44623 "EHLO
	lb1-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756112AbbFVHVP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Jun 2015 03:21:15 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id 2071D2A0095
	for <linux-media@vger.kernel.org>; Mon, 22 Jun 2015 09:20:49 +0200 (CEST)
Message-ID: <5587B751.7080104@xs4all.nl>
Date: Mon, 22 Jun 2015 09:20:49 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [GIT PULL FOR v4.3] sh-vou and various i2c subdev fixes
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This pull request contains a pile of fixes for sh-vou (including a conversion to
vb2) and various i2c subdev improvements and a small docbook fix.

Regards,

	Hans


The following changes since commit 6f32a8c97f11eb074027052b6b507891e5c9d8b1:

  [media] MAINTAINERS: Add entry for the Renesas VSP1 driver (2015-06-18 18:00:44 -0300)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git for-v4.3a

for you to fetch changes up to 5c973d986fcf43f4abed6fcfe48d67fc99da85e8:

  media: adv7604: ability to read default input port from DT (2015-06-22 09:12:21 +0200)

----------------------------------------------------------------
Ben Dooks (1):
      media: adv7180: add of match table

Hans Verkuil (12):
      clock-sh7724.c: fix sh-vou clock identifier
      sh-vou: use resource managed calls
      sh-vou: fix querycap support
      sh-vou: use v4l2_fh
      sh-vou: support compulsory G/S/ENUM_OUTPUT ioctls
      sh-vou: fix incorrect initial pixelformat.
      sh-vou: replace g/s_crop/cropcap by g/s_selection
      sh-vou: let sh_vou_s_fmt_vid_out call sh_vou_try_fmt_vid_out
      sh-vou: fix bytesperline
      sh-vou: convert to vb2
      sh-vou: add support for log_status
      DocBook/media: fix bad spacing in VIDIOC_EXPBUF

Ian Molton (2):
      media: adv7604: document support for ADV7612 dual HDMI input decoder
      media: adv7604: ability to read default input port from DT

Pablo Anton (1):
      media: i2c: ADV7604: Migrate to regmap

Ricardo Ribalda Delgado (1):
      media/i2c/sr030pc30: Remove compat control ops

William Towle (1):
      media: adv7604: chip info and formats for ADV7612

 Documentation/DocBook/media/v4l/vidioc-expbuf.xml       |  38 ++--
 Documentation/devicetree/bindings/media/i2c/adv7604.txt |  21 +-
 arch/sh/kernel/cpu/sh4a/clock-sh7724.c                  |   2 +-
 drivers/media/i2c/adv7180.c                             |  11 +
 drivers/media/i2c/adv7604.c                             | 446 ++++++++++++++++++++++++++++---------
 drivers/media/i2c/sr030pc30.c                           |   7 -
 drivers/media/platform/sh_vou.c                         | 817 +++++++++++++++++++++++++++++++-------------------------------------
 7 files changed, 763 insertions(+), 579 deletions(-)
--
To unsubscribe from this list: send the line "unsubscribe linux-media" in
