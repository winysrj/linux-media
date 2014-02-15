Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:44775 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752474AbaBOBSz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 14 Feb 2014 20:18:55 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Peter Meerwald <pmeerw@pmeerw.net>, sakari.ailus@iki.fi
Subject: [PATCH 0/2] OMAP3 ISP pipeline validation patches
Date: Sat, 15 Feb 2014 02:19:53 +0100
Message-Id: <1392427195-2017-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

Those two patches fix the OMAP3 ISP pipeline validation when locating the
external subdevice.

The code currently works by chance with memory-to-memory pipelines, as it
tries to locate the external subdevice when none is available, but ignores the
failure due to a bug. This patch set fixes both issues.

Peter, could you check whether this fixes the warning you've reported ?

Laurent Pinchart (2):
  omap3isp: Don't try to locate external subdev for mem-to-mem pipelines
  omap3isp: Don't ignore failure to locate external subdev

 drivers/media/platform/omap3isp/ispvideo.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

-- 
Regards,

Laurent Pinchart

