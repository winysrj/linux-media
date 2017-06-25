Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:37710
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751189AbdFYPnl (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 25 Jun 2017 11:43:41 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 2/2] media: dtv-core.rst: complete description of a demod driver
Date: Sun, 25 Jun 2017 12:42:55 -0300
Message-Id: <f91df2e4fcbfea816f8cb7e7d24d115ee56541d9.1498405363.git.mchehab@s-opensource.com>
In-Reply-To: <f495ab869a89caa580d201f7bf2d9944d3d9cb24.1498405363.git.mchehab@s-opensource.com>
References: <f495ab869a89caa580d201f7bf2d9944d3d9cb24.1498405363.git.mchehab@s-opensource.com>
In-Reply-To: <f495ab869a89caa580d201f7bf2d9944d3d9cb24.1498405363.git.mchehab@s-opensource.com>
References: <f495ab869a89caa580d201f7bf2d9944d3d9cb24.1498405363.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

A section talking about demod statistics implementation was
recently added, but it seemed to start from nowere, without
a previous description about how a demod driver would look
like.

Add such description, for completeness.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/media/kapi/dtv-core.rst | 139 +++++++++++++++++++++++++++++++++-
 1 file changed, 137 insertions(+), 2 deletions(-)

diff --git a/Documentation/media/kapi/dtv-core.rst b/Documentation/media/kapi/dtv-core.rst
index 1430f0b7e615..de9a228aca8a 100644
--- a/Documentation/media/kapi/dtv-core.rst
+++ b/Documentation/media/kapi/dtv-core.rst
@@ -80,8 +80,141 @@ Digital TV Frontend
 The Digital TV Frontend kABI defines a driver-internal interface for
 registering low-level, hardware specific driver to a hardware independent
 frontend layer. It is only of interest for Digital TV device driver writers.
-The header file for this API is named dvb_frontend.h and located in
-drivers/media/dvb-core.
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
 
 Before using the Digital TV frontend core, the bridge driver should attach
 the frontend demod, tuner and SEC devices and call
@@ -99,6 +232,8 @@ part of their handler for :c:type:`device_driver`.\ ``resume()``.
 
 A few other optional functions are provided to handle some special cases.
 
+.. _dvbv5_stats:
+
 Digital TV Frontend statistics
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 
-- 
2.9.4
