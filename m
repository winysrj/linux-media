Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f180.google.com ([74.125.82.180]:48400 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932632AbaIEOTx (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 5 Sep 2014 10:19:53 -0400
Received: by mail-we0-f180.google.com with SMTP id w61so11921754wes.11
        for <linux-media@vger.kernel.org>; Fri, 05 Sep 2014 07:19:51 -0700 (PDT)
From: Jean-Michel Hautbois <jean-michel.hautbois@vodalys.com>
To: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	devicetree@vger.kernel.org
Cc: m.chehab@samsung.com, hans.verkuil@cisco.com,
	laurent.pinchart@ideasonboard.com, mark.rutland@arm.com,
	lars@metafoo.de,
	Jean-Michel Hautbois <jean-michel.hautbois@vodalys.com>
Subject: [PATCH 2/2] adv7604: Add DT parsing support
Date: Fri,  5 Sep 2014 16:19:33 +0200
Message-Id: <1409926773-30696-2-git-send-email-jean-michel.hautbois@vodalys.com>
In-Reply-To: <1409926773-30696-1-git-send-email-jean-michel.hautbois@vodalys.com>
References: <1409926773-30696-1-git-send-email-jean-michel.hautbois@vodalys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This allows specifying I²C secodnary addresses different from default ones.

Signed-off-by: Jean-Michel Hautbois <jean-michel.hautbois@vodalys.com>
---
 drivers/media/i2c/adv7604.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/i2c/adv7604.c b/drivers/media/i2c/adv7604.c
index 8336c02..75613a4 100644
--- a/drivers/media/i2c/adv7604.c
+++ b/drivers/media/i2c/adv7604.c
@@ -2705,6 +2705,7 @@ MODULE_DEVICE_TABLE(i2c, adv7604_i2c_id);
 
 static struct of_device_id adv7604_of_id[] __maybe_unused = {
 	{ .compatible = "adi,adv7611", .data = &adv7604_chip_info[ADV7611] },
+	{ .compatible = "adi,adv7604", .data = &adv7604_chip_info[ADV7604] },
 	{ }
 };
 MODULE_DEVICE_TABLE(of, adv7604_of_id);
-- 
2.0.4

