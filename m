Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:52918 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750711Ab1IUW5j (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 21 Sep 2011 18:57:39 -0400
Received: from lancelot.localnet (unknown [91.178.144.162])
	by perceval.ideasonboard.com (Postfix) with ESMTPSA id A67C4359BB
	for <linux-media@vger.kernel.org>; Wed, 21 Sep 2011 22:57:38 +0000 (UTC)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [GIT PULL FOR v3.2] uvcvideo patches
Date: Thu, 22 Sep 2011 00:57:35 +0200
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201109220057.36223.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

The following changes since commit e27412f5a5966629e3d4213c78a539068ca0ea26:

  [media] mmp_camera: add MODULE_ALIAS (2011-09-18 08:05:43 -0300)

are available in the git repository at:
  git://linuxtv.org/pinchartl/uvcvideo.git uvcvideo-next

Al Cooper (1):
      media: Fix a UVC performance problem on systems with non-coherent DMA.

Arne Caspari (1):
      uvcvideo: Detect The Imaging Source CCD cameras by vendor and product ID

Laurent Pinchart (2):
      uvcvideo: Remove deprecated UVCIOC ioctls
      USB: export video.h to the includes available for userspace

Stephan Lachowsky (1):
      uvcvideo: Add a mapping for H.264 payloads
                                                                                                                                                           
 Documentation/feature-removal-schedule.txt |   23 ------                                                                                                  
 drivers/media/video/uvc/uvc_driver.c       |   13 ++++                                                                                                    
 drivers/media/video/uvc/uvc_v4l2.c         |   54 +--------------                                                                                         
 drivers/media/video/uvc/uvc_video.c        |   17 ++++-                                                                                                   
 drivers/media/video/uvc/uvcvideo.h         |  104 ++-------------------------                                                                             
 include/linux/usb/Kbuild                   |    1 +
 6 files changed, 40 insertions(+), 172 deletions(-)

-- 
Regards,

Laurent Pinchart
