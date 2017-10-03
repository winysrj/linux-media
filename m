Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:33085 "EHLO
        mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751128AbdJCLoz (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 3 Oct 2017 07:44:55 -0400
From: Arvind Yadav <arvind.yadav.cs@gmail.com>
To: gregkh@linuxfoundation.org, jacobvonchorus@cwphoto.ca,
        mchehab@kernel.org, eric@anholt.net, stefan.wahren@i2se.com,
        f.fainelli@gmail.com, rjui@broadcom.com, Larry.Finger@lwfinger.net,
        pkshih@realtek.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org
Subject: [PATCH 3/4] staging: bcm2835-camera: pr_err() strings should end with newlines
Date: Tue,  3 Oct 2017 17:13:25 +0530
Message-Id: <1507031006-16543-4-git-send-email-arvind.yadav.cs@gmail.com>
In-Reply-To: <1507031006-16543-1-git-send-email-arvind.yadav.cs@gmail.com>
References: <1507031006-16543-1-git-send-email-arvind.yadav.cs@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

pr_err() messages should end with a new-line to avoid other messages
being concatenated.

Signed-off-by: Arvind Yadav <arvind.yadav.cs@gmail.com>
---
 drivers/staging/vc04_services/bcm2835-camera/mmal-vchiq.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/vc04_services/bcm2835-camera/mmal-vchiq.c b/drivers/staging/vc04_services/bcm2835-camera/mmal-vchiq.c
index 4360db6..6ea7fb0 100644
--- a/drivers/staging/vc04_services/bcm2835-camera/mmal-vchiq.c
+++ b/drivers/staging/vc04_services/bcm2835-camera/mmal-vchiq.c
@@ -1963,7 +1963,7 @@ int vchiq_mmal_finalise(struct vchiq_mmal_instance *instance)
 
 	status = vchi_service_close(instance->handle);
 	if (status != 0)
-		pr_err("mmal-vchiq: VCHIQ close failed");
+		pr_err("mmal-vchiq: VCHIQ close failed\n");
 
 	mutex_unlock(&instance->vchiq_mutex);
 
-- 
1.9.1
