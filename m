Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:56317 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754121AbeAGRD0 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 7 Jan 2018 12:03:26 -0500
Date: Sun, 7 Jan 2018 17:03:24 +0000
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org
Subject: [GIT PULL FOR v4.16] RC fixes
Message-ID: <20180107170324.x53wxu4zg6ymz75g@gofer.mess.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

I've been testing the lirc changes on various distributions and versions;
there were some regressions.

Thanks,

Sean

The following changes since commit 6f0e5fd39143a59c22d60e7befc4f33f22aeed2f:

  media: vb2: add a new warning about pending buffers (2018-01-03 05:30:35 -0500)

are available in the Git repository at:

  git://linuxtv.org/syoung/media_tree.git for-v4.16c

for you to fetch changes up to 6dc84d93e557c787ae74a808d93a8493f85a7800:

  media: rc: do not remove first bit if leader pulse is present (2018-01-05 15:13:15 +0000)

----------------------------------------------------------------
Colin Ian King (1):
      media: lirc: don't kfree the uninitialized pointer txbuf

Sean Young (5):
      media: lirc: add module alias for lirc_dev
      media: lirc: lirc daemon fails to detect raw IR device
      media: lirc: lirc mode ioctls deal with current mode
      media: rc: clean up leader pulse/space for manchester encoding
      media: rc: do not remove first bit if leader pulse is present

 Documentation/media/uapi/rc/lirc-get-features.rst  | 24 ++++++-------
 Documentation/media/uapi/rc/lirc-get-rec-mode.rst  | 42 ++++++++++++++++------
 Documentation/media/uapi/rc/lirc-get-send-mode.rst | 38 +++++++++++++++-----
 drivers/media/rc/ir-mce_kbd-decoder.c              |  6 ++--
 drivers/media/rc/ir-rc5-decoder.c                  | 22 ++++++------
 drivers/media/rc/ir-rc6-decoder.c                  | 31 +++++-----------
 drivers/media/rc/lirc_dev.c                        | 11 +++---
 drivers/media/rc/rc-core-priv.h                    | 10 +++---
 drivers/media/rc/rc-ir-raw.c                       | 13 +++----
 9 files changed, 112 insertions(+), 85 deletions(-)
