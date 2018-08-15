Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:60383 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728810AbeHONNz (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 15 Aug 2018 09:13:55 -0400
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org
Subject: [PATCH 2/2] ir-ctl: different drivers have different default timeouts
Date: Wed, 15 Aug 2018 11:22:19 +0100
Message-Id: <20180815102219.4587-2-sean@mess.org>
In-Reply-To: <20180815102219.4587-1-sean@mess.org>
References: <20180815102219.4587-1-sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

A driver might not support setting the timeout either, in addition,
if a device does not support measuring the carrier, or has no wideband
receiver, this command will also produce an error.

Signed-off-by: Sean Young <sean@mess.org>
---
 utils/ir-ctl/ir-ctl.1.in | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/utils/ir-ctl/ir-ctl.1.in b/utils/ir-ctl/ir-ctl.1.in
index f42d8da0..2a148c70 100644
--- a/utils/ir-ctl/ir-ctl.1.in
+++ b/utils/ir-ctl/ir-ctl.1.in
@@ -224,10 +224,6 @@ To send the pulse and space file \fBplay\fR on emitter 3:
 To send the rc-5 hauppauge '1' scancode:
 .br
 	\fBir\-ctl \-S rc5:0x1e01
-.PP
-To restore the IR receiver on /dev/lirc2 to the default state:
-.br
-	\fBir\-ctl \-Mn \-\-timeout 125000 \-\-device=/dev/lirc2\fR
 .SH BUGS
 Report bugs to \fBLinux Media Mailing List <linux-media@vger.kernel.org>\fR
 .SH COPYRIGHT
-- 
2.17.1
