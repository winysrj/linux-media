Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37377 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933851Ab3CVQQJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 22 Mar 2013 12:16:09 -0400
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r2MGG96X020610
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Fri, 22 Mar 2013 12:16:09 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 2/3] [media] siano: remove the ir protocol field
Date: Fri, 22 Mar 2013 13:16:02 -0300
Message-Id: <1363968963-7841-2-git-send-email-mchehab@redhat.com>
In-Reply-To: <1363968963-7841-1-git-send-email-mchehab@redhat.com>
References: <1363968963-7841-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This field is unused. Remove it.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/common/siano/smsir.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/media/common/siano/smsir.h b/drivers/media/common/siano/smsir.h
index 69b59b9..fc8b792 100644
--- a/drivers/media/common/siano/smsir.h
+++ b/drivers/media/common/siano/smsir.h
@@ -40,7 +40,6 @@ struct ir_t {
 	char phys[32];
 
 	char *rc_codes;
-	u64 protocol;
 
 	u32 timeout;
 	u32 controller;
-- 
1.8.1.4

