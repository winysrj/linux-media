Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:46280 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753501AbaJ1PA7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 28 Oct 2014 11:00:59 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Michael Ira Krufky <mkrufky@linuxtv.org>,
	Fred Richter <frichter@hauppauge.com>
Subject: [PATCH 05/13] [media] lgdt3306a: properly handle I/O errors
Date: Tue, 28 Oct 2014 13:00:40 -0200
Message-Id: <ef1e811ff763318d1f8afdae6c098e6dc4527919.1414507927.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1414507927.git.mchehab@osg.samsung.com>
References: <cover.1414507927.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1414507927.git.mchehab@osg.samsung.com>
References: <cover.1414507927.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fixes the following smatch errors:

drivers/media/dvb-frontends/lgdt3306a.c: In function 'lgdt3306a_set_if':
drivers/media/dvb-frontends/lgdt3306a.c:695:6: warning: variable 'ret' set but not used [-Wunused-but-set-variable]
  int ret;
      ^
drivers/media/dvb-frontends/lgdt3306a.c: In function 'lgdt3306a_monitor_vsb':
drivers/media/dvb-frontends/lgdt3306a.c:1033:6: warning: variable 'ret' set but not used [-Wunused-but-set-variable]
  int ret;
      ^
drivers/media/dvb-frontends/lgdt3306a.c: In function 'lgdt3306a_check_oper_mode':
drivers/media/dvb-frontends/lgdt3306a.c:1082:6: warning: variable 'ret' set but not used [-Wunused-but-set-variable]
  int ret;
      ^
drivers/media/dvb-frontends/lgdt3306a.c: In function 'lgdt3306a_check_lock_status':
drivers/media/dvb-frontends/lgdt3306a.c:1109:6: warning: variable 'ret' set but not used [-Wunused-but-set-variable]
  int ret;
      ^
drivers/media/dvb-frontends/lgdt3306a.c: In function 'lgdt3306a_check_neverlock_status':
drivers/media/dvb-frontends/lgdt3306a.c:1185:6: warning: variable 'ret' set but not used [-Wunused-but-set-variable]
  int ret;
      ^
drivers/media/dvb-frontends/lgdt3306a.c: In function 'lgdt3306a_pre_monitoring':
drivers/media/dvb-frontends/lgdt3306a.c:1199:6: warning: variable 'ret' set but not used [-Wunused-but-set-variable]
  int ret;
      ^
drivers/media/dvb-frontends/lgdt3306a.c: In function 'lgdt3306a_get_packet_error':
drivers/media/dvb-frontends/lgdt3306a.c:1310:6: warning: variable 'ret' set but not used [-Wunused-but-set-variable]
  int ret;
      ^

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/dvb-frontends/lgdt3306a.c b/drivers/media/dvb-frontends/lgdt3306a.c
index 92affe124a8d..d1a914de4180 100644
--- a/drivers/media/dvb-frontends/lgdt3306a.c
+++ b/drivers/media/dvb-frontends/lgdt3306a.c
@@ -734,7 +734,11 @@ static int lgdt3306a_set_if(struct lgdt3306a_state *state,
 		break;
 	}
 	ret = lgdt3306a_write_reg(state, 0x0010, nco1);
+	if (ret)
+		return ret;
 	ret = lgdt3306a_write_reg(state, 0x0011, nco2);
+	if (ret)
+		return ret;
 
 	lg_dbg("if_freq=%d KHz->[%04x]\n", if_freq_khz, nco1<<8 | nco2);
 
@@ -1027,7 +1031,7 @@ static enum dvbfe_algo lgdt3306a_get_frontend_algo(struct dvb_frontend *fe)
 }
 
 /* ------------------------------------------------------------------------ */
