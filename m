Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:35916
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1754994AbdFXQEr (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 24 Jun 2017 12:04:47 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH] media: dtv-core.rst: explain how to get DVBv5 statistics
Date: Sat, 24 Jun 2017 13:04:02 -0300
Message-Id: <77f1f992f8069c870ac7e8867dcbfb3ea09209d7.1498320233.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

It is not trivial to implement the logic that collects DVBv5
statistics. As we're seein lately too many implementations
that are not quite right when reviewing patchsets, add a
detailed explanation, adding a few examples about the right
thing to be done.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/media/kapi/dtv-core.rst | 279 ++++++++++++++++++++++++++++++++++
 1 file changed, 279 insertions(+)

diff --git a/Documentation/media/kapi/dtv-core.rst b/Documentation/media/kapi/dtv-core.rst
index ff86bf0abeae..bec7875a7e2e 100644
--- a/Documentation/media/kapi/dtv-core.rst
+++ b/Documentation/media/kapi/dtv-core.rst
@@ -74,6 +74,285 @@ part of their handler for :c:type:`device_driver`.\ ``resume()``.
 
 A few other optional functions are provided to handle some special cases.
 
+Digital TV Frontend statistics
+~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+
+Introduction
+^^^^^^^^^^^^
+
+Digital TV frontends provide a range of
+:ref:`statistics <frontend-stat-properties>` meant to help tuning the device
+and measuring the quality of service.
+
+For each statistics measurement, the driver should set the type of scale used,
+or ``FE_SCALE_NOT_AVAILABLE`` if the statistics is not available on a given
+time. Drivers should also provide the number of statistics for each type.
+that's usually 1 for most video standards [#f1]_.
+
+Drivers should initialize each statistic counters with length and
+scale at its init code. For example, if the frontend provides signal
+strength, it should have, on its init code::
+
+	struct dtv_frontend_properties *c = &state->fe.dtv_property_cache;
+
+	c->strength.len = 1;
+	c->strength.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
+
+And, when the statistics got updated, set the scale::
+
+	c->strength.stat[0].scale = FE_SCALE_DECIBEL;
+	c->strength.stat[0].uvalue = strength;
+
+.. [#f1] For ISDB-T, it may provide both a global statistics and a per-layer
+   set of statistics. On such cases, len should be equal to 4. The first
+   value corresponds to the global stat; the other ones to each layer, e. g.:
+
+   - c->cnr.stat[0] for global S/N carrier ratio,
+   - c->cnr.stat[1] for Layer A S/N carrier ratio,
+   - c->cnr.stat[2] for layer B S/N carrier ratio,
+   - c->cnr.stat[3] for layer C S/N carrier ratio.
+
+.. note:: Please prefer to use ``FE_SCALE_DECIBEL`` instead of
+   ``FE_SCALE_RELATIVE`` for signal strength and CNR measurements.
+
+Groups of statistics
+^^^^^^^^^^^^^^^^^^^^
+
+There are several groups of statistics currently supported:
+
+Signal strength (:ref:`DTV-STAT-SIGNAL-STRENGTH`)
+  - Measures the signal strength level at the analog part of the tuner or
+    demod.
+
+  - Typically obtained from the gain applied to the tuner and/or frontend
+    in order to detect the carrier. When no carrier is detected, the gain is
+    at the maximum value (so, strength is on its minimal).
+
+  - As the gain is visible through the set of registers that adjust the gain,
+    typically, this statistics is always available [#f2]_.
+
+  - Drivers should try to make it available all the times, as this statistics
+    can be used when adjusting an antenna position and to check for troubles
+    at the cabling.
+
+  .. [#f2] On a few devices, the gain keeps floating if no carrier.
+     On such devices, strength report should check first if carrier is
+     detected at the tuner (``FE_HAS_CARRIER``, see :c:type:`fe_status`),
+     and otherwise return the lowest possible value.
+
+Carrier Signal to Noise ratio (:ref:`DTV-STAT-CNR`)
+  - Signal to Noise ratio for the main carrier.
+
+  - Signal to Noise measurement depends on the device. On some hardware, is
+    available when the main carrier is detected. On those hardware, CNR
+    measurement usually comes from the tuner (e. g. after ``FE_HAS_CARRIER``,
+    see :c:type:`fe_status`).
+
+    On other devices, it requires inner FEC decoding,
+    as the frontend measures it indirectly from other parameters (e. g. after
+    ``FE_HAS_VITERBI``, see :c:type:`fe_status`).
+
+    Having it available after inner FEC is more common.
+
+Bit counts post-FEC (:ref:`DTV-STAT-POST-ERROR-BIT-COUNT` and :ref:`DTV-STAT-POST-TOTAL-BIT-COUNT`)
+  - Those counters measure the number of bits and bit errors errors after
+    the forward error correction (FEC) on the inner coding block
+    (after Viterbi, LDPC or other inner code).
+
+  - Due to its nature, those statistics depend on full coding lock
+    (e. g. after ``FE_HAS_SYNC`` or after ``FE_HAS_LOCK``,
+    see :c:type:`fe_status`).
+
+Bit counts pre-FEC (:ref:`DTV-STAT-PRE-ERROR-BIT-COUNT` and :ref:`DTV-STAT-PRE-TOTAL-BIT-COUNT`)
+  - Those counters measure the number of bits and bit errors errors before
+    the forward error correction (FEC) on the inner coding block
+    (before Viterbi, LDPC or other inner code).
+
+  - Not all frontends provide this kind of statistics.
+
+  - Due to its nature, those statistics depend on inner coding lock (e. g.
+    after ``FE_HAS_VITERBI``, see :c:type:`fe_status`).
+
+Block counts (:ref:`DTV-STAT-ERROR-BLOCK-COUNT` and :ref:`DTV-STAT-TOTAL-BLOCK-COUNT`)
+  - Those counters measure the number of blocks and block errors errors after
+    the forward error correction (FEC) on the inner coding block
+    (before Viterbi, LDPC or other inner code).
+
+  - Due to its nature, those statistics depend on full coding lock
+    (e. g. after ``FE_HAS_SYNC`` or after
+    ``FE_HAS_LOCK``, see :c:type:`fe_status`).
+
+.. note:: All counters should be monotonically increased as they're
+   collected from the hardware.
+
+A typical example of the logic that handle status and statistics is::
+
+	static int foo_get_status_and_stats(struct dvb_frontend *fe)
+	{
+		struct foo_state *state = fe->demodulator_priv;
+		struct dtv_frontend_properties *c = &fe->dtv_property_cache;
+
+		int rc;
+		enum fe_status *status;
+
+		/* Both status and strength are always available */
+		rc = foo_read_status(fe, &status);
+		if (rc < 0)
+			return rc;
+
+		rc = foo_read_strength(fe);
+		if (rc < 0)
+			return rc;
+
+		/* Check if CNR is available */
+		if (!(fe->status & FE_HAS_CARRIER))
+			return 0;
+
+		rc = foo_read_cnr(fe);
+		if (rc < 0)
+			return rc;
+
+		/* Check if pre-BER stats are available */
+		if (!(fe->status & FE_HAS_VITERBI))
+			return 0;
+
+		rc = foo_get_pre_ber(fe);
+		if (rc < 0)
+			return rc;
+
+		/* Check if post-BER stats are available */
+		if (!(fe->status & FE_HAS_SYNC))
+			return 0;
+
+		rc = foo_get_post_ber(fe);
+		if (rc < 0)
+			return rc;
+	}
+
+	static const struct dvb_frontend_ops ops = {
+		/* ... */
+		.read_status = foo_get_status_and_stats,
+	};
+
+Statistics collect
+^^^^^^^^^^^^^^^^^^
+
+On almost all frontend hardware, the bit and byte counts are stored by
+the hardware after a certain amount of time or after the total bit/block
+counter reaches a certain value (usually programable), for example, on
+every 1000 ms or after receiving 1,000,000 bits.
+
+So, if you read the registers too soon, you'll end by reading the same
+value as in the previous reading, causing the monotonic value to be
+incremented too often.
+
+Drivers should take the responsibility to avoid too often reads. That
+can be done using two approaches:
+
+if the driver have a bit that indicates when a collected data is ready
+%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
+
+Driver should check such bit before making the statistics available.
+
+An example of such behavior can be found at this code snippet (adapted
+from mb86a20s driver's logic)::
+
+	static int foo_get_pre_ber(struct dvb_frontend *fe)
+	{
+		struct foo_state *state = fe->demodulator_priv;
+		struct dtv_frontend_properties *c = &fe->dtv_property_cache;
+		int rc, bit_error;
+
+		/* Check if the BER measures are already available */
+		rc = foo_read_u8(state, 0x54);
+		if (rc < 0)
+			return rc;
+
+		if (!rc)
+			return 0;
+
+		/* Read Bit Error Count */
+		bit_error = foo_read_u32(state, 0x55);
+		if (bit_error < 0)
+			return bit_error;
+
+		/* Read Total Bit Count */
+		rc = foo_read_u32(state, 0x51);
+		if (rc < 0)
+			return rc;
+
+		c->pre_bit_error.stat[0].scale = FE_SCALE_COUNTER;
+		c->pre_bit_error.stat[0].uvalue += bit_error;
+		c->pre_bit_count.stat[0].scale = FE_SCALE_COUNTER;
+		c->pre_bit_count.stat[0].uvalue += rc;
+
+		return 0;
+	}
+
+If the driver doesn't provide a statistics available check bit
+%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
+
+A few devices, however, may not provide a way to check if the stats are
+available (or the way to check it is unknown). They may not even provide
+a way to directly read the total number of bits or blocks.
+
+On those devices, the driver need to ensure that it won't be reading from
+the register too often and/or estimate the total number of bits/blocks.
+
+On such drivers, a typical routine to get statistics would be like
+(adapted from dib8000 driver's logic)::
+
+	struct foo_state {
+		/* ... */
+
+		unsigned long per_jiffies_stats;
+	}
+
+	static int foo_get_pre_ber(struct dvb_frontend *fe)
+	{
+		struct foo_state *state = fe->demodulator_priv;
+		struct dtv_frontend_properties *c = &fe->dtv_property_cache;
+		int rc, bit_error;
+		u64 bits;
+
+		/* Check if time for stats was elapsed */
+		if (!time_after(jiffies, state->per_jiffies_stats))
+			return 0;
+
+		/* Next stat should be collected in 1000 ms */
+		state->per_jiffies_stats = jiffies + msecs_to_jiffies(1000);
+
+		/* Read Bit Error Count */
+		bit_error = foo_read_u32(state, 0x55);
+		if (bit_error < 0)
+			return bit_error;
+
+		/*
+		 * On this particular frontend, there's no register that
+		 * would provide the number of bits per 1000ms sample. So,
+		 * some function would calculate it based on DTV properties
+		 */
+		bits = get_number_of_bits_per_1000ms(fe);
+
+		c->pre_bit_error.stat[0].scale = FE_SCALE_COUNTER;
+		c->pre_bit_error.stat[0].uvalue += bit_error;
+		c->pre_bit_count.stat[0].scale = FE_SCALE_COUNTER;
+		c->pre_bit_count.stat[0].uvalue += bits;
+
+		return 0;
+	}
+
+Please notice that, on both cases, we're getting the statistics using the
+:c:type:`dvb_frontend_ops` ``.read_status`` callback. The rationale is that
+the frontend core will automatically call this function periodically
+(usually, 3 times per second, when the frontend is locked).
+
+That warrants that we won't miss to collect a counter and increment the
+monotonic stats at the right time.
+
+Digital TV Frontend functions and types
+~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+
 .. kernel-doc:: drivers/media/dvb-core/dvb_frontend.h
 
 
-- 
2.9.4
