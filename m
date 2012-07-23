Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:50305 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754136Ab2GWSe6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Jul 2012 14:34:58 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: sakari.ailus@iki.fi
Subject: [PATCH 0/4] Aptinate sensors patches
Date: Mon, 23 Jul 2012 20:34:58 +0200
Message-Id: <1343068502-7431-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi everybody,

Here are three fixes/patches for the MT9P031 and MT9V032 sensor drivers. The
second patch (mt9v032 pixel rate control) requires a control framework
modification (1/4) that has already been reviewed.

Sakari, I've rebased your patch on top of the latest media tree, could you
please review it ?

Laurent Pinchart (3):
  v4l2-ctrls: Add v4l2_ctrl_[gs]_ctrl_int64()
  mt9v032: Export horizontal and vertical blanking as V4L2 controls
  mt9p031: Fix horizontal and vertical blanking configuration

Sakari Ailus (1):
  mt9v032: Provide pixel rate control

 drivers/media/video/mt9p031.c    |   12 ++--
 drivers/media/video/mt9v032.c    |   59 +++++++++++++++-
 drivers/media/video/v4l2-ctrls.c |  135 +++++++++++++++++++++++---------------
 include/media/v4l2-ctrls.h       |   23 +++++++
 4 files changed, 166 insertions(+), 63 deletions(-)

-- 
Regards,

Laurent Pinchart

