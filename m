Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:41389 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755304AbcGHNED (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 8 Jul 2016 09:04:03 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: corbet@lwn.net, markus.heiser@darmarIT.de,
	linux-doc@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 46/54] doc-rst: fix some badly converted references
Date: Fri,  8 Jul 2016 10:03:38 -0300
Message-Id: <6aeb3f676a73d9afe52eb4efd44c563f3a792880.1467981855.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1467981855.git.mchehab@s-opensource.com>
References: <cover.1467981855.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1467981855.git.mchehab@s-opensource.com>
References: <cover.1467981855.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Several references were not converted right. That's why
so many symbols were lost when parsing videodev2.h header.

Fix them.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/linux_tv/media/dvb/dmx_types.rst     |   8 +-
 .../linux_tv/media/dvb/fe-bandwidth-t.rst          |  14 +-
 .../linux_tv/media/dvb/fe-diseqc-send-burst.rst    |   4 +-
 Documentation/linux_tv/media/dvb/fe-get-info.rst   |  62 +++----
 .../linux_tv/media/dvb/fe-read-status.rst          |  14 +-
 Documentation/linux_tv/media/dvb/fe-set-tone.rst   |   4 +-
 Documentation/linux_tv/media/dvb/fe-type-t.rst     |   8 +-
 .../linux_tv/media/dvb/fe_property_parameters.rst  | 206 ++++++++++-----------
 Documentation/linux_tv/media/v4l/control.rst       |   6 +-
 .../linux_tv/media/v4l/extended-controls.rst       | 114 ++++++------
 Documentation/linux_tv/media/v4l/pixfmt-013.rst    |  26 +--
 .../linux_tv/media/v4l/pixfmt-indexed.rst          |   2 +-
 .../linux_tv/media/v4l/pixfmt-packed-rgb.rst       |  42 ++---
 .../linux_tv/media/v4l/pixfmt-packed-yuv.rst       |   8 +-
 .../linux_tv/media/v4l/pixfmt-reserved.rst         |  66 +++----
 .../linux_tv/media/v4l/subdev-formats.rst          | 174 ++++++++---------
 16 files changed, 379 insertions(+), 379 deletions(-)

diff --git a/Documentation/linux_tv/media/dvb/dmx_types.rst b/Documentation/linux_tv/media/dvb/dmx_types.rst
index 84bf616ff623..7a8900af2680 100644
--- a/Documentation/linux_tv/media/dvb/dmx_types.rst
+++ b/Documentation/linux_tv/media/dvb/dmx_types.rst
@@ -28,7 +28,7 @@ Output for the demux
 
     -  .. row 2
 
-       -  .. _`DMX-OUT-DECODER`:
+       -  .. _DMX-OUT-DECODER:
 
 	  DMX_OUT_DECODER
 
@@ -36,7 +36,7 @@ Output for the demux
 
     -  .. row 3
 
-       -  .. _`DMX-OUT-TAP`:
+       -  .. _DMX-OUT-TAP:
 
 	  DMX_OUT_TAP
 
@@ -46,7 +46,7 @@ Output for the demux
 
     -  .. row 4
 
-       -  .. _`DMX-OUT-TS-TAP`:
+       -  .. _DMX-OUT-TS-TAP:
 
 	  DMX_OUT_TS_TAP
 
@@ -57,7 +57,7 @@ Output for the demux
 
     -  .. row 5
 
-       -  .. _`DMX-OUT-TSDEMUX-TAP`:
+       -  .. _DMX-OUT-TSDEMUX-TAP:
 
 	  DMX_OUT_TSDEMUX_TAP
 
diff --git a/Documentation/linux_tv/media/dvb/fe-bandwidth-t.rst b/Documentation/linux_tv/media/dvb/fe-bandwidth-t.rst
index f614c22355da..8edaf1a8fbc8 100644
--- a/Documentation/linux_tv/media/dvb/fe-bandwidth-t.rst
+++ b/Documentation/linux_tv/media/dvb/fe-bandwidth-t.rst
@@ -22,7 +22,7 @@ Frontend bandwidth
 
     -  .. row 2
 
-       -  .. _`BANDWIDTH-AUTO`:
+       -  .. _BANDWIDTH-AUTO:
 
 	  ``BANDWIDTH_AUTO``
 
@@ -30,7 +30,7 @@ Frontend bandwidth
 
     -  .. row 3
 
-       -  .. _`BANDWIDTH-1-712-MHZ`:
+       -  .. _BANDWIDTH-1-712-MHZ:
 
 	  ``BANDWIDTH_1_712_MHZ``
 
@@ -38,7 +38,7 @@ Frontend bandwidth
 
     -  .. row 4
 
-       -  .. _`BANDWIDTH-5-MHZ`:
+       -  .. _BANDWIDTH-5-MHZ:
 
 	  ``BANDWIDTH_5_MHZ``
 
@@ -46,7 +46,7 @@ Frontend bandwidth
 
     -  .. row 5
 
-       -  .. _`BANDWIDTH-6-MHZ`:
+       -  .. _BANDWIDTH-6-MHZ:
 
 	  ``BANDWIDTH_6_MHZ``
 
@@ -54,7 +54,7 @@ Frontend bandwidth
 
     -  .. row 6
 
-       -  .. _`BANDWIDTH-7-MHZ`:
+       -  .. _BANDWIDTH-7-MHZ:
 
 	  ``BANDWIDTH_7_MHZ``
 
@@ -62,7 +62,7 @@ Frontend bandwidth
 
     -  .. row 7
 
-       -  .. _`BANDWIDTH-8-MHZ`:
+       -  .. _BANDWIDTH-8-MHZ:
 
 	  ``BANDWIDTH_8_MHZ``
 
@@ -70,7 +70,7 @@ Frontend bandwidth
 
     -  .. row 8
 
-       -  .. _`BANDWIDTH-10-MHZ`:
+       -  .. _BANDWIDTH-10-MHZ:
 
 	  ``BANDWIDTH_10_MHZ``
 
diff --git a/Documentation/linux_tv/media/dvb/fe-diseqc-send-burst.rst b/Documentation/linux_tv/media/dvb/fe-diseqc-send-burst.rst
index 11d441c6f237..9b476545ef89 100644
--- a/Documentation/linux_tv/media/dvb/fe-diseqc-send-burst.rst
+++ b/Documentation/linux_tv/media/dvb/fe-diseqc-send-burst.rst
@@ -61,7 +61,7 @@ enum fe_sec_mini_cmd
 
     -  .. row 2
 
-       -  .. _`SEC-MINI-A`:
+       -  .. _SEC-MINI-A:
 
 	  ``SEC_MINI_A``
 
@@ -69,7 +69,7 @@ enum fe_sec_mini_cmd
 
     -  .. row 3
 
-       -  .. _`SEC-MINI-B`:
+       -  .. _SEC-MINI-B:
 
 	  ``SEC_MINI_B``
 
diff --git a/Documentation/linux_tv/media/dvb/fe-get-info.rst b/Documentation/linux_tv/media/dvb/fe-get-info.rst
index 8ef1ed7bbf68..9a9ddbcdb1ec 100644
--- a/Documentation/linux_tv/media/dvb/fe-get-info.rst
+++ b/Documentation/linux_tv/media/dvb/fe-get-info.rst
@@ -172,7 +172,7 @@ supported only on some specific frontend types.
 
     -  .. row 2
 
-       -  .. _`FE-IS-STUPID`:
+       -  .. _FE-IS-STUPID:
 
 	  ``FE_IS_STUPID``
 
@@ -181,7 +181,7 @@ supported only on some specific frontend types.
 
     -  .. row 3
 
-       -  .. _`FE-CAN-INVERSION-AUTO`:
+       -  .. _FE-CAN-INVERSION-AUTO:
 
 	  ``FE_CAN_INVERSION_AUTO``
 
@@ -189,7 +189,7 @@ supported only on some specific frontend types.
 
     -  .. row 4
 
-       -  .. _`FE-CAN-FEC-1-2`:
+       -  .. _FE-CAN-FEC-1-2:
 
 	  ``FE_CAN_FEC_1_2``
 
@@ -197,7 +197,7 @@ supported only on some specific frontend types.
 
     -  .. row 5
 
-       -  .. _`FE-CAN-FEC-2-3`:
+       -  .. _FE-CAN-FEC-2-3:
 
 	  ``FE_CAN_FEC_2_3``
 
@@ -205,7 +205,7 @@ supported only on some specific frontend types.
 
     -  .. row 6
 
-       -  .. _`FE-CAN-FEC-3-4`:
+       -  .. _FE-CAN-FEC-3-4:
 
 	  ``FE_CAN_FEC_3_4``
 
@@ -213,7 +213,7 @@ supported only on some specific frontend types.
 
     -  .. row 7
 
-       -  .. _`FE-CAN-FEC-4-5`:
+       -  .. _FE-CAN-FEC-4-5:
 
 	  ``FE_CAN_FEC_4_5``
 
@@ -221,7 +221,7 @@ supported only on some specific frontend types.
 
     -  .. row 8
 
-       -  .. _`FE-CAN-FEC-5-6`:
+       -  .. _FE-CAN-FEC-5-6:
 
 	  ``FE_CAN_FEC_5_6``
 
@@ -229,7 +229,7 @@ supported only on some specific frontend types.
 
     -  .. row 9
 
-       -  .. _`FE-CAN-FEC-6-7`:
+       -  .. _FE-CAN-FEC-6-7:
 
 	  ``FE_CAN_FEC_6_7``
 
@@ -237,7 +237,7 @@ supported only on some specific frontend types.
 
     -  .. row 10
 
-       -  .. _`FE-CAN-FEC-7-8`:
+       -  .. _FE-CAN-FEC-7-8:
 
 	  ``FE_CAN_FEC_7_8``
 
@@ -245,7 +245,7 @@ supported only on some specific frontend types.
 
     -  .. row 11
 
-       -  .. _`FE-CAN-FEC-8-9`:
+       -  .. _FE-CAN-FEC-8-9:
 
 	  ``FE_CAN_FEC_8_9``
 
@@ -253,7 +253,7 @@ supported only on some specific frontend types.
 
     -  .. row 12
 
-       -  .. _`FE-CAN-FEC-AUTO`:
+       -  .. _FE-CAN-FEC-AUTO:
 
 	  ``FE_CAN_FEC_AUTO``
 
@@ -261,7 +261,7 @@ supported only on some specific frontend types.
 
     -  .. row 13
 
-       -  .. _`FE-CAN-QPSK`:
+       -  .. _FE-CAN-QPSK:
 
 	  ``FE_CAN_QPSK``
 
@@ -269,7 +269,7 @@ supported only on some specific frontend types.
 
     -  .. row 14
 
-       -  .. _`FE-CAN-QAM-16`:
+       -  .. _FE-CAN-QAM-16:
 
 	  ``FE_CAN_QAM_16``
 
@@ -277,7 +277,7 @@ supported only on some specific frontend types.
 
     -  .. row 15
 
-       -  .. _`FE-CAN-QAM-32`:
+       -  .. _FE-CAN-QAM-32:
 
 	  ``FE_CAN_QAM_32``
 
@@ -285,7 +285,7 @@ supported only on some specific frontend types.
 
     -  .. row 16
 
-       -  .. _`FE-CAN-QAM-64`:
+       -  .. _FE-CAN-QAM-64:
 
 	  ``FE_CAN_QAM_64``
 
@@ -293,7 +293,7 @@ supported only on some specific frontend types.
 
     -  .. row 17
 
-       -  .. _`FE-CAN-QAM-128`:
+       -  .. _FE-CAN-QAM-128:
 
 	  ``FE_CAN_QAM_128``
 
@@ -301,7 +301,7 @@ supported only on some specific frontend types.
 
     -  .. row 18
 
-       -  .. _`FE-CAN-QAM-256`:
+       -  .. _FE-CAN-QAM-256:
 
 	  ``FE_CAN_QAM_256``
 
@@ -309,7 +309,7 @@ supported only on some specific frontend types.
 
     -  .. row 19
 
-       -  .. _`FE-CAN-QAM-AUTO`:
+       -  .. _FE-CAN-QAM-AUTO:
 
 	  ``FE_CAN_QAM_AUTO``
 
@@ -317,7 +317,7 @@ supported only on some specific frontend types.
 
     -  .. row 20
 
-       -  .. _`FE-CAN-TRANSMISSION-MODE-AUTO`:
+       -  .. _FE-CAN-TRANSMISSION-MODE-AUTO:
 
 	  ``FE_CAN_TRANSMISSION_MODE_AUTO``
 
@@ -325,7 +325,7 @@ supported only on some specific frontend types.
 
     -  .. row 21
 
-       -  .. _`FE-CAN-BANDWIDTH-AUTO`:
+       -  .. _FE-CAN-BANDWIDTH-AUTO:
 
 	  ``FE_CAN_BANDWIDTH_AUTO``
 
@@ -333,7 +333,7 @@ supported only on some specific frontend types.
 
     -  .. row 22
 
-       -  .. _`FE-CAN-GUARD-INTERVAL-AUTO`:
+       -  .. _FE-CAN-GUARD-INTERVAL-AUTO:
 
 	  ``FE_CAN_GUARD_INTERVAL_AUTO``
 
@@ -341,7 +341,7 @@ supported only on some specific frontend types.
 
     -  .. row 23
 
-       -  .. _`FE-CAN-HIERARCHY-AUTO`:
+       -  .. _FE-CAN-HIERARCHY-AUTO:
 
 	  ``FE_CAN_HIERARCHY_AUTO``
 
@@ -349,7 +349,7 @@ supported only on some specific frontend types.
 
     -  .. row 24
 
-       -  .. _`FE-CAN-8VSB`:
+       -  .. _FE-CAN-8VSB:
 
 	  ``FE_CAN_8VSB``
 
@@ -357,7 +357,7 @@ supported only on some specific frontend types.
 
     -  .. row 25
 
-       -  .. _`FE-CAN-16VSB`:
+       -  .. _FE-CAN-16VSB:
 
 	  ``FE_CAN_16VSB``
 
@@ -365,7 +365,7 @@ supported only on some specific frontend types.
 
     -  .. row 26
 
-       -  .. _`FE-HAS-EXTENDED-CAPS`:
+       -  .. _FE-HAS-EXTENDED-CAPS:
 
 	  ``FE_HAS_EXTENDED_CAPS``
 
@@ -373,7 +373,7 @@ supported only on some specific frontend types.
 
     -  .. row 27
 
-       -  .. _`FE-CAN-MULTISTREAM`:
+       -  .. _FE-CAN-MULTISTREAM:
 
 	  ``FE_CAN_MULTISTREAM``
 
@@ -381,7 +381,7 @@ supported only on some specific frontend types.
 
     -  .. row 28
 
-       -  .. _`FE-CAN-TURBO-FEC`:
+       -  .. _FE-CAN-TURBO-FEC:
 
 	  ``FE_CAN_TURBO_FEC``
 
@@ -389,7 +389,7 @@ supported only on some specific frontend types.
 
     -  .. row 29
 
-       -  .. _`FE-CAN-2G-MODULATION`:
+       -  .. _FE-CAN-2G-MODULATION:
 
 	  ``FE_CAN_2G_MODULATION``
 
@@ -397,7 +397,7 @@ supported only on some specific frontend types.
 
     -  .. row 30
 
-       -  .. _`FE-NEEDS-BENDING`:
+       -  .. _FE-NEEDS-BENDING:
 
 	  ``FE_NEEDS_BENDING``
 
@@ -405,7 +405,7 @@ supported only on some specific frontend types.
 
     -  .. row 31
 
-       -  .. _`FE-CAN-RECOVER`:
+       -  .. _FE-CAN-RECOVER:
 
 	  ``FE_CAN_RECOVER``
 
@@ -413,7 +413,7 @@ supported only on some specific frontend types.
 
     -  .. row 32
 
-       -  .. _`FE-CAN-MUTE-TS`:
+       -  .. _FE-CAN-MUTE-TS:
 
 	  ``FE_CAN_MUTE_TS``
 
diff --git a/Documentation/linux_tv/media/dvb/fe-read-status.rst b/Documentation/linux_tv/media/dvb/fe-read-status.rst
index 544ce49ee091..339955fbe133 100644
--- a/Documentation/linux_tv/media/dvb/fe-read-status.rst
+++ b/Documentation/linux_tv/media/dvb/fe-read-status.rst
@@ -70,7 +70,7 @@ state changes of the frontend hardware. It is produced using the enum
 
     -  .. row 2
 
-       -  .. _`FE-HAS-SIGNAL`:
+       -  .. _FE-HAS-SIGNAL:
 
 	  ``FE_HAS_SIGNAL``
 
@@ -78,7 +78,7 @@ state changes of the frontend hardware. It is produced using the enum
 
     -  .. row 3
 
