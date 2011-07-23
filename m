Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:53643 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753265Ab1GWSzD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 23 Jul 2011 14:55:03 -0400
Date: Sat, 23 Jul 2011 21:53:03 +0300
From: Dan Carpenter <error27@gmail.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Hans de Goede <hdegoede@redhat.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	=?iso-8859-1?Q?Jean-Fran=E7ois?= Moine <moinejf@free.fr>,
	"open list:MEDIA INPUT INFRA..." <linux-media@vger.kernel.org>,
	kernel-janitors@vger.kernel.org
Subject: [patch] [media] pwc: precedence bug in pwc_init_controls()
Message-ID: <20110723185303.GA3711@shale.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

'!' has higher precedence than '&' so we need parenthesis here.

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/drivers/media/video/pwc/pwc-v4l.c b/drivers/media/video/pwc/pwc-v4l.c
index e9a0e94..8c70e64 100644
--- a/drivers/media/video/pwc/pwc-v4l.c
+++ b/drivers/media/video/pwc/pwc-v4l.c
@@ -338,7 +338,7 @@ int pwc_init_controls(struct pwc_device *pdev)
 	if (pdev->restore_factory)
 		pdev->restore_factory->flags = V4L2_CTRL_FLAG_UPDATE;
 
-	if (!pdev->features & FEATURE_MOTOR_PANTILT)
+	if (!(pdev->features & FEATURE_MOTOR_PANTILT))
 		return hdl->error;
 
 	/* Motor pan / tilt / reset */
