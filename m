Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:59707 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751146AbbHAJWT (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 1 Aug 2015 05:22:19 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Josh Wu <josh.wu@atmel.com>
Subject: [PATCH 0/4] atmel-isi: Remove platform data support
Date: Sat,  1 Aug 2015 12:22:52 +0300
Message-Id: <1438420976-7899-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

While reviewing patches for the atmel-isi I noticed a couple of small issues
with the driver. Here's a patch series to fix them, the main change being the
removal of platform data support now that all users have migrated to DT.

The patches have been compile-tested only. Josh, would you be able to test
them on hardware ?

Laurent Pinchart (4):
  v4l: atmel-isi: Simplify error handling during DT parsing
  v4l: atmel-isi: Remove unused variable
  v4l: atmel-isi: Remove support for platform data
  v4l: atmel-isi: Remove unused platform data fields

 drivers/media/platform/soc_camera/atmel-isi.c |  40 ++------
 drivers/media/platform/soc_camera/atmel-isi.h | 126 +++++++++++++++++++++++++
 include/media/atmel-isi.h                     | 131 --------------------------
 3 files changed, 136 insertions(+), 161 deletions(-)
 create mode 100644 drivers/media/platform/soc_camera/atmel-isi.h
 delete mode 100644 include/media/atmel-isi.h

-- 
Regards,

Laurent Pinchart

