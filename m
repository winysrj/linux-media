Return-path: <linux-media-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:38950 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753221AbZAMCDe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 12 Jan 2009 21:03:34 -0500
From: "Aguirre Rodriguez, Sergio Alberto" <saaguirre@ti.com>
To: "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"video4linux-list@redhat.com" <video4linux-list@redhat.com>,
	Sakari Ailus <sakari.ailus@nokia.com>,
	"Tuukka.O Toivonen" <tuukka.o.toivonen@nokia.com>,
	"Nagalla, Hari" <hnagalla@ti.com>
Date: Mon, 12 Jan 2009 20:03:08 -0600
Subject: [REVIEW PATCH 01/14] V4L: Int if: Dummy slave
Message-ID: <A24693684029E5489D1D202277BE894416429F97@dlee02.ent.ti.com>
Content-Language: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch implements a dummy slave that has no functionality. Helps
managing slaves in the OMAP 3 camera driver; no need to check for NULL
pointers.

Signed-off-by: Sakari Ailus <sakari.ailus@nokia.com>
Signed-off-by: Sergio Aguirre <saaguirre@ti.com>
---
 drivers/media/video/v4l2-int-device.c |   19 +++++++++++++++++++
 include/media/v4l2-int-device.h       |    2 ++
 2 files changed, 21 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/v4l2-int-device.c b/drivers/media/video/v4l2-int-device.c
index a935bae..cba1c9c 100644
--- a/drivers/media/video/v4l2-int-device.c
+++ b/drivers/media/video/v4l2-int-device.c
@@ -32,6 +32,25 @@
 static DEFINE_MUTEX(mutex);
 static LIST_HEAD(int_list);
 
+static struct v4l2_int_slave dummy_slave = {
+	/* Dummy pointer to avoid underflow in find_ioctl. */
+	.ioctls = (void *)0x80000000,
+	.num_ioctls = 0,
+};
+
+static struct v4l2_int_device dummy = {
+	.type = v4l2_int_type_slave,
+	.u = {
+		.slave = &dummy_slave,
+	},
+};
+
+struct v4l2_int_device *v4l2_int_device_dummy()
+{
+	return &dummy;
+}
+EXPORT_SYMBOL_GPL(v4l2_int_device_dummy);
+
 void v4l2_int_device_try_attach_all(void)
 {
 	struct v4l2_int_device *m, *s;
diff --git a/include/media/v4l2-int-device.h b/include/media/v4l2-int-device.h
index 9c2df41..85a1834 100644
--- a/include/media/v4l2-int-device.h
+++ b/include/media/v4l2-int-device.h
@@ -84,6 +84,8 @@ struct v4l2_int_device {
 	void *priv;
 };
 
+struct v4l2_int_device *v4l2_int_device_dummy(void);
+
 void v4l2_int_device_try_attach_all(void);
 
 int v4l2_int_device_register(struct v4l2_int_device *d);
-- 
1.5.6.5

