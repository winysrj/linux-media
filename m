Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:56749 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753560AbZGMXUp (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 13 Jul 2009 19:20:45 -0400
Content-Type: multipart/mixed; boundary="========GMX31537124752724368023"
Date: Tue, 14 Jul 2009 01:20:43 +0200
From: "Hans Werner" <HWerner4@gmx.de>
Message-ID: <20090713232043.315370@gmx.net>
MIME-Version: 1.0
Subject: [BUG][PATCH] kaffeine 0.8.8 USALS/GotoX problem
To: linux-media@vger.kernel.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--========GMX31537124752724368023
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8bit

There is a bug in DvbStream::gotoX in Kaffeine 0.8.8,
which is fixed by the attached patch.

Look for example at what happens when azimuth = 15.951. The
motor should be driven to 16.0 degrees, but when 15.951 is
rounded up with
if (USALS>0.5) ++rd; 
the carries into the upper nibble of CMD2 and the lower nibble of
CMD1 are not handled properly. The result is CMD1 represents 0
instead of 16 degrees and CMD2 is undefined, being set by the
non-existent 11th element of DecimalLookup.

The patch fixes it, and I also took the opportunity to fix the
strange division by while loops.

Regards,
Hans

-- 
GRATIS für alle GMX-Mitglieder: Die maxdome Movie-FLAT!
Jetzt freischalten unter http://portal.gmx.net/de/go/maxdome01

--========GMX31537124752724368023
Content-Type: text/x-patch; charset="iso-8859-15"; name="usals_bug_fix.diff"
Content-Transfer-Encoding: 8bit
Content-Disposition: attachment; filename="usals_bug_fix.diff"

--- dvbstream.cpp.orig
+++ dvbstream.cpp
@@ -758,30 +758,26 @@
 
 void DvbStream::gotoX( double azimuth )
 {
-	double USALS=0.0;
+	int USALS;
 	int CMD1=0x00, CMD2=0x00;
 	int DecimalLookup[10] = { 0x00, 0x02, 0x03, 0x05, 0x06, 0x08, 0x0A, 0x0B, 0x0D, 0x0E };
 
+	//high nibble of CMD1
 	if ( azimuth>0.0 )
 		CMD1 = 0xE0;    // East
 	else
 		CMD1 = 0xD0;      // West
 
-	USALS = fabs( azimuth );
+	USALS = ( fabs(azimuth)*10 + 0.5 );  // NB tenths of a degree
 
-	while (USALS > 16) {
-		CMD1++;
-		USALS-= 16;
-	}
-	while (USALS >= 1.0) {
-		CMD2+=0x10;
-		USALS--;
-	}
-	USALS*= 10.0;
-	int rd = (int)USALS;
-	USALS-= rd;
-	if ( USALS>0.5 )
-		++rd;
+	//low nibble of CMD1 : 16 degree steps
+	CMD1+=USALS/160;
+
+	//high nibble of CMD2 : 1 degree steps
+	CMD2=((USALS%160)/10)*0x10;
+
+	//low nibble of CMD2: 0.1 degree steps, coded as in DecimalLookup
+	int rd  = USALS%10;
 	CMD2+= DecimalLookup[rd];
 
 	rotorCommand( 12, CMD1, CMD2 );

--========GMX31537124752724368023--
