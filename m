Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f41.google.com ([209.85.215.41]:57636 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752508AbaBPQqp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 16 Feb 2014 11:46:45 -0500
Received: by mail-la0-f41.google.com with SMTP id mc6so10791723lab.0
        for <linux-media@vger.kernel.org>; Sun, 16 Feb 2014 08:46:43 -0800 (PST)
From: =?UTF-8?q?Antti=20Sepp=C3=A4l=C3=A4?= <a.seppala@gmail.com>
To: James Hogan <james.hogan@imgtec.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	linux-media@vger.kernel.org,
	=?UTF-8?q?Antti=20Sepp=C3=A4l=C3=A4?= <a.seppala@gmail.com>
Subject: [RFCv2 PATCH 1/3] rc-core: Add Manchester encoder (phase encoder) support to rc-core
Date: Sun, 16 Feb 2014 18:45:53 +0200
Message-Id: <1392569155-27659-2-git-send-email-a.seppala@gmail.com>
In-Reply-To: <1392569155-27659-1-git-send-email-a.seppala@gmail.com>
References: <CAKv9HNbh39=QjyHggge3w-ke658ndCnPP+0EqPL9iUFrf3+imQ@mail.gmail.com>
 <1392569155-27659-1-git-send-email-a.seppala@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Adding a simple Manchester encoder to rc-core.
Manchester coding is used by at least RC-5 protocol and its variants.

Signed-off-by: Antti Seppälä <a.seppala@gmail.com>
---
 drivers/media/rc/ir-raw.c       | 56 +++++++++++++++++++++++++++++++++++++++++
 drivers/media/rc/rc-core-priv.h | 16 ++++++++++++
 2 files changed, 72 insertions(+)

diff --git a/drivers/media/rc/ir-raw.c b/drivers/media/rc/ir-raw.c
index 9d734dd..b9cc45d 100644
--- a/drivers/media/rc/ir-raw.c
+++ b/drivers/media/rc/ir-raw.c
@@ -240,6 +240,62 @@ ir_raw_get_allowed_protocols(void)
 	return protocols;
 }
 
+int ir_raw_gen_manchester(struct ir_raw_event **ev, unsigned int max,
+			  const struct ir_raw_timings_manchester *timings,
+			  unsigned int n, unsigned int data)
+{
+	bool need_pulse;
+	int i, count = 0;
+	i = 1 << (n - 1);
+
+	if (n > max || max < 3)
+		return -EINVAL;
+
+	if (timings->pulse_space_start) {
+		init_ir_raw_event_duration((*ev)++, 1, timings->clock);
+		init_ir_raw_event_duration((*ev), 0, timings->clock);
+		count += 2;
+	} else {
+		init_ir_raw_event_duration((*ev), 1, timings->clock);
+		count++;
+	}
+	i >>= 1;
+
+	while (i > 0) {
+		need_pulse = !(data & i);
+		if (need_pulse == !!(*ev)->pulse) {
+			(*ev)->duration += timings->clock;
+		} else {
+			init_ir_raw_event_duration(++(*ev), need_pulse,
+						   timings->clock);
+			count++;
+		}
+
+		if (count >= max)
+			return -EINVAL;
+
+		init_ir_raw_event_duration(++(*ev), !need_pulse,
+					   timings->clock);
+		count++;
+		i >>= 1;
+	}
+
+	if (timings->trailer_space) {
+		if (!(*ev)->pulse) {
+			(*ev)->duration += timings->trailer_space;
+		} else if (count < max) {
+			init_ir_raw_event_duration(++(*ev), 0,
+						   timings->trailer_space);
+			count++;
+		} else {
+			return -EINVAL;
+		}
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL(ir_raw_gen_manchester);
+
 int ir_raw_gen_pd(struct ir_raw_event **ev, unsigned int max,
 		  const struct ir_raw_timings_pd *timings,
 		  unsigned int n, unsigned int data)
diff --git a/drivers/media/rc/rc-core-priv.h b/drivers/media/rc/rc-core-priv.h
index 3bf8c7b..df3ab46 100644
--- a/drivers/media/rc/rc-core-priv.h
+++ b/drivers/media/rc/rc-core-priv.h
@@ -173,6 +173,22 @@ static inline void ir_raw_gen_pulse_space(struct ir_raw_event **ev,
 }
 
 /**
+ * struct ir_raw_timings_manchester - manchester coding timings
+ * @pulse_space_start:	1 for starting with pulse (0 for starting with space)
+ * @clock:		duration of each pulse/space in ns
+ * @trailer_space:	duration of trailer space in ns
+ */
+struct ir_raw_timings_manchester {
+	unsigned int pulse_space_start:1;
+	unsigned int clock;
+	unsigned int trailer_space;
+};
+
+int ir_raw_gen_manchester(struct ir_raw_event **ev, unsigned int max,
+			  const struct ir_raw_timings_manchester *timings,
+			  unsigned int n, unsigned int data);
+
+/**
  * struct ir_raw_timings_pd - pulse-distance modulation timings
  * @header_pulse:	duration of header pulse in ns (0 for none)
  * @header_space:	duration of header space in ns
-- 
1.8.3.2

