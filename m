Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vc0-f173.google.com ([209.85.220.173]:50414 "EHLO
	mail-vc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932549Ab3CSPmI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Mar 2013 11:42:08 -0400
Received: by mail-vc0-f173.google.com with SMTP id gd11so497729vcb.32
        for <linux-media@vger.kernel.org>; Tue, 19 Mar 2013 08:42:07 -0700 (PDT)
From: Eduardo Valentin <edubezval@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>,
	Eduardo Valentin <edubezval@gmail.com>
Subject: [PATCH 4/4] media: radio: add module alias entry for radio-si4713
Date: Tue, 19 Mar 2013 11:41:34 -0400
Message-Id: <1363707694-27224-5-git-send-email-edubezval@gmail.com>
In-Reply-To: <1363707694-27224-1-git-send-email-edubezval@gmail.com>
References: <1363707694-27224-1-git-send-email-edubezval@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add MODULE_ALIAS entry for radio-si4713 platform driver.

Signed-off-by: Eduardo Valentin <edubezval@gmail.com>
---
 drivers/media/radio/radio-si4713.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/media/radio/radio-si4713.c b/drivers/media/radio/radio-si4713.c
index ae70930..9dda9c3 100644
--- a/drivers/media/radio/radio-si4713.c
+++ b/drivers/media/radio/radio-si4713.c
@@ -43,6 +43,7 @@ MODULE_LICENSE("GPL v2");
 MODULE_AUTHOR("Eduardo Valentin <eduardo.valentin@nokia.com>");
 MODULE_DESCRIPTION("Platform driver for Si4713 FM Radio Transmitter");
 MODULE_VERSION("0.0.1");
+MODULE_ALIAS("platform:radio-si4713");
 
 /* Driver state struct */
 struct radio_si4713_device {
-- 
1.7.7.1.488.ge8e1c

