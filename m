Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:57255 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726646AbeG2Uja (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 29 Jul 2018 16:39:30 -0400
Date: Sun, 29 Jul 2018 20:08:02 +0100
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org
Subject: [GIT FIXES FOR v4.18] out of bounds memory read
Message-ID: <20180729190802.vcjfbjoixwhgrmgp@gofer.mess.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Please pull this fix for v4.18, if possible.

Thanks,

Sean

The following changes since commit 92cab799bbc6fa1fca84bd1692285a5f926c17e9:

  media: bpf: ensure bpf program is freed on detach (2018-07-26 08:39:18 -0400)

are available in the Git repository at:

  git://linuxtv.org/syoung/media_tree.git for-v4.18g

for you to fetch changes up to 0922465cba37c45c1db0786b7fa1ea822bd647a5:

  media: rc: read out of bounds if bpf reports high protocol number (2018-07-29 16:31:45 +0100)

----------------------------------------------------------------
Sean Young (1):
      media: rc: read out of bounds if bpf reports high protocol number

 drivers/media/rc/rc-main.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)
