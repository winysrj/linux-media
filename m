Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.gmx.net ([213.165.64.20])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <HWerner4@gmx.de>) id 1L0lFZ-0008H5-5T
	for linux-dvb@linuxtv.org; Fri, 14 Nov 2008 00:05:22 +0100
Content-Type: multipart/mixed; boundary="========GMX273581226617487520824"
Date: Fri, 14 Nov 2008 00:04:47 +0100
From: "Hans Werner" <HWerner4@gmx.de>
In-Reply-To: <c74595dc0811121256h505d71e1q3468e061dfefc3df@mail.gmail.com>
Message-ID: <20081113230447.273580@gmx.net>
MIME-Version: 1.0
References: <20081112023112.94740@gmx.net>
	<c74595dc0811121256h505d71e1q3468e061dfefc3df@mail.gmail.com>
To: "Alex Betis" <alex.betis@gmail.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] [PATCH] scan-s2: fixes and diseqc rotor support
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

--========GMX273581226617487520824
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8bit

> On Wed, Nov 12, 2008 at 4:31 AM, Hans Werner <HWerner4@gmx.de> wrote:
> 
> > I have attached two patches for scan-s2 at
> > http://mercurial.intuxication.org/hg/scan-s2.
> >
> > Patch1: Some fixes for problems I found. QAM_AUTO is not supported by
> all
> > drivers,
> > in particular the HVR-4000, so one needs to use QPSK as the default and
> > ensure that
> > settings are parsed properly from the network information -- the new S2
> > FECs and
> > modulations were not handled.
> >
> > Patch2: Add DiSEqC 1.2 rotor support. Use it like this to move the dish
> to
> > the correct
> > position for the scan:
> >  scan-s2 -r 19.2E -n dvb-s/Astra-19.2E
> >  or
> >  scan-s2 -R 2 -n dvb-s/Astra-19.2E
> >
> > A file (rotor.conf) listing the rotor positions is used (NB: rotors vary
> --
> > do check your
> > rotor manual).
> >
> Hans,
> I'm looking on your QPSK diff and I disagree with the changes.
> I think the concept of having all missing parameters as AUTO values should
> have modulation, rolloff and FEC set to AUTO enumeration.
> If your card can't handle the AUTO setting, so you have to specify it in
> the
> frequency file.

I want the computer to do the work, see below ;).

> Applying your changes will break scaning S2 channels for a freq file with
> the following line:
> S 11258000 H 27500000
> or even
> S2 11258000 H 27500000
> 
> Since it will order the driver to use QPSK modulation, while there should
> be
> 8PSK or AUTO.
> I don't really know how rolloff=35 will affect since its the default in
> some
> drivers, but again, AUTO setting was intended for that purpose,
> to let the card/driver decide what parameters should be used.

Ok, I have looked at this again and written a new patch. I also looked at what
you checked in yesterday for S1/S2 and -D options.

In order to keep the AUTO behaviour you want and also allow for cards which 
cannot handle autos I have added a new option -X which sets a noauto flag.
When this option is chosen, instead of putting an initial transponder with an AUTO
in the transponder list, several transponders are created for each allowed value of
each free parameter (which may be delivery system, modulation, fec or rolloff).

so with -X
S 12551500 V 22000000 5/6
results in 
initial transponder DVB-S  12551500 V 22000000 5/6 35 QPSK
initial transponder DVB-S2 12551500 V 22000000 5/6 35 QPSK
initial transponder DVB-S2 12551500 V 22000000 5/6 35 8PSK
initial transponder DVB-S2 12551500 V 22000000 5/6 25 QPSK
initial transponder DVB-S2 12551500 V 22000000 5/6 25 8PSK
initial transponder DVB-S2 12551500 V 22000000 5/6 20 QPSK
initial transponder DVB-S2 12551500 V 22000000 5/6 20 8PSK

(fec was fixed in the transponder file in this example, but delivery
system, rolloff and modulation were not)

