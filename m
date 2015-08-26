Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:60097 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752860AbbHZPZo (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 26 Aug 2015 11:25:44 -0400
From: Javier Martinez Canillas <javier@osg.samsung.com>
To: linux-kernel@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-media@vger.kernel.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Shuah Khan <shuahkh@osg.samsung.com>,
	Javier Martinez Canillas <javier@osg.samsung.com>
Subject: [PATCH 0/2] Patches to test MC next gen patches in OMAP3 ISP
Date: Wed, 26 Aug 2015 17:25:17 +0200
Message-Id: <1440602719-12500-1-git-send-email-javier@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

This series contains two patches that are needed to test the
"[PATCH v7 00/44] MC next generation patches" [0] in a OMAP3
board by using the omap3isp driver.

I found two issues during testing, the first one is that the
media_entity_cleanup() function tries to empty the pad links
list but the list is initialized when a entity is registered
causing a NULL pointer deference error.

The second issue is that the omap3isp driver creates links
when the entities are initialized but before the media device
is registered causing a NULL pointer deference as well.

Patch 1/1 fixes the first issue by removing the links list
empty logic from media_entity_cleanup() since that is made
in media_device_unregister_entity() and 2/2 fixes the second
issue by separating the entities initialization from the pads
links creation after the entities have been registered.

Patch 1/1 was posted before [1] but forgot to add the [media]
prefix in the subject line so I'm including in this set again.
Sorry about that.

The testing was made on an OMAP3 DM3735 IGEPv2 board and test
that the media-ctl -p prints out the topology. More extensive
testing will be made but I wanted to share these patches in
order to make easier for other people that were looking at it.

[0]: https://www.mail-archive.com/linux-media@vger.kernel.org/msg91528.html
[1]: https://lkml.org/lkml/2015/8/24/649

Best regards,
Javier


Javier Martinez Canillas (2):
  [media] media: don't try to empty links list in media_entity_cleanup()
  [media] omap3isp: separate links creation from entities init

 drivers/media/media-entity.c                 |   7 --
 drivers/media/platform/omap3isp/isp.c        | 152 +++++++++++++++++----------
 drivers/media/platform/omap3isp/ispccdc.c    |  22 ++--
 drivers/media/platform/omap3isp/ispccdc.h    |   1 +
 drivers/media/platform/omap3isp/ispccp2.c    |  22 ++--
 drivers/media/platform/omap3isp/ispccp2.h    |   1 +
 drivers/media/platform/omap3isp/ispcsi2.c    |  22 ++--
 drivers/media/platform/omap3isp/ispcsi2.h    |   1 +
 drivers/media/platform/omap3isp/isppreview.c |  33 +++---
 drivers/media/platform/omap3isp/isppreview.h |   1 +
 drivers/media/platform/omap3isp/ispresizer.c |  33 +++---
 drivers/media/platform/omap3isp/ispresizer.h |   1 +
 12 files changed, 185 insertions(+), 111 deletions(-)

-- 
2.4.3

