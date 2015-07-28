Return-path: <linux-media-owner@vger.kernel.org>
Received: from atl4mhfb02.myregisteredsite.com ([209.17.115.56]:35542 "EHLO
	atl4mhfb02.myregisteredsite.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751688AbbG1FpE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 28 Jul 2015 01:45:04 -0400
Received: from atl4mhob11.myregisteredsite.com (atl4mhob11.myregisteredsite.com [209.17.115.49])
	by atl4mhfb02.myregisteredsite.com (8.14.4/8.14.4) with ESMTP id t6S5e2lM025882
	for <linux-media@vger.kernel.org>; Tue, 28 Jul 2015 01:40:02 -0400
Received: from mailpod.hostingplatform.com ([10.30.71.204])
	by atl4mhob11.myregisteredsite.com (8.14.4/8.14.4) with ESMTP id t6S5dx3r012464
	for <linux-media@vger.kernel.org>; Tue, 28 Jul 2015 01:39:59 -0400
From: Mike Looijmans <mike.looijmans@topic.nl>
To: linux-media@vger.kernel.org
Cc: dragos.bogdan@analog.com, mchehab@osg.samsung.com, lars@metafoo.de,
	Mike Looijmans <mike.looijmans@topic.nl>
Subject: [PATCH] [media] imageon-bridge: Add module license information
Date: Tue, 28 Jul 2015 07:39:45 +0200
Message-Id: <1438061985-2786-1-git-send-email-mike.looijmans@topic.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Comment header specifies GPL-2, so add a MODULE_LICENSE("GPL v2").
This fixes the driver failing to load when built as module:
  imageon_bridge: module license 'unspecified' taints kernel.
  imageon_bridge: Unknown symbol ...
As an extra service, also add a description.

Signed-off-by: Mike Looijmans <mike.looijmans@topic.nl>
---
 drivers/media/platform/imageon-bridge.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/media/platform/imageon-bridge.c b/drivers/media/platform/imageon-bridge.c
index 9550695..a69b6da 100644
--- a/drivers/media/platform/imageon-bridge.c
+++ b/drivers/media/platform/imageon-bridge.c
@@ -317,3 +317,6 @@ static struct platform_driver imageon_bridge_driver = {
 	.remove = imageon_bridge_remove,
 };
 module_platform_driver(imageon_bridge_driver);
+
+MODULE_DESCRIPTION("Imageon video bridge");
+MODULE_LICENSE("GPL v2");
-- 
1.9.1

