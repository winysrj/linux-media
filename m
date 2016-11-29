Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([80.229.237.210]:47973 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756691AbcK2UXo (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 29 Nov 2016 15:23:44 -0500
Date: Tue, 29 Nov 2016 20:23:41 +0000
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org
Subject: [GIT PULL FOR v4.10] lirc cdev fixes for 4.10
Message-ID: <20161129202341.GA13152@gofer.mess.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Just one fix to prevent double free or NULL deref in error path.

Thanks,
Sean

The following changes since commit a000f0d3995f622410d433a01e94fbfb45969e27:

  [media] vivid: Set color_enc on HSV formats (2016-11-29 12:12:32 -0200)

are available in the git repository at:

  git://linuxtv.org/syoung/media_tree.git for-v4.10

for you to fetch changes up to 90a0560777a72ea91b0fb1147264614dd236853c:

  [media] lirc: fix error paths in lirc_cdev_add() (2016-11-29 20:05:25 +0000)

----------------------------------------------------------------
Sean Young (1):
      [media] lirc: fix error paths in lirc_cdev_add()

 drivers/media/rc/lirc_dev.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)
