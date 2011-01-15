Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:51110 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752633Ab1AOQJd (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 15 Jan 2011 11:09:33 -0500
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id p0FG9WPH018091
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Sat, 15 Jan 2011 11:09:33 -0500
Received: from pedra (vpn-234-251.phx2.redhat.com [10.3.234.251])
	by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id p0FG5PXw001803
	for <linux-media@vger.kernel.org>; Sat, 15 Jan 2011 11:09:32 -0500
Date: Sat, 15 Jan 2011 16:04:22 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 4/8] [media] mb86a20s: Fix i2c read/write error messages
Message-ID: <20110115160422.2a8f36b2@pedra>
In-Reply-To: <cover.1295114145.git.mchehab@redhat.com>
References: <cover.1295114145.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

A script replaced err var to rc. Howerver, this script gambled
"error" string, changing it to "rcor". Revert that bad change.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/dvb/frontends/mb86a20s.c b/drivers/media/dvb/frontends/mb86a20s.c
index d3ad3e7..e06507d 100644
--- a/drivers/media/dvb/frontends/mb86a20s.c
+++ b/drivers/media/dvb/frontends/mb86a20s.c
@@ -318,7 +318,7 @@ static int mb86a20s_i2c_writereg(struct mb86a20s_state *state,
 
 	rc = i2c_transfer(state->i2c, &msg, 1);
 	if (rc != 1) {
-		printk("%s: writereg rcor(rc == %i, reg == 0x%02x,"
+		printk("%s: writereg error (rc == %i, reg == 0x%02x,"
 			 " data == 0x%02x)\n", __func__, rc, reg, data);
 		return rc;
 	}
@@ -353,7 +353,7 @@ static int mb86a20s_i2c_readreg(struct mb86a20s_state *state,
 	rc = i2c_transfer(state->i2c, msg, 2);
 
 	if (rc != 2) {
-		rc("%s: reg=0x%x (rcor=%d)\n", __func__, reg, rc);
+		rc("%s: reg=0x%x (error=%d)\n", __func__, reg, rc);
 		return rc;
 	}
 
-- 
1.7.1


