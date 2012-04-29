Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:56162 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752867Ab2D2QbX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 29 Apr 2012 12:31:23 -0400
Received: by vcqp1 with SMTP id p1so1583944vcq.19
        for <linux-media@vger.kernel.org>; Sun, 29 Apr 2012 09:31:23 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAHAyoxzrPdad5ub0YJofJDrjJi-K+=nsqP4qR4pRAAXgG6718A@mail.gmail.com>
References: <CAOcJUbxHCo7xfGHJZdeEgReJrpCriweSb9s9+-_NfSODLz_NPQ@mail.gmail.com>
	<4F9014CD.1040005@redhat.com>
	<CAHAyoxyhHx8nXhPT0iuKZhcM=bTEaSM=rXfs5P92JXsuOLciCw@mail.gmail.com>
	<CAHAyoxzrPdad5ub0YJofJDrjJi-K+=nsqP4qR4pRAAXgG6718A@mail.gmail.com>
Date: Sun, 29 Apr 2012 12:31:22 -0400
Message-ID: <CAOcJUby+KAE2Dp4NeMWhEtfE=FJG4RKSf5sc_Uxpsm0cbejE=A@mail.gmail.com>
Subject: Re: ATSC-MH driver support for the Hauppauge WinTV Aero-m
From: Michael Krufky <mkrufky@kernellabs.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

>From 78d56f9888c1c768b43cc75e0e02d0e60848bcc4 Mon Sep 17 00:00:00 2001
From: Michael Krufky <mkrufky@linuxtv.org>
Date: Sun, 29 Jan 2012 13:44:58 -0500
Subject: [PATCH 1/3] linux-dvb v5 API support for ATSC-MH

Signed-off-by: Michael Krufky <mkrufky@linuxtv.org>
---
 drivers/media/dvb/dvb-core/dvb_frontend.c |   92 ++++++++++++++++++++++++++++-
 drivers/media/dvb/dvb-core/dvb_frontend.h |   22 +++++++
 include/linux/dvb/frontend.h              |   54 +++++++++++++++++-
 3 files changed, 166 insertions(+), 2 deletions(-)

diff --git a/drivers/media/dvb/dvb-core/dvb_frontend.c
b/drivers/media/dvb/dvb-core/dvb_frontend.c
index 4555baa..067f10a 100644
--- a/drivers/media/dvb/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb/dvb-core/dvb_frontend.c
@@ -180,13 +180,13 @@ static enum dvbv3_emulation_type dvbv3_type(u32
delivery_system)
 	case SYS_DMBTH:
 		return DVBV3_OFDM;
 	case SYS_ATSC:
+	case SYS_ATSCMH:
 	case SYS_DVBC_ANNEX_B:
 		return DVBV3_ATSC;
 	case SYS_UNDEFINED:
 	case SYS_ISDBC:
 	case SYS_DVBH:
 	case SYS_DAB:
