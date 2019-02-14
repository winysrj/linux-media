Return-Path: <SRS0=jAfH=QV=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6824FC43381
	for <linux-media@archiver.kernel.org>; Thu, 14 Feb 2019 15:43:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 40841218FF
	for <linux-media@archiver.kernel.org>; Thu, 14 Feb 2019 15:43:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407587AbfBNPnY (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 14 Feb 2019 10:43:24 -0500
Received: from lb2-smtp-cloud8.xs4all.net ([194.109.24.25]:59208 "EHLO
        lb2-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2407585AbfBNPnX (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 14 Feb 2019 10:43:23 -0500
Received: from [IPv6:2001:420:44c1:2579:bca2:3803:89c3:7ff1] ([IPv6:2001:420:44c1:2579:bca2:3803:89c3:7ff1])
        by smtp-cloud8.xs4all.net with ESMTPA
        id uJATgDcK34HFnuJAXgqbgp; Thu, 14 Feb 2019 16:43:22 +0100
To:     Linux Media Mailing List <linux-media@vger.kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
From:   Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH] media-ctl: add --bus-info
Message-ID: <cee8c085-785f-f793-715d-c4c4d09a5f36@xs4all.nl>
Date:   Thu, 14 Feb 2019 16:43:17 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfAhGmkidlqKc81FiuSWvYzh3tb7u/5fJ6wa8gpMzqdxlTZR+OFny/uODflUJXxYConjW+hFYc2qTzYhoGkR1LvB57VyY7m42NPExG09lzXo5r0CV6POu
 hHt5ogtsPHKK7pE3iz6KsHtsQouAQblo25dgDpfgEwfSixB6M+FtndqKd3w78W/lnh/RMZf50xa847s8R6FkqOVUnOAAXwSZP8aveiEC1hc5AXaqydCsllaH
 +PYJzFF96lxy+TVIabnV8AxMaTN8hSTPJfyrDAzMJ+26VuS5kSYqPRYQgwuisuFy79iu1S+mA1l9mlG8YtQKqrxNqcJktxMc9w8pdvIuZ0zyQqJ4nfu8Sest
 h+j8OrjHmxJ3eo0EoFPmRvMDqywwHA==
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Add a --bus-info option to media-ctl which opens the media device
that has this bus info string. That makes it possible to open a specific
media device without having to know the name of the media device.

Similar functionality has been implemented for v4l2-ctl and v4l2-compliance,
and for the cec utilities.

This allows scripts that no longer need to care about the name of a device
node, instead they can find it based on a unique string.

Also extend the -d option to support -d0 as a shorthand for /dev/media0 to
make it consistent with the other utils.

Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
---
diff --git a/utils/media-ctl/options.c b/utils/media-ctl/options.c
index 16367857..0430b8bc 100644
--- a/utils/media-ctl/options.c
+++ b/utils/media-ctl/options.c
@@ -19,13 +19,18 @@
  * along with this program. If not, see <http://www.gnu.org/licenses/>.
  */

+#include <ctype.h>
+#include <dirent.h>
+#include <fcntl.h>
 #include <getopt.h>
 #include <stdio.h>
 #include <stdlib.h>
 #include <string.h>
+#include <sys/ioctl.h>
 #include <unistd.h>
 #include <v4l2subdev.h>

+#include <linux/media.h>
 #include <linux/videodev2.h>

 #include "options.h"
@@ -42,7 +47,9 @@ static void usage(const char *argv0)
 	unsigned int i;

 	printf("%s [options]\n", argv0);
+	printf("-b, --bus-info name	Use the media device with bus info equal to name\n");
 	printf("-d, --device dev	Media device name (default: %s)\n", MEDIA_DEVNAME_DEFAULT);
+	printf("			If <dev> starts with a digit, then /dev/media<dev> is used.\n");
 	printf("-e, --entity name	Print the device name associated with the given entity\n");
 	printf("-V, --set-v4l2 v4l2	Comma-separated list of formats to setup\n");
 	printf("    --get-v4l2 pad	Print the active format on a given pad\n");
@@ -121,6 +128,7 @@ static void usage(const char *argv0)
 #define OPT_GET_DV			260

 static struct option opts[] = {
+	{"bus-info", 1, 0, 'b'},
 	{"device", 1, 0, 'd'},
 	{"entity", 1, 0, 'e'},
 	{"set-format", 1, 0, 'f'},
@@ -161,6 +169,51 @@ static void list_known_mbus_formats(void)
 	}
 }

+static const char *find_bus_info(const char *bus_info)
+{
+	static char newdev[300];
+	struct dirent *ep;
+	DIR *dp;
+
+	dp = opendir("/dev");
+	if (dp == NULL)
+		return NULL;
+
+	while ((ep = readdir(dp))) {
+		const char *name = ep->d_name;
+
+		if (!memcmp(name, "media", 5) && isdigit(name[5])) {
+			struct media_device_info mdi;
+			int ret;
+			int fd;
+
+			snprintf(newdev, sizeof(newdev), "/dev/%s", name);
+			fd = open(newdev, O_RDWR);
+			if (fd < 0)
+				continue;
+			ret = ioctl(fd, MEDIA_IOC_DEVICE_INFO, &mdi);
+			close(fd);
+			if (!ret && !strcmp(bus_info, mdi.bus_info)) {
+				closedir(dp);
+				return newdev;
+			}
+		}
+	}
+	closedir(dp);
+	return NULL;
+}
+
+static const char *make_devname(const char *device)
+{
+	static char newdev[300];
+
+	if (device[0] >= '0' && device[0] <= '9' && strlen(device) <= 3) {
+		snprintf(newdev, sizeof(newdev), "/dev/media%s", device);
+		return newdev;
+	}
+	return device;
+}
+
 int parse_cmdline(int argc, char **argv)
 {
 	int opt;
@@ -171,11 +224,20 @@ int parse_cmdline(int argc, char **argv)
 	}

 	/* parse options */
-	while ((opt = getopt_long(argc, argv, "d:e:f:hil:prvV:",
+	while ((opt = getopt_long(argc, argv, "b:d:e:f:hil:prvV:",
 				  opts, NULL)) != -1) {
 		switch (opt) {
+		case 'b':
+			media_opts.devname = find_bus_info(optarg);
+			if (!media_opts.devname) {
+				fprintf(stderr, "Error: no media device with bus info '%s' found\n",
+					optarg);
+				return 1;
+			}
+			break;
+
 		case 'd':
-			media_opts.devname = optarg;
+			media_opts.devname = make_devname(optarg);
 			break;

 		case 'e':
