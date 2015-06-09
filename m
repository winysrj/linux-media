Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f174.google.com ([209.85.220.174]:36180 "EHLO
	mail-qk0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932182AbbFIA1L (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 8 Jun 2015 20:27:11 -0400
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: mchehab@osg.samsung.com, bp@suse.de
Cc: tomi.valkeinen@ti.com, bhelgaas@google.com,
	linux-media@vger.kernel.org, linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@suse.com>,
	Toshi Kani <toshi.kani@hp.com>,
	Roland Dreier <roland@kernel.org>,
	Sean Hefty <sean.hefty@intel.com>,
	Hal Rosenstock <hal.rosenstock@gmail.com>,
	Suresh Siddha <sbsiddha@gmail.com>,
	Ingo Molnar <mingo@elte.hu>,
	Thomas Gleixner <tglx@linutronix.de>,
	Juergen Gross <jgross@suse.com>,
	Daniel Vetter <daniel.vetter@ffwll.ch>,
	Andy Lutomirski <luto@amacapital.net>,
	Dave Airlie <airlied@redhat.com>,
	Antonino Daplas <adaplas@gmail.com>,
	Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
	infinipath@intel.com, linux-fbdev@vger.kernel.org
Subject: [PATCH v6 2/3] IB/ipath: add counting for MTRR
Date: Mon,  8 Jun 2015 17:20:21 -0700
Message-Id: <1433809222-28261-3-git-send-email-mcgrof@do-not-panic.com>
In-Reply-To: <1433809222-28261-1-git-send-email-mcgrof@do-not-panic.com>
References: <1433809222-28261-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: "Luis R. Rodriguez" <mcgrof@suse.com>

There is no good reason not to, we eventually delete it as well.

Cc: Toshi Kani <toshi.kani@hp.com>
Cc: Roland Dreier <roland@kernel.org>
Cc: Sean Hefty <sean.hefty@intel.com>
Cc: Hal Rosenstock <hal.rosenstock@gmail.com>
Cc: Suresh Siddha <sbsiddha@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Juergen Gross <jgross@suse.com>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Andy Lutomirski <luto@amacapital.net>
Cc: Dave Airlie <airlied@redhat.com>
Cc: Antonino Daplas <adaplas@gmail.com>
Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>
Cc: Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: infinipath@intel.com
Cc: linux-rdma@vger.kernel.org
Cc: linux-fbdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Luis R. Rodriguez <mcgrof@suse.com>
---
 drivers/infiniband/hw/ipath/ipath_wc_x86_64.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/ipath/ipath_wc_x86_64.c b/drivers/infiniband/hw/ipath/ipath_wc_x86_64.c
index 4ad0b93..70c1f3a 100644
--- a/drivers/infiniband/hw/ipath/ipath_wc_x86_64.c
+++ b/drivers/infiniband/hw/ipath/ipath_wc_x86_64.c
@@ -127,7 +127,7 @@ int ipath_enable_wc(struct ipath_devdata *dd)
 			   "(addr %llx, len=0x%llx)\n",
 			   (unsigned long long) pioaddr,
 			   (unsigned long long) piolen);
-		cookie = mtrr_add(pioaddr, piolen, MTRR_TYPE_WRCOMB, 0);
+		cookie = mtrr_add(pioaddr, piolen, MTRR_TYPE_WRCOMB, 1);
 		if (cookie < 0) {
 			{
 				dev_info(&dd->pcidev->dev,
-- 
2.3.2.209.gd67f9d5.dirty

