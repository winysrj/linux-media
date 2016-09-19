Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([80.229.237.210]:57569 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753453AbcISWV1 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 19 Sep 2016 18:21:27 -0400
From: Sean Young <sean@mess.org>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: linux-media@vger.kernel.org
Subject: [PATCH] v4l-utils: ir-ctl: deal with consecutive pulses or spaces correctly
Date: Mon, 19 Sep 2016 23:21:25 +0100
Message-Id: <1474323685-16439-4-git-send-email-sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When sending a pulse-space file with consecutive spaces or pulses, add them
together correctly. For example:

pulse 100
space 150
space 100
pulse 150
pulse 200

Would send pulse 100, space 250, and pulse 350.

Signed-off-by: Sean Young <sean@mess.org>
---
 utils/ir-ctl/ir-ctl.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/utils/ir-ctl/ir-ctl.c b/utils/ir-ctl/ir-ctl.c
index 229330e..2f85e6d 100644
--- a/utils/ir-ctl/ir-ctl.c
+++ b/utils/ir-ctl/ir-ctl.c
@@ -211,7 +211,7 @@ static struct file *read_file(const char *fname)
 					fprintf(stderr, _("warning: %s:%d: leading space ignored\n"),
 						fname, lineno);
 				} else {
-					f->buf[len] += arg;
+					f->buf[len-1] += arg;
 				}
 			} else {
 				f->buf[len++] = arg;
@@ -220,7 +220,7 @@ static struct file *read_file(const char *fname)
 			expect_pulse = true;
 		} else if (strcmp(keyword, "pulse") == 0) {
 			if (!expect_pulse)
-				f->buf[len] += arg;
+				f->buf[len-1] += arg;
 			else
 				f->buf[len++] = arg;
 			expect_pulse = false;
-- 
2.7.4

