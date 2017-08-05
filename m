Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:50569 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751250AbdHEKDh (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 5 Aug 2017 06:03:37 -0400
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org
Subject: [PATCH] ir-keytable: null deref if kernel compiled without CONFIG_INPUT_EVDEV
Date: Sat,  5 Aug 2017 11:03:36 +0100
Message-Id: <20170805100336.29285-1-sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Sean Young <sean@mess.org>
---
 utils/keytable/keytable.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/utils/keytable/keytable.c b/utils/keytable/keytable.c
index 5572072a..5b2b0af6 100644
--- a/utils/keytable/keytable.c
+++ b/utils/keytable/keytable.c
@@ -1035,10 +1035,8 @@ static int get_attribs(struct rc_device *rc_dev, char *sysfs_name)
 
 	event_names = seek_sysfs_dir(input_names->name, event);
 	free_names(input_names);
-	if (!event_names) {
-		free_names(event_names);
+	if (!event_names)
 		return EINVAL;
-	}
 	if (event_names->next->next) {
 		free_names(event_names);
 		fprintf(stderr, _("Found more than one event interface. This is currently unsupported\n"));
-- 
2.11.0
