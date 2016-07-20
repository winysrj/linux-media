Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([80.229.237.210]:53529 "EHLO gofer.mess.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753212AbcGTOI3 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 20 Jul 2016 10:08:29 -0400
From: Sean Young <sean@mess.org>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: linux-media@vger.kernel.org
Subject: [PATCH] ir-ctl: give proper error message if transmitter does not exist
Date: Wed, 20 Jul 2016 15:08:27 +0100
Message-Id: <1469023707-3248-1-git-send-email-sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

If a transmitter does not exist when setting using -e, you get the error:

warning: /dev/lirc0: failed to set send transmitters: Success

Signed-off-by: Sean Young <sean@mess.org>
---
 utils/ir-ctl/ir-ctl.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/utils/ir-ctl/ir-ctl.c b/utils/ir-ctl/ir-ctl.c
index 05b46a3..229330e 100644
--- a/utils/ir-ctl/ir-ctl.c
+++ b/utils/ir-ctl/ir-ctl.c
@@ -516,7 +516,9 @@ static int lirc_options(struct arguments *args, int fd, unsigned features)
 	if (args->emitters) {
 		if (features & LIRC_CAN_SET_TRANSMITTER_MASK) {
 			rc = ioctl(fd, LIRC_SET_TRANSMITTER_MASK, &args->emitters);
-			if (rc)
+			if (rc > 0)
+				fprintf(stderr, _("warning: %s: failed to set send transmitters: only %d available\n"), dev, rc);
+			else if (rc < 0)
 				fprintf(stderr, _("warning: %s: failed to set send transmitters: %m\n"), dev);
 		} else
 			fprintf(stderr, _("warning: %s: does not support setting send transmitters\n"), dev);
-- 
2.7.4

