Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.gmx.net ([213.165.64.20])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <HWerner4@gmx.de>) id 1L05WD-0001Wt-VK
	for linux-dvb@linuxtv.org; Wed, 12 Nov 2008 03:31:48 +0100
Content-Type: multipart/mixed; boundary="========GMX94741226457072473814"
Date: Wed, 12 Nov 2008 03:31:12 +0100
From: "Hans Werner" <HWerner4@gmx.de>
Message-ID: <20081112023112.94740@gmx.net>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org, alex.betis@gmail.com
Subject: [linux-dvb] [PATCH] scan-s2: fixes and diseqc rotor support
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

--========GMX94741226457072473814
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

I have attached two patches for scan-s2 at http://mercurial.intuxication.org/hg/scan-s2.

Patch1: Some fixes for problems I found. QAM_AUTO is not supported by all drivers,
in particular the HVR-4000, so one needs to use QPSK as the default and ensure that
settings are parsed properly from the network information -- the new S2 FECs and
modulations were not handled.

Patch2: Add DiSEqC 1.2 rotor support. Use it like this to move the dish to the correct
position for the scan:
 scan-s2 -r 19.2E -n dvb-s/Astra-19.2E
 or
 scan-s2 -R 2 -n dvb-s/Astra-19.2E

A file (rotor.conf) listing the rotor positions is used (NB: rotors vary -- do check your
rotor manual).

Regards,
Hans

-- 
Release early, release often.

Ist Ihr Browser Vista-kompatibel? Jetzt die neuesten 
Browser-Versionen downloaden: http://www.gmx.net/de/go/browser

--========GMX94741226457072473814
Content-Type: text/x-patch;
 charset="iso-8859-15";
 name="patch1_qpsk_default.diff"
Content-Transfer-Encoding: 8bit
Content-Disposition: attachment; filename="patch1_qpsk_default.diff"

