Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailgw2.jenoptik.com ([213.248.109.130]:15376 "EHLO
	mailgw2.jenoptik.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754782AbZGNO16 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Jul 2009 10:27:58 -0400
Date: Tue, 14 Jul 2009 16:17:30 +0200
From: "Jesko Schwarzer" <jesko.schwarzer@jena-optronik.de>
To: "'Hans Werner'" <HWerner4@gmx.de>, <linux-media@vger.kernel.org>
Message-ID: <"4430.36161247581063.hermes.jena-optronik.de*"@MHS>
In-Reply-To: <20090713232043.315370@gmx.net>
Subject: AW: [BUG][PATCH] kaffeine 0.8.8 USALS/GotoX problem
MIME-Version: 1.0
Content-Type: text/plain;
 	charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Hans,

I looked into the patch - just to be informed what's going on and got
confused by such code.
I reimplemented it to test it against side effects and still do not
understand why it is written so complicated. Sure, I don't know the
environment of the code, but does it matter in this case ?

If you like try these few lines (the last 3 lines) as a replacement:

	unsigned long USALS;
	int CMD1;
	int CMD2;

 	if ( azimuth>0.0 )
		CMD1 = 0xE0;    // East
 	else
		CMD1 = 0xD0;    // West

/*-----------------------------------------------*/
	USALS = ( fabs( azimuth ) * 16.0 + 0.5 );
	CMD1 |= ( USALS & 0xf00 ) >> 8;
	CMD2  = ( USALS & 0x0ff );
/*-----------------------------------------------*/

Regards
/Jesko

-----Ursprüngliche Nachricht-----
Von: linux-media-owner@vger.kernel.org
[mailto:linux-media-owner@vger.kernel.org] Im Auftrag von Hans Werner
Gesendet: Dienstag, 14. Juli 2009 01:21
An: linux-media@vger.kernel.org
Betreff: [BUG][PATCH] kaffeine 0.8.8 USALS/GotoX problem

There is a bug in DvbStream::gotoX in Kaffeine 0.8.8, which is fixed by the
attached patch.

Look for example at what happens when azimuth = 15.951. The motor should be
driven to 16.0 degrees, but when 15.951 is rounded up with if (USALS>0.5)
++rd; the carries into the upper nibble of CMD2 and the lower nibble of
CMD1 are not handled properly. The result is CMD1 represents 0 instead of 16
degrees and CMD2 is undefined, being set by the non-existent 11th element of
DecimalLookup.

The patch fixes it, and I also took the opportunity to fix the strange
division by while loops.

Regards,
Hans

--
GRATIS für alle GMX-Mitglieder: Die maxdome Movie-FLAT!
Jetzt freischalten unter http://portal.gmx.net/de/go/maxdome01

