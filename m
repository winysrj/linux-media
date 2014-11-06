Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:51220 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751210AbaKFKMG (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 6 Nov 2014 05:12:06 -0500
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Received: from epcpsbgm1.samsung.com (epcpsbgm1 [203.254.230.26])
 by mailout1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0NEM00M8T4C1XM20@mailout1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 06 Nov 2014 19:12:02 +0900 (KST)
Content-transfer-encoding: 8BIT
From: Jacek Anaszewski <j.anaszewski@samsung.com>
To: linux-media@vger.kernel.org
Cc: m.chehab@samsung.com, gjasny@googlemail.com, hdegoede@redhat.com,
	hans.verkuil@cisco.com, b.zolnierkie@samsung.com,
	sakari.ailus@linux.intel.com, kyungmin.park@samsung.com,
	Jacek Anaszewski <j.anaszewski@samsung.com>,
	Teemu Tuominen <teemu.tuominen@intel.com>
Subject: =?UTF-8?q?=5Bv4l-utils=20RFC=20v3=2003/11=5D=20mediatext=3A=20Add=20library?=
Date: Thu, 06 Nov 2014 11:11:34 +0100
Message-id: <1415268702-23685-4-git-send-email-j.anaszewski@samsung.com>
In-reply-to: <1415268702-23685-1-git-send-email-j.anaszewski@samsung.com>
References: <1415268702-23685-1-git-send-email-j.anaszewski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

libmediatext is a helper library for converting configurations (Media
controller links, V4L2 controls and V4L2 sub-device media bus formats and
selections) from text-based form into IOCTLs.

libmediatext depends on libv4l2subdev and libmediactl.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Teemu Tuominen <teemu.tuominen@intel.com>
Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
---
 libmediatext.pc.in                 |   10 ++
 utils/media-ctl/Makefile.am        |   10 +-
 utils/media-ctl/libmediatext.pc.in |   10 ++
 utils/media-ctl/mediatext-test.c   |   66 ++++++++
 utils/media-ctl/mediatext.c        |  303 ++++++++++++++++++++++++++++++++++++
 utils/media-ctl/mediatext.h        |   52 +++++++
 6 files changed, 449 insertions(+), 2 deletions(-)
 create mode 100644 libmediatext.pc.in
 create mode 100644 utils/media-ctl/libmediatext.pc.in
 create mode 100644 utils/media-ctl/mediatext-test.c
 create mode 100644 utils/media-ctl/mediatext.c
 create mode 100644 utils/media-ctl/mediatext.h

diff --git a/libmediatext.pc.in b/libmediatext.pc.in
new file mode 100644
index 0000000..6aa6353
--- /dev/null
+++ b/libmediatext.pc.in
@@ -0,0 +1,10 @@
+prefix=@prefix@
+exec_prefix=@exec_prefix@
+libdir=@libdir@
+includedir=@includedir@
+
+Name: libmediatext
+Description: Media controller and V4L2 text-based configuration library
+Version: @PACKAGE_VERSION@
+Cflags: -I${includedir}
+Libs: -L${libdir} -lmediatext
diff --git a/utils/media-ctl/Makefile.am b/utils/media-ctl/Makefile.am
index a3931fb..3e883e0 100644
--- a/utils/media-ctl/Makefile.am
+++ b/utils/media-ctl/Makefile.am
@@ -1,4 +1,4 @@
-noinst_LTLIBRARIES = libmediactl.la libv4l2subdev.la
+noinst_LTLIBRARIES = libmediactl.la libv4l2subdev.la libmediatext.la
 
 libmediactl_la_SOURCES = libmediactl.c mediactl-priv.h
 libmediactl_la_CFLAGS = -static $(LIBUDEV_CFLAGS)
@@ -9,9 +9,15 @@ libv4l2subdev_la_LIBADD = libmediactl.la
 libv4l2subdev_la_CFLAGS = -static
 libv4l2subdev_la_LDFLAGS = -static
 
+libmediatext_la_SOURCES = mediatext.c
+libmediatext_la_CFLAGS = -static $(LIBUDEV_CFLAGS)
+libmediatext_la_LDFLAGS = -static $(LIBUDEV_LIBS)
+
 mediactl_includedir=$(includedir)/mediactl
 noinst_HEADERS = mediactl.h v4l2subdev.h
 
-bin_PROGRAMS = media-ctl
+bin_PROGRAMS = media-ctl mediatext-test
 media_ctl_SOURCES = media-ctl.c options.c options.h tools.h
 media_ctl_LDADD = libmediactl.la libv4l2subdev.la
+mediatext_test_SOURCES = mediatext-test.c
+mediatext_test_LDADD = libmediatext.la libmediactl.la libv4l2subdev.la
diff --git a/utils/media-ctl/libmediatext.pc.in b/utils/media-ctl/libmediatext.pc.in
new file mode 100644
index 0000000..6aa6353
--- /dev/null
+++ b/utils/media-ctl/libmediatext.pc.in
@@ -0,0 +1,10 @@
+prefix=@prefix@
+exec_prefix=@exec_prefix@
+libdir=@libdir@
+includedir=@includedir@
+
+Name: libmediatext
+Description: Media controller and V4L2 text-based configuration library
+Version: @PACKAGE_VERSION@
+Cflags: -I${includedir}
+Libs: -L${libdir} -lmediatext
diff --git a/utils/media-ctl/mediatext-test.c b/utils/media-ctl/mediatext-test.c
new file mode 100644
index 0000000..29ed38b
--- /dev/null
+++ b/utils/media-ctl/mediatext-test.c
@@ -0,0 +1,66 @@
+/*
+ * libmediatext test program
+ *
+ * Copyright (C) 2013 Intel Corporation
+ *
+ * Contact: Sakari Ailus <sakari.ailus@linux.intel.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU Lesser General Public License as published
+ * by the Free Software Foundation; either version 2.1 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU Lesser General Public License for more details.
+ *
+ * You should have received a copy of the GNU Lesser General Public License
+ * along with this program. If not, see <http://www.gnu.org/licenses/>.
+ */
+
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+
+#include "mediactl.h"
+#include "mediatext.h"
+
+int main(int argc, char *argv[])
+{
+	struct media_device *device;
+	int rval;
+
+	if (argc != 3) {
+		fprintf(stderr, "usage: %s <media device> <string>\n\n", argv[0]);
+		fprintf(stderr, "\tstring := [ v4l2-ctrl | v4l2-mbus | link-reset | link-conf]\n\n");
+		fprintf(stderr, "\tv4l2-ctrl := \"entity\" ctrl_type ctrl_id ctrl_value\n");
+		fprintf(stderr, "\tctrl_type := [ int | int64 | bitmask ]\n");
+		fprintf(stderr, "\tctrl_value := [ %%d | %%PRId64 | bitmask_value ]\n");
+		fprintf(stderr, "\tbitmask_value := b<binary_number>\n\n");
+		fprintf(stderr, "\tv4l2-mbus := \n");
+		fprintf(stderr, "\tlink-conf := \"entity\":pad -> \"entity\":pad[link-flags]\n");
+		fprintf(stderr, "\tctrl-to-subdev-conf := ctrl_id -> \"entity\"\n");
+		return EXIT_FAILURE;
+	}
+
+	device = media_device_new(argv[1]);
+	if (!device)
+		return EXIT_FAILURE;
+
+	media_debug_set_handler(device, (void (*)(void *, ...))fprintf, stdout);
+
+	rval = media_device_enumerate(device);
+	if (rval)
+		return EXIT_FAILURE;
+
+	rval = mediatext_parse(device, argv[2]);
+	if (rval) {
+		fprintf(stderr, "bad string %s (%s)\n", argv[2], strerror(-rval));
+		return EXIT_FAILURE;
+	}
+
+	media_device_unref(device);
+
+	return EXIT_SUCCESS;
+}
diff --git a/utils/media-ctl/mediatext.c b/utils/media-ctl/mediatext.c
new file mode 100644
index 0000000..dc0c80b
--- /dev/null
+++ b/utils/media-ctl/mediatext.c
@@ -0,0 +1,303 @@
+/*
+ * Media controller text-based configuration library
+ *
+ * Copyright (C) 2013 Intel Corporation
+ *
+ * Contact: Sakari Ailus <sakari.ailus@linux.intel.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU Lesser General Public License as published
+ * by the Free Software Foundation; either version 2.1 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU Lesser General Public License for more details.
+ *
+ * You should have received a copy of the GNU Lesser General Public License
+ * along with this program. If not, see <http://www.gnu.org/licenses/>.
+ */
+
+#include <sys/ioctl.h>
+
+#include <ctype.h>
+#include <errno.h>
+#include <fcntl.h>
+#include <inttypes.h>
+#include <stdbool.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <unistd.h>
+#include <sys/stat.h>
+
+#include <linux/types.h>
+
+#include "mediactl.h"
+#include "mediactl-priv.h"
+#include "tools.h"
+#include "v4l2subdev.h"
+
+struct parser {
+	char *prefix;
+	int (*parse)(struct media_device *media, const struct parser *p,
+		     char *string);
+	struct parser *next;
+	bool no_args;
+};
+
+static int parse(struct media_device *media, const struct parser *p, char *string)
+{
+	for (; p->prefix; p++) {
+		size_t len = strlen(p->prefix);
+
+		if (strncmp(p->prefix, string, len))
+			continue;
+
+		string += len;
+
+		for (; isspace(*string); string++);
+
+		if (p->no_args)
+			return p->parse(media, p->next, NULL);
+
+		if (strlen(string) == 0)
+			return -ENOEXEC;
+
+		return p->parse(media, p->next, string);
+	}
+
+	media_dbg(media, "Unknown parser prefix\n");
+
+	return -ENOENT;
+}
+
+struct ctrl_type {
+	uint32_t type;
+	char *str;
+} ctrltypes[] = {
+	{ V4L2_CTRL_TYPE_INTEGER, "int" },
+	{ V4L2_CTRL_TYPE_MENU, "menu" },
+	{ V4L2_CTRL_TYPE_INTEGER_MENU, "intmenu" },
+	{ V4L2_CTRL_TYPE_BITMASK, "bitmask" },
+	{ V4L2_CTRL_TYPE_INTEGER64, "int64" },
+};
+
+static int parse_v4l2_ctrl_id(struct media_device *media, const struct parser *p,
+			      char *string, char **endp, __u32 *ctrl_id)
+{
+	int rval;
+
+	for (; isspace(*string); string++);
+	rval = sscanf(string, "0x%" PRIx32, ctrl_id);
+	if (rval <= 0)
+		return -EINVAL;
+
+	for (; !isspace(*string) && *string; string++);
+	for (; isspace(*string); string++);
+
+	*endp = string;
+
+	return 0;
+}
+
+/* adapted from yavta.c */
+static int parse_v4l2_ctrl(struct media_device *media, const struct parser *p,
+			   char *string)
+{
+	struct v4l2_ext_control ctrl = { 0 };
+	struct v4l2_ext_controls ctrls = { .count = 1,
+					   .controls = &ctrl };
+	int64_t val;
+	int rval;
+	struct media_entity *entity;
+	struct ctrl_type *ctype;
+	unsigned int i;
+
+	entity = media_parse_entity(media, string, &string);
+	if (!entity)
+		return -ENOENT;
+
+	for (i = 0; i < ARRAY_SIZE(ctrltypes); i++)
+		if (!strncmp(string, ctrltypes[i].str,
+			     strlen(ctrltypes[i].str)))
+			break;
+
+	if (i == ARRAY_SIZE(ctrltypes))
+		return -ENOENT;
+
+	ctype = &ctrltypes[i];
+
+	string += strlen(ctrltypes[i].str);
+
+	rval = parse_v4l2_ctrl_id(media, p, string, &string, &ctrl.id);
+	if (rval < 0)
+		return -EINVAL;
+
+	ctrls.ctrl_class = V4L2_CTRL_ID2CLASS(ctrl.id);
+
+	switch (ctype->type) {
+	case V4L2_CTRL_TYPE_BITMASK:
+		if (*string++ != 'b')
+			return -EINVAL;
+		while (*string == '1' || *string == '0') {
+			val <<= 1;
+			if (*string == '1')
+				val++;
+			string++;
+		}
+		break;
+	default:
+		rval = sscanf(string, "%" PRId64, &val);
+		break;
+	}
+	if (rval <= 0)
+		return -EINVAL;
+
+	media_dbg(media, "Setting control 0x%8.8x (type %s), value %" PRId64 "\n",
+		  ctrl.id, ctype->str, val);
+
+	if (ctype->type == V4L2_CTRL_TYPE_INTEGER64)
+		ctrl.value64 = val;
+	else
+		ctrl.value = val;
+
+	rval = v4l2_subdev_open(entity);
+	if (rval < 0)
+		return rval;
+
+	rval = ioctl(entity->fd, VIDIOC_S_EXT_CTRLS, &ctrls);
+	if (ctype->type != V4L2_CTRL_TYPE_INTEGER64) {
+		if (rval != -1) {
+			ctrl.value64 = ctrl.value;
+		} else if (ctype->type != V4L2_CTRL_TYPE_STRING &&
+			   (errno == EINVAL || errno == ENOTTY)) {
+			struct v4l2_control old = { .id = ctrl.id,
+						    .value = val };
+
+			rval = ioctl(entity->fd, VIDIOC_S_CTRL, &old);
+			if (rval != -1) {
+				ctrl.value64 = old.value;
+			}
+		}
+	}
+	if (rval == -1) {
+		media_dbg(media,
+			  "Failed setting control 0x%8.8x: %s (%d) to value %"
+			  PRId64 "\n", ctrl.id, strerror(errno), errno, val);
+		return -errno;
+	}
+
+	if (val != ctrl.value64)
+		media_dbg(media, "Asking for %" PRId64 ", got %" PRId64 "\n",
+			  val, ctrl.value64);
+
+	return 0;
+}
+
+int parse_ctrl_to_subdev_conf(struct media_device *media, const struct parser *p,
+			   char *string)
+{
+	struct media_entity *entity;
+	__u32 ctrl_id;
+	int cts_cnt, rval;
+
+	media_dbg(media, "Configuring v4l2-control target: %s\n", string);
+
+	rval = parse_v4l2_ctrl_id(media, p, string, &string, &ctrl_id);
+	if (rval < 0)
+		return -EINVAL;
+
+	if (string[0] != '-' || string[1] != '>') {
+		media_dbg(media, "Expected '->'\n");
+		return -EINVAL;
+	}
+
+	string += 2;
+
+	entity = media_parse_entity(media, string, &string);
+	if (!entity)
+		return -ENOENT;
+
+	if (!v4l2_subdev_validate_v4l2_ctrl(media, entity, ctrl_id)) {
+		media_dbg(media, "v4l2-control 0x%8.8x not available on entity %s\n",
+			  ctrl_id, entity->info.name);
+		return -EINVAL;
+	}
+
+	cts_cnt = media->ctrl_to_subdev_count;
+	media->ctrl_to_subdev = realloc(media->ctrl_to_subdev,
+					sizeof(*media->ctrl_to_subdev) * (cts_cnt + 1));
+	if (!media->ctrl_to_subdev)
+		return -ENOMEM;
+
+	media->ctrl_to_subdev[cts_cnt].ctrl_id = ctrl_id;
+	media->ctrl_to_subdev[cts_cnt].entity = entity;
+	++media->ctrl_to_subdev_count;
+
+	return 0;
+}
+
+static int parse_v4l2_mbus(struct media_device *media, const struct parser *p,
+			   char *string)
+{
+	media_dbg(media, "Media bus format setup: %s\n", string);
+	return v4l2_subdev_parse_setup_formats(media, string);
+}
+
+static int parse_link_reset(struct media_device *media, const struct parser *p,
+			    char *string)
+{
+	media_dbg(media, "Resetting links\n");
+	return media_reset_links(media);
+}
+
+static int parse_link_conf(struct media_device *media, const struct parser *p,
+			   char *string)
+{
+	media_dbg(media, "Configuring links: %s\n", string);
+	return media_parse_setup_links(media, string);
+}
+
+static const struct parser parsers[] = {
+	{ "v4l2-ctrl", parse_v4l2_ctrl },
+	{ "ctrl-to-subdev-conf", parse_ctrl_to_subdev_conf },
+	{ "v4l2-mbus", parse_v4l2_mbus },
+	{ "link-reset", parse_link_reset, NULL, true },
+	{ "link-conf", parse_link_conf },
+	{ 0 }
+};
+
+int mediatext_parse(struct media_device *media, char *string)
+{
+	return parse(media, parsers, string);
+}
+
+int mediatext_parse_setup_config(struct media_device *device, const char *conf_path)
+{
+	char *line;
+	size_t n = 0;
+	FILE *f;
+	int ret;
+
+	if (conf_path == NULL)
+		return -EINVAL;
+
+	f = fopen(conf_path, "r");
+	if (!f)
+		return -EINVAL;
+
+	while (getline(&line, &n, f) != -1) {
+		ret = mediatext_parse(device, line);
+		if (ret < 0)
+			goto err_parse;
+		free(line);
+		line = NULL;
+		n = 0;
+	}
+
+err_parse:
+	fclose(f);
+	return ret;
+}
diff --git a/utils/media-ctl/mediatext.h b/utils/media-ctl/mediatext.h
new file mode 100644
index 0000000..7dfbaf6
--- /dev/null
+++ b/utils/media-ctl/mediatext.h
@@ -0,0 +1,52 @@
+/*
+ * Media controller text-based configuration library
+ *
+ * Copyright (C) 2013 Intel Corporation
+ *
+ * Contact: Sakari Ailus <sakari.ailus@linux.intel.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU Lesser General Public License as published
+ * by the Free Software Foundation; either version 2.1 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU Lesser General Public License for more details.
+ *
+ * You should have received a copy of the GNU Lesser General Public License
+ * along with this program. If not, see <http://www.gnu.org/licenses/>.
+ */
+
+#ifndef __MEDIATEXT_H__
+#define __MEDIATEXT_H__
+
+struct media_device;
+
+/**
+ * @brief Parse and apply media device command
+ * @param device - media device
+ * @param string - string to parse
+ *
+ * Parse media device command and apply it to the media device
+ * passed in the device argument.
+ *
+ * @return 0 on success, or a negative error code on failure.
+ */
+int mediatext_parse(struct media_device *device, char *string);
+
+/**
+ * @brief Parse and apply media device configuration
+ * @param media - media device
+ * @param conf_path - path to the configuration file
+ *
+ * Parse the media device commands listed in the file under
+ * conf_path and apply them to the media device passed in the
+ * device argument.
+ *
+ * @return 0 on success, or a negative error code on failure.
+ */
+int mediatext_parse_setup_config(struct media_device *device, const char *conf_path);
+
+#endif /* __MEDIATEXT_H__ */
-- 
1.7.9.5

