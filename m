Return-Path: <SRS0=2Dg0=OV=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,T_MIXED_ES,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F419AC67839
	for <linux-media@archiver.kernel.org>; Wed, 12 Dec 2018 16:27:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AD4E720849
	for <linux-media@archiver.kernel.org>; Wed, 12 Dec 2018 16:27:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LA/flPLm"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AD4E720849
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727853AbeLLQ1I (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 12 Dec 2018 11:27:08 -0500
Received: from mail-pg1-f195.google.com ([209.85.215.195]:37529 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727756AbeLLQ1H (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 12 Dec 2018 11:27:07 -0500
Received: by mail-pg1-f195.google.com with SMTP id 80so8562063pge.4;
        Wed, 12 Dec 2018 08:27:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=TNgAFcwDeEgPAbFHjhM8JYwuFl/JrpzvEnAQ525Oe3I=;
        b=LA/flPLmFzqwauqP2pCI3bMAJd/SOUkJlAGizGlpyqtvZBndYgkcJTL7hVIIAm0/28
         f1ldqqQ5/8kdbd3c8W7RHkcHrcKn3v0REcJrMSP7++xlUjuOnmkVEquPk8B+DLfA0E2A
         rqcARk0oh/TV1SjoHmdrWMG15cC+KjGqjoyn45pz4RrdwQKagvhj8FWNFHnm9rVXZ7Dk
         ybGR3anK1TACE3+el9x4lkMiLpf9kfmyC3zZhneA2Tf7hHdHrXNk/Y5VVXJEU55tjvw/
         J8I2e15c9WsCdZLwo36liT2nDu1m8fDHCRqbdEdRDNada6Fua2s+ADvuwbt34xlFFvoE
         TRdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=TNgAFcwDeEgPAbFHjhM8JYwuFl/JrpzvEnAQ525Oe3I=;
        b=iQVYOGe8cSyYBUWCim4Ip/K9PmZpobMOFVMnvJVnvSEBSJFB/5/Ue0dyNamMQw9ivf
         ejoIVQtcZ7DDViIHmqhvZ9uhDo7sGi0tuYA5UixowK/td8b0JhlSbo/xL9ZOlWL6ZaY1
         E8B8BtD9P7sO6bOLMwfqjkAN1znmcafyKoycOGRISqPxzCSewVFM9mykrpLkrX4zPuKE
         rJ0W79WY6Kwz9TxqspGucAeP6i6TYQAlLmvNf65Yo6jHR/n2c8RzyqcZ3exXIGH3ZY59
         54zZE8AZdydi+19ThC9s/QOFu7SkivCLQPwCJAUW90bEkuf622vIQGw2Oj6Zsl1yNU86
         yrAw==
X-Gm-Message-State: AA+aEWZF2TKipF9wX2qA64lgXhGGLFSkfPgwF4Lsc9BZhE6mJlyaU7FC
        rx8A6qrWNSZ64HEOCS50bUo=
X-Google-Smtp-Source: AFSGD/XBQwOZUstVqJy5O8QHt6ROYWkcak7RstJ56I/ecqJoe/p3JnBxGrdOyuPJ1QugvFt4sJU0dg==
X-Received: by 2002:a63:64c:: with SMTP id 73mr18646346pgg.373.1544632025674;
        Wed, 12 Dec 2018 08:27:05 -0800 (PST)
Received: from localhost (68.168.130.77.16clouds.com. [68.168.130.77])
        by smtp.gmail.com with ESMTPSA id z14sm21223298pgv.47.2018.12.12.08.27.04
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 12 Dec 2018 08:27:04 -0800 (PST)
From:   Yangtao Li <tiny.windzz@gmail.com>
To:     fabien.dessenne@st.com, mchehab@kernel.org,
        jean-christophe.trotin@st.com
Cc:     linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yangtao Li <tiny.windzz@gmail.com>
Subject: [PATCH v3] media: platform: sti: remove bdisp_dbg_declare() and hva_dbg_declare()
Date:   Wed, 12 Dec 2018 11:27:03 -0500
Message-Id: <20181212162703.23546-1-tiny.windzz@gmail.com>
X-Mailer: git-send-email 2.17.0
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

We already have the DEFINE_SHOW_ATTRIBUTE. There is no need to define
bdisp_dbg_declare and hva_dbg_declare, so remove them. Also use
DEFINE_SHOW_ATTRIBUTE to simplify some code.

Signed-off-by: Yangtao Li <tiny.windzz@gmail.com>
---
 .../media/platform/sti/bdisp/bdisp-debug.c    | 34 ++++++------------
 drivers/media/platform/sti/hva/hva-debugfs.c  | 36 +++++++------------
 2 files changed, 23 insertions(+), 47 deletions(-)

diff --git a/drivers/media/platform/sti/bdisp/bdisp-debug.c b/drivers/media/platform/sti/bdisp/bdisp-debug.c
index c6a4e2de5c0c..77ca7517fa3e 100644
--- a/drivers/media/platform/sti/bdisp/bdisp-debug.c
+++ b/drivers/media/platform/sti/bdisp/bdisp-debug.c
@@ -315,7 +315,7 @@ static void bdisp_dbg_dump_ivmx(struct seq_file *s,
 	seq_puts(s, "Unknown conversion\n");
 }
 
-static int bdisp_dbg_last_nodes(struct seq_file *s, void *data)
+static int last_nodes_show(struct seq_file *s, void *data)
 {
 	/* Not dumping all fields, focusing on significant ones */
 	struct bdisp_dev *bdisp = s->private;
@@ -388,7 +388,7 @@ static int bdisp_dbg_last_nodes(struct seq_file *s, void *data)
 	return 0;
 }
 
-static int bdisp_dbg_last_nodes_raw(struct seq_file *s, void *data)
+static int last_nodes_raw_show(struct seq_file *s, void *data)
 {
 	struct bdisp_dev *bdisp = s->private;
 	struct bdisp_node *node;
@@ -437,7 +437,7 @@ static const char *bdisp_fmt_to_str(struct bdisp_frame frame)
 	}
 }
 
-static int bdisp_dbg_last_request(struct seq_file *s, void *data)
+static int last_request_show(struct seq_file *s, void *data)
 {
 	struct bdisp_dev *bdisp = s->private;
 	struct bdisp_request *request = &bdisp->dbg.copy_request;
@@ -474,7 +474,7 @@ static int bdisp_dbg_last_request(struct seq_file *s, void *data)
 
 #define DUMP(reg) seq_printf(s, #reg " \t0x%08X\n", readl(bdisp->regs + reg))
 
-static int bdisp_dbg_regs(struct seq_file *s, void *data)
+static int regs_show(struct seq_file *s, void *data)
 {
 	struct bdisp_dev *bdisp = s->private;
 	int ret;
@@ -582,7 +582,7 @@ static int bdisp_dbg_regs(struct seq_file *s, void *data)
 
 #define SECOND 1000000
 
-static int bdisp_dbg_perf(struct seq_file *s, void *data)
+static int perf_show(struct seq_file *s, void *data)
 {
 	struct bdisp_dev *bdisp = s->private;
 	struct bdisp_request *request = &bdisp->dbg.copy_request;
@@ -627,27 +627,15 @@ static int bdisp_dbg_perf(struct seq_file *s, void *data)
 	return 0;
 }
 
-#define bdisp_dbg_declare(name) \
-	static int bdisp_dbg_##name##_open(struct inode *i, struct file *f) \
-	{ \
-		return single_open(f, bdisp_dbg_##name, i->i_private); \
-	} \
-	static const struct file_operations bdisp_dbg_##name##_fops = { \
-		.open           = bdisp_dbg_##name##_open, \
-		.read           = seq_read, \
-		.llseek         = seq_lseek, \
-		.release        = single_release, \
-	}
-
 #define bdisp_dbg_create_entry(name) \
 	debugfs_create_file(#name, S_IRUGO, bdisp->dbg.debugfs_entry, bdisp, \
-			    &bdisp_dbg_##name##_fops)
+			    &name##_fops)
 
-bdisp_dbg_declare(regs);
-bdisp_dbg_declare(last_nodes);
-bdisp_dbg_declare(last_nodes_raw);
-bdisp_dbg_declare(last_request);
-bdisp_dbg_declare(perf);
+DEFINE_SHOW_ATTRIBUTE(regs);
+DEFINE_SHOW_ATTRIBUTE(last_nodes);
+DEFINE_SHOW_ATTRIBUTE(last_nodes_raw);
+DEFINE_SHOW_ATTRIBUTE(last_request);
+DEFINE_SHOW_ATTRIBUTE(perf);
 
 int bdisp_debugfs_create(struct bdisp_dev *bdisp)
 {
diff --git a/drivers/media/platform/sti/hva/hva-debugfs.c b/drivers/media/platform/sti/hva/hva-debugfs.c
index 9f7e8ac875d1..7d12a5b5d914 100644
--- a/drivers/media/platform/sti/hva/hva-debugfs.c
+++ b/drivers/media/platform/sti/hva/hva-debugfs.c
@@ -271,7 +271,7 @@ static void hva_dbg_perf_compute(struct hva_ctx *ctx)
  * device debug info
  */
 
-static int hva_dbg_device(struct seq_file *s, void *data)
+static int device_show(struct seq_file *s, void *data)
 {
 	struct hva_dev *hva = s->private;
 
@@ -281,7 +281,7 @@ static int hva_dbg_device(struct seq_file *s, void *data)
 	return 0;
 }
 
-static int hva_dbg_encoders(struct seq_file *s, void *data)
+static int encoders_show(struct seq_file *s, void *data)
 {
 	struct hva_dev *hva = s->private;
 	unsigned int i = 0;
@@ -299,7 +299,7 @@ static int hva_dbg_encoders(struct seq_file *s, void *data)
 	return 0;
 }
 
-static int hva_dbg_last(struct seq_file *s, void *data)
+static int last_show(struct seq_file *s, void *data)
 {
 	struct hva_dev *hva = s->private;
 	struct hva_ctx *last_ctx = &hva->dbg.last_ctx;
@@ -316,7 +316,7 @@ static int hva_dbg_last(struct seq_file *s, void *data)
 	return 0;
 }
 
-static int hva_dbg_regs(struct seq_file *s, void *data)
+static int regs_show(struct seq_file *s, void *data)
 {
 	struct hva_dev *hva = s->private;
 
@@ -325,26 +325,14 @@ static int hva_dbg_regs(struct seq_file *s, void *data)
 	return 0;
 }
 
-#define hva_dbg_declare(name)						  \
-	static int hva_dbg_##name##_open(struct inode *i, struct file *f) \
-	{								  \
-		return single_open(f, hva_dbg_##name, i->i_private);	  \
-	}								  \
-	static const struct file_operations hva_dbg_##name##_fops = {	  \
-		.open		= hva_dbg_##name##_open,		  \
-		.read		= seq_read,				  \
-		.llseek		= seq_lseek,				  \
-		.release	= single_release,			  \
-	}
-
 #define hva_dbg_create_entry(name)					 \
 	debugfs_create_file(#name, 0444, hva->dbg.debugfs_entry, hva, \
-			    &hva_dbg_##name##_fops)
+			    &name##_fops)
 
-hva_dbg_declare(device);
-hva_dbg_declare(encoders);
-hva_dbg_declare(last);
-hva_dbg_declare(regs);
+DEFINE_SHOW_ATTRIBUTE(device);
+DEFINE_SHOW_ATTRIBUTE(encoders);
+DEFINE_SHOW_ATTRIBUTE(last);
+DEFINE_SHOW_ATTRIBUTE(regs);
 
 void hva_debugfs_create(struct hva_dev *hva)
 {
@@ -380,7 +368,7 @@ void hva_debugfs_remove(struct hva_dev *hva)
  * context (instance) debug info
  */
 
-static int hva_dbg_ctx(struct seq_file *s, void *data)
+static int ctx_show(struct seq_file *s, void *data)
 {
 	struct hva_ctx *ctx = s->private;
 
@@ -392,7 +380,7 @@ static int hva_dbg_ctx(struct seq_file *s, void *data)
 	return 0;
 }
 
-hva_dbg_declare(ctx);
+DEFINE_SHOW_ATTRIBUTE(ctx);
 
 void hva_dbg_ctx_create(struct hva_ctx *ctx)
 {
@@ -407,7 +395,7 @@ void hva_dbg_ctx_create(struct hva_ctx *ctx)
 
 	ctx->dbg.debugfs_entry = debugfs_create_file(name, 0444,
 						     hva->dbg.debugfs_entry,
-						     ctx, &hva_dbg_ctx_fops);
+						     ctx, &ctx_fops);
 }
 
 void hva_dbg_ctx_remove(struct hva_ctx *ctx)
-- 
2.17.0

