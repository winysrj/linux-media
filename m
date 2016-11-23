Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:55080 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965375AbcKWPkg (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 23 Nov 2016 10:40:36 -0500
Received: from avalon.localnet (dfj612ybrt5fhg77mgycy-3.rev.dnainternet.fi [IPv6:2001:14ba:21f5:5b00:2e86:4862:ef6a:2804])
        by galahad.ideasonboard.com (Postfix) with ESMTPSA id 808E72005A
        for <linux-media@vger.kernel.org>; Wed, 23 Nov 2016 16:40:30 +0100 (CET)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [GIT PULL FOR v4.10] Davinci staging updates
Date: Wed, 23 Nov 2016 17:40:52 +0200
Message-ID: <3704737.qNc3EHZKID@avalon>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

The following changes since commit 30f88a42b65858d777b8dfb40bb222fa31d5f0d9:

  [media] staging: lirc: Improvement in code readability (2016-11-22 12:21:25 
-0200)

are available in the git repository at:

  git://linuxtv.org/pinchartl/media.git davinci

for you to fetch changes up to 110134c57b54a8fc2e6400703ae35364c4c8df3d:

  staging: media: davinci_vpfe: unlock on error in vpfe_reqbufs() (2016-11-22 
23:40:12 +0200)

----------------------------------------------------------------
Arnd Bergmann (2):
      staging: media: davinci_vfpe: allow modular build
      staging: media: davinci_vpfe: fix W=1 build warnings

Dan Carpenter (1):
      staging: media: davinci_vpfe: unlock on error in vpfe_reqbufs()

Leo Sperling (1):
      staging: media: davinci_vpfe: Fix indentation issue in vpfe_video.c

Manuel Rodriguez (1):
      staging: media: davinci_vpfe: Fix spelling error on a comment

Saatvik Arya (1):
      staging: media: davinci_vpfe: dm365_resizer: Fix some spelling mistakes

 drivers/staging/media/davinci_vpfe/Makefile        |  4 +++-
 drivers/staging/media/davinci_vpfe/dm365_resizer.c | 31 +++++++++++----------
 drivers/staging/media/davinci_vpfe/dm365_resizer.h |  2 +-
 drivers/staging/media/davinci_vpfe/vpfe_video.c    |  8 ++++----
 4 files changed, 23 insertions(+), 22 deletions(-)

-- 
Regards,

Laurent Pinchart