-       -  .. _`FE-HAS-CARRIER`:
+       -  .. _FE-HAS-CARRIER:
 
 	  ``FE_HAS_CARRIER``
 
@@ -86,7 +86,7 @@ state changes of the frontend hardware. It is produced using the enum
 
     -  .. row 4
 
-       -  .. _`FE-HAS-VITERBI`:
+       -  .. _FE-HAS-VITERBI:
 
 	  ``FE_HAS_VITERBI``
 
@@ -95,7 +95,7 @@ state changes of the frontend hardware. It is produced using the enum
 
     -  .. row 5
 
-       -  .. _`FE-HAS-SYNC`:
+       -  .. _FE-HAS-SYNC:
 
 	  ``FE_HAS_SYNC``
 
@@ -103,7 +103,7 @@ state changes of the frontend hardware. It is produced using the enum
 
     -  .. row 6
 
-       -  .. _`FE-HAS-LOCK`:
+       -  .. _FE-HAS-LOCK:
 
 	  ``FE_HAS_LOCK``
 
@@ -111,7 +111,7 @@ state changes of the frontend hardware. It is produced using the enum
 
     -  .. row 7
 
-       -  .. _`FE-TIMEDOUT`:
+       -  .. _FE-TIMEDOUT:
 
 	  ``FE_TIMEDOUT``
 
@@ -119,7 +119,7 @@ state changes of the frontend hardware. It is produced using the enum
 
     -  .. row 8
 
-       -  .. _`FE-REINIT`:
+       -  .. _FE-REINIT:
 
 	  ``FE_REINIT``
 
diff --git a/Documentation/linux_tv/media/dvb/fe-set-tone.rst b/Documentation/linux_tv/media/dvb/fe-set-tone.rst
index 16bf6b73f8d5..763b61d91004 100644
--- a/Documentation/linux_tv/media/dvb/fe-set-tone.rst
+++ b/Documentation/linux_tv/media/dvb/fe-set-tone.rst
@@ -67,7 +67,7 @@ enum fe_sec_tone_mode
 
     -  .. row 2
 
-       -  .. _`SEC-TONE-ON`:
+       -  .. _SEC-TONE-ON:
 
 	  ``SEC_TONE_ON``
 
@@ -75,7 +75,7 @@ enum fe_sec_tone_mode
 
     -  .. row 3
 
-       -  .. _`SEC-TONE-OFF`:
+       -  .. _SEC-TONE-OFF:
 
 	  ``SEC_TONE_OFF``
 
diff --git a/Documentation/linux_tv/media/dvb/fe-type-t.rst b/Documentation/linux_tv/media/dvb/fe-type-t.rst
index 0c26af5d3a92..8ca762b42e4d 100644
--- a/Documentation/linux_tv/media/dvb/fe-type-t.rst
+++ b/Documentation/linux_tv/media/dvb/fe-type-t.rst
@@ -30,7 +30,7 @@ fe_type_t type, defined as:
 
     -  .. row 2
 
-       -  .. _`FE-QPSK`:
+       -  .. _FE-QPSK:
 
 	  ``FE_QPSK``
 
@@ -40,7 +40,7 @@ fe_type_t type, defined as:
 
     -  .. row 3
 
-       -  .. _`FE-QAM`:
+       -  .. _FE-QAM:
 
 	  ``FE_QAM``
 
@@ -50,7 +50,7 @@ fe_type_t type, defined as:
 
     -  .. row 4
 
-       -  .. _`FE-OFDM`:
+       -  .. _FE-OFDM:
 
 	  ``FE_OFDM``
 
@@ -60,7 +60,7 @@ fe_type_t type, defined as:
 
     -  .. row 5
 
-       -  .. _`FE-ATSC`:
+       -  .. _FE-ATSC:
 
 	  ``FE_ATSC``
 
diff --git a/Documentation/linux_tv/media/dvb/fe_property_parameters.rst b/Documentation/linux_tv/media/dvb/fe_property_parameters.rst
index b6142ee1acfb..47eb29350717 100644
--- a/Documentation/linux_tv/media/dvb/fe_property_parameters.rst
+++ b/Documentation/linux_tv/media/dvb/fe_property_parameters.rst
@@ -91,7 +91,7 @@ modulations are supported by a given standard.
 
     -  .. row 2
 
-       -  .. _`QPSK`:
+       -  .. _QPSK:
 
 	  ``QPSK``
 
@@ -99,7 +99,7 @@ modulations are supported by a given standard.
 
     -  .. row 3
 
-       -  .. _`QAM-16`:
+       -  .. _QAM-16:
 
 	  ``QAM_16``
 
@@ -107,7 +107,7 @@ modulations are supported by a given standard.
 
     -  .. row 4
 
-       -  .. _`QAM-32`:
+       -  .. _QAM-32:
 
 	  ``QAM_32``
 
@@ -115,7 +115,7 @@ modulations are supported by a given standard.
 
     -  .. row 5
 
-       -  .. _`QAM-64`:
+       -  .. _QAM-64:
 
 	  ``QAM_64``
 
@@ -123,7 +123,7 @@ modulations are supported by a given standard.
 
     -  .. row 6
 
-       -  .. _`QAM-128`:
+       -  .. _QAM-128:
 
 	  ``QAM_128``
 
@@ -131,7 +131,7 @@ modulations are supported by a given standard.
 
     -  .. row 7
 
-       -  .. _`QAM-256`:
+       -  .. _QAM-256:
 
 	  ``QAM_256``
 
@@ -139,7 +139,7 @@ modulations are supported by a given standard.
 
     -  .. row 8
 
-       -  .. _`QAM-AUTO`:
+       -  .. _QAM-AUTO:
 
 	  ``QAM_AUTO``
 
@@ -147,7 +147,7 @@ modulations are supported by a given standard.
 
     -  .. row 9
 
-       -  .. _`VSB-8`:
+       -  .. _VSB-8:
 
 	  ``VSB_8``
 
@@ -155,7 +155,7 @@ modulations are supported by a given standard.
 
     -  .. row 10
 
-       -  .. _`VSB-16`:
+       -  .. _VSB-16:
 
 	  ``VSB_16``
 
@@ -163,7 +163,7 @@ modulations are supported by a given standard.
 
     -  .. row 11
 
-       -  .. _`PSK-8`:
+       -  .. _PSK-8:
 
 	  ``PSK_8``
 
@@ -171,7 +171,7 @@ modulations are supported by a given standard.
 
     -  .. row 12
 
-       -  .. _`APSK-16`:
+       -  .. _APSK-16:
 
 	  ``APSK_16``
 
@@ -179,7 +179,7 @@ modulations are supported by a given standard.
 
     -  .. row 13
 
-       -  .. _`APSK-32`:
+       -  .. _APSK-32:
 
 	  ``APSK_32``
 
@@ -187,7 +187,7 @@ modulations are supported by a given standard.
 
     -  .. row 14
 
-       -  .. _`DQPSK`:
+       -  .. _DQPSK:
 
 	  ``DQPSK``
 
@@ -195,7 +195,7 @@ modulations are supported by a given standard.
 
     -  .. row 15
 
-       -  .. _`QAM-4-NR`:
+       -  .. _QAM-4-NR:
 
 	  ``QAM_4_NR``
 
@@ -267,7 +267,7 @@ inversion off. If it fails, it will try to enable inversion.
 
     -  .. row 2
 
-       -  .. _`INVERSION-OFF`:
+       -  .. _INVERSION-OFF:
 
 	  ``INVERSION_OFF``
 
@@ -275,7 +275,7 @@ inversion off. If it fails, it will try to enable inversion.
 
     -  .. row 3
 
-       -  .. _`INVERSION-ON`:
+       -  .. _INVERSION-ON:
 
 	  ``INVERSION_ON``
 
@@ -283,7 +283,7 @@ inversion off. If it fails, it will try to enable inversion.
 
     -  .. row 4
 
-       -  .. _`INVERSION-AUTO`:
+       -  .. _INVERSION-AUTO:
 
 	  ``INVERSION_AUTO``
 
@@ -337,7 +337,7 @@ enum fe_code_rate: type of the Forward Error Correction.
 
     -  .. row 2
 
-       -  .. _`FEC-NONE`:
+       -  .. _FEC-NONE:
 
 	  ``FEC_NONE``
 
@@ -345,7 +345,7 @@ enum fe_code_rate: type of the Forward Error Correction.
 
     -  .. row 3
 
-       -  .. _`FEC-AUTO`:
+       -  .. _FEC-AUTO:
 
 	  ``FEC_AUTO``
 
@@ -353,7 +353,7 @@ enum fe_code_rate: type of the Forward Error Correction.
 
     -  .. row 4
 
-       -  .. _`FEC-1-2`:
+       -  .. _FEC-1-2:
 
 	  ``FEC_1_2``
 
@@ -361,7 +361,7 @@ enum fe_code_rate: type of the Forward Error Correction.
 
     -  .. row 5
 
-       -  .. _`FEC-2-3`:
+       -  .. _FEC-2-3:
 
 	  ``FEC_2_3``
 
@@ -369,7 +369,7 @@ enum fe_code_rate: type of the Forward Error Correction.
 
     -  .. row 6
 
-       -  .. _`FEC-3-4`:
+       -  .. _FEC-3-4:
 
 	  ``FEC_3_4``
 
@@ -377,7 +377,7 @@ enum fe_code_rate: type of the Forward Error Correction.
 
     -  .. row 7
 
-       -  .. _`FEC-4-5`:
+       -  .. _FEC-4-5:
 
 	  ``FEC_4_5``
 
@@ -385,7 +385,7 @@ enum fe_code_rate: type of the Forward Error Correction.
 
     -  .. row 8
 
-       -  .. _`FEC-5-6`:
+       -  .. _FEC-5-6:
 
 	  ``FEC_5_6``
 
@@ -393,7 +393,7 @@ enum fe_code_rate: type of the Forward Error Correction.
 
     -  .. row 9
 
-       -  .. _`FEC-6-7`:
+       -  .. _FEC-6-7:
 
 	  ``FEC_6_7``
 
@@ -401,7 +401,7 @@ enum fe_code_rate: type of the Forward Error Correction.
 
     -  .. row 10
 
-       -  .. _`FEC-7-8`:
+       -  .. _FEC-7-8:
 
 	  ``FEC_7_8``
 
@@ -409,7 +409,7 @@ enum fe_code_rate: type of the Forward Error Correction.
 
     -  .. row 11
 
-       -  .. _`FEC-8-9`:
+       -  .. _FEC-8-9:
 
 	  ``FEC_8_9``
 
@@ -417,7 +417,7 @@ enum fe_code_rate: type of the Forward Error Correction.
 
     -  .. row 12
 
-       -  .. _`FEC-9-10`:
+       -  .. _FEC-9-10:
 
 	  ``FEC_9_10``
 
@@ -425,7 +425,7 @@ enum fe_code_rate: type of the Forward Error Correction.
 
     -  .. row 13
 
-       -  .. _`FEC-2-5`:
+       -  .. _FEC-2-5:
 
 	  ``FEC_2_5``
 
@@ -433,7 +433,7 @@ enum fe_code_rate: type of the Forward Error Correction.
 
     -  .. row 14
 
-       -  .. _`FEC-3-5`:
+       -  .. _FEC-3-5:
 
 	  ``FEC_3_5``
 
@@ -467,7 +467,7 @@ described in the DiSEqC spec.
 
     -  .. row 2
 
-       -  .. _`SEC-VOLTAGE-13`:
+       -  .. _SEC-VOLTAGE-13:
 
 	  ``SEC_VOLTAGE_13``
 
@@ -475,7 +475,7 @@ described in the DiSEqC spec.
 
     -  .. row 3
 
-       -  .. _`SEC-VOLTAGE-18`:
+       -  .. _SEC-VOLTAGE-18:
 
 	  ``SEC_VOLTAGE_18``
 
@@ -483,7 +483,7 @@ described in the DiSEqC spec.
 
     -  .. row 4
 
-       -  .. _`SEC-VOLTAGE-OFF`:
+       -  .. _SEC-VOLTAGE-OFF:
 
 	  ``SEC_VOLTAGE_OFF``
 
@@ -528,7 +528,7 @@ fe_pilot type
 
     -  .. row 2
 
-       -  .. _`PILOT-ON`:
+       -  .. _PILOT-ON:
 
 	  ``PILOT_ON``
 
@@ -536,7 +536,7 @@ fe_pilot type
 
     -  .. row 3
 
-       -  .. _`PILOT-OFF`:
+       -  .. _PILOT-OFF:
 
 	  ``PILOT_OFF``
 
@@ -544,7 +544,7 @@ fe_pilot type
 
     -  .. row 4
 
-       -  .. _`PILOT-AUTO`:
+       -  .. _PILOT-AUTO:
 
 	  ``PILOT_AUTO``
 
@@ -581,7 +581,7 @@ fe_rolloff type
 
     -  .. row 2
 
-       -  .. _`ROLLOFF-35`:
+       -  .. _ROLLOFF-35:
 
 	  ``ROLLOFF_35``
 
@@ -589,7 +589,7 @@ fe_rolloff type
 
     -  .. row 3
 
-       -  .. _`ROLLOFF-20`:
+       -  .. _ROLLOFF-20:
 
 	  ``ROLLOFF_20``
 
@@ -597,7 +597,7 @@ fe_rolloff type
 
     -  .. row 4
 
-       -  .. _`ROLLOFF-25`:
+       -  .. _ROLLOFF-25:
 
 	  ``ROLLOFF_25``
 
@@ -605,7 +605,7 @@ fe_rolloff type
 
     -  .. row 5
 
-       -  .. _`ROLLOFF-AUTO`:
+       -  .. _ROLLOFF-AUTO:
 
 	  ``ROLLOFF_AUTO``
 
@@ -668,7 +668,7 @@ Possible values:
 
     -  .. row 2
 
-       -  .. _`SYS-UNDEFINED`:
+       -  .. _SYS-UNDEFINED:
 
 	  ``SYS_UNDEFINED``
 
@@ -676,7 +676,7 @@ Possible values:
 
     -  .. row 3
 
-       -  .. _`SYS-DVBC-ANNEX-A`:
+       -  .. _SYS-DVBC-ANNEX-A:
 
 	  ``SYS_DVBC_ANNEX_A``
 
@@ -684,7 +684,7 @@ Possible values:
 
     -  .. row 4
 
-       -  .. _`SYS-DVBC-ANNEX-B`:
+       -  .. _SYS-DVBC-ANNEX-B:
 
 	  ``SYS_DVBC_ANNEX_B``
 
@@ -692,7 +692,7 @@ Possible values:
 
     -  .. row 5
 
-       -  .. _`SYS-DVBC-ANNEX-C`:
+       -  .. _SYS-DVBC-ANNEX-C:
 
 	  ``SYS_DVBC_ANNEX_C``
 
@@ -700,7 +700,7 @@ Possible values:
 
     -  .. row 6
 
-       -  .. _`SYS-ISDBC`:
+       -  .. _SYS-ISDBC:
 
 	  ``SYS_ISDBC``
 
@@ -708,7 +708,7 @@ Possible values:
 
     -  .. row 7
 
-       -  .. _`SYS-DVBT`:
+       -  .. _SYS-DVBT:
 
 	  ``SYS_DVBT``
 
@@ -716,7 +716,7 @@ Possible values:
 
     -  .. row 8
 
-       -  .. _`SYS-DVBT2`:
+       -  .. _SYS-DVBT2:
 
 	  ``SYS_DVBT2``
 
@@ -724,7 +724,7 @@ Possible values:
 
     -  .. row 9
 
-       -  .. _`SYS-ISDBT`:
+       -  .. _SYS-ISDBT:
 
 	  ``SYS_ISDBT``
 
@@ -732,7 +732,7 @@ Possible values:
 
     -  .. row 10
 
-       -  .. _`SYS-ATSC`:
+       -  .. _SYS-ATSC:
 
 	  ``SYS_ATSC``
 
@@ -740,7 +740,7 @@ Possible values:
 
     -  .. row 11
 
-       -  .. _`SYS-ATSCMH`:
+       -  .. _SYS-ATSCMH:
 
 	  ``SYS_ATSCMH``
 
@@ -748,7 +748,7 @@ Possible values:
 
     -  .. row 12
 
-       -  .. _`SYS-DTMB`:
+       -  .. _SYS-DTMB:
 
 	  ``SYS_DTMB``
 
@@ -756,7 +756,7 @@ Possible values:
 
     -  .. row 13
 
-       -  .. _`SYS-DVBS`:
+       -  .. _SYS-DVBS:
 
 	  ``SYS_DVBS``
 
@@ -764,7 +764,7 @@ Possible values:
 
     -  .. row 14
 
-       -  .. _`SYS-DVBS2`:
+       -  .. _SYS-DVBS2:
 
 	  ``SYS_DVBS2``
 
@@ -772,7 +772,7 @@ Possible values:
 
     -  .. row 15
 
