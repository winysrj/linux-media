Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:64254 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756665Ab2EGQLX (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 7 May 2012 12:11:23 -0400
Received: by dady13 with SMTP id y13so1433135dad.19
        for <linux-media@vger.kernel.org>; Mon, 07 May 2012 09:11:23 -0700 (PDT)
From: Il Han <corone.il.han@gmail.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-media@vger.kernel.org, Il Han <corone.il.han@gmail.com>
Subject: [PATCH] dvb: Initialize a variable before used.
Date: Tue,  8 May 2012 01:04:42 +0900
Message-Id: <1336406682-19571-1-git-send-email-corone.il.han@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The variable ret is used uninitialized.
It should be initialized before used.
Initialize it.

Signed-off-by: Il Han <corone.il.han@gmail.com>
---
 drivers/media/dvb/dvb-usb/lmedm04.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/dvb/dvb-usb/lmedm04.c b/drivers/media/dvb/dvb-usb/lmedm04.c
index 5dde06d..dc57258 100644
--- a/drivers/media/dvb/dvb-usb/lmedm04.c
+++ b/drivers/media/dvb/dvb-usb/lmedm04.c
@@ -373,7 +373,7 @@ static int lme2510_pid_filter_ctrl(struct dvb_usb_adapter *adap, int onoff)
 	struct lme2510_state *st = adap->dev->priv;
 	static u8 clear_pid_reg[] = LME_ALL_PIDS;
 	static u8 rbuf[1];
-	int ret;
+	int ret = 0;
 
 	deb_info(1, "PID Clearing Filter");
 
-- 
1.7.4.1

