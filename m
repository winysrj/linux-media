Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from fg-out-1718.google.com ([72.14.220.152])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <e9hack@googlemail.com>) id 1Jukj6-00083F-DZ
	for linux-dvb@linuxtv.org; Sat, 10 May 2008 10:46:45 +0200
Received: by fg-out-1718.google.com with SMTP id e21so1149514fga.25
	for <linux-dvb@linuxtv.org>; Sat, 10 May 2008 01:46:41 -0700 (PDT)
Message-ID: <482560EB.2000306@gmail.com>
Date: Sat, 10 May 2008 10:46:35 +0200
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Content-Type: multipart/mixed; boundary="------------020308070600080405080201"
From: e9hack <e9hack@googlemail.com>
Subject: [linux-dvb] [PATCH] Fix the unc for the frontends tda10021 and
	stv0297
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

This is a multi-part message in MIME format.
--------------020308070600080405080201
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

the uncorrected block count is reset on a read request for the tda10021 and stv0297. This 
makes the UNC value of the femon plugin useless. The attached patch will fix this issue. 
It is simple for the stv0297. For the tda10021, the uncorrected block count must be read 
cyclical, because the resolution of the counter is very low. This can be done within 
tda10021_read_status. The read-status-function is called cyclical from the frontend-thread.

Some other frontends have the same problem (tda10023, ves1820, ves1x93, ...).

-Hartmut




--------------020308070600080405080201
Content-Type: text/x-diff;
 name="tda10021-unc-fix.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="tda10021-unc-fix.diff"

signed-off-by: Hartmut Birr <e9hack@gmail.com>
- The uncorrected block counter shouldn't be reset on read. The tda10021 contains 
  an uncorrected block counter, which has only a resoltion of 7 bits and 
  which isn't able wrap to zero. The driver must manage the block counter by itself. 
diff -r 4c4fd6b8755c linux/drivers/media/dvb/frontends/tda10021.c
--- a/linux/drivers/media/dvb/frontends/tda10021.c	Fri May 02 07:51:27 2008 -0300
+++ b/linux/drivers/media/dvb/frontends/tda10021.c	Sat May 03 18:55:09 2008 +0200
@@ -41,6 +41,8 @@ struct tda10021_state {
 
 	u8 pwm;
 	u8 reg0;
+	u8 last_lock : 1;
+	u32 ucblocks;
 };
 
 
@@ -266,6 +268,10 @@ static int tda10021_set_parameters (stru
 
 	tda10021_setup_reg0 (state, reg0x00[qam], p->inversion);
 
+	/* reset uncorrected block counter */
+	state->last_lock = 0;
+	state->ucblocks = 0;
+
 	return 0;
 }
 
@@ -273,6 +279,7 @@ static int tda10021_read_status(struct d
 {
 	struct tda10021_state* state = fe->demodulator_priv;
 	int sync;
+	u32 ucblocks;
 
 	*status = 0;
 	//0x11[0] == EQALGO -> Equalizer algorithms state
@@ -291,6 +298,22 @@ static int tda10021_read_status(struct d
 	if (sync & 8)
 		*status |= FE_HAS_LOCK;
 
+	/* read uncorrected block counter */
+	ucblocks = tda10021_readreg(state, 0x13) & 0x7f;
+
+	/* reset uncorrected block counter */
+	_tda10021_writereg(state, 0x10, tda10021_inittab[0x10] & 0xdf);
+	_tda10021_writereg(state, 0x10, tda10021_inittab[0x10]);
+
+	if (sync & 8) {
+		if (state->last_lock)
+			/* update ucblocks */
+			state->ucblocks += ucblocks;
+		state->last_lock = 1;
+	} else {
+		state->last_lock = 0;
+	}
+
 	return 0;
 }
 
@@ -335,14 +358,10 @@ static int tda10021_read_ucblocks(struct
 static int tda10021_read_ucblocks(struct dvb_frontend* fe, u32* ucblocks)
 {
 	struct tda10021_state* state = fe->demodulator_priv;
-
-	*ucblocks = tda10021_readreg (state, 0x13) & 0x7f;
-	if (*ucblocks == 0x7f)
-		*ucblocks = 0xffffffff;
-
-	/* reset uncorrected block counter */
-	_tda10021_writereg (state, 0x10, tda10021_inittab[0x10] & 0xdf);
-	_tda10021_writereg (state, 0x10, tda10021_inittab[0x10]);
+	fe_status_t status;
+
+	tda10021_read_status(fe, &status);
+	*ucblocks = state->ucblocks;
 
 	return 0;
 }

--------------020308070600080405080201
Content-Type: text/x-diff;
 name="stv0297-unc-fix.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="stv0297-unc-fix.diff"

signed-off-by: Hartmut Birr <e9hack@gmail.com>
- Don't reset the uncorrected block counter on a read request.
diff -r 4c4fd6b8755c linux/drivers/media/dvb/frontends/stv0297.c
--- a/linux/drivers/media/dvb/frontends/stv0297.c	Fri May 02 07:51:27 2008 -0300
+++ b/linux/drivers/media/dvb/frontends/stv0297.c	Sat May 03 15:43:48 2008 +0200
@@ -398,7 +398,6 @@ static int stv0297_read_ucblocks(struct 
 	*ucblocks = (stv0297_readreg(state, 0xD5) << 8)
 		| stv0297_readreg(state, 0xD4);
 
-	stv0297_writereg_mask(state, 0xDF, 0x03, 0x02); /* clear the counters */
 	stv0297_writereg_mask(state, 0xDF, 0x03, 0x01); /* re-enable the counters */
 
 	return 0;

--------------020308070600080405080201
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--------------020308070600080405080201--
