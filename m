Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gh0-f174.google.com ([209.85.160.174]:38201 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752686Ab2FRTYW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Jun 2012 15:24:22 -0400
Received: by mail-gh0-f174.google.com with SMTP id r11so3997516ghr.19
        for <linux-media@vger.kernel.org>; Mon, 18 Jun 2012 12:24:22 -0700 (PDT)
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: <linux-media@vger.kernel.org>,
	Ezequiel Garcia <elezegarcia@gmail.com>
Subject: [PATCH 10/12] cx25821: Use i2c_rc properly to store i2c register status
Date: Mon, 18 Jun 2012 16:23:43 -0300
Message-Id: <1340047425-32000-10-git-send-email-elezegarcia@gmail.com>
In-Reply-To: <1340047425-32000-1-git-send-email-elezegarcia@gmail.com>
References: <1340047425-32000-1-git-send-email-elezegarcia@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Ezequiel Garcia <elezegarcia@gmail.com>
---
 drivers/media/video/cx25821/cx25821-i2c.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/cx25821/cx25821-i2c.c b/drivers/media/video/cx25821/cx25821-i2c.c
index 6311180..398e0e6 100644
--- a/drivers/media/video/cx25821/cx25821-i2c.c
+++ b/drivers/media/video/cx25821/cx25821-i2c.c
@@ -319,7 +319,7 @@ int cx25821_i2c_register(struct cx25821_i2c *bus)
 	bus->i2c_algo.data = bus;
 	bus->i2c_adap.algo_data = bus;
 	i2c_set_adapdata(&bus->i2c_adap, &dev->v4l2_dev);
-	i2c_add_adapter(&bus->i2c_adap);
+	bus->i2c_rc = i2c_add_adapter(&bus->i2c_adap);
 
 	bus->i2c_client.adapter = &bus->i2c_adap;
 
-- 
1.7.4.4

