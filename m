Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud6.xs4all.net ([194.109.24.28]:43027 "EHLO
	lb2-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751244AbcGVP3I (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 22 Jul 2016 11:29:08 -0400
Received: from [192.168.1.137] (marune.xs4all.nl [80.101.105.217])
	by tschai.lan (Postfix) with ESMTPSA id F14BA180050
	for <linux-media@vger.kernel.org>; Fri, 22 Jul 2016 17:29:01 +0200 (CEST)
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT PULL FOR v4.8] (v4) Various fixes
Message-ID: <faa8c34b-1b86-9760-118b-db99f8e8a398@xs4all.nl>
Date: Fri, 22 Jul 2016 17:29:01 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Another bunch of bug fixes for 4.8.

The vb2 fix is particularly nasty, the others are all pretty trivial.

Regards,

	Hans

New for v4: dropped cleanup patches. Will be a separate pull request for 4.9.
New for v3: added patch "cec: fix off-by-one memset"
New for v2: added patch "staging: add MEDIA_SUPPORT dependency"

The following changes since commit 009a620848218d521f008141c62f56bf19294dd9:

  [media] cec: always check all_device_types and features (2016-07-19 13:27:46 -0300)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git for-v4.8a

for you to fetch changes up to 58ef16e4ff962d4d7903527f3571ff4723ead1b8:

  cec: fix off-by-one memset (2016-07-22 17:23:29 +0200)

----------------------------------------------------------------
Arnd Bergmann (1):
      staging: add MEDIA_SUPPORT dependency

Hans Verkuil (5):
      adv7511: fix VIC autodetect
      vim2m: copy the other colorspace-related fields as well
      vivid: don't handle CEC_MSG_SET_STREAM_PATH
      airspy: fix compiler warning
      cec: fix off-by-one memset

Steve Longerbeam (1):
      media: adv7180: Fix broken interrupt register access

Vincent Stehlé (1):
      vb2: Fix allocation size of dma_parms

 drivers/media/i2c/adv7180.c                    | 18 +++++++++---------
 drivers/media/i2c/adv7511.c                    | 24 ++++++++++++++++++++----
 drivers/media/platform/vim2m.c                 | 15 ++++++++++++++-
 drivers/media/platform/vivid/vivid-cec.c       | 10 ----------
 drivers/media/usb/airspy/airspy.c              |  1 -
 drivers/media/v4l2-core/videobuf2-dma-contig.c |  2 +-
 drivers/staging/media/Kconfig                  |  2 +-
 drivers/staging/media/cec/cec-adap.c           |  2 +-
 8 files changed, 46 insertions(+), 28 deletions(-)
