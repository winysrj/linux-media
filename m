Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f177.google.com ([209.85.217.177]:34098 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756983AbbCCQ2r (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 3 Mar 2015 11:28:47 -0500
Received: by lbiv13 with SMTP id v13so19649218lbi.1
        for <linux-media@vger.kernel.org>; Tue, 03 Mar 2015 08:28:45 -0800 (PST)
From: Olli Salonen <olli.salonen@iki.fi>
To: linux-media@vger.kernel.org
Cc: Olli Salonen <olli.salonen@iki.fi>
Subject: [PATCH] si2157: extend frequency range for ATSC
Date: Tue,  3 Mar 2015 18:28:35 +0200
Message-Id: <1425400115-19056-1-git-send-email-olli.salonen@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The Si2157 tuner supports ATSC in addition to DVB-T and DVB-C. Extend 
minimum frequency range to cover the complete ATSC/QAM-B range.

Signed-off-by: Olli Salonen <olli.salonen@iki.fi>
---
 drivers/media/tuners/si2157.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/tuners/si2157.c b/drivers/media/tuners/si2157.c
index d8309b9..d74ae26 100644
--- a/drivers/media/tuners/si2157.c
+++ b/drivers/media/tuners/si2157.c
@@ -349,7 +349,7 @@ static int si2157_get_if_frequency(struct dvb_frontend *fe, u32 *frequency)
 static const struct dvb_tuner_ops si2157_ops = {
 	.info = {
 		.name           = "Silicon Labs Si2146/2147/2148/2157/2158",
-		.frequency_min  = 110000000,
+		.frequency_min  = 55000000,
 		.frequency_max  = 862000000,
 	},
 
-- 
1.9.1

