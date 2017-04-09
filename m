Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f67.google.com ([74.125.83.67]:36380 "EHLO
        mail-pg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751840AbdDIBfG (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sat, 8 Apr 2017 21:35:06 -0400
From: Geliang Tang <geliangtang@gmail.com>
To: Andy Walls <awalls@md.metrocast.net>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Geliang Tang <geliangtang@gmail.com>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 04/12] [media] cx18: use setup_timer
Date: Sun,  9 Apr 2017 09:34:00 +0800
Message-Id: <9c92975c27ba727047cde9336d7da746a0130a04.1490953290.git.geliangtang@gmail.com>
In-Reply-To: <77c0fb26d214e023a99afc948c71d6edd9284205.1490953290.git.geliangtang@gmail.com>
References: <77c0fb26d214e023a99afc948c71d6edd9284205.1490953290.git.geliangtang@gmail.com>
In-Reply-To: <77c0fb26d214e023a99afc948c71d6edd9284205.1490953290.git.geliangtang@gmail.com>
References: <77c0fb26d214e023a99afc948c71d6edd9284205.1490953290.git.geliangtang@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use setup_timer() instead of init_timer() to simplify the code.

Signed-off-by: Geliang Tang <geliangtang@gmail.com>
---
 drivers/media/pci/cx18/cx18-streams.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/media/pci/cx18/cx18-streams.c b/drivers/media/pci/cx18/cx18-streams.c
index 7c93814..3c45e007 100644
--- a/drivers/media/pci/cx18/cx18-streams.c
+++ b/drivers/media/pci/cx18/cx18-streams.c
@@ -282,9 +282,7 @@ static void cx18_stream_init(struct cx18 *cx, int type)
 	INIT_WORK(&s->out_work_order, cx18_out_work_handler);
 
 	INIT_LIST_HEAD(&s->vb_capture);
-	s->vb_timeout.function = cx18_vb_timeout;
-	s->vb_timeout.data = (unsigned long)s;
-	init_timer(&s->vb_timeout);
+	setup_timer(&s->vb_timeout, cx18_vb_timeout, (unsigned long)s);
 	spin_lock_init(&s->vb_lock);
 	if (type == CX18_ENC_STREAM_TYPE_YUV) {
 		spin_lock_init(&s->vbuf_q_lock);
-- 
2.9.3
