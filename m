Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:41779 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755957AbZGNV4r (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Jul 2009 17:56:47 -0400
Cc: linux-media@vger.kernel.org, hftom@free.fr,
	christophpfister@gmail.com
Content-Transfer-Encoding: 7bit
Content-Type: multipart/mixed; boundary="========GMX51371247608603161065"
Date: Tue, 14 Jul 2009 23:56:43 +0200
From: "Hans Werner" <HWerner4@gmx.de>
Message-ID: <20090714215643.51370@gmx.net>
MIME-Version: 1.0
Subject: AW: [BUG][PATCH] kaffeine 0.8.8 USALS/GotoX problem
To: "Jesko Schwarzer" <jesko.schwarzer@jena-optronik.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--========GMX51371247608603161065
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

> There is a bug in DvbStream::gotoX in Kaffeine 0.8.8, which is fixed by
> the
> attached patch.
> 
> Look for example at what happens when azimuth = 15.951. The motor should
> be
> driven to 16.0 degrees, but when 15.951 is rounded up with if (USALS>0.5)
> ++rd; the carries into the upper nibble of CMD2 and the lower nibble of
> CMD1 are not handled properly. The result is CMD1 represents 0 instead of
> 16
> degrees and CMD2 is undefined, being set by the non-existent 11th element
> of
> DecimalLookup.
> 
> The patch fixes it, and I also took the opportunity to fix the strange
> division by while loops.
> 
> Regards,
> Hans


-------- Original-Nachricht --------
> Datum: Tue, 14 Jul 2009 16:17:30 +0200
> Von: "Jesko Schwarzer" <jesko.schwarzer@jena-optronik.de>
> An: "\'Hans Werner\'" <HWerner4@gmx.de>, linux-media@vger.kernel.org
> Betreff: AW: [BUG][PATCH] kaffeine 0.8.8 USALS/GotoX problem

> Hello Hans,
> 
> I looked into the patch - just to be informed what's going on and got
> confused by such code.
> I reimplemented it to test it against side effects and still do not
> understand why it is written so complicated. Sure, I don't know the
> environment of the code, but does it matter in this case ?
> 
> If you like try these few lines (the last 3 lines) as a replacement:
> 
> 	unsigned long USALS;
> 	int CMD1;
> 	int CMD2;
> 
>  	if ( azimuth>0.0 )
> 		CMD1 = 0xE0;    // East
>  	else
> 		CMD1 = 0xD0;    // West
> 
> /*-----------------------------------------------*/
> 	USALS = ( fabs( azimuth ) * 16.0 + 0.5 );
> 	CMD1 |= ( USALS & 0xf00 ) >> 8;
> 	CMD2  = ( USALS & 0x0ff );
> /*-----------------------------------------------*/
> 
> Regards
> /Jesko

Hi Jesko,

thanks for looking at it. I see the main difference in your
version is that there is no DecimalLookup for the bottom 4 bits.

I took a look at the Eutelsat specs here:
http://www.eutelsat.com/satellites/pdf/Diseqc/associated%20docs/positioner_appli_notice.pdf

The relevant section is 3.10.

Reading that I see that the lower four bits should never have
been coded with DecimalLookup at all !! The 12-bit value should be
a true binary fraction (not any coded form of decimal) representing
the angle to a precision of 1/16th of a degree.

Whoever originally wrote the routine may have misinterpreted Table 2 
which shows a lookup table converting the lower 4 bits of CMD2 to 
decimal, just for people who want to make STB displays and data entry
limited to just 0.1 degree accuracy.

So I think your version of the routine is correct. Mine differs
sometimes by 1/16th of a degree (not perceptible with my equipment),
and is the same otherwise.

I have attached a new version of the patch. I compiled and tested
with my rotor and confirmed it works. 

Regards,
Hans




-- 
Release early, release often.

Jetzt kostenlos herunterladen: Internet Explorer 8 und Mozilla Firefox 3 -
sicherer, schneller und einfacher! http://portal.gmx.net/de/go/atbrowser

--========GMX51371247608603161065
Content-Type: text/x-patch; charset="iso-8859-15"; name="usals_bug_fix2.diff"
Content-Transfer-Encoding: 8bit
Content-Disposition: attachment; filename="usals_bug_fix2.diff"

--- dvbstream.cpp.orig	
+++ dvbstream.cpp
@@ -758,31 +758,20 @@
 
 void DvbStream::gotoX( double azimuth )
 {
-	double USALS=0.0;
+	unsigned long USALS;
 	int CMD1=0x00, CMD2=0x00;
-	int DecimalLookup[10] = { 0x00, 0x02, 0x03, 0x05, 0x06, 0x08, 0x0A, 0x0B, 0x0D, 0x0E };
 
+	//rotation direction
 	if ( azimuth>0.0 )
 		CMD1 = 0xE0;    // East
 	else
 		CMD1 = 0xD0;      // West
 
-	USALS = fabs( azimuth );
-
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
-	CMD2+= DecimalLookup[rd];
+	//angle : 12 bits with a precision of 1/16th of a degree
+	//a true binary fraction, NOT binary coded decimal
+	USALS = ( fabs(azimuth)*16 + 0.5 );
+	CMD1 |= (USALS & 0xf00) >> 8;
+	CMD2  = (USALS & 0x0ff);
 
 	rotorCommand( 12, CMD1, CMD2 );
 }

--========GMX51371247608603161065--
