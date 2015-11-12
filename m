Return-path: <linux-media-owner@vger.kernel.org>
Received: from aer-iport-1.cisco.com ([173.38.203.51]:26598 "EHLO
	aer-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752191AbbKLPam (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Nov 2015 10:30:42 -0500
Received: from [10.47.79.222] ([10.47.79.222])
	(authenticated bits=0)
	by aer-core-4.cisco.com (8.14.5/8.14.5) with ESMTP id tACFUdq5015721
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
	for <linux-media@vger.kernel.org>; Thu, 12 Nov 2015 15:30:39 GMT
To: linux-media <linux-media@vger.kernel.org>
From: Hans Verkuil <hansverk@cisco.com>
Subject: adv7511: fix incorrect bit offset
Message-ID: <5644B09F.7040706@cisco.com>
Date: Thu, 12 Nov 2015 16:30:39 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The quantization bits are in bits 7-6, not 7-4, so shift by 6 instead of 4.

This bug is caused by a typo in the adv7511 datasheet.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

diff --git a/drivers/media/i2c/adv7511.c b/drivers/media/i2c/adv7511.c
index e4900df..b8de64c 100644
--- a/drivers/media/i2c/adv7511.c
+++ b/drivers/media/i2c/adv7511.c
@@ -1116,7 +1116,7 @@ static int adv7511_set_fmt(struct v4l2_subdev *sd,
 	adv7511_wr_and_or(sd, 0x55, 0x9f, y << 5);
 	adv7511_wr_and_or(sd, 0x56, 0x3f, c << 6);
 	adv7511_wr_and_or(sd, 0x57, 0x83, (ec << 4) | (q << 2));
-	adv7511_wr_and_or(sd, 0x59, 0x0f, yq << 4);
+	adv7511_wr_and_or(sd, 0x59, 0x3f, yq << 6);
 	adv7511_wr_and_or(sd, 0x4a, 0xff, 1);

 	return 0;
