Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:59417 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751817AbbL2ObO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 29 Dec 2015 09:31:14 -0500
Received: from avalon.localnet (85-23-193-79.bb.dnainternet.fi [85.23.193.79])
	by galahad.ideasonboard.com (Postfix) with ESMTPSA id 098B720114
	for <linux-media@vger.kernel.org>; Tue, 29 Dec 2015 15:30:49 +0100 (CET)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [GIT PULL FOR v4.5] omap3isp fixes
Date: Tue, 29 Dec 2015 16:31:14 +0200
Message-ID: <1720972.142MhTlgVQ@avalon>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

The following changes since commit 768acf46e1320d6c41ed1b7c4952bab41c1cde79:

  [media] rc: sunxi-cir: Initialize the spinlock properly (2015-12-23 15:51:40 -0200)

are available in the git repository at:

  git://linuxtv.org/pinchartl/media.git omap3isp/next

for you to fetch changes up to d86cdf3233d06fa037672f09c23ab38f8715c902:

  v4l: omap3isp: Fix data lane shift configuration (2015-12-29 16:28:32 +0200)

----------------------------------------------------------------
Andrzej Hajda (1):
      v4l: omap3isp: Fix handling platform_get_irq result

Javier Martinez Canillas (1):
      v4l: omap3isp: Fix module autoloading

Lad, Prabhakar (1):
      v4l: omap3isp: use vb2_buffer_state enum for vb2 buffer state

Laurent Pinchart (1):
      v4l: omap3isp: Fix data lane shift configuration

Sakari Ailus (3):
      v4l: omap3isp: Move starting the sensor from streamon IOCTL handler to VB2 QOP
      v4l: omap3isp: Return buffers back to videobuf2 if pipeline streamon fails
      v4l: omap3isp: preview: Mark output buffer done first

 drivers/media/platform/omap3isp/isp.c        |   8 ++-
 drivers/media/platform/omap3isp/ispccdc.c    |   2 +-
 drivers/media/platform/omap3isp/isppreview.c |  14 ++---
 drivers/media/platform/omap3isp/ispvideo.c   | 103 +++++++++++++++++++++++------------
 drivers/media/platform/omap3isp/omap3isp.h   |   8 +--
 5 files changed, 84 insertions(+), 51 deletions(-)

-- 
Regards,

Laurent Pinchart

