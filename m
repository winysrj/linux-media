Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:59021 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752499AbdK2URe (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 29 Nov 2017 15:17:34 -0500
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org
Cc: Matthias Reichl <hias@horus.com>
Subject: [PATCH 1/2] ir-ctl: fix multiple scancodes in one file
Date: Wed, 29 Nov 2017 20:17:31 +0000
Message-Id: <20171129201732.23797-1-sean@mess.org>
In-Reply-To: <20171129200521.z4phw7kzcmf56qgi@gofer.mess.org>
References: <20171129200521.z4phw7kzcmf56qgi@gofer.mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

A file with contents:

scancode sony12:0x100015
space 25000
scancode sony12:0x100015

Will produce bogus results.

Reported-by: Matthias Reichl <hias@horus.com>
Signed-off-by: Sean Young <sean@mess.org>
---
 utils/ir-ctl/ir-ctl.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/utils/ir-ctl/ir-ctl.c b/utils/ir-ctl/ir-ctl.c
index 544ad341..8538ec5d 100644
--- a/utils/ir-ctl/ir-ctl.c
+++ b/utils/ir-ctl/ir-ctl.c
@@ -230,8 +230,8 @@ static struct file *read_file(const char *fname)
 			char *scancodestr;
 
 			if (!expect_pulse) {
-				fprintf(stderr, _("error: %s:%d: space must precede scancode\n"), fname, lineno);
-				return NULL;
+				f->buf[len++] = IR_DEFAULT_TIMEOUT;
+				expect_pulse = true;
 			}
 
 			scancodestr = strchr(p, ':');
@@ -268,7 +268,8 @@ static struct file *read_file(const char *fname)
 			else
 				f->carrier = carrier;
 
-			len += protocol_encode(proto, scancode, f->buf);
+			len += protocol_encode(proto, scancode, f->buf + len);
+			expect_pulse = false;
 			continue;
 		}
 
-- 
2.14.3
