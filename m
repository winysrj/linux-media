Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-1.cisco.com ([144.254.224.140]:51537 "EHLO
	ams-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753203Ab2AKKrz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Jan 2012 05:47:55 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "linux-media" <linux-media@vger.kernel.org>
Subject: [GIT PULL FOR v3.3] V4L2 Spec updates
Date: Wed, 11 Jan 2012 11:47:50 +0100
Cc: Rupert Eibauer <Rupert.Eibauer@ces.ch>,
	Archit Taneja <archit@ti.com>,
	Vaibhav Hiremath <hvaibhav@ti.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201201111147.50943.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Here are a bunch of V4L2 specification updates.

The first three are from this earlier RFC:

http://comments.gmane.org/gmane.linux.drivers.video-input-infrastructure/40701

There were no more comments, so this is the final pull request. It's unchanged
from RFCv2.

The other two fix a long standing missing piece of documentation for extended
controls (it was documented in v4l2-controls.txt, but never made it to the spec),
and make it more explicit that changing input or output means that you need to
query standards, formats, etc. again.

Regards,

	Hans

The following changes since commit 240ab508aa9fb7a294b0ecb563b19ead000b2463:

  [media] [PATCH] don't reset the delivery system on DTV_CLEAR (2012-01-10 23:44:07 -0200)

are available in the git repository at:
  git://linuxtv.org/hverkuil/media_tree.git spec3

Hans Verkuil (5):
      v4l2 spec: clarify usage of V4L2_FBUF_FLAG_OVERLAY
      zoran: do not set V4L2_FBUF_FLAG_OVERLAY.
      omap_vout: add missing OVERLAY_OUTPUT cap and set V4L2_FBUF_FLAG_OVERLAY
      V4L2 Spec: fix extended control documentation.
      V4L2 Spec: improve the G/S_INPUT/OUTPUT documentation.

 .../DocBook/media/v4l/vidioc-g-ext-ctrls.xml       |   18 +++++++++++----
 Documentation/DocBook/media/v4l/vidioc-g-fbuf.xml  |   23 ++++++++++++-------
 Documentation/DocBook/media/v4l/vidioc-g-input.xml |    4 +-
 .../DocBook/media/v4l/vidioc-g-output.xml          |    5 ++-
 Documentation/video4linux/v4l2-controls.txt        |   21 ------------------
 drivers/media/video/omap/omap_vout.c               |    7 ++++-
 drivers/media/video/zoran/zoran_driver.c           |    1 -
 7 files changed, 37 insertions(+), 42 deletions(-)
