Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:36231 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752530AbdEQNmm (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 17 May 2017 09:42:42 -0400
Date: Wed, 17 May 2017 14:42:40 +0100
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org
Subject: [GIT PULL FOR v4.12] Hang in sir_ir
Message-ID: <20170517134240.GA29083@gofer.mess.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

0day found an issue which causes an infinite loop in the interrupt handler.

Thanks,

Sean

The following changes since commit 3622d3e77ecef090b5111e3c5423313f11711dfa:

  [media] ov2640: print error if devm_*_optional*() fails (2017-04-25 07:08:21 -0300)

are available in the git repository at:

  git://linuxtv.org/syoung/media_tree.git for-v4.12e

for you to fetch changes up to cb01c5786d5dca202d020b86fcdfda05bfd576e8:

  [media] sir_ir: infinite loop in interrupt handler (2017-05-17 14:37:07 +0100)

----------------------------------------------------------------
Sean Young (1):
      [media] sir_ir: infinite loop in interrupt handler

 drivers/media/rc/sir_ir.c | 6 ++++++
 1 file changed, 6 insertions(+)
