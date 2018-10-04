Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:53597 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727415AbeJDXXn (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 4 Oct 2018 19:23:43 -0400
Date: Thu, 4 Oct 2018 17:29:41 +0100
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org
Subject: [GIT PULL FOR v4.20] Additional RC fixes
Message-ID: <20181004162941.stweqx5vszghpapk@gofer.mess.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Here are some additional fixes for v4.20. By enabling the rel/keys bits
when the RC input device is registered, we can re-use the same input
device for imon/mce_kbd protocol mouse movements and keys.

Note that all these patches depend on each other; the second depends on the
first, and the third depends on the first two.

Tested with real imon and mce keyboard.

Thanks,

Sean

The following changes since commit 5f108da55c6a928d0305163731bca2ac94ab233b:

  media: smiapp: Remove unused loop (2018-10-03 11:59:10 -0400)

are available in the Git repository at:

  git://linuxtv.org/syoung/media_tree.git for-v4.20b

for you to fetch changes up to a810925a2795daa204f1ff2e659e026acc4459b5:

  media: rc: mce_kbd: input events via rc-core's input device (2018-10-04 15:05:37 +0100)

----------------------------------------------------------------
Sean Young (3):
      media: rc: some events are dropped by userspace
      media: rc: imon: report mouse events using rc-core's input device
      media: rc: mce_kbd: input events via rc-core's input device

 drivers/media/rc/ir-imon-decoder.c    | 62 ++--------------------------
 drivers/media/rc/ir-mce_kbd-decoder.c | 77 +++++++----------------------------
 drivers/media/rc/rc-core-priv.h       |  5 ---
 drivers/media/rc/rc-main.c            | 20 ++++-----
 4 files changed, 26 insertions(+), 138 deletions(-)
