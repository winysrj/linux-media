Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([80.229.237.210]:46659 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751695AbdBOQHB (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 15 Feb 2017 11:07:01 -0500
Date: Wed, 15 Feb 2017 16:06:58 +0000
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org
Cc: Heiner Kallweit <hkallweit1@gmail.com>
Subject: [GIT PULL FOR v4.11] RC deadlocks
Message-ID: <20170215160658.GA6704@gofer.mess.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Two deadlocks which would be nice to have fixed for v4.11. Both were
introduced by the wakeup changes; I guess that teaches me for working
without lockdep enabled.

Thanks,
Sean

The following changes since commit 9eeb0ed0f30938f31a3d9135a88b9502192c18dd:

  [media] mtk-vcodec: fix build warnings without DEBUG (2017-02-08 12:08:20 -0200)

are available in the git repository at:

  git://linuxtv.org/syoung/media_tree.git for-v4.11d

for you to fetch changes up to 79522eaacc1bc691b419a1c9006da1e494bba5c6:

  [media] rc: nuvoton: fix deadlock in nvt_write_wakeup_codes (2017-02-13 13:21:44 +0000)

----------------------------------------------------------------
Heiner Kallweit (1):
      [media] rc: nuvoton: fix deadlock in nvt_write_wakeup_codes

Sean Young (1):
      [media] lirc: fix dead lock between open and wakeup_filter

 drivers/media/rc/lirc_dev.c    | 4 ++--
 drivers/media/rc/nuvoton-cir.c | 5 +++--
 2 files changed, 5 insertions(+), 4 deletions(-)
