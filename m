Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39877 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751645Ab2J0UmA (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 27 Oct 2012 16:42:00 -0400
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q9RKg0lY019777
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Sat, 27 Oct 2012 16:42:00 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 18/68] [media] radio-aimslab.c: get rid of warning: no previous prototype
Date: Sat, 27 Oct 2012 18:40:36 -0200
Message-Id: <1351370486-29040-19-git-send-email-mchehab@redhat.com>
In-Reply-To: <1351370486-29040-1-git-send-email-mchehab@redhat.com>
References: <1351370486-29040-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

drivers/media/radio/radio-aimslab.c:85:6: warning: no previous prototype for 'rtrack_set_pins' [-Wmissing-prototypes]

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/radio/radio-aimslab.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/radio/radio-aimslab.c b/drivers/media/radio/radio-aimslab.c
index 12c70e8..a739ad4 100644
--- a/drivers/media/radio/radio-aimslab.c
+++ b/drivers/media/radio/radio-aimslab.c
@@ -82,7 +82,7 @@ static struct radio_isa_card *rtrack_alloc(void)
 #define AIMS_BIT_VOL_UP		(1 << 6)	/* active low */
 #define AIMS_BIT_VOL_DN		(1 << 7)	/* active low */
 
-void rtrack_set_pins(void *handle, u8 pins)
+static void rtrack_set_pins(void *handle, u8 pins)
 {
 	struct radio_isa_card *isa = handle;
 	struct rtrack *rt = container_of(isa, struct rtrack, isa);
-- 
1.7.11.7

