Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud6.xs4all.net ([194.109.24.28]:35646 "EHLO
	lb2-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751538AbbK0ONy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 27 Nov 2015 09:13:54 -0500
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id 90F8AE0BBB
	for <linux-media@vger.kernel.org>; Fri, 27 Nov 2015 15:13:47 +0100 (CET)
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT PULL FOR v4.5] Three patches
Message-ID: <5658651B.8090804@xs4all.nl>
Date: Fri, 27 Nov 2015 15:13:47 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The v4l2-dv-timings patch is identical to what I sent before, but it merges the
pci-skeleton patch and fixes the docbook warning (was a typo).

Regards,

	Hans

The following changes since commit 10897dacea26943dd80bd6629117f4620fc320ef:

  Merge tag 'v4.4-rc2' into patchwork (2015-11-23 14:16:58 -0200)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git for-v4.5b

for you to fetch changes up to 737e89f00682c11d25ae987e0776a13db645fcec:

  cx231xx: constify cx2341x_handler_ops structures (2015-11-27 14:44:31 +0100)

----------------------------------------------------------------
Hans Verkuil (1):
      v4l2-dv-timings: add new arg to v4l2_match_dv_timings

Julia Lawall (2):
      media, sound: tea575x: constify snd_tea575x_ops structures
      cx231xx: constify cx2341x_handler_ops structures

 Documentation/video4linux/v4l2-pci-skeleton.c | 2 +-
 drivers/media/i2c/adv7604.c                   | 6 +++---
 drivers/media/i2c/adv7842.c                   | 6 +++---
 drivers/media/i2c/tc358743.c                  | 4 ++--
 drivers/media/pci/bt8xx/bttv-cards.c          | 2 +-
 drivers/media/pci/cobalt/cobalt-v4l2.c        | 2 +-
 drivers/media/pci/cx18/cx18-controls.c        | 2 +-
 drivers/media/pci/cx18/cx18-controls.h        | 2 +-
 drivers/media/pci/ivtv/ivtv-controls.c        | 2 +-
 drivers/media/pci/ivtv/ivtv-controls.h        | 2 +-
 drivers/media/platform/s5p-tv/hdmi_drv.c      | 2 +-
 drivers/media/platform/vivid/vivid-vid-cap.c  | 2 +-
 drivers/media/platform/vivid/vivid-vid-out.c  | 2 +-
 drivers/media/radio/radio-maxiradio.c         | 2 +-
 drivers/media/radio/radio-sf16fmr2.c          | 2 +-
 drivers/media/radio/radio-shark.c             | 2 +-
 drivers/media/usb/cx231xx/cx231xx-417.c       | 2 +-
 drivers/media/usb/hdpvr/hdpvr-video.c         | 2 +-
 drivers/media/v4l2-core/v4l2-dv-timings.c     | 9 +++++++--
 include/media/drv-intf/tea575x.h              | 2 +-
 include/media/v4l2-dv-timings.h               | 4 +++-
 sound/pci/es1968.c                            | 2 +-
 sound/pci/fm801.c                             | 2 +-
 23 files changed, 36 insertions(+), 29 deletions(-)
