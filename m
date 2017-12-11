Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:40937 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751622AbdLKRYE (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 11 Dec 2017 12:24:04 -0500
Date: Mon, 11 Dec 2017 22:53:57 +0530
From: Aishwarya Pant <aishpant@gmail.com>
To: Alan Cox <alan@linux.intel.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Cc: julia.lawall@lip6.fr
Subject: [PATCH] staging: atomisp2: replace DEVICE_ATTR with DEVICE_ATTR_RO
Message-ID: <20171211172357.GA20994@mordor.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a clean-up patch which replaces DEVICE_ATTR() macro with file
permission specific DEVICE_ATTR_RO() macro for compaction and
readability.

Done using coccinelle:

@r@
identifier attr, show_fn;
declarer name DEVICE_ATTR;
@@

DEVICE_ATTR(attr, \(S_IRUGO\|0444\), show_fn, NULL);

@script: python p@
attr_show;
attr << r.attr;
@@

// standardise the show fn name to {attr}_show
coccinelle.attr_show = attr + "_show"

@@
identifier r.attr, r.show_fn;
declarer name DEVICE_ATTR_RO;
@@

// change the attr declaration
- DEVICE_ATTR(attr, \(S_IRUGO\|0444\), show_fn, NULL);
+ DEVICE_ATTR_RO(attr);

@rr@
identifier r.show_fn, p.attr_show;
@@

// rename the show function
- show_fn
+ attr_show
	(...) {
	...
  }

@depends on rr@
identifier r.show_fn, p.attr_show;
@@

// rename fn usages
- show_fun
+ attr_show

Signed-off-by: Aishwarya Pant <aishpant@gmail.com>
---
 drivers/staging/media/atomisp/pci/atomisp2/hmm/hmm.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/media/atomisp/pci/atomisp2/hmm/hmm.c b/drivers/staging/media/atomisp/pci/atomisp2/hmm/hmm.c
index a1c81c12718c..4338b8a1309f 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/hmm/hmm.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/hmm/hmm.c
@@ -158,10 +158,10 @@ static ssize_t dynamic_pool_show(struct device *dev,
 	return ret;
 };
 
-static DEVICE_ATTR(active_bo, 0444, active_bo_show, NULL);
-static DEVICE_ATTR(free_bo, 0444, free_bo_show, NULL);
-static DEVICE_ATTR(reserved_pool, 0444, reserved_pool_show, NULL);
-static DEVICE_ATTR(dynamic_pool, 0444, dynamic_pool_show, NULL);
+static DEVICE_ATTR_RO(active_bo);
+static DEVICE_ATTR_RO(free_bo);
+static DEVICE_ATTR_RO(reserved_pool);
+static DEVICE_ATTR_RO(dynamic_pool);
 
 static struct attribute *sysfs_attrs_ctrl[] = {
 	&dev_attr_active_bo.attr,
-- 
2.15.1
