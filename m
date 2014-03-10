Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:50441 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753184AbaCJL7w (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Mar 2014 07:59:52 -0400
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 04/15] drx-j: don't use mc_info before checking if its not NULL
Date: Mon, 10 Mar 2014 08:58:56 -0300
Message-Id: <1394452747-5426-5-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1394452747-5426-1-git-send-email-m.chehab@samsung.com>
References: <1394452747-5426-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

smatch warning:
	drivers/media/dvb-frontends/drx39xyj/drxj.c:20803 drx_ctrl_u_code() warn: variable dereferenced before check 'mc_info' (see line 20800)

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/dvb-frontends/drx39xyj/drxj.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/media/dvb-frontends/drx39xyj/drxj.c b/drivers/media/dvb-frontends/drx39xyj/drxj.c
index 1e6dab7e5892..a8fd53b612ae 100644
--- a/drivers/media/dvb-frontends/drx39xyj/drxj.c
+++ b/drivers/media/dvb-frontends/drx39xyj/drxj.c
@@ -20208,12 +20208,14 @@ static int drx_ctrl_u_code(struct drx_demod_instance *demod,
 	const u8 *mc_data_init = NULL;
 	u8 *mc_data = NULL;
 	unsigned size;
-	char *mc_file = mc_info->mc_file;
+	char *mc_file;
 
 	/* Check arguments */
-	if (!mc_info || !mc_file)
+	if (!mc_info || !mc_info->mc_file)
 		return -EINVAL;
 
+	mc_file = mc_info->mc_file;
+
 	if (!demod->firmware) {
 		const struct firmware *fw = NULL;
 
-- 
1.8.5.3

