Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:4389 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750707AbaIUJf6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 21 Sep 2014 05:35:58 -0400
Received: from tschai.lan (209.80-203-20.nextgentel.com [80.203.20.209] (may be forged))
	(authenticated bits=0)
	by smtp-vbr12.xs4all.nl (8.13.8/8.13.8) with ESMTP id s8L9Zsrp016064
	for <linux-media@vger.kernel.org>; Sun, 21 Sep 2014 11:35:56 +0200 (CEST)
	(envelope-from hverkuil@xs4all.nl)
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id D94552A002F
	for <linux-media@vger.kernel.org>; Sun, 21 Sep 2014 11:35:48 +0200 (CEST)
Message-ID: <541E9BF4.1060702@xs4all.nl>
Date: Sun, 21 Sep 2014 11:35:48 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [GIT PULL FOR v3.18] Fixes, add teletext to vivid
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Various 3.18 fixes and the teletext support for vivid.

Regards,

	Hans

The following changes since commit f5281fc81e9a0a3e80b78720c5ae2ed06da3bfae:

  [media] vpif: Fix compilation with allmodconfig (2014-09-09 18:08:08 -0300)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git for-v3.18c

for you to fetch changes up to bff227b31543edd2d52d27ac5ff51da53032b3b4:

  cx23885: fix size helper functions (2014-09-21 11:24:28 +0200)

----------------------------------------------------------------
Hans Verkuil (6):
      DocBook media: fix wrong prototype
      vivid: add teletext support to VBI capture
      v4l2-dv-timings: only check standards if non-zero
      adv7604/adv7842: fix il_vbackporch typo and zero the struct
      cx23885: fix VBI support.
      cx23885: fix size helper functions

 Documentation/DocBook/media/v4l/vidioc-g-edid.xml |  2 +-
 Documentation/video4linux/vivid.txt               | 10 ++++++----
 drivers/media/i2c/adv7604.c                       |  2 +-
 drivers/media/i2c/adv7842.c                       |  4 +++-
 drivers/media/pci/cx23885/cx23885-core.c          |  4 ++--
 drivers/media/pci/cx23885/cx23885-vbi.c           |  8 ++++----
 drivers/media/pci/cx23885/cx23885-video.c         |  2 +-
 drivers/media/pci/cx23885/cx23885.h               |  9 ++-------
 drivers/media/platform/vivid/vivid-vbi-cap.c      | 43 ++++++++++++++++++++++++++++--------------
 drivers/media/platform/vivid/vivid-vbi-gen.c      | 76 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 drivers/media/platform/vivid/vivid-vbi-gen.h      |  2 +-
 drivers/media/platform/vivid/vivid-vbi-out.c      |  7 ++++---
 drivers/media/platform/vivid/vivid-vid-cap.c      |  2 +-
 drivers/media/platform/vivid/vivid-vid-out.c      |  2 +-
 drivers/media/v4l2-core/v4l2-dv-timings.c         |  3 ++-
 15 files changed, 133 insertions(+), 43 deletions(-)