-	case SYS_ATSCMH:
 	default:
 		/*
 		 * Doesn't know how to emulate those types and/or
@@ -1027,6 +1027,28 @@ static struct dtv_cmds_h
dtv_cmds[DTV_MAX_COMMAND + 1] = {
 	_DTV_CMD(DTV_HIERARCHY, 0, 0),

 	_DTV_CMD(DTV_ENUM_DELSYS, 0, 0),
+
+	_DTV_CMD(DTV_ATSCMH_PARADE_ID, 1, 0),
+	_DTV_CMD(DTV_ATSCMH_RS_FRAME_ENSEMBLE, 1, 0),
+
+	_DTV_CMD(DTV_ATSCMH_FIC_VER, 0, 0),
+	_DTV_CMD(DTV_ATSCMH_PARADE_ID, 0, 0),
+	_DTV_CMD(DTV_ATSCMH_NOG, 0, 0),
+	_DTV_CMD(DTV_ATSCMH_TNOG, 0, 0),
+	_DTV_CMD(DTV_ATSCMH_SGN, 0, 0),
+	_DTV_CMD(DTV_ATSCMH_PRC, 0, 0),
+	_DTV_CMD(DTV_ATSCMH_RS_FRAME_MODE, 0, 0),
+	_DTV_CMD(DTV_ATSCMH_RS_FRAME_ENSEMBLE, 0, 0),
+	_DTV_CMD(DTV_ATSCMH_RS_CODE_MODE_PRI, 0, 0),
+	_DTV_CMD(DTV_ATSCMH_RS_CODE_MODE_SEC, 0, 0),
+	_DTV_CMD(DTV_ATSCMH_SCCC_BLOCK_MODE, 0, 0),
+	_DTV_CMD(DTV_ATSCMH_SCCC_CODE_MODE_A, 0, 0),
+	_DTV_CMD(DTV_ATSCMH_SCCC_CODE_MODE_B, 0, 0),
+	_DTV_CMD(DTV_ATSCMH_SCCC_CODE_MODE_C, 0, 0),
+	_DTV_CMD(DTV_ATSCMH_SCCC_CODE_MODE_D, 0, 0),
+	_DTV_CMD(DTV_ATSCMH_FIC_ERR, 0, 0),
+	_DTV_CMD(DTV_ATSCMH_CRC_ERR, 0, 0),
+	_DTV_CMD(DTV_ATSCMH_RS_ERR, 0, 0),
 };

 static void dtv_property_dump(struct dtv_property *tvp)
@@ -1118,6 +1140,8 @@ static int dtv_property_cache_sync(struct
dvb_frontend *fe,
 	case DVBV3_ATSC:
 		dprintk("%s() Preparing ATSC req\n", __func__);
 		c->modulation = p->u.vsb.modulation;
+		if (c->delivery_system == SYS_ATSCMH)
+			break;
 		if ((c->modulation == VSB_8) || (c->modulation == VSB_16))
 			c->delivery_system = SYS_ATSC;
 		else
@@ -1364,6 +1388,63 @@ static int dtv_property_process_get(struct
dvb_frontend *fe,
 	case DTV_DVBT2_PLP_ID:
 		tvp->u.data = c->dvbt2_plp_id;
 		break;
+
+	/* ATSC-MH */
+	case DTV_ATSCMH_FIC_VER:
+		tvp->u.data = fe->dtv_property_cache.atscmh_fic_ver;
+		break;
+	case DTV_ATSCMH_PARADE_ID:
+		tvp->u.data = fe->dtv_property_cache.atscmh_parade_id;
+		break;
+	case DTV_ATSCMH_NOG:
+		tvp->u.data = fe->dtv_property_cache.atscmh_nog;
+		break;
+	case DTV_ATSCMH_TNOG:
+		tvp->u.data = fe->dtv_property_cache.atscmh_tnog;
+		break;
+	case DTV_ATSCMH_SGN:
+		tvp->u.data = fe->dtv_property_cache.atscmh_sgn;
+		break;
+	case DTV_ATSCMH_PRC:
+		tvp->u.data = fe->dtv_property_cache.atscmh_prc;
+		break;
+	case DTV_ATSCMH_RS_FRAME_MODE:
+		tvp->u.data = fe->dtv_property_cache.atscmh_rs_frame_mode;
+		break;
+	case DTV_ATSCMH_RS_FRAME_ENSEMBLE:
+		tvp->u.data = fe->dtv_property_cache.atscmh_rs_frame_ensemble;
+		break;
+	case DTV_ATSCMH_RS_CODE_MODE_PRI:
+		tvp->u.data = fe->dtv_property_cache.atscmh_rs_code_mode_pri;
+		break;
+	case DTV_ATSCMH_RS_CODE_MODE_SEC:
+		tvp->u.data = fe->dtv_property_cache.atscmh_rs_code_mode_sec;
+		break;
+	case DTV_ATSCMH_SCCC_BLOCK_MODE:
+		tvp->u.data = fe->dtv_property_cache.atscmh_sccc_block_mode;
+		break;
+	case DTV_ATSCMH_SCCC_CODE_MODE_A:
+		tvp->u.data = fe->dtv_property_cache.atscmh_sccc_code_mode_a;
+		break;
+	case DTV_ATSCMH_SCCC_CODE_MODE_B:
+		tvp->u.data = fe->dtv_property_cache.atscmh_sccc_code_mode_b;
+		break;
+	case DTV_ATSCMH_SCCC_CODE_MODE_C:
+		tvp->u.data = fe->dtv_property_cache.atscmh_sccc_code_mode_c;
+		break;
+	case DTV_ATSCMH_SCCC_CODE_MODE_D:
+		tvp->u.data = fe->dtv_property_cache.atscmh_sccc_code_mode_d;
+		break;
+	case DTV_ATSCMH_FIC_ERR:
+		tvp->u.data = fe->dtv_property_cache.atscmh_fic_err;
+		break;
+	case DTV_ATSCMH_CRC_ERR:
+		tvp->u.data = fe->dtv_property_cache.atscmh_crc_err;
+		break;
+	case DTV_ATSCMH_RS_ERR:
+		tvp->u.data = fe->dtv_property_cache.atscmh_rs_err;
+		break;
+
 	default:
 		return -EINVAL;
 	}
