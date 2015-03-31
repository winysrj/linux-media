Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f182.google.com ([209.85.217.182]:36451 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752285AbbCaRs5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 31 Mar 2015 13:48:57 -0400
Received: by lbbug6 with SMTP id ug6so18245085lbb.3
        for <linux-media@vger.kernel.org>; Tue, 31 Mar 2015 10:48:55 -0700 (PDT)
From: =?UTF-8?q?Antti=20Sepp=C3=A4l=C3=A4?= <a.seppala@gmail.com>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	=?UTF-8?q?Antti=20Sepp=C3=A4l=C3=A4?= <a.seppala@gmail.com>,
	James Hogan <james@albanarts.com>,
	=?UTF-8?q?David=20H=C3=A4rdeman?= <david@hardeman.nu>
Subject: [PATCH v3 2/7] rc: rc-ir-raw: Add Manchester encoder (phase encoder) helper
Date: Tue, 31 Mar 2015 20:48:07 +0300
Message-Id: <1427824092-23163-3-git-send-email-a.seppala@gmail.com>
In-Reply-To: <1427824092-23163-1-git-send-email-a.seppala@gmail.com>
References: <1427824092-23163-1-git-send-email-a.seppala@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Adding a simple Manchester encoder to rc-core.
Manchester coding is used by at least RC-5 and RC-6 protocols and their
variants.

Signed-off-by: Antti Seppälä <a.seppala@gmail.com>
Signed-off-by: James Hogan <james@albanarts.com>
Cc: David Härdeman <david@hardeman.nu>
---

Notes:
    Changes in v3:
     - Ported to apply against latest media-tree
     - Enhanced to support rc-6 encoding
     - Checkpatch.pl fixes
    
    Changes in v2 (James Hogan):
     - Alter encode API to return -ENOBUFS when there isn't enough buffer
       space. When this occurs all buffer contents must have been written
       with the partial encoding of the scancode. This is to allow drivers
       such as nuvoton-cir to provide a shorter buffer and still get a
       useful partial encoding for the wakeup pattern.
     - Add kerneldoc comment.
     - Add individual buffer full checks, in order to support -ENOBUFS
       properly.
     - Make i unsigned to theoretically support all 32bits of data.
     - Increment *ev at end so caller can calculate correct number of
       events (during the loop *ev points to the last written event to allow
       it to be extended in length).
     - Make start/leader pulse optional, continuing from (*ev)[-1] if
       disabled. This helps support rc-5x which has a space in the middle of
       the bits.

 drivers/media/rc/rc-core-priv.h | 33 ++++++++++++++++
 drivers/media/rc/rc-ir-raw.c    | 85 +++++++++++++++++++++++++++++++++++++++++
 2 files changed, 118 insertions(+)

diff --git a/drivers/media/rc/rc-core-priv.h b/drivers/media/rc/rc-core-priv.h
index 122c25f..5266ecc7 100644
--- a/drivers/media/rc/rc-core-priv.h
+++ b/drivers/media/rc/rc-core-priv.h
@@ -152,6 +152,39 @@ static inline bool is_timing_event(struct ir_raw_event ev)
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
+ * struct ir_raw_timings_manchester - Manchester coding timings
+ * @leader:		duration of leader pulse (if any) 0 if continuing
+ *			existing signal (see @pulse_space_start)
+ * @pulse_space_start:	1 for starting with pulse (0 for starting with space)
+ * @clock:		duration of each pulse/space in ns
+ * @invert:		if set clock logic is inverted
+ *			(0 = space + pulse, 1 = pulse + space)
+ * @trailer_space:	duration of trailer space in ns
+ */
+struct ir_raw_timings_manchester {
+	unsigned int leader;
+	unsigned int pulse_space_start:1;
+	unsigned int clock;
+	unsigned int invert:1;
+	unsigned int trailer_space;
+};
+
+int ir_raw_gen_manchester(struct ir_raw_event **ev, unsigned int max,
+			  const struct ir_raw_timings_manchester *timings,
+			  unsigned int n, unsigned int data);
+
 /*
  * Routines from rc-raw.c to be used internally and by decoders
  */
diff --git a/drivers/media/rc/rc-ir-raw.c b/drivers/media/rc/rc-ir-raw.c
index dd47fe5..6c9580e 100644
--- a/drivers/media/rc/rc-ir-raw.c
+++ b/drivers/media/rc/rc-ir-raw.c
@@ -247,6 +247,91 @@ static int change_protocol(struct rc_dev *dev, u64 *rc_type)
 }
 
 /**
+ * ir_raw_gen_manchester() - Encode data with Manchester (bi-phase) modulation.
+ * @ev:		Pointer to pointer to next free event. *@ev is incremented for
+ *		each raw event filled.
+ * @max:	Maximum number of raw events to fill.
+ * @timings:	Manchester modulation timings.
+ * @n:		Number of bits of data.
+ * @data:	Data bits to encode.
+ *
+ * Encodes the @n least significant bits of @data using Manchester (bi-phase)
+ * modulation with the timing characteristics described by @timings, writing up
+ * to @max raw IR events using the *@ev pointer.
+ *
+ * Returns:	0 on success.
+ *		-ENOBUFS if there isn't enough space in the array to fit the
+ *		full encoded data. In this case all @max events will have been
+ *		written.
+ */
+int ir_raw_gen_manchester(struct ir_raw_event **ev, unsigned int max,
+			  const struct ir_raw_timings_manchester *timings,
+			  unsigned int n, unsigned int data)
+{
+	bool need_pulse;
+	unsigned int i;
+	int ret = -ENOBUFS;
+
+	i = 1 << (n - 1);
+
+	if (timings->leader) {
+		if (!max--)
+			return ret;
+		if (timings->pulse_space_start) {
+			init_ir_raw_event_duration((*ev)++, 1, timings->leader);
+
+			if (!max--)
+				return ret;
+			init_ir_raw_event_duration((*ev), 0, timings->leader);
+		} else {
+			init_ir_raw_event_duration((*ev), 1, timings->leader);
+		}
+		i >>= 1;
+	} else {
+		/* continue existing signal */
+		--(*ev);
+	}
+	/* from here on *ev will point to the last event rather than the next */
+
+	while (n && i > 0) {
+		need_pulse = !(data & i);
+		if (timings->invert)
+			need_pulse = !need_pulse;
+		if (need_pulse == !!(*ev)->pulse) {
+			(*ev)->duration += timings->clock;
+		} else {
+			if (!max--)
+				goto nobufs;
+			init_ir_raw_event_duration(++(*ev), need_pulse,
+						   timings->clock);
+		}
+
+		if (!max--)
+			goto nobufs;
+		init_ir_raw_event_duration(++(*ev), !need_pulse,
+					   timings->clock);
+		i >>= 1;
+	}
+
+	if (timings->trailer_space) {
+		if (!(*ev)->pulse)
+			(*ev)->duration += timings->trailer_space;
+		else if (!max--)
+			goto nobufs;
+		else
+			init_ir_raw_event_duration(++(*ev), 0,
+						   timings->trailer_space);
+	}
+
+	ret = 0;
+nobufs:
+	/* point to the next event rather than last event before returning */
+	++(*ev);
+	return ret;
+}
+EXPORT_SYMBOL(ir_raw_gen_manchester);
+
+/**
  * ir_raw_encode_scancode() - Encode a scancode as raw events
  *
  * @protocols:		permitted protocols
-- 
2.0.5

