Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:36626 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965480AbdEOTm4 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 15 May 2017 15:42:56 -0400
Received: by mail-wm0-f68.google.com with SMTP id u65so30695582wmu.3
        for <linux-media@vger.kernel.org>; Mon, 15 May 2017 12:42:55 -0700 (PDT)
From: Ricardo Silva <rjpdasilva@gmail.com>
To: Jarod Wilson <jarod@wilsonet.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        Ricardo Silva <rjpdasilva@gmail.com>
Subject: [PATCH 4/5] staging: media: lirc: Use sizeof(*p) instead of sizeof(struct P)
Date: Mon, 15 May 2017 20:40:15 +0100
Message-Id: <20170515194016.10246-5-rjpdasilva@gmail.com>
In-Reply-To: <20170515194016.10246-1-rjpdasilva@gmail.com>
References: <20170515194016.10246-1-rjpdasilva@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix all checkpatch reported issues for "CHECK: Prefer
kzalloc(sizeof(*<p>)...) over kzalloc(sizeof(struct <P>)...)".

Other similar case in the code already using recommended style, so make
it all consistent with the recommended practice.

Signed-off-by: Ricardo Silva <rjpdasilva@gmail.com>
---
 drivers/staging/media/lirc/lirc_zilog.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/media/lirc/lirc_zilog.c b/drivers/staging/media/lirc/lirc_zilog.c
index 99b5858124e0..7e36693b66a8 100644
--- a/drivers/staging/media/lirc/lirc_zilog.c
+++ b/drivers/staging/media/lirc/lirc_zilog.c
@@ -1474,7 +1474,7 @@ static int ir_probe(struct i2c_client *client, const struct i2c_device_id *id)
 	/* Use a single struct IR instance for both the Rx and Tx functions */
 	ir = get_ir_device_by_adapter(adap);
 	if (!ir) {
-		ir = kzalloc(sizeof(struct IR), GFP_KERNEL);
+		ir = kzalloc(sizeof(*ir), GFP_KERNEL);
 		if (!ir) {
 			ret = -ENOMEM;
 			goto out_no_ir;
@@ -1514,7 +1514,7 @@ static int ir_probe(struct i2c_client *client, const struct i2c_device_id *id)
 		rx = get_ir_rx(ir);
 
 		/* Set up a struct IR_tx instance */
-		tx = kzalloc(sizeof(struct IR_tx), GFP_KERNEL);
+		tx = kzalloc(sizeof(*tx), GFP_KERNEL);
 		if (!tx) {
 			ret = -ENOMEM;
 			goto out_put_xx;
@@ -1558,7 +1558,7 @@ static int ir_probe(struct i2c_client *client, const struct i2c_device_id *id)
 		tx = get_ir_tx(ir);
 
 		/* Set up a struct IR_rx instance */
-		rx = kzalloc(sizeof(struct IR_rx), GFP_KERNEL);
+		rx = kzalloc(sizeof(*rx), GFP_KERNEL);
 		if (!rx) {
 			ret = -ENOMEM;
 			goto out_put_xx;
-- 
2.12.2
