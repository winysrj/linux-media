Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:46293 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753117Ab2E0Q4z (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 27 May 2012 12:56:55 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [RFC PATCH 0/3] Improve Kconfig selection for media devices
Date: Sun, 27 May 2012 13:56:40 -0300
Message-Id: <1338137803-12231-1-git-send-email-mchehab@redhat.com>
In-Reply-To: <4FC24E34.3000406@redhat.com>
References: <4FC24E34.3000406@redhat.com>
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The Kconfig building system is improperly selecting some drivers,
like analog TV tuners even when this is not required.

Rearrange the Kconfig in a way to prevent that.

Mauro Carvalho Chehab (3):
  media: reorganize the main Kconfig items
  media: Remove VIDEO_MEDIA Kconfig option
  media: only show V4L devices based on device type selection

 drivers/media/Kconfig               |  114 +++++++++++++++++++++++------------
 drivers/media/common/tuners/Kconfig |   64 ++++++++++----------
 drivers/media/dvb/frontends/Kconfig |    1 +
 drivers/media/radio/Kconfig         |    1 +
 drivers/media/rc/Kconfig            |   29 ++++-----
 drivers/media/video/Kconfig         |   76 +++++++++++++++++------
 drivers/media/video/m5mols/Kconfig  |    1 +
 drivers/media/video/pvrusb2/Kconfig |    1 -
 drivers/media/video/smiapp/Kconfig  |    1 +
 9 files changed, 181 insertions(+), 107 deletions(-)

-- 
1.7.8

