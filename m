Return-path: <mchehab@gaivota>
Received: from devils.ext.ti.com ([198.47.26.153]:52312 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757149Ab0KSXYA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Nov 2010 18:24:00 -0500
From: Sergio Aguirre <saaguirre@ti.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org, Sergio Aguirre <saaguirre@ti.com>
Subject: [omap3isp RFC][PATCH 0/4] Improve inter subdev interaction
Date: Fri, 19 Nov 2010 17:23:47 -0600
Message-Id: <1290209031-12817-1-git-send-email-saaguirre@ti.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Hi,

These are some patches to make these operations more generic:
- Clock control is being controlled in a very crude manner by
  subdevices, it should be centralized in isp.c.
- LSC prefetch wait check is reading a main ISP register, so move
  it to isp.c
- Abstract SBL busy check: we don't want a submodule thinkering
  with main ISP registers. That should be done in the main isp.c

Also, remove main ISP register dump from CSI2 specific dump. We
should be using isp_print_status if we'll like to know main ISP
regdump.

Comments are welcome. More cleanups for better subdevice isolation
are on the way.

Regards,
Sergio

Sergio Aguirre (4):
  omap3isp: Abstract isp subdevs clock control
  omap3isp: Move CCDC LSC prefetch wait to main isp code
  omap3isp: sbl: Abstract SBL busy check
  omap3isp: csi2: Don't dump ISP main registers

 drivers/media/video/isp/isp.c        |   95 ++++++++++++++++++++++++++++++++++
 drivers/media/video/isp/isp.h        |   16 ++++++
 drivers/media/video/isp/ispccdc.c    |   42 ++-------------
 drivers/media/video/isp/ispcsi2.c    |    7 ---
 drivers/media/video/isp/isppreview.c |    6 +--
 drivers/media/video/isp/ispresizer.c |    6 +--
 6 files changed, 119 insertions(+), 53 deletions(-)

