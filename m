Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:33422 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750776AbdCJFN2 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 10 Mar 2017 00:13:28 -0500
Received: by mail-pf0-f196.google.com with SMTP id v190so9533938pfb.0
        for <linux-media@vger.kernel.org>; Thu, 09 Mar 2017 21:13:27 -0800 (PST)
From: simran singhal <singhalsimran0@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, jarod@wilsonet.com, mchehab@kernel.org,
        linux-media@vger.kernel.org
Subject: [PATCH 3/3] staging: lirc_zilog: Clean up tests if NULL returned on failure
Date: Fri, 10 Mar 2017 10:43:12 +0530
Message-Id: <1489122792-8081-4-git-send-email-singhalsimran0@gmail.com>
In-Reply-To: <1489122792-8081-1-git-send-email-singhalsimran0@gmail.com>
References: <1489122792-8081-1-git-send-email-singhalsimran0@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Some functions like kmalloc/kzalloc return NULL on failure.
When NULL represents failure, !x is commonly used.

This was done using Coccinelle:
@@
expression *e;
identifier l1;
@@

e = \(kmalloc\|kzalloc\|kcalloc\|devm_kzalloc\)(...);
...
- e == NULL
+ !e

Signed-off-by: simran singhal <singhalsimran0@gmail.com>
---
 drivers/staging/media/lirc/lirc_zilog.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/media/lirc/lirc_zilog.c b/drivers/staging/media/lirc/lirc_zilog.c
index 34aac3e..4836182 100644
--- a/drivers/staging/media/lirc/lirc_zilog.c
+++ b/drivers/staging/media/lirc/lirc_zilog.c
@@ -1475,7 +1475,7 @@ static int ir_probe(struct i2c_client *client, const struct i2c_device_id *id)
 	ir = get_ir_device_by_adapter(adap);
 	if (ir == NULL) {
 		ir = kzalloc(sizeof(struct IR), GFP_KERNEL);
-		if (ir == NULL) {
+		if (!ir) {
 			ret = -ENOMEM;
 			goto out_no_ir;
 		}
@@ -1515,7 +1515,7 @@ static int ir_probe(struct i2c_client *client, const struct i2c_device_id *id)
 
 		/* Set up a struct IR_tx instance */
 		tx = kzalloc(sizeof(struct IR_tx), GFP_KERNEL);
-		if (tx == NULL) {
+		if (!tx) {
 			ret = -ENOMEM;
 			goto out_put_xx;
 		}
@@ -1559,7 +1559,7 @@ static int ir_probe(struct i2c_client *client, const struct i2c_device_id *id)
 
 		/* Set up a struct IR_rx instance */
 		rx = kzalloc(sizeof(struct IR_rx), GFP_KERNEL);
-		if (rx == NULL) {
+		if (!rx) {
 			ret = -ENOMEM;
 			goto out_put_xx;
 		}
-- 
2.7.4
