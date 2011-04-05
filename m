Return-path: <mchehab@pedra>
Received: from 1-1-12-13a.han.sth.bostream.se ([82.182.30.168]:57675 "EHLO
	palpatine.hardeman.nu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751883Ab1DEKIA (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 5 Apr 2011 06:08:00 -0400
Subject: [PATCH] rc-core: set mode and default keymap for winbond-cir
To: linux-media@vger.kernel.org
From: David =?utf-8?b?SMOkcmRlbWFu?= <david@hardeman.nu>
Cc: mchehab@redhat.com, skandalfo@gmail.com
Date: Tue, 05 Apr 2011 12:07:27 +0200
Message-ID: <20110405100727.5054.61603.stgit@felix.hardeman.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Not having the correct mode and a default keymap is not
very user-friendly (and rc-core won't allow it).

Signed-off-by: David Härdeman <david@hardeman.nu>
---
 drivers/media/rc/winbond-cir.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/media/rc/winbond-cir.c b/drivers/media/rc/winbond-cir.c
index 16f4178..b0a5fdc 100644
--- a/drivers/media/rc/winbond-cir.c
+++ b/drivers/media/rc/winbond-cir.c
@@ -790,6 +790,7 @@ wbcir_probe(struct pnp_dev *device, const struct pnp_device_id *dev_id)
 		goto exit_unregister_led;
 	}
 
+	data->dev->driver_type = RC_DRIVER_IR_RAW;
 	data->dev->driver_name = WBCIR_NAME;
 	data->dev->input_name = WBCIR_NAME;
 	data->dev->input_phys = "wbcir/cir0";
@@ -797,6 +798,7 @@ wbcir_probe(struct pnp_dev *device, const struct pnp_device_id *dev_id)
 	data->dev->input_id.vendor = PCI_VENDOR_ID_WINBOND;
 	data->dev->input_id.product = WBCIR_ID_FAMILY;
 	data->dev->input_id.version = WBCIR_ID_CHIP;
+	data->dev->map_name = RC_MAP_RC6_MCE;
 	data->dev->priv = data;
 	data->dev->dev.parent = &device->dev;
 

