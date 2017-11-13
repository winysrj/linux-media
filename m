Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga05.intel.com ([192.55.52.43]:9208 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753801AbdKMRFK (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 13 Nov 2017 12:05:10 -0500
From: Ville Syrjala <ville.syrjala@linux.intel.com>
To: dri-devel@lists.freedesktop.org
Cc: intel-gfx@lists.freedesktop.org,
        Thierry Reding <thierry.reding@gmail.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        linux-media@vger.kernel.org
Subject: [PATCH 09/10] video/hdmi: Constify 'buffer' to the unpack functions
Date: Mon, 13 Nov 2017 19:04:26 +0200
Message-Id: <20171113170427.4150-10-ville.syrjala@linux.intel.com>
In-Reply-To: <20171113170427.4150-1-ville.syrjala@linux.intel.com>
References: <20171113170427.4150-1-ville.syrjala@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Ville Syrjälä <ville.syrjala@linux.intel.com>

The unpack functions just read from the passed in buffer,
so make it const.

Cc: Thierry Reding <thierry.reding@gmail.com>
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Cc: linux-media@vger.kernel.org
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
---
 drivers/video/hdmi.c | 23 ++++++++++++-----------
 include/linux/hdmi.h |  3 ++-
 2 files changed, 14 insertions(+), 12 deletions(-)

diff --git a/drivers/video/hdmi.c b/drivers/video/hdmi.c
index 38716eb50408..65b915ea4936 100644
--- a/drivers/video/hdmi.c
+++ b/drivers/video/hdmi.c
@@ -31,7 +31,7 @@
 
 #define hdmi_log(fmt, ...) dev_printk(level, dev, fmt, ##__VA_ARGS__)
 
-static u8 hdmi_infoframe_checksum(u8 *ptr, size_t size)
+static u8 hdmi_infoframe_checksum(const u8 *ptr, size_t size)
 {
 	u8 csum = 0;
 	size_t i;
@@ -1016,9 +1016,9 @@ EXPORT_SYMBOL(hdmi_infoframe_log);
  * Returns 0 on success or a negative error code on failure.
  */
 static int hdmi_avi_infoframe_unpack(struct hdmi_avi_infoframe *frame,
-				     void *buffer)
+				     const void *buffer)
 {
-	u8 *ptr = buffer;
+	const u8 *ptr = buffer;
 	int ret;
 
 	if (ptr[0] != HDMI_INFOFRAME_TYPE_AVI ||
@@ -1079,9 +1079,9 @@ static int hdmi_avi_infoframe_unpack(struct hdmi_avi_infoframe *frame,
  * Returns 0 on success or a negative error code on failure.
  */
 static int hdmi_spd_infoframe_unpack(struct hdmi_spd_infoframe *frame,
-				     void *buffer)
+				     const void *buffer)
 {
-	u8 *ptr = buffer;
+	const u8 *ptr = buffer;
 	int ret;
 
 	if (ptr[0] != HDMI_INFOFRAME_TYPE_SPD ||
@@ -1117,9 +1117,9 @@ static int hdmi_spd_infoframe_unpack(struct hdmi_spd_infoframe *frame,
  * Returns 0 on success or a negative error code on failure.
  */
 static int hdmi_audio_infoframe_unpack(struct hdmi_audio_infoframe *frame,
-				       void *buffer)
+				       const void *buffer)
 {
-	u8 *ptr = buffer;
+	const u8 *ptr = buffer;
 	int ret;
 
 	if (ptr[0] != HDMI_INFOFRAME_TYPE_AUDIO ||
@@ -1163,9 +1163,9 @@ static int hdmi_audio_infoframe_unpack(struct hdmi_audio_infoframe *frame,
  */
 static int
 hdmi_vendor_any_infoframe_unpack(union hdmi_vendor_any_infoframe *frame,
-				 void *buffer)
+				 const void *buffer)
 {
-	u8 *ptr = buffer;
+	const u8 *ptr = buffer;
 	size_t length;
 	int ret;
 	u8 hdmi_video_format;
@@ -1234,10 +1234,11 @@ hdmi_vendor_any_infoframe_unpack(union hdmi_vendor_any_infoframe *frame,
  *
  * Returns 0 on success or a negative error code on failure.
  */
-int hdmi_infoframe_unpack(union hdmi_infoframe *frame, void *buffer)
+int hdmi_infoframe_unpack(union hdmi_infoframe *frame,
+			  const void *buffer)
 {
 	int ret;
-	u8 *ptr = buffer;
+	const u8 *ptr = buffer;
 
 	switch (ptr[0]) {
 	case HDMI_INFOFRAME_TYPE_AVI:
diff --git a/include/linux/hdmi.h b/include/linux/hdmi.h
index d271ff23984f..d3816170c062 100644
--- a/include/linux/hdmi.h
+++ b/include/linux/hdmi.h
@@ -332,7 +332,8 @@ union hdmi_infoframe {
 
 ssize_t
 hdmi_infoframe_pack(union hdmi_infoframe *frame, void *buffer, size_t size);
-int hdmi_infoframe_unpack(union hdmi_infoframe *frame, void *buffer);
+int hdmi_infoframe_unpack(union hdmi_infoframe *frame,
+			  const void *buffer);
 void hdmi_infoframe_log(const char *level, struct device *dev,
 			union hdmi_infoframe *frame);
 
-- 
2.13.6
