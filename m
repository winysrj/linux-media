Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr6.xs4all.nl ([194.109.24.26]:1835 "EHLO
	smtp-vbr6.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755785Ab2FJK0V (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 10 Jun 2012 06:26:21 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans de Goede <hdegoede@redhat.com>,
	Andy Walls <awalls@md.metrocast.net>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Pawel Osciak <pawel@osciak.com>,
	Tomasz Stanislawski <t.stanislaws@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv1 PATCH 19/32] v4l2-dev.c: add debug sysfs entry.
Date: Sun, 10 Jun 2012 12:25:41 +0200
Message-Id: <233efccc7faab9711b8d146fa0f607324add3e22.1339321562.git.hans.verkuil@cisco.com>
In-Reply-To: <1339323954-1404-1-git-send-email-hverkuil@xs4all.nl>
References: <1339323954-1404-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <ef490f7ebca5b6df91db6b1acfb9928ada3bcd70.1339321562.git.hans.verkuil@cisco.com>
References: <ef490f7ebca5b6df91db6b1acfb9928ada3bcd70.1339321562.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/video/v4l2-dev.c |   24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/drivers/media/video/v4l2-dev.c b/drivers/media/video/v4l2-dev.c
index 1500208..5c0bb18 100644
--- a/drivers/media/video/v4l2-dev.c
+++ b/drivers/media/video/v4l2-dev.c
@@ -46,6 +46,29 @@ static ssize_t show_index(struct device *cd,
 	return sprintf(buf, "%i\n", vdev->index);
 }
 
+static ssize_t show_debug(struct device *cd,
+			 struct device_attribute *attr, char *buf)
+{
+	struct video_device *vdev = to_video_device(cd);
+
+	return sprintf(buf, "%i\n", vdev->debug);
+}
+
+static ssize_t set_debug(struct device *cd, struct device_attribute *attr,
+		   const char *buf, size_t len)
+{
+	struct video_device *vdev = to_video_device(cd);
+	int res = 0;
+	u16 value;
+
+	res = kstrtou16(buf, 0, &value);
+	if (res)
+		return res;
+
+	vdev->debug = value;
+	return len;
+}
+
 static ssize_t show_name(struct device *cd,
 			 struct device_attribute *attr, char *buf)
 {
@@ -56,6 +79,7 @@ static ssize_t show_name(struct device *cd,
 
 static struct device_attribute video_device_attrs[] = {
 	__ATTR(name, S_IRUGO, show_name, NULL),
+	__ATTR(debug, 0644, show_debug, set_debug),
 	__ATTR(index, S_IRUGO, show_index, NULL),
 	__ATTR_NULL
 };
-- 
1.7.10

