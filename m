Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vb0-f50.google.com ([209.85.212.50]:46518 "EHLO
	mail-vb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932549Ab3CSPmG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Mar 2013 11:42:06 -0400
Received: by mail-vb0-f50.google.com with SMTP id ft2so401547vbb.37
        for <linux-media@vger.kernel.org>; Tue, 19 Mar 2013 08:42:04 -0700 (PDT)
From: Eduardo Valentin <edubezval@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>,
	Eduardo Valentin <edubezval@gmail.com>
Subject: [PATCH 3/4] media: radio: add driver owner entry for radio-si4713
Date: Tue, 19 Mar 2013 11:41:33 -0400
Message-Id: <1363707694-27224-4-git-send-email-edubezval@gmail.com>
In-Reply-To: <1363707694-27224-1-git-send-email-edubezval@gmail.com>
References: <1363707694-27224-1-git-send-email-edubezval@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Simple addition of platform_driver->driver->owner for radio-si4713.

Signed-off-by: Eduardo Valentin <edubezval@gmail.com>
---
 drivers/media/radio/radio-si4713.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/media/radio/radio-si4713.c b/drivers/media/radio/radio-si4713.c
index cd30a89..ae70930 100644
--- a/drivers/media/radio/radio-si4713.c
+++ b/drivers/media/radio/radio-si4713.c
@@ -347,6 +347,7 @@ static int __exit radio_si4713_pdriver_remove(struct platform_device *pdev)
 static struct platform_driver radio_si4713_pdriver = {
 	.driver		= {
 		.name	= "radio-si4713",
+		.owner	= THIS_MODULE,
 	},
 	.probe		= radio_si4713_pdriver_probe,
 	.remove         = __exit_p(radio_si4713_pdriver_remove),
-- 
1.7.7.1.488.ge8e1c

