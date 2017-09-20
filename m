Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:50392
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751735AbdITTMF (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 20 Sep 2017 15:12:05 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 07/25] media: dtv-core.rst: split into multiple files
Date: Wed, 20 Sep 2017 16:11:32 -0300
Message-Id: <50810fd317c71c6c2666da5cded827eb032bc69e.1505933919.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1505933919.git.mchehab@s-opensource.com>
References: <cover.1505933919.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1505933919.git.mchehab@s-opensource.com>
References: <cover.1505933919.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Instead of document all kAPI into a single file, split it
on multiple ones. That makes easier to maintain each part.

As a side effect, it will produce multiple html pages, with
is a good idea.

No changes at the text. Just some chapter levels changed.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/media/kapi/dtv-ca.rst       |   4 +
 Documentation/media/kapi/dtv-common.rst   |  55 +++
 Documentation/media/kapi/dtv-core.rst     | 585 +-----------------------------
 Documentation/media/kapi/dtv-demux.rst    |  71 ++++
 Documentation/media/kapi/dtv-frontend.rst | 443 ++++++++++++++++++++++
 5 files changed, 579 insertions(+), 579 deletions(-)
 create mode 100644 Documentation/media/kapi/dtv-ca.rst
 create mode 100644 Documentation/media/kapi/dtv-common.rst
 create mode 100644 Documentation/media/kapi/dtv-demux.rst
 create mode 100644 Documentation/media/kapi/dtv-frontend.rst

diff --git a/Documentation/media/kapi/dtv-ca.rst b/Documentation/media/kapi/dtv-ca.rst
new file mode 100644
index 000000000000..a4dd700189b0
--- /dev/null
+++ b/Documentation/media/kapi/dtv-ca.rst
@@ -0,0 +1,4 @@
+Digital TV Conditional Access kABI
+----------------------------------
+
+.. kernel-doc:: drivers/media/dvb-core/dvb_ca_en50221.h
diff --git a/Documentation/media/kapi/dtv-common.rst b/Documentation/media/kapi/dtv-common.rst
new file mode 100644
index 000000000000..40cf1033b5e1
--- /dev/null
+++ b/Documentation/media/kapi/dtv-common.rst
@@ -0,0 +1,55 @@
+Digital TV Common functions
+---------------------------
+
+Math functions
+~~~~~~~~~~~~~~
+
+Provide some commonly-used math functions, usually required in order to
+estimate signal strength and signal to noise measurements in dB.
+
+.. kernel-doc:: drivers/media/dvb-core/dvb_math.h
+
+
+DVB devices
+~~~~~~~~~~~
+
+Those functions are responsible for handling the DVB device nodes.
+
+.. kernel-doc:: drivers/media/dvb-core/dvbdev.h
+
+Digital TV Ring buffer
+~~~~~~~~~~~~~~~~~~~~~~
+
+Those routines implement ring buffers used to handle digital TV data and
+copy it from/to userspace.
+
+.. note::
+
+  1) For performance reasons read and write routines don't check buffer sizes
+     and/or number of bytes free/available. This has to be done before these
+     routines are called. For example:
+
+   .. code-block:: c
+
+        /* write @buflen: bytes */
+        free = dvb_ringbuffer_free(rbuf);
+        if (free >= buflen)
+                count = dvb_ringbuffer_write(rbuf, buffer, buflen);
+        else
+                /* do something */
+
+        /* read min. 1000, max. @bufsize: bytes */
+        avail = dvb_ringbuffer_avail(rbuf);
+        if (avail >= 1000)
+                count = dvb_ringbuffer_read(rbuf, buffer, min(avail, bufsize));
+        else
+                /* do something */
+
+  2) If there is exactly one reader and one writer, there is no need
+     to lock read or write operations.
+     Two or more readers must be locked against each other.
+     Flushing the buffer counts as a read operation.
+     Resetting the buffer counts as a read and write operation.
+     Two or more writers must be locked against each other.
+
+.. kernel-doc:: drivers/media/dvb-core/dvb_ringbuffer.h
diff --git a/Documentation/media/kapi/dtv-core.rst b/Documentation/media/kapi/dtv-core.rst
index 4cf9cf63bafd..8ee384f61fa0 100644
--- a/Documentation/media/kapi/dtv-core.rst
+++ b/Documentation/media/kapi/dtv-core.rst
@@ -26,584 +26,11 @@ I2C bus.
    abandoned standard, not used anymore) and ATSC version 3.0 current
    proposals. Currently, the DVB subsystem doesn't implement those standards.
 
-Digital TV Common functions
----------------------------
 
-Math functions
-~~~~~~~~~~~~~~
+.. toctree::
+    :maxdepth: 1
 
