Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud6.xs4all.net ([194.109.24.24]:33347 "EHLO
	lb1-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753374AbbLGMs1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 7 Dec 2015 07:48:27 -0500
Received: from [192.168.1.137] (marune.xs4all.nl [80.101.105.217])
	by tschai.lan (Postfix) with ESMTPSA id 69C33E0BBD
	for <linux-media@vger.kernel.org>; Mon,  7 Dec 2015 13:48:22 +0100 (CET)
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT PULL FOR v4.5] Add ViewCast 260e/460e support & many fixes
Message-ID: <56658015.6000800@xs4all.nl>
Date: Mon, 7 Dec 2015 13:48:21 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds support for the ViewCast 260e/460e patches, based on old Kernel Labs
patches.

While testing the ViewCast 460e card I had on loan I discovered a range of bugs,
primarily in the cx23888 implementation of the cx25840 module.

Tested for NTSC/PAL, video and vbi. Also checked for regressions on a cx23885
based board, a cx25840 board and a cx231xx board.

It also adds simple support for the cs3308 audio device, used by the ViewCast boards.

Regards,

	Hans

The following changes since commit 10897dacea26943dd80bd6629117f4620fc320ef:

  Merge tag 'v4.4-rc2' into patchwork (2015-11-23 14:16:58 -0200)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git viewcast

for you to fetch changes up to 7eac3e718417f1f37a467a1c704d38bdeab86f18:

  cx23885: video instead of vbi register used (2015-11-30 21:19:26 +0100)

----------------------------------------------------------------
Hans Verkuil (11):
      cx23885: fix format/crop handling
      cx231xx: fix NTSC cropcap, add missing cropcap for 417
      ivtv/cx18: fix inverted pixel aspect ratio
      cx25840: fix VBI support for cx23888
      cx25840: more cx23888 register address changes
      cx25840: relax a Vsrc check
      cx25840: fix cx25840_s_stream for cx2388x and cx231xx
      cx25840: initialize the standard to NTSC_M
      cs3308: add new 8-channel volume control driver
      cx23885: add support for ViewCast 260e and 460e.
      cx23885: video instead of vbi register used

 MAINTAINERS                               |   9 +++++++
 drivers/media/i2c/Kconfig                 |  10 ++++++++
 drivers/media/i2c/Makefile                |   1 +
 drivers/media/i2c/cs3308.c                | 138 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/media/i2c/cx25840/cx25840-core.c  | 115 ++++++++++++++++++++++++++++++++++++++++++----------------------------------------
 drivers/media/i2c/cx25840/cx25840-core.h  |   1 +
 drivers/media/i2c/cx25840/cx25840-vbi.c   |  32 ++++++++++++++++-------
 drivers/media/pci/cx18/cx18-ioctl.c       |   4 +--
 drivers/media/pci/cx23885/Kconfig         |   1 +
 drivers/media/pci/cx23885/cx23885-cards.c | 114 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/media/pci/cx23885/cx23885-core.c  |  10 ++++++++
 drivers/media/pci/cx23885/cx23885-i2c.c   |   2 ++
 drivers/media/pci/cx23885/cx23885-vbi.c   |   3 +--
 drivers/media/pci/cx23885/cx23885-video.c |  43 +++++++++++++++++++++++++++++--
 drivers/media/pci/cx23885/cx23885.h       |   7 ++---
 drivers/media/pci/ivtv/ivtv-ioctl.c       |   8 +++---
 drivers/media/usb/cx231xx/cx231xx-417.c   |  22 ++++++++++++++++
 drivers/media/usb/cx231xx/cx231xx-video.c |   5 ++--
 18 files changed, 444 insertions(+), 81 deletions(-)
 create mode 100644 drivers/media/i2c/cs3308.c
