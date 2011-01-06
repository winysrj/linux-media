Return-path: <mchehab@gaivota>
Received: from arroyo.ext.ti.com ([192.94.94.40]:45379 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753088Ab1AFPPg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 6 Jan 2011 10:15:36 -0500
From: "Nori, Sekhar" <nsekhar@ti.com>
To: "mchehab@redhat.com" <mchehab@redhat.com>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Date: Thu, 6 Jan 2011 20:45:16 +0530
Subject: [GIT PATCHES FOR 2.6.38] DaVinci VPIF: Support for DV preset and DV
 timings and core-assisted locking (v2)
Message-ID: <B85A65D85D7EB246BE421B3FB0FBB5930248201AB0@dbde02.ent.ti.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Hi Mauro,

Here is an updated pull request for DV preset and DV timing
support on VPIF as well as core-assisted locking support.

All the changes are local to DaVinci VPIF driver. The patches
have been reviewed on linux-media and acked by TI developers.

Thanks,
Sekhar

The following changes since commit aeb13b434d0953050306435cd3134d65547dbcf4:
  Mauro Carvalho Chehab (1):
        cx25821: Fix compilation breakage due to BKL dependency

are available in the git repository at:

  git://arago-project.org/git/projects/linux-davinci.git for-mauro

Hans Verkuil (2):
      davinci: convert vpif_capture to core-assisted locking
      davinci: convert vpif_display to core-assisted locking

Mats Randgaard (5):
      vpif_cap/disp: Add debug functionality
      vpif: Consolidate formats from capture and display
      vpif_cap/disp: Add support for DV presets
      vpif_cap/disp: Added support for DV timings
      vpif_cap/disp: Cleanup, improved comments

 drivers/media/video/davinci/vpif.c         |  177 +++++++++++
 drivers/media/video/davinci/vpif.h         |   18 +-
 drivers/media/video/davinci/vpif_capture.c |  451 ++++++++++++++++++++------
 drivers/media/video/davinci/vpif_capture.h |    2 +
 drivers/media/video/davinci/vpif_display.c |  474 +++++++++++++++++++++-------
 drivers/media/video/davinci/vpif_display.h |    2 +
 6 files changed, 907 insertions(+), 217 deletions(-)
