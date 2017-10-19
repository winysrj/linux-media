Return-path: <linux-media-owner@vger.kernel.org>
Received: from aer-iport-1.cisco.com ([173.38.203.51]:32095 "EHLO
        aer-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751501AbdJSNTY (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 19 Oct 2017 09:19:24 -0400
From: Harald Dankworth <hardankw@cisco.com>
To: linux-media@vger.kernel.org
Cc: hansverk@cisco.com, tharvey@gateworks.com,
        Harald Dankworth <hardankw@cisco.com>
Subject: [PATCH 1/2] v4l-utils: do not query capabilities of sub-devices.
Date: Thu, 19 Oct 2017 15:09:15 +0200
Message-Id: <1508418555-8870-1-git-send-email-hardankw@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Find the major and minor numbers of the device. Check if the
file /dev/dev/char/major:minor/uevent contains "DEVNAME=v4l-subdev".
If so, the device is a sub-device.

Signed-off-by: Harald Dankworth <hardankw@cisco.com>
Reviewed-by: Hans Verkuil <hansverk@cisco.com>
---
 utils/v4l2-ctl/v4l2-ctl.cpp | 56 ++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 55 insertions(+), 1 deletion(-)

diff --git a/utils/v4l2-ctl/v4l2-ctl.cpp b/utils/v4l2-ctl/v4l2-ctl.cpp
index 5c67bf0..e02dc75 100644
--- a/utils/v4l2-ctl/v4l2-ctl.cpp
+++ b/utils/v4l2-ctl/v4l2-ctl.cpp
@@ -46,6 +46,7 @@
 #include <vector>
 #include <map>
 #include <algorithm>
+#include <fstream>
 
 char options[OptLast];
 
@@ -1142,6 +1143,59 @@ __u32 find_pixel_format(int fd, unsigned index, bool output, bool mplane)
 	return fmt.pixelformat;
 }
 
+static bool is_subdevice(int fd)
+{
+	struct stat sb;
+	if (fstat(fd, &sb) == -1) {
+		fprintf(stderr, "failed to stat file\n");
+		exit(1);
+	}
+
+	char uevent_path[100];
+	if (snprintf(uevent_path, sizeof(uevent_path), "/sys/dev/char/%d:%d/uevent",
+		     major(sb.st_rdev), minor(sb.st_rdev)) == -1) {
+		fprintf(stderr, "failed to create uevent file path\n");
+		exit(1);
+	}
+
+	std::ifstream uevent_file(uevent_path);
+	if (uevent_file.fail()) {
+		fprintf(stderr, "failed to open %s\n", uevent_path);
+		exit(1);
+	}
+
+	std::string line;
+
+	while (std::getline(uevent_file, line)) {
+		if (line.compare(0, 8, "DEVNAME="))
+			continue;
+
+		static const char * devnames[] = {
+			"v4l-subdev",
+			"video",
+			"vbi",
+			"radio",
+			"swradio",
+			"v4l-touch",
+			NULL
+		};
+
+		for (size_t i = 0; devnames[i]; i++) {
+			size_t len = strlen(devnames[i]);
+
+			if (!line.compare(8, len, devnames[i]) && isdigit(line[8+len])) {
+				uevent_file.close();
+				return i == 0;
+			}
+		}
+	}
+
+	uevent_file.close();
+
+	fprintf(stderr, "unknown device name\n");
+	exit(1);
+}
+
 int main(int argc, char **argv)
 {
 	int i;
@@ -1310,7 +1364,7 @@ int main(int argc, char **argv)
 	}
 
 	verbose = options[OptVerbose];
-	if (doioctl(fd, VIDIOC_QUERYCAP, &vcap)) {
+	if (!is_subdevice(fd) && doioctl(fd, VIDIOC_QUERYCAP, &vcap)) {
 		fprintf(stderr, "%s: not a v4l2 node\n", device);
 		exit(1);
 	}
-- 
2.7.4
