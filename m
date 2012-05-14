Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qa0-f46.google.com ([209.85.216.46]:55766 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932526Ab2ENWLb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 May 2012 18:11:31 -0400
Received: by mail-qa0-f46.google.com with SMTP id b17so3179695qad.19
        for <linux-media@vger.kernel.org>; Mon, 14 May 2012 15:11:30 -0700 (PDT)
From: Michael Krufky <mkrufky@kernellabs.com>
To: linux-media@vger.kernel.org
Cc: mchehab@infradead.org, Michael Krufky <mkrufky@linuxtv.org>
Subject: [PATCH 11/11] DVB: remove "stats" property bits from ATSC-MH API property additions
Date: Mon, 14 May 2012 18:10:53 -0400
Message-Id: <1337033453-22119-11-git-send-email-mkrufky@linuxtv.org>
In-Reply-To: <1337033453-22119-1-git-send-email-mkrufky@linuxtv.org>
References: <1337033453-22119-1-git-send-email-mkrufky@linuxtv.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mauro is proposing a new API to handle statistics. This functionality will
be returned after the statistics API is ready. Just remove them for now.

Signed-off-by: Michael Krufky <mkrufky@linuxtv.org>
---
 Documentation/DocBook/media/dvb/dvbproperty.xml |   18 ------------------
 drivers/media/dvb/dvb-core/dvb_frontend.c       |   12 ------------
 drivers/media/dvb/dvb-core/dvb_frontend.h       |    4 ----
 drivers/media/dvb/frontends/lg2160.c            |    9 ++++++++-
 include/linux/dvb/frontend.h                    |    5 +----
 5 files changed, 9 insertions(+), 39 deletions(-)

diff --git a/Documentation/DocBook/media/dvb/dvbproperty.xml b/Documentation/DocBook/media/dvb/dvbproperty.xml
index d631535..e633c09 100644
--- a/Documentation/DocBook/media/dvb/dvbproperty.xml
+++ b/Documentation/DocBook/media/dvb/dvbproperty.xml
@@ -664,21 +664,6 @@ typedef enum atscmh_sccc_code_mode {
 } atscmh_sccc_code_mode_t;
 </programlisting>
 		</section>
-		<section id="DTV-ATSCMH-FIC-ERR">
-			<title><constant>DTV_ATSCMH_FIC_ERR</constant></title>
-			<para>FIC error count.</para>
-			<para>Possible values: 0, 1, 2, 3, ..., 0xffff</para>
-		</section>
-		<section id="DTV-ATSCMH-CRC-ERR">
-			<title><constant>DTV_ATSCMH_CRC_ERR</constant></title>
-			<para>CRC error count.</para>
-			<para>Possible values: 0, 1, 2, 3, ..., 0xffff</para>
-		</section>
-		<section id="DTV-ATSCMH-RS-ERR">
-			<title><constant>DTV_ATSCMH_RS_ERR</constant></title>
-			<para>RS error count.</para>
-			<para>Possible values: 0, 1, 2, 3, ..., 0xffff</para>
-		</section>
 	</section>
 	<section id="DTV-API-VERSION">
 	<title><constant>DTV_API_VERSION</constant></title>
@@ -947,9 +932,6 @@ typedef enum fe_hierarchy {
 				<listitem><para><link linkend="DTV-ATSCMH-SCCC-CODE_MODE-B"><constant>DTV_ATSCMH_SCCC_CODE_MODE_B</constant></link></para></listitem>
 				<listitem><para><link linkend="DTV-ATSCMH-SCCC-CODE_MODE-C"><constant>DTV_ATSCMH_SCCC_CODE_MODE_C</constant></link></para></listitem>
 				<listitem><para><link linkend="DTV-ATSCMH-SCCC-CODE_MODE-D"><constant>DTV_ATSCMH_SCCC_CODE_MODE_D</constant></link></para></listitem>
-				<listitem><para><link linkend="DTV-ATSCMH-FIC-ERR"><constant>DTV_ATSCMH_FIC_ERR</constant></link></para></listitem>
-				<listitem><para><link linkend="DTV-ATSCMH-CRC-ERR"><constant>DTV_ATSCMH_CRC_ERR</constant></link></para></listitem>
-				<listitem><para><link linkend="DTV-ATSCMH-RS-ERR"><constant>DTV_ATSCMH_RS_ERR</constant></link></para></listitem>
 			</itemizedlist>
 		</section>
 	</section>
diff --git a/drivers/media/dvb/dvb-core/dvb_frontend.c b/drivers/media/dvb/dvb-core/dvb_frontend.c
index 067f10a..d12caa5 100644
--- a/drivers/media/dvb/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb/dvb-core/dvb_frontend.c
@@ -1046,9 +1046,6 @@ static struct dtv_cmds_h dtv_cmds[DTV_MAX_COMMAND + 1] = {
 	_DTV_CMD(DTV_ATSCMH_SCCC_CODE_MODE_B, 0, 0),
 	_DTV_CMD(DTV_ATSCMH_SCCC_CODE_MODE_C, 0, 0),
 	_DTV_CMD(DTV_ATSCMH_SCCC_CODE_MODE_D, 0, 0),
-	_DTV_CMD(DTV_ATSCMH_FIC_ERR, 0, 0),
-	_DTV_CMD(DTV_ATSCMH_CRC_ERR, 0, 0),
-	_DTV_CMD(DTV_ATSCMH_RS_ERR, 0, 0),
 };
 
 static void dtv_property_dump(struct dtv_property *tvp)
@@ -1435,15 +1432,6 @@ static int dtv_property_process_get(struct dvb_frontend *fe,
 	case DTV_ATSCMH_SCCC_CODE_MODE_D:
 		tvp->u.data = fe->dtv_property_cache.atscmh_sccc_code_mode_d;
 		break;
-	case DTV_ATSCMH_FIC_ERR:
-		tvp->u.data = fe->dtv_property_cache.atscmh_fic_err;
-		break;
-	case DTV_ATSCMH_CRC_ERR:
-		tvp->u.data = fe->dtv_property_cache.atscmh_crc_err;
-		break;
-	case DTV_ATSCMH_RS_ERR:
-		tvp->u.data = fe->dtv_property_cache.atscmh_rs_err;
-		break;
 
 	default:
 		return -EINVAL;
diff --git a/drivers/media/dvb/dvb-core/dvb_frontend.h b/drivers/media/dvb/dvb-core/dvb_frontend.h
index 80f5c27..e929d56 100644
--- a/drivers/media/dvb/dvb-core/dvb_frontend.h
+++ b/drivers/media/dvb/dvb-core/dvb_frontend.h
@@ -390,10 +390,6 @@ struct dtv_frontend_properties {
 	u8			atscmh_sccc_code_mode_b;
 	u8			atscmh_sccc_code_mode_c;
 	u8			atscmh_sccc_code_mode_d;
-
-	u16			atscmh_fic_err;
-	u16			atscmh_crc_err;
-	u16			atscmh_rs_err;
 };
 
 struct dvb_frontend {
diff --git a/drivers/media/dvb/frontends/lg2160.c b/drivers/media/dvb/frontends/lg2160.c
index daa8596..b7e6085 100644
--- a/drivers/media/dvb/frontends/lg2160.c
+++ b/drivers/media/dvb/frontends/lg2160.c
@@ -804,6 +804,7 @@ fail:
 
 /* ------------------------------------------------------------------------ */
 
+#if 0
 static int lg216x_read_fic_err_count(struct lg216x_state *state, u8 *err)
 {
 	u8 fic_err;
@@ -936,6 +937,7 @@ static int lg216x_read_rs_err_count(struct lg216x_state *state, u16 *err)
 	}
 	return ret;
 }
+#endif
 
 /* ------------------------------------------------------------------------ */
 
@@ -1016,6 +1018,7 @@ static int lg216x_get_frontend(struct dvb_frontend *fe)
 		if (lg_fail(ret))
 			goto fail;
 	}
+#if 0
 	ret = lg216x_read_fic_err_count(state,
 				(u8 *)&fe->dtv_property_cache.atscmh_fic_err);
 	if (lg_fail(ret))
@@ -1042,6 +1045,7 @@ static int lg216x_get_frontend(struct dvb_frontend *fe)
 		break;
 	}
 	lg_fail(ret);
+#endif
 fail:
 	return ret;
 }
