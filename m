Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:2779 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752846AbaHTW7m (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 20 Aug 2014 18:59:42 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 01/29] img-ir: fix sparse warnings
Date: Thu, 21 Aug 2014 00:59:00 +0200
Message-Id: <1408575568-20562-2-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1408575568-20562-1-git-send-email-hverkuil@xs4all.nl>
References: <1408575568-20562-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

drivers/media/rc/img-ir/img-ir-nec.c:111:23: warning: symbol 'img_ir_nec' was not declared. Should it be static?
drivers/media/rc/img-ir/img-ir-jvc.c:54:23: warning: symbol 'img_ir_jvc' was not declared. Should it be static?
drivers/media/rc/img-ir/img-ir-sony.c:120:23: warning: symbol 'img_ir_sony' was not declared. Should it be static?
drivers/media/rc/img-ir/img-ir-sharp.c:75:23: warning: symbol 'img_ir_sharp' was not declared. Should it be static?
drivers/media/rc/img-ir/img-ir-sanyo.c:82:23: warning: symbol 'img_ir_sanyo' was not declared. Should it be static?

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/rc/img-ir/img-ir-hw.c | 6 ------
 drivers/media/rc/img-ir/img-ir-hw.h | 6 ++++++
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/media/rc/img-ir/img-ir-hw.c b/drivers/media/rc/img-ir/img-ir-hw.c
index bfb282a..ec49f94 100644
--- a/drivers/media/rc/img-ir/img-ir-hw.c
+++ b/drivers/media/rc/img-ir/img-ir-hw.c
@@ -25,12 +25,6 @@
 /* Decoders lock (only modified to preprocess them) */
 static DEFINE_SPINLOCK(img_ir_decoders_lock);
 
-extern struct img_ir_decoder img_ir_nec;
-extern struct img_ir_decoder img_ir_jvc;
-extern struct img_ir_decoder img_ir_sony;
-extern struct img_ir_decoder img_ir_sharp;
-extern struct img_ir_decoder img_ir_sanyo;
-
 static bool img_ir_decoders_preprocessed;
 static struct img_ir_decoder *img_ir_decoders[] = {
 #ifdef CONFIG_IR_IMG_NEC
diff --git a/drivers/media/rc/img-ir/img-ir-hw.h b/drivers/media/rc/img-ir/img-ir-hw.h
index 3e40ce8..8fcc16c 100644
--- a/drivers/media/rc/img-ir/img-ir-hw.h
+++ b/drivers/media/rc/img-ir/img-ir-hw.h
@@ -168,6 +168,12 @@ struct img_ir_decoder {
 		      struct img_ir_filter *out, u64 protocols);
 };
 
+extern struct img_ir_decoder img_ir_nec;
+extern struct img_ir_decoder img_ir_jvc;
+extern struct img_ir_decoder img_ir_sony;
+extern struct img_ir_decoder img_ir_sharp;
+extern struct img_ir_decoder img_ir_sanyo;
+
 /**
  * struct img_ir_reg_timings - Reg values for decoder timings at clock rate.
  * @ctrl:	Processed control register value.
-- 
2.1.0.rc1

