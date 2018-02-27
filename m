Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:52305 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752602AbeB0KFR (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 27 Feb 2018 05:05:17 -0500
Date: Tue, 27 Feb 2018 10:05:15 +0000
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org
Subject: [GIT PULL FOR v4.17] Minor RC fixes
Message-ID: <20180227100514.7n5x6t3hcdug7zkz@gofer.mess.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Just two minor changes for RC.

Thanks,
Sean

The following changes since commit 15ea2df9143729a2b722d4ca2b52cfa14a819d8e:

  media: ov2685: mark PM functions as __maybe_unused (2018-02-26 10:38:56 -0500)

are available in the Git repository at:

  git://linuxtv.org/syoung/media_tree.git for-v4.17b

for you to fetch changes up to 66b3840b6bdbbef998741122bd19e6a54c32793d:

  media: rc: fix race condition in ir_raw_event_store_edge() handling (2018-02-27 09:00:21 +0000)

----------------------------------------------------------------
Sean Young (2):
      media: rc: no need to announce major number
      media: rc: fix race condition in ir_raw_event_store_edge() handling

 Documentation/media/uapi/rc/lirc-dev-intro.rst |  1 -
 drivers/media/rc/lirc_dev.c                    |  4 ++--
 drivers/media/rc/rc-core-priv.h                |  5 +++--
 drivers/media/rc/rc-ir-raw.c                   | 24 +++++++++++++++++++++---
 4 files changed, 26 insertions(+), 8 deletions(-)
