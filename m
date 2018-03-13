Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f196.google.com ([209.85.128.196]:35923 "EHLO
        mail-wr0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751255AbeCMWSL (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 13 Mar 2018 18:18:11 -0400
Received: by mail-wr0-f196.google.com with SMTP id d10so2518697wrf.3
        for <linux-media@vger.kernel.org>; Tue, 13 Mar 2018 15:18:10 -0700 (PDT)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: linux-media@vger.kernel.org, mchehab@kernel.org,
        mchehab@s-opensource.com
Cc: rascobie@slingshot.co.nz
Subject: [PATCH v3 2/3] [media] docs: documentation bits for S2X and the 64K transmission mode
Date: Tue, 13 Mar 2018 23:18:04 +0100
Message-Id: <20180313221805.26818-3-d.scheller.oss@gmail.com>
In-Reply-To: <20180313221805.26818-1-d.scheller.oss@gmail.com>
References: <20180313221805.26818-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

Add documentation bits regarding DVB-S2X. Since S2X only brings more
APSK modulations and rolloff's, notice that S2 equals S2X where
appropriate, and mention the additional modulations and rolloff's
at the appropriate places.

Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
---
v2 to v3:
- Added these documentation bits

Please take note of some additional things in the cover letter.

 .../media/uapi/dvb/fe_property_parameters.rst      | 50 ++++++++++++++--------
 .../dvb/frontend-property-satellite-systems.rst    |  8 ++--
 2 files changed, 36 insertions(+), 22 deletions(-)

diff --git a/Documentation/media/uapi/dvb/fe_property_parameters.rst b/Documentation/media/uapi/dvb/fe_property_parameters.rst
index 3524dcae4604..fa98a0d6b3fc 100644
--- a/Documentation/media/uapi/dvb/fe_property_parameters.rst
+++ b/Documentation/media/uapi/dvb/fe_property_parameters.rst
@@ -92,7 +92,8 @@ DVB-C Annex B		64-QAM.
 DVB-T			QPSK, 16-QAM and 64-QAM.
 DVB-T2			QPSK, 16-QAM, 64-QAM and 256-QAM.
 DVB-S			No need to set. It supports only QPSK.
-DVB-S2			QPSK, 8-PSK, 16-APSK and 32-APSK.
+DVB-S2(X)		QPSK, 8-PSK, 16-APSK and 32-APSK. DVB-S2X additionally
+			supports 64-APSK, 128-APSK and 256-APSK.
 ISDB-T			QPSK, DQPSK, 16-QAM and 64-QAM.
 ISDB-S			8-PSK, QPSK and BPSK.
 ======================= =======================================================
@@ -146,7 +147,8 @@ ISDB-T			5MHz, 6MHz, 7MHz and 8MHz, although most places
      :ref:`DTV-SYMBOL-RATE`, and the rolloff factor, with is fixed for
      DVB-C and DVB-S.
 
-     For DVB-S2, the rolloff should also be set via :ref:`DTV-ROLLOFF`.
+     For DVB-S2 and DVB-S2X, the rolloff should also be set via
+     :ref:`DTV-ROLLOFF`.
 
 
 .. _DTV-INVERSION:
@@ -215,9 +217,9 @@ Currently not used.
 DTV_PILOT
 =========
 
-Used on DVB-S2.
+Used on DVB-S2 and DVB-S2X.
 
-Sets DVB-S2 pilot.
+Sets DVB-S2(X) pilot.
 
 The acceptable values are defined by :c:type:`fe_pilot`.
 
@@ -227,12 +229,17 @@ The acceptable values are defined by :c:type:`fe_pilot`.
 DTV_ROLLOFF
 ===========
 
-Used on DVB-S2.
+Used on DVB-S2 and DVB-S2X.
 
-Sets DVB-S2 rolloff.
+Sets DVB-S2(X) rolloff.
 
 The acceptable values are defined by :c:type:`fe_rolloff`.
 
+.. note::
+
+   Rolloff factors 15%, 10% an 5% are part of the DVB-S2X specifications
+   and thus are valid only for S2X-modulated transponders.
+
 
 .. _DTV-DISEQC-SLAVE-REPLY:
 
@@ -267,6 +274,12 @@ Specifies the type of the delivery system.
 
 The acceptable values are defined by :c:type:`fe_delivery_system`.
 
+.. note::
+
+   Since DVB-S2X only defines more rolloff's and more APSK modulations
+   without adding more attributes, DVB-S2X is handled via the DVB-S2
+   delivery system.
+
 
 .. _DTV-ISDBT-PARTIAL-RECEPTION:
 
@@ -894,7 +907,7 @@ The acceptable values are defined by :c:type:`fe_transmit_mode`.
 
    #. DVB-T specifies 2K and 8K as valid sizes.
 
-   #. DVB-T2 specifies 1K, 2K, 4K, 8K, 16K and 32K.
+   #. DVB-T2 specifies 1K, 2K, 4K, 8K, 16K, 32K and 64K.
 
    #. DTMB specifies C1 and C3780.
 
@@ -916,14 +929,14 @@ The acceptable values are defined by :c:type:`fe_hierarchy`.
 DTV_STREAM_ID
 =============
 
-Used on DVB-S2, DVB-T2 and ISDB-S.
+Used on DVB-S2(X), DVB-T2 and ISDB-S.
 
-DVB-S2, DVB-T2 and ISDB-S support the transmission of several streams on
-a single transport stream. This property enables the digital TV driver to
-handle substream filtering, when supported by the hardware. By default,
+DVB-S2(X), DVB-T2 and ISDB-S support the transmission of several streams
+on a single transport stream. This property enables the digital TV driver
+to handle substream filtering, when supported by the hardware. By default,
 substream filtering is disabled.
 
-For DVB-S2 and DVB-T2, the valid substream id range is from 0 to 255.
+For DVB-S2(X) and DVB-T2, the valid substream id range is from 0 to 255.
 
 For ISDB, the valid substream id range is from 1 to 65535.
 
@@ -994,13 +1007,14 @@ use the special macro LNA_AUTO to set LNA auto
 DTV_SCRAMBLING_SEQUENCE_INDEX
 =============================
 
-Used on DVB-S2.
+Used on DVB-S2 and DVB-S2X.
 
-This 18 bit field, when present, carries the index of the DVB-S2 physical
-layer scrambling sequence as defined in clause 5.5.4 of EN 302 307.
-There is no explicit signalling method to convey scrambling sequence index
-to the receiver. If S2 satellite delivery system descriptor is available
-it can be used to read the scrambling sequence index (EN 300 468 table 41).
+This 18 bit field, when present, carries the index of the DVB-S2(X)
+physical layer scrambling sequence as defined in clause 5.5.4 of
+EN 302 307. There is no explicit signalling method to convey scrambling
+sequence index to the receiver. If S2 satellite delivery system descriptor
+is available it can be used to read the scrambling sequence index
+(EN 300 468 table 41).
 
 By default, gold scrambling sequence index 0 is used.
 
diff --git a/Documentation/media/uapi/dvb/frontend-property-satellite-systems.rst b/Documentation/media/uapi/dvb/frontend-property-satellite-systems.rst
index 2929e6999a7a..9f20064850b1 100644
--- a/Documentation/media/uapi/dvb/frontend-property-satellite-systems.rst
+++ b/Documentation/media/uapi/dvb/frontend-property-satellite-systems.rst
@@ -46,11 +46,11 @@ Future implementations might add those two missing parameters:
 
 .. _dvbs2-params:
 
-DVB-S2 delivery system
-======================
+DVB-S2 and -S2X delivery systems
+================================
 
-In addition to all parameters valid for DVB-S, DVB-S2 supports the
-following parameters:
+In addition to all parameters valid for DVB-S, both DVB-S2 and DVB-S2X
+support the following parameters:
 
 -  :ref:`DTV_MODULATION <DTV-MODULATION>`
 
-- 
2.16.1
