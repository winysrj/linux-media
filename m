Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:60926 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751256Ab2EHIH5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 8 May 2012 04:07:57 -0400
Received: by bkcji2 with SMTP id ji2so4342205bkc.19
        for <linux-media@vger.kernel.org>; Tue, 08 May 2012 01:07:56 -0700 (PDT)
From: "Igor M. Liplianin" <liplianin@me.by>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 2/2] TeVii DVB-S s421 and s632 cards support, rs2000 part
Date: Tue, 08 May 2012 11:08:04 +0300
Message-ID: <11624830.SAH8sWiIMs@useri>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="nextPart1581280.HiNoaCvprz"
Content-Transfer-Encoding: 7Bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--nextPart1581280.HiNoaCvprz
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

One register needs to be changed to TS to work. So we use separate inittab.

Signed-off-by: Igor M. Liplianin <liplianin@me.by>

--nextPart1581280.HiNoaCvprz
Content-Disposition: inline; filename="rs2000dw2102.patch"
Content-Transfer-Encoding: 7Bit
Content-Type: text/x-patch; charset="UTF-8"; name="rs2000dw2102.patch"

diff --git a/drivers/media/dvb/frontends/m88rs2000.c b/drivers/media/dvb/frontends/m88rs2000.c
index 045ee5a..547230d 100644
--- a/drivers/media/dvb/frontends/m88rs2000.c
+++ b/drivers/media/dvb/frontends/m88rs2000.c
@@ -442,7 +442,11 @@ static int m88rs2000_init(struct dvb_frontend *fe)
 
 	deb_info("m88rs2000: init chip\n");
 	/* Setup frontend from shutdown/cold */
-	ret = m88rs2000_tab_set(state, m88rs2000_setup);
+	if (state->config->inittab)
+		ret = m88rs2000_tab_set(state,
+				(struct inittab *)state->config->inittab);
+	else
+		ret = m88rs2000_tab_set(state, m88rs2000_setup);
 
 	return ret;
 }

--nextPart1581280.HiNoaCvprz--

