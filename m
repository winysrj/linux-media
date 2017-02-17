Return-path: <linux-media-owner@vger.kernel.org>
Received: from userp1050.oracle.com ([156.151.31.82]:28595 "EHLO
        userp1050.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S964868AbdBQXWb (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 17 Feb 2017 18:22:31 -0500
Date: Sat, 18 Feb 2017 02:20:36 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Eric Anholt <eric@anholt.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Lee Jones <lee@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Ray Jui <rjui@broadcom.com>,
        Scott Branden <sbranden@broadcom.com>,
        bcm-kernel-feedback-list@broadcom.com,
        Michael Zoran <mzoran@crowfest.net>,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-rpi-kernel@lists.infradead.org,
        kernel-janitors@vger.kernel.org
Subject: [patch] staging: bcm2835/mmal-vchiq: unlock on error in
 buffer_from_host()
Message-ID: <20170217232035.GB26717@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

We should unlock before returning on this error path.

Fixes: 7b3ad5abf027 ("staging: Import the BCM2835 MMAL-based V4L2 camera driver.")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/staging/media/platform/bcm2835/mmal-vchiq.c b/drivers/staging/media/platform/bcm2835/mmal-vchiq.c
index f0639ee6c8b9..fdfb6a620a43 100644
--- a/drivers/staging/media/platform/bcm2835/mmal-vchiq.c
+++ b/drivers/staging/media/platform/bcm2835/mmal-vchiq.c
@@ -397,8 +397,10 @@ buffer_from_host(struct vchiq_mmal_instance *instance,
 
 	/* get context */
 	msg_context = get_msg_context(instance);
-	if (msg_context == NULL)
-		return -ENOMEM;
+	if (!msg_context) {
+		ret = -ENOMEM;
+		goto unlock;
+	}
 
 	/* store bulk message context for when data arrives */
 	msg_context->u.bulk.instance = instance;
@@ -454,6 +456,7 @@ buffer_from_host(struct vchiq_mmal_instance *instance,
 
 	vchi_service_release(instance->handle);
 
+unlock:
 	mutex_unlock(&instance->bulk_mutex);
 
 	return ret;
