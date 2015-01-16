Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f46.google.com ([209.85.215.46]:51734 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752039AbbAPMfi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 16 Jan 2015 07:35:38 -0500
Received: by mail-la0-f46.google.com with SMTP id ge10so8882818lab.5
        for <linux-media@vger.kernel.org>; Fri, 16 Jan 2015 04:35:37 -0800 (PST)
From: Olli Salonen <olli.salonen@iki.fi>
To: linux-media@vger.kernel.org
Cc: Olli Salonen <olli.salonen@iki.fi>
Subject: [PATCH 2/2] si2168: add support for 1.7MHz bandwidth
Date: Fri, 16 Jan 2015 14:35:20 +0200
Message-Id: <1421411720-2364-2-git-send-email-olli.salonen@iki.fi>
In-Reply-To: <1421411720-2364-1-git-send-email-olli.salonen@iki.fi>
References: <1421411720-2364-1-git-send-email-olli.salonen@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch is based on Antti's silabs branch.

Add support for 1.7 MHz bandwidth. Supported in all versions of Si2168 according to short data sheets.

Signed-off-by: Olli Salonen <olli.salonen@iki.fi>
---
 drivers/media/dvb-frontends/si2168.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/dvb-frontends/si2168.c b/drivers/media/dvb-frontends/si2168.c
index 7fef5ab..ec893ee 100644
--- a/drivers/media/dvb-frontends/si2168.c
+++ b/drivers/media/dvb-frontends/si2168.c
@@ -185,6 +185,8 @@ static int si2168_set_frontend(struct dvb_frontend *fe)
 		dev_err(&client->dev, "automatic bandwidth not supported");
 		goto err;
 	}
+	else if (c->bandwidth_hz <= 2000000)
+		bandwidth = 0x02;
 	else if (c->bandwidth_hz <= 5000000)
 		bandwidth = 0x05;
 	else if (c->bandwidth_hz <= 6000000)
-- 
1.9.1

