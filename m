Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:39797 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751763Ab3H0MZQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 27 Aug 2013 08:25:16 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: reply+c-3938451-c9f753e3075ab3d507cf32b103da053cfb3af6a8-281889@reply.github.com
Cc: stevellion <notifications@github.com>,
	ljalves/linux_media <linux_media@noreply.github.com>,
	linux-media@vger.kernel.org
Subject: Re: [linux_media] [media] mt9v032: Use the common clock framework (3300a8f)
Date: Tue, 27 Aug 2013 14:26:36 +0200
Message-ID: <2532054.Y0uMuecUVn@avalon>
In-Reply-To: <ljalves/linux_media/commit/3300a8fd48976e7126cf078de95f52d59e413bb0/3938451@github.com>
References: <ljalves/linux_media/commit/3300a8fd48976e7126cf078de95f52d59e413bb0@github.com> <ljalves/linux_media/commit/3300a8fd48976e7126cf078de95f52d59e413bb0/3938451@github.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On Sunday 25 August 2013 04:08:21 stevellion wrote:
> I had trouble compiling V4L with this patch.
> 
> make[2]: Leaving directory `/home/stevemu/media_build/linux'
> make -C /lib/modules/3.2.0-52-generic/build
> SUBDIRS=/home/stevemu/media_build/v4l  modules make[2]: Entering directory
> `/usr/src/linux-headers-3.2.0-52-generic' CC [M] 
> /home/stevemu/media_build/v4l/mt9v032.o
> /home/stevemu/media_build/v4l/mt9v032.c: In function 'mt9v032_power_on':
> /home/stevemu/media_build/v4l/mt9v032.c:226:2: error: implicit declaration
> of function 'clk_prepare_enable' [-Werror=implicit-function-declaration]
> /home/stevemu/media_build/v4l/mt9v032.c: In function 'mt9v032_power_off':
> /home/stevemu/media_build/v4l/mt9v032.c:243:2: error: implicit declaration
> of function 'clk_disable_unprepare' [-Werror=implicit-function-declaration]
> /home/stevemu/media_build/v4l/mt9v032.c: In function 'mt9v032_probe':
> /home/stevemu/media_build/v4l/mt9v032.c:752:2: error: implicit declaration
> of function 'devm_clk_get' [-Werror=implicit-function-declaration]
> /home/stevemu/media_build/v4l/mt9v032.c:752:15: warning: assignment makes
> pointer from integer without a cast [enabled by default] cc1: some warnings
> being treated as errors
> make[3]: *** [/home/stevemu/media_build/v4l/mt9v032.o] Error 1
> make[2]: *** [_module_/home/stevemu/media_build/v4l] Error 2
> make[2]: Leaving directory `/usr/src/linux-headers-3.2.0-52-generic'

Does the following patch to media_build help ?

>From f77f170212cdcabbad96055465d3b2671e386da5 Mon Sep 17 00:00:00 2001
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Date: Tue, 27 Aug 2013 14:24:19 +0200
Subject: [PATCH] Add compat clock helpers

The clk_prepare_enable() and clk_disable_unprepare() clock helpers were
introduced in kernel v3.3. Add them to compat.h for kernels that don't
provide them.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 v4l/compat.h                      | 23 +++++++++++++++++++++++
 v4l/scripts/make_config_compat.pl |  1 +
 2 files changed, 24 insertions(+)

diff --git a/v4l/compat.h b/v4l/compat.h
index a0a6bf4..10ede48 100644
--- a/v4l/compat.h
+++ b/v4l/compat.h
@@ -1241,4 +1241,27 @@ static inline void device_unlock(struct device *dev)
 }
 #endif
 
+#ifdef NEED_CLK_HELPERS
+#include <linux/clk.h>
+static inline int clk_prepare_enable(struct clk *clk)
+{
+	int ret;
+
+	ret = clk_prepare(clk);
+	if (ret)
+		return ret;
+	ret = clk_enable(clk);
+	if (ret)
+		clk_unprepare(clk);
+
+	return ret;
+}
+
+static inline void clk_disable_unprepare(struct clk *clk)
+{
+	clk_disable(clk);
+	clk_unprepare(clk);
+}
+#endif
+
 #endif /*  _COMPAT_H */
diff --git a/v4l/scripts/make_config_compat.pl b/v4l/scripts/make_config_compat.pl
index bdc7e64..7b1f308 100644
--- a/v4l/scripts/make_config_compat.pl
+++ b/v4l/scripts/make_config_compat.pl
@@ -595,6 +595,7 @@ sub check_other_dependencies()
 	check_files_for_func("SIMPLE_DEV_PM_OPS", "NEED_SIMPLE_DEV_PM_OPS", "include/linux/pm.h");
 	check_files_for_func("vm_iomap_memory", "NEED_VM_IOMAP_MEMORY", "include/linux/mm.h");
 	check_files_for_func("device_lock", "NEED_DEVICE_LOCK", "include/linux/device.h");
+	check_files_for_func("clk_prepare_enable", "NEED_CLOCK_HELPERS", "include/linux/clk.h");
 
 	# For tests for uapi-dependent logic
 	check_files_for_func_uapi("usb_endpoint_maxp", "NEED_USB_ENDPOINT_MAXP", "usb/ch9.h");
-- 
Regards,

Laurent Pinchart

