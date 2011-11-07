Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:1465 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751734Ab1KGJmi (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 7 Nov 2011 04:42:38 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [GIT PULL FOR v3.2] Menu changes
Date: Mon, 7 Nov 2011 10:42:30 +0100
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201111071042.30157.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

This is the patch series that reorganizes the V4L menu.

The only thing I didn't touch is the SoC camera support submenu.

Guennadi, what is the status for the SoC camera sensor drivers? I see that
they still have a menu dependency to SOC_CAMERA. Is that still valid?

Regards,

	Hans

The following changes since commit 31cea59efb3a4210c063f31c061ebcaff833f583:

  [media] saa7134.h: Suppress compiler warnings when CONFIG_VIDEO_SAA7134_RC is not set (2011-11-03 16:58:20 -0200)

are available in the git repository at:
  git://linuxtv.org/hverkuil/media_tree.git menu

Hans Verkuil (8):
      V4L menu: move USB drivers section to the top.
      V4L menu: move ISA and parport drivers into their own submenu.
      V4L menu: remove the EXPERIMENTAL tag from vino and c-qcam.
      V4L menu: move all platform drivers to the bottom of the menu.
      V4L menu: remove duplicate USB dependency.
      V4L menu: reorganize the radio menu.
      V4L menu: move all PCI(e) devices to their own submenu.
      cx88: fix menu level for the VP-3054 module.

 drivers/media/radio/Kconfig      |  298 +++++++++++++++--------------
 drivers/media/video/Kconfig      |  394 +++++++++++++++++++++-----------------
 drivers/media/video/cx88/Kconfig |   10 +-
 3 files changed, 377 insertions(+), 325 deletions(-)
