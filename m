Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f177.google.com ([74.125.82.177]:51916 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754985AbaCNXG6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 14 Mar 2014 19:06:58 -0400
Received: by mail-we0-f177.google.com with SMTP id u57so2703976wes.36
        for <linux-media@vger.kernel.org>; Fri, 14 Mar 2014 16:06:57 -0700 (PDT)
From: James Hogan <james@albanarts.com>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	=?UTF-8?q?Antti=20Sepp=C3=A4l=C3=A4?= <a.seppala@gmail.com>
Cc: linux-media@vger.kernel.org, James Hogan <james@albanarts.com>,
	=?UTF-8?q?David=20H=C3=A4rdeman?= <david@hardeman.nu>
Subject: [PATCH v2 3/9] rc: ir-raw: Add Manchester encoder (phase encoder) helper
Date: Fri, 14 Mar 2014 23:04:13 +0000
Message-Id: <1394838259-14260-4-git-send-email-james@albanarts.com>
In-Reply-To: <1394838259-14260-1-git-send-email-james@albanarts.com>
References: <1394838259-14260-1-git-send-email-james@albanarts.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Antti Seppälä <a.seppala@gmail.com>

Adding a simple Manchester encoder to rc-core.
Manchester coding is used by at least RC-5 protocol and its variants.

Signed-off-by: Antti Seppälä <a.seppala@gmail.com>
Signed-off-by: James Hogan <james@albanarts.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: David Härdeman <david@hardeman.nu>
---
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
---
 drivers/media/rc/ir-raw.c       | 82 +++++++++++++++++++++++++++++++++++++++++
 drivers/media/rc/rc-core-priv.h | 19 ++++++++++
 2 files changed, 101 insertions(+)

diff --git a/drivers/media/rc/ir-raw.c b/drivers/media/rc/ir-raw.c
index f8fe10e..4310e82 100644
--- a/drivers/media/rc/ir-raw.c
+++ b/drivers/media/rc/ir-raw.c
@@ -241,6 +241,88 @@ ir_raw_get_allowed_protocols(void)
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
+	i = 1 << (n - 1);
+
+	if (timings->leader) {
+		if (!max--)
+			return ret;
+		if (timings->pulse_space_start) {
+			init_ir_raw_event_duration((*ev)++, 1, timings->clock);
+
+			if (!max--)
+				return ret;
+			init_ir_raw_event_duration((*ev), 0, timings->clock);
+		} else {
+			init_ir_raw_event_duration((*ev), 1, timings->clock);
+		}
+		i >>= 1;
+	} else {
+		/* continue existing signal */
+		--(*ev);
+	}
+	/* from here on *ev will point to the last event rather than the next */
+
+	while (i > 0) {
+		need_pulse = !(data & i);
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
  * ir_raw_gen_pd() - Encode data to raw events with pulse-distance modulation.
  * @ev:		Pointer to pointer to next free event. *@ev is incremented for
  *		each raw event filled.
diff --git a/drivers/media/rc/rc-core-priv.h b/drivers/media/rc/rc-core-priv.h
index b55ae24..c45b797 100644
--- a/drivers/media/rc/rc-core-priv.h
+++ b/drivers/media/rc/rc-core-priv.h
@@ -193,6 +193,25 @@ static inline int ir_raw_gen_pulse_space(struct ir_raw_event **ev,
 }
 
 /**
+ * struct ir_raw_timings_manchester - Manchester coding timings
+ * @leader:		1 if a leader bit is required (see @pulse_space_start)
+ *			0 if continuing existing signal
+ * @pulse_space_start:	1 for starting with pulse (0 for starting with space)
+ * @clock:		duration of each pulse/space in ns
+ * @trailer_space:	duration of trailer space in ns
+ */
+struct ir_raw_timings_manchester {
+	unsigned int leader:1;
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

