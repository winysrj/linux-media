Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:33729 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751596AbbBRPaM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Feb 2015 10:30:12 -0500
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Shuah Khan <shuah.kh@samsung.com>,
	Akihiro Tsukada <tskd08@gmail.com>,
	Ole Ernst <olebowle@gmx.com>
Subject: [PATCH 1/7] [media] dvb-frontend: remove a warning
Date: Wed, 18 Feb 2015 13:29:55 -0200
Message-Id: <110dcdca23da9714db1a2d95800abc4c9d33b512.1424273378.git.mchehab@osg.samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

if CONFIG_MEDIA_CONTROLLER_DVB is not selected, it is now
producing this warning:

drivers/media/dvb-core/dvb_frontend.c: In function ‘dvb_frontend_thread’:
drivers/media/dvb-core/dvb_frontend.c:695:6: warning: unused variable ‘ret’ [-Wunused-variable]
  int ret;
      ^

Reported-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/dvb-core/dvb_frontend.c b/drivers/media/dvb-core/dvb_frontend.c
index aa5306908193..d7d390c5c7c3 100644
--- a/drivers/media/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb-core/dvb_frontend.c
@@ -692,7 +692,9 @@ static int dvb_frontend_thread(void *data)
 	struct dvb_frontend_private *fepriv = fe->frontend_priv;
 	fe_status_t s;
 	enum dvbfe_algo algo;
+#ifdef CONFIG_MEDIA_CONTROLLER_DVB
 	int ret;
+#endif
 
 	bool re_tune = false;
 	bool semheld = false;
-- 
2.1.0

