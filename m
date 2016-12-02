Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([80.229.237.210]:32829 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752083AbcLBRUX (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 2 Dec 2016 12:20:23 -0500
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org
Subject: [PATCH v4l-utils 4/6] ir-ctl: improve scancode validation
Date: Fri,  2 Dec 2016 17:20:19 +0000
Message-Id: <1480699221-9267-4-git-send-email-sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Ensure rc6 mce is that just that and that nec32 is not necx or nec.

Signed-off-by: Sean Young <sean@mess.org>
---
 utils/ir-ctl/ir-ctl.c    |  4 ++--
 utils/ir-ctl/ir-encode.c | 18 ++++++++++++++++++
 utils/ir-ctl/ir-encode.h |  1 +
 3 files changed, 21 insertions(+), 2 deletions(-)

diff --git a/utils/ir-ctl/ir-ctl.c b/utils/ir-ctl/ir-ctl.c
index 768daad..53ff8ca 100644
--- a/utils/ir-ctl/ir-ctl.c
+++ b/utils/ir-ctl/ir-ctl.c
@@ -242,7 +242,7 @@ static struct file *read_file(const char *fname)
 				return NULL;
 			}
 
-			if (scancode & ~protocol_scancode_mask(proto)) {
+			if (!protocol_scancode_valid(proto, scancode)) {
 				fprintf(stderr, _("error: %s:%d: invalid scancode '%s' for protocol '%s'\n"), fname, lineno, scancodestr, protocol_name(proto));
 				return NULL;
 			}
@@ -354,7 +354,7 @@ static struct file *read_scancode(const char *name)
 		return NULL;
 	}
 
-	if (scancode & ~protocol_scancode_mask(proto)) {
+	if (!protocol_scancode_valid(proto, scancode)) {
 		fprintf(stderr, _("error: invalid scancode '%s' for protocol '%s'\n"), p + 1, protocol_name(proto));
 		return NULL;
 	}
diff --git a/utils/ir-ctl/ir-encode.c b/utils/ir-ctl/ir-encode.c
index 704ce95..d3ee035 100644
--- a/utils/ir-ctl/ir-encode.c
+++ b/utils/ir-ctl/ir-encode.c
@@ -417,6 +417,24 @@ unsigned protocol_scancode_mask(enum rc_proto proto)
 	return encoders[proto].scancode_mask;
 }
 
+bool protocol_scancode_valid(enum rc_proto p, unsigned s)
+{
+	if (s & ~encoders[p].scancode_mask)
+		return false;
+
+	if (p == RC_PROTO_NECX) {
+		return (((s >> 16) ^ ~(s >> 8)) & 0xff) != 0;
+	} else if (p == RC_PROTO_NEC32) {
+		return (((s >> 24) ^ ~(s >> 16)) & 0xff) != 0;
+	} else if (p == RC_PROTO_RC6_MCE) {
+		return (s & 0xffff0000) == 0x800f0000;
+	} else if (p == RC_PROTO_RC6_6A_32) {
+		return (s & 0xffff0000) != 0x800f0000;
+	}
+
+	return true;
+}
+
 unsigned protocol_encode(enum rc_proto proto, unsigned scancode, unsigned *buf)
 {
 	return encoders[proto].encode(proto, scancode, buf);
diff --git a/utils/ir-ctl/ir-encode.h b/utils/ir-ctl/ir-encode.h
index b2542ec..4a51f1c 100644
--- a/utils/ir-ctl/ir-encode.h
+++ b/utils/ir-ctl/ir-encode.h
@@ -28,6 +28,7 @@ enum rc_proto {
 bool protocol_match(const char *name, enum rc_proto *proto);
 unsigned protocol_carrier(enum rc_proto proto);
 unsigned protocol_max_size(enum rc_proto proto);
+bool protocol_scancode_valid(enum rc_proto proto, unsigned scancode);
 unsigned protocol_scancode_mask(enum rc_proto proto);
 unsigned protocol_encode(enum rc_proto proto, unsigned scancode, unsigned *buf);
 const char *protocol_name(enum rc_proto proto);
-- 
2.9.3

