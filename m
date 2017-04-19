Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt0-f175.google.com ([209.85.216.175]:33959 "EHLO
        mail-qt0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S940341AbdDSXOl (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 19 Apr 2017 19:14:41 -0400
Received: by mail-qt0-f175.google.com with SMTP id c45so32513385qtb.1
        for <linux-media@vger.kernel.org>; Wed, 19 Apr 2017 16:14:35 -0700 (PDT)
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: linux-media@vger.kernel.org
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>
Subject: [PATCH 10/12] au8522: Set the initial modulation
Date: Wed, 19 Apr 2017 19:13:53 -0400
Message-Id: <1492643635-30823-11-git-send-email-dheitmueller@kernellabs.com>
In-Reply-To: <1492643635-30823-1-git-send-email-dheitmueller@kernellabs.com>
References: <1492643635-30823-1-git-send-email-dheitmueller@kernellabs.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

We need to set the initial modulation on driver setup, or else any
calls to GET_FRONTEND prior to the first SET_FRONTEND call will get
back garbage.

Signed-off-by: Devin Heitmueller <dheitmueller@kernellabs.com>
---
 drivers/media/dvb-frontends/au8522_common.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/dvb-frontends/au8522_common.c b/drivers/media/dvb-frontends/au8522_common.c
index cf4ac24..6722838 100644
--- a/drivers/media/dvb-frontends/au8522_common.c
+++ b/drivers/media/dvb-frontends/au8522_common.c
@@ -234,6 +234,7 @@ int au8522_init(struct dvb_frontend *fe)
 	   chip, so that when it gets powered back up it won't think
 	   that it is already tuned */
 	state->current_frequency = 0;
+	state->current_modulation = VSB_8;
 
 	au8522_writereg(state, 0xa4, 1 << 5);
 
-- 
1.9.1
