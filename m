Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:10843 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933457Ab2J0UoZ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 27 Oct 2012 16:44:25 -0400
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q9RKiOth020759
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Sat, 27 Oct 2012 16:44:25 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 19/68] [media] radio-isa: get rid of warning: no previous prototype
Date: Sat, 27 Oct 2012 18:40:37 -0200
Message-Id: <1351370486-29040-20-git-send-email-mchehab@redhat.com>
In-Reply-To: <1351370486-29040-1-git-send-email-mchehab@redhat.com>
References: <1351370486-29040-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

drivers/media/radio/radio-isa.c:194:24: warning: no previous prototype for 'radio_isa_alloc' [-Wmissing-prototypes]
drivers/media/radio/radio-isa.c:210:5: warning: no previous prototype for 'radio_isa_common_probe' [-Wmissing-prototypes]
drivers/media/radio/radio-isa.c:290:5: warning: no previous prototype for 'radio_isa_common_remove' [-Wmissing-prototypes]

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/radio/radio-isa.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/media/radio/radio-isa.c b/drivers/media/radio/radio-isa.c
index 3c0067d..84b7b9f 100644
--- a/drivers/media/radio/radio-isa.c
+++ b/drivers/media/radio/radio-isa.c
@@ -191,7 +191,7 @@ static bool radio_isa_valid_io(const struct radio_isa_driver *drv, int io)
 	return false;
 }
 
-struct radio_isa_card *radio_isa_alloc(struct radio_isa_driver *drv,
+static struct radio_isa_card *radio_isa_alloc(struct radio_isa_driver *drv,
 				struct device *pdev)
 {
 	struct v4l2_device *v4l2_dev;
@@ -207,8 +207,9 @@ struct radio_isa_card *radio_isa_alloc(struct radio_isa_driver *drv,
 	return isa;
 }
 
-int radio_isa_common_probe(struct radio_isa_card *isa, struct device *pdev,
-				int radio_nr, unsigned region_size)
+static int radio_isa_common_probe(struct radio_isa_card *isa,
+				  struct device *pdev,
+				  int radio_nr, unsigned region_size)
 {
 	const struct radio_isa_driver *drv = isa->drv;
 	const struct radio_isa_ops *ops = drv->ops;
@@ -287,7 +288,8 @@ err_dev_reg:
 	return res;
 }
 
-int radio_isa_common_remove(struct radio_isa_card *isa, unsigned region_size)
+static int radio_isa_common_remove(struct radio_isa_card *isa,
+				   unsigned region_size)
 {
 	const struct radio_isa_ops *ops = isa->drv->ops;
 
-- 
1.7.11.7

