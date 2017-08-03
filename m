Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:48659 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751736AbdHCVmd (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 3 Aug 2017 17:42:33 -0400
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org
Subject: [PATCH 1/4] ir-keytable: do not fail at the first transmit-only device
Date: Thu,  3 Aug 2017 22:42:27 +0100
Message-Id: <20170803214231.9334-1-sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

It is not possible to list all rc devices without this, since
it fails when ir-keytable encounters an rc device without an
input device (ie. IR transmitters).

Note that IR transmitters are not listed, but they are of no
interest to ir-keytable anyway.

Signed-off-by: Sean Young <sean@mess.org>
---
 utils/keytable/keytable.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/utils/keytable/keytable.c b/utils/keytable/keytable.c
index 634f4561..5572072a 100644
--- a/utils/keytable/keytable.c
+++ b/utils/keytable/keytable.c
@@ -1448,7 +1448,7 @@ static int show_sysfs_attribs(struct rc_device *rc_dev)
 	for (cur = names; cur->next; cur = cur->next) {
 		if (cur->name) {
 			if (get_attribs(rc_dev, cur->name))
-				return -1;
+				continue;
 			fprintf(stderr, _("Found %s (%s) with:\n"),
 				rc_dev->sysfs_name,
 				rc_dev->input_name);
-- 
2.11.0
