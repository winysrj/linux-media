Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr10.xs4all.nl ([194.109.24.30]:3483 "EHLO
	smtp-vbr10.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753631Ab3F1Oli (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 28 Jun 2013 10:41:38 -0400
Received: from alastor.dyndns.org (166.80-203-20.nextgentel.com [80.203.20.166] (may be forged))
	(authenticated bits=0)
	by smtp-vbr10.xs4all.nl (8.13.8/8.13.8) with ESMTP id r5SEWF4Y080016
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-media@vger.kernel.org>; Fri, 28 Jun 2013 16:32:18 +0200 (CEST)
	(envelope-from hansverk@cisco.com)
Received: from tschai.localnet (tschai.lan [192.168.1.10])
	(Authenticated sender: hans)
	by alastor.dyndns.org (Postfix) with ESMTPSA id 7D7EA35E004C
	for <linux-media@vger.kernel.org>; Fri, 28 Jun 2013 16:32:14 +0200 (CEST)
From: Hans Verkuil <hansverk@cisco.com>
To: "linux-media" <linux-media@vger.kernel.org>
Subject: [GIT PULL FOR v3.11] Fixes for 3.11
Date: Fri, 28 Jun 2013 16:32:15 +0200
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201306281632.15238.hansverk@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following changes since commit ee17608d6aa04a86e253a9130d6c6d00892f132b:

  [media] imx074: support asynchronous probing (2013-06-21 16:36:15 -0300)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git for-v3.11

for you to fetch changes up to a2bdc80ec11aa569b56dea85550858743a79b999:

  media: i2c: tvp514x: remove manual setting of subdev name (2013-06-28 16:28:33 +0200)

----------------------------------------------------------------
Emil Goode (1):
      saa7134: Fix sparse warnings by adding __user annotation

Hans Verkuil (7):
      ml86v7667: fix compiler warning
      bfin_capture: fix compiler warning
      omap_vout: fix compiler warning
      v4l2-controls.h: fix copy-and-paste error in comment
      saa7164: fix compiler warning
      wl128x: add missing struct v4l2_device.
      mem2mem: set missing v4l2_dev pointer

Lad, Prabhakar (2):
      media: i2c: tvp7002: remove manual setting of subdev name
      media: i2c: tvp514x: remove manual setting of subdev name

Lars-Peter Clausen (1):
      tvp514x: Fix init seqeunce

 drivers/media/i2c/ml86v7667.c                  |  2 +-
 drivers/media/i2c/tvp514x.c                    | 11 +++++------
 drivers/media/i2c/tvp7002.c                    |  1 -
 drivers/media/pci/saa7134/saa7134-video.c      |  2 +-
 drivers/media/pci/saa7164/saa7164-core.c       |  3 ++-
 drivers/media/platform/blackfin/bfin_capture.c |  4 +++-
 drivers/media/platform/m2m-deinterlace.c       |  1 +
 drivers/media/platform/mem2mem_testdev.c       |  3 ++-
 drivers/media/platform/mx2_emmaprp.c           |  1 +
 drivers/media/platform/omap/omap_vout.c        |  3 +--
 drivers/media/radio/wl128x/fmdrv.h             |  2 ++
 drivers/media/radio/wl128x/fmdrv_v4l2.c        |  8 ++++++++
 include/uapi/linux/v4l2-controls.h             |  4 ++--
 13 files changed, 29 insertions(+), 16 deletions(-)
