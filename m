Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:3361 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755215AbaITMyO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 20 Sep 2014 08:54:14 -0400
Received: from tschai.lan (209.80-203-20.nextgentel.com [80.203.20.209])
	(authenticated bits=0)
	by smtp-vbr11.xs4all.nl (8.13.8/8.13.8) with ESMTP id s8KCsBI0042802
	for <linux-media@vger.kernel.org>; Sat, 20 Sep 2014 14:54:13 +0200 (CEST)
	(envelope-from hverkuil@xs4all.nl)
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id C7B332A002F
	for <linux-media@vger.kernel.org>; Sat, 20 Sep 2014 14:54:06 +0200 (CEST)
Message-ID: <541D78EE.7030109@xs4all.nl>
Date: Sat, 20 Sep 2014 14:54:06 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH for v3.17] cx2341x: fix kernel oops
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The v4l2_ctrl_config struct must be zeroed before passing it to
v4l2_ctrl_new_custom(). This was always wrong, but with the recent
v4l2-ctrls.c changes this is now much more likely to lead to a
kernel bug.

This is the only place where this struct wasn't initialized properly.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Reported-by: Pridvorov Andrey <ua0lnj@bk.ru>
---
 drivers/media/common/cx2341x.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/common/cx2341x.c b/drivers/media/common/cx2341x.c
index 103ef6b..be76315 100644
--- a/drivers/media/common/cx2341x.c
+++ b/drivers/media/common/cx2341x.c
@@ -1490,6 +1490,7 @@ static struct v4l2_ctrl *cx2341x_ctrl_new_custom(struct v4l2_ctrl_handler *hdl,
 {
 	struct v4l2_ctrl_config cfg;
 
+	memset(&cfg, 0, sizeof(cfg));
 	cx2341x_ctrl_fill(id, &cfg.name, &cfg.type, &min, &max, &step, &def, &cfg.flags);
 	cfg.ops = &cx2341x_ops;
 	cfg.id = id;
-- 
2.1.0

