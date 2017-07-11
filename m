Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:47897 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755309AbdGKKhj (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 11 Jul 2017 06:37:39 -0400
Date: Tue, 11 Jul 2017 11:37:37 +0100
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org
Subject: [GIT FIXES FOR v4.13] RC fixes.
Message-ID: <20170711103737.o43k5lrfyv6toah7@gofer.mess.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Since v4.12 we set the LIRC_CAN_GET_REC_RESOLUTION lirc feature, and as
a result lircd uses the ioctl LIRC_GET_REC_RESOLUTION. That ioctl has
always been broken in rc-core.

I should have tested lirc decoding, I'll add it to my rc checklist. Sorry.

Thanks,

Sean

The following changes since commit 2748e76ddb2967c4030171342ebdd3faa6a5e8e8:

  media: staging: cxd2099: Activate cxd2099 buffer mode (2017-06-26 08:19:13 -0300)

are available in the git repository at:

  git://linuxtv.org/syoung/media_tree.git for-v4.13d

for you to fetch changes up to 5b96f8172791fbc8f511ea453b8828fe6f02f03c:

  [media] lirc: LIRC_GET_REC_RESOLUTION should return microseconds (2017-07-11 10:38:18 +0100)

----------------------------------------------------------------
Sean Young (1):
      [media] lirc: LIRC_GET_REC_RESOLUTION should return microseconds

 drivers/media/rc/ir-lirc-codec.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)
