Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:63729 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751678Ab1KTO4a (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 20 Nov 2011 09:56:30 -0500
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id pAKEuUWF018480
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Sun, 20 Nov 2011 09:56:30 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [PATCH 7/8] [media] em28xx: Add IR support for em2884
Date: Sun, 20 Nov 2011 12:56:17 -0200
Message-Id: <1321800978-27912-7-git-send-email-mchehab@redhat.com>
In-Reply-To: <1321800978-27912-6-git-send-email-mchehab@redhat.com>
References: <1321800978-27912-1-git-send-email-mchehab@redhat.com>
 <1321800978-27912-2-git-send-email-mchehab@redhat.com>
 <1321800978-27912-3-git-send-email-mchehab@redhat.com>
 <1321800978-27912-4-git-send-email-mchehab@redhat.com>
 <1321800978-27912-5-git-send-email-mchehab@redhat.com>
 <1321800978-27912-6-git-send-email-mchehab@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/video/em28xx/em28xx-input.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/media/video/em28xx/em28xx-input.c b/drivers/media/video/em28xx/em28xx-input.c
index 679da48..2630b26 100644
--- a/drivers/media/video/em28xx/em28xx-input.c
+++ b/drivers/media/video/em28xx/em28xx-input.c
@@ -306,7 +306,8 @@ static void em28xx_ir_handle_key(struct em28xx_IR *ir)
 				   poll_result.rc_data[0],
 				   poll_result.toggle_bit);
 
-		if (ir->dev->chip_id == CHIP_ID_EM2874)
+		if (ir->dev->chip_id == CHIP_ID_EM2874 ||
+		    ir->dev->chip_id == CHIP_ID_EM2884)
 			/* The em2874 clears the readcount field every time the
 			   register is read.  The em2860/2880 datasheet says that it
 			   is supposed to clear the readcount, but it doesn't.  So with
@@ -371,13 +372,15 @@ int em28xx_ir_change_protocol(struct rc_dev *rc_dev, u64 rc_type)
 	case CHIP_ID_EM2883:
 		ir->get_key = default_polling_getkey;
 		break;
+	case CHIP_ID_EM2884:
 	case CHIP_ID_EM2874:
 	case CHIP_ID_EM28174:
 		ir->get_key = em2874_polling_getkey;
 		em28xx_write_regs(dev, EM2874_R50_IR_CONFIG, &ir_config, 1);
 		break;
 	default:
-		printk("Unrecognized em28xx chip id: IR not supported\n");
+		printk("Unrecognized em28xx chip id 0x%02x: IR not supported\n",
+			dev->chip_id);
 		rc = -EINVAL;
 	}
 
-- 
1.7.7.1

