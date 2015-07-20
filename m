Return-path: <linux-media-owner@vger.kernel.org>
Received: from vader.hardeman.nu ([95.142.160.32]:52572 "EHLO hardeman.nu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753674AbbGTTQ6 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Jul 2015 15:16:58 -0400
Subject: [PATCH 6/7] [PATCH FIXES] Revert "[media] rc: rc-ir-raw: Add
 Manchester encoder (phase encoder) helper"
From: David =?utf-8?b?SMOkcmRlbWFu?= <david@hardeman.nu>
To: linux-media@vger.kernel.org
Cc: m.chehab@samsung.com
Date: Mon, 20 Jul 2015 21:16:56 +0200
Message-ID: <20150720191656.24633.55454.stgit@zeus.muc.hardeman.nu>
In-Reply-To: <20150720191238.24633.85293.stgit@zeus.muc.hardeman.nu>
References: <20150720191238.24633.85293.stgit@zeus.muc.hardeman.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This reverts commit 1d971d927efa2e10194c96ed0475b6d6054342d8.

The current code is not mature enough, the API should allow a single
protocol to be specified. Also, the current code contains heuristics
that will depend on module load order.

Signed-off-by: David Härdeman <david@hardeman.nu>
---
 drivers/media/rc/rc-core-priv.h |   33 ---------------
 drivers/media/rc/rc-ir-raw.c    |   85 ---------------------------------------
 2 files changed, 118 deletions(-)

diff --git a/drivers/media/rc/rc-core-priv.h b/drivers/media/rc/rc-core-priv.h
index 5266ecc7..122c25f 100644
--- a/drivers/media/rc/rc-core-priv.h
+++ b/drivers/media/rc/rc-core-priv.h
@@ -152,39 +152,6 @@ static inline bool is_timing_event(struct ir_raw_event ev)
 #define TO_US(duration)			DIV_ROUND_CLOSEST((duration), 1000)
 #define TO_STR(is_pulse)		((is_pulse) ? "pulse" : "space")
 
-/* functions for IR encoders */
-
-static inline void init_ir_raw_event_duration(struct ir_raw_event *ev,
-					      unsigned int pulse,
-					      u32 duration)
-{
-	init_ir_raw_event(ev);
-	ev->duration = duration;
-	ev->pulse = pulse;
-}
-
-/**
- * struct ir_raw_timings_manchester - Manchester coding timings
- * @leader:		duration of leader pulse (if any) 0 if continuing
- *			existing signal (see @pulse_space_start)
- * @pulse_space_start:	1 for starting with pulse (0 for starting with space)
- * @clock:		duration of each pulse/space in ns
- * @invert:		if set clock logic is inverted
- *			(0 = space + pulse, 1 = pulse + space)
- * @trailer_space:	duration of trailer space in ns
- */
-struct ir_raw_timings_manchester {
-	unsigned int leader;
-	unsigned int pulse_space_start:1;
-	unsigned int clock;
-	unsigned int invert:1;
-	unsigned int trailer_space;
-};
-
-int ir_raw_gen_manchester(struct ir_raw_event **ev, unsigned int max,
-			  const struct ir_raw_timings_manchester *timings,
-			  unsigned int n, unsigned int data);
-
 /*
  * Routines from rc-raw.c to be used internally and by decoders
  */
diff --git a/drivers/media/rc/rc-ir-raw.c b/drivers/media/rc/rc-ir-raw.c
index 72dd6b6..f426f16 100644
--- a/drivers/media/rc/rc-ir-raw.c
+++ b/drivers/media/rc/rc-ir-raw.c
@@ -247,91 +247,6 @@ static int change_protocol(struct rc_dev *dev, u64 *rc_type)
 }
 
 /**
- * ir_raw_gen_manchester() - Encode data with Manchester (bi-phase) modulation.
- * @ev:		Pointer to pointer to next free event. *@ev is incremented for
- *		each raw event filled.
- * @max:	Maximum number of raw events to fill.
- * @timings:	Manchester modulation timings.
- * @n:		Number of bits of data.
- * @data:	Data bits to encode.
- *
- * Encodes the @n least significant bits of @data using Manchester (bi-phase)
- * modulation with the timing characteristics described by @timings, writing up
- * to @max raw IR events using the *@ev pointer.
- *
- * Returns:	0 on success.
- *		-ENOBUFS if there isn't enough space in the array to fit the
- *		full encoded data. In this case all @max events will have been
- *		written.
- */
-int ir_raw_gen_manchester(struct ir_raw_event **ev, unsigned int max,
-			  const struct ir_raw_timings_manchester *timings,
-			  unsigned int n, unsigned int data)
-{
-	bool need_pulse;
-	unsigned int i;
-	int ret = -ENOBUFS;
-
-	i = 1 << (n - 1);
-
-	if (timings->leader) {
-		if (!max--)
-			return ret;
-		if (timings->pulse_space_start) {
-			init_ir_raw_event_duration((*ev)++, 1, timings->leader);
-
-			if (!max--)
-				return ret;
-			init_ir_raw_event_duration((*ev), 0, timings->leader);
-		} else {
-			init_ir_raw_event_duration((*ev), 1, timings->leader);
-		}
-		i >>= 1;
-	} else {
-		/* continue existing signal */
-		--(*ev);
-	}
-	/* from here on *ev will point to the last event rather than the next */
-
-	while (n && i > 0) {
-		need_pulse = !(data & i);
-		if (timings->invert)
-			need_pulse = !need_pulse;
-		if (need_pulse == !!(*ev)->pulse) {
-			(*ev)->duration += timings->clock;
-		} else {
-			if (!max--)
-				goto nobufs;
-			init_ir_raw_event_duration(++(*ev), need_pulse,
-						   timings->clock);
-		}
-
-		if (!max--)
-			goto nobufs;
-		init_ir_raw_event_duration(++(*ev), !need_pulse,
-					   timings->clock);
-		i >>= 1;
-	}
-
-	if (timings->trailer_space) {
-		if (!(*ev)->pulse)
-			(*ev)->duration += timings->trailer_space;
-		else if (!max--)
-			goto nobufs;
-		else
-			init_ir_raw_event_duration(++(*ev), 0,
-						   timings->trailer_space);
-	}
-
-	ret = 0;
-nobufs:
-	/* point to the next event rather than last event before returning */
-	++(*ev);
-	return ret;
-}
-EXPORT_SYMBOL(ir_raw_gen_manchester);
-
-/**
  * ir_raw_encode_scancode() - Encode a scancode as raw events
  *
  * @protocols:		permitted protocols

