Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:26418 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752419Ab2J0Um1 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 27 Oct 2012 16:42:27 -0400
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q9RKgRZi006366
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Sat, 27 Oct 2012 16:42:27 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 45/68] [media] dmxdev: fix a comparition of unsigned expression warning
Date: Sat, 27 Oct 2012 18:41:03 -0200
Message-Id: <1351370486-29040-46-git-send-email-mchehab@redhat.com>
In-Reply-To: <1351370486-29040-1-git-send-email-mchehab@redhat.com>
References: <1351370486-29040-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

drivers/media/dvb-core/dmxdev.c: In function 'dvb_dmxdev_pes_filter_set':
drivers/media/dvb-core/dmxdev.c:880:2: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/dvb-core/dmxdev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/dvb-core/dmxdev.c b/drivers/media/dvb-core/dmxdev.c
index 889c9c1..d81dbb2 100644
--- a/drivers/media/dvb-core/dmxdev.c
+++ b/drivers/media/dvb-core/dmxdev.c
@@ -877,7 +877,7 @@ static int dvb_dmxdev_pes_filter_set(struct dmxdev *dmxdev,
 	dvb_dmxdev_filter_stop(dmxdevfilter);
 	dvb_dmxdev_filter_reset(dmxdevfilter);
 
-	if (params->pes_type > DMX_PES_OTHER || params->pes_type < 0)
+	if ((unsigned)params->pes_type > DMX_PES_OTHER)
 		return -EINVAL;
 
 	dmxdevfilter->type = DMXDEV_TYPE_PES;
-- 
1.7.11.7

