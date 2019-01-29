Return-Path: <SRS0=OvUS=QF=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8330C169C4
	for <linux-media@archiver.kernel.org>; Tue, 29 Jan 2019 16:34:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C37ED20869
	for <linux-media@archiver.kernel.org>; Tue, 29 Jan 2019 16:34:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728344AbfA2QeC (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 29 Jan 2019 11:34:02 -0500
Received: from gofer.mess.org ([88.97.38.141]:55585 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726420AbfA2QeB (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 29 Jan 2019 11:34:01 -0500
Received: by gofer.mess.org (Postfix, from userid 1000)
        id C9443601E2; Tue, 29 Jan 2019 16:34:00 +0000 (GMT)
From:   Sean Young <sean@mess.org>
To:     linux-media@vger.kernel.org
Subject: [PATCH v4l-utils] Print receiver timeout
Date:   Tue, 29 Jan 2019 16:34:00 +0000
Message-Id: <20190129163400.22280-1-sean@mess.org>
X-Mailer: git-send-email 2.11.0
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Signed-off-by: Sean Young <sean@mess.org>
---
 utils/ir-ctl/ir-ctl.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/utils/ir-ctl/ir-ctl.c b/utils/ir-ctl/ir-ctl.c
index 7ecb1317..f8f4e0aa 100644
--- a/utils/ir-ctl/ir-ctl.c
+++ b/utils/ir-ctl/ir-ctl.c
@@ -708,8 +708,13 @@ static void lirc_features(struct arguments *args, int fd, unsigned features)
 		if (features & LIRC_CAN_MEASURE_CARRIER)
 			printf(_(" - Can measure carrier\n"));
 		if (features & LIRC_CAN_SET_REC_TIMEOUT) {
-			unsigned min_timeout, max_timeout;
-			int rc = ioctl(fd, LIRC_GET_MIN_TIMEOUT, &min_timeout);
+			unsigned min_timeout, max_timeout, timeout;
+
+			// This ioctl is only supported from kernel 4.18 onwards
+			int rc = ioctl(fd, LIRC_GET_REC_TIMEOUT, &timeout);
+			if (rc == 0)
+				printf(_(" - Receiving timeout %u microseconds\n"), timeout);
+			rc = ioctl(fd, LIRC_GET_MIN_TIMEOUT, &min_timeout);
 			if (rc) {
 				fprintf(stderr, _("warning: %s: device supports setting receiving timeout but LIRC_GET_MIN_TIMEOUT returns: %m\n"), dev);
 				min_timeout = 0;
@@ -724,7 +729,7 @@ static void lirc_features(struct arguments *args, int fd, unsigned features)
 			}
 
 			if (min_timeout || max_timeout)
-				printf(_(" - Can set receiving timeout min:%u microseconds max:%u microseconds\n"), min_timeout, max_timeout);
+				printf(_(" - Can set receiving timeout min %u microseconds, max %u microseconds\n"), min_timeout, max_timeout);
 		}
 	} else if (features & LIRC_CAN_REC_LIRCCODE) {
 		printf(_(" - Device can receive using device dependent LIRCCODE mode (not supported)\n"));
-- 
2.20.1

