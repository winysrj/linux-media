Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:1177 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751049Ab3FXIoa (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 24 Jun 2013 04:44:30 -0400
Received: from alastor.dyndns.org (166.80-203-20.nextgentel.com [80.203.20.166] (may be forged))
	(authenticated bits=0)
	by smtp-vbr4.xs4all.nl (8.13.8/8.13.8) with ESMTP id r5O8iQ0D011803
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-media@vger.kernel.org>; Mon, 24 Jun 2013 10:44:28 +0200 (CEST)
	(envelope-from hverkuil@xs4all.nl)
Received: from tschai.localnet (tschai.lan [192.168.1.10])
	(Authenticated sender: hans)
	by alastor.dyndns.org (Postfix) with ESMTPSA id 5AE4235E0027
	for <linux-media@vger.kernel.org>; Mon, 24 Jun 2013 10:44:25 +0200 (CEST)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "linux-media" <linux-media@vger.kernel.org>
Subject: [GIT PULL FOR v3.11] Updates for 3.11
Date: Mon, 24 Jun 2013 10:44:25 +0200
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201306241044.25541.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

(Same as my previous git pull message, but with an additional patch from
Prabhakar.)

Some async/OF work from Prabhakar (the correct version this time) and
assorted improvements and fixes for compiler warnings.

Regards,

        Hans

The following changes since commit ee17608d6aa04a86e253a9130d6c6d00892f132b:

  [media] imx074: support asynchronous probing (2013-06-21 16:36:15 -0300)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git for-v3.11

for you to fetch changes up to a0d1da533b6b5dd76644364ad0e000a77275c88d:

  media: i2c: tvp7002: add support for asynchronous probing (2013-06-24 10:40:04 +0200)

----------------------------------------------------------------
Emil Goode (1):
      saa7134: Fix sparse warnings by adding __user annotation

Hans Verkuil (5):
      ml86v7667: fix compiler warning
      bfin_capture: fix compiler warning
      omap_vout: fix compiler warning
      v4l2-controls.h: fix copy-and-paste error in comment
      saa7164: fix compiler warning

Lad, Prabhakar (4):
      media: i2c: ths8200: support asynchronous probing
      media: i2c: ths8200: add OF support
      media: i2c: adv7343: add support for asynchronous probing
      media: i2c: tvp7002: add support for asynchronous probing

Lars-Peter Clausen (1):
      tvp514x: Fix init seqeunce

 Documentation/devicetree/bindings/media/i2c/ths8200.txt | 19 +++++++++++++++++++
 drivers/media/i2c/adv7343.c                             | 15 +++++++++++----
 drivers/media/i2c/ml86v7667.c                           |  2 +-
 drivers/media/i2c/ths8200.c                             | 18 +++++++++++++++++-
 drivers/media/i2c/tvp514x.c                             | 10 +++++-----
 drivers/media/i2c/tvp7002.c                             |  6 ++++++
 drivers/media/pci/saa7134/saa7134-video.c               |  2 +-
 drivers/media/pci/saa7164/saa7164-core.c                |  3 ++-
 drivers/media/platform/blackfin/bfin_capture.c          |  4 +++-
 drivers/media/platform/omap/omap_vout.c                 |  3 +--
 include/uapi/linux/v4l2-controls.h                      |  4 ++--
 11 files changed, 68 insertions(+), 18 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/media/i2c/ths8200.txt