The new S1/S2 and -D options are respected. So with -D S1, the S2
lines would not be added for example.

Using -X -D and S2/S1/S thus gives lots of flexibility for scanning.

The patch also makes improvements in
parse_satellite_delivery_system_descriptor, adding rolloff and the
new S2 FECs and changes to delivery system and modulation parsing.

Hans

-- 
Release early, release often.

Sensationsangebot nur bis 30.11: GMX FreeDSL - Telefonanschluss + DSL 
für nur 16,37 Euro/mtl.!* http://dsl.gmx.de/?ac=OM.AD.PD003K11308T4569a

--========GMX273581226617487520824
Content-Type: text/x-patch; charset="iso-8859-15"; name="patch1b_noauto.diff"
Content-Transfer-Encoding: 8bit
Content-Disposition: attachment; filename="patch1b_noauto.diff"

diff -r 9ba3818cecb9 scan.c
--- a/scan.c
+++ b/scan.c
@@ -73,6 +73,7 @@ static int long_timeout;
 static int long_timeout;
 static int current_tp_only;
 static int get_other_nits;
+static int noauto=0;
 static int vdr_dump_provider;
 static int vdr_dump_channum;
 static int no_ATSC_PSIP;
@@ -400,25 +401,42 @@ static void parse_s2_satellite_delivery_
 
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
+                case 0: t->delivery_system = SYS_DVBS; break;
+                case 1: t->delivery_system = SYS_DVBS2; break;
+        }
+
+        if (t->delivery_system == SYS_DVBS2) {
+                switch ( getBits(buf,67,2) ) {
+                        case 0 : t->rolloff = ROLLOFF_35; break;
+                        case 1 : t->rolloff = ROLLOFF_25; break;
+                        case 2 : t->rolloff = ROLLOFF_20; break;
+                }
+        } else {
+		if (noauto) t->rolloff = ROLLOFF_35;
 	}
 
 	t->frequency = 10 * bcd32_to_cpu (buf[2], buf[3], buf[4], buf[5]);
