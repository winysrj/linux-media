Return-path: <linux-media-owner@vger.kernel.org>
Received: from 1-1-12-13a.han.sth.bostream.se ([82.182.30.168]:51229 "EHLO
	palpatine.hardeman.nu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753833Ab0FGTcV (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 7 Jun 2010 15:32:21 -0400
Subject: [PATCH 1/8] ir-core: convert mantis to not use ir-functions.c
To: mchehab@redhat.com
From: David =?utf-8?b?SMOkcmRlbWFu?= <david@hardeman.nu>
Cc: linux-media@vger.kernel.org
Date: Mon, 07 Jun 2010 21:32:18 +0200
Message-ID: <20100607193218.21236.78478.stgit@localhost.localdomain>
In-Reply-To: <20100607192830.21236.69701.stgit@localhost.localdomain>
References: <20100607192830.21236.69701.stgit@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Convert drivers/media/dvb/mantis/mantis_input.c to not use ir-functions.c

Signed-off-by: David Härdeman <david@hardeman.nu>
---
 drivers/media/dvb/mantis/mantis_input.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

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

