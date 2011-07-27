Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:19797 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755043Ab1G0U3s (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Jul 2011 16:29:48 -0400
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p6RKTmX3028328
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Wed, 27 Jul 2011 16:29:48 -0400
Received: from localhost.localdomain (vpn-227-4.phx2.redhat.com [10.3.227.4])
	by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id p6RKTkxu009397
	for <linux-media@vger.kernel.org>; Wed, 27 Jul 2011 16:29:47 -0400
Date: Wed, 27 Jul 2011 17:29:32 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 1/3] [media] drxk: Fix error return code during drxk init
Message-ID: <20110727172932.4b42e59d@redhat.com>
In-Reply-To: <cover.1311798269.git.mchehab@redhat.com>
References: <cover.1311798269.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/dvb/frontends/drxk_hard.c b/drivers/media/dvb/frontends/drxk_hard.c
index 5694955..5b22c1f 100644
--- a/drivers/media/dvb/frontends/drxk_hard.c
+++ b/drivers/media/dvb/frontends/drxk_hard.c
@@ -6171,7 +6171,7 @@ error:
 	if (status < 0)
 		printk(KERN_ERR "drxk: Error %d on %s\n", status, __func__);
 
-	return 0;
+	return status;
 }
 
 static void drxk_c_release(struct dvb_frontend *fe)
-- 
1.7.1


