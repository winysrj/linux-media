Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:40081 "EHLO
	lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751148AbbBBLpc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 2 Feb 2015 06:45:32 -0500
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id 270EF2A0080
	for <linux-media@vger.kernel.org>; Mon,  2 Feb 2015 12:44:54 +0100 (CET)
Message-ID: <54CF6336.1080103@xs4all.nl>
Date: Mon, 02 Feb 2015 12:44:54 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [GIT PULL FOR v3.20] Various fixes
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following changes since commit a5f43c18fceb2b96ec9fddb4348f5282a71cf2b0:

  [media] Documentation/video4linux: remove obsolete text files (2015-01-29 19:16:30 -0200)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git for-v3.20c

for you to fetch changes up to 533ab6434b8d57778bd764bcae2e9ec8fdf068a5:

  davinci: add V4L2 dependencies (2015-02-02 11:49:28 +0100)

----------------------------------------------------------------
Alexey Khoroshilov (1):
      cx231xx: fix usbdev leak on failure paths in cx231xx_usb_probe()

Arnd Bergmann (4):
      timberdale: do not select TIMB_DMA
      radio/aimslab: use mdelay instead of udelay
      siano: fix Kconfig dependencies
      davinci: add V4L2 dependencies

Hans Verkuil (1):
      vivid: use consistent colorspace/Y'CbCr Encoding strings

Ismael Luceno (1):
      MAINTAINERS: Update solo6x10 entry

Nicholas Mc Guire (1):
      pvrusb2: use msecs_to_jiffies for conversion

Prabhakar Lad (1):
      media: am437x: fix sparse warnings

 MAINTAINERS                                 |  1 +
 drivers/media/mmc/siano/Kconfig             |  2 ++
 drivers/media/platform/Kconfig              |  6 ++----
 drivers/media/platform/am437x/am437x-vpfe.c |  5 ++---
 drivers/media/platform/davinci/Kconfig      |  6 +++---
 drivers/media/platform/vivid/vivid-ctrls.c  |  4 ++--
 drivers/media/radio/radio-aimslab.c         |  4 ++--
 drivers/media/usb/cx231xx/cx231xx-cards.c   |  7 ++++---
 drivers/media/usb/pvrusb2/pvrusb2-hdw.c     | 19 ++++++++-----------
 drivers/media/usb/siano/Kconfig             |  2 ++
 10 files changed, 28 insertions(+), 28 deletions(-)
