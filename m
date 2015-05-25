Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud3.xs4all.net ([194.109.24.22]:60939 "EHLO
	lb1-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751119AbbEYIuE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 25 May 2015 04:50:04 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id 5BC6F2A0095
	for <linux-media@vger.kernel.org>; Mon, 25 May 2015 10:49:59 +0200 (CEST)
Message-ID: <5562E237.2090107@xs4all.nl>
Date: Mon, 25 May 2015 10:49:59 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [GIT PULL FOR v4.2] cobalt fixes and sparse/compiler warning fixes
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following changes since commit 2a80f296422a01178d0a993479369e94f5830127:

  [media] dvb-core: fix 32-bit overflow during bandwidth calculation (2015-05-20 14:01:46 -0300)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git cobalt-fixes

for you to fetch changes up to 330a3e910e8832046267d0dbb5871b4aaf375a26:

  adv7604/cobalt: missing GPIOLIB dependency (2015-05-25 10:49:07 +0200)

----------------------------------------------------------------
Hans Verkuil (12):
      cobalt: fix irqs used for the adv7511 transmitter
      cobalt: fix 64-bit division link error
      cobalt: fix compiler warnings on 32 bit OSes
      e4000: fix compiler warning
      cobalt: fix sparse warnings
      cobalt: fix sparse warnings
      cobalt: fix sparse warnings
      cobalt: fix sparse warnings
      cobalt: fix sparse warnings
      cx24120: fix sparse warning
      saa7164: fix sparse warning
      adv7604/cobalt: missing GPIOLIB dependency

 drivers/media/dvb-frontends/cx24120.c     |   2 +-
 drivers/media/i2c/Kconfig                 |   2 +-
 drivers/media/pci/cobalt/Kconfig          |   2 +-
 drivers/media/pci/cobalt/cobalt-cpld.c    |   6 +--
 drivers/media/pci/cobalt/cobalt-driver.c  |  18 +++++--
 drivers/media/pci/cobalt/cobalt-driver.h  |  22 ++++----
 drivers/media/pci/cobalt/cobalt-flash.c   |  18 +++----
 drivers/media/pci/cobalt/cobalt-i2c.c     |  56 ++++++++++----------
 drivers/media/pci/cobalt/cobalt-irq.c     |  58 ++++++++++----------
 drivers/media/pci/cobalt/cobalt-omnitek.c |  12 ++---
 drivers/media/pci/cobalt/cobalt-v4l2.c    | 235 ++++++++++++++++++++++++++++++++++++++++++++--------------------------------------
 drivers/media/pci/saa7164/saa7164-i2c.c   |   2 +-
 drivers/media/tuners/e4000.c              |   2 +-
 13 files changed, 231 insertions(+), 204 deletions(-)
