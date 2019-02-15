Return-Path: <SRS0=2oy6=QW=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CBC69C43381
	for <linux-media@archiver.kernel.org>; Fri, 15 Feb 2019 08:10:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9EEF2214DA
	for <linux-media@archiver.kernel.org>; Fri, 15 Feb 2019 08:10:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730378AbfBOIKa (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 15 Feb 2019 03:10:30 -0500
Received: from lb2-smtp-cloud8.xs4all.net ([194.109.24.25]:46726 "EHLO
        lb2-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730345AbfBOIK3 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 15 Feb 2019 03:10:29 -0500
Received: from [192.168.2.10] ([212.251.195.8])
        by smtp-cloud8.xs4all.net with ESMTPA
        id uYZkgHWLt4HFnuYZngs14i; Fri, 15 Feb 2019 09:10:27 +0100
To:     Linux Media Mailing List <linux-media@vger.kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
From:   Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCHv2] media-ctl: support a bus-info string as argument to -d
Message-ID: <454f5a3f-e3a9-51b7-6932-5b2bacfa92ff@xs4all.nl>
Date:   Fri, 15 Feb 2019 09:10:24 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfOz5hf6Is0a7vJCnZo8YHPSYpda3f3bhhQoEKqV1SfQulodYyWgKWNGLDTDmL+iDprSfAcV5IRrAwDAkcdgF2Y1XicvMbDBB7KuPtylj59mbu1/HvplA
 T8cUikf7/x/esNBIr4uMIzzpEJiO+nxxn04Pc3W56EvIdAjs/PSyK8Cnuv0PIHAeAJOPEmuXtwf0Z0KTBn/VFh5V/vVc6FUU1rXt6FtiuFrrddo9cgqEVhVs
 jEENk2sCCa2hB+xesnZRBiGX3SZm0hgt9zcyifpHFIE=
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

If the device passed to the -d option is not found, then interpret it
as a bus-info string and try to open all media devices and see which one
reports a bus-info string equal to the -d argument.

That makes it possible to open a specific media device without having to know
the name of the media device.

Similar functionality has been implemented for v4l2-ctl and v4l2-compliance,
and for the cec utilities.

This allows scripts that no longer need to care about the name of a device
node, instead they can find it based on a unique string.

Also extend the -d option to support -d0 as a shorthand for /dev/media0 to
make it consistent with the other utils.

Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
---
Changes since v1:
- fold into the -d option instead of creating a separate option
---
diff --git a/utils/media-ctl/options.c b/utils/media-ctl/options.c
index 16367857..fb923775 100644
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
@@ -43,6 +48,9 @@ static void usage(const char *argv0)

 	printf("%s [options]\n", argv0);
 	printf("-d, --device dev	Media device name (default: %s)\n", MEDIA_DEVNAME_DEFAULT);
+	printf("			If <dev> starts with a digit, then /dev/media<dev> is used.\n");
+	printf("			If <dev> doesn't exist, then find a media device that\n");
+	printf("			reports a bus info string equal to <dev>.\n");
 	printf("-e, --entity name	Print the device name associated with the given entity\n");
 	printf("-V, --set-v4l2 v4l2	Comma-separated list of formats to setup\n");
 	printf("    --get-v4l2 pad	Print the active format on a given pad\n");
@@ -161,6 +169,48 @@ static void list_known_mbus_formats(void)
 	}
 }

+static const char *make_devname(const char *device)
+{
+	static char newdev[300];
+	struct dirent *ep;
+	DIR *dp;
+
+	if (!access(device, F_OK))
+		return device;
+
+	if (device[0] >= '0' && device[0] <= '9' && strlen(device) <= 3) {
+		snprintf(newdev, sizeof(newdev), "/dev/media%s", device);
+		return newdev;
+	}
+
+	dp = opendir("/dev");
+	if (dp == NULL)
+		return device;
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
+			if (!ret && !strcmp(device, mdi.bus_info)) {
+				closedir(dp);
+				return newdev;
+			}
+		}
+	}
+	closedir(dp);
+	return device;
+}
+
 int parse_cmdline(int argc, char **argv)
 {
 	int opt;
@@ -175,7 +225,7 @@ int parse_cmdline(int argc, char **argv)
 				  opts, NULL)) != -1) {
 		switch (opt) {
 		case 'd':
-			media_opts.devname = optarg;
+			media_opts.devname = make_devname(optarg);
 			break;

 		case 'e':
