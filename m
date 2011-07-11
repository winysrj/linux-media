Return-path: <mchehab@localhost>
Received: from mx1.redhat.com ([209.132.183.28]:23787 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756415Ab1GKB7o (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 10 Jul 2011 21:59:44 -0400
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p6B1xiHR011636
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Sun, 10 Jul 2011 21:59:44 -0400
Received: from pedra (vpn-225-29.phx2.redhat.com [10.3.225.29])
	by int-mx10.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id p6B1xKKa030664
	for <linux-media@vger.kernel.org>; Sun, 10 Jul 2011 21:59:43 -0400
Date: Sun, 10 Jul 2011 22:58:56 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 08/21] [media] drxk: Print an error if firmware is not
 loaded
Message-ID: <20110710225856.15e840d5@pedra>
In-Reply-To: <cover.1310347962.git.mchehab@redhat.com>
References: <cover.1310347962.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@infradead.org>

If something bad happens during firmware load, an error
should be printed at dmesg.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/dvb/frontends/drxk_hard.c b/drivers/media/dvb/frontends/drxk_hard.c
index 89db378..1452e82 100644
--- a/drivers/media/dvb/frontends/drxk_hard.c
+++ b/drivers/media/dvb/frontends/drxk_hard.c
@@ -1395,8 +1395,10 @@ static int DownloadMicrocode(struct drxk_state *state,
 		}
 
 		status = write_block(state, Address, BlockSize, pSrc);
-		if (status < 0)
+		if (status < 0) {
+			printk(KERN_ERR "drxk: Error %d while loading firmware\n", status);
 			break;
+		}
 		pSrc += BlockSize;
 		offset += BlockSize;
 	}
-- 
1.7.1