-static void lgdt3306a_monitor_vsb(struct lgdt3306a_state *state)
+static int lgdt3306a_monitor_vsb(struct lgdt3306a_state *state)
 {
 	u8 val;
 	int ret;
@@ -1035,16 +1039,27 @@ static void lgdt3306a_monitor_vsb(struct lgdt3306a_state *state)
 	u16 fbDlyCir;
 
 	ret = lgdt3306a_read_reg(state, 0x21a1, &val);
+	if (ret)
+		return ret;
 	snrRef = val & 0x3f;
 
 	ret = lgdt3306a_read_reg(state, 0x2185, &maxPowerMan);
+	if (ret)
+		return ret;
 
 	ret = lgdt3306a_read_reg(state, 0x2191, &val);
+	if (ret)
+		return ret;
 	nCombDet = (val & 0x80) >> 7;
 
 	ret = lgdt3306a_read_reg(state, 0x2180, &val);
+	if (ret)
+		return ret;
 	fbDlyCir = (val & 0x03) << 8;
+
 	ret = lgdt3306a_read_reg(state, 0x2181, &val);
+	if (ret)
+		return ret;
 	fbDlyCir |= val;
 
 	lg_dbg("snrRef=%d maxPowerMan=0x%x nCombDet=%d fbDlyCir=0x%x\n",
@@ -1052,6 +1067,8 @@ static void lgdt3306a_monitor_vsb(struct lgdt3306a_state *state)
 
 	/* Carrier offset sub loop bandwidth */
 	ret = lgdt3306a_read_reg(state, 0x1061, &val);
+	if (ret)
+		return ret;
 	val &= 0xf8;
 	if ((snrRef > 18) && (maxPowerMan > 0x68) && (nCombDet == 0x01) && ((fbDlyCir == 0x03FF) || (fbDlyCir < 0x6C)))	{
 		/* SNR is over 18dB and no ghosting */
@@ -1060,20 +1077,30 @@ static void lgdt3306a_monitor_vsb(struct lgdt3306a_state *state)
 		val |= 0x04; /* final bandwidth = 4 */
 	}
 	ret = lgdt3306a_write_reg(state, 0x1061, val);
+	if (ret)
+		return ret;
 
 	/* Adjust Notch Filter */
 	ret = lgdt3306a_read_reg(state, 0x0024, &val);
+	if (ret)
+		return ret;
 	val &= 0x0f;
 	if (nCombDet == 0) { /* Turn on the Notch Filter */
 		val |= 0x50;
 	}
 	ret = lgdt3306a_write_reg(state, 0x0024, val);
+	if (ret)
+		return ret;
 
 	/* VSB Timing Recovery output normalization */
 	ret = lgdt3306a_read_reg(state, 0x103d, &val);
+	if (ret)
+		return ret;
 	val &= 0xcf;
 	val |= 0x20;
 	ret = lgdt3306a_write_reg(state, 0x103d, val);
+
+	return ret;
 }
 
 static enum lgdt3306a_modulation lgdt3306a_check_oper_mode(struct lgdt3306a_state *state)
@@ -1082,6 +1109,8 @@ static enum lgdt3306a_modulation lgdt3306a_check_oper_mode(struct lgdt3306a_stat
 	int ret;
 
 	ret = lgdt3306a_read_reg(state, 0x0081, &val);
+	if (ret)
+		goto err;
 
 	if (val & 0x80)	{
 		lg_dbg("VSB\n");
@@ -1089,6 +1118,8 @@ static enum lgdt3306a_modulation lgdt3306a_check_oper_mode(struct lgdt3306a_stat
 	}
 	if (val & 0x08) {
 		ret = lgdt3306a_read_reg(state, 0x00a6, &val);
+		if (ret)
+			goto err;
 		val = val >> 2;
 		if (val & 0x01) {
 			lg_dbg("QAM256\n");
@@ -1098,6 +1129,7 @@ static enum lgdt3306a_modulation lgdt3306a_check_oper_mode(struct lgdt3306a_stat
 			return LG3306_QAM64;
 		}
 	}
+err:
 	lg_warn("UNKNOWN\n");
 	return LG3306_UNKNOWN_MODE;
 }
@@ -1116,6 +1148,8 @@ static enum lgdt3306a_lock_status lgdt3306a_check_lock_status(struct lgdt3306a_s
 	case LG3306_SYNC_LOCK:
 	{
 		ret = lgdt3306a_read_reg(state, 0x00a6, &val);
+		if (ret)
+			return ret;
 
 		if ((val & 0x80) == 0x80)
 			lockStatus = LG3306_LOCK;
@@ -1128,6 +1162,8 @@ static enum lgdt3306a_lock_status lgdt3306a_check_lock_status(struct lgdt3306a_s
 	case LG3306_AGC_LOCK:
 	{
 		ret = lgdt3306a_read_reg(state, 0x0080, &val);
+		if (ret)
+			return ret;
 
 		if ((val & 0x40) == 0x40)
 			lockStatus = LG3306_LOCK;
@@ -1142,6 +1178,8 @@ static enum lgdt3306a_lock_status lgdt3306a_check_lock_status(struct lgdt3306a_s
 		modeOper = lgdt3306a_check_oper_mode(state);
 		if ((modeOper == LG3306_QAM64) || (modeOper == LG3306_QAM256)) {
 			ret = lgdt3306a_read_reg(state, 0x1094, &val);
+			if (ret)
+				return ret;
 
 			if ((val & 0x80) == 0x80)
 				lockStatus = LG3306_LOCK;
@@ -1158,6 +1196,8 @@ static enum lgdt3306a_lock_status lgdt3306a_check_lock_status(struct lgdt3306a_s
 		modeOper = lgdt3306a_check_oper_mode(state);
 		if ((modeOper == LG3306_QAM64) || (modeOper == LG3306_QAM256)) {
 			ret = lgdt3306a_read_reg(state, 0x0080, &val);
+			if (ret)
+				return ret;
 
 			if ((val & 0x10) == 0x10)
 				lockStatus = LG3306_LOCK;
@@ -1186,6 +1226,8 @@ static enum lgdt3306a_neverlock_status lgdt3306a_check_neverlock_status(struct l
 	enum lgdt3306a_neverlock_status lockStatus;
 
 	ret = lgdt3306a_read_reg(state, 0x0080, &val);
+	if (ret)
+		return ret;
 	lockStatus = (enum lgdt3306a_neverlock_status)(val & 0x03);
 
 	lg_dbg("NeverLock=%d", lockStatus);
@@ -1193,7 +1235,7 @@ static enum lgdt3306a_neverlock_status lgdt3306a_check_neverlock_status(struct l
 	return lockStatus;
 }
 
-static void lgdt3306a_pre_monitoring(struct lgdt3306a_state *state)
+static int lgdt3306a_pre_monitoring(struct lgdt3306a_state *state)
 {
 	u8 val = 0;
 	int ret;
@@ -1201,16 +1243,24 @@ static void lgdt3306a_pre_monitoring(struct lgdt3306a_state *state)
 
 	/* Channel variation */
 	ret = lgdt3306a_read_reg(state, 0x21bc, &currChDiffACQ);
+	if (ret)
+		return ret;
 
 	/* SNR of Frame sync */
 	ret = lgdt3306a_read_reg(state, 0x21a1, &val);
+	if (ret)
+		return ret;
 	snrRef = val & 0x3f;
 
 	/* Strong Main CIR */
 	ret = lgdt3306a_read_reg(state, 0x2199, &val);
+	if (ret)
+		return ret;
 	mainStrong = (val & 0x40) >> 6;
 
 	ret = lgdt3306a_read_reg(state, 0x0090, &val);
+	if (ret)
+		return ret;
 	aiccrejStatus = (val & 0xf0) >> 4;
 
 	lg_dbg("snrRef=%d mainStrong=%d aiccrejStatus=%d currChDiffACQ=0x%x\n",
@@ -1221,30 +1271,50 @@ static void lgdt3306a_pre_monitoring(struct lgdt3306a_state *state)
 #endif
 	if (mainStrong == 0) {
 		ret = lgdt3306a_read_reg(state, 0x2135, &val);
+		if (ret)
+			return ret;
 		val &= 0x0f;
 		val |= 0xa0;
 		ret = lgdt3306a_write_reg(state, 0x2135, val);
+		if (ret)
+			return ret;
 
 		ret = lgdt3306a_read_reg(state, 0x2141, &val);
+		if (ret)
+			return ret;
 		val &= 0x3f;
 		val |= 0x80;
 		ret = lgdt3306a_write_reg(state, 0x2141, val);
+		if (ret)
+			return ret;
 
 		ret = lgdt3306a_write_reg(state, 0x2122, 0x70);
+		if (ret)
+			return ret;
 	} else { /* Weak ghost or static channel */
 		ret = lgdt3306a_read_reg(state, 0x2135, &val);
+		if (ret)
+			return ret;
 		val &= 0x0f;
 		val |= 0x70;
 		ret = lgdt3306a_write_reg(state, 0x2135, val);
+		if (ret)
+			return ret;
 
 		ret = lgdt3306a_read_reg(state, 0x2141, &val);
+		if (ret)
+			return ret;
 		val &= 0x3f;
 		val |= 0x40;
 		ret = lgdt3306a_write_reg(state, 0x2141, val);
+		if (ret)
+			return ret;
 
 		ret = lgdt3306a_write_reg(state, 0x2122, 0x40);
+		if (ret)
+			return ret;
 	}
-
+	return 0;
 }
 
 static enum lgdt3306a_lock_status lgdt3306a_sync_lock_poll(struct lgdt3306a_state *state)
@@ -1310,6 +1380,8 @@ static u8 lgdt3306a_get_packet_error(struct lgdt3306a_state *state)
 	int ret;
 
 	ret = lgdt3306a_read_reg(state, 0x00fa, &val);
+	if (ret)
+		return ret;
 
 	return val;
 }
@@ -1393,7 +1465,9 @@ static enum lgdt3306a_lock_status lgdt3306a_vsb_lock_poll(struct lgdt3306a_state
 			return LG3306_UNLOCK;
 		} else {
 			msleep(20);
-			lgdt3306a_pre_monitoring(state);
+			ret = lgdt3306a_pre_monitoring(state);
+			if (ret)
+				return LG3306_UNLOCK;
 
 			packet_error = lgdt3306a_get_packet_error(state);
 			snr = lgdt3306a_calculate_snr_x100(state);
@@ -1483,7 +1557,7 @@ static int lgdt3306a_read_status(struct dvb_frontend *fe, fe_status_t *status)
 
 				*status |= FE_HAS_LOCK;
 
-				lgdt3306a_monitor_vsb(state);
+				ret = lgdt3306a_monitor_vsb(state);
 			}
 			break;
 		default:
-- 
1.9.3

