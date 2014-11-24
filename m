Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f51.google.com ([209.85.215.51]:34534 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751400AbaKXHBI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 24 Nov 2014 02:01:08 -0500
Received: by mail-la0-f51.google.com with SMTP id mc6so7124182lab.10
        for <linux-media@vger.kernel.org>; Sun, 23 Nov 2014 23:01:05 -0800 (PST)
From: Olli Salonen <olli.salonen@iki.fi>
To: linux-media@vger.kernel.org
Cc: Olli Salonen <olli.salonen@iki.fi>
Subject: [PATCH 3/4] si2157: make checkpatch.pl happy (remove break after goto)
Date: Mon, 24 Nov 2014 08:57:35 +0200
Message-Id: <1416812256-27894-3-git-send-email-olli.salonen@iki.fi>
In-Reply-To: <1416812256-27894-1-git-send-email-olli.salonen@iki.fi>
References: <1416812256-27894-1-git-send-email-olli.salonen@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Break after goto is unnecessary.

Signed-off-by: Olli Salonen <olli.salonen@iki.fi>
---
 drivers/media/tuners/si2157.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/media/tuners/si2157.c b/drivers/media/tuners/si2157.c
index a8f2edb9..3bdf00a 100644
--- a/drivers/media/tuners/si2157.c
+++ b/drivers/media/tuners/si2157.c
@@ -129,7 +129,6 @@ static int si2157_init(struct dvb_frontend *fe)
 	case SI2147_A30:
 	case SI2146_A10:
 		goto skip_fw_download;
-		break;
 	default:
 		dev_err(&s->client->dev,
 				"unknown chip version Si21%d-%c%c%c\n",
-- 
1.9.1

