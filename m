Return-path: <mchehab@pedra>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:64201 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752332Ab0JYCFi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 24 Oct 2010 22:05:38 -0400
Received: by bwz11 with SMTP id 11so1963681bwz.19
        for <linux-media@vger.kernel.org>; Sun, 24 Oct 2010 19:05:37 -0700 (PDT)
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: lirc-list@lists.sourceforge.net
Cc: Jarod Wilson <jarod@wilsonet.com>, mchehab@infradead.org,
	linux-media@vger.kernel.org, Andy Walls <awalls@md.metrocast.net>,
	Maxim Levitsky <maximlevitsky@gmail.com>
Subject: [PATCH] IR: initialize ir_raw_event in few more drivers
Date: Mon, 25 Oct 2010 04:05:29 +0200
Message-Id: <1287972329-8171-1-git-send-email-maximlevitsky@gmail.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Few drivers still have assumption that ir_raw_event
consists of duration and pulse flag.
Fix that.

Signed-off-by: Maxim Levitsky <maximlevitsky@gmail.com>
---
 drivers/media/dvb/siano/smsir.c          |    2 +-
 drivers/media/video/cx23885/cx23888-ir.c |    1 +
 drivers/media/video/cx25840/cx25840-ir.c |    1 +
 3 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/media/dvb/siano/smsir.c b/drivers/media/dvb/siano/smsir.c
index d0e4639..a27c44a 100644
--- a/drivers/media/dvb/siano/smsir.c
+++ b/drivers/media/dvb/siano/smsir.c
@@ -40,7 +40,7 @@ void sms_ir_event(struct smscore_device_t *coredev, const char *buf, int len)
 	const s32 *samples = (const void *)buf;
 
 	for (i = 0; i < len >> 2; i++) {
-		struct ir_raw_event ev;
+		DEFINE_IR_RAW_EVENT(ev);
 
 		ev.duration = abs(samples[i]) * 1000; /* Convert to ns */
 		ev.pulse = (samples[i] > 0) ? false : true;
diff --git a/drivers/media/video/cx23885/cx23888-ir.c b/drivers/media/video/cx23885/cx23888-ir.c
index 2502a0a..e78e3e4 100644
--- a/drivers/media/video/cx23885/cx23888-ir.c
+++ b/drivers/media/video/cx23885/cx23888-ir.c
@@ -704,6 +704,7 @@ static int cx23888_ir_rx_read(struct v4l2_subdev *sd, u8 *buf, size_t count,
 		if (v > IR_MAX_DURATION)
 			v = IR_MAX_DURATION;
 
+		init_ir_raw_event(&p->ir_core_data);
 		p->ir_core_data.pulse = u;
 		p->ir_core_data.duration = v;
 
diff --git a/drivers/media/video/cx25840/cx25840-ir.c b/drivers/media/video/cx25840/cx25840-ir.c
index c2b4c14..97a4e9b 100644
--- a/drivers/media/video/cx25840/cx25840-ir.c
+++ b/drivers/media/video/cx25840/cx25840-ir.c
@@ -706,6 +706,7 @@ static int cx25840_ir_rx_read(struct v4l2_subdev *sd, u8 *buf, size_t count,
 		if (v > IR_MAX_DURATION)
 			v = IR_MAX_DURATION;
 
+		init_ir_raw_event(&p->ir_core_data);
 		p->ir_core_data.pulse = u;
 		p->ir_core_data.duration = v;
 
-- 
1.7.1

