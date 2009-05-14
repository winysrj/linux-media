Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:42025 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756056AbZENLwg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 14 May 2009 07:52:36 -0400
From: Eduardo Valentin <eduardo.valentin@nokia.com>
To: Hans Verkuil <hverkuil@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: "Nurkkala Eero.An (EXT-Offcode/Oulu)" <ext-Eero.Nurkkala@nokia.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Eduardo Valentin <eduardo.valentin@nokia.com>
Subject: [PATCH v3 3/7] v4l2_subdev i2c: Add i2c board info to v4l2_i2c_new_subdev
Date: Thu, 14 May 2009 14:46:57 +0300
Message-Id: <1242301622-29672-4-git-send-email-eduardo.valentin@nokia.com>
In-Reply-To: <1242301622-29672-3-git-send-email-eduardo.valentin@nokia.com>
References: <1242301622-29672-1-git-send-email-eduardo.valentin@nokia.com>
 <1242301622-29672-2-git-send-email-eduardo.valentin@nokia.com>
 <1242301622-29672-3-git-send-email-eduardo.valentin@nokia.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Device drivers of v4l2_subdev devices may want to have
i2c board info data. This patch adds an helper function
to allow bridge drivers to pass board specific data to
v4l2_subdev drivers.

Signed-off-by: Eduardo Valentin <eduardo.valentin@nokia.com>
---
 drivers/media/video/v4l2-common.c |   33 +++++++++++++++++++++++++++------
 include/media/v4l2-common.h       |    6 ++++++
 2 files changed, 33 insertions(+), 6 deletions(-)

diff --git a/drivers/media/video/v4l2-common.c b/drivers/media/video/v4l2-common.c
index 389f7b2..ac30c46 100644
--- a/drivers/media/video/v4l2-common.c
+++ b/drivers/media/video/v4l2-common.c
@@ -864,9 +864,9 @@ static struct i2c_client *v4l2_i2c_legacy_find_client(struct i2c_adapter *adap,
 
 
 /* Load an i2c sub-device. */
-struct v4l2_subdev *v4l2_i2c_new_subdev(struct v4l2_device *v4l2_dev,
-		struct i2c_adapter *adapter,
-		const char *module_name, const char *client_type, u8 addr)
+static struct v4l2_subdev *__v4l2_i2c_new_subdev(struct v4l2_device *v4l2_dev,
+		struct i2c_adapter *adapter, const char *module_name,
+		const char *client_type, u8 addr, struct i2c_board_info *i)
 {
 	struct v4l2_subdev *sd = NULL;
 	struct i2c_client *client;
@@ -882,9 +882,13 @@ struct v4l2_subdev *v4l2_i2c_new_subdev(struct v4l2_device *v4l2_dev,
 #if LINUX_VERSION_CODE >= KERNEL_VERSION(2, 6, 26)
 	/* Setup the i2c board info with the device type and
 	   the device address. */
-	memset(&info, 0, sizeof(info));
-	strlcpy(info.type, client_type, sizeof(info.type));
-	info.addr = addr;
+	if (!i) {
+		memset(&info, 0, sizeof(info));
+		strlcpy(info.type, client_type, sizeof(info.type));
+		info.addr = addr;
+	} else {
+		memcpy(&info, i, sizeof(info));
+	}
 
 	/* Create the i2c client */
 	client = i2c_new_device(adapter, &info);
@@ -922,8 +926,25 @@ error:
 #endif
 	return sd;
 }
+
+struct v4l2_subdev *v4l2_i2c_new_subdev(struct v4l2_device *v4l2_dev,
+		struct i2c_adapter *adapter,
+		const char *module_name, const char *client_type, u8 addr)
+{
+	return __v4l2_i2c_new_subdev(v4l2_dev, adapter, module_name,
+					client_type, addr, NULL);
+}
 EXPORT_SYMBOL_GPL(v4l2_i2c_new_subdev);
 
+struct v4l2_subdev *v4l2_i2c_new_subdev_board_info(struct v4l2_device *v4l2_dev,
+		struct i2c_adapter *adapter, const char *module_name,
+		struct i2c_board_info *i)
+{
+	return __v4l2_i2c_new_subdev(v4l2_dev, adapter, module_name,
+					NULL, 0, i);
+}
+EXPORT_SYMBOL_GPL(v4l2_i2c_new_subdev_board_info);
+
 /* Probe and load an i2c sub-device. */
 struct v4l2_subdev *v4l2_i2c_new_probed_subdev(struct v4l2_device *v4l2_dev,
 	struct i2c_adapter *adapter,
diff --git a/include/media/v4l2-common.h b/include/media/v4l2-common.h
index 2e1e3a2..da9c95d 100644
--- a/include/media/v4l2-common.h
+++ b/include/media/v4l2-common.h
@@ -130,6 +130,7 @@ int v4l2_chip_match_host(const struct v4l2_dbg_match *match);
 struct i2c_driver;
 struct i2c_adapter;
 struct i2c_client;
+struct i2c_board_info;
 struct i2c_device_id;
 struct v4l2_device;
 struct v4l2_subdev;
@@ -147,6 +148,11 @@ int v4l2_i2c_attach(struct i2c_adapter *adapter, int address, struct i2c_driver
 struct v4l2_subdev *v4l2_i2c_new_subdev(struct v4l2_device *v4l2_dev,
 		struct i2c_adapter *adapter,
 		const char *module_name, const char *client_type, u8 addr);
+/* Same as v4l2_i2c_new_subdev, but with oportunity to pass i2c_board_info
+   to client device */
+struct v4l2_subdev *v4l2_i2c_new_subdev_board_info(struct v4l2_device *v4l2_dev,
+		struct i2c_adapter *adapter, const char *module_name,
+		struct i2c_board_info *i);
 /* Probe and load an i2c module and return an initialized v4l2_subdev struct.
    Only call request_module if module_name != NULL.
    The client_type argument is the name of the chip that's on the adapter. */
-- 
1.6.2.GIT

