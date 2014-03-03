Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:49395 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754149AbaCCKH7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 3 Mar 2014 05:07:59 -0500
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 79/79] [media] drx-j: set it to serial mode by default
Date: Mon,  3 Mar 2014 07:07:13 -0300
Message-Id: <1393841233-24840-80-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1393841233-24840-1-git-send-email-m.chehab@samsung.com>
References: <1393841233-24840-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Currently, there's just one device using this frontend: PCTV 80e,
and it works on serial mode.

Change the default here to serial mode. If we add more devices,
then this option should be set via config structure.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/dvb-frontends/drx39xyj/drxj.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/dvb-frontends/drx39xyj/drxj.c b/drivers/media/dvb-frontends/drx39xyj/drxj.c
index 8437fd5b8c91..a99040b741c6 100644
--- a/drivers/media/dvb-frontends/drx39xyj/drxj.c
+++ b/drivers/media/dvb-frontends/drx39xyj/drxj.c
@@ -833,7 +833,7 @@ struct drx_common_attr drxj_default_comm_attr_g = {
 	 /* MPEG output configuration */
 	 true,			/* If true, enable MPEG ouput    */
 	 false,			/* If true, insert RS byte       */
-	 true,			/* If true, parallel out otherwise serial */
+	 false,			/* If true, parallel out otherwise serial */
 	 false,			/* If true, invert DATA signals  */
 	 false,			/* If true, invert ERR signal    */
 	 false,			/* If true, invert STR signals   */
-- 
1.8.5.3

