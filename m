Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:60242 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755978Ab2AEPiA (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 5 Jan 2012 10:38:00 -0500
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q05Fc0aR004101
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Thu, 5 Jan 2012 10:38:00 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 1/5] [media] drxk: remove ops.info.frequency_stepsize from DVB-C
Date: Thu,  5 Jan 2012 13:37:48 -0200
Message-Id: <1325777872-14696-2-git-send-email-mchehab@redhat.com>
In-Reply-To: <1325777872-14696-1-git-send-email-mchehab@redhat.com>
References: <1325777872-14696-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

ops.info.frequency_stepsize is used only for DVB-T & friends. For
DVB-C, the step size is calculated using the symbol rate.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/dvb/frontends/drxk_hard.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/media/dvb/frontends/drxk_hard.c b/drivers/media/dvb/frontends/drxk_hard.c
index c8213f6..77e78f4 100644
--- a/drivers/media/dvb/frontends/drxk_hard.c
+++ b/drivers/media/dvb/frontends/drxk_hard.c
@@ -6356,7 +6356,6 @@ static struct dvb_frontend_ops drxk_c_ops = {
 	.delsys = { SYS_DVBC_ANNEX_A, SYS_DVBC_ANNEX_C },
 	.info = {
 		 .name = "DRXK DVB-C",
-		 .frequency_stepsize = 62500,
 		 .frequency_min = 47000000,
 		 .frequency_max = 862000000,
 		 .symbol_rate_min = 870000,
-- 
1.7.7.5

