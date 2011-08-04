Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.dream-property.net ([82.149.226.172]:36442 "EHLO
	mail.dream-property.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753883Ab1HDPkm (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 4 Aug 2011 11:40:42 -0400
Received: from localhost (localhost [127.0.0.1])
	by mail.dream-property.net (Postfix) with ESMTP id 288E3315347A
	for <linux-media@vger.kernel.org>; Thu,  4 Aug 2011 17:33:24 +0200 (CEST)
Received: from mail.dream-property.net ([127.0.0.1])
	by localhost (mail.dream-property.net [127.0.0.1]) (amavisd-new, port 10024)
	with LMTP id ouKQqh6kKDZM for <linux-media@vger.kernel.org>;
	Thu,  4 Aug 2011 17:33:17 +0200 (CEST)
Received: from pepe.dream-property.nete (dreamboxupdate.com [82.149.226.174])
	by mail.dream-property.net (Postfix) with SMTP id 0FA6A3153473
	for <linux-media@vger.kernel.org>; Thu,  4 Aug 2011 17:33:16 +0200 (CEST)
From: Andreas Oberritter <obi@linuxtv.org>
To: linux-media@vger.kernel.org
Subject: [PATCH 1/4] DVB: dvb_frontend: fix stale parameters on initial frontend event
Date: Thu,  4 Aug 2011 15:33:12 +0000
Message-Id: <1312471995-26292-1-git-send-email-obi@linuxtv.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

- FE_SET_FRONTEND triggers a frontend event, which uses stale data.
  Modify it to use the data given by the user.

- Fixes a regression caused by a5959dbea37973a2440eeba39fba32c79d862ec2.

Signed-off-by: Andreas Oberritter <obi@linuxtv.org>
---
 drivers/media/dvb/dvb-core/dvb_frontend.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/drivers/media/dvb/dvb-core/dvb_frontend.c b/drivers/media/dvb/dvb-core/dvb_frontend.c
index efe9c30..23d79d0 100644
--- a/drivers/media/dvb/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb/dvb-core/dvb_frontend.c
@@ -1827,6 +1827,13 @@ static int dvb_frontend_ioctl_legacy(struct file *file,
 			dtv_property_cache_sync(fe, c, &fepriv->parameters_in);
 		}
 
+		/*
+		 * Initialize output parameters to match the values given by
+		 * the user. FE_SET_FRONTEND triggers an initial frontend event
+		 * with status = 0, which copies output parameters to userspace.
+		 */
+		fepriv->parameters_out = fepriv->parameters_in;
+
 		memset(&fetunesettings, 0, sizeof(struct dvb_frontend_tune_settings));
 		memcpy(&fetunesettings.parameters, parg,
 		       sizeof (struct dvb_frontend_parameters));
-- 
1.7.2.5

