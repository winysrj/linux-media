Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:44115 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753896AbaDJWGu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Apr 2014 18:06:50 -0400
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com
Subject: [PATCH v2 5/9] Allow passing file descriptors to yavta
Date: Fri, 11 Apr 2014 01:06:41 +0300
Message-Id: <1397167605-29956-5-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <1397167605-29956-1-git-send-email-sakari.ailus@iki.fi>
References: <1397167605-29956-1-git-send-email-sakari.ailus@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
---
 yavta.c |   46 +++++++++++++++++++++++++++++++---------------
 1 file changed, 31 insertions(+), 15 deletions(-)

diff --git a/yavta.c b/yavta.c
index 12a6719..6f80311 100644
--- a/yavta.c
+++ b/yavta.c
@@ -63,6 +63,7 @@ struct buffer
 struct device
 {
 	int fd;
+	int opened;
 
 	int type; /* buffer queue type */
 	enum v4l2_memory memtype;
@@ -222,11 +223,6 @@ static const char *v4l2_format_name(unsigned int fourcc)
 
 static int video_open(struct device *dev, const char *devname)
 {
-	dev->fd = -1;
-	dev->memtype = V4L2_MEMORY_MMAP;
-	dev->buffers = NULL;
-	dev->type = (enum v4l2_buf_type)-1;
-
 	dev->fd = open(devname, O_RDWR);
 	if (dev->fd < 0) {
 		printf("Error opening device %s: %s (%d).\n", devname,
@@ -236,6 +232,8 @@ static int video_open(struct device *dev, const char *devname)
 
 	printf("Device %s opened.\n", devname);
 
+	dev->opened = 1;
+
 	return 0;
 }
 
@@ -287,7 +285,8 @@ static void video_close(struct device *dev)
 		free(dev->pattern[i]);
 
 	free(dev->buffers);
-	close(dev->fd);
+	if (dev->opened)
+		close(dev->fd);
 }
 
 static unsigned int get_control_type(struct device *dev, unsigned int id)
@@ -1513,6 +1512,7 @@ static void usage(const char *argv0)
 	printf("-w, --set-control 'ctrl value'	Set control 'ctrl' to 'value'\n");
 	printf("    --enum-formats		Enumerate formats\n");
 	printf("    --enum-inputs		Enumerate inputs\n");
+	printf("    --fd                        Use a numeric file descriptor insted of a device\n");
 	printf("    --no-query			Don't query capabilities on open\n");
 	printf("    --offset			User pointer buffer offset from page start\n");
 	printf("    --requeue-last		Requeue the last buffers before streamoff\n");
@@ -1529,6 +1529,7 @@ static void usage(const char *argv0)
 #define OPT_USERPTR_OFFSET	261
 #define OPT_REQUEUE_LAST	262
 #define OPT_STRIDE		263
+#define OPT_FD			264
 
 static struct option opts[] = {
 	{"capture", 2, 0, 'c'},
@@ -1536,6 +1537,7 @@ static struct option opts[] = {
 	{"delay", 1, 0, 'd'},
 	{"enum-formats", 0, 0, OPT_ENUM_FORMATS},
 	{"enum-inputs", 0, 0, OPT_ENUM_INPUTS},
+	{"fd", 1, 0, OPT_FD},
 	{"file", 2, 0, 'F'},
 	{"fill-frames", 0, 0, 'I'},
 	{"format", 1, 0, 'f'},
@@ -1564,7 +1566,11 @@ static struct option opts[] = {
 int main(int argc, char *argv[])
 {
 	struct sched_param sched;
-	struct device dev = { .type = -1 };
+	struct device dev = {
+		.fd = -1,
+		.memtype = V4L2_MEMORY_MMAP,
+		.type = -1,
+	};
 	int ret;
 
 	/* Options parsings */
@@ -1728,6 +1734,14 @@ int main(int argc, char *argv[])
 		case OPT_ENUM_INPUTS:
 			do_enum_inputs = 1;
 			break;
+		case OPT_FD:
+			dev.fd = atoi(optarg);
+			if (dev.fd < 0) {
+				printf("Bad file descriptor %d\n", dev.fd);
+				return 1;
+			}
+			printf("Using file descriptor %d\n", dev.fd);
+			break;
 		case OPT_NO_QUERY:
 			no_query = 1;
 			break;
@@ -1758,17 +1772,19 @@ int main(int argc, char *argv[])
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
+	if (dev.fd == -1) {
+		if (optind >= argc) {
+			usage(argv[0]);
+			return 1;
+		} else {
+			ret = video_open(&dev, argv[optind]);
+			if (ret < 0)
+				return 1;
+		}
+	}
 
 	if (!no_query) {
 		ret = video_querycap(&dev, &capabilities);
-- 
1.7.10.4

