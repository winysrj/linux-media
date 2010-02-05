Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pz0-f189.google.com ([209.85.222.189]:59613 "EHLO
	mail-pz0-f189.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932444Ab0BENxD (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 5 Feb 2010 08:53:03 -0500
From: Yong Zhang <yong.zhang0@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: a.p.zijlstra@chello.nl, mingo@elte.hu,
	Brian Johnson <brijohn@gmail.com>,
	Jean-Francois Moine <moinejf@free.fr>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org
Subject: [PATCH 3/4] V4L/DVB: gspca - sn9c20x: correct onstack wait_queue_head declaration
Date: Fri,  5 Feb 2010 21:52:39 +0800
Message-Id: <bc78da996dc04da174f51d2dbe1df4b084a07a3f.1265375697.git.yong.zhang0@gmail.com>
In-Reply-To: <b47c0527f1471857fec4662da1bfd0bb9e6071a7.1265375697.git.yong.zhang0@gmail.com>
References: <1265377920-5898-1-git-send-email-yong.zhang0@gmail.com>
 <b1dccd762d3d04ab75d79d1d9b097d593a89f32a.1265375697.git.yong.zhang0@gmail.com>
 <b47c0527f1471857fec4662da1bfd0bb9e6071a7.1265375697.git.yong.zhang0@gmail.com>
In-Reply-To: <b1dccd762d3d04ab75d79d1d9b097d593a89f32a.1265375697.git.yong.zhang0@gmail.com>
References: <b1dccd762d3d04ab75d79d1d9b097d593a89f32a.1265375697.git.yong.zhang0@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use DECLARE_WAIT_QUEUE_HEAD_ONSTACK to make lockdep happy

Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>
Cc: Brian Johnson <brijohn@gmail.com>
Cc: Jean-Francois Moine <moinejf@free.fr>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-media@vger.kernel.org
---
 drivers/media/video/gspca/sn9c20x.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/gspca/sn9c20x.c b/drivers/media/video/gspca/sn9c20x.c
index 0ca1c06..8f75fbc 100644
--- a/drivers/media/video/gspca/sn9c20x.c
+++ b/drivers/media/video/gspca/sn9c20x.c
@@ -1426,7 +1426,7 @@ static int input_kthread(void *data)
 	struct gspca_dev *gspca_dev = (struct gspca_dev *)data;
 	struct sd *sd = (struct sd *) gspca_dev;
 
-	DECLARE_WAIT_QUEUE_HEAD(wait);
+	DECLARE_WAIT_QUEUE_HEAD_ONSTACK(wait);
 	set_freezable();
 	for (;;) {
 		if (kthread_should_stop())
-- 
1.6.3.3

