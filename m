Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud6.xs4all.net ([194.109.24.28]:34328 "EHLO
	lb2-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752098AbaLSKox (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Dec 2014 05:44:53 -0500
Received: from [10.61.169.145] (173-38-208-169.cisco.com [173.38.208.169])
	by tschai.lan (Postfix) with ESMTPSA id 3D4CB2A002F
	for <linux-media@vger.kernel.org>; Fri, 19 Dec 2014 11:44:33 +0100 (CET)
Message-ID: <5494019B.3050103@xs4all.nl>
Date: Fri, 19 Dec 2014 11:44:43 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: [GIT PULL FOR v3.20] cx25821: convert to vb2
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This pull request converts this driver to the vb2 framework.

I have tested video capture with my cx25821 board. Audio capture
DMA works as well, but since my board doesn't have an audio line-in
I couldn't test it with actual audio.

This patch series also removes the last case of btcx-risc abuse, so
that module can now be merged again with bttv, which is where it
belongs.

Regards,

	Hans

The following changes since commit 427ae153c65ad7a08288d86baf99000569627d03:

  [media] bq/c-qcam, w9966, pms: move to staging in preparation for removal (2014-12-16 23:21:44 -0200)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git for-v3.20d

for you to fetch changes up to 0b3b8440e1a9ce7a77c0dba6a3deb7980b0e1dc5:

  cx25821: remove video output support (2014-12-19 11:42:08 +0100)

----------------------------------------------------------------
Hans Verkuil (7):
      cx25821: remove bogus btcx_risc dependency
      cx231xx: remove btcx_riscmem reference
      btcx-risc: move to bt8xx
      cx28521: drop videobuf abuse in cx25821-alsa
      cx25821: convert to vb2
      cx25821: add create_bufs support
      cx25821: remove video output support

 drivers/media/common/Kconfig                    |   4 -
 drivers/media/common/Makefile                   |   1 -
 drivers/media/pci/bt8xx/Kconfig                 |   1 -
 drivers/media/pci/bt8xx/Makefile                |   2 +-
 drivers/media/{common => pci/bt8xx}/btcx-risc.c |  36 +---
 drivers/media/{common => pci/bt8xx}/btcx-risc.h |   8 -
 drivers/media/pci/cx25821/Kconfig               |   3 +-
 drivers/media/pci/cx25821/Makefile              |   3 +-
 drivers/media/pci/cx25821/cx25821-alsa.c        | 113 ++++++++--
 drivers/media/pci/cx25821/cx25821-core.c        | 112 +++++-----
 drivers/media/pci/cx25821/cx25821-video.c       | 685 ++++++++++++++++---------------------------------------------
 drivers/media/pci/cx25821/cx25821.h             |  48 +++--
 drivers/media/usb/cx231xx/cx231xx.h             |  10 +-
 13 files changed, 368 insertions(+), 658 deletions(-)
 rename drivers/media/{common => pci/bt8xx}/btcx-risc.c (90%)
 rename drivers/media/{common => pci/bt8xx}/btcx-risc.h (92%)
