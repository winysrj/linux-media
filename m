Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:54810 "EHLO
	lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932642AbbD0OYL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 27 Apr 2015 10:24:11 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id 35C852A0095
	for <linux-media@vger.kernel.org>; Mon, 27 Apr 2015 16:24:03 +0200 (CEST)
Message-ID: <553E4683.3010204@xs4all.nl>
Date: Mon, 27 Apr 2015 16:24:03 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [GIT PULL FOR v4.2] Fix compiler warnings, vivid improvements
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following changes since commit b3e5ced63e051e8f911b795ac5b06229a5328f7b:

  Merge tag 'v4.1-rc1' into patchwork (2015-04-27 10:32:45 -0300)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git for-v4.2f

for you to fetch changes up to c2abe92094034a3bdd8698ca5992b1b8239e975d:

  radio-bcm2048: fix compiler warning (2015-04-27 16:19:41 +0200)

----------------------------------------------------------------
Hans Verkuil (11):
      vivid-tpg: add tpg_log_status()
      vivid-tpg: add full range SMPTE 240M support
      vivid-tpg: add full range BT.2020 support
      vivid-tpg: add full range BT.2020C support
      vivid-tpg: fix XV601/709 Y'CbCr encoding
      DocBook/media: attemps -> attempts
      s5c73m3/s5k5baf/s5k6aa: fix compiler warnings
      s3c-camif: fix compiler warnings
      cx24123/mb86a20s/s921: fix compiler warnings
      dib8000: fix compiler warning
      radio-bcm2048: fix compiler warning

Philipp Zabel (1):
      vivid: add 1080p capture at 2 fps and 5 fps to webcam emulation

 Documentation/DocBook/media/v4l/media-func-open.xml |   2 +-
 drivers/media/dvb-frontends/cx24123.h               |   2 +-
 drivers/media/dvb-frontends/dib8000.h               |   2 +-
 drivers/media/dvb-frontends/mb86a20s.h              |   2 +-
 drivers/media/dvb-frontends/s921.h                  |   2 +-
 drivers/media/i2c/s5c73m3/s5c73m3-core.c            |   2 +-
 drivers/media/i2c/s5k5baf.c                         |   2 +-
 drivers/media/i2c/s5k6aa.c                          |   2 +-
 drivers/media/platform/s3c-camif/camif-capture.c    |   4 +--
 drivers/media/platform/vivid/vivid-core.c           |  13 ++++++++-
 drivers/media/platform/vivid/vivid-tpg.c            | 109 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-------------
 drivers/media/platform/vivid/vivid-tpg.h            |   1 +
 drivers/media/platform/vivid/vivid-vid-cap.c        |  13 +++++----
 drivers/staging/media/bcm2048/radio-bcm2048.c       |   3 +-
 14 files changed, 122 insertions(+), 37 deletions(-)
