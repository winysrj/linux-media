Return-path: <linux-media-owner@vger.kernel.org>
Received: from dell.nexicom.net ([216.168.96.13]:57323 "EHLO smtp.nexicom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753741Ab1JaQmi (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 31 Oct 2011 12:42:38 -0400
Received: from mail.lockie.ca (dyn-dsl-mb-216-168-118-207.nexicom.net [216.168.118.207])
	by smtp.nexicom.net (8.13.6/8.13.4) with ESMTP id p9VGgWZ9022374
	for <linux-media@vger.kernel.org>; Mon, 31 Oct 2011 12:42:34 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by mail.lockie.ca (Postfix) with ESMTP id 543E71E01A7
	for <linux-media@vger.kernel.org>; Mon, 31 Oct 2011 12:42:31 -0400 (EDT)
Message-ID: <4EAECFF7.5030902@lockie.ca>
Date: Mon, 31 Oct 2011 12:42:31 -0400
From: James <bjlockie@lockie.ca>
MIME-Version: 1.0
CC: linux-media Mailing List <linux-media@vger.kernel.org>
Subject: Re: femon patch for dB
References: <4EAB342F.2020008@lockie.ca> <201110290221.05015.marek.vasut@gmail.com> <4EAB612A.6010003@xenotime.net> <4EAB8B5A.5040908@lockie.ca> <4EAB919A.6020401@xenotime.net> <4EAB9F41.40208@redhat.com> <CAOcJUbzLrRGa8MvziFd_OLaJEUyzXgjK-w4vL95gykOwz5otHQ@mail.gmail.com> <CAOcJUbw4512cswquogyUg19QXm=sKcsPQGsBty6+738f9mnvkw@mail.gmail.com>
In-Reply-To: <CAOcJUbw4512cswquogyUg19QXm=sKcsPQGsBty6+738f9mnvkw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 10/30/11 10:01, Michael Krufky wrote:
> The patch is actually OK with me, except that i disagree
> with the -2 parameter choice.  I propose instead, to use a lowercase
> 'h' ...


diff -r d4e8bf5658ce util/femon/femon.c
--- a/util/femon/femon.c	Fri Oct 07 01:26:04 2011 +0530
+++ b/util/femon/femon.c	Mon Oct 31 12:29:14 2011 -0400
@@ -16,6 +16,9 @@
  * You should have received a copy of the GNU General Public License
  * along with this program; if not, write to the Free Software
  * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ *
+ * James Lockie: Oct. 2011
+ * modified to add a switch (-h) to show signal/snr in dB
  */
 
 
@@ -37,11 +40,16 @@
 
 #include <libdvbapi/dvbfe.h>
 
+/* the s5h1409 delivers both fields in 0.1dB increments, while
+ * some demods expect signal to be 0-65535 and SNR to be in 1/256 increments
+*/
+
 #define FE_STATUS_PARAMS (DVBFE_INFO_LOCKSTATUS|DVBFE_INFO_SIGNAL_STRENGTH|DVBFE_INFO_BER|DVBFE_INFO_SNR|DVBFE_INFO_UNCORRECTED_BLOCKS)
 
 static char *usage_str =
     "\nusage: femon [options]\n"
-    "     -H        : human readable output\n"
+    "     -H        : human readable output: (signal: 0-65335, snr: 1/256 increments)\n"
+    "     -h        : human readable output: (signal and snr in .1 dB increments)\n"
     "     -A        : Acoustical mode. A sound indicates the signal quality.\n"
     "     -r        : If 'Acoustical mode' is active it tells the application\n"
     "                 is called remotely via ssh. The sound is heard on the 'real'\n"
@@ -62,7 +70,7 @@
 
 
 static
-int check_frontend (struct dvbfe_handle *fe, int human_readable, unsigned int count)
+int check_frontend (struct dvbfe_handle *fe, int human_readable, int db_readable, unsigned int count)
 {
 	struct dvbfe_info fe_info;
 	unsigned int samples = 0;
@@ -93,31 +101,32 @@
 			fprintf(stderr, "Problem retrieving frontend information: %m\n");
 		}
 
+		//  print the status code
+		printf ("status %c%c%c%c%c | ",
+			fe_info.signal ? 'S' : ' ',
+			fe_info.carrier ? 'C' : ' ',
+			fe_info.viterbi ? 'V' : ' ',
+			fe_info.sync ? 'Y' : ' ',
+			fe_info.lock ? 'L' : ' ' );
 
+		if (db_readable) {
+                       printf ("signal %3.0fdB | snr %3.0fdB",
+				(fe_info.signal_strength * 0.1),
+				(fe_info.snr * 0.1) );
+		} else if (human_readable) {
+                       printf ("signal %3u%% | snr %3u%%",
+				(fe_info.signal_strength * 100) / 0xffff,
+				(fe_info.snr * 100) / 0xffff );
+		} else {
+			printf ("signal %04x | snr %04x",
+				fe_info.signal_strength,
+				fe_info.snr );
+		}
 
-		if (human_readable) {
-                       printf ("status %c%c%c%c%c | signal %3u%% | snr %3u%% | ber %d | unc %d | ",
-				fe_info.signal ? 'S' : ' ',
-				fe_info.carrier ? 'C' : ' ',
-				fe_info.viterbi ? 'V' : ' ',
-				fe_info.sync ? 'Y' : ' ',
-				fe_info.lock ? 'L' : ' ',
-				(fe_info.signal_strength * 100) / 0xffff,
-				(fe_info.snr * 100) / 0xffff,
-				fe_info.ber,
-				fe_info.ucblocks);
-		} else {
-			printf ("status %c%c%c%c%c | signal %04x | snr %04x | ber %08x | unc %08x | ",
-				fe_info.signal ? 'S' : ' ',
-				fe_info.carrier ? 'C' : ' ',
-				fe_info.viterbi ? 'V' : ' ',
-				fe_info.sync ? 'Y' : ' ',
-				fe_info.lock ? 'L' : ' ',
-				fe_info.signal_strength,
-				fe_info.snr,
-				fe_info.ber,
-				fe_info.ucblocks);
-		}
+		/* always print ber and ucblocks */
+		printf (" | ber %08x | unc %08x | ",
+			fe_info.ber,
+			fe_info.ucblocks);
 
 		if (fe_info.lock)
 			printf("FE_HAS_LOCK");
@@ -145,7 +154,7 @@
 
 
 static
-int do_mon(unsigned int adapter, unsigned int frontend, int human_readable, unsigned int count)
+int do_mon(unsigned int adapter, unsigned int frontend, int human_readable, int db_readable, unsigned int count)
 {
 	int result;
 	struct dvbfe_handle *fe;
@@ -175,7 +184,7 @@
 	}
 	printf("FE: %s (%s)\n", fe_info.name, fe_type);
 
-	result = check_frontend (fe, human_readable, count);
+	result = check_frontend (fe, human_readable, db_readable, count);
 
 	dvbfe_close(fe);
 
@@ -186,9 +195,10 @@
 {
 	unsigned int adapter = 0, frontend = 0, count = 0;
 	int human_readable = 0;
+	int db_readable = 0;
 	int opt;
 
-       while ((opt = getopt(argc, argv, "rAHa:f:c:")) != -1) {
+       while ((opt = getopt(argc, argv, "rAHha:f:c:")) != -1) {
 		switch (opt)
 		{
 		default:
@@ -206,6 +216,9 @@
 		case 'H':
 			human_readable = 1;
 			break;
+		case 'h':
+			db_readable = 1;
+			break;
 		case 'A':
 			// Acoustical mode: we have to reduce the delay between
 			// checks in order to hear nice sound
@@ -218,7 +231,7 @@
 		}
 	}
 
-	do_mon(adapter, frontend, human_readable, count);
+	do_mon(adapter, frontend, human_readable, db_readable, count);
 
 	return 0;
 }


On 10/30/11 11:42, Antti Palosaari wrote:
> 
> 
> You should take look to demod drivers and check what those are returning. I have strong feeling that most drivers returns SNR as 10xdB. And SS as 0-0xffff. I think there is good consensus of SNR unit, but for SS it is not so clear. For my drivers I have used SNR 10xdB and SS 0-0xffff. That's why, giving only those two alternatives is not suitable. Maybe it is better to set own param for SNR and SS?

Good point.

