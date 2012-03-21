Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:57766 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752347Ab2CULDH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 21 Mar 2012 07:03:07 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-media@vger.kernel.org
Subject: [PATCH v2 0/9] soc-camera: Add support for configurable line stride
Date: Wed, 21 Mar 2012 12:03:19 +0100
Message-Id: <1332327808-6056-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

Here's the second version of the soc-camera configurable line stride support
patches.

The patches have been successfully tested on a Mackerel board with the on-board
VGA sensor.

Laurent Pinchart (9):
  mx2_camera: Fix sizeimage computation in try_fmt()
  soc_camera: Use soc_camera_device::sizeimage to compute buffer sizes
  soc_camera: Use soc_camera_device::bytesperline to compute line sizes
  soc-camera: Add plane layout information to struct soc_mbus_pixelfmt
  soc-camera: Fix bytes per line computation for planar formats
  soc-camera: Add soc_mbus_image_size
  soc-camera: Honor user-requested bytesperline and sizeimage
  mx2_camera: Use soc_mbus_image_size() instead of manual computation
  soc-camera: Support user-configurable line stride

 drivers/media/video/atmel-isi.c            |   18 ++-------
 drivers/media/video/mx1_camera.c           |   14 +------
 drivers/media/video/mx2_camera.c           |   21 ++++-------
 drivers/media/video/mx3_camera.c           |   41 ++++++++++++---------
 drivers/media/video/omap1_camera.c         |   22 +++++------
 drivers/media/video/pxa_camera.c           |   15 ++------
 drivers/media/video/sh_mobile_ceu_camera.c |   45 ++++++++++++-----------
 drivers/media/video/soc_camera.c           |   35 ++++++++++--------
 drivers/media/video/soc_mediabus.c         |   54 ++++++++++++++++++++++++++++
 include/media/soc_camera.h                 |    4 ++
 include/media/soc_mediabus.h               |   21 +++++++++++
 11 files changed, 172 insertions(+), 118 deletions(-)

-- 
Regards,

Laurent Pinchart

