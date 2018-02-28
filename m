Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:48567 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752453AbeB1M2y (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 28 Feb 2018 07:28:54 -0500
Date: Wed, 28 Feb 2018 12:28:53 +0000
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org
Subject: [GIT FIXES FOR 4.16] Remove LIRC_CAN_SEND_SCANCODE
Message-ID: <20180228122852.p2rk3z6bl4rjgxm3@gofer.mess.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Here is a fix to the documentation warning. LIRC_CAN_SEND_SCANCODE was
introduced in v4.16 to signify that kernel IR encoders could be used
for IR Tx; this lirc feature bit was found to trip up the lirc daemon,
so it was removed again but not from the lirc header.

See https://git.linuxtv.org/v4l-utils.git/tree/utils/ir-ctl/ir-ctl.c#n763
how IR Tx using scancodes can be done.

Thanks

Sean

The following changes since commit 7dbdd16a79a9d27d7dca0a49029fc8966dcfecc5:

  media: vb2: Makefile: place vb2-trace together with vb2-core (2018-02-26 11:39:04 -0500)

are available in the Git repository at:

  git://linuxtv.org/syoung/media_tree.git for-v4.16d

for you to fetch changes up to 1ddde79437bae627a7b0cadde6b88c544cbca285:

  media: rc: lirc does not use LIRC_CAN_SEND_SCANCODE feature (2018-02-28 12:07:48 +0000)

----------------------------------------------------------------
Sean Young (1):
      media: rc: lirc does not use LIRC_CAN_SEND_SCANCODE feature

 include/uapi/linux/lirc.h | 1 -
 1 file changed, 1 deletion(-)
