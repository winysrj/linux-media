Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f43.google.com ([209.85.215.43]:39988 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752611Ab3CFWah (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 Mar 2013 17:30:37 -0500
Received: by mail-la0-f43.google.com with SMTP id ek20so8024724lab.30
        for <linux-media@vger.kernel.org>; Wed, 06 Mar 2013 14:30:36 -0800 (PST)
Date: Thu, 7 Mar 2013 02:23:07 +0400
From: Volokh Konstantin <volokh84@gmail.com>
To: hverkuil@xs4all.nl, volokh84@gmail.com
Cc: linux-media@vger.kernel.org
Subject: [PATCH 2/2] hverkuil/go7007: media: i2c: Correct authorship info
Message-ID: <20130306222307.GD10958@Volokh.Home>
References: <1362562084-26910-1-git-send-email-volokh84@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1362562084-26910-1-git-send-email-volokh84@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Volokh Konstantin <volokh84@gmail.com>
---
 drivers/media/i2c/tw2804.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/media/i2c/tw2804.c b/drivers/media/i2c/tw2804.c
index 096b657..45a4cd3 100644
--- a/drivers/media/i2c/tw2804.c
+++ b/drivers/media/i2c/tw2804.c
@@ -431,5 +431,4 @@ module_i2c_driver(wis_tw2804_driver);
 
 MODULE_LICENSE("GPL v2");
 MODULE_DESCRIPTION("TW2804/TW2802 V4L2 i2c driver");
-MODULE_AUTHOR("Volokh Konstantin <volokh84@gmail.com>");
 MODULE_AUTHOR("Micronas USA Inc");
-- 
1.7.7.6

