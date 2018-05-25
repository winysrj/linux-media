Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:53201 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S965729AbeEYPoR (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 25 May 2018 11:44:17 -0400
Date: Fri, 25 May 2018 16:44:15 +0100
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org
Subject: [GIT PULL FOR v4.18] RC fixes
Message-ID: <20180525154415.6ncwvvcqpc5mcxrs@gofer.mess.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Fixes for a regression in v4.16, and broken open/close handling in the
nuvoton driver.

Thanks

Sean

The following changes since commit 8ed8bba70b4355b1ba029b151ade84475dd12991:

  media: imx274: remove non-indexed pointers from mode_table (2018-05-17 06:22:08 -0400)

are available in the Git repository at:

  git://linuxtv.org/syoung/media_tree.git for-v4.18d

for you to fetch changes up to 3b65073f8d650f2749bdac48153a126c568352b9:

  media: rc: ensure input/lirc device can be opened after register (2018-05-25 16:32:15 +0100)

----------------------------------------------------------------
Michał Winiarski (3):
      media: rc: nuvoton: Tweak the interrupt enabling dance
      media: rc: nuvoton: Keep track of users on CIR enable/disable
      media: rc: nuvoton: Keep device enabled during reg init

Sean Young (1):
      media: rc: ensure input/lirc device can be opened after register

 drivers/media/rc/nuvoton-cir.c | 89 +++++++++++++++++++-----------------------
 drivers/media/rc/rc-main.c     |  4 +-
 2 files changed, 43 insertions(+), 50 deletions(-)
