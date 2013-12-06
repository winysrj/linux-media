Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:1092 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757377Ab3LFKRq (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 6 Dec 2013 05:17:46 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Dinesh.Ram@cern.ch, edubezval@gmail.com,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv2 10/11] si4713: print product number
Date: Fri,  6 Dec 2013 11:17:13 +0100
Message-Id: <1386325034-19344-11-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1386325034-19344-1-git-send-email-hverkuil@xs4all.nl>
References: <1386325034-19344-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Eduardo Valentin <edubezval@gmail.com>

Print the PN value, useful to check what chip the dev board has.

Signed-off-by: Eduardo Valentin <edubezval@gmail.com>
Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/radio/si4713/si4713.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/radio/si4713/si4713.c b/drivers/media/radio/si4713/si4713.c
index 17e0106..6f28a2b 100644
--- a/drivers/media/radio/si4713/si4713.c
+++ b/drivers/media/radio/si4713/si4713.c
@@ -464,7 +464,7 @@ static int si4713_checkrev(struct si4713_device *sdev)
 		v4l2_info(&sdev->sd, "chip found @ 0x%02x (%s)\n",
 				client->addr << 1, client->adapter->name);
 	} else {
-		v4l2_err(&sdev->sd, "Invalid product number\n");
+		v4l2_err(&sdev->sd, "Invalid product number 0x%X\n", resp[1]);
 		rval = -EINVAL;
 	}
 	return rval;
-- 
1.8.4.rc3

