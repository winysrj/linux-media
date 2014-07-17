Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:1668 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754849AbaGQJfK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Jul 2014 05:35:10 -0400
Received: from tschai.lan (173-38-208-169.cisco.com [173.38.208.169])
	(authenticated bits=0)
	by smtp-vbr14.xs4all.nl (8.13.8/8.13.8) with ESMTP id s6H9Z7AG071703
	for <linux-media@vger.kernel.org>; Thu, 17 Jul 2014 11:35:09 +0200 (CEST)
	(envelope-from hverkuil@xs4all.nl)
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id 0D2752A1FD1
	for <linux-media@vger.kernel.org>; Thu, 17 Jul 2014 11:35:06 +0200 (CEST)
Message-ID: <53C798C9.8030609@xs4all.nl>
Date: Thu, 17 Jul 2014 11:35:05 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [GIT PULL FOR v3.17] Assorted patches
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mostly little cleanups and adding a new card to cx23885.

	Hans

The following changes since commit 3c0d394ea7022bb9666d9df97a5776c4bcc3045c:

  [media] dib8000: improve the message that reports per-layer locks (2014-07-07 09:59:01 -0300)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git for-v3.17b

for you to fetch changes up to 46c9074bfa73aaf1dfce77d078fcf636652d4e99:

  zoran: remove duplicate ZR050_MO_COMP define (2014-07-17 10:49:11 +0200)

----------------------------------------------------------------
Andreas Weber (1):
      DocBook media: fix number of bits filled with zeros for

Andrey Utkin (3):
      solo6x10: expose encoder quantization setting as V4L2 control
      solo6x10: update GOP size, QP immediately
      media: pvrusb2: make logging code sane

Anil Belur (1):
      staging: media: bcm2048: radio-bcm2048.c - removed IRQF_DISABLED macro

Dan Carpenter (1):
      zoran: remove duplicate ZR050_MO_COMP define

Geert Uytterhoeven (1):
      staging/solo6x10: SOLO6X10 should select BITREVERSE

Hans Verkuil (3):
      cx23885: fix UNSET/TUNER_ABSENT confusion.
      cx23885: add support for Hauppauge ImpactVCB-e
      hdpvr: fix reported HDTV colorspace

Himangi Saraogi (1):
      saa7164-dvb: Remove unnecessary null test

Luke Hart (1):
      radio-bcm2048.c: Fix some checkpatch.pl errors

 Documentation/DocBook/media/v4l/pixfmt-srggb12.xml |  2 +-
 drivers/media/pci/cx23885/cx23885-417.c            |  8 ++++----
 drivers/media/pci/cx23885/cx23885-cards.c          | 31 ++++++++++++++++++++++++++++++-
 drivers/media/pci/cx23885/cx23885-video.c          | 11 ++++++-----
 drivers/media/pci/cx23885/cx23885.h                |  1 +
 drivers/media/pci/saa7164/saa7164-dvb.c            | 32 ++++++++++++++------------------
 drivers/media/pci/zoran/zr36050.h                  |  1 -
 drivers/media/usb/hdpvr/hdpvr-video.c              |  2 +-
 drivers/media/usb/pvrusb2/pvrusb2-v4l2.c           | 12 +++---------
 drivers/staging/media/bcm2048/radio-bcm2048.c      | 22 +++++++++++-----------
 drivers/staging/media/solo6x10/Kconfig             |  1 +
 drivers/staging/media/solo6x10/solo6x10-v4l2-enc.c |  9 +++++++++
 12 files changed, 81 insertions(+), 51 deletions(-)
