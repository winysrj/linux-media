Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailrelay003.isp.belgacom.be ([195.238.6.53]:34941 "EHLO
	mailrelay003.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752028AbZJCOve (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 3 Oct 2009 10:51:34 -0400
Message-ID: <4AC764A3.9000708@computer.org>
Date: Sat, 03 Oct 2009 16:50:11 +0200
From: Jan Ceuleers <jan.ceuleers@computer.org>
MIME-Version: 1.0
To: Michael Hunold <michael@mihu.de>
CC: linux-media@vger.kernel.org
Subject: [PATCH] drivers/media/video/saa7164: memset region size error
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

>From 357033c321c3d9a98300b7dbe330fbb5008c092b Mon Sep 17 00:00:00 2001
From: Jan Ceuleers <jan.ceuleers@computer.org>
Date: Sat, 3 Oct 2009 16:42:15 +0200
Subject: [PATCH] drivers/media/video/saa7164: memset region size error

The size of the region to be memset() should be the size
of the target rather than the size of the pointer to it.

Compile-tested only.

Signed-off-by: Jan Ceuleers <jan.ceuleers@computer.org>
---
 drivers/media/video/saa7164/saa7164-cmd.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/saa7164/saa7164-cmd.c b/drivers/media/video/saa7164/saa7164-cmd.c
index c45966e..9c1d3ac 100644
--- a/drivers/media/video/saa7164/saa7164-cmd.c
+++ b/drivers/media/video/saa7164/saa7164-cmd.c
@@ -347,7 +347,7 @@ int saa7164_cmd_send(struct saa7164_dev *dev, u8 id, tmComResCmd_t command,
 
 	/* Prepare some basic command/response structures */
 	memset(&command_t, 0, sizeof(command_t));
-	memset(&response_t, 0, sizeof(&response_t));
+	memset(&response_t, 0, sizeof(response_t));
 	pcommand_t = &command_t;
 	presponse_t = &response_t;
 	command_t.id = id;
-- 
1.5.4.3

