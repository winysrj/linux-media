Return-path: <mchehab@pedra>
Received: from chybek.jannau.net ([83.169.20.219]:53722 "EHLO
	chybek.jannau.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757552Ab1COMbR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 15 Mar 2011 08:31:17 -0400
Date: Tue, 15 Mar 2011 13:32:58 +0100
From: Janne Grunau <j@jannau.net>
To: Christian Ulrich <chrulri@gmail.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH] DVB-APPS: azap gets -p argument
Message-ID: <20110315123258.GA6570@aniel>
References: <AANLkTimexhCMBSd7UNr1gizgbnarwS9kucZC0nWSBJxX@mail.gmail.com>
 <20110315121126.GD8113@aniel>
 <AANLkTingP4tLViGTMvKeBM4XNj-cRZtqECh4WjLgZM40@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="ibTvN161/egqYuK8"
Content-Disposition: inline
In-Reply-To: <AANLkTingP4tLViGTMvKeBM4XNj-cRZtqECh4WjLgZM40@mail.gmail.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>


--ibTvN161/egqYuK8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Mar 15, 2011 at 01:23:40PM +0100, Christian Ulrich wrote:
> Hi, thank you for your feedback.
> 
> Indeed, I never used -r alone, but only with -p.
> So with your patch, [acst]zap -r will be the same as -rp. That looks good to me.

well, azap not yet. iirc I implemented -p for azap but it was never
applied since nobody tested it. see attached patch for [cst]zap

Janne

--ibTvN161/egqYuK8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="dvb_apps_cstzap_always_record_pat_pmt.diff"

diff -r 4746d76ae4b6 util/szap/czap.c
--- a/util/szap/czap.c	Sat Mar 05 18:39:58 2011 +0100
+++ b/util/szap/czap.c	Tue Mar 15 13:32:29 2011 +0100
@@ -253,7 +253,7 @@
     "     -x        : exit after tuning\n"
     "     -H        : human readable output\n"
     "     -r        : set up /dev/dvb/adapterX/dvr0 for TS recording\n"
-    "     -p        : add pat and pmt to TS recording (implies -r)\n"
+    "     -p        : obsolete (pat and pmt will always be included with -r)\n"
 ;
 
 int main(int argc, char **argv)
@@ -279,8 +279,11 @@
 		case 'd':
 			demux = strtoul(optarg, NULL, 0);
 			break;
+		case 'p':
+			printf("'-p' is obsolete. '-r' records PAT/PMT");
 		case 'r':
 			dvr = 1;
+			rec_psi = 1;
 			break;
 		case 'l':
 			list_channels = 1;
@@ -288,9 +291,6 @@
 		case 'n':
 			chan_no = strtoul(optarg, NULL, 0);
 			break;
-		case 'p':
-			rec_psi = 1;
-			break;
 		case 'x':
 			exit_after_tuning = 1;
 			break;
diff -r 4746d76ae4b6 util/szap/szap.c
--- a/util/szap/szap.c	Sat Mar 05 18:39:58 2011 +0100
+++ b/util/szap/szap.c	Tue Mar 15 13:32:29 2011 +0100
@@ -547,8 +547,11 @@
 	 case 'q':
 	    list_channels = 1;
 	    break;
+	 case 'p':
+	    printf("'-p' is obsolete. '-r' records PAT/PMT");
 	 case 'r':
 	    dvr = 1;
+	    rec_psi = 1;
 	    break;
 	 case 'n':
 	    chan_no = strtoul(optarg, NULL, 0);
@@ -559,9 +562,6 @@
 	 case 'f':
 	    frontend = strtoul(optarg, NULL, 0);
 	    break;
-	 case 'p':
-	    rec_psi = 1;
-	    break;
 	 case 'd':
 	    demux = strtoul(optarg, NULL, 0);
 	    break;
diff -r 4746d76ae4b6 util/szap/tzap.c
--- a/util/szap/tzap.c	Sat Mar 05 18:39:58 2011 +0100
+++ b/util/szap/tzap.c	Tue Mar 15 13:32:29 2011 +0100
@@ -485,7 +485,7 @@
     "     -c file   : read channels list from 'file'\n"
     "     -x        : exit after tuning\n"
     "     -r        : set up /dev/dvb/adapterX/dvr0 for TS recording\n"
-    "     -p        : add pat and pmt to TS recording (implies -r)\n"
+    "     -p        : obsolete (pat and pmt will always be included with -r)\n"
     "     -s        : only print summary\n"
     "     -S        : run silently (no output)\n"
     "     -H        : human readable output\n"
@@ -529,10 +529,10 @@
 			filename = strdup(optarg);
 			record=1;
 			/* fall through */
+		case 'p':
+			printf("'-p' is obsolete. '-r' records PAT/PMT");
 		case 'r':
 			dvr = 1;
-			break;
-		case 'p':
 			rec_psi = 1;
 			break;
 		case 'x':

--ibTvN161/egqYuK8--
