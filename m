Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:46935
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752073AbdIANY6 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 1 Sep 2017 09:24:58 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>
Subject: [PATCH v2 10/27] media: fe_property_parameters.rst: better define properties usage
Date: Fri,  1 Sep 2017 10:24:32 -0300
Message-Id: <86fc94f744c75664d65e432ff7c9cd789dd6474f.1504272067.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1504272067.git.mchehab@s-opensource.com>
References: <cover.1504272067.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1504272067.git.mchehab@s-opensource.com>
References: <cover.1504272067.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Several frontend properties are specific to a subset of the
delivery systems. Make it clearer when describing each
property.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 .../media/uapi/dvb/fe_property_parameters.rst      | 82 ++++++++++++++++++++--
 1 file changed, 75 insertions(+), 7 deletions(-)

diff --git a/Documentation/media/uapi/dvb/fe_property_parameters.rst b/Documentation/media/uapi/dvb/fe_property_parameters.rst
index c6eb74f59b00..e085e84fef38 100644
--- a/Documentation/media/uapi/dvb/fe_property_parameters.rst
+++ b/Documentation/media/uapi/dvb/fe_property_parameters.rst
@@ -111,6 +111,8 @@ DTV_BANDWIDTH_HZ
 
 Bandwidth for the channel, in HZ.
 
+Should be set only for terrestrial delivery systems.
+
 Possible values: ``1712000``, ``5000000``, ``6000000``, ``7000000``,
 ``8000000``, ``10000000``.
 
@@ -148,6 +150,7 @@ Specifies if the frontend should do spectral inversion or not.
 
 The acceptable values are defined by :c:type:`fe_spectral_inversion`.
 
+
 .. _DTV-DISEQC-MASTER:
 
 DTV_DISEQC_MASTER
@@ -161,8 +164,9 @@ Currently not implemented.
 DTV_SYMBOL_RATE
 ===============
 
-Digital TV symbol rate, in bauds (symbols/second). Used on cable
-standards.
+Used on cable and satellite delivery systems.
+
+Digital TV symbol rate, in bauds (symbols/second).
 
 
 .. _DTV-INNER-FEC:
@@ -170,7 +174,7 @@ standards.
 DTV_INNER_FEC
 =============
 
-Used cable/satellite transmissions.
+Used on cable and satellite delivery systems.
 
 The acceptable values are defined by :c:type:`fe_code_rate`.
 
@@ -180,6 +184,8 @@ The acceptable values are defined by :c:type:`fe_code_rate`.
 DTV_VOLTAGE
 ===========
 
+Used on satellite delivery systems.
+
 The voltage is usually used with non-DiSEqC capable LNBs to switch the
 polarzation (horizontal/vertical). When using DiSEqC epuipment this
 voltage has to be switched consistently to the DiSEqC commands as
@@ -201,6 +207,8 @@ Currently not used.
 DTV_PILOT
 =========
 
+Used on DVB-S2.
+
 Sets DVB-S2 pilot.
 
 The acceptable values are defined by :c:type:`fe_pilot`.
@@ -211,7 +219,9 @@ The acceptable values are defined by :c:type:`fe_pilot`.
 DTV_ROLLOFF
 ===========
 
-Sets DVB-S2 rolloff
+Used on DVB-S2.
+
+Sets DVB-S2 rolloff.
 
 The acceptable values are defined by :c:type:`fe_rolloff`.
 
@@ -245,7 +255,7 @@ Currently not implemented.
 DTV_DELIVERY_SYSTEM
 ===================
 
-Specifies the type of Delivery system.
+Specifies the type of the delivery system.
 
 The acceptable values are defined by :c:type:`fe_delivery_system`.
 
@@ -255,6 +265,8 @@ The acceptable values are defined by :c:type:`fe_delivery_system`.
 DTV_ISDBT_PARTIAL_RECEPTION
 ===========================
 
+Used only on ISDB.
+
 If ``DTV_ISDBT_SOUND_BROADCASTING`` is '0' this bit-field represents
 whether the channel is in partial reception mode or not.
 
@@ -273,6 +285,8 @@ Possible values: 0, 1, -1 (AUTO)
 DTV_ISDBT_SOUND_BROADCASTING
 ============================
 
+Used only on ISDB.
+
 This field represents whether the other DTV_ISDBT_*-parameters are
 referring to an ISDB-T and an ISDB-Tsb channel. (See also
 ``DTV_ISDBT_PARTIAL_RECEPTION``).
@@ -285,6 +299,8 @@ Possible values: 0, 1, -1 (AUTO)
 DTV_ISDBT_SB_SUBCHANNEL_ID
 ==========================
 
