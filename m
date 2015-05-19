Return-path: <linux-media-owner@vger.kernel.org>
Received: from vader.hardeman.nu ([95.142.160.32]:50811 "EHLO hardeman.nu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752276AbbESWLo (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 19 May 2015 18:11:44 -0400
Subject: [PATCH 1/4] rc-core: fix remove uevent generation
From: David =?utf-8?b?SMOkcmRlbWFu?= <david@hardeman.nu>
To: linux-media@vger.kernel.org
Cc: m.chehab@samsung.com
Date: Wed, 20 May 2015 00:03:12 +0200
Message-ID: <20150519220312.3467.3382.stgit@zeus.muc.hardeman.nu>
In-Reply-To: <20150519220101.3467.16288.stgit@zeus.muc.hardeman.nu>
References: <20150519220101.3467.16288.stgit@zeus.muc.hardeman.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The input_dev is already gone when the rc device is being unregistered
so checking for its presence only means that no remove uevent will be
generated.

Cc: stable@kernel.org
Signed-off-by: David Härdeman <david@hardeman.nu>
---
 drivers/media/rc/rc-main.c |    3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/media/rc/rc-main.c b/drivers/media/rc/rc-main.c
index 9d015db..84d142b 100644
--- a/drivers/media/rc/rc-main.c
+++ b/drivers/media/rc/rc-main.c
@@ -1193,9 +1193,6 @@ static int rc_dev_uevent(struct device *device, struct kobj_uevent_env *env)
 {
 	struct rc_dev *dev = to_rc_dev(device);
 
-	if (!dev || !dev->input_dev)
-		return -ENODEV;
-
 	if (dev->rc_map.name)
 		ADD_HOTPLUG_VAR("NAME=%s", dev->rc_map.name);
 	if (dev->driver_name)

