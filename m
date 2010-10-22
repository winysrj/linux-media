Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:6320 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756632Ab0JVN1t (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 22 Oct 2010 09:27:49 -0400
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o9MDRnOS027668
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Fri, 22 Oct 2010 09:27:49 -0400
Date: Fri, 22 Oct 2010 11:25:28 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: jarod@redhat.com
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 3/3] mceusb: Allow a per-model device name
Message-ID: <20101022112528.6c2e4131@pedra>
In-Reply-To: <cover.1287753463.git.mchehab@redhat.com>
References: <cover.1287753463.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

It is better to use a per-model device name, especially on multi-function
devices like Polaris. So, allow overriding the default name at the
mceusb model table.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/IR/mceusb.c b/drivers/media/IR/mceusb.c
index e72bfa1..35425ee 100644
--- a/drivers/media/IR/mceusb.c
+++ b/drivers/media/IR/mceusb.c
@@ -126,6 +126,7 @@ struct mceusb_model {
 	u32 is_polaris:1;
 
 	const char *rc_map;	/* Allow specify a per-board map */
+	const char *name;	/* per-board name */
 };
 
 static const struct mceusb_model mceusb_model[] = {
@@ -155,6 +156,7 @@ static const struct mceusb_model mceusb_model[] = {
 		 * to allow testing it
 		 */
 		.rc_map = RC_MAP_RC5_HAUPPAUGE_NEW,
+		.name = "cx231xx MCE IR",
 	},
 };
 
@@ -960,6 +962,7 @@ static struct input_dev *mceusb_init_input_dev(struct mceusb_dev *ir)
 	struct ir_dev_props *props;
 	struct device *dev = ir->dev;
 	const char *rc_map = RC_MAP_RC6_MCE;
+	const char *name = "Media Center Ed. eHome Infrared Remote Transceiver";
 	int ret = -ENODEV;
 
 	idev = input_allocate_device();
@@ -975,8 +978,11 @@ static struct input_dev *mceusb_init_input_dev(struct mceusb_dev *ir)
 		goto props_alloc_failed;
 	}
 
-	snprintf(ir->name, sizeof(ir->name), "Media Center Ed. eHome "
-		 "Infrared Remote Transceiver (%04x:%04x)",
+	if (mceusb_model[ir->model].name)
+		name = mceusb_model[ir->model].name;
+
+	snprintf(ir->name, sizeof(ir->name), "%s (%04x:%04x)",
+		 name,
 		 le16_to_cpu(ir->usbdev->descriptor.idVendor),
 		 le16_to_cpu(ir->usbdev->descriptor.idProduct));
 
-- 
1.7.1

