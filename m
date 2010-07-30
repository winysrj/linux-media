Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:41194 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758365Ab0G3LjM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Jul 2010 07:39:12 -0400
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: lirc-list@lists.sourceforge.net
Cc: Jarod Wilson <jarod@wilsonet.com>, linux-input@vger.kernel.org,
	linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Christoph Bartelmus <lirc@bartelmus.de>,
	Maxim Levitsky <maximlevitsky@gmail.com>
Subject: [PATCH 05/13] IR: JVC: make repeat work
Date: Fri, 30 Jul 2010 14:38:45 +0300
Message-Id: <1280489933-20865-6-git-send-email-maximlevitsky@gmail.com>
In-Reply-To: <1280489933-20865-1-git-send-email-maximlevitsky@gmail.com>
References: <1280489933-20865-1-git-send-email-maximlevitsky@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Currently, jvc decoder will attempt misdetect next press as a repeat
of last keypress, therefore second keypress isn't detected.

Signed-off-by: Maxim Levitsky <maximlevitsky@gmail.com>
---
 drivers/media/IR/ir-jvc-decoder.c |   14 +++++++++++++-
 1 files changed, 13 insertions(+), 1 deletions(-)

diff --git a/drivers/media/IR/ir-jvc-decoder.c b/drivers/media/IR/ir-jvc-decoder.c
index 8894d8b..77a89c4 100644
--- a/drivers/media/IR/ir-jvc-decoder.c
+++ b/drivers/media/IR/ir-jvc-decoder.c
@@ -32,6 +32,7 @@ enum jvc_state {
 	STATE_BIT_SPACE,
 	STATE_TRAILER_PULSE,
 	STATE_TRAILER_SPACE,
+	STATE_CHECK_REPEAT,
 };
 
 /**
@@ -60,6 +61,7 @@ static int ir_jvc_decode(struct input_dev *input_dev, struct ir_raw_event ev)
 	IR_dprintk(2, "JVC decode started at state %d (%uus %s)\n",
 		   data->state, TO_US(ev.duration), TO_STR(ev.pulse));
 
+again:
 	switch (data->state) {
 
 	case STATE_INACTIVE:
@@ -149,8 +151,18 @@ static int ir_jvc_decode(struct input_dev *input_dev, struct ir_raw_event ev)
 		}
 
 		data->count = 0;
-		data->state = STATE_BIT_PULSE;
+		data->state = STATE_CHECK_REPEAT;
 		return 0;
+
+	case STATE_CHECK_REPEAT:
+		if (!ev.pulse)
+			break;
+
+		if (eq_margin(ev.duration, JVC_HEADER_PULSE, JVC_UNIT / 2))
+			data->state = STATE_INACTIVE;
+  else
+			data->state = STATE_BIT_PULSE;
+		goto again;
 	}
 
 out:
-- 
1.7.0.4

