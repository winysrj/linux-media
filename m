Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53638 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755280Ab3DQAmw (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Apr 2013 20:42:52 -0400
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r3H0gqm6002325
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Tue, 16 Apr 2013 20:42:52 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH v2 28/31] [media] r820t: put it into automatic gain mode
Date: Tue, 16 Apr 2013 21:42:39 -0300
Message-Id: <1366159362-3773-29-git-send-email-mchehab@redhat.com>
In-Reply-To: <1366159362-3773-1-git-send-email-mchehab@redhat.com>
References: <1366159362-3773-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Currently, it is putting it on manual mode.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/tuners/r820t.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/media/tuners/r820t.c b/drivers/media/tuners/r820t.c
index c644e90..e63ee94 100644
--- a/drivers/media/tuners/r820t.c
+++ b/drivers/media/tuners/r820t.c
@@ -1216,12 +1216,12 @@ static int r820t_set_gain_mode(struct r820t_priv *priv,
 			return rc;
 	} else {
 		/* LNA */
-		rc = r820t_write_reg_mask(priv, 0x05, 0, 0xef);
+		rc = r820t_write_reg_mask(priv, 0x05, 0, 0x10);
 		if (rc < 0)
 			return rc;
 
 		/* Mixer */
-		rc = r820t_write_reg_mask(priv, 0x07, 0x10, 0xef);
+		rc = r820t_write_reg_mask(priv, 0x07, 0x10, 0x10);
 		if (rc < 0)
 			return rc;
 
@@ -1261,7 +1261,7 @@ static int generic_set_freq(struct dvb_frontend *fe,
 	if (rc < 0)
 		goto err;
 
-	rc = r820t_set_gain_mode(priv, true, 0);
+	rc = r820t_set_gain_mode(priv, false, 0);
 	if (rc < 0)
 		goto err;
 
-- 
1.8.1.4

