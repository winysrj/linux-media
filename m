Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.mujha-vel.cz ([81.30.225.246]:39565 "EHLO
	smtp.mujha-vel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752532Ab0BJXcr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Feb 2010 18:32:47 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: mchehab@redhat.com
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	jirislaby@gmail.com, Matthias Benesch <twoof7@freenet.de>,
	Ralph Metzler <rjkm@metzlerbros.de>,
	Oliver Endriss <o.endriss@gmx.de>
Subject: [PATCH 1/1] DVB: ngene, fix memset parameters
Date: Thu, 11 Feb 2010 00:32:42 +0100
Message-Id: <1265844762-17730-1-git-send-email-jslaby@suse.cz>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Switch second and third memset parameter to stamp the length buffer bytes
by 0xff's, not 255 bytes by low 8 bits of Length.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Matthias Benesch <twoof7@freenet.de>
Cc: Ralph Metzler <rjkm@metzlerbros.de>
Cc: Oliver Endriss <o.endriss@gmx.de>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/dvb/ngene/ngene-core.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/dvb/ngene/ngene-core.c b/drivers/media/dvb/ngene/ngene-core.c
index cb5982e..0150dfe 100644
--- a/drivers/media/dvb/ngene/ngene-core.c
+++ b/drivers/media/dvb/ngene/ngene-core.c
@@ -564,7 +564,7 @@ static void FillTSBuffer(void *Buffer, int Length, u32 Flags)
 {
 	u32 *ptr = Buffer;
 
-	memset(Buffer, Length, 0xff);
+	memset(Buffer, 0xff, Length);
 	while (Length > 0) {
 		if (Flags & DF_SWAP32)
 			*ptr = 0x471FFF10;
-- 
1.6.6.1

