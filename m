Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:48831 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750785AbZAYQl6 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 25 Jan 2009 11:41:58 -0500
Content-Type: text/plain; charset="iso-8859-1"
Date: Sun, 25 Jan 2009 17:41:56 +0100
From: "Hans Werner" <HWerner4@gmx.de>
Message-ID: <20090125164156.205250@gmx.net>
MIME-Version: 1.0
Subject: [PATCH] scan-s2: tone setting when moving rotor
To: alex.betis@gmail.com, linux-media@vger.kernel.org,
	linux-dvb@linuxtv.org
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Alex,

here's a patch for scan-s2.

I found with one card (VP-1041) that I needed to be careful to 
turn off the tone before making the DiSEqC 1.2 rotor command.
Kaffeine does this too so guess it is generally necessary. Also
we can rotate faster by selecting the higher LNB voltage (18v).

Regards,
Hans

Signed-off-by: Hans Werner <hwerner4@gmx.de>


diff -r 06fb47f19e1c diseqc.c
--- a/diseqc.c
+++ b/diseqc.c
@@ -77,7 +77,15 @@ int rotor_command( int frontend_fd, int 
 	return err;
 }
 
-int rotate_rotor (int frontend_fd, int from_rotor_pos, int to_rotor_pos, int voltage_18){
+static inline void msleep(uint32_t msec)
+{
+	struct timespec req = { msec / 1000, 1000000 * (msec % 1000) };
+
+	while (nanosleep(&req, &req))
+		;
+}
+
+int rotate_rotor (int frontend_fd, int from_rotor_pos, int to_rotor_pos, int voltage_18, int hiband){
 	/* Rotate a DiSEqC 1.2 rotor from position from_rotor_pos to position to_rotor_pos */
 	/* Uses Goto nn (command 9) */
 	float rotor_wait_time; //seconds
@@ -97,8 +105,17 @@ int rotate_rotor (int frontend_fd, int f
 				a2 = rotor_angle(from_rotor_pos);
 				degreesmoved = abs(a1-a2);
 				if (degreesmoved>180) degreesmoved=360-degreesmoved;
-				rotor_wait_time = degreesmoved / (voltage_18 ? speed_18V : speed_13V);
+				rotor_wait_time = degreesmoved / speed_18V;
 			}
+
+			//switch tone off
+			if (err = ioctl(frontend_fd, FE_SET_TONE, SEC_TONE_OFF))
+				return err;
+			msleep(15);
+			// high voltage for high speed rotation
+			if (err = ioctl(frontend_fd, FE_SET_VOLTAGE, SEC_VOLTAGE_18))
+				return err;
+			msleep(15);
 			err = rotor_command(frontend_fd, 9, to_rotor_pos, 0, 0);
 			if (err) {
 				info("Rotor move error!\n");
@@ -111,20 +128,22 @@ int rotate_rotor (int frontend_fd, int f
 				}
 				info("completed.\n");
 			}
+
 		} else {
 			info("Rotor already at position %i\n", from_rotor_pos);
 		}
+
+		// correct tone and voltage
+		if (err = ioctl(frontend_fd, FE_SET_TONE, hiband ? SEC_TONE_ON : SEC_TONE_OFF))
+                        return err;
+		msleep(15);
+		if (err = ioctl(frontend_fd, FE_SET_VOLTAGE, voltage_18))
+			return err;
+		msleep(15);
 	}
 	return err;
 }
 
-static inline void msleep(uint32_t msec)
-{
-	struct timespec req = { msec / 1000, 1000000 * (msec % 1000) };
-
-	while (nanosleep(&req, &req))
-		;
-}
 
 int diseqc_send_msg (int fd, fe_sec_voltage_t v, struct diseqc_cmd **cmd,
 					 fe_sec_tone_mode_t t, fe_sec_mini_cmd_t b)
