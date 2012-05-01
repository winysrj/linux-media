Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr2.xs4all.nl ([194.109.24.22]:1632 "EHLO
	smtp-vbr2.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751671Ab2EAJF6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 1 May 2012 05:05:58 -0400
Received: from alastor.dyndns.org (215.80-203-102.nextgentel.com [80.203.102.215] (may be forged))
	(authenticated bits=0)
	by smtp-vbr2.xs4all.nl (8.13.8/8.13.8) with ESMTP id q4195tL0092654
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-media@vger.kernel.org>; Tue, 1 May 2012 11:05:56 +0200 (CEST)
	(envelope-from hverkuil@xs4all.nl)
Received: from tschai.lan (tschai.lan [192.168.1.10])
	(Authenticated sender: hans)
	by alastor.dyndns.org (Postfix) with ESMTPSA id B7CD5FA80007
	for <linux-media@vger.kernel.org>; Tue,  1 May 2012 11:05:54 +0200 (CEST)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: [PATCH 0/7] Improved/New DV Timings API
Date: Tue,  1 May 2012 11:05:45 +0200
Message-Id: <1335863152-15791-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro!

This is the final version of the DV Timings API.

The RFCv3 version of this API can be found here:

http://comments.gmane.org/gmane.linux.drivers.video-input-infrastructure/47288

Changes since RFCv3 are:

- Extended the v4l2-dv-timings.h header with a few new DMT timings 
  corresponding with the latest DMT standard (Version 1.0, Revision 12).

- Mark the new ioctls as experimental (also added this note to the CREATE_BUFS
  and PREPARE_BUF ioctls as it was missing there).

- Add the revision notes.

- Add the CEA-861 and VESA DMT standards to the bibliography.

- Refer to the new v4l2-dv-timings.h header in the documentation (that was
  missing completely).

- Added a new patch that marks the DV Preset API as deprecated.

The git pull information is added below.

Regards,

	Hans


The following changes since commit bcb2cf6e0bf033d79821c89e5ccb328bfbd44907:

  [media] ngene: remove an unneeded condition (2012-04-26 15:29:23 -0300)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git timingsv4

for you to fetch changes up to bdf36b3c1ef4796e021ac8d46685c1bc741150bc:

  V4L2: Mark the DV Preset API as deprecated. (2012-05-01 10:54:48 +0200)

----------------------------------------------------------------
Hans Verkuil (7):
      videodev2.h: add enum/query/cap dv_timings ioctls.
      v4l2 framework: add support for the new dv_timings ioctls.
      v4l2-dv-timings.h: definitions for CEA-861 and VESA DMT timings.
      V4L2 spec: document the new V4L2 DV timings ioctls.
      tvp7002: add support for the new dv timings API.
      Feature removal: remove invalid DV presets.                                                                    
      V4L2: Mark the DV Preset API as deprecated.                                                                    

 Documentation/DocBook/media/v4l/biblio.xml                  |   18 ++                                               
 Documentation/DocBook/media/v4l/common.xml                  |   38 ++-                                              
 Documentation/DocBook/media/v4l/compat.xml                  |   17 ++                                               
 Documentation/DocBook/media/v4l/v4l2.xml                    |   15 +-                                               
 Documentation/DocBook/media/v4l/vidioc-create-bufs.xml      |    6 +                                                
 Documentation/DocBook/media/v4l/vidioc-dv-timings-cap.xml   |  211 +++++++++++++                                    
 Documentation/DocBook/media/v4l/vidioc-enum-dv-presets.xml  |    4 +                                                
 Documentation/DocBook/media/v4l/vidioc-enum-dv-timings.xml  |  119 ++++++++                                         
 Documentation/DocBook/media/v4l/vidioc-enuminput.xml        |    2 +-                                               
 Documentation/DocBook/media/v4l/vidioc-enumoutput.xml       |    2 +-                                               
 Documentation/DocBook/media/v4l/vidioc-g-dv-preset.xml      |    6 +                                                
 Documentation/DocBook/media/v4l/vidioc-g-dv-timings.xml     |  130 +++++++-                                         
 Documentation/DocBook/media/v4l/vidioc-prepare-buf.xml      |    6 +                                                
 Documentation/DocBook/media/v4l/vidioc-query-dv-preset.xml  |    4 +                                                
 Documentation/DocBook/media/v4l/vidioc-query-dv-timings.xml |  104 +++++++                                          
 Documentation/feature-removal-schedule.txt                  |    9 +                                                
 drivers/media/video/tvp7002.c                               |  102 ++++++-                                          
 drivers/media/video/v4l2-compat-ioctl32.c                   |    3 +                                                
 drivers/media/video/v4l2-ioctl.c                            |  126 +++++---                                         
 include/linux/Kbuild                                        |    1 +                                                
 include/linux/v4l2-dv-timings.h                             |  766 ++++++++++++++++++++++++++++++++++++++++++++++++ 
 include/linux/videodev2.h                                   |  179 +++++++++--                                      
 include/media/v4l2-ioctl.h                                  |    6 +                                                
 include/media/v4l2-subdev.h                                 |    6 +                                                
 24 files changed, 1775 insertions(+), 105 deletions(-)                                                              
 create mode 100644 Documentation/DocBook/media/v4l/vidioc-dv-timings-cap.xml                                        
 create mode 100644 Documentation/DocBook/media/v4l/vidioc-enum-dv-timings.xml
 create mode 100644 Documentation/DocBook/media/v4l/vidioc-query-dv-timings.xml
 create mode 100644 include/linux/v4l2-dv-timings.h

