Return-path: <linux-media-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:58137 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751068Ab1ISFfj (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 19 Sep 2011 01:35:39 -0400
Received: from dbdp20.itg.ti.com ([172.24.170.38])
	by comal.ext.ti.com (8.13.7/8.13.7) with ESMTP id p8J5ZZIA030237
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Mon, 19 Sep 2011 00:35:38 -0500
From: Manjunath Hadli <manjunath.hadli@ti.com>
To: LMML <linux-media@vger.kernel.org>
CC: dlos <davinci-linux-open-source@linux.davincidsp.com>,
	Manjunath Hadli <manjunath.hadli@ti.com>
Subject: [PATCH RESEND 0/4] davinci vpbe: enable DM365 v4l2 display driver
Date: Mon, 19 Sep 2011 11:05:25 +0530
Message-ID: <1316410529-14744-1-git-send-email-manjunath.hadli@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The patchset adds incremental changes necessary to enable dm365
v4l2 display driver, which includes vpbe display driver changes,
osd specific changes and venc changes. The changes are incremental
in nature,addind a few HD modes, and taking care of register level
changes.

The patch set does not include THS7303 amplifier driver which is planned
to be sent seperately.


Manjunath Hadli (4):
  davinci vpbe: remove unused macro.
  davinci vpbe: add dm365 VPBE display driver changes
  davinci vpbe: add dm365 and dm355 specific OSD changes
  davinci vpbe: add VENC block changes to enable dm365 and dm355

 drivers/media/video/davinci/vpbe.c         |   55 +++-
 drivers/media/video/davinci/vpbe_display.c |    1 -
 drivers/media/video/davinci/vpbe_osd.c     |  474 +++++++++++++++++++++++++---
 drivers/media/video/davinci/vpbe_venc.c    |  205 +++++++++++--
 include/media/davinci/vpbe.h               |   16 +
 include/media/davinci/vpbe_venc.h          |    4 +
 6 files changed, 686 insertions(+), 69 deletions(-)

