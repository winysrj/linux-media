Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f47.google.com ([74.125.82.47]:34355 "EHLO
	mail-wm0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751389AbcB0Tnc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 27 Feb 2016 14:43:32 -0500
From: Jannik Becher <becher.jannik@gmail.com>
To: crope@iki.fi
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	Jannik Becher <Becher.Jannik@gmail.com>
Subject: [PATCH] Media: usb: hackrf: fixed a style issue
Date: Sat, 27 Feb 2016 20:42:36 +0100
Message-Id: <1456602156-25011-1-git-send-email-Becher.Jannik@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fixed a coding style issue.

Signed-off-by: Jannik Becher <Becher.Jannik@gmail.com>
---
 drivers/media/usb/hackrf/hackrf.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/usb/hackrf/hackrf.c b/drivers/media/usb/hackrf/hackrf.c
index 9e700ca..186ef2d 100644
--- a/drivers/media/usb/hackrf/hackrf.c
+++ b/drivers/media/usb/hackrf/hackrf.c
@@ -249,6 +249,7 @@ static int hackrf_set_params(struct hackrf_dev *dev)
 	unsigned int uitmp, uitmp1, uitmp2;
 	const bool rx = test_bit(RX_ON, &dev->flags);
 	const bool tx = test_bit(TX_ON, &dev->flags);
+
 	static const struct {
 		u32 freq;
 	} bandwidth_lut[] = {
-- 
2.5.0

