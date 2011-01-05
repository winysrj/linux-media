Return-path: <mchehab@gaivota>
Received: from bear.ext.ti.com ([192.94.94.41]:47988 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751507Ab1AEKRj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 5 Jan 2011 05:17:39 -0500
From: "Nori, Sekhar" <nsekhar@ti.com>
To: "mchehab@redhat.com" <mchehab@redhat.com>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Date: Wed, 5 Jan 2011 15:47:22 +0530
Subject: [GIT PATCHES FOR 2.6.38] DaVinci VPIF: Support for DV preset and DV
 timings
Message-ID: <B85A65D85D7EB246BE421B3FB0FBB593024816E1E6@dbde02.ent.ti.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Hi Mauro,

Can you please pull from the following tree for DV preset
and DV timings support for DaVinci VPIF.

Sorry for the late request, but we were waiting for an ack
from Manju. The patches themselves have been reviewed on the
list quite a while ago. The patches affect only DaVinci VPIF
video and have been verified by Manju to not have broken anything.

Thanks,
Sekhar

The following changes since commit 187134a5875df20356f4dca075db29f294115a47:
  David Henningsson (1):
        [media] DVB: IR support for TechnoTrend CT-3650

are available in the git repository at:

  git://arago-project.org/git/projects/linux-davinci.git for-mauro

Mats Randgaard (5):
      vpif_cap/disp: Add debug functionality
      vpif: Consolidate formats from capture and display
      vpif_cap/disp: Add support for DV presets
      vpif_cap/disp: Added support for DV timings
      vpif_cap/disp: Cleanup, improved comments

 drivers/media/video/davinci/vpif.c         |  177 ++++++++++++
 drivers/media/video/davinci/vpif.h         |   18 +-
 drivers/media/video/davinci/vpif_capture.c |  361 +++++++++++++++++++++++--
 drivers/media/video/davinci/vpif_capture.h |    2 +
 drivers/media/video/davinci/vpif_display.c |  400 +++++++++++++++++++++++++---
 drivers/media/video/davinci/vpif_display.h |    2 +
 6 files changed, 884 insertions(+), 76 deletions(-)
