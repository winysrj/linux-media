Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:45299 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751051AbbKIV0u (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 9 Nov 2015 16:26:50 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: prabhakar.csengg@gmail.com
Subject: [GIT PULL FOR v4.5] Davinci staging fixes
Date: Mon, 09 Nov 2015 23:27:02 +0200
Message-ID: <1523162.9GiZlJHs21@avalon>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

I've collected the pending Davinci staging fixes from patchwork and prepared a 
branch for you.

Prabhakar, is that fine with you ? Do you still maintain the driver ? If so, 
do you expect patches to be picked up when you ack them, or can you collect 
them in a branch somewhere and send a pull request ?

The following changes since commit 79f5b6ae960d380c829fb67d5dadcd1d025d2775:

  [media] c8sectpfe: Remove select on CONFIG_FW_LOADER_USER_HELPER_FALLBACK 
(2015-10-20 16:02:41 -0200)

are available in the git repository at:

  git://linuxtv.org/pinchartl/media.git davinci

for you to fetch changes up to b542f513822fd11460ef781742d6c0446b40eeb8:

  staging: media: davinci_vpfe: fix ipipe_mode type (2015-11-09 23:07:53 
+0200)

----------------------------------------------------------------
Andrzej Hajda (1):
      staging: media: davinci_vpfe: fix ipipe_mode type

Arnd Bergmann (1):
      staging/davinci/vpfe/dm365: add missing dependencies

Julia Lawall (1):
      drivers/staging/media/davinci_vpfe/vpfe_mc_capture.c: use correct 
structure type name in sizeof

Junsu Shin (1):
      staging: media: davinci_vpfe: Fix over 80 characters coding style issue

Nicholas Mc Guire (1):
      staging: media: davinci_vpfe: drop condition with no effect

 drivers/staging/media/davinci_vpfe/Kconfig           | 2 ++
 drivers/staging/media/davinci_vpfe/dm365_ipipe.c     | 5 +++--
 drivers/staging/media/davinci_vpfe/dm365_ipipe_hw.c  | 2 +-
 drivers/staging/media/davinci_vpfe/dm365_resizer.c   | 7 +------
 drivers/staging/media/davinci_vpfe/vpfe_mc_capture.c | 2 +-
 5 files changed, 8 insertions(+), 10 deletions(-)

-- 
Regards,

Laurent Pinchart

