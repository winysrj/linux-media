Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud3.xs4all.net ([194.109.24.22]:55430 "EHLO
	lb1-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751280AbbFBUN4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 2 Jun 2015 16:13:56 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id B5AB72A0089
	for <linux-media@vger.kernel.org>; Tue,  2 Jun 2015 22:13:48 +0200 (CEST)
Message-ID: <556E0E7C.8040005@xs4all.nl>
Date: Tue, 02 Jun 2015 22:13:48 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [GIT PULL FOR v4.2] Add support for the colorspace transfer function
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch series adds support to explicitly specify the colorspace transfer
function. This was always implicitly defined by the colorspace, but (as I
suspected that it might happen) this turned out not to work. In practice it
is an independent setting in its own right and it is commonly specified as
such (EDID, metadata inside compressed video streams).

In addition, you need this if you want to be able to specify linear RGB data
such as is often returned by raw sensor images and as is used by openGL.

The next step once this is merged is to start providing support for colorspace
conversion hardware.

Regards,

	Hans

The following changes since commit c1c3c85ddf60a6d97c122d57d385b4929fcec4b3:

  [media] DocBook: fix FE_SET_PROPERTY ioctl arguments (2015-06-01 06:10:15 -0300)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git xfer

for you to fetch changes up to 7d7627ee142035c9b9656da0219973814f6afa9a:

  vivid.txt: update the vivid documentation (2015-06-02 08:27:14 +0200)

----------------------------------------------------------------
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

 Documentation/DocBook/media/v4l/pixfmt.xml         | 113 ++++++++++++++----
 Documentation/DocBook/media/v4l/subdev-formats.xml |  12 +-
 Documentation/video4linux/vivid.txt                |  30 +++--
 drivers/media/i2c/adv7511.c                        |   5 +
 drivers/media/pci/cobalt/cobalt-driver.h           |   1 +
 drivers/media/pci/cobalt/cobalt-v4l2.c             |  17 ++-
 drivers/media/platform/am437x/am437x-vpfe.c        |   3 +-
 drivers/media/platform/vivid/vivid-core.h          |   1 +
 drivers/media/platform/vivid/vivid-ctrls.c         |  58 ++++++---
 drivers/media/platform/vivid/vivid-tpg-colors.c    | 478 +++++++++++++++++++++++++++++++++++++++++++++++++++++++------------------
 drivers/media/platform/vivid/vivid-tpg-colors.h    |   4 +-
 drivers/media/platform/vivid/vivid-tpg.c           |  13 +-
 drivers/media/platform/vivid/vivid-tpg.h           |  19 +++
 drivers/media/platform/vivid/vivid-vid-cap.c       |   9 ++
 drivers/media/platform/vivid/vivid-vid-common.c    |   2 +
 drivers/media/platform/vivid/vivid-vid-out.c       |   4 +
 drivers/media/v4l2-core/v4l2-ioctl.c               |   9 +-
 include/media/v4l2-mediabus.h                      |   2 +
 include/uapi/linux/v4l2-mediabus.h                 |   4 +-
 include/uapi/linux/videodev2.h                     |  41 ++++++-
 20 files changed, 640 insertions(+), 185 deletions(-)
