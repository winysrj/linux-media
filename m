Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f196.google.com ([209.85.128.196]:40277 "EHLO
        mail-wr0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751708AbeFWPgf (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 23 Jun 2018 11:36:35 -0400
Received: by mail-wr0-f196.google.com with SMTP id g18-v6so9409703wro.7
        for <linux-media@vger.kernel.org>; Sat, 23 Jun 2018 08:36:34 -0700 (PDT)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: mchehab@kernel.org, mchehab@s-opensource.com
Cc: linux-media@vger.kernel.org
Subject: [PATCH 18/19] [media] ddbridge/sx8: enable modulation selection in set_parameters()
Date: Sat, 23 Jun 2018 17:36:14 +0200
Message-Id: <20180623153615.27630-19-d.scheller.oss@gmail.com>
In-Reply-To: <20180623153615.27630-1-d.scheller.oss@gmail.com>
References: <20180623153615.27630-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

Allow for tuning to transponders with specific modulations in
set_parameters(). Setting a specific modulation will also enable lower
modulations.

Picked up from the upstream dddvb GIT. Upstream also has support for
APSK64/128/256 modulations which aren't supported yet by the DVB
API, so comment them out until support for them is added.

Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
---
 drivers/media/pci/ddbridge/ddbridge-sx8.c | 30 +++++++++++++++++++++++-------
 1 file changed, 23 insertions(+), 7 deletions(-)

diff --git a/drivers/media/pci/ddbridge/ddbridge-sx8.c b/drivers/media/pci/ddbridge/ddbridge-sx8.c
index c87cefa10762..4418604258d1 100644
--- a/drivers/media/pci/ddbridge/ddbridge-sx8.c
+++ b/drivers/media/pci/ddbridge/ddbridge-sx8.c
@@ -372,15 +372,31 @@ static int set_parameters(struct dvb_frontend *fe)
 	if (iq_mode)
 		ts_config = (SX8_TSCONFIG_TSHEADER | SX8_TSCONFIG_MODE_IQ);
 	if (iq_mode < 3) {
-		u32 flags = 3;
-		u32 mask = 0x7f;
-
-		if (p->modulation == APSK_16 ||
-		    p->modulation == APSK_32) {
-			flags = 2;
+		u32 mask;
+
+		switch (p->modulation) {
+		/* uncomment whenever these modulations hit the DVB API
+		 *	case APSK_256:
+		 *		mask = 0x7f;
+		 *		break;
+		 *	case APSK_128:
+		 *		mask = 0x3f;
+		 *		break;
+		 *	case APSK_64:
+		 *		mask = 0x1f;
+		 *		break;
+		 */
+		case APSK_32:
 			mask = 0x0f;
+			break;
+		case APSK_16:
+			mask = 0x07;
+			break;
+		default:
+			mask = 0x03;
+			break;
 		}
-		stat = start(fe, flags, mask, ts_config);
+		stat = start(fe, 3, mask, ts_config);
 	} else {
 		u32 flags = (iq_mode == 2) ? 1 : 0;
 
-- 
2.16.4
