Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:36327 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751340AbbCIGjj (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 9 Mar 2015 02:39:39 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Josh Wu <josh.wu@atmel.com>
Subject: [PATCH 0/4] soc-camera: Make clock start and stop operations optional
Date: Mon,  9 Mar 2015 08:39:32 +0200
Message-Id: <1425883176-29859-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

This patch set makes the soc-camera host clock_start and clock_stop operations
optional and remove the empty stubs from the rcar-vin driver.

The rationale behind the change is that clock_start and clock_stop are
supposed to control a clock output supplied to the sensor, exposed through a
v4l2 clock. While some drivers abuse it to start/stop video streaming on the
host side and should be fixed, other drivers that behave correctly currently
have to implement stubs if the video hardware doesn't have a clock output.

The last patch in the series skips v4l2 clock registration completely if the
clock operations are not provided, as that v4l2 clock is a no-op. This could
introduce breakage and thus needs to be reviewed and tested carefully. I've
included the patch last to make it easy to skip it for now and only apply the
rest.

Laurent Pinchart (4):
  soc-camera: Unregister v4l2 clock in the OF bind error path
  soc-camera: Make clock_start and clock_stop operations optional
  rcar-vin: Don't implement empty optional clock operations
  soc-camera: Skip v4l2 clock registration if host doesn't provide clk
    ops

 drivers/media/platform/soc_camera/rcar_vin.c   |  15 ----
 drivers/media/platform/soc_camera/soc_camera.c | 113 +++++++++++++++----------
 2 files changed, 67 insertions(+), 61 deletions(-)

-- 
Regards,

Laurent Pinchart

