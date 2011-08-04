Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.dream-property.net ([82.149.226.172]:36439 "EHLO
	mail.dream-property.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751663Ab1HDPkm (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 4 Aug 2011 11:40:42 -0400
Received: from localhost (localhost [127.0.0.1])
	by mail.dream-property.net (Postfix) with ESMTP id 016B13153473
	for <linux-media@vger.kernel.org>; Thu,  4 Aug 2011 17:33:25 +0200 (CEST)
Received: from mail.dream-property.net ([127.0.0.1])
	by localhost (mail.dream-property.net [127.0.0.1]) (amavisd-new, port 10024)
	with LMTP id GETln1gOMeiS for <linux-media@vger.kernel.org>;
	Thu,  4 Aug 2011 17:33:18 +0200 (CEST)
Received: from pepe.dream-property.nete (dreamboxupdate.com [82.149.226.174])
	by mail.dream-property.net (Postfix) with SMTP id 2825F3153477
	for <linux-media@vger.kernel.org>; Thu,  4 Aug 2011 17:33:17 +0200 (CEST)
From: Andreas Oberritter <obi@linuxtv.org>
To: linux-media@vger.kernel.org
Subject: [PATCH 2/4] DVB: dvb_frontend: avoid possible race condition on first event
Date: Thu,  4 Aug 2011 15:33:13 +0000
Message-Id: <1312471995-26292-2-git-send-email-obi@linuxtv.org>
In-Reply-To: <1312471995-26292-1-git-send-email-obi@linuxtv.org>
References: <1312471995-26292-1-git-send-email-obi@linuxtv.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

- Make sure the initial frontend event on FE_SET_FRONTEND gets
  enqueued before the frontend thread wakes up.

Signed-off-by: Andreas Oberritter <obi@linuxtv.org>
---
 drivers/media/dvb/dvb-core/dvb_frontend.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/dvb/dvb-core/dvb_frontend.c b/drivers/media/dvb/dvb-core/dvb_frontend.c
index 23d79d0..45ea843 100644
--- a/drivers/media/dvb/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb/dvb-core/dvb_frontend.c
@@ -1891,8 +1891,8 @@ static int dvb_frontend_ioctl_legacy(struct file *file,
 		/* Request the search algorithm to search */
 		fepriv->algo_status |= DVBFE_ALGO_SEARCH_AGAIN;
 
-		dvb_frontend_wakeup(fe);
 		dvb_frontend_add_event(fe, 0);
+		dvb_frontend_wakeup(fe);
 		fepriv->status = 0;
 		err = 0;
 		break;
-- 
1.7.2.5

