Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:32879 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751069AbaDOJcH (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 15 Apr 2014 05:32:07 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 05/10] si2157: extend frequency range for DVB-C
Date: Tue, 15 Apr 2014 12:31:41 +0300
Message-Id: <1397554306-14561-6-git-send-email-crope@iki.fi>
In-Reply-To: <1397554306-14561-1-git-send-email-crope@iki.fi>
References: <1397554306-14561-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

DVB-C uses lower frequencies than DVB-T. Extend frequency range down to
110 MHz in order to support DVB-C. 110 - 862 MHz range is defined by
NorDig Unified 2.2 specification.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/tuners/si2157.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/tuners/si2157.c b/drivers/media/tuners/si2157.c
index 953f2e3..5675448 100644
--- a/drivers/media/tuners/si2157.c
+++ b/drivers/media/tuners/si2157.c
@@ -155,7 +155,7 @@ err:
 static const struct dvb_tuner_ops si2157_tuner_ops = {
 	.info = {
 		.name           = "Silicon Labs Si2157",
-		.frequency_min  = 174000000,
+		.frequency_min  = 110000000,
 		.frequency_max  = 862000000,
 	},
 
-- 
1.9.0

