Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:37611 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751247AbdFFVWq (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 6 Jun 2017 17:22:46 -0400
Date: Tue, 6 Jun 2017 22:22:44 +0100
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org
Subject: [GIT PULL FOR v4.13] Various RC fixes
Message-ID: <20170606212244.GA843@gofer.mess.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Some minor fixes that just missed the first pull request, that would be nice
to have in v4.13.

Thank you

Sean

The following changes since commit 9e9e6a78143bbb6cb9cffd29ab48d5f32def4e20:

  [media] Doc*/media/uapi: fix control name (2017-06-06 16:49:46 -0300)

are available in the git repository at:

  git://linuxtv.org/syoung/media_tree.git for-v4.13b

for you to fetch changes up to 8e35a2305e02ee0c8cb3bf971acab9fbe708e384:

  [media] ir-spi: Fix issues with lirc API (2017-06-06 20:55:36 +0100)

----------------------------------------------------------------
Anton Blanchard (1):
      [media] ir-spi: Fix issues with lirc API

Johan Hovold (2):
      [media] mceusb: fix memory leaks in error path
      [media] mceusb: drop redundant urb reinitialisation

Sean Young (1):
      [media] sir_ir: annotate hardware config module parameters

 drivers/media/rc/ir-spi.c | 9 ++++++---
 drivers/media/rc/mceusb.c | 5 ++---
 drivers/media/rc/sir_ir.c | 4 ++--
 3 files changed, 10 insertions(+), 8 deletions(-)
