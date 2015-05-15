Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:33681 "EHLO
	lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933981AbbEOLjM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 15 May 2015 07:39:12 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id 999312A009F
	for <linux-media@vger.kernel.org>; Fri, 15 May 2015 13:38:58 +0200 (CEST)
Message-ID: <5555DAD2.6080703@xs4all.nl>
Date: Fri, 15 May 2015 13:38:58 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [GIT PULL FOR v4.2] Various fixes
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following changes since commit 0fae1997f09796aca8ada5edc028aef587f6716c:

  [media] dib0700: avoid the risk of forgetting to add the adapter's size (2015-05-14 19:31:34 -0300)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git for-4.2h

for you to fetch changes up to ac640baa8ee43f01529e8ca5b98972ed50de1f7d:

  DocBook/media: add missing entry for V4L2_PIX_FMT_Y16_BE (2015-05-15 12:30:54 +0200)

----------------------------------------------------------------
Hans Verkuil (7):
      DocBook/media: fix querycap error code
      sta2x11: use monotonic timestamp
      rcar-vin: use monotonic timestamps
      DocBook/media: remove spurious space.
      DocBook/media: improve timestamp documentation
      DocBook/media: fix syntax error
      DocBook/media: add missing entry for V4L2_PIX_FMT_Y16_BE

Prashant Laddha (1):
      v4l2-dv-timings: fix overflow in gtf timings calculation

Ricardo Ribalda Delgado (4):
      media/vivid: Add support for Y16 format
      media/v4l2-core: Add support for V4L2_PIX_FMT_Y16_BE
      media/vivid: Add support for Y16_BE format
      media/vivid: Code cleanout

 Documentation/DocBook/media/v4l/io.xml              |  2 +-
 Documentation/DocBook/media/v4l/pixfmt-y16-be.xml   | 81 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 Documentation/DocBook/media/v4l/pixfmt.xml          |  1 +
 Documentation/DocBook/media/v4l/vidioc-dqevent.xml  |  5 ++++-
 Documentation/DocBook/media/v4l/vidioc-qbuf.xml     |  4 +++-
 Documentation/DocBook/media/v4l/vidioc-querycap.xml |  2 +-
 drivers/media/pci/sta2x11/sta2x11_vip.c             |  3 ++-
 drivers/media/platform/soc_camera/rcar_vin.c        |  2 +-
 drivers/media/platform/vivid/vivid-tpg.c            | 20 ++++++++++++++----
 drivers/media/platform/vivid/vivid-vid-common.c     | 16 +++++++++++++++
 drivers/media/v4l2-core/v4l2-dv-timings.c           | 28 ++++++++++++++++---------
 drivers/media/v4l2-core/v4l2-ioctl.c                |  1 +
 include/uapi/linux/videodev2.h                      |  1 +
 13 files changed, 146 insertions(+), 20 deletions(-)
 create mode 100644 Documentation/DocBook/media/v4l/pixfmt-y16-be.xml
