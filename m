Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:45653 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751069AbeCRLFR (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 18 Mar 2018 07:05:17 -0400
Date: Sun, 18 Mar 2018 11:05:16 +0000
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org
Subject: [GIT PULL FOR v4.17] RC meson-ir and mceusb fixes
Message-ID: <20180318110515.2htsallnducpq76l@gofer.mess.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Just two fixes for meson-ir timeout handling, and teaching mceusb how
to do learning mode.

Thanks,

Sean

The following changes since commit 3f127ce11353fd1071cae9b65bc13add6aec6b90:

  media: em28xx-cards: fix em28xx_duplicate_dev() (2018-03-08 06:06:51 -0500)

are available in the Git repository at:

  git://linuxtv.org/syoung/media_tree.git for-v4.17d

for you to fetch changes up to fe0ed203181e0cd62d1340bc1165e76534c4dddc:

  media: rc: mceusb: pid 0x0609 vid 0x031d does not under report carrier cycles (2018-03-18 10:48:49 +0000)

----------------------------------------------------------------
A Sun (1):
      media: mceusb: add IR learning support features (IR carrier frequency measurement and wide-band/short-range receiver)

Sean Young (3):
      media: rc: meson-ir: add timeout on idle
      media: rc: meson-ir: lower timeout and make configurable
      media: rc: mceusb: pid 0x0609 vid 0x031d does not under report carrier cycles

 drivers/media/rc/mceusb.c    | 160 +++++++++++++++++++++++++++++++++++++++----
 drivers/media/rc/meson-ir.c  |   7 +-
 drivers/media/rc/rc-ir-raw.c |  30 +++++++-
 include/media/rc-core.h      |   4 +-
 4 files changed, 181 insertions(+), 20 deletions(-)
