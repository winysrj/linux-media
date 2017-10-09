Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:64320 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751652AbdJIKXR (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 9 Oct 2017 06:23:17 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH] media: v4l2-tpg: use __u16 instead of int for struct tpg_rbg_color16
Date: Mon,  9 Oct 2017 07:23:11 -0300
Message-Id: <a96b3f52121ef0e3446a4e33c8c34871ddabc319.1507544529.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Despite the struct says "color16", it was actually using 32 bits
for each color. Fix it.

Suggested-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---

Should come after this patch series:
    V4L2 kAPI cleanups and documentation improvements part 2


 include/media/tpg/v4l2-tpg.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/media/tpg/v4l2-tpg.h b/include/media/tpg/v4l2-tpg.h
index bc0b38440719..823fadede7bf 100644
--- a/include/media/tpg/v4l2-tpg.h
+++ b/include/media/tpg/v4l2-tpg.h
@@ -32,7 +32,7 @@ struct tpg_rbg_color8 {
 };
 
 struct tpg_rbg_color16 {
-	int r, g, b;
+	__u16 r, g, b;
 };
 
 enum tpg_color {
-- 
2.13.6
