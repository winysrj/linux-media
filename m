Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:56481 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755342AbcESXl7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 19 May 2016 19:41:59 -0400
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org
Subject: [PATCH 0/3] R-Car VSP miscellaneous fixes
Date: Fri, 20 May 2016 02:41:55 +0300
Message-Id: <1463701318-22081-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

This series fixes three unrelated issues in the R-Car VSP driver. Please see
individual patches for details.

Laurent Pinchart (3):
  v4l: vsp1: Fix typo in register field names
  v4l: vsp1: Fix descriptions of Gen2 VSP instances
  v4l: vsp1: Fix crash when resetting pipeline

 drivers/media/platform/vsp1/vsp1_drv.c  |  6 +++---
 drivers/media/platform/vsp1/vsp1_pipe.c | 14 +++++++++-----
 drivers/media/platform/vsp1/vsp1_regs.h |  8 ++++----
 3 files changed, 16 insertions(+), 12 deletions(-)

-- 
Regards,

Laurent Pinchart

