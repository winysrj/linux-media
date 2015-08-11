Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:37513 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965124AbbHKPPi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Aug 2015 11:15:38 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 4/4] sr030pc30: don't read a new pointer
Date: Tue, 11 Aug 2015 12:13:55 -0300
Message-Id: <1439306035-20735-4-git-send-email-mchehab@osg.samsung.com>
In-Reply-To: <1439306035-20735-1-git-send-email-mchehab@osg.samsung.com>
References: <1439306035-20735-1-git-send-email-mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

sr030pc30_get_fmt() can only succeed if both info->curr_win and
info->curr_fmt are not NULL.

If one of those vars are null, the curent code would call:
	ret = sr030pc30_set_params(sd);

If the curr_win is null, it will return -EINVAL, as it would be
expected. However, if curr_fmt is NULL, the function won't
set it.

The code will then try to read from it:

        mf->code        = info->curr_fmt->code;
        mf->colorspace  = info->curr_fmt->colorspace;

with obviouly won't work.

This got reported by smatch:
	drivers/media/i2c/sr030pc30.c:505 sr030pc30_get_fmt() error: we previously assumed 'info->curr_win' could be null (see line 499)
	drivers/media/i2c/sr030pc30.c:507 sr030pc30_get_fmt() error: we previously assumed 'info->curr_fmt' could be null (see line 499)

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
---
 drivers/media/i2c/sr030pc30.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/media/i2c/sr030pc30.c b/drivers/media/i2c/sr030pc30.c
index 229dc76c44a5..47ebe27cb00e 100644
--- a/drivers/media/i2c/sr030pc30.c
+++ b/drivers/media/i2c/sr030pc30.c
@@ -496,11 +496,8 @@ static int sr030pc30_get_fmt(struct v4l2_subdev *sd,
 
 	mf = &format->format;
 
-	if (!info->curr_win || !info->curr_fmt) {
-		ret = sr030pc30_set_params(sd);
-		if (ret)
-			return ret;
-	}
+	if (!info->curr_win || !info->curr_fmt)
+		return -EINVAL;
 
 	mf->width	= info->curr_win->width;
 	mf->height	= info->curr_win->height;
-- 
2.4.3

