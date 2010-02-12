Return-path: <linux-media-owner@vger.kernel.org>
Received: from acsinet12.oracle.com ([141.146.126.234]:28664 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751382Ab0BLVCv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Feb 2010 16:02:51 -0500
Date: Fri, 12 Feb 2010 13:02:29 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Huang Shijie <shijie8@gmail.com>,
	Kang Yong <kangyong@telegent.com>,
	Zhang Xiaobing <xbzhang@telegent.com>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
	linux-media@vger.kernel.org
Subject: [PATCH -next] media/video/tlg2300: fix build when CONFIG_PM=n
Message-Id: <20100212130229.222d3777.randy.dunlap@oracle.com>
In-Reply-To: <20100212181304.a7bd9a63.sfr@canb.auug.org.au>
References: <20100212181304.a7bd9a63.sfr@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Randy Dunlap <randy.dunlap@oracle.com>

When CONFIG_PM is not enabled, tlg2300 has build errors,
so handle that case, mostly via stubs.

drivers/media/video/tlg2300/pd-alsa.c:237: error: 'struct poseidon' has no member named 'msg'
drivers/media/video/tlg2300/pd-main.c:412: error: implicit declaration of function 'find_old_poseidon'
drivers/media/video/tlg2300/pd-main.c:418: error: implicit declaration of function 'set_map_flags'
drivers/media/video/tlg2300/pd-main.c:462: error: implicit declaration of function 'get_pd'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: 	Huang Shijie <shijie8@gmail.com>
Cc: 	Kang Yong <kangyong@telegent.com>
Cc: 	Zhang Xiaobing <xbzhang@telegent.com>
---
 drivers/media/video/tlg2300/pd-common.h |    4 ++++
 drivers/media/video/tlg2300/pd-main.c   |   19 ++++++++++++++-----
 2 files changed, 18 insertions(+), 5 deletions(-)

--- linux-next-20100212.orig/drivers/media/video/tlg2300/pd-common.h
+++ linux-next-20100212/drivers/media/video/tlg2300/pd-common.h
@@ -254,7 +254,11 @@ void destroy_video_device(struct video_d
 extern int debug_mode;
 void set_debug_mode(struct video_device *vfd, int debug_mode);
 
+#ifdef CONFIG_PM
 #define in_hibernation(pd) (pd->msg.event == PM_EVENT_FREEZE)
+#else
+#define in_hibernation(pd) (0)
+#endif
 #define get_pm_count(p) (atomic_read(&(p)->interface->pm_usage_cnt))
 
 #define log(a, ...) printk(KERN_DEBUG "\t[ %s : %.3d ] "a"\n", \
--- linux-next-20100212.orig/drivers/media/video/tlg2300/pd-main.c
+++ linux-next-20100212/drivers/media/video/tlg2300/pd-main.c
@@ -255,6 +255,11 @@ out:
 	return ret;
 }
 
+static inline struct poseidon *get_pd(struct usb_interface *intf)
+{
+	return usb_get_intfdata(intf);
+}
+
 #ifdef CONFIG_PM
 /* one-to-one map : poseidon{} <----> usb_device{}'s port */
 static inline void set_map_flags(struct poseidon *pd, struct usb_device *udev)
@@ -303,11 +308,6 @@ static inline int is_working(struct pose
 	return get_pm_count(pd) > 0;
 }
 
-static inline struct poseidon *get_pd(struct usb_interface *intf)
-{
-	return usb_get_intfdata(intf);
-}
-
 static int poseidon_suspend(struct usb_interface *intf, pm_message_t msg)
 {
 	struct poseidon *pd = get_pd(intf);
@@ -366,6 +366,15 @@ static void hibernation_resume(struct wo
 	if (pd->pm_resume)
 		pd->pm_resume(pd);
 }
+#else /* CONFIG_PM is not enabled: */
+static inline struct poseidon *find_old_poseidon(struct usb_device *udev)
+{
+	return NULL;
+}
+
+static inline void set_map_flags(struct poseidon *pd, struct usb_device *udev)
+{
+}
 #endif
 
 static bool check_firmware(struct usb_device *udev, int *down_firmware)
