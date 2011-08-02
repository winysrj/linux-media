Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-68.nebula.fi ([83.145.220.68]:39344 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753430Ab1HBO5E (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 2 Aug 2011 10:57:04 -0400
Date: Tue, 2 Aug 2011 17:56:59 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: mchehab@redhat.com
Subject: [GIT PULL FOR v3.2] adp1653 and event documentation fixes and
 frame sync event
Message-ID: <20110802145659.GQ32629@valkosipuli.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,


This pull request contains fixes to adp1653 driver and event documentation
besides the new frame sync event definition and support for it to the OMAP 3
ISP driver.


The following changes since commit 449d1a0ad1732476d394fb2b885092a5c554f983:

  [media] anysee: use multi-frontend (MFE) (2011-07-31 01:42:40 -0300)

are available in the git repository at:
  ssh://linuxtv.org/git/sailus/media_tree.git media-for-3.2-misc-2

Andy Shevchenko (2):
      adp1653: check platform_data before usage
      adp1653: check error code of adp1653_init_controls

Sakari Ailus (3):
      v4l: Move event documentation from SUBSCRIBE_EVENT to DQEVENT
      v4l: events: Define V4L2_EVENT_FRAME_SYNC
      omap3isp: ccdc: Use generic frame sync event instead of private HS_VS event

 Documentation/DocBook/media/v4l/vidioc-dqevent.xml |  129 ++++++++++++++++++++
 .../DocBook/media/v4l/vidioc-subscribe-event.xml   |  123 +++----------------
 Documentation/video4linux/omap3isp.txt             |    9 +-
 drivers/media/video/adp1653.c                      |   15 ++-
 drivers/media/video/omap3isp/ispccdc.c             |   11 ++-
 include/linux/omap3isp.h                           |    2 -
 include/linux/videodev2.h                          |   12 ++-
 7 files changed, 181 insertions(+), 120 deletions(-)

-- 
Sakari Ailus
sakari.ailus@iki.fi
