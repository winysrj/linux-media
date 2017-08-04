Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:59147 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752078AbdHDPIz (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 4 Aug 2017 11:08:55 -0400
Date: Fri, 4 Aug 2017 16:08:54 +0100
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org
Subject: [GIT FIXES FOR v4.13] RC use-after-free fix
Message-ID: <20170804150854.geuyqr3uq5inorpf@gofer.mess.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

While testing with kasan I discovered a regression in v4.13. The change
is a simple revert.

Thanks
Sean


The following changes since commit da48c948c263c9d87dfc64566b3373a858cc8aa2:

  media: fix warning on v4l2_subdev_call() result interpreted as bool (2017-07-26 13:43:17 -0400)

are available in the git repository at:

  git://linuxtv.org/syoung/media_tree.git for-v4.13e

for you to fetch changes up to db50cbd947104f14e06ec107c098800b7442af3e:

  Revert "[media] lirc_dev: remove superfluous get/put_device() calls" (2017-08-04 15:48:46 +0100)

----------------------------------------------------------------
Sean Young (1):
      Revert "[media] lirc_dev: remove superfluous get/put_device() calls"

 drivers/media/rc/lirc_dev.c | 4 ++++
 1 file changed, 4 insertions(+)
