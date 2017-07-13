Return-path: <linux-media-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:38125 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751050AbdGMLoH (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 13 Jul 2017 07:44:07 -0400
From: Colin King <colin.king@canonical.com>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Max Kellermann <max.kellermann@gmail.com>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-media@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [media] drxj: make several const arrays static
Date: Thu, 13 Jul 2017 12:44:03 +0100
Message-Id: <20170713114403.32168-1-colin.king@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Colin Ian King <colin.king@canonical.com>

Don't populate const arrays on the stack but instead make them static.
Makes the object code smaller by over 1800 bytes:

Before:
   text	   data	    bss	    dec	    hex	filename
  94100	   9160	      0	 103260	  1935c	drxj.o

After:
   text	   data	    bss	    dec	    hex	filename
  91044	  10400	      0	 101444	  18c44	drxj.o

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/media/dvb-frontends/drx39xyj/drxj.c | 35 +++++++++++++++--------------
 1 file changed, 18 insertions(+), 17 deletions(-)

diff --git a/drivers/media/dvb-frontends/drx39xyj/drxj.c b/drivers/media/dvb-frontends/drx39xyj/drxj.c
index 14040c915dbb..499ccff557bf 100644
--- a/drivers/media/dvb-frontends/drx39xyj/drxj.c
+++ b/drivers/media/dvb-frontends/drx39xyj/drxj.c
@@ -5489,7 +5489,7 @@ static int set_vsb_leak_n_gain(struct drx_demod_instance *demod)
 	struct i2c_device_addr *dev_addr = NULL;
 	int rc;
 
-	const u8 vsb_ffe_leak_gain_ram0[] = {
+	static const u8 vsb_ffe_leak_gain_ram0[] = {
 		DRXJ_16TO8(0x8),	/* FFETRAINLKRATIO1  */
 		DRXJ_16TO8(0x8),	/* FFETRAINLKRATIO2  */
 		DRXJ_16TO8(0x8),	/* FFETRAINLKRATIO3  */
@@ -5620,7 +5620,7 @@ static int set_vsb_leak_n_gain(struct drx_demod_instance *demod)
 		DRXJ_16TO8(0x1010)	/* FIRRCA1GAIN8 */
 	};
 
-	const u8 vsb_ffe_leak_gain_ram1[] = {
+	static const u8 vsb_ffe_leak_gain_ram1[] = {
 		DRXJ_16TO8(0x1010),	/* FIRRCA1GAIN9 */
 		DRXJ_16TO8(0x0808),	/* FIRRCA1GAIN10 */
 		DRXJ_16TO8(0x0808),	/* FIRRCA1GAIN11 */
@@ -5710,7 +5710,7 @@ static int set_vsb(struct drx_demod_instance *demod)
 	struct drxj_data *ext_attr = NULL;
 	u16 cmd_result = 0;
 	u16 cmd_param = 0;
-	const u8 vsb_taps_re[] = {
+	static const u8 vsb_taps_re[] = {
 		DRXJ_16TO8(-2),	/* re0  */
 		DRXJ_16TO8(4),	/* re1  */
 		DRXJ_16TO8(1),	/* re2  */
@@ -6666,7 +6666,7 @@ static int set_qam16(struct drx_demod_instance *demod)
 {
 	struct i2c_device_addr *dev_addr = demod->my_i2c_dev_addr;
 	int rc;
-	const u8 qam_dq_qual_fun[] = {
+	static const u8 qam_dq_qual_fun[] = {
 		DRXJ_16TO8(2),	/* fun0  */
 		DRXJ_16TO8(2),	/* fun1  */
 		DRXJ_16TO8(2),	/* fun2  */
@@ -6674,7 +6674,7 @@ static int set_qam16(struct drx_demod_instance *demod)
 		DRXJ_16TO8(3),	/* fun4  */
 		DRXJ_16TO8(3),	/* fun5  */
 	};
-	const u8 qam_eq_cma_rad[] = {
+	static const u8 qam_eq_cma_rad[] = {
 		DRXJ_16TO8(13517),	/* RAD0  */
 		DRXJ_16TO8(13517),	/* RAD1  */
 		DRXJ_16TO8(13517),	/* RAD2  */
@@ -6901,7 +6901,7 @@ static int set_qam32(struct drx_demod_instance *demod)
 {
 	struct i2c_device_addr *dev_addr = demod->my_i2c_dev_addr;
 	int rc;
-	const u8 qam_dq_qual_fun[] = {
+	static const u8 qam_dq_qual_fun[] = {
 		DRXJ_16TO8(3),	/* fun0  */
 		DRXJ_16TO8(3),	/* fun1  */
 		DRXJ_16TO8(3),	/* fun2  */
@@ -6909,7 +6909,7 @@ static int set_qam32(struct drx_demod_instance *demod)
 		DRXJ_16TO8(4),	/* fun4  */
 		DRXJ_16TO8(4),	/* fun5  */
 	};
-	const u8 qam_eq_cma_rad[] = {
+	static const u8 qam_eq_cma_rad[] = {
 		DRXJ_16TO8(6707),	/* RAD0  */
 		DRXJ_16TO8(6707),	/* RAD1  */
 		DRXJ_16TO8(6707),	/* RAD2  */
@@ -7136,7 +7136,8 @@ static int set_qam64(struct drx_demod_instance *demod)
 {
 	struct i2c_device_addr *dev_addr = demod->my_i2c_dev_addr;
 	int rc;
-	const u8 qam_dq_qual_fun[] = {	/* this is hw reset value. no necessary to re-write */
+	static const u8 qam_dq_qual_fun[] = {
+		/* this is hw reset value. no necessary to re-write */
 		DRXJ_16TO8(4),	/* fun0  */
 		DRXJ_16TO8(4),	/* fun1  */
 		DRXJ_16TO8(4),	/* fun2  */
@@ -7144,7 +7145,7 @@ static int set_qam64(struct drx_demod_instance *demod)
 		DRXJ_16TO8(6),	/* fun4  */
 		DRXJ_16TO8(6),	/* fun5  */
 	};
-	const u8 qam_eq_cma_rad[] = {
+	static const u8 qam_eq_cma_rad[] = {
 		DRXJ_16TO8(13336),	/* RAD0  */
 		DRXJ_16TO8(12618),	/* RAD1  */
 		DRXJ_16TO8(11988),	/* RAD2  */
@@ -7371,7 +7372,7 @@ static int set_qam128(struct drx_demod_instance *demod)
 {
 	struct i2c_device_addr *dev_addr = demod->my_i2c_dev_addr;
 	int rc;
-	const u8 qam_dq_qual_fun[] = {
+	static const u8 qam_dq_qual_fun[] = {
 		DRXJ_16TO8(6),	/* fun0  */
 		DRXJ_16TO8(6),	/* fun1  */
 		DRXJ_16TO8(6),	/* fun2  */
@@ -7379,7 +7380,7 @@ static int set_qam128(struct drx_demod_instance *demod)
 		DRXJ_16TO8(9),	/* fun4  */
 		DRXJ_16TO8(9),	/* fun5  */
 	};
-	const u8 qam_eq_cma_rad[] = {
+	static const u8 qam_eq_cma_rad[] = {
 		DRXJ_16TO8(6164),	/* RAD0  */
 		DRXJ_16TO8(6598),	/* RAD1  */
 		DRXJ_16TO8(6394),	/* RAD2  */
@@ -7606,7 +7607,7 @@ static int set_qam256(struct drx_demod_instance *demod)
 {
 	struct i2c_device_addr *dev_addr = demod->my_i2c_dev_addr;
 	int rc;
-	const u8 qam_dq_qual_fun[] = {
+	static const u8 qam_dq_qual_fun[] = {
 		DRXJ_16TO8(8),	/* fun0  */
 		DRXJ_16TO8(8),	/* fun1  */
 		DRXJ_16TO8(8),	/* fun2  */
@@ -7614,7 +7615,7 @@ static int set_qam256(struct drx_demod_instance *demod)
 		DRXJ_16TO8(12),	/* fun4  */
 		DRXJ_16TO8(12),	/* fun5  */
 	};
-	const u8 qam_eq_cma_rad[] = {
+	static const u8 qam_eq_cma_rad[] = {
 		DRXJ_16TO8(12345),	/* RAD0  */
 		DRXJ_16TO8(12345),	/* RAD1  */
 		DRXJ_16TO8(13626),	/* RAD2  */
@@ -7862,7 +7863,7 @@ set_qam(struct drx_demod_instance *demod,
 		/* parameter    */ NULL,
 		/* result       */ NULL
 	};
-	const u8 qam_a_taps[] = {
+	static const u8 qam_a_taps[] = {
 		DRXJ_16TO8(-1),	/* re0  */
 		DRXJ_16TO8(1),	/* re1  */
 		DRXJ_16TO8(1),	/* re2  */
@@ -7892,7 +7893,7 @@ set_qam(struct drx_demod_instance *demod,
 		DRXJ_16TO8(-40),	/* re26 */
 		DRXJ_16TO8(619)	/* re27 */
 	};
-	const u8 qam_b64_taps[] = {
+	static const u8 qam_b64_taps[] = {
 		DRXJ_16TO8(0),	/* re0  */
 		DRXJ_16TO8(-2),	/* re1  */
 		DRXJ_16TO8(1),	/* re2  */
@@ -7922,7 +7923,7 @@ set_qam(struct drx_demod_instance *demod,
 		DRXJ_16TO8(-46),	/* re26 */
 		DRXJ_16TO8(614)	/* re27 */
 	};
-	const u8 qam_b256_taps[] = {
+	static const u8 qam_b256_taps[] = {
 		DRXJ_16TO8(-2),	/* re0  */
 		DRXJ_16TO8(4),	/* re1  */
 		DRXJ_16TO8(1),	/* re2  */
@@ -7952,7 +7953,7 @@ set_qam(struct drx_demod_instance *demod,
 		DRXJ_16TO8(-32),	/* re26 */
 		DRXJ_16TO8(628)	/* re27 */
 	};
-	const u8 qam_c_taps[] = {
+	static const u8 qam_c_taps[] = {
 		DRXJ_16TO8(-3),	/* re0  */
 		DRXJ_16TO8(3),	/* re1  */
 		DRXJ_16TO8(2),	/* re2  */
-- 
2.11.0
