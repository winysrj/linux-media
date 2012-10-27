Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:4071 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752312Ab2J0UmZ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 27 Oct 2012 16:42:25 -0400
Received: from int-mx12.intmail.prod.int.phx2.redhat.com (int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q9RKgPtp019849
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Sat, 27 Oct 2012 16:42:25 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 36/68] [media] dib9000: get rid of warning: no previous prototype
Date: Sat, 27 Oct 2012 18:40:54 -0200
Message-Id: <1351370486-29040-37-git-send-email-mchehab@redhat.com>
In-Reply-To: <1351370486-29040-1-git-send-email-mchehab@redhat.com>
References: <1351370486-29040-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

drivers/media/dvb-frontends/dib9000.h:100:5: warning: no previous prototype for 'dib9000_remove_slave_frontend' [-Wmissing-prototypes]

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/dvb-frontends/dib9000.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/dvb-frontends/dib9000.h b/drivers/media/dvb-frontends/dib9000.h
index b5781a4..de1cc91 100644
--- a/drivers/media/dvb-frontends/dib9000.h
+++ b/drivers/media/dvb-frontends/dib9000.h
@@ -97,7 +97,7 @@ static inline int dib9000_set_slave_frontend(struct dvb_frontend *fe, struct dvb
 	return -ENODEV;
 }
 
-int dib9000_remove_slave_frontend(struct dvb_frontend *fe)
+static inline int dib9000_remove_slave_frontend(struct dvb_frontend *fe)
 {
 	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __func__);
 	return -ENODEV;
-- 
1.7.11.7

