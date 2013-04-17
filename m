Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:23466 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755247Ab3DQAmx (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Apr 2013 20:42:53 -0400
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r3H0grfF002348
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Tue, 16 Apr 2013 20:42:53 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH v2 25/31] [media] r820t: Don't put it in standby if not initialized yet
Date: Tue, 16 Apr 2013 21:42:36 -0300
Message-Id: <1366159362-3773-26-git-send-email-mchehab@redhat.com>
In-Reply-To: <1366159362-3773-1-git-send-email-mchehab@redhat.com>
References: <1366159362-3773-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

r820t_standby() can be called before r820t_init().
If that happens, just do nothing.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/tuners/r820t.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/media/tuners/r820t.c b/drivers/media/tuners/r820t.c
index fc660f2..b679a3f 100644
--- a/drivers/media/tuners/r820t.c
+++ b/drivers/media/tuners/r820t.c
@@ -1298,6 +1298,10 @@ static int r820t_standby(struct r820t_priv *priv)
 {
 	int rc;
 
+	/* If device was not initialized yet, don't need to standby */
+	if (!priv->init_done)
+		return 0;
+
 	rc = r820t_write_reg(priv, 0x06, 0xb1);
 	if (rc < 0)
 		return rc;
-- 
1.8.1.4