diff -r 40368fdba59a scan.c
--- a/scan.c
+++ b/scan.c
@@ -393,25 +397,32 @@ static void parse_s2_satellite_delivery_
 
 static void parse_satellite_delivery_system_descriptor (const unsigned char *buf, struct transponder *t)
 {
-	static const fe_code_rate_t fec_tab [8] = {
-		FEC_AUTO, FEC_1_2, FEC_2_3, FEC_3_4,
-		FEC_5_6, FEC_7_8, FEC_NONE, FEC_NONE
-	};
-
 	if (!t) {
 		warning("satellite_delivery_system_descriptor outside transport stream definition (ignored)\n");
 		return;
 	}
 
-	if(((buf[8] >> 1) & 0x01) == 0) {
-		t->delivery_system = SYS_DVBS;
-	}
-	else {
-		t->delivery_system = SYS_DVBS2;
+	switch ( getBits(buf,69,1) ) {
+		case 0: t->delivery_system = SYS_DVBS; break;
+		case 1: t->delivery_system = SYS_DVBS2; break;
 	}
 
 	t->frequency = 10 * bcd32_to_cpu (buf[2], buf[3], buf[4], buf[5]);
-	t->fec = fec_tab[buf[12] & 0x07];
+	
+	switch ( getBits(buf,100,4) ) {
+                case 0 : t->fec = FEC_AUTO; break;
+                case 1 : t->fec = FEC_1_2; break;
+                case 2 : t->fec = FEC_2_3; break;
+                case 3 : t->fec = FEC_3_4; break;
+                case 4 : t->fec = FEC_5_6; break;
+                case 5 : t->fec = FEC_7_8; break;
+                case 6 : t->fec = FEC_8_9; break;
+                case 7 : t->fec = FEC_3_5; break;
+                case 8 : t->fec = FEC_4_5; break;
+                case 9 : t->fec = FEC_9_10; break;
+                case 15 : t->fec = FEC_NONE; break;
+        }
+	
 	t->symbol_rate = 10 * bcd32_to_cpu (buf[9], buf[10], buf[11], buf[12] & 0xf0);
 
 	t->inversion = spectral_inversion;	
@@ -419,6 +430,13 @@ static void parse_satellite_delivery_sys
 	t->polarisation = (buf[8] >> 5) & 0x03;
 	t->orbital_pos = bcd32_to_cpu (0x00, 0x00, buf[6], buf[7]);
 	t->we_flag = buf[8] >> 7;
+
+	switch ( getBits(buf,70,2) ) {
+                case 0 : t->modulation = QAM_AUTO; break;
+                case 1 : t->modulation = QPSK; break;
+                case 2 : t->modulation = PSK_8; break;
+                case 3 : t->modulation = QAM_16; break;
+        }
 
 	if (verbosity >= 5) {
 		debug("%#04x/%#04x ", t->network_id, t->transport_stream_id);
@@ -1858,7 +1892,7 @@ struct strtab qamtab[] = {
 
 static enum fe_modulation str2qam(const char *qam)
 {
-	return str2enum(qam, qamtab, QAM_AUTO);
+	return str2enum(qam, qamtab, QPSK);
 }
 
 static const char* qam2str(enum fe_modulation qam)
@@ -1968,8 +2074,8 @@ static int tune_initial (int frontend_fd
 		else if (sscanf(buf, "S %u %1[HVLR] %u %4s %4s %6s\n", &f, pol, &sr, fec, rolloff, qam) >= 3) {
 			t = alloc_transponder(f);
 			t->delivery_system = SYS_DVBS;
-			t->modulation = QAM_AUTO;
-			t->rolloff = ROLLOFF_AUTO;
+			t->modulation = QPSK;
+			t->rolloff = ROLLOFF_35;
 			t->fec = FEC_AUTO;
 			switch(pol[0]) 
 			{

--========GMX94741226457072473814
Content-Type: text/x-patch;
 charset="iso-8859-15";
 name="patch2_add_diseqc_rotor.diff"
Content-Transfer-Encoding: 8bit
Content-Disposition: attachment; filename="patch2_add_diseqc_rotor.diff"

diff -r 40368fdba59a diseqc.c
--- a/diseqc.c
+++ b/diseqc.c
@@ -45,6 +45,77 @@ struct diseqc_cmd uncommitted_switch_cmd
 };
 
 /*--------------------------------------------------------------------------*/
+
+#define DISEQC_X 2
+int rotor_command( int frontend_fd, int cmd, int n1, int n2, int n3 )
+{
+	int err;
+        struct dvb_diseqc_master_cmd cmds[] = {
+                { { 0xe0, 0x31, 0x60, 0x00, 0x00, 0x00 }, 3 },  //0 Stop Positioner movement
+                { { 0xe0, 0x31, 0x63, 0x00, 0x00, 0x00 }, 3 },  //1 Disable Limits
+                { { 0xe0, 0x31, 0x66, 0x00, 0x00, 0x00 }, 3 },  //2 Set East Limit
+                { { 0xe0, 0x31, 0x67, 0x00, 0x00, 0x00 }, 3 },  //3 Set West Limit
+                { { 0xe0, 0x31, 0x68, 0x00, 0x00, 0x00 }, 4 },  //4 Drive Motor East continously
+                { { 0xe0, 0x31, 0x68,256-n1,0x00, 0x00 }, 4 },  //5 Drive Motor East nn steps
+                { { 0xe0, 0x31, 0x69,256-n1,0x00, 0x00 }, 4 },  //6 Drive Motor West nn steps
+                { { 0xe0, 0x31, 0x69, 0x00, 0x00, 0x00 }, 4 },  //7 Drive Motor West continously
+                { { 0xe0, 0x31, 0x6a, n1, 0x00, 0x00 }, 4 },  //8 Store nn
+                { { 0xe0, 0x31, 0x6b, n1, 0x00, 0x00 }, 4 },   //9 Goto nn
+                { { 0xe0, 0x31, 0x6f, n1, n2, n3 }, 4}, //10 Recalculate Position
+                { { 0xe0, 0x31, 0x6a, 0x00, 0x00, 0x00 }, 4 },  //11 Enable Limits
+                { { 0xe0, 0x31, 0x6e, n1, n2, 0x00 }, 5 },   //12 Gotoxx
+                { { 0xe0, 0x10, 0x38, 0xF4, 0x00, 0x00 }, 4 }    //13 User
+        };
+
+        int i;
+        for ( i=0; i<DISEQC_X; ++i ) {
+                usleep(15*1000);
+                if ( err = ioctl( frontend_fd, FE_DISEQC_SEND_MASTER_CMD, &cmds[cmd] ) )
+                        error("rotor_command: FE_DISEQC_SEND_MASTER_CMD failed, err=%i\n",err);
+        }
+	return err;
+}
+
+int rotate_rotor (int frontend_fd, int from_rotor_pos, int to_rotor_pos, int voltage_18){
+	/* Rotate a DiSEqC 1.2 rotor from position from_rotor_pos to position to_rotor_pos */
+	/* Uses Goto nn (command 9) */
+	float rotor_wait_time; //seconds
+	int err=0;
+
+	float speed_13V = 1.5; //degrees per second
+	float speed_18V = 2.4; //degrees per second
+	float degreesmoved,a1,a2;
+
+	if (to_rotor_pos != 0) {
+		if (from_rotor_pos != to_rotor_pos) {
+			info("Moving rotor from position %i to position %i\n",from_rotor_pos,to_rotor_pos);
+			if (from_rotor_pos == 0) {
+				rotor_wait_time = 15; // starting from unknown position
+			} else {
+				a1 = rotor_angle(to_rotor_pos);
+				a2 = rotor_angle(from_rotor_pos);
+				degreesmoved = abs(a1-a2);
+				if (degreesmoved>180) degreesmoved=360-degreesmoved;
+				rotor_wait_time = degreesmoved / (voltage_18 ? speed_18V : speed_13V);
+			}
+			err = rotor_command(frontend_fd, 9, to_rotor_pos, 0, 0);
+			if (err) {
+				info("Rotor move error!\n");
+			} else {
+				int i;
+				info("Rotating");
+				for (i=0; i<10; i++){
+					usleep(rotor_wait_time*100000);
+					info(".");
+				}
+				info("completed.\n");
+			}
+		} else {
+			info("Rotor already at position %i\n", from_rotor_pos);
+		}
+	}
+	return err;
+}
 
 static inline void msleep(uint32_t msec)
 {
diff -r 40368fdba59a diseqc.h
--- a/diseqc.h
+++ b/diseqc.h
@@ -17,6 +17,7 @@ extern int diseqc_send_msg (int fd, fe_s
 *   set up the switch to position/voltage/tone
 */
 extern int setup_switch (int frontend_fd, int switch_pos, int voltage_18, int freq, int uncommitted_switch_pos);
+extern int rotate_rotor (int frontend_fd, int from_rotor_pos, int to_rotor_pos, int voltage_18);
 
 
 #endif
diff -r 40368fdba59a scan.c
--- a/scan.c
+++ b/scan.c
@@ -84,10 +84,14 @@ static fe_spectral_inversion_t spectral_
 static fe_spectral_inversion_t spectral_inversion = INVERSION_AUTO;
 static int switch_pos = 0;
 static int uncommitted_switch_pos = 0;
+static int rotor_pos = 0;
+static int curr_rotor_pos = 0;
+static char rotor_pos_name[16] = "";
 static char override_orbital_pos[16] = "";
 static enum format output_format = OUTPUT_VDR;
 static int output_format_set = 0;
 
+static rotorslot_t rotor[49];
 
 struct section_buf {
 	struct list_head list;
@@ -1569,6 +1587,22 @@ static int __tune_to_transponder (int fr
 		if (verbosity >= 2) {
 			dprintf(1,"DVB-S IF freq is %d\n", if_freq);
 		}
+
+		
+		if (rotor_pos != 0 ) {
+			/* Rotate DiSEqC 1.2 rotor to correct orbital position */
+			if (t->orbital_pos!=0) rotor_pos = rotor_nn(t->orbital_pos, t->we_flag);
+			int err;
+			err = rotate_rotor(	frontend_fd,
+						curr_rotor_pos, 
+						rotor_pos,
+						t->polarisation == POLARISATION_VERTICAL ? 0 : 1);
+			if (err)
+				error("Error in rotate_rotor err=%i\n",err); 
+			else
+				curr_rotor_pos = rotor_pos;
+		}
+
 		break;
 
 	case SYS_DVBT:
@@ -1939,6 +1973,78 @@ static const char* hier2str(enum fe_hier
 	return enum2str(hier, hiertab, "???");
 }
 
+static int read_rotor_conf(const char *rotor_conf)
+{
+	FILE *rotor_conf_fd;
+	unsigned int nn;
+	char buf[200], angle_we[20], angle[20], we[2];
+	int i = -1;
+	rotor_conf_fd = fopen (rotor_conf, "r");
+	if (!rotor_conf_fd){
+		error("Cannot open rotor configuration file '%s'.");
+		return errno;
+	}
+	while (fgets(buf, sizeof(buf), rotor_conf_fd)) {
+		if (buf[0] != '#' && buf[0] != '\n') {
+			if (sscanf(buf, "%u %s\n", &nn, angle_we)==2) {
+				i++;
+				rotor[i].nn = nn;
+				strcpy(rotor[i].angle_we,angle_we);
+				strncpy(angle,angle_we,strlen(angle_we)-1);
+				rotor[i].orbital_pos = atof(angle) * 10;
+				strncpy(we,angle_we+strlen(angle_we)-1,1);
+				we[1]='\0';
+				rotor[i].we_flag = (strcmp(we,"W")==0 || strcmp(we,"w")==0) ? 0 : 1;
+				//info("rotor: i=%i, nn=%i, orbital_pos=%i we_flag=%i\n", 
+				//	i, rotor[i].nn, rotor[i].orbital_pos, rotor[i].we_flag);
+			}
+		}
+	}
+	fclose(rotor_conf_fd);
+	return 0;
+}
+
+int rotor_nn(int orbital_pos, int we_flag){
+	/*given say 192,1 return the position number*/
+	int i;
+	for (i=0; i<49; i++){
+		if (rotor[i].orbital_pos == orbital_pos && rotor[i].we_flag == we_flag) {
+			return rotor[i].nn;
+		}
+	}
+	error("rotor_nn: orbital_pos=%i, we_flag=%i not found.\n", orbital_pos, we_flag);
+	return 0;
+}
+
+int rotor_name2nn(char *angle_we){
+	/*given say '19.2E' return the position number*/
+	int i;
+	for (i=0; i<49; i++){
+		if (strcmp(rotor[i].angle_we, angle_we) == 0) {
+			return rotor[i].nn;
+		}
+	}
+	error("rotor_name2nn: '%s' not found.\n", angle_we);
+	return 0;
+}
+
+float rotor_angle(int nn) {
+	/*given nn, return the angle in 0.0-359.9 range (1=1.0E, 359=1.0W) */
+	int i;
+	float angle;
+	for (i=0; i<49; i++){
+		if (rotor[i].nn == nn) {
+			if(rotor[i].we_flag == 0) //west
+				angle = 360.00 - rotor[i].orbital_pos / 10;
+			else //east
+				angle = rotor[i].orbital_pos / 10;
+			return angle;
+		}
+	}
+	error("rotor_angle: nn=%i not found",nn);
+	return -999;
+}
+
 static int tune_initial (int frontend_fd, const char *initial)
 {
 	FILE *inif;
@@ -2353,6 +2459,8 @@ static const char *usage = "\n"
 "	-d N	use DVB /dev/dvb/adapter?/demuxN\n"
 "	-s N	use DiSEqC switch position N (DVB-S only)\n"
 "	-S N    use DiSEqC uncommitted switch position N (DVB-S only)\n"
+"	-r sat  move DiSEqC rotor to satellite location, e.g. '13.0E' or '1.0W'\n"
+"	-R N    move DiSEqC rotor to position number N\n"
 "	-i N	spectral inversion setting (0: off, 1: on, 2: auto [default])\n"
 "	-n	evaluate NIT messages for full network scan (slow!)\n"
 "	-5	multiply all filter timeouts by factor 5\n"
@@ -2431,7 +2539,7 @@ int main (int argc, char **argv)
 
 	/* start with default lnb type */
 	lnb_type = *lnb_enum(0);
-	while ((opt = getopt(argc, argv, "5cnpa:f:d:O:k:I:S:s:o:x:t:i:l:vquPA:U")) != -1) {
+	while ((opt = getopt(argc, argv, "5cnpa:f:d:O:k:I:S:s:r:R:o:x:t:i:l:vquPA:U")) != -1) {
 		switch (opt) 
 		{
 		case 'a':
@@ -2474,6 +2582,14 @@ int main (int argc, char **argv)
 
 		case 'S':
 			uncommitted_switch_pos = strtoul(optarg, NULL, 0);
+			break;
+
+		case 'r':
+			strncpy(rotor_pos_name,optarg,sizeof(rotor_pos_name)-1);
+			break;
+
+		case 'R':
+			rotor_pos = strtoul(optarg, NULL, 0);
 			break;
 
 		case 'O':
@@ -2567,6 +2683,16 @@ int main (int argc, char **argv)
 		fprintf (stderr, "uncommitted_switch position needs to be < 16!\n");
 		return -1;
 	}
+
+	read_rotor_conf("rotor.conf");
+	if (strlen(rotor_pos_name)>0){
+		rotor_pos=rotor_name2nn(rotor_pos_name);
+		if (rotor_pos == 0){
+			fprintf(stderr,"Rotor position '%s' not found. Check config.",rotor_pos_name);
+			return -1;
+		}
+	}
+
 	if (initial)
 		info("scanning %s\n", initial);
 
diff -r 40368fdba59a scan.h
--- a/scan.h
+++ b/scan.h
@@ -103,6 +103,12 @@ typedef struct transponder {
 	uint32_t *other_f;			/* DVB-T freqeuency-list descriptor */
 } transponder_t;
 
+typedef struct rotorslot {
+	unsigned int nn;
+	int orbital_pos;	// 192  degrees*10
+	unsigned int we_flag;	// 0=W, 1=E
+	char angle_we[8];	// '19.2E'
+} rotorslot_t;
 
 #endif
 

--========GMX94741226457072473814
Content-Type: text/plain; charset="iso-8859-15"; name="rotor.conf"
Content-Transfer-Encoding: 8bit
Content-Disposition: attachment; filename="rotor.conf"

# rotor.conf
# diseqc_position_number orbital_position
1 13.0E
2 19.2E
3 16.0E
4 10.0E
5 7.0E
6 5.0E
7 3.0E
10 8.0W
11 18.0W
13 27.5W
16 23.5E
17 26.0E
19 28.2E
26 1.0W
27 7.0W
28 12.5W















--========GMX94741226457072473814
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--========GMX94741226457072473814--
