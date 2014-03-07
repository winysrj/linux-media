Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr2.xs4all.nl ([194.109.24.22]:3868 "EHLO
	smtp-vbr2.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751130AbaCGLPj (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 7 Mar 2014 06:15:39 -0500
Received: from tschai.lan (173-38-208-169.cisco.com [173.38.208.169])
	(authenticated bits=0)
	by smtp-vbr2.xs4all.nl (8.13.8/8.13.8) with ESMTP id s27BFaxT035707
	for <linux-media@vger.kernel.org>; Fri, 7 Mar 2014 12:15:38 +0100 (CET)
	(envelope-from hverkuil@xs4all.nl)
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id B9BA52A1887
	for <linux-media@vger.kernel.org>; Fri,  7 Mar 2014 12:15:34 +0100 (CET)
Message-ID: <5319AA56.8020806@xs4all.nl>
Date: Fri, 07 Mar 2014 12:15:34 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [GIT PULL FOR v3.15] Various fixes for 3.15
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following changes since commit bfd0306462fdbc5e0a8c6999aef9dde0f9745399:

  [media] v4l: Document timestamp buffer flag behaviour (2014-03-05 16:48:28 -0300)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git for-v3.15d

for you to fetch changes up to fa7d917d4b77fc9de583a70c2405e2c628f39cb8:

  s2255drv: urgent memory leak fix. (2014-03-07 12:13:15 +0100)

----------------------------------------------------------------
Arnd Bergmann (1):
      arv: fix sleep_on race

Dan Carpenter (1):
      em28xx-cards: remove a wrong indent level

Fengguang Wu (1):
      drivers/media/usb/usbtv/usbtv-core.c:119:22: sparse: symbol 'usbtv_id_table' was not declared. Should it be static?

Geert Uytterhoeven (1):
      v4l: VIDEO_SH_VOU should depend on HAS_DMA

Hans Verkuil (2):
      v4l2-ctrls: replace BUG_ON by WARN_ON
      media DocBook: fix NV16M description.

Jon Mason (1):
      staging/dt3155v4l: use PCI_VENDOR_ID_INTEL

Philipp Zabel (2):
      tvp5150: Fix type mismatch warning in clamp macro
      tvp5150: Make debug module parameter visible in sysfs

sensoray-dev (1):
      s2255drv: urgent memory leak fix.

 Documentation/DocBook/media/v4l/pixfmt-nv16m.xml | 9 ++++-----
 drivers/media/i2c/tvp5150.c                      | 8 ++++----
 drivers/media/platform/Kconfig                   | 2 +-
 drivers/media/platform/arv.c                     | 6 +++---
 drivers/media/usb/em28xx/em28xx-cards.c          | 4 ++--
 drivers/media/usb/s2255/s2255drv.c               | 5 -----
 drivers/media/usb/usbtv/usbtv-core.c             | 4 ++--
 drivers/media/usb/usbtv/usbtv-video.c            | 6 +++---
 drivers/media/v4l2-core/v4l2-ctrls.c             | 3 ++-
 drivers/staging/media/dt3155v4l/dt3155v4l.c      | 3 +--
 10 files changed, 22 insertions(+), 28 deletions(-)
