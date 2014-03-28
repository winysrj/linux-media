Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:36582 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751305AbaC1RVz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 28 Mar 2014 13:21:55 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH] adv7604: Mark adv7604_of_id table with __maybe_unused
Date: Fri, 28 Mar 2014 18:23:50 +0100
Message-Id: <1396027430-27328-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The table is always declared but is unused when both CONFIG_OF and
CONFIG_MODULES are not set. This results in a compile warning. Fix it by
marking the table as __maybe_unused. The compiler will discard it if
unused.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/i2c/adv7604.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/i2c/adv7604.c b/drivers/media/i2c/adv7604.c
index c864db9..5de6dad 100644
--- a/drivers/media/i2c/adv7604.c
+++ b/drivers/media/i2c/adv7604.c
@@ -2672,7 +2672,7 @@ static struct i2c_device_id adv7604_i2c_id[] = {
 };
 MODULE_DEVICE_TABLE(i2c, adv7604_i2c_id);
 
-static struct of_device_id adv7604_of_id[] = {
+static struct of_device_id adv7604_of_id[] __maybe_unused = {
 	{ .compatible = "adi,adv7604", .data = &adv7604_chip_info[ADV7604] },
 	{ .compatible = "adi,adv7611", .data = &adv7604_chip_info[ADV7611] },
 	{ }
-- 
Regards,

Laurent Pinchart

