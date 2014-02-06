Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f181.google.com ([209.85.212.181]:55007 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756994AbaBFUAA (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 6 Feb 2014 15:00:00 -0500
Received: by mail-wi0-f181.google.com with SMTP id hi5so185848wib.8
        for <linux-media@vger.kernel.org>; Thu, 06 Feb 2014 11:59:59 -0800 (PST)
From: James Hogan <james.hogan@imgtec.com>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	=?UTF-8?q?Antti=20Sepp=C3=A4l=C3=A4?= <a.seppala@gmail.com>
Cc: linux-media@vger.kernel.org, James Hogan <james.hogan@imgtec.com>
Subject: [RFC 2/4] rc: ir-raw: add modulation helpers
Date: Thu,  6 Feb 2014 19:59:21 +0000
Message-Id: <1391716763-2689-3-git-send-email-james.hogan@imgtec.com>
In-Reply-To: <1391716763-2689-1-git-send-email-james.hogan@imgtec.com>
References: <1391716763-2689-1-git-send-email-james.hogan@imgtec.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add IR encoding helpers, particularly for pulse-distance modulation as
used by the NEC protocol.

Signed-off-by: James Hogan <james.hogan@imgtec.com>
---
 drivers/media/rc/ir-raw.c       | 33 +++++++++++++++++++++++++++++++
 drivers/media/rc/rc-core-priv.h | 44 +++++++++++++++++++++++++++++++++++++++++
 2 files changed, 77 insertions(+)

diff --git a/drivers/media/rc/ir-raw.c b/drivers/media/rc/ir-raw.c
index 9aea407..ae7b445 100644
--- a/drivers/media/rc/ir-raw.c
+++ b/drivers/media/rc/ir-raw.c
@@ -240,6 +240,39 @@ ir_raw_get_allowed_protocols(void)
 	return protocols;
 }
 
+int ir_raw_gen_pd(struct ir_raw_event **ev, unsigned int max,
+		  const struct ir_raw_timings_pd *timings,
+		  unsigned int n, unsigned int data)
+{
+	int i;
+
+	i = 2 + n*2;
+	if (timings->header_pulse)
+		i += 2;
+	if (max < i)
+		return -EINVAL;
+
+	if (timings->header_pulse)
+		ir_raw_gen_pulse_space(ev, timings->header_pulse,
+				       timings->header_space);
+
+	if (timings->msb_first) {
+		for (i = n - 1; i >= 0; --i)
+			ir_raw_gen_pulse_space(ev, timings->bit_pulse,
+					timings->bit_space[(data >> i) & 1]);
+	} else {
+		for (i = 0; i < n; ++i, data >>= 1)
+			ir_raw_gen_pulse_space(ev, timings->bit_pulse,
+					timings->bit_space[data & 1]);
+	}
+
+	ir_raw_gen_pulse_space(ev, timings->trailer_pulse,
+			       timings->trailer_space);
+
+	return 0;
+}
+EXPORT_SYMBOL(ir_raw_gen_pd);
+
 /**
  * ir_raw_encode_scancode() - Encode a scancode as raw events
  *
diff --git a/drivers/media/rc/rc-core-priv.h b/drivers/media/rc/rc-core-priv.h
index dfbaad0..a77ad96 100644
--- a/drivers/media/rc/rc-core-priv.h
+++ b/drivers/media/rc/rc-core-priv.h
@@ -153,6 +153,50 @@ static inline bool is_timing_event(struct ir_raw_event ev)
 #define TO_US(duration)			DIV_ROUND_CLOSEST((duration), 1000)
 #define TO_STR(is_pulse)		((is_pulse) ? "pulse" : "space")
 
+/* functions for IR encoders */
+
+static inline void init_ir_raw_event_duration(struct ir_raw_event *ev,
+					      unsigned int pulse,
+					      u32 duration)
+{
+	init_ir_raw_event(ev);
+	ev->duration = duration;
+	ev->pulse = pulse;
+}
+
+static inline void ir_raw_gen_pulse_space(struct ir_raw_event **ev,
+					  unsigned int pulse_width,
+					  unsigned int space_width)
+{
+	init_ir_raw_event_duration((*ev)++, 1, pulse_width);
+	init_ir_raw_event_duration((*ev)++, 0, space_width);
+}
+
+/**
+ * struct ir_raw_timings_pd - pulse-distance modulation timings
+ * @header_pulse:	duration of header pulse in ns (0 for none)
+ * @header_space:	duration of header space in ns
+ * @bit_pulse:		duration of bit pulse in ns
+ * @bit_space:		duration of bit space (for logic 0 and 1) in ns
+ * @trailer_pulse:	duration of trailer pulse in ns
+ * @trailer_space:	duration of trailer space in ns
+ * @msb_first:		1 if most significant bit is sent first
+ */
+struct ir_raw_timings_pd
+{
+	unsigned int header_pulse;
+	unsigned int header_space;
+	unsigned int bit_pulse;
+	unsigned int bit_space[2];
+	unsigned int trailer_pulse;
+	unsigned int trailer_space;
+	unsigned int msb_first:1;
+};
+
+int ir_raw_gen_pd(struct ir_raw_event **ev, unsigned int max,
+		  const struct ir_raw_timings_pd *timings,
+		  unsigned int n, unsigned int data);
+
 /*
  * Routines from rc-raw.c to be used internally and by decoders
  */
-- 
1.8.3.2

