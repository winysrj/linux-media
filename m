Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:53717 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758370Ab0G3CRo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 29 Jul 2010 22:17:44 -0400
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: lirc-list@lists.sourceforge.net
Cc: Jarod Wilson <jarod@wilsonet.com>, linux-input@vger.kernel.org,
	linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Christoph Bartelmus <lirc@bartelmus.de>,
	Maxim Levitsky <maximlevitsky@gmail.com>
Subject: [PATCH 04/13] IR: fix locking in ir_raw_event_work
Date: Fri, 30 Jul 2010 05:17:06 +0300
Message-Id: <1280456235-2024-5-git-send-email-maximlevitsky@gmail.com>
In-Reply-To: <1280456235-2024-1-git-send-email-maximlevitsky@gmail.com>
References: <1280456235-2024-1-git-send-email-maximlevitsky@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

It is prefectly possible to have ir_raw_event_work
running concurently on two cpus, thus we must protect
it from that situation.

Maybe better solution is to ditch the workqueue at all
and use good 'ol thread per receiver, and just wake it up...

Signed-off-by: Maxim Levitsky <maximlevitsky@gmail.com>
---
 drivers/media/IR/ir-raw-event.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/media/IR/ir-raw-event.c b/drivers/media/IR/ir-raw-event.c
index 9d5c029..4098748 100644
--- a/drivers/media/IR/ir-raw-event.c
+++ b/drivers/media/IR/ir-raw-event.c
@@ -40,13 +40,16 @@ static void ir_raw_event_work(struct work_struct *work)
 	struct ir_raw_event_ctrl *raw =
 		container_of(work, struct ir_raw_event_ctrl, rx_work);
 
+	mutex_lock(&ir_raw_handler_lock);
+
 	while (kfifo_out(&raw->kfifo, &ev, sizeof(ev)) == sizeof(ev)) {
-		mutex_lock(&ir_raw_handler_lock);
 		list_for_each_entry(handler, &ir_raw_handler_list, list)
 			handler->decode(raw->input_dev, ev);
-		mutex_unlock(&ir_raw_handler_lock);
 		raw->prev_ev = ev;
 	}
+
+	mutex_unlock(&ir_raw_handler_lock);
+
 }
 
 /**
-- 
1.7.0.4

