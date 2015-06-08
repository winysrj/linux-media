Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:46158 "EHLO
	lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932345AbbFHMJ1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 8 Jun 2015 08:09:27 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id BEE8A2A0095
	for <linux-media@vger.kernel.org>; Mon,  8 Jun 2015 14:09:20 +0200 (CEST)
Message-ID: <557585F0.7000904@xs4all.nl>
Date: Mon, 08 Jun 2015 14:09:20 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [GIT PULL FOR v4.2] Various fixes
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

m2m improvements, adv driver fixes/improvements, compiler warning fix,
interlaced and DV timings related fixes/improvements.

Regards,

	Hans

The following changes since commit 839aa56d077972170a074bcbe31bf0d7eba37b24:

  [media] v4l2-ioctl: log buffer type 0 correctly (2015-06-06 07:43:49 -0300)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git for-v4.2p

for you to fetch changes up to fe010ceb1951b55a2718bbeaa88bc5d743b9f834:

  cx231xx: fix compiler warning (2015-06-08 14:02:13 +0200)

----------------------------------------------------------------
Hans Verkuil (10):
      v4l2-mem2mem: add support for prepare_buf
      vim2m: add create_bufs and prepare_buf support
      adv7511: replace uintX_t by uX for consistency
      adv7842: replace uintX_t by uX for consistency
      adv7511: log the currently set infoframes
      adv7604: log infoframes
      adv7604: fix broken saturator check
      adv7604: log alt-gamma and HDMI colorspace
      v4l2-dv-timings: support interlaced in v4l2_print_dv_timings
      cx231xx: fix compiler warning

Prashant Laddha (3):
      v4l2-dv-timing: avoid rounding twice in gtf hblank calc
      v4l2-dv-timings: add interlace support in detect cvt/gtf
      vivid: Use interlaced info for cvt/gtf timing detection

 drivers/media/i2c/Kconfig                    |   2 ++
 drivers/media/i2c/adv7511.c                  | 155 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++----------
 drivers/media/i2c/adv7604.c                  | 107 ++++++++++++++++++++++++++++++++++++------------------
 drivers/media/i2c/adv7842.c                  |  26 +++++++-------
 drivers/media/pci/cobalt/cobalt-driver.c     |   1 +
 drivers/media/platform/vim2m.c               |   8 +++++
 drivers/media/platform/vivid/vivid-vid-cap.c |   5 +--
 drivers/media/usb/cx231xx/cx231xx-cards.c    |  28 +++++++++------
 drivers/media/v4l2-core/v4l2-dv-timings.c    |  70 ++++++++++++++++++++++++++++++------
 drivers/media/v4l2-core/v4l2-mem2mem.c       |  28 +++++++++++++++
 include/media/adv7511.h                      |   7 ++--
 include/media/adv7842.h                      |  50 +++++++++++++-------------
 include/media/v4l2-dv-timings.h              |   6 ++--
 include/media/v4l2-mem2mem.h                 |   4 +++
 14 files changed, 380 insertions(+), 117 deletions(-)
