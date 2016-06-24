Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:35490 "EHLO
	mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751229AbcFXFkX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 24 Jun 2016 01:40:23 -0400
Received: by mail-wm0-f67.google.com with SMTP id a66so2181239wme.2
        for <linux-media@vger.kernel.org>; Thu, 23 Jun 2016 22:40:23 -0700 (PDT)
From: Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH 5/9] media: rc: nuvoton: remove unneeded code in
 nvt_process_rx_ir_data
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: linux-media@vger.kernel.org
Message-ID: <6ade811b-bf54-eeef-e83b-4dead2296200@gmail.com>
Date: Fri, 24 Jun 2016 07:39:39 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The definition of rawir includes the initialization already.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/media/rc/nuvoton-cir.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/media/rc/nuvoton-cir.c b/drivers/media/rc/nuvoton-cir.c
index 1d99f10..9d9717d 100644
--- a/drivers/media/rc/nuvoton-cir.c
+++ b/drivers/media/rc/nuvoton-cir.c
@@ -757,8 +757,6 @@ static void nvt_process_rx_ir_data(struct nvt_dev *nvt)
 
 	nvt_dbg_verbose("Processing buffer of len %d", nvt->pkts);
 
-	init_ir_raw_event(&rawir);
-
 	for (i = 0; i < nvt->pkts; i++) {
 		sample = nvt->buf[i];
 
-- 
2.9.0

