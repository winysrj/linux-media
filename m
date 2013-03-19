Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vc0-f177.google.com ([209.85.220.177]:49874 "EHLO
	mail-vc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756741Ab3CSPmC (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Mar 2013 11:42:02 -0400
Received: by mail-vc0-f177.google.com with SMTP id ia10so492025vcb.36
        for <linux-media@vger.kernel.org>; Tue, 19 Mar 2013 08:42:02 -0700 (PDT)
From: Eduardo Valentin <edubezval@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>,
	Eduardo Valentin <edubezval@gmail.com>
Subject: [PATCH 2/4] media: radio: correct module license (==> GPL v2)
Date: Tue, 19 Mar 2013 11:41:32 -0400
Message-Id: <1363707694-27224-3-git-send-email-edubezval@gmail.com>
In-Reply-To: <1363707694-27224-1-git-send-email-edubezval@gmail.com>
References: <1363707694-27224-1-git-send-email-edubezval@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As per code header comment, changing the driver license entry
to match the correct version.

Signed-off-by: Eduardo Valentin <edubezval@gmail.com>
---
 drivers/media/radio/radio-si4713.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/radio/radio-si4713.c b/drivers/media/radio/radio-si4713.c
index 5b5c42b..cd30a89 100644
--- a/drivers/media/radio/radio-si4713.c
+++ b/drivers/media/radio/radio-si4713.c
@@ -39,7 +39,7 @@ module_param(radio_nr, int, 0);
 MODULE_PARM_DESC(radio_nr,
 		 "Minor number for radio device (-1 ==> auto assign)");
 
-MODULE_LICENSE("GPL");
+MODULE_LICENSE("GPL v2");
 MODULE_AUTHOR("Eduardo Valentin <eduardo.valentin@nokia.com>");
 MODULE_DESCRIPTION("Platform driver for Si4713 FM Radio Transmitter");
 MODULE_VERSION("0.0.1");
-- 
1.7.7.1.488.ge8e1c

