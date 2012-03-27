Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailfe08.c2i.net ([212.247.154.226]:60605 "EHLO swip.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750876Ab2C0QBK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 27 Mar 2012 12:01:10 -0400
Received: from [176.74.212.201] (account mc467741@c2i.net HELO laptop002.hselasky.homeunix.org)
  by mailfe08.swip.net (CommuniGate Pro SMTP 5.4.2)
  with ESMTPA id 256815132 for linux-media@vger.kernel.org; Tue, 27 Mar 2012 17:56:06 +0200
From: Hans Petter Selasky <hselasky@c2i.net>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH] Fix compiler warning.
Date: Tue, 27 Mar 2012 17:54:41 +0200
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Message-Id: <201203271754.41984.hselasky@c2i.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

>From 03d309b552e01622a678b2c500f80fe59746ca12 Mon Sep 17 00:00:00 2001
From: Hans Petter Selasky <hselasky@c2i.net>
Date: Tue, 27 Mar 2012 17:53:19 +0200
Subject: [PATCH] Fix compiler warning.

Signed-off-by: Hans Petter Selasky <hselasky@c2i.net>
---
 drivers/media/dvb/dvb-core/dvb_frontend.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/dvb/dvb-core/dvb_frontend.c b/drivers/media/dvb/dvb-
core/dvb_frontend.c
index 4555baa..bfdf599 100644
--- a/drivers/media/dvb/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb/dvb-core/dvb_frontend.c
@@ -146,7 +146,7 @@ static int dtv_get_frontend(struct dvb_frontend *fe,
 
 static bool has_get_frontend(struct dvb_frontend *fe)
 {
-	return fe->ops.get_frontend;
+	return fe->ops.get_frontend != NULL;
 }
 
 /*
-- 
1.7.1.1

