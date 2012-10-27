Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:43582 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933304Ab2J0Umi (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 27 Oct 2012 16:42:38 -0400
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q9RKgckH004853
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Sat, 27 Oct 2012 16:42:38 -0400
Received: from pedra (vpn1-4-98.gru2.redhat.com [10.97.4.98])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id q9RKg5b1017375
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Sat, 27 Oct 2012 16:42:38 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 02/68] [media] drxd_hard: get rid of warning: no previous prototype
Date: Sat, 27 Oct 2012 18:40:20 -0200
Message-Id: <1351370486-29040-3-git-send-email-mchehab@redhat.com>
In-Reply-To: <1351370486-29040-1-git-send-email-mchehab@redhat.com>
References: <1351370486-29040-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

drivers/media/dvb-frontends/drxd_hard.c:1751:5: warning: no previous prototype for 'SetOperationMode' [-Wmissing-prototypes]
drivers/media/dvb-frontends/drxd_hard.c:2615:5: warning: no previous prototype for 'DRXD_init' [-Wmissing-prototypes]
drivers/media/dvb-frontends/drxd_hard.c:2777:5: warning: no previous prototype for 'DRXD_status' [-Wmissing-prototypes]

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/dvb-frontends/drxd_hard.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/media/dvb-frontends/drxd_hard.c b/drivers/media/dvb-frontends/drxd_hard.c
index 6d98537..e71cc60 100644
--- a/drivers/media/dvb-frontends/drxd_hard.c
+++ b/drivers/media/dvb-frontends/drxd_hard.c
@@ -1748,7 +1748,8 @@ static int DRX_Stop(struct drxd_state *state)
 	return status;
 }
 
-int SetOperationMode(struct drxd_state *state, int oMode)
+#if 0	/* Currently unused */
+static int SetOperationMode(struct drxd_state *state, int oMode)
 {
 	int status;
 
@@ -1788,6 +1789,7 @@ int SetOperationMode(struct drxd_state *state, int oMode)
 		state->operation_mode = oMode;
 	return status;
 }
+#endif
 
 static int StartDiversity(struct drxd_state *state)
 {
@@ -2612,7 +2614,7 @@ static int CDRXD(struct drxd_state *state, u32 IntermediateFrequency)
 	return 0;
 }
 
-int DRXD_init(struct drxd_state *state, const u8 * fw, u32 fw_size)
+static int DRXD_init(struct drxd_state *state, const u8 *fw, u32 fw_size)
 {
 	int status = 0;
 	u32 driverVersion;
@@ -2774,7 +2776,7 @@ int DRXD_init(struct drxd_state *state, const u8 * fw, u32 fw_size)
 	return status;
 }
 
-int DRXD_status(struct drxd_state *state, u32 * pLockStatus)
+static int DRXD_status(struct drxd_state *state, u32 *pLockStatus)
 {
 	DRX_GetLockStatus(state, pLockStatus);
 
-- 
1.7.11.7

