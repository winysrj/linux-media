Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:46822 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754069AbeCWL5h (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 23 Mar 2018 07:57:37 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 30/30] media: cec-core: fix a bug at cec_error_inj_write()
Date: Fri, 23 Mar 2018 07:57:16 -0400
Message-Id: <c1b1e1d6a1588d099720f8c6509736b01ccdc6ae.1521806166.git.mchehab@s-opensource.com>
In-Reply-To: <39adb4e739050dcdb74c3465d261de8de5f224b7.1521806166.git.mchehab@s-opensource.com>
References: <39adb4e739050dcdb74c3465d261de8de5f224b7.1521806166.git.mchehab@s-opensource.com>
In-Reply-To: <39adb4e739050dcdb74c3465d261de8de5f224b7.1521806166.git.mchehab@s-opensource.com>
References: <39adb4e739050dcdb74c3465d261de8de5f224b7.1521806166.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

If the adapter doesn't have error_inj_parse_line() ops, the
write() logic won't return -EINVAL, but, instead, it will keep
looping, because "count" is a non-negative number.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/cec/cec-core.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/media/cec/cec-core.c b/drivers/media/cec/cec-core.c
index ea3eccfdba15..b0c87f9ea08f 100644
--- a/drivers/media/cec/cec-core.c
+++ b/drivers/media/cec/cec-core.c
@@ -209,14 +209,14 @@ static ssize_t cec_error_inj_write(struct file *file,
 	if (IS_ERR(buf))
 		return PTR_ERR(buf);
 	p = buf;
-	while (p && *p && count >= 0) {
+	while (p && *p) {
 		p = skip_spaces(p);
 		line = strsep(&p, "\n");
 		if (!*line || *line == '#')
 			continue;
 		if (!adap->ops->error_inj_parse_line(adap, line)) {
-			count = -EINVAL;
-			break;
+			kfree(buf);
+			return -EINVAL;
 		}
 	}
 	kfree(buf);
-- 
2.14.3
