Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37884 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757330Ab0CKWC2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Mar 2010 17:02:28 -0500
Message-Id: <201003112202.o2BM2IE8013128@imap1.linux-foundation.org>
Subject: [patch 3/5] v4l/dvb: gspca - sn9c20x: correct onstack wait_queue_head declaration
To: mchehab@infradead.org
Cc: linux-media@vger.kernel.org, akpm@linux-foundation.org,
	yong.zhang0@gmail.com, brijohn@gmail.com, moinejf@free.fr
From: akpm@linux-foundation.org
Date: Thu, 11 Mar 2010 14:02:18 -0800
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Yong Zhang <yong.zhang0@gmail.com>

Use DECLARE_WAIT_QUEUE_HEAD_ONSTACK to make lockdep happy.

Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>
Cc: Brian Johnson <brijohn@gmail.com>
Cc: Jean-Francois Moine <moinejf@free.fr>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/video/gspca/sn9c20x.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/media/video/gspca/sn9c20x.c~v4l-dvb-gspca-sn9c20x-correct-onstack-wait_queue_head-declaration drivers/media/video/gspca/sn9c20x.c
--- a/drivers/media/video/gspca/sn9c20x.c~v4l-dvb-gspca-sn9c20x-correct-onstack-wait_queue_head-declaration
+++ a/drivers/media/video/gspca/sn9c20x.c
@@ -1426,7 +1426,7 @@ static int input_kthread(void *data)
 	struct gspca_dev *gspca_dev = (struct gspca_dev *)data;
 	struct sd *sd = (struct sd *) gspca_dev;
 
-	DECLARE_WAIT_QUEUE_HEAD(wait);
+	DECLARE_WAIT_QUEUE_HEAD_ONSTACK(wait);
 	set_freezable();
 	for (;;) {
 		if (kthread_should_stop())
_
