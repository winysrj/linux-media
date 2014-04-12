Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:50693 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754300AbaDLNYR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 12 Apr 2014 09:24:17 -0400
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com
Subject: [yavta PATCH v3 06/11] Allow passing file descriptors to yavta
Date: Sat, 12 Apr 2014 16:23:58 +0300
Message-Id: <1397309043-8322-7-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <1397309043-8322-1-git-send-email-sakari.ailus@iki.fi>
References: <1397309043-8322-1-git-send-email-sakari.ailus@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
---
 yavta.c |   57 ++++++++++++++++++++++++++++++++++++++++++++++++---------
 1 file changed, 48 insertions(+), 9 deletions(-)

diff --git a/yavta.c b/yavta.c
index 78ebf21..98f5e05 100644
--- a/yavta.c
+++ b/yavta.c
@@ -63,6 +63,7 @@ struct buffer
 struct device
 {
 	int fd;
+	int opened;
 
 	enum v4l2_buf_type type;
 	enum v4l2_memory memtype;
@@ -258,8 +259,30 @@ static void video_init(struct device *dev)
 	dev->type = (enum v4l2_buf_type)-1;
 }
 
+static bool video_has_fd(struct device *dev)
+{
+	return dev->fd != -1;
+}
+
+static int video_set_fd(struct device *dev, int fd)
+{
+	if (video_has_fd(dev)) {
+		printf("Can't set fd (already open).\n");
+		return -1;
+	}
+
+	dev->fd = fd;
+
+	return 0;
+}
+
 static int video_open(struct device *dev, const char *devname)
 {
+	if (video_has_fd(dev)) {
+		printf("Can't open device (already open).\n");
+		return -1;
+	}
+
 	dev->fd = open(devname, O_RDWR);
 	if (dev->fd < 0) {
 		printf("Error opening device %s: %s (%d).\n", devname,
@@ -269,6 +292,8 @@ static int video_open(struct device *dev, const char *devname)
 
 	printf("Device %s opened.\n", devname);
 
+	dev->opened = 1;
+
 	return 0;
 }
 
@@ -318,7 +343,8 @@ static void video_close(struct device *dev)
 		free(dev->pattern[i]);
 
 	free(dev->buffers);
-	close(dev->fd);
+	if (dev->opened)
+		close(dev->fd);
 }
 
 static unsigned int get_control_type(struct device *dev, unsigned int id)
@@ -1544,6 +1570,7 @@ static void usage(const char *argv0)
 	printf("-w, --set-control 'ctrl value'	Set control 'ctrl' to 'value'\n");
 	printf("    --enum-formats		Enumerate formats\n");
 	printf("    --enum-inputs		Enumerate inputs\n");
+	printf("    --fd                        Use a numeric file descriptor insted of a device\n");
 	printf("    --no-query			Don't query capabilities on open\n");
 	printf("    --offset			User pointer buffer offset from page start\n");
 	printf("    --requeue-last		Requeue the last buffers before streamoff\n");
@@ -1560,6 +1587,7 @@ static void usage(const char *argv0)
 #define OPT_USERPTR_OFFSET	261
 #define OPT_REQUEUE_LAST	262
 #define OPT_STRIDE		263
+#define OPT_FD			264
 
 static struct option opts[] = {
 	{"buffer-type", 1, 0, 'B'},
@@ -1568,6 +1596,7 @@ static struct option opts[] = {
 	{"delay", 1, 0, 'd'},
 	{"enum-formats", 0, 0, OPT_ENUM_FORMATS},
 	{"enum-inputs", 0, 0, OPT_ENUM_INPUTS},
+	{"fd", 1, 0, OPT_FD},
 	{"file", 2, 0, 'F'},
 	{"fill-frames", 0, 0, 'I'},
 	{"format", 1, 0, 'f'},
@@ -1761,6 +1790,15 @@ int main(int argc, char *argv[])
 		case OPT_ENUM_INPUTS:
 			do_enum_inputs = 1;
 			break;
+		case OPT_FD:
+			ret = atoi(optarg);
+			if (ret < 0) {
+				printf("Bad file descriptor %d\n", ret);
+				return 1;
+			}
+			printf("Using file descriptor %d\n", ret);
+			video_set_fd(&dev, ret);
+			break;
 		case OPT_NO_QUERY:
 			no_query = 1;
 			break;
@@ -1791,17 +1829,18 @@ int main(int argc, char *argv[])
 		return 1;
 	}
 
-	if (optind >= argc) {
-		usage(argv[0]);
-		return 1;
-	}
-
 	if (!do_file)
 		filename = NULL;
 
-	ret = video_open(&dev, argv[optind]);
-	if (ret < 0)
-		return 1;
+	if (!video_has_fd(&dev)) {
+		if (optind >= argc) {
+			usage(argv[0]);
+			return 1;
+		}
+		ret = video_open(&dev, argv[optind]);
+		if (ret < 0)
+			return 1;
+	}
 
 	if (!no_query) {
 		ret = video_querycap(&dev, &capabilities);
-- 
1.7.10.4

