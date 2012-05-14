Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qc0-f174.google.com ([209.85.216.174]:62645 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932461Ab2ENWLY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 May 2012 18:11:24 -0400
Received: by qcro28 with SMTP id o28so3753022qcr.19
        for <linux-media@vger.kernel.org>; Mon, 14 May 2012 15:11:23 -0700 (PDT)
From: Michael Krufky <mkrufky@kernellabs.com>
To: linux-media@vger.kernel.org
Cc: mchehab@infradead.org, Michael Krufky <mkrufky@linuxtv.org>
Subject: [PATCH 02/11] DocBook: document new DTV Properties for ATSC-MH delivery system
Date: Mon, 14 May 2012 18:10:44 -0400
Message-Id: <1337033453-22119-2-git-send-email-mkrufky@linuxtv.org>
In-Reply-To: <1337033453-22119-1-git-send-email-mkrufky@linuxtv.org>
References: <1337033453-22119-1-git-send-email-mkrufky@linuxtv.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Document the following properties for controlling an ATSC-MH frontend:

DTV_ATSCMH_FIC_VER - Version number of the FIC signaling data
DTV_ATSCMH_PARADE_ID - Parade identification number
DTV_ATSCMH_NOG - Number of MH groups per MH subframe for a designated parade
DTV_ATSCMH_TNOG - Total number of MH groups in all parades in one subframe
DTV_ATSCMH_SGN - Start group number
DTV_ATSCMH_PRC - Parade repetition cycle
DTV_ATSCMH_RS_FRAME_MODE - RS frame mode
DTV_ATSCMH_RS_FRAME_ENSEMBLE - RS frame ensemble
DTV_ATSCMH_RS_CODE_MODE_PRI - RS code mode (primary)
DTV_ATSCMH_RS_CODE_MODE_SEC - RS code mode (secondary)
DTV_ATSCMH_SCCC_BLOCK_MODE - Series Concatenated Convolutional Code Block Mode
DTV_ATSCMH_SCCC_CODE_MODE_A - Series Concatenated Convolutional Code Rate A
DTV_ATSCMH_SCCC_CODE_MODE_B - Series Concatenated Convolutional Code Rate B
DTV_ATSCMH_SCCC_CODE_MODE_C - Series Concatenated Convolutional Code Rate C
DTV_ATSCMH_SCCC_CODE_MODE_D - Series Concatenated Convolutional Code Rate D
DTV_ATSCMH_FIC_ERR - FIC error count
DTV_ATSCMH_CRC_ERR - CRC error count
DTV_ATSCMH_RS_ERR - RS error count

Signed-off-by: Michael Krufky <mkrufky@linuxtv.org>
---
 Documentation/DocBook/media/dvb/dvbproperty.xml |  178 +++++++++++++++++++++++
 1 file changed, 178 insertions(+)

diff --git a/Documentation/DocBook/media/dvb/dvbproperty.xml b/Documentation/DocBook/media/dvb/dvbproperty.xml
index c7a4ca5..d631535 100644
--- a/Documentation/DocBook/media/dvb/dvbproperty.xml
+++ b/Documentation/DocBook/media/dvb/dvbproperty.xml
@@ -531,6 +531,154 @@ typedef enum fe_delivery_system {
 				here are referring to what can be found in the TMCC-structure -
 				independent of the mode.</para>
 		</section>
+		<section id="DTV-ATSCMH-FIC-VER">
+			<title><constant>DTV_ATSCMH_FIC_VER</constant></title>
+			<para>Version number of the FIC (Fast Information Channel) signaling data.</para>
+			<para>FIC is used for relaying information to allow rapid service acquisition by the receiver.</para>
+			<para>Possible values: 0, 1, 2, 3, ..., 30, 31</para>
+		</section>
+		<section id="DTV-ATSCMH-PARADE-ID">
+			<title><constant>DTV_ATSCMH_PARADE_ID</constant></title>
+			<para>Parade identification number</para>
+			<para>A parade is a collection of up to eight MH groups, conveying one or two ensembles.</para>
+			<para>Possible values: 0, 1, 2, 3, ..., 126, 127</para>
+		</section>
+		<section id="DTV-ATSCMH-NOG">
+			<title><constant>DTV_ATSCMH_NOG</constant></title>
+			<para>Number of MH groups per MH subframe for a designated parade.</para>
+			<para>Possible values: 1, 2, 3, 4, 5, 6, 7, 8</para>
+		</section>
+		<section id="DTV-ATSCMH-TNOG">
+			<title><constant>DTV_ATSCMH_TNOG</constant></title>
+			<para>Total number of MH groups including all MH groups belonging to all MH parades in one MH subframe.</para>
+			<para>Possible values: 0, 1, 2, 3, ..., 30, 31</para>
+		</section>
+		<section id="DTV-ATSCMH-SGN">
+			<title><constant>DTV_ATSCMH_SGN</constant></title>
+			<para>Start group number.</para>
+			<para>Possible values: 0, 1, 2, 3, ..., 14, 15</para>
+		</section>
+		<section id="DTV-ATSCMH-PRC">
+			<title><constant>DTV_ATSCMH_PRC</constant></title>
+			<para>Parade repetition cycle.</para>
+			<para>Possible values: 1, 2, 3, 4, 5, 6, 7, 8</para>
+		</section>
+		<section id="DTV-ATSCMH-RS-FRAME-MODE">
+			<title><constant>DTV_ATSCMH_RS_FRAME_MODE</constant></title>
+			<para>RS frame mode.</para>
+			<para>Possible values are:</para>
+<programlisting>
+typedef enum atscmh_rs_frame_mode {
+	ATSCMH_RSFRAME_PRI_ONLY  = 0,
+	ATSCMH_RSFRAME_PRI_SEC   = 1,
+} atscmh_rs_frame_mode_t;
+</programlisting>
+		</section>
+		<section id="DTV-ATSCMH-RS-FRAME-ENSEMBLE">
+			<title><constant>DTV_ATSCMH_RS_FRAME_ENSEMBLE</constant></title>
+			<para>RS frame ensemble.</para>
+			<para>Possible values are:</para>
+<programlisting>
+typedef enum atscmh_rs_frame_ensemble {
+	ATSCMH_RSFRAME_ENS_PRI   = 0,
+	ATSCMH_RSFRAME_ENS_SEC   = 1,
+} atscmh_rs_frame_ensemble_t;
+</programlisting>
+		</section>
+		<section id="DTV-ATSCMH-RS-CODE-MODE-PRI">
+			<title><constant>DTV_ATSCMH_RS_CODE_MODE_PRI</constant></title>
+			<para>RS code mode (primary).</para>
+			<para>Possible values are:</para>
+<programlisting>
+typedef enum atscmh_rs_code_mode {
+	ATSCMH_RSCODE_211_187    = 0,
+	ATSCMH_RSCODE_223_187    = 1,
+	ATSCMH_RSCODE_235_187    = 2,
+} atscmh_rs_code_mode_t;
+</programlisting>
+		</section>
+		<section id="DTV-ATSCMH-RS-CODE-MODE-SEC">
+			<title><constant>DTV_ATSCMH_RS_CODE_MODE_SEC</constant></title>
+			<para>RS code mode (secondary).</para>
+			<para>Possible values are:</para>
+<programlisting>
+typedef enum atscmh_rs_code_mode {
+	ATSCMH_RSCODE_211_187    = 0,
+	ATSCMH_RSCODE_223_187    = 1,
+	ATSCMH_RSCODE_235_187    = 2,
+} atscmh_rs_code_mode_t;
+</programlisting>
+		</section>
+		<section id="DTV-ATSCMH-SCCC-BLOCK-MODE">
+			<title><constant>DTV_ATSCMH_SCCC_BLOCK_MODE</constant></title>
+			<para>Series Concatenated Convolutional Code Block Mode.</para>
+			<para>Possible values are:</para>
+<programlisting>
+typedef enum atscmh_sccc_block_mode {
+	ATSCMH_SCCC_BLK_SEP      = 0,
+	ATSCMH_SCCC_BLK_COMB     = 1,
+} atscmh_sccc_block_mode_t;
+</programlisting>
+		</section>
+		<section id="DTV-ATSCMH-SCCC-CODE-MODE-A">
+			<title><constant>DTV_ATSCMH_SCCC_CODE_MODE_A</constant></title>
+			<para>Series Concatenated Convolutional Code Rate.</para>
+			<para>Possible values are:</para>
+<programlisting>
+typedef enum atscmh_sccc_code_mode {
+	ATSCMH_SCCC_CODE_HLF     = 0,
+	ATSCMH_SCCC_CODE_QTR     = 1,
+} atscmh_sccc_code_mode_t;
+</programlisting>
+		</section>
+		<section id="DTV-ATSCMH-SCCC-CODE-MODE-B">
+			<title><constant>DTV_ATSCMH_SCCC_CODE_MODE_B</constant></title>
+			<para>Series Concatenated Convolutional Code Rate.</para>
+			<para>Possible values are:</para>
+<programlisting>
+typedef enum atscmh_sccc_code_mode {
+	ATSCMH_SCCC_CODE_HLF     = 0,
+	ATSCMH_SCCC_CODE_QTR     = 1,
+} atscmh_sccc_code_mode_t;
+</programlisting>
+		</section>
+		<section id="DTV-ATSCMH-SCCC-CODE-MODE-C">
+			<title><constant>DTV_ATSCMH_SCCC_CODE_MODE_C</constant></title>
+			<para>Series Concatenated Convolutional Code Rate.</para>
+			<para>Possible values are:</para>
+<programlisting>
+typedef enum atscmh_sccc_code_mode {
+	ATSCMH_SCCC_CODE_HLF     = 0,
+	ATSCMH_SCCC_CODE_QTR     = 1,
+} atscmh_sccc_code_mode_t;
+</programlisting>
+		</section>
+		<section id="DTV-ATSCMH-SCCC-CODE-MODE-D">
+			<title><constant>DTV_ATSCMH_SCCC_CODE_MODE_D</constant></title>
+			<para>Series Concatenated Convolutional Code Rate.</para>
+			<para>Possible values are:</para>
+<programlisting>
+typedef enum atscmh_sccc_code_mode {
+	ATSCMH_SCCC_CODE_HLF     = 0,
+	ATSCMH_SCCC_CODE_QTR     = 1,
+} atscmh_sccc_code_mode_t;
+</programlisting>
+		</section>
+		<section id="DTV-ATSCMH-FIC-ERR">
+			<title><constant>DTV_ATSCMH_FIC_ERR</constant></title>
+			<para>FIC error count.</para>
+			<para>Possible values: 0, 1, 2, 3, ..., 0xffff</para>
+		</section>
+		<section id="DTV-ATSCMH-CRC-ERR">
+			<title><constant>DTV_ATSCMH_CRC_ERR</constant></title>
+			<para>CRC error count.</para>
+			<para>Possible values: 0, 1, 2, 3, ..., 0xffff</para>
+		</section>
+		<section id="DTV-ATSCMH-RS-ERR">
+			<title><constant>DTV_ATSCMH_RS_ERR</constant></title>
+			<para>RS error count.</para>
+			<para>Possible values: 0, 1, 2, 3, ..., 0xffff</para>
+		</section>
 	</section>
 	<section id="DTV-API-VERSION">
 	<title><constant>DTV_API_VERSION</constant></title>
@@ -774,6 +922,36 @@ typedef enum fe_hierarchy {
 				<listitem><para><link linkend="DTV-BANDWIDTH-HZ"><constant>DTV_BANDWIDTH_HZ</constant></link></para></listitem>
 			</itemizedlist>
 		</section>
+		<section id="atscmh-params">
+			<title>ATSC-MH delivery system</title>
+			<para>The following parameters are valid for ATSC-MH:</para>
+			<itemizedlist mark='opencircle'>
+				<listitem><para><link linkend="DTV-API-VERSION"><constant>DTV_API_VERSION</constant></link></para></listitem>
+				<listitem><para><link linkend="DTV-DELIVERY-SYSTEM"><constant>DTV_DELIVERY_SYSTEM</constant></link></para></listitem>
+				<listitem><para><link linkend="DTV-TUNE"><constant>DTV_TUNE</constant></link></para></listitem>
+				<listitem><para><link linkend="DTV-CLEAR"><constant>DTV_CLEAR</constant></link></para></listitem>
+				<listitem><para><link linkend="DTV-FREQUENCY"><constant>DTV_FREQUENCY</constant></link></para></listitem>
+				<listitem><para><link linkend="DTV-BANDWIDTH-HZ"><constant>DTV_BANDWIDTH_HZ</constant></link></para></listitem>
+				<listitem><para><link linkend="DTV-ATSCMH-FIC-VER"><constant>DTV_ATSCMH_FIC_VER</constant></link></para></listitem>
+				<listitem><para><link linkend="DTV-ATSCMH-PARADE-ID"><constant>DTV_ATSCMH_PARADE_ID</constant></link></para></listitem>
+				<listitem><para><link linkend="DTV-ATSCMH-NOG"><constant>DTV_ATSCMH_NOG</constant></link></para></listitem>
+				<listitem><para><link linkend="DTV-ATSCMH-TNOG"><constant>DTV_ATSCMH_TNOG</constant></link></para></listitem>
+				<listitem><para><link linkend="DTV-ATSCMH-SGN"><constant>DTV_ATSCMH_SGN</constant></link></para></listitem>
+				<listitem><para><link linkend="DTV-ATSCMH-PRC"><constant>DTV_ATSCMH_PRC</constant></link></para></listitem>
+				<listitem><para><link linkend="DTV-ATSCMH-RS-FRAME-MODE"><constant>DTV_ATSCMH_RS_FRAME_MODE</constant></link></para></listitem>
+				<listitem><para><link linkend="DTV-ATSCMH-RS-FRAME-ENSEMBLE"><constant>DTV_ATSCMH_RS_FRAME_ENSEMBLE</constant></link></para></listitem>
+				<listitem><para><link linkend="DTV-ATSCMH-CODE-MODE-PRI"><constant>DTV_ATSCMH_CODE_MODE_PRI</constant></link></para></listitem>
+				<listitem><para><link linkend="DTV-ATSCMH-CODE-MODE-SEC"><constant>DTV_ATSCMH_CODE_MODE_SEC</constant></link></para></listitem>
+				<listitem><para><link linkend="DTV-ATSCMH-SCCC-BLOCK-MODE"><constant>DTV_ATSCMH_SCCC_BLOCK_MODE</constant></link></para></listitem>
+				<listitem><para><link linkend="DTV-ATSCMH-SCCC-CODE_MODE-A"><constant>DTV_ATSCMH_SCCC_CODE_MODE_A</constant></link></para></listitem>
+				<listitem><para><link linkend="DTV-ATSCMH-SCCC-CODE_MODE-B"><constant>DTV_ATSCMH_SCCC_CODE_MODE_B</constant></link></para></listitem>
+				<listitem><para><link linkend="DTV-ATSCMH-SCCC-CODE_MODE-C"><constant>DTV_ATSCMH_SCCC_CODE_MODE_C</constant></link></para></listitem>
+				<listitem><para><link linkend="DTV-ATSCMH-SCCC-CODE_MODE-D"><constant>DTV_ATSCMH_SCCC_CODE_MODE_D</constant></link></para></listitem>
+				<listitem><para><link linkend="DTV-ATSCMH-FIC-ERR"><constant>DTV_ATSCMH_FIC_ERR</constant></link></para></listitem>
+				<listitem><para><link linkend="DTV-ATSCMH-CRC-ERR"><constant>DTV_ATSCMH_CRC_ERR</constant></link></para></listitem>
+				<listitem><para><link linkend="DTV-ATSCMH-RS-ERR"><constant>DTV_ATSCMH_RS_ERR</constant></link></para></listitem>
+			</itemizedlist>
+		</section>
 	</section>
 	<section id="frontend-property-cable-systems">
 	<title>Properties used on cable delivery systems</title>
-- 
1.7.9.5

