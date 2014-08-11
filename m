Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:41774 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752328AbaHKNGJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Aug 2014 09:06:09 -0400
Received: from valkosipuli.retiisi.org.uk (valkosipuli.retiisi.org.uk [IPv6:2001:1bc8:102:7fc9::80:2])
	by hillosipuli.retiisi.org.uk (Postfix) with ESMTP id 2457260095
	for <linux-media@vger.kernel.org>; Mon, 11 Aug 2014 16:06:07 +0300 (EEST)
Date: Mon, 11 Aug 2014 16:05:34 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Subject: [GIT PULL FOR 3.18] Test pattern controls
Message-ID: <20140811130534.GH16460@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

This set adds V4L2 test pattern controls and support for those in the smiapp
driver. This pull request is on top of the unlocked controls patches, the
pull request of which can be found here:

<URL:http://www.spinics.net/lists/linux-media/msg79196.html>

Please pull.


The following changes since commit c2685f81e4d37ab93523a20246b95a63e47d7fcc:

  smiapp: Set 64-bit integer control using v4l2_ctrl_s_ctrl_int64() (2014-08-01 12:27:42 +0300)

are available in the git repository at:

  ssh://linuxtv.org/git/sailus/media_tree.git smiapp-test-pattern

for you to fetch changes up to 0c4e05e5269f0ce68e61aa9222ea7da4b08beac9:

  smiapp: Implement the test pattern control (2014-08-01 16:51:10 +0300)

----------------------------------------------------------------
Sakari Ailus (3):
      v4l: Add test pattern colour component controls
      smiapp: Add driver-specific test pattern menu item definitions
      smiapp: Implement the test pattern control

 Documentation/DocBook/media/v4l/controls.xml |   34 +++++++++++
 drivers/media/i2c/smiapp/smiapp-core.c       |   79 ++++++++++++++++++++++++--
 drivers/media/i2c/smiapp/smiapp.h            |    4 ++
 drivers/media/v4l2-core/v4l2-ctrls.c         |    4 ++
 include/uapi/linux/Kbuild                    |    1 +
 include/uapi/linux/smiapp.h                  |   29 ++++++++++
 include/uapi/linux/v4l2-controls.h           |    4 ++
 7 files changed, 150 insertions(+), 5 deletions(-)
 create mode 100644 include/uapi/linux/smiapp.h

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