@@ -1319,13 +1323,16 @@ static int lg216x_read_ucblocks(struct dvb_frontend *fe, u32 *ucblocks)
 {
 	struct lg216x_state *state = fe->demodulator_priv;
 	int ret;
-
+#if 0
 	ret = lg216x_read_rs_err_count(state,
 				       &fe->dtv_property_cache.atscmh_rs_err);
 	if (lg_fail(ret))
 		goto fail;
 
 	*ucblocks = fe->dtv_property_cache.atscmh_rs_err;
+#else
+	*ucblocks = 0;
+#endif
 fail:
 	return 0;
 }
diff --git a/include/linux/dvb/frontend.h b/include/linux/dvb/frontend.h
index 5aedd5a..f50d405 100644
--- a/include/linux/dvb/frontend.h
+++ b/include/linux/dvb/frontend.h
@@ -336,11 +336,8 @@ struct dvb_frontend_event {
 #define DTV_ATSCMH_SCCC_CODE_MODE_B	57
 #define DTV_ATSCMH_SCCC_CODE_MODE_C	58
 #define DTV_ATSCMH_SCCC_CODE_MODE_D	59
-#define DTV_ATSCMH_FIC_ERR		60
-#define DTV_ATSCMH_CRC_ERR		61
-#define DTV_ATSCMH_RS_ERR		62
 
-#define DTV_MAX_COMMAND				DTV_ATSCMH_RS_ERR
+#define DTV_MAX_COMMAND				DTV_ATSCMH_SCCC_CODE_MODE_D
 
 typedef enum fe_pilot {
 	PILOT_ON,
-- 
1.7.9.5

