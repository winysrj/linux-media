Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:1810 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753515Ab2E1MSD (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 28 May 2012 08:18:03 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	stefanr@s5r6.in-berlin.de
Subject: [RFC PATCHv2 0/3] Improve Kconfig selection for media devices
Date: Mon, 28 May 2012 09:17:46 -0300
Message-Id: <1338207469-32606-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The Kconfig building system is improperly selecting some drivers,
like analog TV tuners even when this is not required.

Rearrange the Kconfig in a way to prevent that.

v2: Some fixups at the first patch (typos, renames). Other patches
    got rebased due to that.

Mauro Carvalho Chehab (3):
  [media] media: reorganize the main Kconfig items
  [media] media: Remove VIDEO_MEDIA Kconfig option
  [media] media: only show V4L devices based on device type selection

 drivers/media/Kconfig               |  113 +++++++++++++++++++++++------------
 drivers/media/common/tuners/Kconfig |   64 ++++++++++----------
 drivers/media/dvb/frontends/Kconfig |    1 +
 drivers/media/radio/Kconfig         |    1 +
 drivers/media/rc/Kconfig            |   29 ++++-----
 drivers/media/video/Kconfig         |   76 +++++++++++++++++------
 drivers/media/video/m5mols/Kconfig  |    1 +
 drivers/media/video/pvrusb2/Kconfig |    1 -
 drivers/media/video/smiapp/Kconfig  |    1 +
 9 files changed, 180 insertions(+), 107 deletions(-)

-- 
1.7.8

