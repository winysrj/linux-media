Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:33286 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751345AbaK1Xx3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 28 Nov 2014 18:53:29 -0500
Received: from valkosipuli.retiisi.org.uk (valkosipuli.retiisi.org.uk [IPv6:2001:1bc8:102:7fc9::80:2])
	by hillosipuli.retiisi.org.uk (Postfix) with ESMTP id 2C9BA60093
	for <linux-media@vger.kernel.org>; Sat, 29 Nov 2014 01:53:25 +0200 (EET)
Date: Sat, 29 Nov 2014 01:53:24 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Subject: [GIT PULL FOR v3.19] Add V4L2_SEL_TGT_NATIVE_SIZE target
Message-ID: <20141128235324.GQ8907@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

This pull request adds support for the V4L2_SEL_TGT_NATIVE_SIZE selection
target to access the device's native size. Among is also a patch to clean up
sub-device interface documentation and capability flags to tell whether
setting the native size is possible.

Please pull.


The following changes since commit 504febc3f98c87a8bebd8f2f274f32c0724131e4:

  Revert "[media] lmed04: add missing breaks" (2014-11-25 22:16:25 -0200)

are available in the git repository at:

  ssh://linuxtv.org/git/sailus/media_tree.git native-size

for you to fetch changes up to da7cf8011adc281a878dde254f5642745648decd:

  smiapp: Support V4L2_SEL_TGT_NATIVE_SIZE (2014-11-29 01:48:54 +0200)

----------------------------------------------------------------
Sakari Ailus (5):
      v4l: Clean up sub-device format documentation
      v4l: Add V4L2_SEL_TGT_NATIVE_SIZE selection target
      v4l: Add input and output capability flags for native size setting
      smiapp: Set left and top to zero for crop bounds selection
      smiapp: Support V4L2_SEL_TGT_NATIVE_SIZE

 Documentation/DocBook/media/v4l/dev-subdev.xml     |  109 +++++++++++---------
 .../DocBook/media/v4l/selections-common.xml        |   16 +++
 .../DocBook/media/v4l/vidioc-enuminput.xml         |    8 ++
 .../DocBook/media/v4l/vidioc-enumoutput.xml        |    8 ++
 drivers/media/i2c/smiapp/smiapp-core.c             |    7 ++
 include/uapi/linux/v4l2-common.h                   |    2 +
 include/uapi/linux/videodev2.h                     |    2 +
 7 files changed, 106 insertions(+), 46 deletions(-)

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
