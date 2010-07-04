Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:23151 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756662Ab0GDBsK (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 3 Jul 2010 21:48:10 -0400
Date: Sat, 3 Jul 2010 21:48:04 -0400
From: Jarod Wilson <jarod@redhat.com>
To: linux-media@vger.kernel.org
Cc: Pieter Hoekstra <pieter.hoekstra@5137.org>
Subject: [PATCH] IR/imon: auto-configure another 0xffdc device variant
Message-ID: <20100704014804.GE17081@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Per Pieter Hoekstra:

I have a Antec Fusion with a iMON Lcd and I get the following error:
imon 6-1:1.0: Unknown 0xffdc device, defaulting to VFD and iMON IR (id
0x9e)

The driver is functional if I load it like this: (I do not use a remote for it)
modprobe imon display_type=1 (On Mythbuntu 10.04/2.6.32)

This device is a lcd-type with support for a MCE remote. Looking at
the source code, this device (0x9e) is the same as id 0x9f.

Signed-off-by: Jarod Wilson <jarod@redhat.com>
---
 drivers/media/IR/imon.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/media/IR/imon.c b/drivers/media/IR/imon.c
index 4b1fe9b..71eeb85 100644
--- a/drivers/media/IR/imon.c
+++ b/drivers/media/IR/imon.c
@@ -2059,6 +2059,7 @@ static void imon_get_ffdc_type(struct imon_context *ictx)
 		detected_display_type = IMON_DISPLAY_TYPE_VFD;
 		break;
 	/* iMON LCD, MCE IR */
+	case 0x9e:
 	case 0x9f:
 		dev_info(ictx->dev, "0xffdc iMON LCD, MCE IR");
 		detected_display_type = IMON_DISPLAY_TYPE_LCD;
-- 
1.7.1

-- 
Jarod Wilson
jarod@redhat.com

