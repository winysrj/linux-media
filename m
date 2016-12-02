Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([80.229.237.210]:36405 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751070AbcLBRUX (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 2 Dec 2016 12:20:23 -0500
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org
Subject: [PATCH v4l-utils 6/6] ir-ctl: rename rc5x to rc5x_20
Date: Fri,  2 Dec 2016 17:20:21 +0000
Message-Id: <1480699221-9267-6-git-send-email-sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There are many extended rc5 protocols and we can only generate the 20
bit variant.

Signed-off-by: Sean Young <sean@mess.org>
---
 utils/ir-ctl/ir-ctl.1.in | 7 ++++---
 utils/ir-ctl/ir-encode.c | 4 ++--
 utils/ir-ctl/ir-encode.h | 2 +-
 3 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/utils/ir-ctl/ir-ctl.1.in b/utils/ir-ctl/ir-ctl.1.in
index a1d5aeb..c2e0094 100644
--- a/utils/ir-ctl/ir-ctl.1.in
+++ b/utils/ir-ctl/ir-ctl.1.in
@@ -177,9 +177,10 @@ there are limits to what lirc devices can send in one go.
 .SS Supported Protocols
 A scancode with protocol can be specified on the command line or in the
 pulse and space file. The following protocols are supported:
-\fBrc5\fR, \fBrc5x\fR, \fBrc5_sz\fR, \fBjvc\fR, \fBsony12\fR, \fBsony\fB15\fR,
-\fBsony20\fR, \fBnec\fR, \fBnecx\fR, \fBnec32\fR, \fBsanyo\fR, \fBrc6_0\fR,
-\fBrc6_6a_20\fR, \fBrc6_6a_24\fR, \fBrc6_6a_32\fR, \fBrc6_mce\fR, \fBsharp\fR.
+\fBrc5\fR, \fBrc5x_20\fR, \fBrc5_sz\fR, \fBjvc\fR, \fBsony12\fR,
+\fBsony\fB15\fR, \fBsony20\fR, \fBnec\fR, \fBnecx\fR, \fBnec32\fR,
+\fBsanyo\fR, \fBrc6_0\fR, \fBrc6_6a_20\fR, \fBrc6_6a_24\fR, \fBrc6_6a_32\fR,
+\fBrc6_mce\fR, \fBsharp\fR.
 If the scancode starts with 0x it will be interpreted as a
 hexidecimal number, and if it starts with 0 it will be interpreted as an
 octal number.
diff --git a/utils/ir-ctl/ir-encode.c b/utils/ir-ctl/ir-encode.c
index d3ee035..9cc8c5d 100644
--- a/utils/ir-ctl/ir-encode.c
+++ b/utils/ir-ctl/ir-encode.c
@@ -260,7 +260,7 @@ static int rc5_encode(enum rc_proto proto, unsigned scancode, unsigned *buf)
 		add_bits(scancode >> 6, 6);
 		add_bits(scancode, 6);
 		break;
-	case RC_PROTO_RC5X:
+	case RC_PROTO_RC5X_20:
 		add_bits(!(scancode & 0x4000), 1);
 		add_bits(0, 1);
 		add_bits(scancode >> 16, 5);
@@ -350,7 +350,7 @@ static const struct {
 	int (*encode)(enum rc_proto proto, unsigned scancode, unsigned *buf);
 } encoders[RC_PROTO_COUNT] = {
 	[RC_PROTO_RC5] = { "rc5", 0x1f3f, 24, 36000, rc5_encode },
-	[RC_PROTO_RC5X] = { "rc5x", 0x1f7f3f, 40, 36000, rc5_encode },
+	[RC_PROTO_RC5X_20] = { "rc5x_20", 0x1f7f3f, 40, 36000, rc5_encode },
 	[RC_PROTO_RC5_SZ] = { "rc5_sz", 0x2fff, 26, 36000, rc5_encode },
 	[RC_PROTO_SONY12] = { "sony12", 0x1f007f, 25, 40000, sony_encode },
 	[RC_PROTO_SONY15] = { "sony15", 0xff007f, 31, 40000, sony_encode },
diff --git a/utils/ir-ctl/ir-encode.h b/utils/ir-ctl/ir-encode.h
index 4a51f1c..31d81aa 100644
--- a/utils/ir-ctl/ir-encode.h
+++ b/utils/ir-ctl/ir-encode.h
@@ -4,7 +4,7 @@
 
 enum rc_proto {
 	RC_PROTO_RC5,
-	RC_PROTO_RC5X,
+	RC_PROTO_RC5X_20,
 	RC_PROTO_RC5_SZ,
 	RC_PROTO_JVC,
 	RC_PROTO_SONY12,
-- 
2.9.3

