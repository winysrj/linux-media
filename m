Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:41631 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755110AbaCNXG5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 14 Mar 2014 19:06:57 -0400
Received: by mail-wg0-f44.google.com with SMTP id m15so2672615wgh.15
        for <linux-media@vger.kernel.org>; Fri, 14 Mar 2014 16:06:56 -0700 (PDT)
From: James Hogan <james@albanarts.com>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	=?UTF-8?q?Antti=20Sepp=C3=A4l=C3=A4?= <a.seppala@gmail.com>
Cc: linux-media@vger.kernel.org, James Hogan <james@albanarts.com>,
	=?UTF-8?q?David=20H=C3=A4rdeman?= <david@hardeman.nu>
Subject: [PATCH v2 2/9] rc: ir-raw: Add pulse-distance modulation helper
Date: Fri, 14 Mar 2014 23:04:12 +0000
Message-Id: <1394838259-14260-3-git-send-email-james@albanarts.com>
In-Reply-To: <1394838259-14260-1-git-send-email-james@albanarts.com>
References: <1394838259-14260-1-git-send-email-james@albanarts.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add IR encoding helper for pulse-distance modulation as used by the NEC
protocol.

Signed-off-by: James Hogan <james@albanarts.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Antti Seppälä <a.seppala@gmail.com>
Cc: David Härdeman <david@hardeman.nu>
---
Changes in v2:
 - Alter encode API to return -ENOBUFS when there isn't enough buffer
   space. When this occurs all buffer contents must have been written
   with the partial encoding of the scancode. This is to allow drivers
   such as nuvoton-cir to provide a shorter buffer and still get a
   useful partial encoding for the wakeup pattern.
 - Update ir_raw_gen_pd() with a kerneldoc comment and individual buffer
   full checks rather than a single one at the beginning, in order to
   support -ENOBUFS properly.
 - Update ir_raw_gen_pulse_space() to check the number of free slots and
   fill as many as possible before returning -ENOBUFS.
 - Fix brace placement for timings struct.
---
 drivers/media/rc/ir-raw.c       | 56 ++++++++++++++++++++++++++++++++++++
 drivers/media/rc/rc-core-priv.h | 63 +++++++++++++++++++++++++++++++++++++++++
 2 files changed, 119 insertions(+)

diff --git a/drivers/media/rc/ir-raw.c b/drivers/media/rc/ir-raw.c
index 01adc10..f8fe10e 100644
--- a/drivers/media/rc/ir-raw.c
+++ b/drivers/media/rc/ir-raw.c
@@ -241,6 +241,62 @@ ir_raw_get_allowed_protocols(void)
 }
 
 /**
+ * ir_raw_gen_pd() - Encode data to raw events with pulse-distance modulation.
+ * @ev:		Pointer to pointer to next free event. *@ev is incremented for
+ *		each raw event filled.
+ * @max:	Maximum number of raw events to fill.
+ * @timings:	Pulse distance modulation timings.
+ * @n:		Number of bits of data.
+ * @data:	Data bits to encode.
+ *
+ * Encodes the @n least significant bits of @data using pulse-distance
+ * modulation with the timing characteristics described by @timings, writing up
+ * to @max raw IR events using the *@ev pointer.
+ *
+ * Returns:	0 on success.
+ *		-ENOBUFS if there isn't enough space in the array to fit the
+ *		full encoded data. In this case all @max events will have been
+ *		written.
+ */
+int ir_raw_gen_pd(struct ir_raw_event **ev, unsigned int max,
+		  const struct ir_raw_timings_pd *timings,
+		  unsigned int n, unsigned int data)
+{
+	int i;
+	int ret;
+
+	if (timings->header_pulse) {
+		ret = ir_raw_gen_pulse_space(ev, &max, timings->header_pulse,
+					     timings->header_space);
+		if (ret)
+			return ret;
+	}
+
+	if (timings->msb_first) {
+		for (i = n - 1; i >= 0; --i) {
+			ret = ir_raw_gen_pulse_space(ev, &max,
+					timings->bit_pulse,
+					timings->bit_space[(data >> i) & 1]);
+			if (ret)
+				return ret;
+		}
+	} else {
+		for (i = 0; i < n; ++i, data >>= 1) {
+			ret = ir_raw_gen_pulse_space(ev, &max,
+					timings->bit_pulse,
+					timings->bit_space[data & 1]);
+			if (ret)
+				return ret;
+		}
+	}
+
+	ret = ir_raw_gen_pulse_space(ev, &max, timings->trailer_pulse,
+				     timings->trailer_space);
+	return ret;
+}
+EXPORT_SYMBOL(ir_raw_gen_pd);
+
+/**
  * ir_raw_encode_scancode() - Encode a scancode as raw events
  *
  * @protocols:		permitted protocols
diff --git a/drivers/media/rc/rc-core-priv.h b/drivers/media/rc/rc-core-priv.h
index 8afb971..b55ae24 100644
--- a/drivers/media/rc/rc-core-priv.h
+++ b/drivers/media/rc/rc-core-priv.h
@@ -153,6 +153,69 @@ static inline bool is_timing_event(struct ir_raw_event ev)
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
+/**
+ * ir_raw_gen_pulse_space() - generate pulse and space raw events.
+ * @ev:			Pointer to pointer to next free raw event.
+ *			Will be incremented for each raw event written.
+ * @max:		Pointer to number of raw events available in buffer.
+ *			Will be decremented for each raw event written.
+ * @pulse_width:	Width of pulse in ns.
+ * @space_width:	Width of space in ns.
+ *
+ * Returns:	0 on success.
+ *		-ENOBUFS if there isn't enough buffer space to write both raw
+ *		events. In this case @max events will have been written.
+ */
+static inline int ir_raw_gen_pulse_space(struct ir_raw_event **ev,
+					 unsigned int *max,
+					 unsigned int pulse_width,
+					 unsigned int space_width)
+{
+	if (!*max)
+		return -ENOBUFS;
+	init_ir_raw_event_duration((*ev)++, 1, pulse_width);
+	if (!--*max)
+		return -ENOBUFS;
+	init_ir_raw_event_duration((*ev)++, 0, space_width);
+	--*max;
+	return 0;
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
+struct ir_raw_timings_pd {
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