-	t->fec = fec_tab[buf[12] & 0x07];
+
+        switch ( getBits(buf,100,4) ) {
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
@@ -427,9 +445,17 @@ static void parse_satellite_delivery_sys
 	t->orbital_pos = bcd32_to_cpu (0x00, 0x00, buf[6], buf[7]);
 	t->we_flag = buf[8] >> 7;
 
+	switch ( getBits(buf,70,2) ) {
+		case 0 : t->modulation = QAM_AUTO; break;
+		case 1 : t->modulation = QPSK; break;
+		case 2 : t->modulation = PSK_8; break;
+		case 3 : t->modulation = QAM_16; break;
+	}
+
 	if (verbosity >= 5) {
 		debug("%#04x/%#04x ", t->network_id, t->transport_stream_id);
 		dump_dvb_parameters (stderr, t);
+		printf("\n");
 		if (t->scan_done)
 			dprintf(5, " (done)");
 		if (t->last_tuning_failed)
@@ -2064,107 +2090,106 @@ static int tune_initial (int frontend_fd
 		if (buf[0] == '#' || buf[0] == '\n')
 			;
 		else if (sscanf(buf, "S%c %u %1[HVLR] %u %4s %4s %6s\n", &scan_mode, &f, pol, &sr, fec, rolloff, qam) >= 3) {
-			t = alloc_transponder(f);
-			t->delivery_system = SYS_DVBS;
-			t->modulation = QAM_AUTO;
-			t->rolloff = ROLLOFF_AUTO;
-			t->fec = FEC_AUTO;
-
+			scan_mode1 = FALSE;
+			scan_mode2 = FALSE;
 			switch(scan_mode)
 			{
 			case '1':
 				/* Enable only DVB-S mode */
-				scan_mode1 = TRUE;
+				if (!disable_s1) scan_mode1 = TRUE;
 				break;
-
+				
 			case '2':
 				/* Enable only DVB-S2 mode */
-				scan_mode2 = TRUE;
+				if (!disable_s1) scan_mode2 = TRUE;
 				break;
 
 			default:
 				/* Enable both DVB-S and DVB-S2 scan modes */
-				scan_mode1 = TRUE;
-				scan_mode2 = TRUE;
+				if (!disable_s1) scan_mode1 = TRUE;
+				if (!disable_s2) scan_mode2 = TRUE;
 				break;
 			}
 
-			switch(pol[0]) 
-			{
-			case 'H':
-			case 'L':
-				t->polarisation = POLARISATION_HORIZONTAL;
-				break;
-			default:
-				t->polarisation = POLARISATION_VERTICAL;;
-				break;
-			}
-			t->inversion = spectral_inversion;
-			t->symbol_rate = sr;
+			/*Generate a list of transponders, explicitly enumerating the AUTOs if they
+  			  are disabled with the -X parameter.*/
 
-			// parse optional parameters
-			if(strlen(fec) > 0) {
-				t->fec = str2fec(fec);
+			int nmod,nfec,ndel,nrol;
+			int imod,ifec,idel,irol;
+
+			/* set up list of delivery systems*/
+			fe_delivery_system_t delset[]={SYS_DVBS,SYS_DVBS2};
+			ndel=2;
+			if (scan_mode1 && !scan_mode2) {delset[0]=SYS_DVBS ; ndel=1;}
+			if (!scan_mode1 && scan_mode2) {delset[0]=SYS_DVBS2; ndel=1;}
+
+			/* set up list of modulations*/
+			fe_modulation_t modset[2]={ QPSK, PSK_8 };
+			nmod=2;
+			if (strlen(qam)>0) {
+				modset[0]=str2qam(qam); nmod=1;
+			} else if (noauto) { 
+				if (scan_mode1 && !scan_mode2 ) nmod=1;
+			} else {
+				modset[0]=QAM_AUTO; nmod=1;
 			}
 
-			if(strlen(rolloff) > 0) {
-				t->rolloff = str2rolloff(rolloff);
+			/* set up list of rollofs*/			
+			fe_rolloff_t rolset[3]={ROLLOFF_35,ROLLOFF_25,ROLLOFF_20};
+			nrol=3;
+			if (strlen(rolloff)>0) {
+				rolset[0]=str2rolloff(rolloff); nrol=1;
+			} else if (noauto) { 
+				if (scan_mode1 && ! scan_mode2) nrol=1;
+			} else {
+				rolset[0]=ROLLOFF_AUTO; nrol=1;
 			}
 
-			if(strlen(qam) > 0) {
-				t->modulation = str2qam(qam);
+			/* set up list of FECs*/
+			fe_code_rate_t fecset[9]={FEC_1_2,FEC_2_3,FEC_3_4,FEC_5_6,FEC_7_8,FEC_8_9,FEC_3_5,FEC_4_5,FEC_9_10};
+			if (strlen(fec)>0) {
+				fecset[0]=str2fec(fec); nfec=1;
+			} else if (noauto) { 
+				if (scan_mode1) nfec=6;
+				if (scan_mode2) nfec=9;
+			} else {
+				fecset[0]=FEC_AUTO; nfec=1;
 			}
 
-			switch(t->modulation)
-			{
-			case PSK_8:
-				/* DVB-S2 modulation is explicitly specified, scan only in DVB-S2 mode */
-				scan_mode1 = FALSE;
-				scan_mode2 = TRUE;
-				break;
-			}
+			for (idel=0;idel<ndel;idel++){
+			for (ifec=0;ifec<nfec;ifec++){
+			for (irol=0;irol<nrol;irol++){
+			for (imod=0;imod<nmod;imod++){
+				/*skip impossible settings*/
+				if ((rolset[irol]==ROLLOFF_25||rolset[irol]==ROLLOFF_20) && delset[idel]!=SYS_DVBS2) continue;
+				if (ifec > 5 && delset[idel]!=SYS_DVBS2) continue;
+				if (modset[imod] == PSK_8 && delset[idel] != SYS_DVBS2) continue;
 
-			/* Apply disable flags */
-			if(disable_s1) {
-				scan_mode1 = FALSE;
-			}
-			if(disable_s2) {
-				scan_mode2 = FALSE;
-			}
+				t = alloc_transponder(f);
 
-			/* Both modes should be scanned */
-			if(scan_mode1 && scan_mode2) {
-				/* Set current transponder to DVB-S delivery */
-				t->delivery_system = SYS_DVBS;
+				t->delivery_system = delset[idel];
+				t->modulation = modset[imod];
+				t->rolloff = rolset[irol];
+				t->fec = fecset[ifec];
 
-				/* create new transponder for the second mode */
-				t2 = alloc_transponder(f);
-				/* copy all parameters from original transponder */
-				copy_transponder(t2, t);
-				/* set second transponder to DVB-S2 */
-				t2->delivery_system = SYS_DVBS2;
+				switch(pol[0]) 
+				{
+				case 'H':
+				case 'L':
+					t->polarisation = POLARISATION_HORIZONTAL;
+					break;
+				default:
+					t->polarisation = POLARISATION_VERTICAL;;
+					break;
+				}
+				t->inversion = spectral_inversion;
+				t->symbol_rate = sr;
 
 				info("initial transponder DVB-S%s %u %c %d %s %s %s\n",
 					t->delivery_system==SYS_DVBS?" ":"2",
 					t->frequency,
 					pol[0], t->symbol_rate, fec2str(t->fec), rolloff2str(t->rolloff), qam2str(t->modulation));
-
-				/* change the main pointer so the second added transponder will be printed */
-				t = t2;
-			}
-			else { /* only one system should be used */
-				if(scan_mode1) {
-					t->delivery_system = SYS_DVBS;
-				}
-				else if(scan_mode2) {
-					t->delivery_system = SYS_DVBS2;
-				}
-			}
-
-			info("initial transponder DVB-S%s %u %c %d %s %s %s\n",
-				t->delivery_system==SYS_DVBS?" ":"2",
-				t->frequency,
-				pol[0], t->symbol_rate, fec2str(t->fec), rolloff2str(t->rolloff), qam2str(t->modulation));
+			}}}}
 		}
 		else if (sscanf(buf, "C %u %u %4s %6s\n", &f, &sr, fec, qam) >= 2) {
 			t = alloc_transponder(f);
@@ -2553,7 +2578,10 @@ static const char *usage = "\n"
 "	-D s	Disable specified scan mode (by default all modes are enabled)\n"
 "		s=S1  Disable DVB-S scan\n"
 "		s=S2  Disable DVB-S2 scan (good for owners of cards that do not\n"
-"		      support DVB-S2 systems)\n";
+"		      support DVB-S2 systems)\n"
+"	-X	Disable AUTOs for initial transponders (esp. for hardware which\n"
+"		not support it). Instead try each value of any free parameters.\n";
+
 
 void bad_usage(char *pname, int problem)
 {
@@ -2606,7 +2634,7 @@ int main (int argc, char **argv)
 
 	/* start with default lnb type */
 	lnb_type = *lnb_enum(0);
-	while ((opt = getopt(argc, argv, "5cnpa:f:d:O:k:I:S:s:r:R:o:D:x:t:i:l:vquPA:U")) != -1) {
+	while ((opt = getopt(argc, argv, "5cnXpa:f:d:O:k:I:S:s:r:R:o:D:x:t:i:l:vquPA:U")) != -1) {
 		switch (opt) 
 		{
 		case 'a':
@@ -2621,6 +2649,10 @@ int main (int argc, char **argv)
 
 		case 'n':
 			get_other_nits = 1;
+			break;
+
+		case 'X':
+			noauto = 1;
 			break;
 
 		case 'd':

--========GMX273581226617487520824
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--========GMX273581226617487520824--
