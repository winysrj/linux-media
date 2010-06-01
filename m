Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:7847 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754295Ab0FAU1I (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 1 Jun 2010 16:27:08 -0400
Received: from int-mx03.intmail.prod.int.phx2.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o51KR8Gc008423
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Tue, 1 Jun 2010 16:27:08 -0400
Received: from ihatethathostname.lab.bos.redhat.com (ihatethathostname.lab.bos.redhat.com [10.16.43.238])
	by int-mx03.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id o51KR7KI027196
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Tue, 1 Jun 2010 16:27:08 -0400
Received: from ihatethathostname.lab.bos.redhat.com (ihatethathostname.lab.bos.redhat.com [127.0.0.1])
	by ihatethathostname.lab.bos.redhat.com (8.14.4/8.14.3) with ESMTP id o51KR7I7028037
	for <linux-media@vger.kernel.org>; Tue, 1 Jun 2010 16:27:07 -0400
Received: (from jarod@localhost)
	by ihatethathostname.lab.bos.redhat.com (8.14.4/8.14.4/Submit) id o51KR7g1028035
	for linux-media@vger.kernel.org; Tue, 1 Jun 2010 16:27:07 -0400
Date: Tue, 1 Jun 2010 16:27:07 -0400
From: Jarod Wilson <jarod@redhat.com>
To: linux-media@vger.kernel.org
Subject: [PATCH] IR: only initially enable protocol that matches loaded keymap
Message-ID: <20100601202707.GA28024@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Rather than loading all IR protocol decoders as enabled when bringing
up a new device, only enable the IR protocol decoder that matches the
keymap being loaded. Additional decoders can be enabled on the fly by
those that need to, either by twiddling sysfs bits or by using the
ir-keytable util from v4l-utils.

Functional testing done with the mceusb driver, and it behaves as expected,
only the rc6 decoder is enabled, keys are all handled properly, etc.

Signed-off-by: Jarod Wilson <jarod@redhat.com>
---
 drivers/media/IR/ir-jvc-decoder.c  |    4 +++-
 drivers/media/IR/ir-nec-decoder.c  |    4 +++-
 drivers/media/IR/ir-rc5-decoder.c  |    4 +++-
 drivers/media/IR/ir-rc6-decoder.c  |    4 +++-
 drivers/media/IR/ir-sony-decoder.c |    4 +++-
 5 files changed, 15 insertions(+), 5 deletions(-)

diff --git a/drivers/media/IR/ir-jvc-decoder.c b/drivers/media/IR/ir-jvc-decoder.c
index 0b80494..b02e801 100644
--- a/drivers/media/IR/ir-jvc-decoder.c
+++ b/drivers/media/IR/ir-jvc-decoder.c
@@ -253,6 +253,7 @@ static int ir_jvc_register(struct input_dev *input_dev)
 {
 	struct ir_input_dev *ir_dev = input_get_drvdata(input_dev);
 	struct decoder_data *data;
+	u64 ir_type = ir_dev->rc_tab.ir_type;
 	int rc;
 
 	rc = sysfs_create_group(&ir_dev->dev.kobj, &decoder_attribute_group);
@@ -266,7 +267,8 @@ static int ir_jvc_register(struct input_dev *input_dev)
 	}
 
 	data->ir_dev = ir_dev;
-	data->enabled = 1;
+	if (ir_type == IR_TYPE_JVC || ir_type == IR_TYPE_UNKNOWN)
+		data->enabled = 1;
 
 	spin_lock(&decoder_lock);
 	list_add_tail(&data->list, &decoder_list);
diff --git a/drivers/media/IR/ir-nec-decoder.c b/drivers/media/IR/ir-nec-decoder.c
index ba79233..6059a1f 100644
--- a/drivers/media/IR/ir-nec-decoder.c
+++ b/drivers/media/IR/ir-nec-decoder.c
@@ -260,6 +260,7 @@ static int ir_nec_register(struct input_dev *input_dev)
 {
 	struct ir_input_dev *ir_dev = input_get_drvdata(input_dev);
 	struct decoder_data *data;
+	u64 ir_type = ir_dev->rc_tab.ir_type;
 	int rc;
 
 	rc = sysfs_create_group(&ir_dev->dev.kobj, &decoder_attribute_group);
@@ -273,7 +274,8 @@ static int ir_nec_register(struct input_dev *input_dev)
 	}
 
 	data->ir_dev = ir_dev;
-	data->enabled = 1;
+	if (ir_type == IR_TYPE_NEC || ir_type == IR_TYPE_UNKNOWN)
+		data->enabled = 1;
 
 	spin_lock(&decoder_lock);
 	list_add_tail(&data->list, &decoder_list);
diff --git a/drivers/media/IR/ir-rc5-decoder.c b/drivers/media/IR/ir-rc5-decoder.c
index 23cdb1b..4aa797b 100644
--- a/drivers/media/IR/ir-rc5-decoder.c
+++ b/drivers/media/IR/ir-rc5-decoder.c
@@ -256,6 +256,7 @@ static int ir_rc5_register(struct input_dev *input_dev)
 {
 	struct ir_input_dev *ir_dev = input_get_drvdata(input_dev);
 	struct decoder_data *data;
+	u64 ir_type = ir_dev->rc_tab.ir_type;
 	int rc;
 
 	rc = sysfs_create_group(&ir_dev->dev.kobj, &decoder_attribute_group);
@@ -269,7 +270,8 @@ static int ir_rc5_register(struct input_dev *input_dev)
 	}
 
 	data->ir_dev = ir_dev;
-	data->enabled = 1;
+	if (ir_type == IR_TYPE_RC5 || ir_type == IR_TYPE_UNKNOWN)
+		data->enabled = 1;
 
 	spin_lock(&decoder_lock);
 	list_add_tail(&data->list, &decoder_list);
diff --git a/drivers/media/IR/ir-rc6-decoder.c b/drivers/media/IR/ir-rc6-decoder.c
index 2bf479f..9f61da2 100644
--- a/drivers/media/IR/ir-rc6-decoder.c
+++ b/drivers/media/IR/ir-rc6-decoder.c
@@ -352,6 +352,7 @@ static int ir_rc6_register(struct input_dev *input_dev)
 {
 	struct ir_input_dev *ir_dev = input_get_drvdata(input_dev);
 	struct decoder_data *data;
+	u64 ir_type = ir_dev->rc_tab.ir_type;
 	int rc;
 
 	rc = sysfs_create_group(&ir_dev->dev.kobj, &decoder_attribute_group);
@@ -365,7 +366,8 @@ static int ir_rc6_register(struct input_dev *input_dev)
 	}
 
 	data->ir_dev = ir_dev;
-	data->enabled = 1;
+	if (ir_type == IR_TYPE_RC6 || ir_type == IR_TYPE_UNKNOWN)
+		data->enabled = 1;
 
 	spin_lock(&decoder_lock);
 	list_add_tail(&data->list, &decoder_list);
diff --git a/drivers/media/IR/ir-sony-decoder.c b/drivers/media/IR/ir-sony-decoder.c
index 9f440c5..219075f 100644
--- a/drivers/media/IR/ir-sony-decoder.c
+++ b/drivers/media/IR/ir-sony-decoder.c
@@ -245,6 +245,7 @@ static int ir_sony_register(struct input_dev *input_dev)
 {
 	struct ir_input_dev *ir_dev = input_get_drvdata(input_dev);
 	struct decoder_data *data;
+	u64 ir_type = ir_dev->rc_tab.ir_type;
 	int rc;
 
 	rc = sysfs_create_group(&ir_dev->dev.kobj, &decoder_attribute_group);
@@ -258,7 +259,8 @@ static int ir_sony_register(struct input_dev *input_dev)
 	}
 
 	data->ir_dev = ir_dev;
-	data->enabled = 1;
+	if (ir_type == IR_TYPE_SONY || ir_type == IR_TYPE_UNKNOWN)
+		data->enabled = 1;
 
 	spin_lock(&decoder_lock);
 	list_add_tail(&data->list, &decoder_list);
-- 
1.6.5.2

-- 
Jarod Wilson
jarod@redhat.com