diff -r 06fb47f19e1c diseqc.h
--- a/diseqc.h
+++ b/diseqc.h
@@ -17,7 +17,7 @@ extern int diseqc_send_msg (int fd, fe_s
 *   set up the switch to position/voltage/tone
 */
 extern int setup_switch (int frontend_fd, int switch_pos, int voltage_18, int freq, int uncommitted_switch_pos);
-extern int rotate_rotor (int frontend_fd, int from_rotor_pos, int to_rotor_pos, int voltage_18);
+extern int rotate_rotor (int frontend_fd, int from_rotor_pos, int to_rotor_pos, int voltage_18, int hiband);
 
 #endif
 
diff -r 06fb47f19e1c scan.c
--- a/scan.c
+++ b/scan.c
@@ -1076,7 +1076,7 @@ static void parse_nit (struct section_bu
 				// New DVB-S transponder
 				t = alloc_transponder(tn.frequency);
 
-				// For sattelites add both DVB-S and DVB-S2 transopnders since we don't know what should be used
+				// For satellites add both DVB-S and DVB-S2 transponders since we don't know what should be used
 				if(current_tp->delivery_system == SYS_DVBS || current_tp->delivery_system == SYS_DVBS2) {
 					tn.delivery_system = SYS_DVBS;
 					copy_transponder(t, &tn);
@@ -1705,6 +1705,7 @@ static int __tune_to_transponder (int fr
 	uint32_t if_freq = 0;
 	uint32_t bandwidth_hz = 0;
 	current_tp = t;
+	int hiband = 0;
 
 	struct dtv_property p_clear[] = {
 		{ .cmd = DTV_CLEAR },
@@ -1735,7 +1736,7 @@ static int __tune_to_transponder (int fr
 		if (lnb_type.high_val) {
 			if (lnb_type.switch_val) {
 				/* Voltage-controlled switch */
-				int hiband = 0;
+				hiband = 0;
 
 				if (t->frequency >= lnb_type.switch_val)
 					hiband = 1;
@@ -1770,9 +1771,10 @@ static int __tune_to_transponder (int fr
 			if (t->orbital_pos!=0) rotor_pos = rotor_nn(t->orbital_pos, t->we_flag);
 			int err;
 			err = rotate_rotor(	frontend_fd,
-				curr_rotor_pos, 
-				rotor_pos,
-				t->polarisation == POLARISATION_VERTICAL ? 0 : 1);
+						curr_rotor_pos, 
+						rotor_pos,
+						t->polarisation == POLARISATION_VERTICAL ? 0 : 1,
+						hiband);
 			if (err)
 				error("Error in rotate_rotor err=%i\n",err); 
 			else
@@ -1798,14 +1800,14 @@ static int __tune_to_transponder (int fr
 		}
 		break;
 
-	case SYS_DVBC_ANNEX_B:
-	case SYS_DVBC_ANNEX_AC:
-		if_freq = t->frequency;
-
-		if (verbosity >= 2){
-			dprintf(1,"DVB-C frequency is %d\n", if_freq);
-		}
-		break;
+	case SYS_DVBC_ANNEX_B:
+	case SYS_DVBC_ANNEX_AC:
+		if_freq = t->frequency;
+
+		if (verbosity >= 2){
+			dprintf(1,"DVB-C frequency is %d\n", if_freq);
+		}
+		break;
 	}
 
 	struct dvb_frontend_event ev;
@@ -1825,7 +1827,7 @@ static int __tune_to_transponder (int fr
 		.num = 10,
 		.props = p_tune
 	};
-
+	
 	/* discard stale QPSK events */
 	while (1) {
 		if (ioctl(frontend_fd, FE_GET_EVENT, &ev) == -1)
@@ -2723,8 +2725,8 @@ static const char *usage = "\n"
 "	-5	multiply all filter timeouts by factor 5\n"
 "		for non-DVB-compliant section repitition rates\n"
 "	-O pos	Orbital position override 'S4W', 'S19.2E' - good for VDR output\n"
-"	-k cnt	Skip count, will skip every first specified\n"
-"		messages for every message type (default 0)\n"
+"	-k cnt	Skip count: skip the first cnt \n"
+"		messages of each message type (default 0)\n"
 "	-I cnt	Scan iterations count (default 10).\n"
 "		Larger number will make scan longer on every channel\n"
 "	-o fmt	output format: 'vdr' (default) or 'zap'\n"

-- 
Release early, release often.

NUR NOCH BIS 31.01.! GMX FreeDSL - Telefonanschluss + DSL 
für nur 16,37 EURO/mtl.!* http://dsl.gmx.de/?ac=OM.AD.PD003K11308T4569a
