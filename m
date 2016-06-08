Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:43857 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932401AbcFHX6c (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 8 Jun 2016 19:58:32 -0400
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org
Subject: [PATCH 0/5] R-Car VSP: Add CLU support
Date: Thu,  9 Jun 2016 02:58:11 +0300
Message-Id: <1465430296-22644-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

This patch series adds support for the Cubic Look Up table (CLU) to the vsp1
driver.

The first three patches are small unrelated fixes, I've included them here to
get them review and they will be added to the next pull request for the vsp1
driver. Patch 4/5 replaces the custom ioctl used to configure the 1D lookup
table (LUT) by an array control, to align it with the CLU API. This isn't an
issue as there's no user of this API with the mainline kernel.

Finally patch 5/5 adds support for the CLU, exposing the look-up table
contents through a control. The look-up table being quite large, I will likely
work on supporting partial control updates in the control framework at some
point. Feel free to beat me to it.

Laurent Pinchart (5):
  v4l: vsp1: pipe: Fix typo in comment
  v4l: vsp1: dl: Don't free fragments with interrupts disabled
  v4l: vsp1: lut: Initialize the mutex
  v4l: vsp1: lut: Expose configuration through a control
  v4l: vsp1: Add Cubic Look Up Table (CLU) support

 drivers/media/platform/vsp1/Makefile      |   2 +-
 drivers/media/platform/vsp1/vsp1.h        |   3 +
 drivers/media/platform/vsp1/vsp1_clu.c    | 276 ++++++++++++++++++++++++++++++
 drivers/media/platform/vsp1/vsp1_clu.h    |  44 +++++
 drivers/media/platform/vsp1/vsp1_dl.c     |  72 ++++++--
 drivers/media/platform/vsp1/vsp1_drv.c    |  25 ++-
 drivers/media/platform/vsp1/vsp1_entity.c |   1 +
 drivers/media/platform/vsp1/vsp1_entity.h |   1 +
 drivers/media/platform/vsp1/vsp1_lut.c    |  72 +++++---
 drivers/media/platform/vsp1/vsp1_lut.h    |   6 +-
 drivers/media/platform/vsp1/vsp1_pipe.h   |   2 +-
 drivers/media/platform/vsp1/vsp1_regs.h   |   9 +
 include/uapi/linux/vsp1.h                 |  34 ----
 13 files changed, 465 insertions(+), 82 deletions(-)
 create mode 100644 drivers/media/platform/vsp1/vsp1_clu.c
 create mode 100644 drivers/media/platform/vsp1/vsp1_clu.h
 delete mode 100644 include/uapi/linux/vsp1.h

-- 
Regards,

Laurent Pinchart

