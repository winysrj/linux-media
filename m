Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:39287 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754571AbaDWTWy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 23 Apr 2014 15:22:54 -0400
Received: from valkosipuli.retiisi.org.uk (valkosipuli.retiisi.org.uk [IPv6:2001:1bc8:102:7fc9::80:2])
	by hillosipuli.retiisi.org.uk (Postfix) with ESMTP id 3F7CB60096
	for <linux-media@vger.kernel.org>; Wed, 23 Apr 2014 22:22:51 +0300 (EEST)
Date: Wed, 23 Apr 2014 22:22:49 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Subject: [GIT PULL for v3.16] Sub-device and Media device owner change, small
 fixes
Message-ID: <20140423192249.GL8753@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

This pull request contains ownership and module use count changes for the
media device and V4L2 sub-devices, a missing check for the user space
arguments in [gs]_frame_interval and a few comment improvements.

Please pull.

The following changes since commit 701b57ee3387b8e3749845b02310b5625fbd8da0:

  [media] vb2: Add videobuf2-dvb support (2014-04-16 18:59:29 -0300)

are available in the git repository at:

  ssh://linuxtv.org/git/sailus/media_tree.git upstream

for you to fetch changes up to 6544c39041d2e88c895110796c7db4cdb1f5d8e2:

  v4l: Remove documentation for nonexistend input field in v4l2_buffer (2014-04-23 22:14:34 +0300)

----------------------------------------------------------------
Sakari Ailus (5):
      v4l: Check pad arguments for [gs]_frame_interval
      media: Use a better owner for the media device
      v4l: Only get module if it's different than the driver for v4l2_dev
      v4l: V4L2_MBUS_FRAME_DESC_FL_BLOB is about 1D DMA
      v4l: Remove documentation for nonexistend input field in v4l2_buffer

 drivers/media/media-device.c          |    7 ++++---
 drivers/media/media-devnode.c         |    5 +++--
 drivers/media/v4l2-core/v4l2-device.c |   18 +++++++++++++++---
 drivers/media/v4l2-core/v4l2-subdev.c |   16 ++++++++++++++--
 include/media/media-device.h          |    4 +++-
 include/media/media-devnode.h         |    3 ++-
 include/media/v4l2-subdev.h           |   10 +++++++---
 include/uapi/linux/videodev2.h        |    1 -
 8 files changed, 48 insertions(+), 16 deletions(-)

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
