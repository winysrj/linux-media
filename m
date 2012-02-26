Return-path: <linux-media-owner@vger.kernel.org>
Received: from swampdragon.chaosbits.net ([90.184.90.115]:22143 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752928Ab2BZW7R (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 26 Feb 2012 17:59:17 -0500
Date: Sun, 26 Feb 2012 23:57:13 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: linux-kernel@vger.kernel.org
cc: trivial@kernel.org, linux-media@vger.kernel.org,
	Olivier Grenie <olivier.grenie@dibcom.fr>,
	Patrick Boettcher <patrick.boettcher@dibcom.fr>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH][trivial] media, DiB0090: remove redundant ';' from
 dib0090_fw_identify()
Message-ID: <alpine.LNX.2.00.1202262355210.6089@swampdragon.chaosbits.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

One semi-colon is enough.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 drivers/media/dvb/frontends/dib0090.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/dvb/frontends/dib0090.c b/drivers/media/dvb/frontends/dib0090.c
index 224d81e..d9fe60b 100644
--- a/drivers/media/dvb/frontends/dib0090.c
+++ b/drivers/media/dvb/frontends/dib0090.c
@@ -519,7 +519,7 @@ static int dib0090_fw_identify(struct dvb_frontend *fe)
 	return 0;
 
 identification_error:
-	return -EIO;;
+	return -EIO;
 }
 
 static void dib0090_reset_digital(struct dvb_frontend *fe, const struct dib0090_config *cfg)
-- 
1.7.9.2


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

