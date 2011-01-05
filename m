Return-path: <mchehab@gaivota>
Received: from bear.ext.ti.com ([192.94.94.41]:47146 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751675Ab1AEJ7n convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 5 Jan 2011 04:59:43 -0500
From: "Hadli, Manjunath" <manjunath.hadli@ti.com>
To: "'mats.randgaard@cisco.com'" <mats.randgaard@cisco.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Date: Wed, 5 Jan 2011 15:29:37 +0530
Subject: RE: [PATCH 0/5] DaVinci VPIF: Support for DV preset and DV timings. 
Message-ID: <B85A65D85D7EB246BE421B3FB0FBB5930247F9A81C@dbde02.ent.ti.com>
In-Reply-To: <1292512665-22538-1-git-send-email-mats.randgaard@cisco.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Tested for SD modes on TI Dm6467 EVM. DV_PRESTES testing done for THS8200 based EVM by Hans.

For the whole patch series:

Acked-by: Manjunath Hadli <Manjunath.hadli@ti.com>

Regards,
-Manju

-----Original Message-----
From: linux-media-owner@vger.kernel.org [mailto:linux-media-owner@vger.kernel.org] On Behalf Of mats.randgaard@cisco.com
Sent: Thursday, December 16, 2010 8:48 PM
To: linux-media@vger.kernel.org
Cc: mats.randgaard@cisco.com
Subject: [PATCH 0/5] DaVinci VPIF: Support for DV preset and DV timings. 

From: Mats Randgaard <mats.randgaard@cisco.com>

Support for DV preset and timings added to vpif_capture and vpif_display drivers.
Functions for debugging are added and the code is improved as well.

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
 drivers/media/video/davinci/vpif_display.c |  402 +++++++++++++++++++++++++---
 drivers/media/video/davinci/vpif_display.h |    2 +
 6 files changed, 886 insertions(+), 76 deletions(-)

--
To unsubscribe from this list: send the line "unsubscribe linux-media" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
