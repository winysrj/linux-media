Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:37708
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751020AbdFYPnk (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 25 Jun 2017 11:43:40 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 1/2] media: dtv-core.rst: add an introduction to FE kAPI
Date: Sun, 25 Jun 2017 12:42:54 -0300
Message-Id: <f495ab869a89caa580d201f7bf2d9944d3d9cb24.1498405363.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Instead of just start describing the kAPI functions, add
an introduction giving a general line about a DVB driver's
structure.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/media/kapi/dtv-core.rst | 33 +++++++++++++++++++++++++++++----
 1 file changed, 29 insertions(+), 4 deletions(-)

diff --git a/Documentation/media/kapi/dtv-core.rst b/Documentation/media/kapi/dtv-core.rst
index bec7875a7e2e..1430f0b7e615 100644
--- a/Documentation/media/kapi/dtv-core.rst
+++ b/Documentation/media/kapi/dtv-core.rst
@@ -1,6 +1,31 @@
 Digital TV (DVB) devices
 ------------------------
 
+Digital TV devices are implemented by several different drivers:
+
+- A bridge driver that is responsible to talk with the bus where the other
+  devices are connected (PCI, USB, SPI), bind to the other drivers and
+  implement the digital demux logic (either in software or in hardware);
+
+- Frontend drivers that are usually implemented as two separate drivers:
+
+  - A tuner driver that implements the logic with commands the part of the
+    hardware with is reponsible to tune into a digital TV transponder or
+    physical channel. The output of a tuner is usually a baseband or
+    Intermediate Frequency (IF) signal;
+
+  - A demodulator driver (a.k.a "demod") that implements the logic with
+    commands the digital TV decoding hardware. The output of a demod is
+    a digital stream, with multiple audio, video and data channels typically
+    multiplexed using MPEG Transport Stream [#f1]_.
+
+On most hardware, the frontend drivers talk with the bridge driver using an
+I2C bus.
+
+.. [#f1] Some standards use TCP/IP for multiplexing data, like DVB-H (an
+   abandoned standard, not used anymore) and ATSC version 3.0 current
+   proposals. Currently, the DVB subsystem doesn't implement those standards.
+
 Digital TV Common functions
 ---------------------------
 
@@ -87,7 +112,7 @@ and measuring the quality of service.
 For each statistics measurement, the driver should set the type of scale used,
 or ``FE_SCALE_NOT_AVAILABLE`` if the statistics is not available on a given
 time. Drivers should also provide the number of statistics for each type.
-that's usually 1 for most video standards [#f1]_.
+that's usually 1 for most video standards [#f2]_.
 
 Drivers should initialize each statistic counters with length and
 scale at its init code. For example, if the frontend provides signal
@@ -103,7 +128,7 @@ And, when the statistics got updated, set the scale::
 	c->strength.stat[0].scale = FE_SCALE_DECIBEL;
 	c->strength.stat[0].uvalue = strength;
 
-.. [#f1] For ISDB-T, it may provide both a global statistics and a per-layer
+.. [#f2] For ISDB-T, it may provide both a global statistics and a per-layer
    set of statistics. On such cases, len should be equal to 4. The first
    value corresponds to the global stat; the other ones to each layer, e. g.:
 
@@ -129,13 +154,13 @@ Signal strength (:ref:`DTV-STAT-SIGNAL-STRENGTH`)
     at the maximum value (so, strength is on its minimal).
 
   - As the gain is visible through the set of registers that adjust the gain,
-    typically, this statistics is always available [#f2]_.
+    typically, this statistics is always available [#f3]_.
 
   - Drivers should try to make it available all the times, as this statistics
     can be used when adjusting an antenna position and to check for troubles
     at the cabling.
 
-  .. [#f2] On a few devices, the gain keeps floating if no carrier.
+  .. [#f3] On a few devices, the gain keeps floating if no carrier.
      On such devices, strength report should check first if carrier is
      detected at the tuner (``FE_HAS_CARRIER``, see :c:type:`fe_status`),
      and otherwise return the lowest possible value.
-- 
2.9.4
