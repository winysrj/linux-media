Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud6.xs4all.net ([194.109.24.28]:44661 "EHLO
	lb2-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752719AbaLAJPJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 1 Dec 2014 04:15:09 -0500
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id 2B3DC2A008F
	for <linux-media@vger.kernel.org>; Mon,  1 Dec 2014 10:14:53 +0100 (CET)
Message-ID: <547C318D.1050009@xs4all.nl>
Date: Mon, 01 Dec 2014 10:14:53 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [GIT PULL FOR v3.19] Improve V4L2 colorspace handling
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

This pull request improves the colorspace handling in V4L2 as discussed before
in Düsseldorf and in the v3 patch series:

http://www.mail-archive.com/linux-media@vger.kernel.org/msg82487.html

Support for the improved colorspaces has been added to vivid and adv7511. The
adv7511 changes have been tested with actual hardware (a loop between the adv7511
and the adv7604). Since linux/hdmi.h doesn't yet have support for BT2020 those
InfoFrame values have been hardcoded. But I'll make a patch to change that once
the new defines will appear in hdmi.h.

A patch for adv7604 and probably adv7842 adding support for this is in the pipeline,
but I need to do more testing. While I can detect what it sent to the adv7604 without
any problem, the adv7604 does some conversions as well and those are not yet
exposed correctly to userspace. Unfortunately I have a higher prio project to
finish first before I can spend time on that. But that doesn't block this pull
request from being merged.

Once this is merged I'll update v4l-utils and valgrind to support the new colorspace
fields.

Regards,

	Hans

The following changes since commit 504febc3f98c87a8bebd8f2f274f32c0724131e4:

  Revert "[media] lmed04: add missing breaks" (2014-11-25 22:16:25 -0200)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git colorspace-api

for you to fetch changes up to 1f27f940b48e14057684b0025317b148b430495f:

  adv7511: improve colorspace handling (2014-12-01 09:48:23 +0100)

----------------------------------------------------------------
Hans Verkuil (9):
      videodev2.h: improve colorspace support
      v4l2-mediabus: improve colorspace support
      v4l2-ioctl.c: log the new ycbcr_enc and quantization fields
      DocBook media: rewrite the Colorspace chapter
      vivid-tpg-colors: add AdobeRGB and BT.2020 support
      vivid-tpg: improve colorspace support
      vivid: add new colorspaces
      vivid: add support for YCbCr encoding and quantization
      adv7511: improve colorspace handling

 Documentation/DocBook/media/v4l/biblio.xml      |   85 +++++
 Documentation/DocBook/media/v4l/pixfmt.xml      | 1274 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++------------------
 drivers/media/i2c/adv7511.c                     |  208 +++++++++++++
 drivers/media/platform/vivid/vivid-core.h       |   13 +
 drivers/media/platform/vivid/vivid-ctrls.c      |  113 +++++--
 drivers/media/platform/vivid/vivid-tpg-colors.c |  704 ++++++++++++++++++++++++++++++++++++++---
 drivers/media/platform/vivid/vivid-tpg-colors.h |    4 +-
 drivers/media/platform/vivid/vivid-tpg.c        |  327 ++++++++++++-------
 drivers/media/platform/vivid/vivid-tpg.h        |   38 +++
 drivers/media/platform/vivid/vivid-vid-cap.c    |   34 +-
 drivers/media/platform/vivid/vivid-vid-common.c |    4 +
 drivers/media/platform/vivid/vivid-vid-out.c    |   25 +-
 drivers/media/v4l2-core/v4l2-ioctl.c            |   11 +-
 include/media/v4l2-mediabus.h                   |    4 +
 include/uapi/linux/v4l2-mediabus.h              |    6 +-
 include/uapi/linux/videodev2.h                  |   99 +++++-
 16 files changed, 2440 insertions(+), 509 deletions(-)
