Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:43854 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751274Ab2AYPM3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 25 Jan 2012 10:12:29 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-media@vger.kernel.org
Subject: [PATCH 0/8] soc-camera: Add support for configurable line stride
Date: Wed, 25 Jan 2012 16:12:23 +0100
Message-Id: <1327504351-24413-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

This patch set adds support for configurable line stride to the soc-camera
framework and the sh_mobile_ceu_camera driver. I've successfully tested it on
a Mackerel board with the on-board VGA sensor.

Laurent Pinchart (8):
  soc_camera: Use soc_camera_device::sizeimage to compute buffer sizes
  soc_camera: Use soc_camera_device::bytesperline to compute line sizes
  soc-camera: Add plane layout information to struct soc_mbus_pixelfmt
  soc-camera: Fix bytes per line computation for planar formats
  soc-camera: Add soc_mbus_image_size
  soc-camera: Honor user-requested bytesperline and sizeimage
  soc-camera: Support user-configurable line stride
  sh_mobile_ceu_camera: Support user-configurable line stride

 drivers/media/video/atmel-isi.c            |   18 ++------
 drivers/media/video/mx1_camera.c           |   14 +-----
 drivers/media/video/mx2_camera.c           |   16 ++-----
 drivers/media/video/mx3_camera.c           |   41 +++++++++-------
 drivers/media/video/omap1_camera.c         |   22 ++++-----
 drivers/media/video/pxa_camera.c           |   15 +-----
 drivers/media/video/sh_mobile_ceu_camera.c |   68 ++++++++++++++++-----------
 drivers/media/video/soc_camera.c           |   35 ++++++++-------
 drivers/media/video/soc_mediabus.c         |   54 ++++++++++++++++++++++
 include/media/soc_camera.h                 |    4 ++
 include/media/soc_mediabus.h               |   21 +++++++++
 11 files changed, 184 insertions(+), 124 deletions(-)

-- 
Regards,

Laurent Pinchart