+Used only on ISDB.
+
 This field only applies if ``DTV_ISDBT_SOUND_BROADCASTING`` is '1'.
 
 (Note of the author: This might not be the correct description of the
@@ -320,6 +336,8 @@ Possible values: 0 .. 41, -1 (AUTO)
 DTV_ISDBT_SB_SEGMENT_IDX
 ========================
 
+Used only on ISDB.
+
 This field only applies if ``DTV_ISDBT_SOUND_BROADCASTING`` is '1'.
 
 ``DTV_ISDBT_SB_SEGMENT_IDX`` gives the index of the segment to be
@@ -336,6 +354,8 @@ Note: This value cannot be determined by an automatic channel search.
 DTV_ISDBT_SB_SEGMENT_COUNT
 ==========================
 
+Used only on ISDB.
+
 This field only applies if ``DTV_ISDBT_SOUND_BROADCASTING`` is '1'.
 
 ``DTV_ISDBT_SB_SEGMENT_COUNT`` gives the total count of connected
@@ -351,6 +371,8 @@ Note: This value cannot be determined by an automatic channel search.
 DTV-ISDBT-LAYER[A-C] parameters
 ===============================
 
+Used only on ISDB.
+
 ISDB-T channels can be coded hierarchically. As opposed to DVB-T in
 ISDB-T hierarchical layers can be decoded simultaneously. For that
 reason a ISDB-T demodulator has 3 Viterbi and 3 Reed-Solomon decoders.
@@ -367,6 +389,8 @@ There are 3 parameter sets, for Layers A, B and C.
 DTV_ISDBT_LAYER_ENABLED
 -----------------------
 
+Used only on ISDB.
+
 Hierarchical reception in ISDB-T is achieved by enabling or disabling
 layers in the decoding process. Setting all bits of
 ``DTV_ISDBT_LAYER_ENABLED`` to '1' forces all layers (if applicable) to
@@ -397,6 +421,8 @@ Only the values of the first 3 bits are used. Other bits will be silently ignore
 DTV_ISDBT_LAYER[A-C]_FEC
 ------------------------
 
+Used only on ISDB.
+
 The Forward Error Correction mechanism used by a given ISDB Layer, as
 defined by :c:type:`fe_code_rate`.
 
@@ -410,6 +436,8 @@ Possible values are: ``FEC_AUTO``, ``FEC_1_2``, ``FEC_2_3``, ``FEC_3_4``,
 DTV_ISDBT_LAYER[A-C]_MODULATION
 -------------------------------
 
+Used only on ISDB.
+
 The modulation used by a given ISDB Layer, as defined by
 :c:type:`fe_modulation`.
 
@@ -428,6 +456,8 @@ Possible values are: ``QAM_AUTO``, ``QPSK``, ``QAM_16``, ``QAM_64``, ``DQPSK``
 DTV_ISDBT_LAYER[A-C]_SEGMENT_COUNT
 ----------------------------------
 
+Used only on ISDB.
+
 Possible values: 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, -1 (AUTO)
 
 Note: Truth table for ``DTV_ISDBT_SOUND_BROADCASTING`` and
@@ -517,6 +547,8 @@ Note: Truth table for ``DTV_ISDBT_SOUND_BROADCASTING`` and
 DTV_ISDBT_LAYER[A-C]_TIME_INTERLEAVING
 --------------------------------------
 
+Used only on ISDB.
+
 Valid values: 0, 1, 2, 4, -1 (AUTO)
 
 when DTV_ISDBT_SOUND_BROADCASTING is active, value 8 is also valid.
@@ -590,6 +622,8 @@ TMCC-structure, as shown in the table below.
 DTV_ATSCMH_FIC_VER
 ------------------
 
+Used only on ATSC-MH.
+
 Version number of the FIC (Fast Information Channel) signaling data.
 
 FIC is used for relaying information to allow rapid service acquisition
@@ -603,6 +637,8 @@ Possible values: 0, 1, 2, 3, ..., 30, 31
 DTV_ATSCMH_PARADE_ID
 --------------------
 
+Used only on ATSC-MH.
+
 Parade identification number
 
 A parade is a collection of up to eight MH groups, conveying one or two
@@ -616,6 +652,8 @@ Possible values: 0, 1, 2, 3, ..., 126, 127
 DTV_ATSCMH_NOG
 --------------
 
+Used only on ATSC-MH.
+
 Number of MH groups per MH subframe for a designated parade.
 
 Possible values: 1, 2, 3, 4, 5, 6, 7, 8
@@ -626,6 +664,8 @@ Possible values: 1, 2, 3, 4, 5, 6, 7, 8
 DTV_ATSCMH_TNOG
 ---------------
 
+Used only on ATSC-MH.
+
 Total number of MH groups including all MH groups belonging to all MH
 parades in one MH subframe.
 
@@ -637,6 +677,8 @@ Possible values: 0, 1, 2, 3, ..., 30, 31
 DTV_ATSCMH_SGN
 --------------
 
+Used only on ATSC-MH.
+
 Start group number.
 
 Possible values: 0, 1, 2, 3, ..., 14, 15
@@ -647,6 +689,8 @@ Possible values: 0, 1, 2, 3, ..., 14, 15
 DTV_ATSCMH_PRC
 --------------
 
+Used only on ATSC-MH.
+
 Parade repetition cycle.
 
 Possible values: 1, 2, 3, 4, 5, 6, 7, 8
@@ -657,6 +701,8 @@ Possible values: 1, 2, 3, 4, 5, 6, 7, 8
 DTV_ATSCMH_RS_FRAME_MODE
 ------------------------
 
+Used only on ATSC-MH.
+
 Reed Solomon (RS) frame mode.
 
 The acceptable values are defined by :c:type:`atscmh_rs_frame_mode`.
@@ -667,6 +713,8 @@ The acceptable values are defined by :c:type:`atscmh_rs_frame_mode`.
 DTV_ATSCMH_RS_FRAME_ENSEMBLE
 ----------------------------
 
+Used only on ATSC-MH.
+
 Reed Solomon(RS) frame ensemble.
 
 The acceptable values are defined by :c:type:`atscmh_rs_frame_ensemble`.
@@ -677,6 +725,8 @@ The acceptable values are defined by :c:type:`atscmh_rs_frame_ensemble`.
 DTV_ATSCMH_RS_CODE_MODE_PRI
 ---------------------------
 
+Used only on ATSC-MH.
+
 Reed Solomon (RS) code mode (primary).
 
 The acceptable values are defined by :c:type:`atscmh_rs_code_mode`.
@@ -687,6 +737,8 @@ The acceptable values are defined by :c:type:`atscmh_rs_code_mode`.
 DTV_ATSCMH_RS_CODE_MODE_SEC
 ---------------------------
 
+Used only on ATSC-MH.
+
 Reed Solomon (RS) code mode (secondary).
 
 The acceptable values are defined by :c:type:`atscmh_rs_code_mode`.
@@ -697,6 +749,8 @@ The acceptable values are defined by :c:type:`atscmh_rs_code_mode`.
 DTV_ATSCMH_SCCC_BLOCK_MODE
 --------------------------
 
+Used only on ATSC-MH.
+
 Series Concatenated Convolutional Code Block Mode.
 
 The acceptable values are defined by :c:type:`atscmh_sccc_block_mode`.
@@ -707,6 +761,8 @@ The acceptable values are defined by :c:type:`atscmh_sccc_block_mode`.
 DTV_ATSCMH_SCCC_CODE_MODE_A
 ---------------------------
 
+Used only on ATSC-MH.
+
 Series Concatenated Convolutional Code Rate.
 
 The acceptable values are defined by :c:type:`atscmh_sccc_code_mode`.
@@ -716,6 +772,8 @@ The acceptable values are defined by :c:type:`atscmh_sccc_code_mode`.
 DTV_ATSCMH_SCCC_CODE_MODE_B
 ---------------------------
 
+Used only on ATSC-MH.
+
 Series Concatenated Convolutional Code Rate.
 
 Possible values are the same as documented on enum
@@ -727,6 +785,8 @@ Possible values are the same as documented on enum
 DTV_ATSCMH_SCCC_CODE_MODE_C
 ---------------------------
 
+Used only on ATSC-MH.
+
 Series Concatenated Convolutional Code Rate.
 
 Possible values are the same as documented on enum
@@ -738,6 +798,8 @@ Possible values are the same as documented on enum
 DTV_ATSCMH_SCCC_CODE_MODE_D
 ---------------------------
 
+Used only on ATSC-MH.
+
 Series Concatenated Convolutional Code Rate.
 
 Possible values are the same as documented on enum
@@ -797,9 +859,11 @@ The acceptable values are defined by :c:type:`fe_guard_interval`.
 DTV_TRANSMISSION_MODE
 =====================
 
+
+Used only on OFTM-based standards, e. g. DVB-T/T2, ISDB-T, DTMB.
+
 Specifies the FFT size (with corresponds to the approximate number of
-carriers) used by the standard. This is used only on OFTM-based standards,
-e. g. DVB-T/T2, ISDB-T, DTMB.
+carriers) used by the standard.
 
 The acceptable values are defined by :c:type:`fe_transmit_mode`.
 
@@ -832,6 +896,8 @@ The acceptable values are defined by :c:type:`fe_transmit_mode`.
 DTV_HIERARCHY
 =============
 
+Used only on DVB-T and DVB-T2.
+
 Frontend hierarchy.
 
 The acceptable values are defined by :c:type:`fe_hierarchy`.
@@ -842,6 +908,8 @@ The acceptable values are defined by :c:type:`fe_hierarchy`.
 DTV_STREAM_ID
 =============
 
+Used on DVB-S2, DVB-T2 and ISDB-S.
+
 DVB-S2, DVB-T2 and ISDB-S support the transmission of several streams on
 a single transport stream. This property enables the DVB driver to
 handle substream filtering, when supported by the hardware. By default,
-- 
2.13.5
