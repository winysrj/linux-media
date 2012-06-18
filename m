Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:38163 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752686Ab2FRTYL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Jun 2012 15:24:11 -0400
Received: by yhmm54 with SMTP id m54so4149641yhm.19
        for <linux-media@vger.kernel.org>; Mon, 18 Jun 2012 12:24:10 -0700 (PDT)
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: <linux-media@vger.kernel.org>,
	Ezequiel Garcia <elezegarcia@gmail.com>
Subject: [PATCH 04/12] cx23885: Use i2c_rc properly to store i2c register status
Date: Mon, 18 Jun 2012 16:23:37 -0300
Message-Id: <1340047425-32000-4-git-send-email-elezegarcia@gmail.com>
In-Reply-To: <1340047425-32000-1-git-send-email-elezegarcia@gmail.com>
References: <1340047425-32000-1-git-send-email-elezegarcia@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Ezequiel Garcia <elezegarcia@gmail.com>
---
 drivers/media/video/cx23885/cx23885-i2c.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/cx23885/cx23885-i2c.c b/drivers/media/video/cx23885/cx23885-i2c.c
index be1e21d..7a93fc6 100644
--- a/drivers/media/video/cx23885/cx23885-i2c.c
+++ b/drivers/media/video/cx23885/cx23885-i2c.c
@@ -331,7 +331,7 @@ int cx23885_i2c_register(struct cx23885_i2c *bus)
 	bus->i2c_algo.data = bus;
 	bus->i2c_adap.algo_data = bus;
 	i2c_set_adapdata(&bus->i2c_adap, &dev->v4l2_dev);
-	i2c_add_adapter(&bus->i2c_adap);
+	bus->i2c_rc = i2c_add_adapter(&bus->i2c_adap);
 
 	bus->i2c_client.adapter = &bus->i2c_adap;
 
-- 
1.7.4.4

