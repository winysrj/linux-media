Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34095 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932320Ab2AEBBM (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 4 Jan 2012 20:01:12 -0500
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q0511B2e016396
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Wed, 4 Jan 2012 20:01:12 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 42/47] [media] mt2063: print the detected version
Date: Wed,  4 Jan 2012 23:00:53 -0200
Message-Id: <1325725258-27934-43-git-send-email-mchehab@redhat.com>
In-Reply-To: <1325725258-27934-1-git-send-email-mchehab@redhat.com>
References: <1325725258-27934-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Instead of printing it just for debug purposes, outputs the detected
version at the logs. This may be useful if someone wants to report
a problem.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/common/tuners/mt2063.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/media/common/tuners/mt2063.c b/drivers/media/common/tuners/mt2063.c
index 599f864..de45c9d 100644
--- a/drivers/media/common/tuners/mt2063.c
+++ b/drivers/media/common/tuners/mt2063.c
@@ -1845,8 +1845,7 @@ static int mt2063_init(struct dvb_frontend *fe)
 		return -ENODEV;	/*  Wrong tuner Part/Rev code */
 	}
 
-	dprintk(1, "Discovered a mt2063 %s (2nd part number 0x%02x)\n",
-		step, state->reg[MT2063_REG_RSVD_3B]);
+	printk(KERN_INFO "mt2063: detected a mt2063 %s\n", step);
 
 	/*  Reset the tuner  */
 	status = mt2063_write(state, MT2063_REG_LO2CQ_3, &all_resets, 1);
-- 
1.7.7.5

