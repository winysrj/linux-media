Return-path: <mchehab@pedra>
Received: from mailout-de.gmx.net ([213.165.64.22]:43544 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1756907Ab0JEJxe (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 5 Oct 2010 05:53:34 -0400
Received: from lyakh (helo=localhost)
	by axis700.grange with local-esmtp (Exim 4.63)
	(envelope-from <g.liakhovetski@gmx.de>)
	id 1P34DR-0007vq-Po
	for linux-media@vger.kernel.org; Tue, 05 Oct 2010 11:53:45 +0200
Date: Tue, 5 Oct 2010 11:53:45 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 1/2] V4L: add IMX074 sensor chip ID
In-Reply-To: <Pine.LNX.4.64.1010041801060.5668@axis700.grange>
Message-ID: <Pine.LNX.4.64.1010051145090.28567@axis700.grange>
References: <Pine.LNX.4.64.1010041801060.5668@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Chip identification register contains the value 0x74.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
diff --git a/include/media/v4l2-chip-ident.h b/include/media/v4l2-chip-ident.h
index 1c612b4..aeb4ff9 100644
--- a/include/media/v4l2-chip-ident.h
+++ b/include/media/v4l2-chip-ident.h
@@ -38,6 +38,9 @@ enum {
 	/* module tvaudio: reserved range 50-99 */
 	V4L2_IDENT_TVAUDIO = 50,	/* A tvaudio chip, unknown which it is exactly */
 
+	/* Sony IMX074 */
+	V4L2_IDENT_IMX074 = 74,
+
 	/* module saa7110: just ident 100 */
 	V4L2_IDENT_SAA7110 = 100,
 
