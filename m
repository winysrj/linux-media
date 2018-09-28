Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtprelay0123.hostedemail.com ([216.40.44.123]:54465 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725985AbeI2EXI (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 29 Sep 2018 00:23:08 -0400
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Eugen Hristev <eugen.hristev@microchip.com>,
        linux-media@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Josh Wu <josh.wu@atmel.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Subject: Bad MAINTAINERS pattern in section 'MICROCHIP ISI DRIVER'
Date: Fri, 28 Sep 2018 14:57:21 -0700
Message-Id: <20180928215721.30421-1-joe@perches.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Please fix this defect appropriately.

linux-next MAINTAINERS section:

	9550	MICROCHIP ISI DRIVER
	9551	M:	Eugen Hristev <eugen.hristev@microchip.com>
	9552	L:	linux-media@vger.kernel.org
	9553	S:	Supported
	9554	F:	drivers/media/platform/atmel/atmel-isi.c
-->	9555	F:	include/media/atmel-isi.h

Commit that introduced this:

commit 92de0f8845adcd55f37f581ddc6c09f1127e217a
 Author: Nicolas Ferre <nicolas.ferre@microchip.com>
 Date:   Wed Aug 29 16:31:46 2018 +0200
 
     MAINTAINERS: move former ATMEL entries to proper MICROCHIP location
     
     Standardize the Microchip / Atmel entries with the same form and move them
     so that they are all located at the same place, under the newer MICROCHIP
     banner.
     Only modifications to the titles of the entries are done in this patch.
     
     Signed-off-by: Nicolas Ferre <nicolas.ferre@microchip.com>
     Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
 
  MAINTAINERS | 154 ++++++++++++++++++++++++++++++------------------------------
  1 file changed, 77 insertions(+), 77 deletions(-)

Last commit with include/media/atmel-isi.h

commit 40a78f36fc92bb156872468fb829984a9d946df7
Author: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Date:   Sat Aug 1 06:22:54 2015 -0300

    [media] v4l: atmel-isi: Remove support for platform data
    
    All in-tree users have migrated to DT, remove support for platform data.
    
    Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
    [josh.wu@atmel.com: squash the commit to remove the unused variable: dev]
    Signed-off-by: Josh Wu <josh.wu@atmel.com>
    Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
    
    Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

 drivers/media/platform/soc_camera/atmel-isi.c      | 24 ++++++----------------
 .../media/platform/soc_camera}/atmel-isi.h         |  0
 2 files changed, 6 insertions(+), 18 deletions(-)
