Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:41982 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751091Ab1EOHrW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 15 May 2011 03:47:22 -0400
Received: from lancelot.localnet (249.170-65-87.adsl-dyn.isp.belgacom.be [87.65.170.249])
	by perceval.ideasonboard.com (Postfix) with ESMTPSA id BEC233599D
	for <linux-media@vger.kernel.org>; Sun, 15 May 2011 07:47:21 +0000 (UTC)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [GIT PATCH FOR 2.6.40] uvcvideo patches
Date: Sun, 15 May 2011 09:48:24 +0200
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201105150948.24956.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Mauro,

The following changes since commit f9b51477fe540fb4c65a05027fdd6f2ecce4db3b:

  [media] DVB: return meaningful error codes in dvb_frontend (2011-05-09 05:47:20 +0200)

are available in the git repository at:
  git://linuxtv.org/pinchartl/uvcvideo.git uvcvideo-next

They replace the git pull request I've sent on Thursday with the same subject.

Bob Liu (2):
      Revert "V4L/DVB: v4l2-dev: remove get_unmapped_area"
      uvcvideo: Add support for NOMMU arch

Hans de Goede (2):
      v4l: Add M420 format definition
      uvcvideo: Add M420 format support

Laurent Pinchart (4):
      v4l: Release module if subdev registration fails
      uvcvideo: Register a v4l2_device
      uvcvideo: Register subdevices for each entity
      uvcvideo: Connect video devices to media entities                                                                                                    
                                                                                                                                                           
 Documentation/DocBook/media-entities.tmpl |    1 +                                                                                                        
 Documentation/DocBook/v4l/pixfmt-m420.xml |  147 +++++++++++++++++++++++++++++                                                                            
 Documentation/DocBook/v4l/pixfmt.xml      |    1 +                                                                                                        
 Documentation/DocBook/v4l/videodev2.h.xml |    1 +                                                                                                        
 drivers/media/video/uvc/Makefile          |    3 +                                                                                                        
 drivers/media/video/uvc/uvc_driver.c      |   71 +++++++++++++--                                                                                          
 drivers/media/video/uvc/uvc_entity.c      |  118 +++++++++++++++++++++++                                                                                  
 drivers/media/video/uvc/uvc_queue.c       |   34 +++++++-                                                                                                 
 drivers/media/video/uvc/uvc_v4l2.c        |   17 ++++                                                                                                     
 drivers/media/video/uvc/uvcvideo.h        |   27 +++++                                                                                                    
 drivers/media/video/v4l2-dev.c            |   18 ++++                                                                                                     
 drivers/media/video/v4l2-device.c         |    5 +-                                                                                                       
 include/linux/videodev2.h                 |    1 +                                                                                                        
 include/media/v4l2-dev.h                  |    2 +                                                                                                        
 14 files changed, 437 insertions(+), 9 deletions(-)                                                                                                       
 create mode 100644 Documentation/DocBook/v4l/pixfmt-m420.xml                                                                                              
 create mode 100644 drivers/media/video/uvc/uvc_entity.c

-- 
Regards,

Laurent Pinchart