@@ -1682,6 +1763,15 @@ static int dtv_property_process_set(struct
dvb_frontend *fe,
 	case DTV_DVBT2_PLP_ID:
 		c->dvbt2_plp_id = tvp->u.data;
 		break;
+
+	/* ATSC-MH */
+	case DTV_ATSCMH_PARADE_ID:
+		fe->dtv_property_cache.atscmh_parade_id = tvp->u.data;
+		break;
+	case DTV_ATSCMH_RS_FRAME_ENSEMBLE:
+		fe->dtv_property_cache.atscmh_rs_frame_ensemble = tvp->u.data;
+		break;
+
 	default:
 		return -EINVAL;
 	}
diff --git a/drivers/media/dvb/dvb-core/dvb_frontend.h
b/drivers/media/dvb/dvb-core/dvb_frontend.h
index d63a821..80f5c27 100644
--- a/drivers/media/dvb/dvb-core/dvb_frontend.h
+++ b/drivers/media/dvb/dvb-core/dvb_frontend.h
@@ -372,6 +372,28 @@ struct dtv_frontend_properties {

 	/* DVB-T2 specifics */
 	u32                     dvbt2_plp_id;
+
+	/* ATSC-MH specifics */
+	u8			atscmh_fic_ver;
+	u8			atscmh_parade_id;
+	u8			atscmh_nog;
+	u8			atscmh_tnog;
+	u8			atscmh_sgn;
+	u8			atscmh_prc;
+
+	u8			atscmh_rs_frame_mode;
+	u8			atscmh_rs_frame_ensemble;
+	u8			atscmh_rs_code_mode_pri;
+	u8			atscmh_rs_code_mode_sec;
+	u8			atscmh_sccc_block_mode;
+	u8			atscmh_sccc_code_mode_a;
+	u8			atscmh_sccc_code_mode_b;
+	u8			atscmh_sccc_code_mode_c;
+	u8			atscmh_sccc_code_mode_d;
+
+	u16			atscmh_fic_err;
+	u16			atscmh_crc_err;
+	u16			atscmh_rs_err;
 };

 struct dvb_frontend {
diff --git a/include/linux/dvb/frontend.h b/include/linux/dvb/frontend.h
index cb4428a..5aedd5a 100644
--- a/include/linux/dvb/frontend.h
+++ b/include/linux/dvb/frontend.h
@@ -320,7 +320,27 @@ struct dvb_frontend_event {

 #define DTV_ENUM_DELSYS		44

-#define DTV_MAX_COMMAND				DTV_ENUM_DELSYS
+/* ATSC-MH */
+#define DTV_ATSCMH_FIC_VER		45
+#define DTV_ATSCMH_PARADE_ID		46
+#define DTV_ATSCMH_NOG			47
+#define DTV_ATSCMH_TNOG			48
+#define DTV_ATSCMH_SGN			49
+#define DTV_ATSCMH_PRC			50
+#define DTV_ATSCMH_RS_FRAME_MODE	51
+#define DTV_ATSCMH_RS_FRAME_ENSEMBLE	52
+#define DTV_ATSCMH_RS_CODE_MODE_PRI	53
+#define DTV_ATSCMH_RS_CODE_MODE_SEC	54
+#define DTV_ATSCMH_SCCC_BLOCK_MODE	55
+#define DTV_ATSCMH_SCCC_CODE_MODE_A	56
+#define DTV_ATSCMH_SCCC_CODE_MODE_B	57
+#define DTV_ATSCMH_SCCC_CODE_MODE_C	58
+#define DTV_ATSCMH_SCCC_CODE_MODE_D	59
+#define DTV_ATSCMH_FIC_ERR		60
+#define DTV_ATSCMH_CRC_ERR		61
+#define DTV_ATSCMH_RS_ERR		62
+
+#define DTV_MAX_COMMAND				DTV_ATSCMH_RS_ERR

 typedef enum fe_pilot {
 	PILOT_ON,
@@ -360,6 +380,38 @@ typedef enum fe_delivery_system {

 #define SYS_DVBC_ANNEX_AC	SYS_DVBC_ANNEX_A

+/* ATSC-MH */
+
+enum atscmh_sccc_block_mode {
+	ATSCMH_SCCC_BLK_SEP      = 0,
+	ATSCMH_SCCC_BLK_COMB     = 1,
+	ATSCMH_SCCC_BLK_RES      = 2,
+};
+
+enum atscmh_sccc_code_mode {
+	ATSCMH_SCCC_CODE_HLF     = 0,
+	ATSCMH_SCCC_CODE_QTR     = 1,
+	ATSCMH_SCCC_CODE_RES     = 2,
+};
+
+enum atscmh_rs_frame_ensemble {
+	ATSCMH_RSFRAME_ENS_PRI   = 0,
+	ATSCMH_RSFRAME_ENS_SEC   = 1,
+};
+
+enum atscmh_rs_frame_mode {
+	ATSCMH_RSFRAME_PRI_ONLY  = 0,
+	ATSCMH_RSFRAME_PRI_SEC   = 1,
+	ATSCMH_RSFRAME_RES       = 2,
+};
+
+enum atscmh_rs_code_mode {
+	ATSCMH_RSCODE_211_187    = 0,
+	ATSCMH_RSCODE_223_187    = 1,
+	ATSCMH_RSCODE_235_187    = 2,
+	ATSCMH_RSCODE_RES        = 3,
+};
+

 struct dtv_cmds_h {
 	char	*name;		/* A display name for debugging purposes */
-- 
1.7.5.4

>From 00db48640ebb884688aaff84f7d0d69bc5ab0026 Mon Sep 17 00:00:00 2001
From: Michael Krufky <mkrufky@linuxtv.org>
Date: Sun, 29 Apr 2012 11:59:46 -0400
Subject: [PATCH 2/3] DocBook: document new DTV Properties for ATSC-MH
 delivery system

Signed-off-by: Michael Krufky <mkrufky@linuxtv.org>
---
 Documentation/DocBook/media/dvb/dvbproperty.xml |  178 +++++++++++++++++++++++
 1 files changed, 178 insertions(+), 0 deletions(-)

diff --git a/Documentation/DocBook/media/dvb/dvbproperty.xml
b/Documentation/DocBook/media/dvb/dvbproperty.xml
index c7a4ca5..d631535 100644
--- a/Documentation/DocBook/media/dvb/dvbproperty.xml
+++ b/Documentation/DocBook/media/dvb/dvbproperty.xml
@@ -531,6 +531,154 @@ typedef enum fe_delivery_system {
 				here are referring to what can be found in the TMCC-structure -
 				independent of the mode.</para>
 		</section>
+		<section id="DTV-ATSCMH-FIC-VER">
+			<title><constant>DTV_ATSCMH_FIC_VER</constant></title>
+			<para>Version number of the FIC (Fast Information Channel)
signaling data.</para>
+			<para>FIC is used for relaying information to allow rapid service
acquisition by the receiver.</para>
+			<para>Possible values: 0, 1, 2, 3, ..., 30, 31</para>
+		</section>
+		<section id="DTV-ATSCMH-PARADE-ID">
+			<title><constant>DTV_ATSCMH_PARADE_ID</constant></title>
+			<para>Parade identification number</para>
+			<para>A parade is a collection of up to eight MH groups, conveying
one or two ensembles.</para>
+			<para>Possible values: 0, 1, 2, 3, ..., 126, 127</para>
+		</section>
+		<section id="DTV-ATSCMH-NOG">
+			<title><constant>DTV_ATSCMH_NOG</constant></title>
+			<para>Number of MH groups per MH subframe for a designated parade.</para>
+			<para>Possible values: 1, 2, 3, 4, 5, 6, 7, 8</para>
+		</section>
+		<section id="DTV-ATSCMH-TNOG">
+			<title><constant>DTV_ATSCMH_TNOG</constant></title>
+			<para>Total number of MH groups including all MH groups belonging
to all MH parades in one MH subframe.</para>
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
 				<listitem><para><link
linkend="DTV-BANDWIDTH-HZ"><constant>DTV_BANDWIDTH_HZ</constant></link></para></listitem>
 			</itemizedlist>
 		</section>
+		<section id="atscmh-params">
+			<title>ATSC-MH delivery system</title>
+			<para>The following parameters are valid for ATSC-MH:</para>
+			<itemizedlist mark='opencircle'>
+				<listitem><para><link
linkend="DTV-API-VERSION"><constant>DTV_API_VERSION</constant></link></para></listitem>
+				<listitem><para><link
linkend="DTV-DELIVERY-SYSTEM"><constant>DTV_DELIVERY_SYSTEM</constant></link></para></listitem>
+				<listitem><para><link
linkend="DTV-TUNE"><constant>DTV_TUNE</constant></link></para></listitem>
+				<listitem><para><link
linkend="DTV-CLEAR"><constant>DTV_CLEAR</constant></link></para></listitem>
+				<listitem><para><link
linkend="DTV-FREQUENCY"><constant>DTV_FREQUENCY</constant></link></para></listitem>
+				<listitem><para><link
linkend="DTV-BANDWIDTH-HZ"><constant>DTV_BANDWIDTH_HZ</constant></link></para></listitem>
+				<listitem><para><link
linkend="DTV-ATSCMH-FIC-VER"><constant>DTV_ATSCMH_FIC_VER</constant></link></para></listitem>
+				<listitem><para><link
linkend="DTV-ATSCMH-PARADE-ID"><constant>DTV_ATSCMH_PARADE_ID</constant></link></para></listitem>
+				<listitem><para><link
linkend="DTV-ATSCMH-NOG"><constant>DTV_ATSCMH_NOG</constant></link></para></listitem>
+				<listitem><para><link
linkend="DTV-ATSCMH-TNOG"><constant>DTV_ATSCMH_TNOG</constant></link></para></listitem>
+				<listitem><para><link
linkend="DTV-ATSCMH-SGN"><constant>DTV_ATSCMH_SGN</constant></link></para></listitem>
+				<listitem><para><link
linkend="DTV-ATSCMH-PRC"><constant>DTV_ATSCMH_PRC</constant></link></para></listitem>
+				<listitem><para><link
linkend="DTV-ATSCMH-RS-FRAME-MODE"><constant>DTV_ATSCMH_RS_FRAME_MODE</constant></link></para></listitem>
+				<listitem><para><link
linkend="DTV-ATSCMH-RS-FRAME-ENSEMBLE"><constant>DTV_ATSCMH_RS_FRAME_ENSEMBLE</constant></link></para></listitem>
+				<listitem><para><link
linkend="DTV-ATSCMH-CODE-MODE-PRI"><constant>DTV_ATSCMH_CODE_MODE_PRI</constant></link></para></listitem>
+				<listitem><para><link
linkend="DTV-ATSCMH-CODE-MODE-SEC"><constant>DTV_ATSCMH_CODE_MODE_SEC</constant></link></para></listitem>
+				<listitem><para><link
linkend="DTV-ATSCMH-SCCC-BLOCK-MODE"><constant>DTV_ATSCMH_SCCC_BLOCK_MODE</constant></link></para></listitem>
+				<listitem><para><link
linkend="DTV-ATSCMH-SCCC-CODE_MODE-A"><constant>DTV_ATSCMH_SCCC_CODE_MODE_A</constant></link></para></listitem>
+				<listitem><para><link
linkend="DTV-ATSCMH-SCCC-CODE_MODE-B"><constant>DTV_ATSCMH_SCCC_CODE_MODE_B</constant></link></para></listitem>
+				<listitem><para><link
linkend="DTV-ATSCMH-SCCC-CODE_MODE-C"><constant>DTV_ATSCMH_SCCC_CODE_MODE_C</constant></link></para></listitem>
+				<listitem><para><link
linkend="DTV-ATSCMH-SCCC-CODE_MODE-D"><constant>DTV_ATSCMH_SCCC_CODE_MODE_D</constant></link></para></listitem>
+				<listitem><para><link
linkend="DTV-ATSCMH-FIC-ERR"><constant>DTV_ATSCMH_FIC_ERR</constant></link></para></listitem>
+				<listitem><para><link
linkend="DTV-ATSCMH-CRC-ERR"><constant>DTV_ATSCMH_CRC_ERR</constant></link></para></listitem>
+				<listitem><para><link
linkend="DTV-ATSCMH-RS-ERR"><constant>DTV_ATSCMH_RS_ERR</constant></link></para></listitem>
+			</itemizedlist>
+		</section>
 	</section>
 	<section id="frontend-property-cable-systems">
 	<title>Properties used on cable delivery systems</title>
-- 
1.7.5.4

>From 4e35eb1485546d2134c046d547e89a67eda118ca Mon Sep 17 00:00:00 2001
From: Michael Krufky <mkrufky@linuxtv.org>
Date: Sun, 29 Apr 2012 12:06:16 -0400
Subject: [PATCH 3/3] increment DVB API to version 5.6 for ATSC-MH frontend
 control

Signed-off-by: Michael Krufky <mkrufky@linuxtv.org>
---
 include/linux/dvb/version.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/dvb/version.h b/include/linux/dvb/version.h
index 0559e2b..43d9e8d 100644
--- a/include/linux/dvb/version.h
+++ b/include/linux/dvb/version.h
@@ -24,6 +24,6 @@
 #define _DVBVERSION_H_

 #define DVB_API_VERSION 5
-#define DVB_API_VERSION_MINOR 5
+#define DVB_API_VERSION_MINOR 6

 #endif /*_DVBVERSION_H_*/
-- 
1.7.5.4
