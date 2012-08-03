Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailfe05.c2i.net ([212.247.154.130]:42061 "EHLO swip.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751272Ab2HCGe6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 3 Aug 2012 02:34:58 -0400
Received: from [176.74.212.201] (account mc467741@c2i.net HELO laptop015.hselasky.homeunix.org)
  by mailfe05.swip.net (CommuniGate Pro SMTP 5.4.4)
  with ESMTPA id 300478117 for linux-media@vger.kernel.org; Fri, 03 Aug 2012 08:34:55 +0200
From: Hans Petter Selasky <hselasky@c2i.net>
To: "linux-media" <linux-media@vger.kernel.org>
Subject: [PATCH] Add missing else case.
Date: Fri, 3 Aug 2012 08:35:19 +0200
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Message-Id: <201208030835.19281.hselasky@c2i.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

>From 59306435992d9349f10ad82a8adf14d98becbbe8 Mon Sep 17 00:00:00 2001
From: Hans Petter Selasky <hselasky@c2i.net>
Date: Fri, 3 Aug 2012 08:34:05 +0200
Subject: [PATCH] Add missing else case.

Signed-off-by: Hans Petter Selasky <hselasky@c2i.net>
---
 drivers/media/common/tuners/tuner-xc2028.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/common/tuners/tuner-xc2028.c b/drivers/media/common/tuners/tuner-xc2028.c
index ea0550e..49e63ec 100644
--- a/drivers/media/common/tuners/tuner-xc2028.c
+++ b/drivers/media/common/tuners/tuner-xc2028.c
@@ -1414,8 +1414,8 @@ static int xc2028_set_config(struct dvb_frontend *fe, void *priv_cfg)
 			tuner_err("Failed to request firmware %s\n",
 				  priv->fname);
 			priv->state = XC2028_NODEV;
-		}
-		priv->state = XC2028_WAITING_FIRMWARE;
+		} else
+			priv->state = XC2028_WAITING_FIRMWARE;
 	}
 	mutex_unlock(&priv->lock);
 
-- 
1.7.10.1

