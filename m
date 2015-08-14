Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud3.xs4all.net ([194.109.24.22]:36259 "EHLO
	lb1-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751399AbbHNLy1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 14 Aug 2015 07:54:27 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id 8E83D2A0091
	for <linux-media@vger.kernel.org>; Fri, 14 Aug 2015 13:53:54 +0200 (CEST)
Message-ID: <55CDD6D2.3070704@xs4all.nl>
Date: Fri, 14 Aug 2015 13:53:54 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [GIT PULL FOR v4.3] More fixes
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

These patches are the last set for 4.3 (except for this one
https://patchwork.linuxtv.org/patch/30895/ that I just posted).

Some have been posted before as part of the 'Various fixes' git pull request
that wasn't fully merged (the tw68 and rcar patches).

Regards,

	Hans

The following changes since commit 2696f495bdc046d84da6c909a1e7f535138a2a62:

  [media] Staging: media: lirc: use USB API functions rather than constants (2015-08-11 18:00:30 -0300)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git for-v4.3g

for you to fetch changes up to d124cac1097f8877fb34add564f5c609db19bf76:

  horus3a: fix compiler warning (2015-08-14 13:34:02 +0200)

----------------------------------------------------------------
Abhilash Jindal (2):
      zoran: Use monotonic time
      bt8xxx: Use monotonic time

Ezequiel Garcia (1):
      tw68: Move PCI vendor and device IDs to pci_ids.h

Hans Verkuil (1):
      horus3a: fix compiler warning

Mike Looijmans (1):
      i2c/adv7511: Fix license, set to GPL v2

Rob Taylor (2):
      media: rcar_vin: fill in bus_info field
      media: rcar_vin: Reject videobufs that are too small for current format

William Towle (1):
      media: soc_camera: rcar_vin: Add BT.709 24-bit RGB888 input support

 drivers/media/dvb-frontends/horus3a.c        |  1 +
 drivers/media/i2c/adv7511.c                  |  2 +-
 drivers/media/pci/bt8xx/bttv-input.c         | 21 ++++++++-------------
 drivers/media/pci/bt8xx/bttvp.h              |  2 +-
 drivers/media/pci/tw68/tw68-core.c           | 21 +++++++++++----------
 drivers/media/pci/tw68/tw68.h                | 16 ----------------
 drivers/media/pci/zoran/zoran_device.c       | 18 +++++-------------
 drivers/media/platform/soc_camera/rcar_vin.c | 16 ++++++++++++++--
 include/linux/pci_ids.h                      |  9 +++++++++
 9 files changed, 50 insertions(+), 56 deletions(-)
