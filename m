Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr10.xs4all.nl ([194.109.24.30]:1210 "EHLO
	smtp-vbr10.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750927AbaIUMKH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 21 Sep 2014 08:10:07 -0400
Received: from tschai.lan (209.80-203-20.nextgentel.com [80.203.20.209])
	(authenticated bits=0)
	by smtp-vbr10.xs4all.nl (8.13.8/8.13.8) with ESMTP id s8LCA4Nu011120
	for <linux-media@vger.kernel.org>; Sun, 21 Sep 2014 14:10:06 +0200 (CEST)
	(envelope-from hverkuil@xs4all.nl)
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id 861B52A002F
	for <linux-media@vger.kernel.org>; Sun, 21 Sep 2014 14:09:58 +0200 (CEST)
Message-ID: <541EC016.8090708@xs4all.nl>
Date: Sun, 21 Sep 2014 14:09:58 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH] v4l2-ioctl.c: fix inverted condition
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

v4l_print_ext_controls() would print the 'size' if it was 0 and
'value' if size was non-zero, but it should have been the other
way around.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/v4l2-core/v4l2-ioctl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
index 46f4c04..9ccb19a 100644
--- a/drivers/media/v4l2-core/v4l2-ioctl.c
+++ b/drivers/media/v4l2-core/v4l2-ioctl.c
@@ -562,7 +562,7 @@ static void v4l_print_ext_controls(const void *arg, bool write_only)
 	pr_cont("class=0x%x, count=%d, error_idx=%d",
 			p->ctrl_class, p->count, p->error_idx);
 	for (i = 0; i < p->count; i++) {
-		if (p->controls[i].size)
+		if (!p->controls[i].size)
 			pr_cont(", id/val=0x%x/0x%x",
 				p->controls[i].id, p->controls[i].value);
 		else
-- 
2.1.0

