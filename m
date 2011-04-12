Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:5442 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757115Ab1DLXqN (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 12 Apr 2011 19:46:13 -0400
Message-ID: <4DA4E440.7090008@redhat.com>
Date: Tue, 12 Apr 2011 20:46:08 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
	wk <handygewinnspiel@gmx.de>
Subject: [PATCH dvb-apps] Avoid buffer overflow with UTF-8 32-bit strings
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

As Winfried <handygewinnspiel@gmx.de> pointed, me UTF-8 can have up to 
32 bits.

Also, someone might want to convert data to UCS-4, So, the buffer need to 
have 4 bytes per char, to be safe.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/util/scan/scan.c b/util/scan/scan.c
--- a/util/scan/scan.c
+++ b/util/scan/scan.c
@@ -884,7 +884,7 @@ static void descriptorcpy(char **dest, c
 	 * Destination length should be bigger. As the worse case seems to
 	 * use 3 chars for one code, use it for destlen
 	 */
-	destlen = len * 3;
+	destlen = len * 4;
 	*dest = malloc(destlen + 1);
 
 	/* Remove special chars */
