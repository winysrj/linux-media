Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f43.google.com ([74.125.83.43]:44087 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753830Ab3EFPpO (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 6 May 2013 11:45:14 -0400
Received: by mail-ee0-f43.google.com with SMTP id b15so1870246eek.2
        for <linux-media@vger.kernel.org>; Mon, 06 May 2013 08:45:13 -0700 (PDT)
From: Gianluca Gennari <gennarone@gmail.com>
To: linux-media@vger.kernel.org, mchehab@redhat.com
Cc: Gianluca Gennari <gennarone@gmail.com>
Subject: [PATCH 1/3] r820t: do not double-free fe->tuner_priv in r820t_release()
Date: Mon,  6 May 2013 17:44:35 +0200
Message-Id: <1367855077-6134-2-git-send-email-gennarone@gmail.com>
In-Reply-To: <1367855077-6134-1-git-send-email-gennarone@gmail.com>
References: <1367855077-6134-1-git-send-email-gennarone@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

fe->tuner_priv is already freed by hybrid_tuner_release_state().

Signed-off-by: Gianluca Gennari <gennarone@gmail.com>
---
 drivers/media/tuners/r820t.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/media/tuners/r820t.c b/drivers/media/tuners/r820t.c
index 2d6d498..0a5f96b 100644
--- a/drivers/media/tuners/r820t.c
+++ b/drivers/media/tuners/r820t.c
@@ -2256,7 +2256,6 @@ static int r820t_release(struct dvb_frontend *fe)
 
 	mutex_unlock(&r820t_list_mutex);
 
-	kfree(fe->tuner_priv);
 	fe->tuner_priv = NULL;
 
 	return 0;
-- 
1.8.2.2