-Provide some commonly-used math functions, usually required in order to
-estimate signal strength and signal to noise measurements in dB.
-
-.. kernel-doc:: drivers/media/dvb-core/dvb_math.h
-
-
-DVB devices
-~~~~~~~~~~~
-
-Those functions are responsible for handling the DVB device nodes.
-
-.. kernel-doc:: drivers/media/dvb-core/dvbdev.h
-
-Digital TV Ring buffer
-----------------------
-
-Those routines implement ring buffers used to handle digital TV data and
-copy it from/to userspace.
-
-.. note::
-
-  1) For performance reasons read and write routines don't check buffer sizes
-     and/or number of bytes free/available. This has to be done before these
-     routines are called. For example:
-
-   .. code-block:: c
-
-        /* write @buflen: bytes */
-        free = dvb_ringbuffer_free(rbuf);
-        if (free >= buflen)
-                count = dvb_ringbuffer_write(rbuf, buffer, buflen);
-        else
-                /* do something */
-
-        /* read min. 1000, max. @bufsize: bytes */
-        avail = dvb_ringbuffer_avail(rbuf);
-        if (avail >= 1000)
-                count = dvb_ringbuffer_read(rbuf, buffer, min(avail, bufsize));
-        else
-                /* do something */
-
-  2) If there is exactly one reader and one writer, there is no need
-     to lock read or write operations.
-     Two or more readers must be locked against each other.
-     Flushing the buffer counts as a read operation.
-     Resetting the buffer counts as a read and write operation.
-     Two or more writers must be locked against each other.
-
-.. kernel-doc:: drivers/media/dvb-core/dvb_ringbuffer.h
-
-
-Digital TV Frontend kABI
-------------------------
-
-Digital TV Frontend
-~~~~~~~~~~~~~~~~~~~
-
-The Digital TV Frontend kABI defines a driver-internal interface for
-registering low-level, hardware specific driver to a hardware independent
-frontend layer. It is only of interest for Digital TV device driver writers.
-The header file for this API is named ``dvb_frontend.h`` and located in
-``drivers/media/dvb-core``.
-
-Demodulator driver
-^^^^^^^^^^^^^^^^^^
-
-The demodulator driver is responsible to talk with the decoding part of the
-hardware. Such driver should implement :c:type:`dvb_frontend_ops`, with
-tells what type of digital TV standards are supported, and points to a
-series of functions that allow the DVB core to command the hardware via
-the code under ``drivers/media/dvb-core/dvb_frontend.c``.
-
-A typical example of such struct in a driver ``foo`` is::
-
-	static struct dvb_frontend_ops foo_ops = {
-		.delsys = { SYS_DVBT, SYS_DVBT2, SYS_DVBC_ANNEX_A },
-		.info = {
-			.name	= "foo DVB-T/T2/C driver",
-			.caps = FE_CAN_FEC_1_2 |
-				FE_CAN_FEC_2_3 |
-				FE_CAN_FEC_3_4 |
-				FE_CAN_FEC_5_6 |
-				FE_CAN_FEC_7_8 |
-				FE_CAN_FEC_AUTO |
-				FE_CAN_QPSK |
-				FE_CAN_QAM_16 |
-				FE_CAN_QAM_32 |
-				FE_CAN_QAM_64 |
-				FE_CAN_QAM_128 |
-				FE_CAN_QAM_256 |
-				FE_CAN_QAM_AUTO |
-				FE_CAN_TRANSMISSION_MODE_AUTO |
-				FE_CAN_GUARD_INTERVAL_AUTO |
-				FE_CAN_HIERARCHY_AUTO |
-				FE_CAN_MUTE_TS |
-				FE_CAN_2G_MODULATION,
-			.frequency_min = 42000000, /* Hz */
-			.frequency_max = 1002000000, /* Hz */
-			.symbol_rate_min = 870000,
-			.symbol_rate_max = 11700000
-		},
-		.init = foo_init,
-		.sleep = foo_sleep,
-		.release = foo_release,
-		.set_frontend = foo_set_frontend,
-		.get_frontend = foo_get_frontend,
-		.read_status = foo_get_status_and_stats,
-		.tune = foo_tune,
-		.i2c_gate_ctrl = foo_i2c_gate_ctrl,
-		.get_frontend_algo = foo_get_algo,
-	};
-
-A typical example of such struct in a driver ``bar`` meant to be used on
-Satellite TV reception is::
-
-	static const struct dvb_frontend_ops bar_ops = {
-		.delsys = { SYS_DVBS, SYS_DVBS2 },
-		.info = {
-			.name		= "Bar DVB-S/S2 demodulator",
-			.frequency_min	= 500000, /* KHz */
-			.frequency_max	= 2500000, /* KHz */
-			.frequency_stepsize	= 0,
-			.symbol_rate_min = 1000000,
-			.symbol_rate_max = 45000000,
-			.symbol_rate_tolerance = 500,
-			.caps = FE_CAN_INVERSION_AUTO |
-				FE_CAN_FEC_AUTO |
-				FE_CAN_QPSK,
-		},
-		.init = bar_init,
-		.sleep = bar_sleep,
-		.release = bar_release,
-		.set_frontend = bar_set_frontend,
-		.get_frontend = bar_get_frontend,
-		.read_status = bar_get_status_and_stats,
-		.i2c_gate_ctrl = bar_i2c_gate_ctrl,
-		.get_frontend_algo = bar_get_algo,
-		.tune = bar_tune,
-
-		/* Satellite-specific */
-		.diseqc_send_master_cmd = bar_send_diseqc_msg,
-		.diseqc_send_burst = bar_send_burst,
-		.set_tone = bar_set_tone,
-		.set_voltage = bar_set_voltage,
-	};
-
-.. note::
-
-   #) For satellite digital TV standards (DVB-S, DVB-S2, ISDB-S), the
-      frequencies are specified in kHz, while, for terrestrial and cable
-      standards, they're specified in Hz. Due to that, if the same frontend
-      supports both types, you'll need to have two separate
-      :c:type:`dvb_frontend_ops` structures, one for each standard.
-   #) The ``.i2c_gate_ctrl`` field is present only when the hardware has
-      allows controlling an I2C gate (either directly of via some GPIO pin),
-      in order to remove the tuner from the I2C bus after a channel is
-      tuned.
-   #) All new drivers should implement the
-      :ref:`DVBv5 statistics <dvbv5_stats>` via ``.read_status``.
-      Yet, there are a number of callbacks meant to get statistics for
-      signal strength, S/N and UCB. Those are there to provide backward
-      compatibility with legacy applications that don't support the DVBv5
-      API. Implementing those callbacks are optional. Those callbacks may be
-      removed in the future, after we have all existing drivers supporting
-      DVBv5 stats.
-   #) Other callbacks are required for satellite TV standards, in order to
-      control LNBf and DiSEqC: ``.diseqc_send_master_cmd``,
-      ``.diseqc_send_burst``, ``.set_tone``, ``.set_voltage``.
-
-.. |delta|   unicode:: U+00394
-
-The ``drivers/media/dvb-core/dvb_frontend.c`` has a kernel thread with is
-responsible for tuning the device. It supports multiple algoritms to
-detect a channel, as defined at enum :c:func:`dvbfe_algo`.
-
-The algorithm to be used is obtained via ``.get_frontend_algo``. If the driver
-doesn't fill its field at struct :c:type:`dvb_frontend_ops`, it will default to
-``DVBFE_ALGO_SW``, meaning that the dvb-core will do a zigzag when tuning,
-e. g. it will try first to use the specified center frequency ``f``,
-then, it will do ``f`` + |delta|, ``f`` - |delta|, ``f`` + 2 x |delta|,
-``f`` - 2 x |delta| and so on.
-
-If the hardware has internally a some sort of zigzag algorithm, you should
-define a ``.get_frontend_algo`` function that would return ``DVBFE_ALGO_HW``.
-
-.. note::
-
-   The core frontend support also supports
-   a third type (``DVBFE_ALGO_CUSTOM``), in order to allow the driver to
-   define its own hardware-assisted algorithm. Very few hardware need to
-   use it nowadays. Using ``DVBFE_ALGO_CUSTOM`` require to provide other
-   function callbacks at struct :c:type:`dvb_frontend_ops`.
-
-Attaching frontend driver to the bridge driver
-^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
-
-Before using the Digital TV frontend core, the bridge driver should attach
-the frontend demod, tuner and SEC devices and call
-:c:func:`dvb_register_frontend()`,
-in order to register the new frontend at the subsystem. At device
-detach/removal, the bridge driver should call
-:c:func:`dvb_unregister_frontend()` to
-remove the frontend from the core and then :c:func:`dvb_frontend_detach()`
-to free the memory allocated by the frontend drivers.
-
-The drivers should also call :c:func:`dvb_frontend_suspend()` as part of
-their handler for the :c:type:`device_driver`.\ ``suspend()``, and
-:c:func:`dvb_frontend_resume()` as
-part of their handler for :c:type:`device_driver`.\ ``resume()``.
-
-A few other optional functions are provided to handle some special cases.
-
-.. _dvbv5_stats:
-
-Digital TV Frontend statistics
-~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-
-Introduction
-^^^^^^^^^^^^
-
-Digital TV frontends provide a range of
-:ref:`statistics <frontend-stat-properties>` meant to help tuning the device
-and measuring the quality of service.
-
-For each statistics measurement, the driver should set the type of scale used,
-or ``FE_SCALE_NOT_AVAILABLE`` if the statistics is not available on a given
-time. Drivers should also provide the number of statistics for each type.
-that's usually 1 for most video standards [#f2]_.
-
-Drivers should initialize each statistic counters with length and
-scale at its init code. For example, if the frontend provides signal
-strength, it should have, on its init code::
-
-	struct dtv_frontend_properties *c = &state->fe.dtv_property_cache;
-
-	c->strength.len = 1;
-	c->strength.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
-
-And, when the statistics got updated, set the scale::
-
-	c->strength.stat[0].scale = FE_SCALE_DECIBEL;
-	c->strength.stat[0].uvalue = strength;
-
-.. [#f2] For ISDB-T, it may provide both a global statistics and a per-layer
-   set of statistics. On such cases, len should be equal to 4. The first
-   value corresponds to the global stat; the other ones to each layer, e. g.:
-
-   - c->cnr.stat[0] for global S/N carrier ratio,
-   - c->cnr.stat[1] for Layer A S/N carrier ratio,
-   - c->cnr.stat[2] for layer B S/N carrier ratio,
-   - c->cnr.stat[3] for layer C S/N carrier ratio.
-
-.. note:: Please prefer to use ``FE_SCALE_DECIBEL`` instead of
-   ``FE_SCALE_RELATIVE`` for signal strength and CNR measurements.
-
-Groups of statistics
-^^^^^^^^^^^^^^^^^^^^
-
-There are several groups of statistics currently supported:
-
-Signal strength (:ref:`DTV-STAT-SIGNAL-STRENGTH`)
-  - Measures the signal strength level at the analog part of the tuner or
-    demod.
-
-  - Typically obtained from the gain applied to the tuner and/or frontend
-    in order to detect the carrier. When no carrier is detected, the gain is
-    at the maximum value (so, strength is on its minimal).
-
-  - As the gain is visible through the set of registers that adjust the gain,
-    typically, this statistics is always available [#f3]_.
-
-  - Drivers should try to make it available all the times, as this statistics
-    can be used when adjusting an antenna position and to check for troubles
-    at the cabling.
-
-  .. [#f3] On a few devices, the gain keeps floating if no carrier.
-     On such devices, strength report should check first if carrier is
-     detected at the tuner (``FE_HAS_CARRIER``, see :c:type:`fe_status`),
-     and otherwise return the lowest possible value.
-
-Carrier Signal to Noise ratio (:ref:`DTV-STAT-CNR`)
-  - Signal to Noise ratio for the main carrier.
-
-  - Signal to Noise measurement depends on the device. On some hardware, is
-    available when the main carrier is detected. On those hardware, CNR
-    measurement usually comes from the tuner (e. g. after ``FE_HAS_CARRIER``,
-    see :c:type:`fe_status`).
-
-    On other devices, it requires inner FEC decoding,
-    as the frontend measures it indirectly from other parameters (e. g. after
-    ``FE_HAS_VITERBI``, see :c:type:`fe_status`).
-
-    Having it available after inner FEC is more common.
-
-Bit counts post-FEC (:ref:`DTV-STAT-POST-ERROR-BIT-COUNT` and :ref:`DTV-STAT-POST-TOTAL-BIT-COUNT`)
-  - Those counters measure the number of bits and bit errors errors after
-    the forward error correction (FEC) on the inner coding block
-    (after Viterbi, LDPC or other inner code).
-
-  - Due to its nature, those statistics depend on full coding lock
-    (e. g. after ``FE_HAS_SYNC`` or after ``FE_HAS_LOCK``,
-    see :c:type:`fe_status`).
-
-Bit counts pre-FEC (:ref:`DTV-STAT-PRE-ERROR-BIT-COUNT` and :ref:`DTV-STAT-PRE-TOTAL-BIT-COUNT`)
-  - Those counters measure the number of bits and bit errors errors before
-    the forward error correction (FEC) on the inner coding block
-    (before Viterbi, LDPC or other inner code).
-
-  - Not all frontends provide this kind of statistics.
-
-  - Due to its nature, those statistics depend on inner coding lock (e. g.
-    after ``FE_HAS_VITERBI``, see :c:type:`fe_status`).
-
-Block counts (:ref:`DTV-STAT-ERROR-BLOCK-COUNT` and :ref:`DTV-STAT-TOTAL-BLOCK-COUNT`)
-  - Those counters measure the number of blocks and block errors errors after
-    the forward error correction (FEC) on the inner coding block
-    (before Viterbi, LDPC or other inner code).
-
-  - Due to its nature, those statistics depend on full coding lock
-    (e. g. after ``FE_HAS_SYNC`` or after
-    ``FE_HAS_LOCK``, see :c:type:`fe_status`).
-
-.. note:: All counters should be monotonically increased as they're
-   collected from the hardware.
-
-A typical example of the logic that handle status and statistics is::
-
-	static int foo_get_status_and_stats(struct dvb_frontend *fe)
-	{
-		struct foo_state *state = fe->demodulator_priv;
-		struct dtv_frontend_properties *c = &fe->dtv_property_cache;
-
-		int rc;
-		enum fe_status *status;
-
-		/* Both status and strength are always available */
-		rc = foo_read_status(fe, &status);
-		if (rc < 0)
-			return rc;
-
-		rc = foo_read_strength(fe);
-		if (rc < 0)
-			return rc;
-
-		/* Check if CNR is available */
-		if (!(fe->status & FE_HAS_CARRIER))
-			return 0;
-
-		rc = foo_read_cnr(fe);
-		if (rc < 0)
-			return rc;
-
-		/* Check if pre-BER stats are available */
-		if (!(fe->status & FE_HAS_VITERBI))
-			return 0;
-
-		rc = foo_get_pre_ber(fe);
-		if (rc < 0)
-			return rc;
-
-		/* Check if post-BER stats are available */
-		if (!(fe->status & FE_HAS_SYNC))
-			return 0;
-
-		rc = foo_get_post_ber(fe);
-		if (rc < 0)
-			return rc;
-	}
-
-	static const struct dvb_frontend_ops ops = {
-		/* ... */
-		.read_status = foo_get_status_and_stats,
-	};
-
-Statistics collect
-^^^^^^^^^^^^^^^^^^
-
-On almost all frontend hardware, the bit and byte counts are stored by
-the hardware after a certain amount of time or after the total bit/block
-counter reaches a certain value (usually programable), for example, on
-every 1000 ms or after receiving 1,000,000 bits.
-
-So, if you read the registers too soon, you'll end by reading the same
-value as in the previous reading, causing the monotonic value to be
-incremented too often.
-
-Drivers should take the responsibility to avoid too often reads. That
-can be done using two approaches:
-
-if the driver have a bit that indicates when a collected data is ready
-%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
-
-Driver should check such bit before making the statistics available.
-
-An example of such behavior can be found at this code snippet (adapted
-from mb86a20s driver's logic)::
-
-	static int foo_get_pre_ber(struct dvb_frontend *fe)
-	{
-		struct foo_state *state = fe->demodulator_priv;
-		struct dtv_frontend_properties *c = &fe->dtv_property_cache;
-		int rc, bit_error;
-
-		/* Check if the BER measures are already available */
-		rc = foo_read_u8(state, 0x54);
-		if (rc < 0)
-			return rc;
-
-		if (!rc)
-			return 0;
-
-		/* Read Bit Error Count */
-		bit_error = foo_read_u32(state, 0x55);
-		if (bit_error < 0)
-			return bit_error;
-
-		/* Read Total Bit Count */
-		rc = foo_read_u32(state, 0x51);
-		if (rc < 0)
-			return rc;
-
-		c->pre_bit_error.stat[0].scale = FE_SCALE_COUNTER;
-		c->pre_bit_error.stat[0].uvalue += bit_error;
-		c->pre_bit_count.stat[0].scale = FE_SCALE_COUNTER;
-		c->pre_bit_count.stat[0].uvalue += rc;
-
-		return 0;
-	}
-
-If the driver doesn't provide a statistics available check bit
-%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
-
-A few devices, however, may not provide a way to check if the stats are
-available (or the way to check it is unknown). They may not even provide
-a way to directly read the total number of bits or blocks.
-
-On those devices, the driver need to ensure that it won't be reading from
-the register too often and/or estimate the total number of bits/blocks.
-
-On such drivers, a typical routine to get statistics would be like
-(adapted from dib8000 driver's logic)::
-
-	struct foo_state {
-		/* ... */
-
-		unsigned long per_jiffies_stats;
-	}
-
-	static int foo_get_pre_ber(struct dvb_frontend *fe)
-	{
-		struct foo_state *state = fe->demodulator_priv;
-		struct dtv_frontend_properties *c = &fe->dtv_property_cache;
-		int rc, bit_error;
-		u64 bits;
-
-		/* Check if time for stats was elapsed */
-		if (!time_after(jiffies, state->per_jiffies_stats))
-			return 0;
-
-		/* Next stat should be collected in 1000 ms */
-		state->per_jiffies_stats = jiffies + msecs_to_jiffies(1000);
-
-		/* Read Bit Error Count */
-		bit_error = foo_read_u32(state, 0x55);
-		if (bit_error < 0)
-			return bit_error;
-
-		/*
-		 * On this particular frontend, there's no register that
-		 * would provide the number of bits per 1000ms sample. So,
-		 * some function would calculate it based on DTV properties
-		 */
-		bits = get_number_of_bits_per_1000ms(fe);
-
-		c->pre_bit_error.stat[0].scale = FE_SCALE_COUNTER;
-		c->pre_bit_error.stat[0].uvalue += bit_error;
-		c->pre_bit_count.stat[0].scale = FE_SCALE_COUNTER;
-		c->pre_bit_count.stat[0].uvalue += bits;
-
-		return 0;
-	}
-
-Please notice that, on both cases, we're getting the statistics using the
-:c:type:`dvb_frontend_ops` ``.read_status`` callback. The rationale is that
-the frontend core will automatically call this function periodically
-(usually, 3 times per second, when the frontend is locked).
-
-That warrants that we won't miss to collect a counter and increment the
-monotonic stats at the right time.
-
-Digital TV Frontend functions and types
-~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-
-.. kernel-doc:: drivers/media/dvb-core/dvb_frontend.h
-
-
-Digital TV Demux kABI
----------------------
-
-Digital TV Demux
-~~~~~~~~~~~~~~~~
-
-The Kernel Digital TV Demux kABI defines a driver-internal interface for
-registering low-level, hardware specific driver to a hardware independent
-demux layer. It is only of interest for Digital TV device driver writers.
-The header file for this kABI is named demux.h and located in
-drivers/media/dvb-core.
-
-The demux kABI should be implemented for each demux in the system. It is
-used to select the TS source of a demux and to manage the demux resources.
-When the demux client allocates a resource via the demux kABI, it receives
-a pointer to the kABI of that resource.
-
-Each demux receives its TS input from a DVB front-end or from memory, as
-set via this demux kABI. In a system with more than one front-end, the kABI
-can be used to select one of the DVB front-ends as a TS source for a demux,
-unless this is fixed in the HW platform.
-
-The demux kABI only controls front-ends regarding to their connections with
-demuxes; the kABI used to set the other front-end parameters, such as
-tuning, are devined via the Digital TV Frontend kABI.
-
-The functions that implement the abstract interface demux should be defined
-static or module private and registered to the Demux core for external
-access. It is not necessary to implement every function in the struct
-&dmx_demux. For example, a demux interface might support Section filtering,
-but not PES filtering. The kABI client is expected to check the value of any
-function pointer before calling the function: the value of ``NULL`` means
-that the function is not available.
-
-Whenever the functions of the demux API modify shared data, the
-possibilities of lost update and race condition problems should be
-addressed, e.g. by protecting parts of code with mutexes.
-
-Note that functions called from a bottom half context must not sleep.
-Even a simple memory allocation without using ``GFP_ATOMIC`` can result in a
-kernel thread being put to sleep if swapping is needed. For example, the
-Linux Kernel calls the functions of a network device interface from a
-bottom half context. Thus, if a demux kABI function is called from network
-device code, the function must not sleep.
-
-
-
-Demux Callback API
-------------------
-
-Demux Callback
-~~~~~~~~~~~~~~
-
-This kernel-space API comprises the callback functions that deliver filtered
-data to the demux client. Unlike the other DVB kABIs, these functions are
-provided by the client and called from the demux code.
-
-The function pointers of this abstract interface are not packed into a
-structure as in the other demux APIs, because the callback functions are
-registered and used independent of each other. As an example, it is possible
-for the API client to provide several callback functions for receiving TS
-packets and no callbacks for PES packets or sections.
-
-The functions that implement the callback API need not be re-entrant: when
-a demux driver calls one of these functions, the driver is not allowed to
-call the function again before the original call returns. If a callback is
-triggered by a hardware interrupt, it is recommended to use the Linux
-bottom half mechanism or start a tasklet instead of making the callback
-function call directly from a hardware interrupt.
-
-This mechanism is implemented by :c:func:`dmx_ts_cb()` and :c:func:`dmx_section_cb()`
-callbacks.
-
-.. kernel-doc:: drivers/media/dvb-core/demux.h
-
-Digital TV Conditional Access kABI
-----------------------------------
-
-.. kernel-doc:: drivers/media/dvb-core/dvb_ca_en50221.h
+    dtv-common
+    dtv-frontend
+    dtv-demux
+    dtv-ca
diff --git a/Documentation/media/kapi/dtv-demux.rst b/Documentation/media/kapi/dtv-demux.rst
new file mode 100644
index 000000000000..8169c479156e
--- /dev/null
+++ b/Documentation/media/kapi/dtv-demux.rst
@@ -0,0 +1,71 @@
+Digital TV Demux kABI
+---------------------
+
+Digital TV Demux
+~~~~~~~~~~~~~~~~
+
+The Kernel Digital TV Demux kABI defines a driver-internal interface for
+registering low-level, hardware specific driver to a hardware independent
+demux layer. It is only of interest for Digital TV device driver writers.
+The header file for this kABI is named demux.h and located in
+drivers/media/dvb-core.
+
+The demux kABI should be implemented for each demux in the system. It is
+used to select the TS source of a demux and to manage the demux resources.
+When the demux client allocates a resource via the demux kABI, it receives
+a pointer to the kABI of that resource.
+
+Each demux receives its TS input from a DVB front-end or from memory, as
+set via this demux kABI. In a system with more than one front-end, the kABI
+can be used to select one of the DVB front-ends as a TS source for a demux,
+unless this is fixed in the HW platform.
+
+The demux kABI only controls front-ends regarding to their connections with
+demuxes; the kABI used to set the other front-end parameters, such as
+tuning, are devined via the Digital TV Frontend kABI.
+
+The functions that implement the abstract interface demux should be defined
+static or module private and registered to the Demux core for external
+access. It is not necessary to implement every function in the struct
+&dmx_demux. For example, a demux interface might support Section filtering,
+but not PES filtering. The kABI client is expected to check the value of any
+function pointer before calling the function: the value of ``NULL`` means
+that the function is not available.
+
+Whenever the functions of the demux API modify shared data, the
+possibilities of lost update and race condition problems should be
+addressed, e.g. by protecting parts of code with mutexes.
+
+Note that functions called from a bottom half context must not sleep.
+Even a simple memory allocation without using ``GFP_ATOMIC`` can result in a
+kernel thread being put to sleep if swapping is needed. For example, the
+Linux Kernel calls the functions of a network device interface from a
+bottom half context. Thus, if a demux kABI function is called from network
+device code, the function must not sleep.
+
+
+
+Demux Callback API
+~~~~~~~~~~~~~~~~~~
+
+This kernel-space API comprises the callback functions that deliver filtered
+data to the demux client. Unlike the other DVB kABIs, these functions are
+provided by the client and called from the demux code.
+
+The function pointers of this abstract interface are not packed into a
+structure as in the other demux APIs, because the callback functions are
+registered and used independent of each other. As an example, it is possible
+for the API client to provide several callback functions for receiving TS
+packets and no callbacks for PES packets or sections.
+
+The functions that implement the callback API need not be re-entrant: when
+a demux driver calls one of these functions, the driver is not allowed to
+call the function again before the original call returns. If a callback is
+triggered by a hardware interrupt, it is recommended to use the Linux
+bottom half mechanism or start a tasklet instead of making the callback
+function call directly from a hardware interrupt.
+
+This mechanism is implemented by :c:func:`dmx_ts_cb()` and :c:func:`dmx_section_cb()`
+callbacks.
+
+.. kernel-doc:: drivers/media/dvb-core/demux.h
diff --git a/Documentation/media/kapi/dtv-frontend.rst b/Documentation/media/kapi/dtv-frontend.rst
new file mode 100644
index 000000000000..9f67b7a7387d
--- /dev/null
+++ b/Documentation/media/kapi/dtv-frontend.rst
@@ -0,0 +1,443 @@
+Digital TV Frontend kABI
+------------------------
+
+Digital TV Frontend
+~~~~~~~~~~~~~~~~~~~
+
+The Digital TV Frontend kABI defines a driver-internal interface for
+registering low-level, hardware specific driver to a hardware independent
+frontend layer. It is only of interest for Digital TV device driver writers.
+The header file for this API is named ``dvb_frontend.h`` and located in
+``drivers/media/dvb-core``.
+
+Demodulator driver
+^^^^^^^^^^^^^^^^^^
+
+The demodulator driver is responsible to talk with the decoding part of the
+hardware. Such driver should implement :c:type:`dvb_frontend_ops`, with
+tells what type of digital TV standards are supported, and points to a
+series of functions that allow the DVB core to command the hardware via
+the code under ``drivers/media/dvb-core/dvb_frontend.c``.
+
+A typical example of such struct in a driver ``foo`` is::
+
+	static struct dvb_frontend_ops foo_ops = {
+		.delsys = { SYS_DVBT, SYS_DVBT2, SYS_DVBC_ANNEX_A },
+		.info = {
+			.name	= "foo DVB-T/T2/C driver",
+			.caps = FE_CAN_FEC_1_2 |
+				FE_CAN_FEC_2_3 |
+				FE_CAN_FEC_3_4 |
+				FE_CAN_FEC_5_6 |
+				FE_CAN_FEC_7_8 |
+				FE_CAN_FEC_AUTO |
+				FE_CAN_QPSK |
+				FE_CAN_QAM_16 |
+				FE_CAN_QAM_32 |
+				FE_CAN_QAM_64 |
+				FE_CAN_QAM_128 |
+				FE_CAN_QAM_256 |
+				FE_CAN_QAM_AUTO |
+				FE_CAN_TRANSMISSION_MODE_AUTO |
+				FE_CAN_GUARD_INTERVAL_AUTO |
+				FE_CAN_HIERARCHY_AUTO |
+				FE_CAN_MUTE_TS |
+				FE_CAN_2G_MODULATION,
+			.frequency_min = 42000000, /* Hz */
+			.frequency_max = 1002000000, /* Hz */
+			.symbol_rate_min = 870000,
+			.symbol_rate_max = 11700000
+		},
+		.init = foo_init,
+		.sleep = foo_sleep,
+		.release = foo_release,
+		.set_frontend = foo_set_frontend,
+		.get_frontend = foo_get_frontend,
+		.read_status = foo_get_status_and_stats,
+		.tune = foo_tune,
+		.i2c_gate_ctrl = foo_i2c_gate_ctrl,
+		.get_frontend_algo = foo_get_algo,
+	};
+
+A typical example of such struct in a driver ``bar`` meant to be used on
+Satellite TV reception is::
+
+	static const struct dvb_frontend_ops bar_ops = {
+		.delsys = { SYS_DVBS, SYS_DVBS2 },
+		.info = {
+			.name		= "Bar DVB-S/S2 demodulator",
+			.frequency_min	= 500000, /* KHz */
+			.frequency_max	= 2500000, /* KHz */
+			.frequency_stepsize	= 0,
+			.symbol_rate_min = 1000000,
+			.symbol_rate_max = 45000000,
+			.symbol_rate_tolerance = 500,
+			.caps = FE_CAN_INVERSION_AUTO |
+				FE_CAN_FEC_AUTO |
+				FE_CAN_QPSK,
+		},
+		.init = bar_init,
+		.sleep = bar_sleep,
+		.release = bar_release,
+		.set_frontend = bar_set_frontend,
+		.get_frontend = bar_get_frontend,
+		.read_status = bar_get_status_and_stats,
+		.i2c_gate_ctrl = bar_i2c_gate_ctrl,
+		.get_frontend_algo = bar_get_algo,
+		.tune = bar_tune,
+
+		/* Satellite-specific */
+		.diseqc_send_master_cmd = bar_send_diseqc_msg,
+		.diseqc_send_burst = bar_send_burst,
+		.set_tone = bar_set_tone,
+		.set_voltage = bar_set_voltage,
+	};
+
+.. note::
+
+   #) For satellite digital TV standards (DVB-S, DVB-S2, ISDB-S), the
+      frequencies are specified in kHz, while, for terrestrial and cable
+      standards, they're specified in Hz. Due to that, if the same frontend
+      supports both types, you'll need to have two separate
+      :c:type:`dvb_frontend_ops` structures, one for each standard.
+   #) The ``.i2c_gate_ctrl`` field is present only when the hardware has
+      allows controlling an I2C gate (either directly of via some GPIO pin),
+      in order to remove the tuner from the I2C bus after a channel is
+      tuned.
+   #) All new drivers should implement the
+      :ref:`DVBv5 statistics <dvbv5_stats>` via ``.read_status``.
+      Yet, there are a number of callbacks meant to get statistics for
+      signal strength, S/N and UCB. Those are there to provide backward
+      compatibility with legacy applications that don't support the DVBv5
+      API. Implementing those callbacks are optional. Those callbacks may be
+      removed in the future, after we have all existing drivers supporting
+      DVBv5 stats.
+   #) Other callbacks are required for satellite TV standards, in order to
+      control LNBf and DiSEqC: ``.diseqc_send_master_cmd``,
+      ``.diseqc_send_burst``, ``.set_tone``, ``.set_voltage``.
+
+.. |delta|   unicode:: U+00394
+
+The ``drivers/media/dvb-core/dvb_frontend.c`` has a kernel thread with is
+responsible for tuning the device. It supports multiple algoritms to
+detect a channel, as defined at enum :c:func:`dvbfe_algo`.
+
+The algorithm to be used is obtained via ``.get_frontend_algo``. If the driver
+doesn't fill its field at struct :c:type:`dvb_frontend_ops`, it will default to
+``DVBFE_ALGO_SW``, meaning that the dvb-core will do a zigzag when tuning,
+e. g. it will try first to use the specified center frequency ``f``,
+then, it will do ``f`` + |delta|, ``f`` - |delta|, ``f`` + 2 x |delta|,
+``f`` - 2 x |delta| and so on.
+
+If the hardware has internally a some sort of zigzag algorithm, you should
+define a ``.get_frontend_algo`` function that would return ``DVBFE_ALGO_HW``.
+
+.. note::
+
+   The core frontend support also supports
+   a third type (``DVBFE_ALGO_CUSTOM``), in order to allow the driver to
+   define its own hardware-assisted algorithm. Very few hardware need to
+   use it nowadays. Using ``DVBFE_ALGO_CUSTOM`` require to provide other
+   function callbacks at struct :c:type:`dvb_frontend_ops`.
+
+Attaching frontend driver to the bridge driver
+^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
+
+Before using the Digital TV frontend core, the bridge driver should attach
+the frontend demod, tuner and SEC devices and call
+:c:func:`dvb_register_frontend()`,
+in order to register the new frontend at the subsystem. At device
+detach/removal, the bridge driver should call
+:c:func:`dvb_unregister_frontend()` to
+remove the frontend from the core and then :c:func:`dvb_frontend_detach()`
+to free the memory allocated by the frontend drivers.
+
+The drivers should also call :c:func:`dvb_frontend_suspend()` as part of
+their handler for the :c:type:`device_driver`.\ ``suspend()``, and
+:c:func:`dvb_frontend_resume()` as
+part of their handler for :c:type:`device_driver`.\ ``resume()``.
+
+A few other optional functions are provided to handle some special cases.
+
+.. _dvbv5_stats:
+
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
+that's usually 1 for most video standards [#f2]_.
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
+.. [#f2] For ISDB-T, it may provide both a global statistics and a per-layer
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
+    typically, this statistics is always available [#f3]_.
+
+  - Drivers should try to make it available all the times, as this statistics
+    can be used when adjusting an antenna position and to check for troubles
+    at the cabling.
+
+  .. [#f3] On a few devices, the gain keeps floating if no carrier.
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
+.. kernel-doc:: drivers/media/dvb-core/dvb_frontend.h
-- 
2.13.5
