Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:39264 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756424Ab0JVN0s (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 22 Oct 2010 09:26:48 -0400
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o9MDQlcA005812
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Fri, 22 Oct 2010 09:26:48 -0400
Date: Fri, 22 Oct 2010 11:25:27 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: jarod@redhat.com
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 2/3] mceusb: allow a per-model RC map
Message-ID: <20101022112527.7104b849@pedra>
In-Reply-To: <cover.1287753463.git.mchehab@redhat.com>
References: <cover.1287753463.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Especially when used with Polaris boards, devices may have different
types of remotes shipped. So, we need a per-model rc-map.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/IR/mceusb.c b/drivers/media/IR/mceusb.c
index 9143ab6..e72bfa1 100644
--- a/drivers/media/IR/mceusb.c
+++ b/drivers/media/IR/mceusb.c
@@ -125,10 +125,7 @@ struct mceusb_model {
 	u32 tx_mask_inverted:1;
 	u32 is_polaris:1;
 
-	/*
-	 * Allow specify a per-board extra data, like
-	 * device names, and per-device rc_maps
-	 */
+	const char *rc_map;	/* Allow specify a per-board map */
 };
 
 static const struct mceusb_model mceusb_model[] = {
@@ -152,6 +149,12 @@ static const struct mceusb_model mceusb_model[] = {
 	},
 	[POLARIS_EVK] = {
 		.is_polaris = 1,
+		/*
+		 * In fact, the EVK is shipped without
+		 * remotes, but we should have something handy,
+		 * to allow testing it
+		 */
+		.rc_map = RC_MAP_RC5_HAUPPAUGE_NEW,
 	},
 };
 
@@ -956,6 +959,7 @@ static struct input_dev *mceusb_init_input_dev(struct mceusb_dev *ir)
 	struct input_dev *idev;
 	struct ir_dev_props *props;
 	struct device *dev = ir->dev;
+	const char *rc_map = RC_MAP_RC6_MCE;
 	int ret = -ENODEV;
 
 	idev = input_allocate_device();
@@ -990,7 +994,10 @@ static struct input_dev *mceusb_init_input_dev(struct mceusb_dev *ir)
 
 	ir->props = props;
 
-	ret = ir_input_register(idev, RC_MAP_RC6_MCE, props, DRIVER_NAME);
+	if (mceusb_model[ir->model].rc_map)
+		rc_map = mceusb_model[ir->model].rc_map;
+
+	ret = ir_input_register(idev, rc_map, props, DRIVER_NAME);
 	if (ret < 0) {
 		dev_err(dev, "remote input device register failed\n");
 		goto irdev_failed;
-- 
1.7.1