-       -  .. _`SYS-TURBO`:
+       -  .. _SYS-TURBO:
 
 	  ``SYS_TURBO``
 
@@ -780,7 +780,7 @@ Possible values:
 
     -  .. row 16
 
-       -  .. _`SYS-ISDBS`:
+       -  .. _SYS-ISDBS:
 
 	  ``SYS_ISDBS``
 
@@ -788,7 +788,7 @@ Possible values:
 
     -  .. row 17
 
-       -  .. _`SYS-DAB`:
+       -  .. _SYS-DAB:
 
 	  ``SYS_DAB``
 
@@ -796,7 +796,7 @@ Possible values:
 
     -  .. row 18
 
-       -  .. _`SYS-DSS`:
+       -  .. _SYS-DSS:
 
 	  ``SYS_DSS``
 
@@ -804,7 +804,7 @@ Possible values:
 
     -  .. row 19
 
-       -  .. _`SYS-CMMB`:
+       -  .. _SYS-CMMB:
 
 	  ``SYS_CMMB``
 
@@ -812,7 +812,7 @@ Possible values:
 
     -  .. row 20
 
-       -  .. _`SYS-DVBH`:
+       -  .. _SYS-DVBH:
 
 	  ``SYS_DVBH``
 
@@ -1238,7 +1238,7 @@ Possible values are:
 
     -  .. row 2
 
-       -  .. _`ATSCMH-RSFRAME-PRI-ONLY`:
+       -  .. _ATSCMH-RSFRAME-PRI-ONLY:
 
 	  ``ATSCMH_RSFRAME_PRI_ONLY``
 
@@ -1247,7 +1247,7 @@ Possible values are:
 
     -  .. row 3
 
-       -  .. _`ATSCMH-RSFRAME-PRI-SEC`:
+       -  .. _ATSCMH-RSFRAME-PRI-SEC:
 
 	  ``ATSCMH_RSFRAME_PRI_SEC``
 
@@ -1282,7 +1282,7 @@ Possible values are:
 
     -  .. row 2
 
-       -  .. _`ATSCMH-RSFRAME-ENS-PRI`:
+       -  .. _ATSCMH-RSFRAME-ENS-PRI:
 
 	  ``ATSCMH_RSFRAME_ENS_PRI``
 
@@ -1290,7 +1290,7 @@ Possible values are:
 
     -  .. row 3
 
-       -  .. _`ATSCMH-RSFRAME-ENS-SEC`:
+       -  .. _ATSCMH-RSFRAME-ENS-SEC:
 
 	  ``AATSCMH_RSFRAME_PRI_SEC``
 
@@ -1298,7 +1298,7 @@ Possible values are:
 
     -  .. row 4
 
-       -  .. _`ATSCMH-RSFRAME-RES`:
+       -  .. _ATSCMH-RSFRAME-RES:
 
 	  ``AATSCMH_RSFRAME_RES``
 
@@ -1331,7 +1331,7 @@ Possible values are:
 
     -  .. row 2
 
-       -  .. _`ATSCMH-RSCODE-211-187`:
+       -  .. _ATSCMH-RSCODE-211-187:
 
 	  ``ATSCMH_RSCODE_211_187``
 
@@ -1339,7 +1339,7 @@ Possible values are:
 
     -  .. row 3
 
-       -  .. _`ATSCMH-RSCODE-223-187`:
+       -  .. _ATSCMH-RSCODE-223-187:
 
 	  ``ATSCMH_RSCODE_223_187``
 
@@ -1347,7 +1347,7 @@ Possible values are:
 
     -  .. row 4
 
-       -  .. _`ATSCMH-RSCODE-235-187`:
+       -  .. _ATSCMH-RSCODE-235-187:
 
 	  ``ATSCMH_RSCODE_235_187``
 
@@ -1355,7 +1355,7 @@ Possible values are:
 
     -  .. row 5
 
-       -  .. _`ATSCMH-RSCODE-RES`:
+       -  .. _ATSCMH-RSCODE-RES:
 
 	  ``ATSCMH_RSCODE_RES``
 
@@ -1399,7 +1399,7 @@ Possible values are:
 
     -  .. row 2
 
-       -  .. _`ATSCMH-SCCC-BLK-SEP`:
+       -  .. _ATSCMH-SCCC-BLK-SEP:
 
 	  ``ATSCMH_SCCC_BLK_SEP``
 
@@ -1408,7 +1408,7 @@ Possible values are:
 
     -  .. row 3
 
-       -  .. _`ATSCMH-SCCC-BLK-COMB`:
+       -  .. _ATSCMH-SCCC-BLK-COMB:
 
 	  ``ATSCMH_SCCC_BLK_COMB``
 
@@ -1417,7 +1417,7 @@ Possible values are:
 
     -  .. row 4
 
-       -  .. _`ATSCMH-SCCC-BLK-RES`:
+       -  .. _ATSCMH-SCCC-BLK-RES:
 
 	  ``ATSCMH_SCCC_BLK_RES``
 
@@ -1450,7 +1450,7 @@ Possible values are:
 
     -  .. row 2
 
-       -  .. _`ATSCMH-SCCC-CODE-HLF`:
+       -  .. _ATSCMH-SCCC-CODE-HLF:
 
 	  ``ATSCMH_SCCC_CODE_HLF``
 
@@ -1458,7 +1458,7 @@ Possible values are:
 
     -  .. row 3
 
-       -  .. _`ATSCMH-SCCC-CODE-QTR`:
+       -  .. _ATSCMH-SCCC-CODE-QTR:
 
 	  ``ATSCMH_SCCC_CODE_QTR``
 
@@ -1466,7 +1466,7 @@ Possible values are:
 
     -  .. row 4
 
-       -  .. _`ATSCMH-SCCC-CODE-RES`:
+       -  .. _ATSCMH-SCCC-CODE-RES:
 
 	  ``ATSCMH_SCCC_CODE_RES``
 
@@ -1562,7 +1562,7 @@ Modulation guard interval
 
     -  .. row 2
 
-       -  .. _`GUARD-INTERVAL-AUTO`:
+       -  .. _GUARD-INTERVAL-AUTO:
 
 	  ``GUARD_INTERVAL_AUTO``
 
@@ -1570,7 +1570,7 @@ Modulation guard interval
 
     -  .. row 3
 
-       -  .. _`GUARD-INTERVAL-1-128`:
+       -  .. _GUARD-INTERVAL-1-128:
 
 	  ``GUARD_INTERVAL_1_128``
 
@@ -1578,7 +1578,7 @@ Modulation guard interval
 
     -  .. row 4
 
-       -  .. _`GUARD-INTERVAL-1-32`:
+       -  .. _GUARD-INTERVAL-1-32:
 
 	  ``GUARD_INTERVAL_1_32``
 
@@ -1586,7 +1586,7 @@ Modulation guard interval
 
     -  .. row 5
 
-       -  .. _`GUARD-INTERVAL-1-16`:
+       -  .. _GUARD-INTERVAL-1-16:
 
 	  ``GUARD_INTERVAL_1_16``
 
@@ -1594,7 +1594,7 @@ Modulation guard interval
 
     -  .. row 6
 
-       -  .. _`GUARD-INTERVAL-1-8`:
+       -  .. _GUARD-INTERVAL-1-8:
 
 	  ``GUARD_INTERVAL_1_8``
 
@@ -1602,7 +1602,7 @@ Modulation guard interval
 
     -  .. row 7
 
-       -  .. _`GUARD-INTERVAL-1-4`:
+       -  .. _GUARD-INTERVAL-1-4:
 
 	  ``GUARD_INTERVAL_1_4``
 
@@ -1610,7 +1610,7 @@ Modulation guard interval
 
     -  .. row 8
 
-       -  .. _`GUARD-INTERVAL-19-128`:
+       -  .. _GUARD-INTERVAL-19-128:
 
 	  ``GUARD_INTERVAL_19_128``
 
@@ -1618,7 +1618,7 @@ Modulation guard interval
 
     -  .. row 9
 
-       -  .. _`GUARD-INTERVAL-19-256`:
+       -  .. _GUARD-INTERVAL-19-256:
 
 	  ``GUARD_INTERVAL_19_256``
 
@@ -1626,7 +1626,7 @@ Modulation guard interval
 
     -  .. row 10
 
-       -  .. _`GUARD-INTERVAL-PN420`:
+       -  .. _GUARD-INTERVAL-PN420:
 
 	  ``GUARD_INTERVAL_PN420``
 
@@ -1634,7 +1634,7 @@ Modulation guard interval
 
     -  .. row 11
 
-       -  .. _`GUARD-INTERVAL-PN595`:
+       -  .. _GUARD-INTERVAL-PN595:
 
 	  ``GUARD_INTERVAL_PN595``
 
@@ -1642,7 +1642,7 @@ Modulation guard interval
 
     -  .. row 12
 
-       -  .. _`GUARD-INTERVAL-PN945`:
+       -  .. _GUARD-INTERVAL-PN945:
 
 	  ``GUARD_INTERVAL_PN945``
 
@@ -1691,7 +1691,7 @@ enum fe_transmit_mode: Number of carriers per channel
 
     -  .. row 2
 
-       -  .. _`TRANSMISSION-MODE-AUTO`:
+       -  .. _TRANSMISSION-MODE-AUTO:
 
 	  ``TRANSMISSION_MODE_AUTO``
 
@@ -1700,7 +1700,7 @@ enum fe_transmit_mode: Number of carriers per channel
 
     -  .. row 3
 
-       -  .. _`TRANSMISSION-MODE-1K`:
+       -  .. _TRANSMISSION-MODE-1K:
 
 	  ``TRANSMISSION_MODE_1K``
 
@@ -1708,7 +1708,7 @@ enum fe_transmit_mode: Number of carriers per channel
 
     -  .. row 4
 
-       -  .. _`TRANSMISSION-MODE-2K`:
+       -  .. _TRANSMISSION-MODE-2K:
 
 	  ``TRANSMISSION_MODE_2K``
 
@@ -1716,7 +1716,7 @@ enum fe_transmit_mode: Number of carriers per channel
 
     -  .. row 5
 
-       -  .. _`TRANSMISSION-MODE-8K`:
+       -  .. _TRANSMISSION-MODE-8K:
 
 	  ``TRANSMISSION_MODE_8K``
 
@@ -1724,7 +1724,7 @@ enum fe_transmit_mode: Number of carriers per channel
 
     -  .. row 6
 
-       -  .. _`TRANSMISSION-MODE-4K`:
+       -  .. _TRANSMISSION-MODE-4K:
 
 	  ``TRANSMISSION_MODE_4K``
 
@@ -1732,7 +1732,7 @@ enum fe_transmit_mode: Number of carriers per channel
 
     -  .. row 7
 
-       -  .. _`TRANSMISSION-MODE-16K`:
+       -  .. _TRANSMISSION-MODE-16K:
 
 	  ``TRANSMISSION_MODE_16K``
 
@@ -1740,7 +1740,7 @@ enum fe_transmit_mode: Number of carriers per channel
 
     -  .. row 8
 
-       -  .. _`TRANSMISSION-MODE-32K`:
+       -  .. _TRANSMISSION-MODE-32K:
 
 	  ``TRANSMISSION_MODE_32K``
 
@@ -1748,7 +1748,7 @@ enum fe_transmit_mode: Number of carriers per channel
 
     -  .. row 9
 
-       -  .. _`TRANSMISSION-MODE-C1`:
+       -  .. _TRANSMISSION-MODE-C1:
 
 	  ``TRANSMISSION_MODE_C1``
 
@@ -1756,7 +1756,7 @@ enum fe_transmit_mode: Number of carriers per channel
 
     -  .. row 10
 
-       -  .. _`TRANSMISSION-MODE-C3780`:
+       -  .. _TRANSMISSION-MODE-C3780:
 
 	  ``TRANSMISSION_MODE_C3780``
 
@@ -1808,7 +1808,7 @@ Frontend hierarchy
 
     -  .. row 2
 
-       -  .. _`HIERARCHY-NONE`:
+       -  .. _HIERARCHY-NONE:
 
 	  ``HIERARCHY_NONE``
 
@@ -1816,7 +1816,7 @@ Frontend hierarchy
 
     -  .. row 3
 
-       -  .. _`HIERARCHY-AUTO`:
+       -  .. _HIERARCHY-AUTO:
 
 	  ``HIERARCHY_AUTO``
 
@@ -1824,7 +1824,7 @@ Frontend hierarchy
 
     -  .. row 4
 
-       -  .. _`HIERARCHY-1`:
+       -  .. _HIERARCHY-1:
 
 	  ``HIERARCHY_1``
 
@@ -1832,7 +1832,7 @@ Frontend hierarchy
 
     -  .. row 5
 
-       -  .. _`HIERARCHY-2`:
+       -  .. _HIERARCHY-2:
 
 	  ``HIERARCHY_2``
 
@@ -1840,7 +1840,7 @@ Frontend hierarchy
 
     -  .. row 6
 
-       -  .. _`HIERARCHY-4`:
+       -  .. _HIERARCHY-4:
 
 	  ``HIERARCHY_4``
 
@@ -1915,7 +1915,7 @@ Time interleaving to be used. Currently, used only on DTMB.
 
     -  .. row 2
 
-       -  .. _`INTERLEAVING-NONE`:
+       -  .. _INTERLEAVING-NONE:
 
 	  ``INTERLEAVING_NONE``
 
@@ -1923,7 +1923,7 @@ Time interleaving to be used. Currently, used only on DTMB.
 
     -  .. row 3
 
-       -  .. _`INTERLEAVING-AUTO`:
+       -  .. _INTERLEAVING-AUTO:
 
 	  ``INTERLEAVING_AUTO``
 
@@ -1931,7 +1931,7 @@ Time interleaving to be used. Currently, used only on DTMB.
 
     -  .. row 4
 
-       -  .. _`INTERLEAVING-240`:
+       -  .. _INTERLEAVING-240:
 
 	  ``INTERLEAVING_240``
 
@@ -1939,7 +1939,7 @@ Time interleaving to be used. Currently, used only on DTMB.
 
     -  .. row 5
 
-       -  .. _`INTERLEAVING-720`:
+       -  .. _INTERLEAVING-720:
 
 	  ``INTERLEAVING_720``
 
diff --git a/Documentation/linux_tv/media/v4l/control.rst b/Documentation/linux_tv/media/v4l/control.rst
index de88007a8dff..6cf218ab36fb 100644
--- a/Documentation/linux_tv/media/v4l/control.rst
+++ b/Documentation/linux_tv/media/v4l/control.rst
@@ -143,7 +143,7 @@ Control IDs
 ``V4L2_CID_VFLIP`` ``(boolean)``
     Mirror the picture vertically.
 
-.. _`v4l2-power-line-frequency`:
+.. _v4l2-power-line-frequency:
 
 ``V4L2_CID_POWER_LINE_FREQUENCY`` ``(enum)``
     Enables a power line frequency filter to avoid flicker. Possible
@@ -184,7 +184,7 @@ Control IDs
     Enable the color killer (i. e. force a black & white image in case
     of a weak video signal).
 
-.. _`v4l2-colorfx`:
+.. _v4l2-colorfx:
 
 ``V4L2_CID_COLORFX`` ``(enum)``
     Selects a color effect. The following values are defined:
@@ -337,7 +337,7 @@ Control IDs
     REQBUFS. The value is the minimum number of OUTPUT buffers that is
     necessary for hardware to work.
 
