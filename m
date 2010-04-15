Return-path: <linux-media-owner@vger.kernel.org>
Received: from 1-1-12-13a.han.sth.bostream.se ([82.182.30.168]:52172 "EHLO
	palpatine.hardeman.nu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757791Ab0DOVqY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 15 Apr 2010 17:46:24 -0400
Subject: [PATCH 5/8] ir-core: convert mantis from ir-functions.c
To: mchehab@redhat.com
From: David =?utf-8?b?SMOkcmRlbWFu?= <david@hardeman.nu>
Cc: linux-media@vger.kernel.org, linux-input@vger.kernel.org
Date: Thu, 15 Apr 2010 23:46:20 +0200
Message-ID: <20100415214620.14142.19939.stgit@localhost.localdomain>
In-Reply-To: <20100415214520.14142.56114.stgit@localhost.localdomain>
References: <20100415214520.14142.56114.stgit@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Convert drivers/media/dvb/mantis/mantis_input.c to not use ir-functions.c
(The driver is anyway not complete enough to actually use the subsystem yet).

Signed-off-by: David Härdeman <david@hardeman.nu>
---
 0 files changed, 0 insertions(+), 0 deletions(-)

diff --git a/drivers/media/dvb/mantis/mantis_input.c b/drivers/media/dvb/mantis/mantis_input.c
index 3d4e466..a99489b 100644
--- a/drivers/media/dvb/mantis/mantis_input.c
+++ b/drivers/media/dvb/mantis/mantis_input.c
@@ -19,7 +19,7 @@
 */
 
 #include <linux/input.h>
-#include <media/ir-common.h>
+#include <media/ir-core.h>
 #include <linux/pci.h>
 
 #include "dmxdev.h"
@@ -104,7 +104,6 @@ EXPORT_SYMBOL_GPL(ir_mantis);
 int mantis_input_init(struct mantis_pci *mantis)
 {
 	struct input_dev *rc;
-	struct ir_input_state rc_state;
 	char name[80], dev[80];
 	int err;
 
@@ -120,8 +119,6 @@ int mantis_input_init(struct mantis_pci *mantis)
 	rc->name = name;
 	rc->phys = dev;
 
-	ir_input_init(rc, &rc_state, IR_TYPE_OTHER);
-
 	rc->id.bustype	= BUS_PCI;
 	rc->id.vendor	= mantis->vendor_id;
 	rc->id.product	= mantis->device_id;

