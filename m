Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud3.xs4all.net ([194.109.24.30]:38310 "EHLO
	lb3-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754896AbbEaNLs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 31 May 2015 09:11:48 -0400
Received: from tschai.fritz.box (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id 33C342A0003
	for <linux-media@vger.kernel.org>; Sun, 31 May 2015 15:11:41 +0200 (CEST)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: [PATCH 0/9] Add support for the colorspace transfer function
Date: Sun, 31 May 2015 15:11:30 +0200
Message-Id: <1433077899-18516-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Until now the colorspace define also implied which transfer function should
be used (sometimes known - incorrectly - as the gamma). After doing more
research it is clear that this should be split off as a separate value. I
always left the door open for this since I suspected I would have to do it at
some point.

The reasons for this are:

1) Most compressed (if not all) formats provide this as a separate setting as well,
   and also EDIDs supply it as a separate setting.
2) OpenGL uses linear RGB (i.e. no transfer function was applied at all to the
   R, G and B components), and that cannot currently be represented as long as it
   is implicitly specified by the colorspace.
3) While in theory HDMI video that uses e.g. sRGB should use the sRGB transfer function
   as well, in practice a different transfer function such as Rec.709 might be
   used (I've seen this happen). You need to be able to represent that, and the
   only way to do that is by making it a separate setting.

This patch series adds support for this.

Regards,

	Hans

Hans Verkuil (9):
  videodev2.h: add support for transfer functions
  DocBook/media: document new xfer_func fields.
  adv7511: add xfer_func support
  am437x-vpfe: add support for xfer_func
  vivid: add xfer_func support.
  vivid-tpg: precalculate colorspace/xfer_func combinations
  cobalt: support transfer function
  cobalt: simplify colorspace code
  vivid.txt: update the vivid documentation

 Documentation/DocBook/media/v4l/pixfmt.xml         | 113 ++++-
 Documentation/DocBook/media/v4l/subdev-formats.xml |  12 +-
 Documentation/video4linux/vivid.txt                |  30 +-
 drivers/media/i2c/adv7511.c                        |   5 +
 drivers/media/pci/cobalt/cobalt-driver.h           |   1 +
 drivers/media/pci/cobalt/cobalt-v4l2.c             |  17 +-
 drivers/media/platform/am437x/am437x-vpfe.c        |   3 +-
 drivers/media/platform/vivid/vivid-core.h          |   1 +
 drivers/media/platform/vivid/vivid-ctrls.c         |  58 ++-
 drivers/media/platform/vivid/vivid-tpg-colors.c    | 478 ++++++++++++++++-----
 drivers/media/platform/vivid/vivid-tpg-colors.h    |   4 +-
 drivers/media/platform/vivid/vivid-tpg.c           |  13 +-
 drivers/media/platform/vivid/vivid-tpg.h           |  19 +
 drivers/media/platform/vivid/vivid-vid-cap.c       |   9 +
 drivers/media/platform/vivid/vivid-vid-common.c    |   2 +
 drivers/media/platform/vivid/vivid-vid-out.c       |   4 +
 drivers/media/v4l2-core/v4l2-ioctl.c               |   9 +-
 include/media/v4l2-mediabus.h                      |   2 +
 include/uapi/linux/v4l2-mediabus.h                 |   4 +-
 include/uapi/linux/videodev2.h                     |  41 +-
 20 files changed, 640 insertions(+), 185 deletions(-)

-- 
2.1.4