-.. _`v4l2-alpha-component`:
+.. _v4l2-alpha-component:
 
 ``V4L2_CID_ALPHA_COMPONENT`` ``(integer)``
     Sets the alpha color component. When a capture device (or capture
diff --git a/Documentation/linux_tv/media/v4l/extended-controls.rst b/Documentation/linux_tv/media/v4l/extended-controls.rst
index d18c3b9896d9..26eb6ee851c3 100644
--- a/Documentation/linux_tv/media/v4l/extended-controls.rst
+++ b/Documentation/linux_tv/media/v4l/extended-controls.rst
@@ -202,7 +202,7 @@ Codec Control IDs
     return a description of this control class. This description can be
     used as the caption of a Tab page in a GUI, for example.
 
-.. _`v4l2-mpeg-stream-type`:
+.. _v4l2-mpeg-stream-type:
 
 ``V4L2_CID_MPEG_STREAM_TYPE (enum v4l2_mpeg_stream_type)``
     The MPEG-1, -2 or -4 output stream type. One cannot assume anything
@@ -275,7 +275,7 @@ Codec Control IDs
 ``V4L2_CID_MPEG_STREAM_PES_ID_VIDEO (integer)``
     Video ID for MPEG PES
 
-.. _`v4l2-mpeg-stream-vbi-fmt`:
+.. _v4l2-mpeg-stream-vbi-fmt:
 
 ``V4L2_CID_MPEG_STREAM_VBI_FMT (enum v4l2_mpeg_stream_vbi_fmt)``
     Some cards can embed VBI data (e. g. Closed Caption, Teletext) into
@@ -307,7 +307,7 @@ Codec Control IDs
 
 
 
-.. _`v4l2-mpeg-audio-sampling-freq`:
+.. _v4l2-mpeg-audio-sampling-freq:
 
 ``V4L2_CID_MPEG_AUDIO_SAMPLING_FREQ (enum v4l2_mpeg_audio_sampling_freq)``
     MPEG Audio sampling frequency. Possible values are:
@@ -339,7 +339,7 @@ Codec Control IDs
 
 
 
-.. _`v4l2-mpeg-audio-encoding`:
+.. _v4l2-mpeg-audio-encoding:
 
 ``V4L2_CID_MPEG_AUDIO_ENCODING (enum v4l2_mpeg_audio_encoding)``
     MPEG Audio encoding. This control is specific to multiplexed MPEG
@@ -384,7 +384,7 @@ Codec Control IDs
 
 
 
-.. _`v4l2-mpeg-audio-l1-bitrate`:
+.. _v4l2-mpeg-audio-l1-bitrate:
 
 ``V4L2_CID_MPEG_AUDIO_L1_BITRATE (enum v4l2_mpeg_audio_l1_bitrate)``
     MPEG-1/2 Layer I bitrate. Possible values are:
@@ -482,7 +482,7 @@ Codec Control IDs
 
 
 
-.. _`v4l2-mpeg-audio-l2-bitrate`:
+.. _v4l2-mpeg-audio-l2-bitrate:
 
 ``V4L2_CID_MPEG_AUDIO_L2_BITRATE (enum v4l2_mpeg_audio_l2_bitrate)``
     MPEG-1/2 Layer II bitrate. Possible values are:
@@ -580,7 +580,7 @@ Codec Control IDs
 
 
 
-.. _`v4l2-mpeg-audio-l3-bitrate`:
+.. _v4l2-mpeg-audio-l3-bitrate:
 
 ``V4L2_CID_MPEG_AUDIO_L3_BITRATE (enum v4l2_mpeg_audio_l3_bitrate)``
     MPEG-1/2 Layer III bitrate. Possible values are:
@@ -681,7 +681,7 @@ Codec Control IDs
 ``V4L2_CID_MPEG_AUDIO_AAC_BITRATE (integer)``
     AAC bitrate in bits per second.
 
-.. _`v4l2-mpeg-audio-ac3-bitrate`:
+.. _v4l2-mpeg-audio-ac3-bitrate:
 
 ``V4L2_CID_MPEG_AUDIO_AC3_BITRATE (enum v4l2_mpeg_audio_ac3_bitrate)``
     AC-3 bitrate. Possible values are:
@@ -809,7 +809,7 @@ Codec Control IDs
 
 
 
-.. _`v4l2-mpeg-audio-mode`:
+.. _v4l2-mpeg-audio-mode:
 
 ``V4L2_CID_MPEG_AUDIO_MODE (enum v4l2_mpeg_audio_mode)``
     MPEG Audio mode. Possible values are:
@@ -847,7 +847,7 @@ Codec Control IDs
 
 
 
-.. _`v4l2-mpeg-audio-mode-extension`:
+.. _v4l2-mpeg-audio-mode-extension:
 
 ``V4L2_CID_MPEG_AUDIO_MODE_EXTENSION (enum v4l2_mpeg_audio_mode_extension)``
     Joint Stereo audio mode extension. In Layer I and II they indicate
@@ -887,7 +887,7 @@ Codec Control IDs
 
 
 
-.. _`v4l2-mpeg-audio-emphasis`:
+.. _v4l2-mpeg-audio-emphasis:
 
 ``V4L2_CID_MPEG_AUDIO_EMPHASIS (enum v4l2_mpeg_audio_emphasis)``
     Audio Emphasis. Possible values are:
@@ -919,7 +919,7 @@ Codec Control IDs
 
 
 
-.. _`v4l2-mpeg-audio-crc`:
+.. _v4l2-mpeg-audio-crc:
 
 ``V4L2_CID_MPEG_AUDIO_CRC (enum v4l2_mpeg_audio_crc)``
     CRC method. Possible values are:
@@ -951,7 +951,7 @@ Codec Control IDs
     itself, guaranteeing a fixed and reproducible audio bitstream. 0 =
     unmuted, 1 = muted.
 
-.. _`v4l2-mpeg-audio-dec-playback`:
+.. _v4l2-mpeg-audio-dec-playback:
 
 ``V4L2_CID_MPEG_AUDIO_DEC_PLAYBACK (enum v4l2_mpeg_audio_dec_playback)``
     Determines how monolingual audio should be played back. Possible
@@ -1002,12 +1002,12 @@ Codec Control IDs
 
 
 
-.. _`v4l2-mpeg-audio-dec-multilingual-playback`:
+.. _v4l2-mpeg-audio-dec-multilingual-playback:
 
 ``V4L2_CID_MPEG_AUDIO_DEC_MULTILINGUAL_PLAYBACK (enum v4l2_mpeg_audio_dec_playback)``
     Determines how multilingual audio should be played back.
 
-.. _`v4l2-mpeg-video-encoding`:
+.. _v4l2-mpeg-video-encoding:
 
 ``V4L2_CID_MPEG_VIDEO_ENCODING (enum v4l2_mpeg_video_encoding)``
     MPEG Video encoding method. This control is specific to multiplexed
@@ -1040,7 +1040,7 @@ Codec Control IDs
 
 
 
-.. _`v4l2-mpeg-video-aspect`:
+.. _v4l2-mpeg-video-aspect:
 
 ``V4L2_CID_MPEG_VIDEO_ASPECT (enum v4l2_mpeg_video_aspect)``
     Video aspect. Possible values are:
@@ -1082,7 +1082,7 @@ Codec Control IDs
 ``V4L2_CID_MPEG_VIDEO_PULLDOWN (boolean)``
     Enable 3:2 pulldown (default 0)
 
-.. _`v4l2-mpeg-video-bitrate-mode`:
+.. _v4l2-mpeg-video-bitrate-mode:
 
 ``V4L2_CID_MPEG_VIDEO_BITRATE_MODE (enum v4l2_mpeg_video_bitrate_mode)``
     Video bitrate mode. Possible values are:
@@ -1162,7 +1162,7 @@ Codec Control IDs
 
 
 
-.. _`v4l2-mpeg-video-dec-pts`:
+.. _v4l2-mpeg-video-dec-pts:
 
 ``V4L2_CID_MPEG_VIDEO_DEC_PTS (integer64)``
     This read-only control returns the 33-bit video Presentation Time
@@ -1170,7 +1170,7 @@ Codec Control IDs
     currently displayed frame. This is the same PTS as is used in
     :ref:`VIDIOC_DECODER_CMD`.
 
-.. _`v4l2-mpeg-video-dec-frame`:
+.. _v4l2-mpeg-video-dec-frame:
 
 ``V4L2_CID_MPEG_VIDEO_DEC_FRAME (integer64)``
     This read-only control returns the frame counter of the frame that
@@ -1186,7 +1186,7 @@ Codec Control IDs
     Enable writing sample aspect ratio in the Video Usability
     Information. Applicable to the H264 encoder.
 
-.. _`v4l2-mpeg-video-h264-vui-sar-idc`:
+.. _v4l2-mpeg-video-h264-vui-sar-idc:
 
 ``V4L2_CID_MPEG_VIDEO_H264_VUI_SAR_IDC (enum v4l2_mpeg_video_h264_vui_sar_idc)``
     VUI sample aspect ratio indicator for H.264 encoding. The value is
@@ -1318,7 +1318,7 @@ Codec Control IDs
     Extended sample aspect ratio height for H.264 VUI encoding.
     Applicable to the H264 encoder.
 
-.. _`v4l2-mpeg-video-h264-level`:
+.. _v4l2-mpeg-video-h264-level:
 
 ``V4L2_CID_MPEG_VIDEO_H264_LEVEL (enum v4l2_mpeg_video_h264_level)``
     The level information for the H264 video elementary stream.
@@ -1429,7 +1429,7 @@ Codec Control IDs
 
 
 
-.. _`v4l2-mpeg-video-mpeg4-level`:
+.. _v4l2-mpeg-video-mpeg4-level:
 
 ``V4L2_CID_MPEG_VIDEO_MPEG4_LEVEL (enum v4l2_mpeg_video_mpeg4_level)``
     The level information for the MPEG4 elementary stream. Applicable to
@@ -1492,7 +1492,7 @@ Codec Control IDs
 
 
 
-.. _`v4l2-mpeg-video-h264-profile`:
+.. _v4l2-mpeg-video-h264-profile:
 
 ``V4L2_CID_MPEG_VIDEO_H264_PROFILE (enum v4l2_mpeg_video_h264_profile)``
     The profile information for H264. Applicable to the H264 encoder.
@@ -1609,7 +1609,7 @@ Codec Control IDs
 
 
 
-.. _`v4l2-mpeg-video-mpeg4-profile`:
+.. _v4l2-mpeg-video-mpeg4-profile:
 
 ``V4L2_CID_MPEG_VIDEO_MPEG4_PROFILE (enum v4l2_mpeg_video_mpeg4_profile)``
     The profile information for MPEG4. Applicable to the MPEG4 encoder.
@@ -1658,7 +1658,7 @@ Codec Control IDs
     The maximum number of reference pictures used for encoding.
     Applicable to the encoder.
 
-.. _`v4l2-mpeg-video-multi-slice-mode`:
+.. _v4l2-mpeg-video-multi-slice-mode:
 
 ``V4L2_CID_MPEG_VIDEO_MULTI_SLICE_MODE (enum v4l2_mpeg_video_multi_slice_mode)``
     Determines how the encoder should handle division of frame into
@@ -1703,7 +1703,7 @@ Codec Control IDs
     ``V4L2_MPEG_VIDEO_MULTI_SLICE_MODE_MAX_BYTES``. Applicable to the
     encoder.
 
-.. _`v4l2-mpeg-video-h264-loop-filter-mode`:
+.. _v4l2-mpeg-video-h264-loop-filter-mode:
 
 ``V4L2_CID_MPEG_VIDEO_H264_LOOP_FILTER_MODE (enum v4l2_mpeg_video_h264_loop_filter_mode)``
     Loop filter mode for H264 encoder. Possible values are:
@@ -1743,7 +1743,7 @@ Codec Control IDs
     Loop filter beta coefficient, defined in the H264 standard.
     Applicable to the H264 encoder.
 
-.. _`v4l2-mpeg-video-h264-entropy-mode`:
+.. _v4l2-mpeg-video-h264-entropy-mode:
 
 ``V4L2_CID_MPEG_VIDEO_H264_ENTROPY_MODE (enum v4l2_mpeg_video_h264_entropy_mode)``
     Entropy coding mode for H264 - CABAC/CAVALC. Applicable to the H264
@@ -1861,12 +1861,12 @@ Codec Control IDs
     data rate that an encoder or editing process may produce.".
     Applicable to the MPEG1, MPEG2, MPEG4 encoders.
 
-.. _`v4l2-mpeg-video-vbv-delay`:
+.. _v4l2-mpeg-video-vbv-delay:
 
 ``V4L2_CID_MPEG_VIDEO_VBV_DELAY (integer)``
     Sets the initial delay in milliseconds for VBV buffer control.
 
-.. _`v4l2-mpeg-video-hor-search-range`:
+.. _v4l2-mpeg-video-hor-search-range:
 
 ``V4L2_CID_MPEG_VIDEO_MV_H_SEARCH_RANGE (integer)``
     Horizontal search range defines maximum horizontal search area in
@@ -1874,7 +1874,7 @@ Codec Control IDs
     reference picture. This V4L2 control macro is used to set horizontal
     search range for motion estimation module in video encoder.
 
-.. _`v4l2-mpeg-video-vert-search-range`:
+.. _v4l2-mpeg-video-vert-search-range:
 
 ``V4L2_CID_MPEG_VIDEO_MV_V_SEARCH_RANGE (integer)``
     Vertical search range defines maximum vertical search area in pixels
@@ -1882,7 +1882,7 @@ Codec Control IDs
     picture. This V4L2 control macro is used to set vertical search
     range for motion estimation module in video encoder.
 
-.. _`v4l2-mpeg-video-force-key-frame`:
+.. _v4l2-mpeg-video-force-key-frame:
 
 ``V4L2_CID_MPEG_VIDEO_FORCE_KEY_FRAME (button)``
     Force a key frame for the next queued buffer. Applicable to
@@ -1904,7 +1904,7 @@ Codec Control IDs
     the need to store or decode any previous frames. Applicable to the
     H264 encoder.
 
-.. _`v4l2-mpeg-video-header-mode`:
+.. _v4l2-mpeg-video-header-mode:
 
 ``V4L2_CID_MPEG_VIDEO_HEADER_MODE (enum v4l2_mpeg_video_header_mode)``
     Determines whether the header is returned as the first buffer or is
@@ -1960,7 +1960,7 @@ Codec Control IDs
     Sets current frame as frame0 in frame packing SEI. Applicable to the
     H264 encoder.
 
-.. _`v4l2-mpeg-video-h264-sei-fp-arrangement-type`:
+.. _v4l2-mpeg-video-h264-sei-fp-arrangement-type:
 
 ``V4L2_CID_MPEG_VIDEO_H264_SEI_FP_ARRANGEMENT_TYPE (enum v4l2_mpeg_video_h264_sei_fp_arrangement_type)``
     Frame packing arrangement type for H264 SEI. Applicable to the H264
@@ -2016,7 +2016,7 @@ Codec Control IDs
     a technique used for restructuring the ordering of macroblocks in
     pictures. Applicable to the H264 encoder.
 
-.. _`v4l2-mpeg-video-h264-fmo-map-type`:
+.. _v4l2-mpeg-video-h264-fmo-map-type:
 
 ``V4L2_CID_MPEG_VIDEO_H264_FMO_MAP_TYPE (enum v4l2_mpeg_video_h264_fmo_map_type)``
     When using FMO, the map type divides the image in different scan
@@ -2079,7 +2079,7 @@ Codec Control IDs
 ``V4L2_CID_MPEG_VIDEO_H264_FMO_SLICE_GROUP (integer)``
     Number of slice groups in FMO. Applicable to the H264 encoder.
 
-.. _`v4l2-mpeg-video-h264-fmo-change-direction`:
+.. _v4l2-mpeg-video-h264-fmo-change-direction:
 
 ``V4L2_CID_MPEG_VIDEO_H264_FMO_CHANGE_DIRECTION (enum v4l2_mpeg_video_h264_fmo_change_dir)``
     Specifies a direction of the slice group change for raster and wipe
@@ -2147,7 +2147,7 @@ Codec Control IDs
 ``V4L2_CID_MPEG_VIDEO_H264_HIERARCHICAL_CODING (boolean)``
     Enables H264 hierarchical coding. Applicable to the H264 encoder.
 
-.. _`v4l2-mpeg-video-h264-hierarchical-coding-type`:
+.. _v4l2-mpeg-video-h264-hierarchical-coding-type:
 
 ``V4L2_CID_MPEG_VIDEO_H264_HIERARCHICAL_CODING_TYPE (enum v4l2_mpeg_video_h264_hierarchical_coding_type)``
     Specifies the hierarchical coding type. Applicable to the H264
@@ -2314,7 +2314,7 @@ MFC 5.1 Control IDs
     (``V4L2_CID_MPEG_VIDEO_MB_RC_ENABLE``). Applicable to the H264
     encoder.
 
-.. _`v4l2-mpeg-mfc51-video-frame-skip-mode`:
+.. _v4l2-mpeg-mfc51-video-frame-skip-mode:
 
 ``V4L2_CID_MPEG_MFC51_VIDEO_FRAME_SKIP_MODE (enum v4l2_mpeg_mfc51_video_frame_skip_mode)``
     Indicates in what conditions the encoder should skip frames. If
@@ -2363,7 +2363,7 @@ MFC 5.1 Control IDs
     the other hand enabling this setting will ensure that the stream
     will meet tight bandwidth constraints. Applicable to encoders.
 
-.. _`v4l2-mpeg-mfc51-video-force-frame-type`:
+.. _v4l2-mpeg-mfc51-video-force-frame-type:
 
 ``V4L2_CID_MPEG_MFC51_VIDEO_FORCE_FRAME_TYPE (enum v4l2_mpeg_mfc51_video_force_frame_type)``
     Force a frame type for the next queued buffer. Applicable to
@@ -2409,7 +2409,7 @@ are specific to the Conexant CX23415 and CX23416 MPEG encoding chips.
 CX2341x Control IDs
 ^^^^^^^^^^^^^^^^^^^
 
-.. _`v4l2-mpeg-cx2341x-video-spatial-filter-mode`:
+.. _v4l2-mpeg-cx2341x-video-spatial-filter-mode:
 
 ``V4L2_CID_MPEG_CX2341X_VIDEO_SPATIAL_FILTER_MODE (enum v4l2_mpeg_cx2341x_video_spatial_filter_mode)``
     Sets the Spatial Filter mode (default ``MANUAL``). Possible values
@@ -2440,7 +2440,7 @@ CX2341x Control IDs
     The setting for the Spatial Filter. 0 = off, 15 = maximum. (Default
     is 0.)
 
-.. _`luma-spatial-filter-type`:
+.. _luma-spatial-filter-type:
 
 ``V4L2_CID_MPEG_CX2341X_VIDEO_LUMA_SPATIAL_FILTER_TYPE (enum v4l2_mpeg_cx2341x_video_luma_spatial_filter_type)``
     Select the algorithm to use for the Luma Spatial Filter (default
@@ -2485,7 +2485,7 @@ CX2341x Control IDs
 
 
 
-.. _`chroma-spatial-filter-type`:
+.. _chroma-spatial-filter-type:
 
 ``V4L2_CID_MPEG_CX2341X_VIDEO_CHROMA_SPATIAL_FILTER_TYPE (enum v4l2_mpeg_cx2341x_video_chroma_spatial_filter_type)``
     Select the algorithm for the Chroma Spatial Filter (default
@@ -2512,7 +2512,7 @@ CX2341x Control IDs
 
 
 
-.. _`v4l2-mpeg-cx2341x-video-temporal-filter-mode`:
+.. _v4l2-mpeg-cx2341x-video-temporal-filter-mode:
 
 ``V4L2_CID_MPEG_CX2341X_VIDEO_TEMPORAL_FILTER_MODE (enum v4l2_mpeg_cx2341x_video_temporal_filter_mode)``
     Sets the Temporal Filter mode (default ``MANUAL``). Possible values
@@ -2543,7 +2543,7 @@ CX2341x Control IDs
     The setting for the Temporal Filter. 0 = off, 31 = maximum. (Default
     is 8 for full-scale capturing and 0 for scaled capturing.)
 
-.. _`v4l2-mpeg-cx2341x-video-median-filter-type`:
+.. _v4l2-mpeg-cx2341x-video-median-filter-type:
 
 ``V4L2_CID_MPEG_CX2341X_VIDEO_MEDIAN_FILTER_TYPE (enum v4l2_mpeg_cx2341x_video_median_filter_type)``
     Median Filter Type (default ``OFF``). Possible values are:
@@ -2624,7 +2624,7 @@ codec.
 VPX Control IDs
 ^^^^^^^^^^^^^^^
 
-.. _`v4l2-vpx-num-partitions`:
+.. _v4l2-vpx-num-partitions:
 
 ``V4L2_CID_MPEG_VIDEO_VPX_NUM_PARTITIONS (enum v4l2_vp8_num_partitions)``
     The number of token partitions to use in VP8 encoder. Possible
@@ -2666,7 +2666,7 @@ VPX Control IDs
 ``V4L2_CID_MPEG_VIDEO_VPX_IMD_DISABLE_4X4 (boolean)``
     Setting this prevents intra 4x4 mode in the intra mode decision.
 
-.. _`v4l2-vpx-num-ref-frames`:
+.. _v4l2-vpx-num-ref-frames:
 
 ``V4L2_CID_MPEG_VIDEO_VPX_NUM_REF_FRAMES (enum v4l2_vp8_num_ref_frames)``
     The number of reference pictures for encoding P frames. Possible
@@ -2719,7 +2719,7 @@ VPX Control IDs
     frame refresh period is set as 4, the frames 0, 4, 8 etc will be
     taken as the golden frames as frame 0 is always a key frame.
 
-.. _`v4l2-vpx-golden-frame-sel`:
+.. _v4l2-vpx-golden-frame-sel:
 
 ``V4L2_CID_MPEG_VIDEO_VPX_GOLDEN_FRAME_SEL (enum v4l2_vp8_golden_frame_sel)``
     Selects the golden frame for encoding. Possible values are:
@@ -2784,7 +2784,7 @@ Camera Control IDs
     :ref:`VIDIOC_QUERYCTRL` for this control will
     return a description of this control class.
 
-.. _`v4l2-exposure-auto-type`:
+.. _v4l2-exposure-auto-type:
 
 ``V4L2_CID_EXPOSURE_AUTO (enum v4l2_exposure_auto_type)``
     Enables automatic adjustments of the exposure time and/or iris
@@ -2849,7 +2849,7 @@ Camera Control IDs
     light at the image sensor. The camera performs the exposure
     compensation by adjusting absolute exposure time and/or aperture.
 
-.. _`v4l2-exposure-metering`:
+.. _v4l2-exposure-metering:
 
 ``V4L2_CID_EXPOSURE_METERING (enum v4l2_exposure_metering)``
     Determines how the camera measures the amount of light available for
@@ -2954,7 +2954,7 @@ Camera Control IDs
     disabled, that is when ``V4L2_CID_FOCUS_AUTO`` control is set to
     ``FALSE`` (0).
 
-.. _`v4l2-auto-focus-status`:
+.. _v4l2-auto-focus-status:
 
 ``V4L2_CID_AUTO_FOCUS_STATUS (bitmask)``
     The automatic focus status. This is a read-only control.
@@ -2997,7 +2997,7 @@ Camera Control IDs
 
 
 
-.. _`v4l2-auto-focus-range`:
+.. _v4l2-auto-focus-range:
 
 ``V4L2_CID_AUTO_FOCUS_RANGE (enum v4l2_auto_focus_range)``
     Determines auto focus distance range for which lens may be adjusted.
@@ -3081,7 +3081,7 @@ Camera Control IDs
     its strength. Such band-stop filters can be used, for example, to
     filter out the fluorescent light component.
 
-.. _`v4l2-auto-n-preset-white-balance`:
+.. _v4l2-auto-n-preset-white-balance:
 
 ``V4L2_CID_AUTO_N_PRESET_WHITE_BALANCE (enum v4l2_auto_n_preset_white_balance)``
     Sets white balance to automatic, manual or a preset. The presets
@@ -3170,7 +3170,7 @@ Camera Control IDs
 
 
 
-.. _`v4l2-wide-dynamic-range`:
+.. _v4l2-wide-dynamic-range:
 
 ``V4L2_CID_WIDE_DYNAMIC_RANGE (boolean)``
     Enables or disables the camera's wide dynamic range feature. This
@@ -3180,7 +3180,7 @@ Camera Control IDs
     commonly realized in cameras by combining two subsequent frames with
     different exposure times.  [1]_
 
-.. _`v4l2-image-stabilization`:
+.. _v4l2-image-stabilization:
 
 ``V4L2_CID_IMAGE_STABILIZATION (boolean)``
     Enables or disables image stabilization.
@@ -3198,7 +3198,7 @@ Camera Control IDs
     than ``V4L2_CID_ISO_SENSITIVITY_MANUAL`` is undefined, drivers
     should ignore such requests.
 
-.. _`v4l2-iso-sensitivity-auto-type`:
+.. _v4l2-iso-sensitivity-auto-type:
 
 ``V4L2_CID_ISO_SENSITIVITY_AUTO (enum v4l2_iso_sensitivity_type)``
     Enables or disables automatic ISO sensitivity adjustments.
@@ -3224,7 +3224,7 @@ Camera Control IDs
 
 
 
-.. _`v4l2-scene-mode`:
+.. _v4l2-scene-mode:
 
 ``V4L2_CID_SCENE_MODE (enum v4l2_scene_mode)``
     This control allows to select scene programs as the camera automatic
@@ -3936,7 +3936,7 @@ JPEG Control IDs
     ``V4L2_CID_JPEG_RESTART_INTERVAL`` control is set to 0, DRI and RSTm
     markers will not be inserted.
 
-.. _`jpeg-quality-control`:
+.. _jpeg-quality-control:
 
 ``V4L2_CID_JPEG_COMPRESSION_QUALITY (integer)``
     ``V4L2_CID_JPEG_COMPRESSION_QUALITY`` control determines trade-off
@@ -3952,7 +3952,7 @@ JPEG Control IDs
     non-zero values are meaningful. The recommended range is 1 - 100,
     where larger values correspond to better image quality.
 
-.. _`jpeg-active-marker-control`:
+.. _jpeg-active-marker-control:
 
 ``V4L2_CID_JPEG_ACTIVE_MARKER (bitmask)``
     Specify which JPEG markers are included in compressed stream. This
diff --git a/Documentation/linux_tv/media/v4l/pixfmt-013.rst b/Documentation/linux_tv/media/v4l/pixfmt-013.rst
index eefbd83766eb..475f6e6fe785 100644
--- a/Documentation/linux_tv/media/v4l/pixfmt-013.rst
+++ b/Documentation/linux_tv/media/v4l/pixfmt-013.rst
@@ -21,7 +21,7 @@ Compressed Formats
 
        -  Details
 
-    -  .. _`V4L2-PIX-FMT-JPEG`:
+    -  .. _V4L2-PIX-FMT-JPEG:
 
        -  ``V4L2_PIX_FMT_JPEG``
 
@@ -30,7 +30,7 @@ Compressed Formats
        -  TBD. See also :ref:`VIDIOC_G_JPEGCOMP <VIDIOC_G_JPEGCOMP>`,
 	  :ref:`VIDIOC_S_JPEGCOMP <VIDIOC_G_JPEGCOMP>`.
 
-    -  .. _`V4L2-PIX-FMT-MPEG`:
+    -  .. _V4L2-PIX-FMT-MPEG:
 
        -  ``V4L2_PIX_FMT_MPEG``
 
@@ -40,7 +40,7 @@ Compressed Formats
 	  extended control ``V4L2_CID_MPEG_STREAM_TYPE``, see
 	  :ref:`mpeg-control-id`.
 
-    -  .. _`V4L2-PIX-FMT-H264`:
+    -  .. _V4L2-PIX-FMT-H264:
 
        -  ``V4L2_PIX_FMT_H264``
 
@@ -48,7 +48,7 @@ Compressed Formats
 
        -  H264 video elementary stream with start codes.
 
-    -  .. _`V4L2-PIX-FMT-H264-NO-SC`:
+    -  .. _V4L2-PIX-FMT-H264-NO-SC:
 
        -  ``V4L2_PIX_FMT_H264_NO_SC``
 
@@ -56,7 +56,7 @@ Compressed Formats
 
        -  H264 video elementary stream without start codes.
 
-    -  .. _`V4L2-PIX-FMT-H264-MVC`:
+    -  .. _V4L2-PIX-FMT-H264-MVC:
 
        -  ``V4L2_PIX_FMT_H264_MVC``
 
@@ -64,7 +64,7 @@ Compressed Formats
 
        -  H264 MVC video elementary stream.
 
-    -  .. _`V4L2-PIX-FMT-H263`:
+    -  .. _V4L2-PIX-FMT-H263:
 
        -  ``V4L2_PIX_FMT_H263``
 
@@ -72,7 +72,7 @@ Compressed Formats
 
        -  H263 video elementary stream.
 
-    -  .. _`V4L2-PIX-FMT-MPEG1`:
+    -  .. _V4L2-PIX-FMT-MPEG1:
 
        -  ``V4L2_PIX_FMT_MPEG1``
 
@@ -80,7 +80,7 @@ Compressed Formats
 
        -  MPEG1 video elementary stream.
 
-    -  .. _`V4L2-PIX-FMT-MPEG2`:
+    -  .. _V4L2-PIX-FMT-MPEG2:
 
        -  ``V4L2_PIX_FMT_MPEG2``
 
@@ -88,7 +88,7 @@ Compressed Formats
 
        -  MPEG2 video elementary stream.
 
-    -  .. _`V4L2-PIX-FMT-MPEG4`:
+    -  .. _V4L2-PIX-FMT-MPEG4:
 
        -  ``V4L2_PIX_FMT_MPEG4``
 
@@ -96,7 +96,7 @@ Compressed Formats
 
        -  MPEG4 video elementary stream.
 
-    -  .. _`V4L2-PIX-FMT-XVID`:
+    -  .. _V4L2-PIX-FMT-XVID:
 
        -  ``V4L2_PIX_FMT_XVID``
 
@@ -104,7 +104,7 @@ Compressed Formats
 
        -  Xvid video elementary stream.
 
-    -  .. _`V4L2-PIX-FMT-VC1-ANNEX-G`:
+    -  .. _V4L2-PIX-FMT-VC1-ANNEX-G:
 
        -  ``V4L2_PIX_FMT_VC1_ANNEX_G``
 
@@ -112,7 +112,7 @@ Compressed Formats
 
        -  VC1, SMPTE 421M Annex G compliant stream.
 
-    -  .. _`V4L2-PIX-FMT-VC1-ANNEX-L`:
+    -  .. _V4L2-PIX-FMT-VC1-ANNEX-L:
 
        -  ``V4L2_PIX_FMT_VC1_ANNEX_L``
 
@@ -120,7 +120,7 @@ Compressed Formats
 
        -  VC1, SMPTE 421M Annex L compliant stream.
 
-    -  .. _`V4L2-PIX-FMT-VP8`:
+    -  .. _V4L2-PIX-FMT-VP8:
 
        -  ``V4L2_PIX_FMT_VP8``
 
diff --git a/Documentation/linux_tv/media/v4l/pixfmt-indexed.rst b/Documentation/linux_tv/media/v4l/pixfmt-indexed.rst
index 71e5fb316768..99a780fe6b61 100644
--- a/Documentation/linux_tv/media/v4l/pixfmt-indexed.rst
+++ b/Documentation/linux_tv/media/v4l/pixfmt-indexed.rst
@@ -49,7 +49,7 @@ the palette, this must be done with ioctls of the Linux framebuffer API.
 
        -  0
 
-    -  .. _`V4L2-PIX-FMT-PAL8`:
+    -  .. _V4L2-PIX-FMT-PAL8:
 
        -  ``V4L2_PIX_FMT_PAL8``
 
diff --git a/Documentation/linux_tv/media/v4l/pixfmt-packed-rgb.rst b/Documentation/linux_tv/media/v4l/pixfmt-packed-rgb.rst
index 37d41660fc76..c7aa2e91ac78 100644
--- a/Documentation/linux_tv/media/v4l/pixfmt-packed-rgb.rst
+++ b/Documentation/linux_tv/media/v4l/pixfmt-packed-rgb.rst
@@ -115,7 +115,7 @@ next to each other in memory.
 
        -  0
 
-    -  .. _`V4L2-PIX-FMT-RGB332`:
+    -  .. _V4L2-PIX-FMT-RGB332:
 
        -  ``V4L2_PIX_FMT_RGB332``
 
@@ -138,7 +138,7 @@ next to each other in memory.
 
        -  b\ :sub:`0`
 
-    -  .. _`V4L2-PIX-FMT-ARGB444`:
+    -  .. _V4L2-PIX-FMT-ARGB444:
 
        -  ``V4L2_PIX_FMT_ARGB444``
 
@@ -178,7 +178,7 @@ next to each other in memory.
 
        -  r\ :sub:`0`
 
-    -  .. _`V4L2-PIX-FMT-XRGB444`:
+    -  .. _V4L2-PIX-FMT-XRGB444:
 
        -  ``V4L2_PIX_FMT_XRGB444``
 
@@ -218,7 +218,7 @@ next to each other in memory.
 
        -  r\ :sub:`0`
 
-    -  .. _`V4L2-PIX-FMT-ARGB555`:
+    -  .. _V4L2-PIX-FMT-ARGB555:
 
        -  ``V4L2_PIX_FMT_ARGB555``
 
@@ -258,7 +258,7 @@ next to each other in memory.
 
        -  g\ :sub:`3`
 
-    -  .. _`V4L2-PIX-FMT-XRGB555`:
+    -  .. _V4L2-PIX-FMT-XRGB555:
 
        -  ``V4L2_PIX_FMT_XRGB555``
 
@@ -298,7 +298,7 @@ next to each other in memory.
 
        -  g\ :sub:`3`
 
-    -  .. _`V4L2-PIX-FMT-RGB565`:
+    -  .. _V4L2-PIX-FMT-RGB565:
 
        -  ``V4L2_PIX_FMT_RGB565``
 
@@ -338,7 +338,7 @@ next to each other in memory.
 
        -  g\ :sub:`3`
 
-    -  .. _`V4L2-PIX-FMT-ARGB555X`:
+    -  .. _V4L2-PIX-FMT-ARGB555X:
 
        -  ``V4L2_PIX_FMT_ARGB555X``
 
@@ -378,7 +378,7 @@ next to each other in memory.
 
        -  b\ :sub:`0`
 
-    -  .. _`V4L2-PIX-FMT-XRGB555X`:
+    -  .. _V4L2-PIX-FMT-XRGB555X:
 
        -  ``V4L2_PIX_FMT_XRGB555X``
 
@@ -418,7 +418,7 @@ next to each other in memory.
 
        -  b\ :sub:`0`
 
-    -  .. _`V4L2-PIX-FMT-RGB565X`:
+    -  .. _V4L2-PIX-FMT-RGB565X:
 
        -  ``V4L2_PIX_FMT_RGB565X``
 
@@ -458,7 +458,7 @@ next to each other in memory.
 
        -  b\ :sub:`0`
 
-    -  .. _`V4L2-PIX-FMT-BGR24`:
+    -  .. _V4L2-PIX-FMT-BGR24:
 
        -  ``V4L2_PIX_FMT_BGR24``
 
@@ -515,7 +515,7 @@ next to each other in memory.
 
        -  r\ :sub:`0`
 
-    -  .. _`V4L2-PIX-FMT-RGB24`:
+    -  .. _V4L2-PIX-FMT-RGB24:
 
        -  ``V4L2_PIX_FMT_RGB24``
 
@@ -572,7 +572,7 @@ next to each other in memory.
 
        -  b\ :sub:`0`
 
-    -  .. _`V4L2-PIX-FMT-BGR666`:
+    -  .. _V4L2-PIX-FMT-BGR666:
 
        -  ``V4L2_PIX_FMT_BGR666``
 
@@ -646,7 +646,7 @@ next to each other in memory.
 
        -  -
 
-    -  .. _`V4L2-PIX-FMT-ABGR32`:
+    -  .. _V4L2-PIX-FMT-ABGR32:
 
        -  ``V4L2_PIX_FMT_ABGR32``
 
@@ -720,7 +720,7 @@ next to each other in memory.
 
        -  a\ :sub:`0`
 
-    -  .. _`V4L2-PIX-FMT-XBGR32`:
+    -  .. _V4L2-PIX-FMT-XBGR32:
 
        -  ``V4L2_PIX_FMT_XBGR32``
 
@@ -794,7 +794,7 @@ next to each other in memory.
 
        -  -
 
-    -  .. _`V4L2-PIX-FMT-ARGB32`:
+    -  .. _V4L2-PIX-FMT-ARGB32:
 
        -  ``V4L2_PIX_FMT_ARGB32``
 
@@ -868,7 +868,7 @@ next to each other in memory.
 
        -  b\ :sub:`0`
 
-    -  .. _`V4L2-PIX-FMT-XRGB32`:
+    -  .. _V4L2-PIX-FMT-XRGB32:
 
        -  ``V4L2_PIX_FMT_XRGB32``
 
@@ -1194,7 +1194,7 @@ either the corresponding ARGB or XRGB format, depending on the driver.
 
        -  0
 
-    -  .. _`V4L2-PIX-FMT-RGB444`:
+    -  .. _V4L2-PIX-FMT-RGB444:
 
        -  ``V4L2_PIX_FMT_RGB444``
 
@@ -1234,7 +1234,7 @@ either the corresponding ARGB or XRGB format, depending on the driver.
 
        -  r\ :sub:`0`
 
-    -  .. _`V4L2-PIX-FMT-RGB555`:
+    -  .. _V4L2-PIX-FMT-RGB555:
 
        -  ``V4L2_PIX_FMT_RGB555``
 
@@ -1274,7 +1274,7 @@ either the corresponding ARGB or XRGB format, depending on the driver.
 
        -  g\ :sub:`3`
 
-    -  .. _`V4L2-PIX-FMT-RGB555X`:
+    -  .. _V4L2-PIX-FMT-RGB555X:
 
        -  ``V4L2_PIX_FMT_RGB555X``
 
@@ -1314,7 +1314,7 @@ either the corresponding ARGB or XRGB format, depending on the driver.
 
        -  b\ :sub:`0`
 
-    -  .. _`V4L2-PIX-FMT-BGR32`:
+    -  .. _V4L2-PIX-FMT-BGR32:
 
        -  ``V4L2_PIX_FMT_BGR32``
 
@@ -1388,7 +1388,7 @@ either the corresponding ARGB or XRGB format, depending on the driver.
 
        -  a\ :sub:`0`
 
-    -  .. _`V4L2-PIX-FMT-RGB32`:
+    -  .. _V4L2-PIX-FMT-RGB32:
 
        -  ``V4L2_PIX_FMT_RGB32``
 
diff --git a/Documentation/linux_tv/media/v4l/pixfmt-packed-yuv.rst b/Documentation/linux_tv/media/v4l/pixfmt-packed-yuv.rst
index 2560257237dc..54716455f453 100644
--- a/Documentation/linux_tv/media/v4l/pixfmt-packed-yuv.rst
+++ b/Documentation/linux_tv/media/v4l/pixfmt-packed-yuv.rst
@@ -115,7 +115,7 @@ component of each pixel in one 16 or 32 bit word.
 
        -  0
 
-    -  .. _`V4L2-PIX-FMT-YUV444`:
+    -  .. _V4L2-PIX-FMT-YUV444:
 
        -  ``V4L2_PIX_FMT_YUV444``
 
@@ -155,7 +155,7 @@ component of each pixel in one 16 or 32 bit word.
 
        -  Y'\ :sub:`0`
 
-    -  .. _`V4L2-PIX-FMT-YUV555`:
+    -  .. _V4L2-PIX-FMT-YUV555:
 
        -  ``V4L2_PIX_FMT_YUV555``
 
@@ -195,7 +195,7 @@ component of each pixel in one 16 or 32 bit word.
 
        -  Cb\ :sub:`3`
 
-    -  .. _`V4L2-PIX-FMT-YUV565`:
+    -  .. _V4L2-PIX-FMT-YUV565:
 
        -  ``V4L2_PIX_FMT_YUV565``
 
@@ -235,7 +235,7 @@ component of each pixel in one 16 or 32 bit word.
 
        -  Cb\ :sub:`3`
 
-    -  .. _`V4L2-PIX-FMT-YUV32`:
+    -  .. _V4L2-PIX-FMT-YUV32:
 
        -  ``V4L2_PIX_FMT_YUV32``
 
diff --git a/Documentation/linux_tv/media/v4l/pixfmt-reserved.rst b/Documentation/linux_tv/media/v4l/pixfmt-reserved.rst
index 8f9ecae1e677..9a5704baf9fe 100644
--- a/Documentation/linux_tv/media/v4l/pixfmt-reserved.rst
+++ b/Documentation/linux_tv/media/v4l/pixfmt-reserved.rst
@@ -33,7 +33,7 @@ please make a proposal on the linux-media mailing list.
 
        -  Details
 
-    -  .. _`V4L2-PIX-FMT-DV`:
+    -  .. _V4L2-PIX-FMT-DV:
 
        -  ``V4L2_PIX_FMT_DV``
 
@@ -41,7 +41,7 @@ please make a proposal on the linux-media mailing list.
 
        -  unknown
 
-    -  .. _`V4L2-PIX-FMT-ET61X251`:
+    -  .. _V4L2-PIX-FMT-ET61X251:
 
        -  ``V4L2_PIX_FMT_ET61X251``
 
@@ -49,7 +49,7 @@ please make a proposal on the linux-media mailing list.
 
        -  Compressed format of the ET61X251 driver.
 
-    -  .. _`V4L2-PIX-FMT-HI240`:
+    -  .. _V4L2-PIX-FMT-HI240:
 
        -  ``V4L2_PIX_FMT_HI240``
 
@@ -57,7 +57,7 @@ please make a proposal on the linux-media mailing list.
 
        -  8 bit RGB format used by the BTTV driver.
 
-    -  .. _`V4L2-PIX-FMT-HM12`:
+    -  .. _V4L2-PIX-FMT-HM12:
 
        -  ``V4L2_PIX_FMT_HM12``
 
@@ -69,7 +69,7 @@ please make a proposal on the linux-media mailing list.
 	  The format is documented in the kernel sources in the file
 	  ``Documentation/video4linux/cx2341x/README.hm12``
 
-    -  .. _`V4L2-PIX-FMT-CPIA1`:
+    -  .. _V4L2-PIX-FMT-CPIA1:
 
        -  ``V4L2_PIX_FMT_CPIA1``
 
@@ -77,7 +77,7 @@ please make a proposal on the linux-media mailing list.
 
        -  YUV format used by the gspca cpia1 driver.
 
-    -  .. _`V4L2-PIX-FMT-JPGL`:
+    -  .. _V4L2-PIX-FMT-JPGL:
 
        -  ``V4L2_PIX_FMT_JPGL``
 
@@ -86,7 +86,7 @@ please make a proposal on the linux-media mailing list.
        -  JPEG-Light format (Pegasus Lossless JPEG) used in Divio webcams NW
 	  80x.
 
-    -  .. _`V4L2-PIX-FMT-SPCA501`:
+    -  .. _V4L2-PIX-FMT-SPCA501:
 
        -  ``V4L2_PIX_FMT_SPCA501``
 
@@ -94,7 +94,7 @@ please make a proposal on the linux-media mailing list.
 
        -  YUYV per line used by the gspca driver.
 
-    -  .. _`V4L2-PIX-FMT-SPCA505`:
+    -  .. _V4L2-PIX-FMT-SPCA505:
 
        -  ``V4L2_PIX_FMT_SPCA505``
 
@@ -102,7 +102,7 @@ please make a proposal on the linux-media mailing list.
 
        -  YYUV per line used by the gspca driver.
 
-    -  .. _`V4L2-PIX-FMT-SPCA508`:
+    -  .. _V4L2-PIX-FMT-SPCA508:
 
        -  ``V4L2_PIX_FMT_SPCA508``
 
@@ -110,7 +110,7 @@ please make a proposal on the linux-media mailing list.
 
        -  YUVY per line used by the gspca driver.
 
-    -  .. _`V4L2-PIX-FMT-SPCA561`:
+    -  .. _V4L2-PIX-FMT-SPCA561:
 
        -  ``V4L2_PIX_FMT_SPCA561``
 
@@ -118,7 +118,7 @@ please make a proposal on the linux-media mailing list.
 
        -  Compressed GBRG Bayer format used by the gspca driver.
 
-    -  .. _`V4L2-PIX-FMT-PAC207`:
+    -  .. _V4L2-PIX-FMT-PAC207:
 
        -  ``V4L2_PIX_FMT_PAC207``
 
@@ -126,7 +126,7 @@ please make a proposal on the linux-media mailing list.
 
        -  Compressed BGGR Bayer format used by the gspca driver.
 
-    -  .. _`V4L2-PIX-FMT-MR97310A`:
+    -  .. _V4L2-PIX-FMT-MR97310A:
 
        -  ``V4L2_PIX_FMT_MR97310A``
 
@@ -134,7 +134,7 @@ please make a proposal on the linux-media mailing list.
 
        -  Compressed BGGR Bayer format used by the gspca driver.
 
-    -  .. _`V4L2-PIX-FMT-JL2005BCD`:
+    -  .. _V4L2-PIX-FMT-JL2005BCD:
 
        -  ``V4L2_PIX_FMT_JL2005BCD``
 
@@ -142,7 +142,7 @@ please make a proposal on the linux-media mailing list.
 
        -  JPEG compressed RGGB Bayer format used by the gspca driver.
 
-    -  .. _`V4L2-PIX-FMT-OV511`:
+    -  .. _V4L2-PIX-FMT-OV511:
 
        -  ``V4L2_PIX_FMT_OV511``
 
@@ -150,7 +150,7 @@ please make a proposal on the linux-media mailing list.
 
        -  OV511 JPEG format used by the gspca driver.
 
-    -  .. _`V4L2-PIX-FMT-OV518`:
+    -  .. _V4L2-PIX-FMT-OV518:
 
        -  ``V4L2_PIX_FMT_OV518``
 
@@ -158,7 +158,7 @@ please make a proposal on the linux-media mailing list.
 
        -  OV518 JPEG format used by the gspca driver.
 
-    -  .. _`V4L2-PIX-FMT-PJPG`:
+    -  .. _V4L2-PIX-FMT-PJPG:
 
        -  ``V4L2_PIX_FMT_PJPG``
 
@@ -166,7 +166,7 @@ please make a proposal on the linux-media mailing list.
 
        -  Pixart 73xx JPEG format used by the gspca driver.
 
-    -  .. _`V4L2-PIX-FMT-SE401`:
+    -  .. _V4L2-PIX-FMT-SE401:
 
        -  ``V4L2_PIX_FMT_SE401``
 
@@ -174,7 +174,7 @@ please make a proposal on the linux-media mailing list.
 
        -  Compressed RGB format used by the gspca se401 driver
 
-    -  .. _`V4L2-PIX-FMT-SQ905C`:
+    -  .. _V4L2-PIX-FMT-SQ905C:
 
        -  ``V4L2_PIX_FMT_SQ905C``
 
@@ -182,7 +182,7 @@ please make a proposal on the linux-media mailing list.
 
        -  Compressed RGGB bayer format used by the gspca driver.
 
-    -  .. _`V4L2-PIX-FMT-MJPEG`:
+    -  .. _V4L2-PIX-FMT-MJPEG:
 
        -  ``V4L2_PIX_FMT_MJPEG``
 
@@ -190,7 +190,7 @@ please make a proposal on the linux-media mailing list.
 
        -  Compressed format used by the Zoran driver
 
-    -  .. _`V4L2-PIX-FMT-PWC1`:
+    -  .. _V4L2-PIX-FMT-PWC1:
 
        -  ``V4L2_PIX_FMT_PWC1``
 
@@ -198,7 +198,7 @@ please make a proposal on the linux-media mailing list.
 
        -  Compressed format of the PWC driver.
 
-    -  .. _`V4L2-PIX-FMT-PWC2`:
+    -  .. _V4L2-PIX-FMT-PWC2:
 
        -  ``V4L2_PIX_FMT_PWC2``
 
@@ -206,7 +206,7 @@ please make a proposal on the linux-media mailing list.
 
        -  Compressed format of the PWC driver.
 
-    -  .. _`V4L2-PIX-FMT-SN9C10X`:
+    -  .. _V4L2-PIX-FMT-SN9C10X:
 
        -  ``V4L2_PIX_FMT_SN9C10X``
 
@@ -214,7 +214,7 @@ please make a proposal on the linux-media mailing list.
 
        -  Compressed format of the SN9C102 driver.
 
-    -  .. _`V4L2-PIX-FMT-SN9C20X-I420`:
+    -  .. _V4L2-PIX-FMT-SN9C20X-I420:
 
        -  ``V4L2_PIX_FMT_SN9C20X_I420``
 
@@ -222,7 +222,7 @@ please make a proposal on the linux-media mailing list.
 
        -  YUV 4:2:0 format of the gspca sn9c20x driver.
 
-    -  .. _`V4L2-PIX-FMT-SN9C2028`:
+    -  .. _V4L2-PIX-FMT-SN9C2028:
 
        -  ``V4L2_PIX_FMT_SN9C2028``
 
@@ -230,7 +230,7 @@ please make a proposal on the linux-media mailing list.
 
        -  Compressed GBRG bayer format of the gspca sn9c2028 driver.
 
-    -  .. _`V4L2-PIX-FMT-STV0680`:
+    -  .. _V4L2-PIX-FMT-STV0680:
 
        -  ``V4L2_PIX_FMT_STV0680``
 
@@ -238,7 +238,7 @@ please make a proposal on the linux-media mailing list.
 
        -  Bayer format of the gspca stv0680 driver.
 
-    -  .. _`V4L2-PIX-FMT-WNVA`:
+    -  .. _V4L2-PIX-FMT-WNVA:
 
        -  ``V4L2_PIX_FMT_WNVA``
 
@@ -247,7 +247,7 @@ please make a proposal on the linux-media mailing list.
        -  Used by the Winnov Videum driver,
 	  `http://www.thedirks.org/winnov/ <http://www.thedirks.org/winnov/>`__
 
-    -  .. _`V4L2-PIX-FMT-TM6000`:
+    -  .. _V4L2-PIX-FMT-TM6000:
 
        -  ``V4L2_PIX_FMT_TM6000``
 
@@ -255,7 +255,7 @@ please make a proposal on the linux-media mailing list.
 
        -  Used by Trident tm6000
 
-    -  .. _`V4L2-PIX-FMT-CIT-YYVYUY`:
+    -  .. _V4L2-PIX-FMT-CIT-YYVYUY:
 
        -  ``V4L2_PIX_FMT_CIT_YYVYUY``
 
@@ -265,7 +265,7 @@ please make a proposal on the linux-media mailing list.
 
 	  Uses one line of Y then 1 line of VYUY
 
-    -  .. _`V4L2-PIX-FMT-KONICA420`:
+    -  .. _V4L2-PIX-FMT-KONICA420:
 
        -  ``V4L2_PIX_FMT_KONICA420``
 
@@ -275,7 +275,7 @@ please make a proposal on the linux-media mailing list.
 
 	  YUV420 planar in blocks of 256 pixels.
 
-    -  .. _`V4L2-PIX-FMT-YYUV`:
+    -  .. _V4L2-PIX-FMT-YYUV:
 
        -  ``V4L2_PIX_FMT_YYUV``
 
@@ -283,7 +283,7 @@ please make a proposal on the linux-media mailing list.
 
        -  unknown
 
-    -  .. _`V4L2-PIX-FMT-Y4`:
+    -  .. _V4L2-PIX-FMT-Y4:
 
        -  ``V4L2_PIX_FMT_Y4``
 
@@ -292,7 +292,7 @@ please make a proposal on the linux-media mailing list.
        -  Old 4-bit greyscale format. Only the most significant 4 bits of
 	  each byte are used, the other bits are set to 0.
 
-    -  .. _`V4L2-PIX-FMT-Y6`:
+    -  .. _V4L2-PIX-FMT-Y6:
 
        -  ``V4L2_PIX_FMT_Y6``
 
@@ -301,7 +301,7 @@ please make a proposal on the linux-media mailing list.
        -  Old 6-bit greyscale format. Only the most significant 6 bits of
 	  each byte are used, the other bits are set to 0.
 
-    -  .. _`V4L2-PIX-FMT-S5C-UYVY-JPG`:
+    -  .. _V4L2-PIX-FMT-S5C-UYVY-JPG:
 
        -  ``V4L2_PIX_FMT_S5C_UYVY_JPG``
 
diff --git a/Documentation/linux_tv/media/v4l/subdev-formats.rst b/Documentation/linux_tv/media/v4l/subdev-formats.rst
index cf4be8cab3f9..6dbb27b09c34 100644
--- a/Documentation/linux_tv/media/v4l/subdev-formats.rst
+++ b/Documentation/linux_tv/media/v4l/subdev-formats.rst
@@ -240,7 +240,7 @@ The following tables list existing packed RGB formats.
 
        -  0
 
-    -  .. _`MEDIA-BUS-FMT-RGB444-1X12`:
+    -  .. _MEDIA-BUS-FMT-RGB444-1X12:
 
        -  MEDIA_BUS_FMT_RGB444_1X12
 
@@ -311,7 +311,7 @@ The following tables list existing packed RGB formats.
 
        -  b\ :sub:`0`
 
-    -  .. _`MEDIA-BUS-FMT-RGB444-2X8-PADHI-BE`:
+    -  .. _MEDIA-BUS-FMT-RGB444-2X8-PADHI-BE:
 
        -  MEDIA_BUS_FMT_RGB444_2X8_PADHI_BE
 
@@ -451,7 +451,7 @@ The following tables list existing packed RGB formats.
 
        -  b\ :sub:`0`
 
-    -  .. _`MEDIA-BUS-FMT-RGB444-2X8-PADHI-LE`:
+    -  .. _MEDIA-BUS-FMT-RGB444-2X8-PADHI-LE:
 
        -  MEDIA_BUS_FMT_RGB444_2X8_PADHI_LE
 
@@ -591,7 +591,7 @@ The following tables list existing packed RGB formats.
 
        -  r\ :sub:`0`
 
-    -  .. _`MEDIA-BUS-FMT-RGB555-2X8-PADHI-BE`:
+    -  .. _MEDIA-BUS-FMT-RGB555-2X8-PADHI-BE:
 
        -  MEDIA_BUS_FMT_RGB555_2X8_PADHI_BE
 
@@ -731,7 +731,7 @@ The following tables list existing packed RGB formats.
 
        -  b\ :sub:`0`
 
-    -  .. _`MEDIA-BUS-FMT-RGB555-2X8-PADHI-LE`:
+    -  .. _MEDIA-BUS-FMT-RGB555-2X8-PADHI-LE:
 
        -  MEDIA_BUS_FMT_RGB555_2X8_PADHI_LE
 
@@ -871,7 +871,7 @@ The following tables list existing packed RGB formats.
 
        -  g\ :sub:`3`
 
-    -  .. _`MEDIA-BUS-FMT-RGB565-1X16`:
+    -  .. _MEDIA-BUS-FMT-RGB565-1X16:
 
        -  MEDIA_BUS_FMT_RGB565_1X16
 
@@ -942,7 +942,7 @@ The following tables list existing packed RGB formats.
 
        -  b\ :sub:`0`
 
-    -  .. _`MEDIA-BUS-FMT-BGR565-2X8-BE`:
+    -  .. _MEDIA-BUS-FMT-BGR565-2X8-BE:
 
        -  MEDIA_BUS_FMT_BGR565_2X8_BE
 
@@ -1082,7 +1082,7 @@ The following tables list existing packed RGB formats.
 
        -  r\ :sub:`0`
 
-    -  .. _`MEDIA-BUS-FMT-BGR565-2X8-LE`:
+    -  .. _MEDIA-BUS-FMT-BGR565-2X8-LE:
 
        -  MEDIA_BUS_FMT_BGR565_2X8_LE
 
@@ -1222,7 +1222,7 @@ The following tables list existing packed RGB formats.
 
        -  g\ :sub:`3`
 
-    -  .. _`MEDIA-BUS-FMT-RGB565-2X8-BE`:
+    -  .. _MEDIA-BUS-FMT-RGB565-2X8-BE:
 
        -  MEDIA_BUS_FMT_RGB565_2X8_BE
 
@@ -1362,7 +1362,7 @@ The following tables list existing packed RGB formats.
 
        -  b\ :sub:`0`
 
-    -  .. _`MEDIA-BUS-FMT-RGB565-2X8-LE`:
+    -  .. _MEDIA-BUS-FMT-RGB565-2X8-LE:
 
        -  MEDIA_BUS_FMT_RGB565_2X8_LE
 
@@ -1502,7 +1502,7 @@ The following tables list existing packed RGB formats.
 
        -  g\ :sub:`3`
 
-    -  .. _`MEDIA-BUS-FMT-RGB666-1X18`:
+    -  .. _MEDIA-BUS-FMT-RGB666-1X18:
 
        -  MEDIA_BUS_FMT_RGB666_1X18
 
@@ -1573,7 +1573,7 @@ The following tables list existing packed RGB formats.
 
        -  b\ :sub:`0`
 
-    -  .. _`MEDIA-BUS-FMT-RBG888-1X24`:
+    -  .. _MEDIA-BUS-FMT-RBG888-1X24:
 
        -  MEDIA_BUS_FMT_RBG888_1X24
 
@@ -1644,7 +1644,7 @@ The following tables list existing packed RGB formats.
 
        -  g\ :sub:`0`
 
-    -  .. _`MEDIA-BUS-FMT-RGB666-1X24_CPADHI`:
+    -  .. _MEDIA-BUS-FMT-RGB666-1X24_CPADHI:
 
        -  MEDIA_BUS_FMT_RGB666_1X24_CPADHI
 
@@ -1715,7 +1715,7 @@ The following tables list existing packed RGB formats.
 
        -  b\ :sub:`0`
 
-    -  .. _`MEDIA-BUS-FMT-BGR888-1X24`:
+    -  .. _MEDIA-BUS-FMT-BGR888-1X24:
 
        -  MEDIA_BUS_FMT_BGR888_1X24
 
@@ -1786,7 +1786,7 @@ The following tables list existing packed RGB formats.
 
        -  r\ :sub:`0`
 
-    -  .. _`MEDIA-BUS-FMT-GBR888-1X24`:
+    -  .. _MEDIA-BUS-FMT-GBR888-1X24:
 
        -  MEDIA_BUS_FMT_GBR888_1X24
 
@@ -1857,7 +1857,7 @@ The following tables list existing packed RGB formats.
 
        -  r\ :sub:`0`
 
-    -  .. _`MEDIA-BUS-FMT-RGB888-1X24`:
+    -  .. _MEDIA-BUS-FMT-RGB888-1X24:
 
        -  MEDIA_BUS_FMT_RGB888_1X24
 
@@ -1928,7 +1928,7 @@ The following tables list existing packed RGB formats.
 
        -  b\ :sub:`0`
 
-    -  .. _`MEDIA-BUS-FMT-RGB888-2X12-BE`:
+    -  .. _MEDIA-BUS-FMT-RGB888-2X12-BE:
 
        -  MEDIA_BUS_FMT_RGB888_2X12_BE
 
@@ -2068,7 +2068,7 @@ The following tables list existing packed RGB formats.
 
        -  b\ :sub:`0`
 
-    -  .. _`MEDIA-BUS-FMT-RGB888-2X12-LE`:
+    -  .. _MEDIA-BUS-FMT-RGB888-2X12-LE:
 
        -  MEDIA_BUS_FMT_RGB888_2X12_LE
 
@@ -2208,7 +2208,7 @@ The following tables list existing packed RGB formats.
 
        -  g\ :sub:`4`
 
-    -  .. _`MEDIA-BUS-FMT-ARGB888-1X32`:
+    -  .. _MEDIA-BUS-FMT-ARGB888-1X32:
 
        -  MEDIA_BUS_FMT_ARGB888_1X32
 
@@ -2279,7 +2279,7 @@ The following tables list existing packed RGB formats.
 
        -  b\ :sub:`0`
 
-    -  .. _`MEDIA-BUS-FMT-RGB888-1X32-PADHI`:
+    -  .. _MEDIA-BUS-FMT-RGB888-1X32-PADHI:
 
        -  MEDIA_BUS_FMT_RGB888_1X32_PADHI
 
@@ -2393,7 +2393,7 @@ JEIDA defined bit mapping will be named
 
        -  0
 
-    -  .. _`MEDIA-BUS-FMT-RGB666-1X7X3-SPWG`:
+    -  .. _MEDIA-BUS-FMT-RGB666-1X7X3-SPWG:
 
        -  MEDIA_BUS_FMT_RGB666_1X7X3_SPWG
 
@@ -2500,7 +2500,7 @@ JEIDA defined bit mapping will be named
 
        -  r\ :sub:`0`
 
-    -  .. _`MEDIA-BUS-FMT-RGB888-1X7X4-SPWG`:
+    -  .. _MEDIA-BUS-FMT-RGB888-1X7X4-SPWG:
 
        -  MEDIA_BUS_FMT_RGB888_1X7X4_SPWG
 
@@ -2607,7 +2607,7 @@ JEIDA defined bit mapping will be named
 
        -  r\ :sub:`0`
 
-    -  .. _`MEDIA-BUS-FMT-RGB888-1X7X4-JEIDA`:
+    -  .. _MEDIA-BUS-FMT-RGB888-1X7X4-JEIDA:
 
        -  MEDIA_BUS_FMT_RGB888_1X7X4_JEIDA
 
@@ -2814,7 +2814,7 @@ organization is given as an example for the first pixel only.
 
        -  0
 
-    -  .. _`MEDIA-BUS-FMT-SBGGR8-1X8`:
+    -  .. _MEDIA-BUS-FMT-SBGGR8-1X8:
 
        -  MEDIA_BUS_FMT_SBGGR8_1X8
 
@@ -2845,7 +2845,7 @@ organization is given as an example for the first pixel only.
 
        -  b\ :sub:`0`
 
-    -  .. _`MEDIA-BUS-FMT-SGBRG8-1X8`:
+    -  .. _MEDIA-BUS-FMT-SGBRG8-1X8:
 
        -  MEDIA_BUS_FMT_SGBRG8_1X8
 
@@ -2876,7 +2876,7 @@ organization is given as an example for the first pixel only.
 
        -  g\ :sub:`0`
 
-    -  .. _`MEDIA-BUS-FMT-SGRBG8-1X8`:
+    -  .. _MEDIA-BUS-FMT-SGRBG8-1X8:
 
        -  MEDIA_BUS_FMT_SGRBG8_1X8
 
@@ -2907,7 +2907,7 @@ organization is given as an example for the first pixel only.
 
        -  g\ :sub:`0`
 
-    -  .. _`MEDIA-BUS-FMT-SRGGB8-1X8`:
+    -  .. _MEDIA-BUS-FMT-SRGGB8-1X8:
 
        -  MEDIA_BUS_FMT_SRGGB8_1X8
 
@@ -2938,7 +2938,7 @@ organization is given as an example for the first pixel only.
 
        -  r\ :sub:`0`
 
-    -  .. _`MEDIA-BUS-FMT-SBGGR10-ALAW8-1X8`:
+    -  .. _MEDIA-BUS-FMT-SBGGR10-ALAW8-1X8:
 
        -  MEDIA_BUS_FMT_SBGGR10_ALAW8_1X8
 
@@ -2969,7 +2969,7 @@ organization is given as an example for the first pixel only.
 
        -  b\ :sub:`0`
 
-    -  .. _`MEDIA-BUS-FMT-SGBRG10-ALAW8-1X8`:
+    -  .. _MEDIA-BUS-FMT-SGBRG10-ALAW8-1X8:
 
        -  MEDIA_BUS_FMT_SGBRG10_ALAW8_1X8
 
@@ -3000,7 +3000,7 @@ organization is given as an example for the first pixel only.
 
        -  g\ :sub:`0`
 
-    -  .. _`MEDIA-BUS-FMT-SGRBG10-ALAW8-1X8`:
+    -  .. _MEDIA-BUS-FMT-SGRBG10-ALAW8-1X8:
 
        -  MEDIA_BUS_FMT_SGRBG10_ALAW8_1X8
 
@@ -3031,7 +3031,7 @@ organization is given as an example for the first pixel only.
 
        -  g\ :sub:`0`
 
-    -  .. _`MEDIA-BUS-FMT-SRGGB10-ALAW8-1X8`:
+    -  .. _MEDIA-BUS-FMT-SRGGB10-ALAW8-1X8:
 
        -  MEDIA_BUS_FMT_SRGGB10_ALAW8_1X8
 
@@ -3062,7 +3062,7 @@ organization is given as an example for the first pixel only.
 
        -  r\ :sub:`0`
 
-    -  .. _`MEDIA-BUS-FMT-SBGGR10-DPCM8-1X8`:
+    -  .. _MEDIA-BUS-FMT-SBGGR10-DPCM8-1X8:
 
        -  MEDIA_BUS_FMT_SBGGR10_DPCM8_1X8
 
@@ -3093,7 +3093,7 @@ organization is given as an example for the first pixel only.
 
        -  b\ :sub:`0`
 
-    -  .. _`MEDIA-BUS-FMT-SGBRG10-DPCM8-1X8`:
+    -  .. _MEDIA-BUS-FMT-SGBRG10-DPCM8-1X8:
 
        -  MEDIA_BUS_FMT_SGBRG10_DPCM8_1X8
 
@@ -3124,7 +3124,7 @@ organization is given as an example for the first pixel only.
 
        -  g\ :sub:`0`
 
-    -  .. _`MEDIA-BUS-FMT-SGRBG10-DPCM8-1X8`:
+    -  .. _MEDIA-BUS-FMT-SGRBG10-DPCM8-1X8:
 
        -  MEDIA_BUS_FMT_SGRBG10_DPCM8_1X8
 
@@ -3155,7 +3155,7 @@ organization is given as an example for the first pixel only.
 
        -  g\ :sub:`0`
 
-    -  .. _`MEDIA-BUS-FMT-SRGGB10-DPCM8-1X8`:
+    -  .. _MEDIA-BUS-FMT-SRGGB10-DPCM8-1X8:
 
        -  MEDIA_BUS_FMT_SRGGB10_DPCM8_1X8
 
@@ -3186,7 +3186,7 @@ organization is given as an example for the first pixel only.
 
        -  r\ :sub:`0`
 
-    -  .. _`MEDIA-BUS-FMT-SBGGR10-2X8-PADHI-BE`:
+    -  .. _MEDIA-BUS-FMT-SBGGR10-2X8-PADHI-BE:
 
        -  MEDIA_BUS_FMT_SBGGR10_2X8_PADHI_BE
 
@@ -3246,7 +3246,7 @@ organization is given as an example for the first pixel only.
 
        -  b\ :sub:`0`
 
-    -  .. _`MEDIA-BUS-FMT-SBGGR10-2X8-PADHI-LE`:
+    -  .. _MEDIA-BUS-FMT-SBGGR10-2X8-PADHI-LE:
 
        -  MEDIA_BUS_FMT_SBGGR10_2X8_PADHI_LE
 
@@ -3306,7 +3306,7 @@ organization is given as an example for the first pixel only.
 
        -  b\ :sub:`8`
 
-    -  .. _`MEDIA-BUS-FMT-SBGGR10-2X8-PADLO-BE`:
+    -  .. _MEDIA-BUS-FMT-SBGGR10-2X8-PADLO-BE:
 
        -  MEDIA_BUS_FMT_SBGGR10_2X8_PADLO_BE
 
@@ -3366,7 +3366,7 @@ organization is given as an example for the first pixel only.
 
        -  0
 
-    -  .. _`MEDIA-BUS-FMT-SBGGR10-2X8-PADLO-LE`:
+    -  .. _MEDIA-BUS-FMT-SBGGR10-2X8-PADLO-LE:
 
        -  MEDIA_BUS_FMT_SBGGR10_2X8_PADLO_LE
 
@@ -3426,7 +3426,7 @@ organization is given as an example for the first pixel only.
 
        -  b\ :sub:`2`
 
-    -  .. _`MEDIA-BUS-FMT-SBGGR10-1X10`:
+    -  .. _MEDIA-BUS-FMT-SBGGR10-1X10:
 
        -  MEDIA_BUS_FMT_SBGGR10_1X10
 
@@ -3457,7 +3457,7 @@ organization is given as an example for the first pixel only.
 
        -  b\ :sub:`0`
 
-    -  .. _`MEDIA-BUS-FMT-SGBRG10-1X10`:
+    -  .. _MEDIA-BUS-FMT-SGBRG10-1X10:
 
        -  MEDIA_BUS_FMT_SGBRG10_1X10
 
@@ -3488,7 +3488,7 @@ organization is given as an example for the first pixel only.
 
        -  g\ :sub:`0`
 
-    -  .. _`MEDIA-BUS-FMT-SGRBG10-1X10`:
+    -  .. _MEDIA-BUS-FMT-SGRBG10-1X10:
 
        -  MEDIA_BUS_FMT_SGRBG10_1X10
 
@@ -3519,7 +3519,7 @@ organization is given as an example for the first pixel only.
 
        -  g\ :sub:`0`
 
-    -  .. _`MEDIA-BUS-FMT-SRGGB10-1X10`:
+    -  .. _MEDIA-BUS-FMT-SRGGB10-1X10:
 
        -  MEDIA_BUS_FMT_SRGGB10_1X10
 
@@ -3550,7 +3550,7 @@ organization is given as an example for the first pixel only.
 
        -  r\ :sub:`0`
 
-    -  .. _`MEDIA-BUS-FMT-SBGGR12-1X12`:
+    -  .. _MEDIA-BUS-FMT-SBGGR12-1X12:
 
        -  MEDIA_BUS_FMT_SBGGR12_1X12
 
@@ -3581,7 +3581,7 @@ organization is given as an example for the first pixel only.
 
        -  b\ :sub:`0`
 
-    -  .. _`MEDIA-BUS-FMT-SGBRG12-1X12`:
+    -  .. _MEDIA-BUS-FMT-SGBRG12-1X12:
 
        -  MEDIA_BUS_FMT_SGBRG12_1X12
 
@@ -3612,7 +3612,7 @@ organization is given as an example for the first pixel only.
 
        -  g\ :sub:`0`
 
-    -  .. _`MEDIA-BUS-FMT-SGRBG12-1X12`:
+    -  .. _MEDIA-BUS-FMT-SGRBG12-1X12:
 
        -  MEDIA_BUS_FMT_SGRBG12_1X12
 
@@ -3643,7 +3643,7 @@ organization is given as an example for the first pixel only.
 
        -  g\ :sub:`0`
 
-    -  .. _`MEDIA-BUS-FMT-SRGGB12-1X12`:
+    -  .. _MEDIA-BUS-FMT-SRGGB12-1X12:
 
        -  MEDIA_BUS_FMT_SRGGB12_1X12
 
@@ -3817,7 +3817,7 @@ the following codes.
 
        -  0
 
-    -  .. _`MEDIA-BUS-FMT-Y8-1X8`:
+    -  .. _MEDIA-BUS-FMT-Y8-1X8:
 
        -  MEDIA_BUS_FMT_Y8_1X8
 
@@ -3888,7 +3888,7 @@ the following codes.
 
        -  y\ :sub:`0`
 
-    -  .. _`MEDIA-BUS-FMT-UV8-1X8`:
+    -  .. _MEDIA-BUS-FMT-UV8-1X8:
 
        -  MEDIA_BUS_FMT_UV8_1X8
 
@@ -4028,7 +4028,7 @@ the following codes.
 
        -  v\ :sub:`0`
 
-    -  .. _`MEDIA-BUS-FMT-UYVY8-1_5X8`:
+    -  .. _MEDIA-BUS-FMT-UYVY8-1_5X8:
 
        -  MEDIA_BUS_FMT_UYVY8_1_5X8
 
@@ -4444,7 +4444,7 @@ the following codes.
 
        -  y\ :sub:`0`
 
-    -  .. _`MEDIA-BUS-FMT-VYUY8-1_5X8`:
+    -  .. _MEDIA-BUS-FMT-VYUY8-1_5X8:
 
        -  MEDIA_BUS_FMT_VYUY8_1_5X8
 
@@ -4860,7 +4860,7 @@ the following codes.
 
        -  y\ :sub:`0`
 
-    -  .. _`MEDIA-BUS-FMT-YUYV8-1_5X8`:
+    -  .. _MEDIA-BUS-FMT-YUYV8-1_5X8:
 
        -  MEDIA_BUS_FMT_YUYV8_1_5X8
 
@@ -5276,7 +5276,7 @@ the following codes.
 
        -  v\ :sub:`0`
 
-    -  .. _`MEDIA-BUS-FMT-YVYU8-1_5X8`:
+    -  .. _MEDIA-BUS-FMT-YVYU8-1_5X8:
 
        -  MEDIA_BUS_FMT_YVYU8_1_5X8
 
@@ -5692,7 +5692,7 @@ the following codes.
 
        -  u\ :sub:`0`
 
-    -  .. _`MEDIA-BUS-FMT-UYVY8-2X8`:
+    -  .. _MEDIA-BUS-FMT-UYVY8-2X8:
 
        -  MEDIA_BUS_FMT_UYVY8_2X8
 
@@ -5970,7 +5970,7 @@ the following codes.
 
        -  y\ :sub:`0`
 
-    -  .. _`MEDIA-BUS-FMT-VYUY8-2X8`:
+    -  .. _MEDIA-BUS-FMT-VYUY8-2X8:
 
        -  MEDIA_BUS_FMT_VYUY8_2X8
 
@@ -6248,7 +6248,7 @@ the following codes.
 
        -  y\ :sub:`0`
 
-    -  .. _`MEDIA-BUS-FMT-YUYV8-2X8`:
+    -  .. _MEDIA-BUS-FMT-YUYV8-2X8:
 
        -  MEDIA_BUS_FMT_YUYV8_2X8
 
@@ -6526,7 +6526,7 @@ the following codes.
 
        -  v\ :sub:`0`
 
-    -  .. _`MEDIA-BUS-FMT-YVYU8-2X8`:
+    -  .. _MEDIA-BUS-FMT-YVYU8-2X8:
 
        -  MEDIA_BUS_FMT_YVYU8_2X8
 
@@ -6804,7 +6804,7 @@ the following codes.
 
        -  u\ :sub:`0`
 
-    -  .. _`MEDIA-BUS-FMT-Y10-1X10`:
+    -  .. _MEDIA-BUS-FMT-Y10-1X10:
 
        -  MEDIA_BUS_FMT_Y10_1X10
 
@@ -6875,7 +6875,7 @@ the following codes.
 
        -  y\ :sub:`0`
 
-    -  .. _`MEDIA-BUS-FMT-UYVY10-2X10`:
+    -  .. _MEDIA-BUS-FMT-UYVY10-2X10:
 
        -  MEDIA_BUS_FMT_UYVY10_2X10
 
@@ -7153,7 +7153,7 @@ the following codes.
 
        -  y\ :sub:`0`
 
-    -  .. _`MEDIA-BUS-FMT-VYUY10-2X10`:
+    -  .. _MEDIA-BUS-FMT-VYUY10-2X10:
 
        -  MEDIA_BUS_FMT_VYUY10_2X10
 
@@ -7431,7 +7431,7 @@ the following codes.
 
        -  y\ :sub:`0`
 
-    -  .. _`MEDIA-BUS-FMT-YUYV10-2X10`:
+    -  .. _MEDIA-BUS-FMT-YUYV10-2X10:
 
        -  MEDIA_BUS_FMT_YUYV10_2X10
 
@@ -7709,7 +7709,7 @@ the following codes.
 
        -  v\ :sub:`0`
 
-    -  .. _`MEDIA-BUS-FMT-YVYU10-2X10`:
+    -  .. _MEDIA-BUS-FMT-YVYU10-2X10:
 
        -  MEDIA_BUS_FMT_YVYU10_2X10
 
@@ -7987,7 +7987,7 @@ the following codes.
 
        -  u\ :sub:`0`
 
-    -  .. _`MEDIA-BUS-FMT-Y12-1X12`:
+    -  .. _MEDIA-BUS-FMT-Y12-1X12:
 
        -  MEDIA_BUS_FMT_Y12_1X12
 
@@ -8058,7 +8058,7 @@ the following codes.
 
        -  y\ :sub:`0`
 
-    -  .. _`MEDIA-BUS-FMT-UYVY12-2X12`:
+    -  .. _MEDIA-BUS-FMT-UYVY12-2X12:
 
        -  MEDIA_BUS_FMT_UYVY12_2X12
 
@@ -8336,7 +8336,7 @@ the following codes.
 
        -  y\ :sub:`0`
 
-    -  .. _`MEDIA-BUS-FMT-VYUY12-2X12`:
+    -  .. _MEDIA-BUS-FMT-VYUY12-2X12:
 
        -  MEDIA_BUS_FMT_VYUY12_2X12
 
@@ -8614,7 +8614,7 @@ the following codes.
 
        -  y\ :sub:`0`
 
-    -  .. _`MEDIA-BUS-FMT-YUYV12-2X12`:
+    -  .. _MEDIA-BUS-FMT-YUYV12-2X12:
 
        -  MEDIA_BUS_FMT_YUYV12_2X12
 
@@ -8892,7 +8892,7 @@ the following codes.
 
        -  v\ :sub:`0`
 
-    -  .. _`MEDIA-BUS-FMT-YVYU12-2X12`:
+    -  .. _MEDIA-BUS-FMT-YVYU12-2X12:
 
        -  MEDIA_BUS_FMT_YVYU12_2X12
 
@@ -9170,7 +9170,7 @@ the following codes.
 
        -  u\ :sub:`0`
 
-    -  .. _`MEDIA-BUS-FMT-UYVY8-1X16`:
+    -  .. _MEDIA-BUS-FMT-UYVY8-1X16:
 
        -  MEDIA_BUS_FMT_UYVY8_1X16
 
@@ -9310,7 +9310,7 @@ the following codes.
 
        -  y\ :sub:`0`
 
-    -  .. _`MEDIA-BUS-FMT-VYUY8-1X16`:
+    -  .. _MEDIA-BUS-FMT-VYUY8-1X16:
 
        -  MEDIA_BUS_FMT_VYUY8_1X16
 
@@ -9450,7 +9450,7 @@ the following codes.
 
        -  y\ :sub:`0`
 
-    -  .. _`MEDIA-BUS-FMT-YUYV8-1X16`:
+    -  .. _MEDIA-BUS-FMT-YUYV8-1X16:
 
        -  MEDIA_BUS_FMT_YUYV8_1X16
 
@@ -9590,7 +9590,7 @@ the following codes.
 
        -  v\ :sub:`0`
 
-    -  .. _`MEDIA-BUS-FMT-YVYU8-1X16`:
+    -  .. _MEDIA-BUS-FMT-YVYU8-1X16:
 
        -  MEDIA_BUS_FMT_YVYU8_1X16
 
@@ -9730,7 +9730,7 @@ the following codes.
 
        -  u\ :sub:`0`
 
-    -  .. _`MEDIA-BUS-FMT-YDYUYDYV8-1X16`:
+    -  .. _MEDIA-BUS-FMT-YDYUYDYV8-1X16:
 
        -  MEDIA_BUS_FMT_YDYUYDYV8_1X16
 
@@ -10008,7 +10008,7 @@ the following codes.
 
        -  v\ :sub:`0`
 
-    -  .. _`MEDIA-BUS-FMT-UYVY10-1X20`:
+    -  .. _MEDIA-BUS-FMT-UYVY10-1X20:
 
        -  MEDIA_BUS_FMT_UYVY10_1X20
 
@@ -10148,7 +10148,7 @@ the following codes.
 
        -  y\ :sub:`0`
 
-    -  .. _`MEDIA-BUS-FMT-VYUY10-1X20`:
+    -  .. _MEDIA-BUS-FMT-VYUY10-1X20:
 
        -  MEDIA_BUS_FMT_VYUY10_1X20
 
@@ -10288,7 +10288,7 @@ the following codes.
 
        -  y\ :sub:`0`
 
-    -  .. _`MEDIA-BUS-FMT-YUYV10-1X20`:
+    -  .. _MEDIA-BUS-FMT-YUYV10-1X20:
 
        -  MEDIA_BUS_FMT_YUYV10_1X20
 
@@ -10428,7 +10428,7 @@ the following codes.
 
        -  v\ :sub:`0`
 
-    -  .. _`MEDIA-BUS-FMT-YVYU10-1X20`:
+    -  .. _MEDIA-BUS-FMT-YVYU10-1X20:
 
        -  MEDIA_BUS_FMT_YVYU10_1X20
 
@@ -10568,7 +10568,7 @@ the following codes.
 
        -  u\ :sub:`0`
 
-    -  .. _`MEDIA-BUS-FMT-VUY8-1X24`:
+    -  .. _MEDIA-BUS-FMT-VUY8-1X24:
 
        -  MEDIA_BUS_FMT_VUY8_1X24
 
@@ -10639,7 +10639,7 @@ the following codes.
 
        -  y\ :sub:`0`
 
-    -  .. _`MEDIA-BUS-FMT-YUV8-1X24`:
+    -  .. _MEDIA-BUS-FMT-YUV8-1X24:
 
        -  MEDIA_BUS_FMT_YUV8_1X24
 
@@ -10710,7 +10710,7 @@ the following codes.
 
        -  v\ :sub:`0`
 
-    -  .. _`MEDIA-BUS-FMT-UYVY12-1X24`:
+    -  .. _MEDIA-BUS-FMT-UYVY12-1X24:
 
        -  MEDIA_BUS_FMT_UYVY12_1X24
 
@@ -10850,7 +10850,7 @@ the following codes.
 
        -  y\ :sub:`0`
 
-    -  .. _`MEDIA-BUS-FMT-VYUY12-1X24`:
+    -  .. _MEDIA-BUS-FMT-VYUY12-1X24:
 
        -  MEDIA_BUS_FMT_VYUY12_1X24
 
@@ -10990,7 +10990,7 @@ the following codes.
 
        -  y\ :sub:`0`
 
-    -  .. _`MEDIA-BUS-FMT-YUYV12-1X24`:
+    -  .. _MEDIA-BUS-FMT-YUYV12-1X24:
 
        -  MEDIA_BUS_FMT_YUYV12_1X24
 
@@ -11130,7 +11130,7 @@ the following codes.
 
        -  v\ :sub:`0`
 
-    -  .. _`MEDIA-BUS-FMT-YVYU12-1X24`:
+    -  .. _MEDIA-BUS-FMT-YVYU12-1X24:
 
        -  MEDIA_BUS_FMT_YVYU12_1X24
 
@@ -11270,7 +11270,7 @@ the following codes.
 
        -  u\ :sub:`0`
 
-    -  .. _`MEDIA-BUS-FMT-YUV10-1X30`:
+    -  .. _MEDIA-BUS-FMT-YUV10-1X30:
 
        -  MEDIA_BUS_FMT_YUV10_1X30
 
@@ -11341,7 +11341,7 @@ the following codes.
 
        -  v\ :sub:`0`
 
-    -  .. _`MEDIA-BUS-FMT-AYUV8-1X32`:
+    -  .. _MEDIA-BUS-FMT-AYUV8-1X32:
 
        -  MEDIA_BUS_FMT_AYUV8_1X32
 
@@ -11534,7 +11534,7 @@ The following table lists existing HSV/HSL formats.
 
        -  0
 
-    -  .. _`MEDIA-BUS-FMT-AHSV8888-1X32`:
+    -  .. _MEDIA-BUS-FMT-AHSV8888-1X32:
 
        -  MEDIA_BUS_FMT_AHSV8888_1X32
 
@@ -11639,7 +11639,7 @@ The following table lists existing JPEG compressed formats.
 
        -  Remarks
 
-    -  .. _`MEDIA-BUS-FMT-JPEG-1X8`:
+    -  .. _MEDIA-BUS-FMT-JPEG-1X8:
 
        -  MEDIA_BUS_FMT_JPEG_1X8
 
@@ -11678,7 +11678,7 @@ formats.
 
        -  Comments
 
-    -  .. _`MEDIA-BUS-FMT-S5C-UYVY-JPEG-1X8`:
+    -  .. _MEDIA-BUS-FMT-S5C-UYVY-JPEG-1X8:
 
        -  MEDIA_BUS_FMT_S5C_UYVY_JPEG_1X8
 
-- 
2.7.4

