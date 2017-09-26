Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:56659 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S970460AbdIZUXz (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 26 Sep 2017 16:23:55 -0400
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org
Subject: [PATCH 5/5] keytable: show lirc device and make test show lirc scancodes
Date: Tue, 26 Sep 2017 21:23:52 +0100
Message-Id: <20170926202352.10276-5-sean@mess.org>
In-Reply-To: <20170926202352.10276-1-sean@mess.org>
References: <20170926202352.10276-1-sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Now you can see what protocol any remote is using the following command.

$ ir-keytable -c -p all -t
Old keytable cleared
Protocols changed to lirc rc-5 rc-5-sz jvc sony nec sanyo mce_kbd rc-6 sharp xmp
Testing events. Please, press CTRL-C to abort.
2124.576099: lirc protocol(rc5): scancode = 0x1e11
2124.576143: event type EV_MSC(0x04): scancode = 0x1e11
2124.576143: event type EV_SYN(0x00).
2125.601002: lirc protocol(rc6_mce): scancode = 0x800f0410
2125.601051: event type EV_MSC(0x04): scancode = 0x800f0410
2125.601051: event type EV_SYN(0x00).

Signed-off-by: Sean Young <sean@mess.org>
---
 utils/keytable/keytable.c | 140 ++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 134 insertions(+), 6 deletions(-)

diff --git a/utils/keytable/keytable.c b/utils/keytable/keytable.c
index 5d12ec31..f0744c6a 100644
--- a/utils/keytable/keytable.c
+++ b/utils/keytable/keytable.c
@@ -18,13 +18,16 @@
 #include <fcntl.h>
 #include <stdio.h>
 #include <unistd.h>
+#include <poll.h>
 #include <stdlib.h>
 #include <string.h>
 #include <linux/input.h>
+#include <linux/lirc.h>
 #include <sys/ioctl.h>
 #include <sys/types.h>
 #include <dirent.h>
 #include <argp.h>
+#include <time.h>
 #include <stdbool.h>
 
 #include "parse.h"
@@ -270,6 +273,7 @@ static int sysfs = 0;
 struct rc_device {
 	char *sysfs_name;	/* Device sysfs node name */
 	char *input_name;	/* Input device file name */
+	char *lirc_name;	/* Lirc device file name */
 	char *drv_name;		/* Kernel driver that implements it */
 	char *keytable_name;	/* Keycode table name */
 
@@ -1016,15 +1020,33 @@ static int v2_set_protocols(struct rc_device *rc_dev)
 static int get_attribs(struct rc_device *rc_dev, char *sysfs_name)
 {
 	struct uevents  *uevent;
-	char		*input = "input", *event = "event";
+	char		*input = "input", *event = "event", *lirc = "lirc";
 	char		*DEV = "/dev/";
-	static struct sysfs_names *input_names, *event_names, *attribs, *cur;
+	static struct sysfs_names *input_names, *event_names, *attribs, *cur, *lirc_names;
 
 	/* Clean the attributes */
 	memset(rc_dev, 0, sizeof(*rc_dev));
 
 	rc_dev->sysfs_name = sysfs_name;
 
+	lirc_names = seek_sysfs_dir(rc_dev->sysfs_name, lirc);
+	if (lirc_names) {
+		uevent = read_sysfs_uevents(lirc_names->name);
+		free_names(lirc_names);
+		if (uevent) {
+			while (uevent->next) {
+				if (!strcmp(uevent->key, "DEVNAME")) {
+					rc_dev->lirc_name = malloc(strlen(uevent->value) + strlen(DEV) + 1);
+					strcpy(rc_dev->lirc_name, DEV);
+					strcat(rc_dev->lirc_name, uevent->value);
+					break;
+				}
+				uevent = uevent->next;
+			}
+			free_uevent(uevent);
+		}
+	}
+
 	input_names = seek_sysfs_dir(rc_dev->sysfs_name, input);
 	if (!input_names)
 		return EINVAL;
@@ -1262,16 +1284,119 @@ static char *get_event_name(struct parse_event *event, u_int16_t code)
 	return "";
 }
 
-static void test_event(int fd)
+static void print_scancodes(const struct lirc_scancode *scancodes, unsigned count)
+{
+	unsigned i;
+
+	for (i=0; i< count; i++)  {
+		const char *p;
+		switch (scancodes[i].rc_proto) {
+			case RC_PROTO_UNKNOWN: p = "unknown"; break;
+			case RC_PROTO_OTHER: p = "other"; break;
+			case RC_PROTO_RC5: p = "rc5"; break;
+			case RC_PROTO_RC5X_20: p = "rc5x_20"; break;
+			case RC_PROTO_RC5_SZ: p = "rc5_sz"; break;
+			case RC_PROTO_JVC: p = "jvc"; break;
+			case RC_PROTO_SONY12: p = "sony12"; break;
+			case RC_PROTO_SONY15: p = "sony15"; break;
+			case RC_PROTO_SONY20: p = "sony20"; break;
+			case RC_PROTO_NEC: p = "nec"; break;
+			case RC_PROTO_NECX: p = "necx"; break;
+			case RC_PROTO_NEC32: p = "nec32"; break;
+			case RC_PROTO_SANYO: p = "sanyo"; break;
+			case RC_PROTO_MCIR2_KBD: p = "mcir2_kbd"; break;
+			case RC_PROTO_MCIR2_MSE: p = "mcri2_mse"; break;
+			case RC_PROTO_RC6_0: p = "rc6_0"; break;
+			case RC_PROTO_RC6_6A_20: p = "rc6_6a_20"; break;
+			case RC_PROTO_RC6_6A_24: p = "rc6_6a_24"; break;
+			case RC_PROTO_RC6_6A_32: p = "rc6_6a_32"; break;
+			case RC_PROTO_RC6_MCE: p = "rc6_mce"; break;
+			case RC_PROTO_SHARP: p = "sharp"; break;
+			case RC_PROTO_XMP: p = "xmp"; break;
+			case RC_PROTO_CEC: p = "cec"; break;
+			default: p = NULL; break;
+		}
+		printf(_("%llu.%06llu: "),
+			scancodes[i].timestamp / 1000000000ull,
+			(scancodes[i].timestamp % 1000000000ull) / 1000ull);
+
+		if (p)
+			printf(_("lirc protocol(%s): scancode = 0x%llx"),
+				p, scancodes[i].scancode);
+		else
+			printf(_("lirc protocol(%d): scancode = 0x%llx"),
+				scancodes[i].rc_proto, scancodes[i].scancode);
+
+		if (scancodes[i].flags & LIRC_SCANCODE_FLAG_REPEAT)
+			printf(_(" repeat"));
+		if (scancodes[i].flags & LIRC_SCANCODE_FLAG_TOGGLE)
+			printf(_(" toggle=1"));
+
+		printf("\n");
+	}
+}
+
+static void test_event(struct rc_device *rc_dev, int fd)
 {
 	struct input_event ev[64];
-	int rd, i;
+	struct lirc_scancode sc[64];
+	int rd, i, lircfd = -1;
+
+	if (rc_dev->lirc_name) {
+		lircfd = open(rc_dev->lirc_name, O_RDONLY | O_NONBLOCK);
+		if (lircfd == -1) {
+			perror(_("Can't open lirc device"));
+			return;
+		}
+		unsigned features;
+		if (ioctl(lircfd, LIRC_GET_FEATURES, &features)) {
+			perror(_("Can't get lirc features"));
+			return;
+		}
+
+		if (!(features & LIRC_CAN_REC_SCANCODE)) {
+			close(lircfd);
+			lircfd = -1;
+		}
+		else {
+			unsigned mode = LIRC_MODE_SCANCODE;
+			if (ioctl(lircfd, LIRC_SET_REC_MODE, &mode)) {
+				perror(_("Can't set lirc mode"));
+				return;
+			}
+
+			mode = CLOCK_MONOTONIC;
+			ioctl(fd, EVIOCSCLOCKID, &mode);
+		}
+	}
+
 
 	printf (_("Testing events. Please, press CTRL-C to abort.\n"));
 	while (1) {
+		struct pollfd pollstruct[2] = {
+			{ .fd = fd, .events = POLLIN },
+			{ .fd = lircfd, .events = POLLIN },
+		};
+
+		poll(pollstruct, lircfd != -1 ? 2 : 1, -1);
+
+		if (lircfd != -1) {
+			rd = read(lircfd, sc, sizeof(sc));
+
+			if (rd != -1) {
+				print_scancodes(sc, rd / sizeof(struct lirc_scancode));
+			} else if (errno != EAGAIN) {
+				perror(_("Error reading lirc scancode"));
+				return;
+			}
+		}
+
 		rd = read(fd, ev, sizeof(ev));
 
 		if (rd < (int) sizeof(struct input_event)) {
+			if (errno == EAGAIN)
+				continue;
+
 			perror(_("Error reading event"));
 			return;
 		}
@@ -1455,6 +1580,9 @@ static int show_sysfs_attribs(struct rc_device *rc_dev, char *name)
 			fprintf(stderr, _("\tDriver %s, table %s\n"),
 				rc_dev->drv_name,
 				rc_dev->keytable_name);
+			if (rc_dev->lirc_name)
+				fprintf(stderr, _("\tLirc device: %s\n"),
+					rc_dev->lirc_name);
 			fprintf(stderr, _("\tSupported protocols: "));
 			write_sysfs_protocols(rc_dev->supported, stderr, "%s ");
 			fprintf(stderr, "\n\t");
@@ -1585,7 +1713,7 @@ int main(int argc, char *argv[])
 
 	if (debug)
 		fprintf(stderr, _("Opening %s\n"), devicename);
-	fd = open(devicename, O_RDONLY);
+	fd = open(devicename, O_RDONLY | O_NONBLOCK);
 	if (fd < 0) {
 		perror(devicename);
 		return -1;
@@ -1644,7 +1772,7 @@ int main(int argc, char *argv[])
 	}
 
 	if (test)
-		test_event(fd);
+		test_event(&rc_dev, fd);
 
 	return 0;
 }
-- 
2.13.5
