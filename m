Return-path: <mchehab@pedra>
Received: from mailout-de.gmx.net ([213.165.64.23]:43047 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753576Ab1EDLRn (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 4 May 2011 07:17:43 -0400
Message-ID: <4DC135E5.40805@gmx.net>
Date: Wed, 04 May 2011 13:17:57 +0200
From: Lutz Sammer <johns98@gmx.net>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
CC: mchehab@redhat.com
Subject: [PATCH] stb0899: Fix not locking DVB-S transponder
Content-Type: multipart/mixed;
 boundary="------------060306030505080506020806"
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

This is a multi-part message in MIME format.
--------------060306030505080506020806
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

stb0899: Fix not locking DVB-S transponder

When stb0899_check_data is entered, it could happen, that the data is
already locked and the data search looped.  stb0899_check_data fails to
lock on a good frequency.  stb0899_search_data uses an extrem big search
step and fails to lock.

The new code checks for lock before starting a new search.
The first read ignores the loop bit, for the case that the loop bit is
set during the search setup.  I also added the msleep to reduce the
traffic on the i2c bus.

Resend, last version seems to be broken by email-client.

Johns

Signed-off-by: Lutz Sammer <johns98@gmx.net>

--------------060306030505080506020806
Content-Type: text/plain;
 name="stb0899_not_locking_fix.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="stb0899_not_locking_fix.diff"

diff --git a/drivers/media/dvb/frontends/stb0899_algo.c b/drivers/media/dvb/frontends/stb0899_algo.c
index 2da55ec..55f0c4e 100644
--- a/drivers/media/dvb/frontends/stb0899_algo.c
+++ b/drivers/media/dvb/frontends/stb0899_algo.c
@@ -338,36 +338,42 @@ static enum stb0899_status stb0899_check_data(struct stb0899_state *state)
 	int lock = 0, index = 0, dataTime = 500, loop;
 	u8 reg;
 
-	internal->status = NODATA;
+	reg = stb0899_read_reg(state, STB0899_VSTATUS);
+	lock = STB0899_GETFIELD(VSTATUS_LOCKEDVIT, reg);
+	if ( !lock ) {
 
-	/* RESET FEC	*/
-	reg = stb0899_read_reg(state, STB0899_TSTRES);
-	STB0899_SETFIELD_VAL(FRESACS, reg, 1);
-	stb0899_write_reg(state, STB0899_TSTRES, reg);
-	msleep(1);
-	reg = stb0899_read_reg(state, STB0899_TSTRES);
-	STB0899_SETFIELD_VAL(FRESACS, reg, 0);
-	stb0899_write_reg(state, STB0899_TSTRES, reg);
+		internal->status = NODATA;
 
-	if (params->srate <= 2000000)
-		dataTime = 2000;
-	else if (params->srate <= 5000000)
-		dataTime = 1500;
-	else if (params->srate <= 15000000)
-		dataTime = 1000;
-	else
-		dataTime = 500;
-
-	stb0899_write_reg(state, STB0899_DSTATUS2, 0x00); /* force search loop	*/
-	while (1) {
-		/* WARNING! VIT LOCKED has to be tested before VIT_END_LOOOP	*/
-		reg = stb0899_read_reg(state, STB0899_VSTATUS);
-		lock = STB0899_GETFIELD(VSTATUS_LOCKEDVIT, reg);
-		loop = STB0899_GETFIELD(VSTATUS_END_LOOPVIT, reg);
+		/* RESET FEC	*/
+		reg = stb0899_read_reg(state, STB0899_TSTRES);
+		STB0899_SETFIELD_VAL(FRESACS, reg, 1);
+		stb0899_write_reg(state, STB0899_TSTRES, reg);
+		msleep(1);
+		reg = stb0899_read_reg(state, STB0899_TSTRES);
+		STB0899_SETFIELD_VAL(FRESACS, reg, 0);
+		stb0899_write_reg(state, STB0899_TSTRES, reg);
 
-		if (lock || loop || (index > dataTime))
-			break;
-		index++;
+		if (params->srate <= 2000000)
+			dataTime = 2000;
+		else if (params->srate <= 5000000)
+			dataTime = 1500;
+		else if (params->srate <= 15000000)
+			dataTime = 1000;
+		else
+			dataTime = 500;
+
+		stb0899_write_reg(state, STB0899_DSTATUS2, 0x00); /* force search loop	*/
+		while (1) {
+			/* WARNING! VIT LOCKED has to be tested before VIT_END_LOOOP	*/
+			reg = stb0899_read_reg(state, STB0899_VSTATUS);
+			lock = STB0899_GETFIELD(VSTATUS_LOCKEDVIT, reg);
+			loop = STB0899_GETFIELD(VSTATUS_END_LOOPVIT, reg);
+	
+			if (lock || (loop && index) || (index > dataTime))
+				break;
+			index++;
+			msleep(1);
+		}
 	}
 
 	if (lock) {	/* DATA LOCK indicator	*/

--------------060306030505080506020806--
