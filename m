Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([80.229.237.210]:43315 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752008AbcLFKT2 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 6 Dec 2016 05:19:28 -0500
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org
Cc: James Hogan <james@albanarts.com>,
        =?UTF-8?q?Antti=20Sepp=C3=A4l=C3=A4?= <a.seppala@gmail.com>,
        =?UTF-8?q?David=20H=C3=A4rdeman?= <david@hardeman.nu>
Subject: [PATCH v4 07/13] [media] rc: rc-ir-raw: Add pulse-distance modulation helper
Date: Tue,  6 Dec 2016 10:19:15 +0000
Message-Id: <3a5b98ae55a8d6f2df9e852b2250edee41ed398f.1481019109.git.sean@mess.org>
In-Reply-To: <cover.1481019109.git.sean@mess.org>
References: <cover.1481019109.git.sean@mess.org>
In-Reply-To: <cover.1481019109.git.sean@mess.org>
References: <cover.1481019109.git.sean@mess.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: James Hogan <james@albanarts.com>

Add IR encoding helper for pulse-distance modulation as used by the NEC
protocol.

Signed-off-by: James Hogan <james@albanarts.com>
Signed-off-by: Sean Young <sean@mess.org>
Cc: Antti Seppälä <a.seppala@gmail.com>
Cc: David Härdeman <david@hardeman.nu>
---
 drivers/media/rc/rc-core-priv.h | 52 ++++++++++++++++++++++++++++++++++++++
 drivers/media/rc/rc-ir-raw.c    | 56 +++++++++++++++++++++++++++++++++++++++++
 2 files changed, 108 insertions(+)

diff --git a/drivers/media/rc/rc-core-priv.h b/drivers/media/rc/rc-core-priv.h
index b175bf3..0680e10 100644
--- a/drivers/media/rc/rc-core-priv.h
+++ b/drivers/media/rc/rc-core-priv.h
@@ -190,6 +190,58 @@ int ir_raw_gen_manchester(struct ir_raw_event **ev, unsigned int max,
 			  const struct ir_raw_timings_manchester *timings,
 			  unsigned int n, unsigned int data);
 
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
diff --git a/drivers/media/rc/rc-ir-raw.c b/drivers/media/rc/rc-ir-raw.c
index 072b4bd..5d299f6 100644
--- a/drivers/media/rc/rc-ir-raw.c
+++ b/drivers/media/rc/rc-ir-raw.c
@@ -335,6 +335,62 @@ int ir_raw_gen_manchester(struct ir_raw_event **ev, unsigned int max,
 EXPORT_SYMBOL(ir_raw_gen_manchester);
 
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
  * @protocol:		protocol
-- 
2.9.3

