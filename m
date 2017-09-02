Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:49333 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752329AbdIBLnV (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 2 Sep 2017 07:43:21 -0400
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org
Subject: [PATCH 1/2] keytable: use DEV_NAME if available
Date: Sat,  2 Sep 2017 12:43:18 +0100
Message-Id: <20170902114319.9879-1-sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The result from EVIOCGNAME can be truncated.

Signed-off-by: Sean Young <sean@mess.org>
---
 utils/keytable/keytable.c | 22 +++++++++++++++++++---
 1 file changed, 19 insertions(+), 3 deletions(-)

diff --git a/utils/keytable/keytable.c b/utils/keytable/keytable.c
index 5d12ec31..7b0d1acb 100644
--- a/utils/keytable/keytable.c
+++ b/utils/keytable/keytable.c
@@ -271,6 +271,7 @@ struct rc_device {
 	char *sysfs_name;	/* Device sysfs node name */
 	char *input_name;	/* Input device file name */
 	char *drv_name;		/* Kernel driver that implements it */
+	char *dev_name;		/* Kernel device name */
 	char *keytable_name;	/* Keycode table name */
 
 	enum sysfs_ver version; /* sysfs version */
@@ -1076,6 +1077,10 @@ static int get_attribs(struct rc_device *rc_dev, char *sysfs_name)
 			rc_dev->drv_name = malloc(strlen(uevent->value) + 1);
 			strcpy(rc_dev->drv_name, uevent->value);
 		}
+		if (!strcmp(uevent->key, "DEV_NAME")) {
+			rc_dev->dev_name = malloc(strlen(uevent->value) + 1);
+			strcpy(rc_dev->dev_name, uevent->value);
+		}
 		if (!strcmp(uevent->key, "NAME")) {
 			rc_dev->keytable_name = malloc(strlen(uevent->value) + 1);
 			strcpy(rc_dev->keytable_name, uevent->value);
@@ -1416,9 +1421,8 @@ static void show_evdev_attribs(int fd)
 	get_rate(fd, &delay, &period);
 }
 
-static void device_info(int fd, char *prepend)
+static void device_name(int fd, char *prepend)
 {
-	struct input_id id;
 	char buf[32];
 	int rc;
 
@@ -1427,6 +1431,12 @@ static void device_info(int fd, char *prepend)
 		fprintf(stderr,_("%sName: %.*s\n"),prepend, rc, buf);
 	else
 		perror ("EVIOCGNAME");
+}
+
+static void device_info(int fd, char *prepend)
+{
+	struct input_id id;
+	int rc;
 
 	rc = ioctl(fd, EVIOCGID, &id);
 	if (rc >= 0)
@@ -1452,7 +1462,10 @@ static int show_sysfs_attribs(struct rc_device *rc_dev, char *name)
 			fprintf(stderr, _("Found %s (%s) with:\n"),
 				rc_dev->sysfs_name,
 				rc_dev->input_name);
-			fprintf(stderr, _("\tDriver %s, table %s\n"),
+			if (rc_dev->dev_name)
+				fprintf(stderr, _("\tName: %s\n"),
+					rc_dev->dev_name);
+			fprintf(stderr, _("\tDriver: %s, table: %s\n"),
 				rc_dev->drv_name,
 				rc_dev->keytable_name);
 			fprintf(stderr, _("\tSupported protocols: "));
@@ -1461,6 +1474,8 @@ static int show_sysfs_attribs(struct rc_device *rc_dev, char *name)
 			display_proto(rc_dev);
 			fd = open(rc_dev->input_name, O_RDONLY);
 			if (fd > 0) {
+				if (!rc_dev->dev_name)
+					device_name(fd, "\t");
 				device_info(fd, "\t");
 				show_evdev_attribs(fd);
 				close(fd);
@@ -1495,6 +1510,7 @@ int main(int argc, char *argv[])
 				perror(_("Can't open device"));
 				return -1;
 			}
+			device_name(fd, "");
 			device_info(fd, "");
 			close(fd);
 			return 0;
-- 
2.13.5
