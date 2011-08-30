Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-2.cisco.com ([144.254.224.141]:28256 "EHLO
	ams-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752153Ab1H3J7C (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 30 Aug 2011 05:59:02 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: [GIT PATCHES FOR 3.2] Add VOLATILE flag and change autocluster handling of volatile controls
Date: Tue, 30 Aug 2011 11:58:59 +0200
Cc: hdegoede@redhat.com
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201108301158.59995.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Acked by Hans de Goede and based on extensive discussions on how to handle 
this. See:

http://comments.gmane.org/gmane.linux.drivers.video-input-infrastructure/35067
http://comments.gmane.org/gmane.linux.drivers.video-input-infrastructure/36650

So it's time to get this merged.

Regards,

	Hans

The following changes since commit 69d232ae8e95a229e7544989d6014e875deeb121:

  [media] omap3isp: ccdc: Use generic frame sync event instead of private 
HS_VS event (2011-08-29 12:38:51 -0300)

are available in the git repository at:
  ssh://linuxtv.org/git/hverkuil/media_tree.git autofoo

Hans Verkuil (8):
      videodev2.h: add V4L2_CTRL_FLAG_VOLATILE.
      v4l2-ctrls: replace is_volatile with V4L2_CTRL_FLAG_VOLATILE.
      v4l2-ctrls: implement new volatile autocluster scheme.
      v4l2-controls.txt: update auto cluster documentation.
      pwc: switch to the new auto-cluster volatile handling.
      vivi: add support for VIDIOC_LOG_STATUS.
      pwc: add support for VIDIOC_LOG_STATUS.
      saa7115: use the new auto cluster support.

 Documentation/DocBook/media/v4l/compat.xml         |    8 +
 Documentation/DocBook/media/v4l/v4l2.xml           |    9 +-
 .../DocBook/media/v4l/vidioc-queryctrl.xml         |    9 ++
 Documentation/video4linux/v4l2-controls.txt        |   43 +++----
 drivers/media/radio/radio-wl1273.c                 |    2 +-
 drivers/media/radio/wl128x/fmdrv_v4l2.c            |    2 +-
 drivers/media/video/adp1653.c                      |    2 +-
 drivers/media/video/pwc/pwc-v4l.c                  |  136 
+++++++++-----------
 drivers/media/video/s5p-mfc/s5p_mfc_dec.c          |    4 +-
 drivers/media/video/s5p-mfc/s5p_mfc_enc.c          |    2 +-
 drivers/media/video/saa7115.c                      |    5 +-
 drivers/media/video/v4l2-ctrls.c                   |  104 ++++++++++++----
 drivers/media/video/vivi.c                         |    9 ++
 include/linux/videodev2.h                          |    1 +
 include/media/v4l2-ctrls.h                         |   15 +--
 15 files changed, 204 insertions(+), 147 deletions(-)
