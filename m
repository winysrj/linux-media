Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:59995 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756497AbcECU2P (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 3 May 2016 16:28:15 -0400
From: Javier Martinez Canillas <javier@osg.samsung.com>
To: linux-kernel@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
	Krzysztof Kozlowski <k.kozlowski@samsung.com>,
	Javier Martinez Canillas <javier@osg.samsung.com>,
	<stable@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Kamil Debski <k.debski@samsung.com>,
	Jeongtae Park <jtp.park@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org
Subject: [PATCH 1/3] [media] s5p-mfc: Set device name for reserved memory region devs
Date: Tue,  3 May 2016 16:27:16 -0400
Message-Id: <1462307238-21815-2-git-send-email-javier@osg.samsung.com>
In-Reply-To: <1462307238-21815-1-git-send-email-javier@osg.samsung.com>
References: <1462307238-21815-1-git-send-email-javier@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The devices don't have a name set, so makes dev_name() returns NULL which
makes harder to identify the devices that are causing issues, for example:

WARNING: CPU: 2 PID: 616 at drivers/base/core.c:251 device_release+0x8c/0x90
Device '(null)' does not have a release() function, it is broken and must be fixed.

And after setting the device name:

WARNING: CPU: 0 PID: 591 at drivers/base/core.c:251 device_release+0x8c/0x90
Device 's5p-mfc-l' does not have a release() function, it is broken and must be fixed.

Cc: <stable@vger.kernel.org>
Fixes: 6e83e6e25eb4 ("[media] s5p-mfc: Fix kernel warning on memory init")
Signed-off-by: Javier Martinez Canillas <javier@osg.samsung.com>

---

 drivers/media/platform/s5p-mfc/s5p_mfc.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc.c b/drivers/media/platform/s5p-mfc/s5p_mfc.c
index b16466fe35ee..8fc1fd4ee2ed 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc.c
@@ -1062,6 +1062,8 @@ static int s5p_mfc_alloc_memdevs(struct s5p_mfc_dev *dev)
 		mfc_err("Not enough memory\n");
 		return -ENOMEM;
 	}
+
+	dev_set_name(dev->mem_dev_l, "%s", "s5p-mfc-l");
 	device_initialize(dev->mem_dev_l);
 	of_property_read_u32_array(dev->plat_dev->dev.of_node,
 			"samsung,mfc-l", mem_info, 2);
@@ -1079,6 +1081,8 @@ static int s5p_mfc_alloc_memdevs(struct s5p_mfc_dev *dev)
 		mfc_err("Not enough memory\n");
 		return -ENOMEM;
 	}
+
+	dev_set_name(dev->mem_dev_r, "%s", "s5p-mfc-r");
 	device_initialize(dev->mem_dev_r);
 	of_property_read_u32_array(dev->plat_dev->dev.of_node,
 			"samsung,mfc-r", mem_info, 2);
-- 
2.5.5

