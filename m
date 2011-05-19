Return-path: <mchehab@pedra>
Received: from ns.mm-sol.com ([213.240.235.226]:32984 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932622Ab1ESMg2 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 19 May 2011 08:36:28 -0400
From: Yordan Kamenov <ykamenov@mm-sol.com>
To: linux-media@vger.kernel.org
Cc: sakari.ailus@maxwell.research.nokia.com,
	Yordan Kamenov <ykamenov@mm-sol.com>
Subject: [libv4l-mcplugin PATCH 1/3] Add files for media controller pipelines
Date: Thu, 19 May 2011 15:36:10 +0300
Message-Id: <a2f6931744d4a75cb7a662fef8f12e53793b84e5.1305804894.git.ykamenov@mm-sol.com>
In-Reply-To: <cover.1305804894.git.ykamenov@mm-sol.com>
References: <cover.1305804894.git.ykamenov@mm-sol.com>
In-Reply-To: <cover.1305804894.git.ykamenov@mm-sol.com>
References: <cover.1305804894.git.ykamenov@mm-sol.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Add Makefile.
Add files for Media Controller pipelines initialization, configuration and
destruction.
Add file for list operations.
Add config file.

Signed-off-by: Yordan Kamenov <ykamenov@mm-sol.com>
---
 Makefile      |   30 ++
 omap3-mc.conf |   82 +++++
 paths.c       |  959 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 paths.h       |   64 ++++
 sl_list.h     |   65 ++++
 5 files changed, 1200 insertions(+), 0 deletions(-)
 create mode 100644 Makefile
 create mode 100644 omap3-mc.conf
 create mode 100644 paths.c
 create mode 100644 paths.h
 create mode 100644 sl_list.h

diff --git a/Makefile b/Makefile
new file mode 100644
index 0000000..2b3b375
--- /dev/null
+++ b/Makefile
@@ -0,0 +1,30 @@
+ARCH ?= arm
+KDIR ?= /usr/src/linux
+LIBV4LINCDIR ?= ../../v4l-utils/lib/include/
+LIBMEDIACTLDIR ?= /usr/local/lib
+CONF_INST_DIR := $(DESTDIR)/etc/libv4l2plugins
+PLUGIN_INST_DIR := $(DESTDIR)/usr/lib/libv4l/plugins
+
+KINC := -I$(KDIR)/include -I$(KDIR)/arch/$(ARCH)/include
+INC := -I$(LIBV4LINCDIR) $(KINC)
+CC   := $(CROSS_COMPILE)gcc
+
+LDFLAGS += -L$(LIBMEDIACTLDIR) -lmediactl
+
+CFLAGS += -O2 -Wall -fpic -I. $(INC)
+OBJS = libv4l2plugin-omap3mc.o paths.o operations.o
+
+all: libv4l2plugin-omap3mc.so
+
+libv4l2plugin-omap3mc.so: $(OBJS)
+	$(CC) $(CFLAGS) -shared $(LDFLAGS) -o libv4l2plugin-omap3mc.so $(OBJS)
+clean:
+	rm -f $(OBJS) libv4l2plugin-omap3mc.so
+
+install: libv4l2plugin-omap3mc.so
+	test -z "$(CONF_INST_DIR)" || mkdir -p "$(CONF_INST_DIR)"
+	install -m 666 omap3-mc.conf "$(CONF_INST_DIR)"
+	test -z "$(PLUGIN_INST_DIR)" || mkdir -p "$(PLUGIN_INST_DIR)"
+	install -m 755 libv4l2plugin-omap3mc.so "$(PLUGIN_INST_DIR)"
+
+.PHONY: clean all
diff --git a/omap3-mc.conf b/omap3-mc.conf
new file mode 100644
index 0000000..3b7947c
--- /dev/null
+++ b/omap3-mc.conf
@@ -0,0 +1,82 @@
+# Configuration file for media controller plugin for libv4l
+#
+#
+# Format:
+#
+# [primary|secondary]_path
+#     list of subdevice names
+# end
+#
+# [primary|secondary]_in_pixfmt
+#     list of formats supported by input device
+# end
+#
+# [primary|secondary]_out_pixfmt
+#     list of formats supported by output device
+# end
+#
+#
+#
+# Sensors:
+#      jt8ev1, smiapp-001, smiapp-002, smiapp-003, smiapp-004, tcm8500md, vw6558
+#
+# Subdevices:
+#      OMAP3 ISP CSI2a
+#      OMAP3 ISP CSI2a output
+#      OMAP3 ISP CCP2
+#      OMAP3 ISP CCP2 input
+#      OMAP3 ISP CCDC
+#      OMAP3 ISP preview
+#      OMAP3 ISP preview output
+#      OMAP3 ISP resizer input
+#      OMAP3 ISP resizer
+#      OMAP3 ISP resizer output
+#
+#
+# Formats:
+#      BAYER8_SBGGR, BAYER8_SGBRG, BAYER8_SGRBG, BAYER10_SGRBG, BAYER10_SRGGB,
+#      BAYER10_SBGGR, BAYER10_SGBRG, BAYER10DPCM8_SGRBG, YUYV, UYVY
+#
+#
+
+
+
+primary_path
+    jt8ev1
+    OMAP3 ISP CSI2a
+    OMAP3 ISP CCDC
+    OMAP3 ISP preview
+    OMAP3 ISP resizer
+    OMAP3 ISP resizer output
+end
+
+primary_in_pixfmt
+    BAYER10DPCM8_SGRBG
+    BAYER10_SGRBG
+end
+
+primary_out_pixfmt
+    UYVY
+end
+
+
+
+secondary_path
+    vw6558
+    OMAP3 ISP CCP2
+    OMAP3 ISP CCDC
+    OMAP3 ISP preview
+    OMAP3 ISP resizer
+    OMAP3 ISP resizer output
+end
+
+secondary_in_pixfmt
+    BAYER10DPCM8_SGRBG
+    BAYER10_SGRBG
+end
+
+secondary_out_pixfmt
+    UYVY
+end
+
+
diff --git a/paths.c b/paths.c
new file mode 100644
index 0000000..bbc6cfd
--- /dev/null
+++ b/paths.c
@@ -0,0 +1,959 @@
+/*
+ * Copyright (C) 2011 Nokia Corporation
+ *
+ * Contact: Yordan Kamenov <ykamenov@mm-sol.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License along
+ * with this program; if not, write to the Free Software Foundation, Inc.,
+ */
+
+#include <unistd.h>
+#include <sys/syscall.h>
+#include <stdlib.h>
+#include <errno.h>
+#include <fcntl.h>
+#include <string.h>
+#include <stddef.h>
+#include <ctype.h>
+#include <string.h>
+
+#include <linux/v4l2-subdev.h>
+
+#include "sl_list.h"
+#include "paths.h"
+
+#define CONFIG_FILE "/etc/libv4l2plugins/omap3-mc.conf"
+
+#define LINESIZE        (256)
+#define CHOMP(x)                        \
+    do {                                \
+        char *p;                        \
+        int  sz;                        \
+        p = (x);                        \
+        sz = strlen(p);            \
+        p += sz - 1;                    \
+        if (sz) \
+            while (isspace(*p)) *p-- = 0;	\
+    } while (0)
+
+/* Sections in configuration file */
+enum mc_plugin_config_sections {
+	CONFIG_SECTION_NONE,
+	CONFIG_SECTION_PRIMARY_PATH,
+	CONFIG_SECTION_PRIMARY_IN_PIXFMT,
+	CONFIG_SECTION_PRIMARY_OUT_PIXFMT,
+	CONFIG_SECTION_SECONDARY_PATH,
+	CONFIG_SECTION_SECONDARY_IN_PIXFMT,
+	CONFIG_SECTION_SECONDARY_OUT_PIXFMT
+};
+
+struct capture_pipeline pipe_sensor_yuv_path;
+
+int pixel_mc_plugin_to_subdev(enum mc_plugin_pixelformat pixfmt)
+{
+	switch (pixfmt) {
+		case MC_PLUGIN_PIX_FMT_BAYER10_SGRBG:
+			return V4L2_MBUS_FMT_SGRBG10_1X10;
+
+		case MC_PLUGIN_PIX_FMT_BAYER10DPCM8_SGRBG:
+			return V4L2_MBUS_FMT_SGRBG10_DPCM8_1X8;
+
+		case MC_PLUGIN_PIX_FMT_YUYV:
+			return V4L2_MBUS_FMT_YUYV8_1X16;
+
+		case MC_PLUGIN_PIX_FMT_UYVY:
+			return V4L2_MBUS_FMT_UYVY8_1X16;
+
+		default:
+			break;
+	}
+
+	return 0;
+}
+
+enum mc_plugin_pixelformat pixel_subdev_to_mc_plugin(int pixfmt)
+{
+	switch (pixfmt) {
+		case V4L2_MBUS_FMT_SGRBG10_1X10:
+			return MC_PLUGIN_PIX_FMT_BAYER10_SGRBG;
+
+		case V4L2_MBUS_FMT_SGRBG10_DPCM8_1X8:
+			return MC_PLUGIN_PIX_FMT_BAYER10DPCM8_SGRBG;
+
+		case V4L2_MBUS_FMT_YUYV8_1X16:
+			return MC_PLUGIN_PIX_FMT_YUYV;
+
+		case V4L2_MBUS_FMT_UYVY8_1X16:
+			return MC_PLUGIN_PIX_FMT_UYVY;
+
+		default:
+			break;
+	}
+
+	return 0;
+}
+
+int pixel_mc_plugin_to_v4l(enum mc_plugin_pixelformat pixfmt)
+{
+	switch (pixfmt) {
+		case MC_PLUGIN_PIX_FMT_BAYER10_SGRBG:
+			return V4L2_PIX_FMT_SGRBG10;
+
+#ifdef V4L2_PIX_FMT_SGRBG10DPCM8
+		case MC_PLUGIN_PIX_FMT_BAYER10DPCM8_SGRBG:
+			return V4L2_PIX_FMT_SGRBG10DPCM8;
+#endif
+
+		case MC_PLUGIN_PIX_FMT_YUYV:
+			return V4L2_PIX_FMT_YUYV;
+
+		case MC_PLUGIN_PIX_FMT_UYVY:
+			return V4L2_PIX_FMT_UYVY;
+
+		default:
+			break;
+	}
+
+	return 0;
+}
+
+enum mc_plugin_pixelformat pixel_v4l_to_mc_plugin(int pixfmt)
+{
+	switch (pixfmt) {
+		case V4L2_PIX_FMT_SGRBG10:
+			return MC_PLUGIN_PIX_FMT_BAYER10_SGRBG;
+
+#ifdef V4L2_PIX_FMT_SGRBG10DPCM8
+		case V4L2_PIX_FMT_SGRBG10DPCM8:
+			return MC_PLUGIN_PIX_FMT_BAYER10DPCM8_SGRBG;
+#endif
+
+		case V4L2_PIX_FMT_YUYV:
+			return MC_PLUGIN_PIX_FMT_YUYV;
+
+		case V4L2_PIX_FMT_UYVY:
+			return MC_PLUGIN_PIX_FMT_UYVY;
+
+		default:
+			break;
+	}
+
+	return 0;
+}
+
+enum mc_plugin_pixelformat pixel_str_to_mc_plugin(char *strpix)
+{
+	if (strcmp(strpix, "BAYER8_SBGGR") == 0)
+		return MC_PLUGIN_PIX_FMT_BAYER8_SBGGR;
+	if (strcmp(strpix, "BAYER8_SGBRG") == 0)
+		return MC_PLUGIN_PIX_FMT_BAYER8_SGBRG;
+	if (strcmp(strpix, "BAYER8_SGRBG") == 0)
+		return MC_PLUGIN_PIX_FMT_BAYER8_SGRBG;
+	if (strcmp(strpix, "BAYER10_SGRBG") == 0)
+		return MC_PLUGIN_PIX_FMT_BAYER10_SGRBG;
+	if (strcmp(strpix, "BAYER10_SRGGB") == 0)
+		return MC_PLUGIN_PIX_FMT_BAYER10_SRGGB;
+	if (strcmp(strpix, "BAYER10_SBGGR") == 0)
+		return MC_PLUGIN_PIX_FMT_BAYER10_SBGGR;
+	if (strcmp(strpix, "BAYER10_SGBRG") == 0)
+		return MC_PLUGIN_PIX_FMT_BAYER10_SGBRG;
+	if (strcmp(strpix, "BAYER10DPCM8_SGRBG") == 0)
+		return MC_PLUGIN_PIX_FMT_BAYER10DPCM8_SGRBG;
+	if (strcmp(strpix, "YUYV") == 0)
+		return MC_PLUGIN_PIX_FMT_YUYV;
+	if (strcmp(strpix, "UYVY") == 0)
+		return MC_PLUGIN_PIX_FMT_UYVY;
+
+	return MC_PLUGIN_PIX_FMT_INVALID;
+}
+
+const struct capture_pipeline *pipe_sensor_yuv(int primary)
+{
+	FILE *fp = NULL;
+	char buffer[LINESIZE], *begin;
+	int i = 0;
+	enum mc_plugin_config_sections conf_section = CONFIG_SECTION_NONE;
+
+	fp = fopen(CONFIG_FILE, "r");
+	if (!fp) {
+		MC_PLUGIN_PRINTF ("Opening file %s failed", CONFIG_FILE);
+		return NULL;
+	}
+
+	while (fgets(buffer, LINESIZE, fp)) {
+		/* skip initial whitespace */
+		begin = buffer + strspn(buffer, "\r\t ");
+
+		/* skip comments and empty lines */
+		if (*begin == '#')
+			continue;
+		if (*begin == '\n')
+			continue;
+
+		/* Remove LF */
+		CHOMP(begin);
+
+		/* Check if we enter a config section */
+		if (conf_section == CONFIG_SECTION_NONE) {
+			if (strcmp(begin, "primary_path") == 0)
+				conf_section = CONFIG_SECTION_PRIMARY_PATH;
+			else if (strcmp(begin, "primary_in_pixfmt") == 0)
+				conf_section = CONFIG_SECTION_PRIMARY_IN_PIXFMT;
+			else if (strcmp(begin, "primary_out_pixfmt") == 0)
+				conf_section = CONFIG_SECTION_PRIMARY_OUT_PIXFMT;
+			else if (strcmp(begin, "secondary_path") == 0)
+				conf_section = CONFIG_SECTION_SECONDARY_PATH;
+			else if (strcmp(begin, "secondary_in_pixfmt") == 0)
+				conf_section = CONFIG_SECTION_SECONDARY_IN_PIXFMT;
+			else if (strcmp(begin, "secondary_out_pixfmt") == 0)
+				conf_section = CONFIG_SECTION_SECONDARY_OUT_PIXFMT;
+
+			i = 0;
+			continue;
+		}
+
+		/* Check if we exit a config section */
+		if (strcmp(begin, "end") == 0) {
+			conf_section = CONFIG_SECTION_NONE;
+			continue;
+		}
+
+		if ((i + 1) > PIPELINE_MAX_ELEMENTS ||
+			strlen(begin) >= SUBDEVICE_MAX_NAME_LEN) {
+
+			fclose(fp);
+			return NULL;
+		}
+
+		switch (conf_section) {
+		case CONFIG_SECTION_PRIMARY_PATH:
+			if (!primary)
+				break;
+			strcpy(pipe_sensor_yuv_path.path[i], begin);
+			strcpy(pipe_sensor_yuv_path.path[i+1], "");
+			i++;
+			break;
+		case CONFIG_SECTION_PRIMARY_IN_PIXFMT:
+			if (!primary)
+				break;
+			pipe_sensor_yuv_path.in_pixfmt[i] = pixel_str_to_mc_plugin(begin);
+			pipe_sensor_yuv_path.in_pixfmt[i+1] = MC_PLUGIN_PIX_FMT_INVALID;
+			i++;
+			break;
+		case CONFIG_SECTION_PRIMARY_OUT_PIXFMT:
+			if (!primary)
+				break;
+			pipe_sensor_yuv_path.out_pixfmt[i] = pixel_str_to_mc_plugin(begin);
+			pipe_sensor_yuv_path.out_pixfmt[i+1] = MC_PLUGIN_PIX_FMT_INVALID;
+			i++;
+			break;
+		case CONFIG_SECTION_SECONDARY_PATH:
+			if (primary)
+				break;
+			strcpy(pipe_sensor_yuv_path.path[i], begin);
+			strcpy(pipe_sensor_yuv_path.path[i+1], "");
+			i++;
+			break;
+		case CONFIG_SECTION_SECONDARY_IN_PIXFMT:
+			if (primary)
+				break;
+			pipe_sensor_yuv_path.in_pixfmt[i] = pixel_str_to_mc_plugin(begin);
+			pipe_sensor_yuv_path.in_pixfmt[i+1] = MC_PLUGIN_PIX_FMT_INVALID;
+			i++;
+			break;
+		case CONFIG_SECTION_SECONDARY_OUT_PIXFMT:
+			if (primary)
+				break;
+			pipe_sensor_yuv_path.out_pixfmt[i] = pixel_str_to_mc_plugin(begin);
+			pipe_sensor_yuv_path.out_pixfmt[i+1] = MC_PLUGIN_PIX_FMT_INVALID;
+			i++;
+			break;
+		case CONFIG_SECTION_NONE:
+			break;
+		}
+
+	}
+
+	fclose(fp);
+
+	return &pipe_sensor_yuv_path;
+}
+
+struct media_link *media_find_link(struct media_device *media,
+                                         struct media_entity *source,
+                                         struct media_entity *sink)
+{
+	unsigned int l;
+
+	for (l = 0; l < source->num_links; l++) {
+		struct media_link *link = &source->links[l];
+
+		if (link->source->entity == source &&
+			link->sink->entity == sink)
+				return link;
+	}
+
+	return NULL;
+}
+
+struct ipipe_descriptor *path_allocate(struct media_device *media,
+										const struct capture_pipeline *pipe)
+{
+	struct ipipe_descriptor *image_path;
+	struct sub_module *sub;
+	struct media_entity *entity;
+	const char *entity_name;
+	int i;
+
+	if (!media || !pipe) {
+		MC_PLUGIN_PRINTF("NULL pointer\n");
+		return NULL;
+	}
+
+	image_path = malloc(sizeof(*image_path));
+	if (!image_path) {
+		perror("image path");
+		return NULL;
+	}
+
+	image_path->pipe = pipe;
+	INIT_LIST_HEAD(&image_path->container);
+
+	for (i = 0; ; i++) {
+		entity_name = (char *)pipe->path[i];
+		if (strlen(entity_name) == 0)
+			break;
+
+		entity = media_get_entity_by_name(media, entity_name, strlen(entity_name));
+		if (!entity) {
+			MC_PLUGIN_PRINTF("Can't find entity [%s]\n", entity_name);
+			continue;
+		}
+
+		sub = submodule_alloc();
+		if (sub) {
+			sub->entity = entity;
+			list_add_tail(&sub->list, &image_path->container);
+		}
+	}
+
+	return image_path;
+}
+
+struct sub_module *submodule_alloc()
+{
+	struct sub_module *sb = NULL;
+
+	sb = malloc(sizeof (*sb));
+	if (!sb) {
+		MC_PLUGIN_PRINTF("Can not allocate module\n");
+		return sb;
+	}
+
+	sb->entity = NULL;
+	INIT_LIST_HEAD(&sb->list);
+
+	return sb;
+}
+
+void submodule_free(struct sub_module *sb)
+{
+	free(sb);
+	sb = NULL;
+}
+
+struct sub_module *path_destination_submodule(struct ipipe_descriptor *path)
+{
+	struct sub_module *next, *last;
+
+	if (NULL == path) {
+		MC_PLUGIN_PRINTF("Wrong argument: NULL pointer\n");
+		return NULL;
+	}
+
+	last = NULL;
+	list_for_each_entry(next, &path->container, list)
+		last = next;
+
+	return last;
+}
+
+int path_power_on(struct ipipe_descriptor *path, int fd)
+{
+	struct sub_module *sub_mod, *next_sub_mod;
+	int last_sm, err = 0;
+
+	if (NULL == path) {
+		MC_PLUGIN_PRINTF("Wrong argument: NULL pointer\n");
+		return -1;
+	}
+
+	list_for_each_entry(sub_mod, &path->container, list) {
+		next_sub_mod = list_entry(sub_mod->list.next, typeof(*sub_mod), list);
+		last_sm = &next_sub_mod->list == &path->container;
+		err += submodule_open(sub_mod, fd, last_sm);
+	}
+
+	return err;
+}
+
+int submodule_open(struct sub_module *sb, int fd, int last_sm)
+{
+	int err = 0;
+
+	if (!sb) {
+		MC_PLUGIN_PRINTF("Wrong argument: NULL pointer\n");
+		return -1;
+	}
+
+	if (sb->entity->fd < 0)
+		sb->entity->fd = SYS_OPEN(sb->entity->devname, O_RDWR, 0);
+
+	if (sb->entity->fd < 0)
+		err = -1;
+
+	if (last_sm && err != -1) {
+		int dr;
+		dr = dup2(sb->entity->fd, fd);
+		close(sb->entity->fd);
+		sb->entity->fd = fd;
+	}
+
+	return err;
+}
+
+int path_connect_entities(struct media_device *media,
+							struct ipipe_descriptor *path)
+{
+	struct media_entity *source, *sink;
+	struct media_link *link;
+	const char *sink_name, *source_name;
+	int i, err = 0;
+
+	if (!media || !path) {
+		MC_PLUGIN_PRINTF("Wrong argument: NULL pointer\n");
+		return -1;
+	}
+
+	source_name = (char *)path->pipe->path[0];
+	sink_name = (char *)path->pipe->path[1];
+	i = 1;
+
+	while (strlen(source_name) != 0) {
+
+		sink_name = (char *)path->pipe->path[i];
+		if (strlen(sink_name) == 0)
+			break;
+
+		source = media_get_entity_by_name(media, source_name, strlen(source_name));
+		sink = media_get_entity_by_name(media, sink_name, strlen(sink_name));
+
+		if ((NULL == sink) || (NULL == source)) {
+			MC_PLUGIN_PRINTF("Error finding entities\n");
+			err = -1;
+			break;
+		}
+
+		link = media_find_link(media, source, sink);
+
+		/* Do not explicitly setup immutable links */
+		if (!(link->flags & MEDIA_LINK_FLAG_IMMUTABLE)) {
+			err = media_setup_link(media, link->source, link->sink,
+								MEDIA_LINK_FLAG_ACTIVE);
+		} else {
+			if (!(link->flags & MEDIA_LINK_FLAG_ACTIVE)) {
+				MC_PLUGIN_PRINTF("Immutable link is not activated\n");
+				err = -1;
+			}
+		}
+
+		if (err < 0) {
+			MC_PLUGIN_PRINTF("Fail to connect %s->%s\n", source_name, sink_name);
+			break;
+		}
+
+		source_name = sink_name;
+		i++;
+	}
+
+	return err;
+}
+
+void path_power_off(struct ipipe_descriptor *path)
+{
+	struct sub_module *sub_mod, *next_sub_mod;
+	int last_sm;
+
+	if (NULL == path) {
+		MC_PLUGIN_PRINTF("Wrong argument: NULL pointer\n");
+		return;
+	}
+
+	list_for_each_entry(sub_mod, &path->container, list) {
+		next_sub_mod = list_entry(sub_mod->list.next, typeof(*sub_mod), list);
+		last_sm = &next_sub_mod->list == &path->container;
+		submodule_power_off(sub_mod, last_sm);
+	}
+
+}
+
+int submodule_power_off(struct sub_module *sb, int last_sm)
+{
+	if (!sb) {
+		MC_PLUGIN_PRINTF("Wrong argument: NULL pointer\n");
+		return -1;
+	}
+
+	if (sb->entity->fd > 0 && !last_sm)
+		SYS_CLOSE(sb->entity->fd);
+
+	sb->entity->fd = -1;
+
+	return 0;
+}
+
+int path_disconnect_entities(struct media_device *media,
+								struct ipipe_descriptor *path)
+{
+	struct media_entity *source, *sink;
+	struct media_link *link;
+	const char *sink_name, *source_name;
+	int i, err = 0;
+
+	if (!media || !path) {
+		MC_PLUGIN_PRINTF("Wrong argument: NULL pointer\n");
+		return -1;
+	}
+
+	source_name = (char *)path->pipe->path[0];
+	sink_name = (char *)path->pipe->path[1];
+	i = 1;
+
+	while (strlen(source_name) != 0) {
+
+		sink_name = (char *)path->pipe->path[i];
+		if (strlen(sink_name) == 0)
+			break;
+
+		source = media_get_entity_by_name(media, source_name, strlen(source_name));
+		sink = media_get_entity_by_name(media, sink_name, strlen(sink_name));
+
+		if ((NULL == sink) || (NULL == source)) {
+			MC_PLUGIN_PRINTF("Error finding entities\n");
+			err = -1;
+			break;
+		}
+
+		link = media_find_link(media, source, sink);
+
+		/* Do not explicitly setup immutable links */
+		if (!(link->flags & MEDIA_LINK_FLAG_IMMUTABLE))
+			err = media_setup_link(media, link->source, link->sink,
+									(link->flags & ~MEDIA_LINK_FLAG_ACTIVE));
+
+		source_name = sink_name;
+		i++;
+	}
+
+	return err;
+}
+
+int path_enum_src_framesizes(struct omap3mcplugin *plugin,
+								enum mc_plugin_pixelformat *pixfmt,
+								struct v4l2_rect *res, int max_rect)
+{
+	struct media_entity *source, *sink;
+	const char *sink_name, *source_name;
+	struct media_link *link;
+	int ret = -1;
+	struct v4l2_subdev_frame_size_enum size;
+
+	if (!plugin || !pixfmt || !res) {
+		MC_PLUGIN_PRINTF("NULL pointer");
+		return -1;
+	}
+
+	source_name = (char *)plugin->path->pipe->path[0];
+	sink_name = (char *)plugin->path->pipe->path[1];
+
+	source = media_get_entity_by_name(plugin->media, source_name, strlen(source_name));
+	sink = media_get_entity_by_name(plugin->media, sink_name, strlen(sink_name));
+
+	if ((NULL == sink) || (NULL == source)) {
+		MC_PLUGIN_PRINTF("Error finding entities\n");
+		errno = EBADF;
+		return -1;
+	}
+
+	link = media_find_link(plugin->media, source, sink);
+
+	if (NULL == link) {
+		MC_PLUGIN_PRINTF("No link present between source and sink\n");
+		errno = EBADF;
+		return -1;
+	}
+
+	memset(&size, 0, sizeof(size));
+
+	size.index = 0;
+	size.code = pixel_mc_plugin_to_subdev(*pixfmt);
+	size.pad = link->source->index;
+
+	while (0 == SYS_IOCTL(source->fd, VIDIOC_SUBDEV_ENUM_FRAME_SIZE, &size)) {
+		/* NOTE : min_width min_height and max_width max_height */
+		/* are equal for now so take just one of them */
+		ret = 0;
+		res[size.index].width = size.max_width;
+		res[size.index].height = size.max_height;
+
+		++size.index;
+		if (size.index >= max_rect)
+			break;
+
+	}
+
+	return ret;
+}
+
+int path_set_resolution(struct omap3mcplugin *plugin,
+							struct v4l2_rect *src_res,
+							enum mc_plugin_pixelformat *src_pix,
+							struct v4l2_rect *dst_res,
+							enum mc_plugin_pixelformat *dst_pix)
+{
+	struct media_link *link = NULL;
+	struct sub_module *pos, *source = NULL, *sink = NULL;
+	struct v4l2_rect res;
+	struct v4l2_format format;
+	struct v4l2_subdev_format subdev_fmt;
+	enum mc_plugin_pixelformat source_pix, sink_pix;
+	int first_submodule, err = -1;
+
+	if (!plugin || !src_res || !src_pix ||
+		!dst_res || !dst_pix) {
+
+		MC_PLUGIN_PRINTF("NULL pointer\n");
+		return -1;
+	}
+
+	if (!src_res->width || !src_res->height || MC_PLUGIN_PIX_FMT_INVALID == *src_pix ||
+		!dst_res->width || !dst_res->height || MC_PLUGIN_PIX_FMT_INVALID == *dst_pix) {
+
+		MC_PLUGIN_PRINTF("Wrong input argumets\n");
+		return -1;
+	}
+
+	source_pix = *src_pix;
+	sink_pix = *src_pix;
+	res = *src_res;
+
+	first_submodule = 1;
+	list_for_each_entry(pos, &plugin->path->container, list) {
+
+		/* If first submodule just set source pixel format and resolution */
+		if (NULL == source) {
+			source = pos;
+			continue;
+		}
+
+		/* If we reach last submodule apply destination resolution */
+		if (media_entity_type(pos->entity) == MEDIA_ENTITY_TYPE_NODE && sink) {
+			res = *dst_res;
+
+			memset (&format, 0x0, sizeof (struct v4l2_format));
+			format.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
+			err = SYS_IOCTL(pos->entity->fd, VIDIOC_G_FMT, &format);
+			if (err < 0) {
+				perror("VIDIOC_G_FMT:");
+				break;
+			}
+
+			format.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
+			format.fmt.pix.width = dst_res->width;
+			format.fmt.pix.height = dst_res->height;
+			format.fmt.pix.pixelformat = pixel_mc_plugin_to_v4l(*dst_pix);
+			format.fmt.pix.field = V4L2_FIELD_ANY;
+
+			err = SYS_IOCTL(pos->entity->fd, VIDIOC_S_FMT, &format);
+			if (err < 0) {
+				perror("VIDIOC_S_FMT:");
+				break;
+			}
+		}
+
+		sink = pos;
+
+		link = media_find_link(plugin->media, source->entity, sink->entity);
+
+		if (link == NULL) {
+			MC_PLUGIN_PRINTF("No link present between source and sink\n");
+			err = -1;
+			break;
+		}
+
+		if (!(link->flags & MEDIA_LINK_FLAG_ACTIVE)) {
+			MC_PLUGIN_PRINTF("This link is not active\n");
+			err = -1;
+			break;
+		}
+
+		/* Set source format */
+		memset(&subdev_fmt, 0, sizeof(subdev_fmt));
+		subdev_fmt.format.code = pixel_mc_plugin_to_subdev(source_pix);
+		subdev_fmt.which = V4L2_SUBDEV_FORMAT_ACTIVE;
+		subdev_fmt.format.width = res.width;
+		subdev_fmt.format.height = res.height;
+		subdev_fmt.pad = link->source->index;
+
+		err = SYS_IOCTL(source->entity->fd, VIDIOC_SUBDEV_S_FMT, &subdev_fmt);
+		if (err < 0) {
+			perror("Error set source format:");
+			break;
+		} else {
+			res.width = subdev_fmt.format.width;
+			res.height = subdev_fmt.format.height;
+			source_pix = pixel_subdev_to_mc_plugin(subdev_fmt.format.code);
+		}
+
+		if (media_entity_type(pos->entity) == MEDIA_ENTITY_TYPE_NODE && sink)
+			break;
+
+		/* Set sink format */
+		memset(&subdev_fmt, 0, sizeof(subdev_fmt));
+		subdev_fmt.format.code = pixel_mc_plugin_to_subdev(sink_pix);
+		subdev_fmt.which = V4L2_SUBDEV_FORMAT_ACTIVE;
+		subdev_fmt.format.width = res.width;
+		subdev_fmt.format.height = res.height;
+		subdev_fmt.pad = link->sink->index;
+
+		err = SYS_IOCTL(sink->entity->fd, VIDIOC_SUBDEV_S_FMT, &subdev_fmt);
+		if (err < 0) {
+			perror("Error set sink format:");
+			break;
+		} else {
+			res.width = subdev_fmt.format.width;
+			res.height = subdev_fmt.format.height;
+			sink_pix = pixel_subdev_to_mc_plugin(subdev_fmt.format.code);
+		}
+
+		/* Sink pix is not supported modify source pixelformat also */
+		if (source_pix != sink_pix) {
+			source_pix = sink_pix;
+
+			memset(&subdev_fmt, 0, sizeof(subdev_fmt));
+			subdev_fmt.format.code = pixel_mc_plugin_to_subdev(source_pix);
+			subdev_fmt.which = V4L2_SUBDEV_FORMAT_ACTIVE;
+			subdev_fmt.format.width = res.width;
+			subdev_fmt.format.height = res.height;
+			subdev_fmt.pad = link->source->index;
+
+			err = SYS_IOCTL(source->entity->fd, VIDIOC_SUBDEV_S_FMT, &subdev_fmt);
+			if (err < 0) {
+				perror("Error set source format:");
+				break;
+			} else {
+				res.width = subdev_fmt.format.width;
+				res.height = subdev_fmt.format.height;
+				source_pix = pixel_subdev_to_mc_plugin(subdev_fmt.format.code);
+			}
+
+			err += (source_pix == sink_pix) ? 0 : -1;
+		}
+
+		if (err < 0) {
+			fprintf(stderr, "Error set source format for second time %s\n", source->entity->info.name);
+			break;
+		}
+
+		/* Store correct source pixel format and resolution */
+		if (first_submodule) {
+			*src_pix = source_pix;
+			*src_res = res;
+			first_submodule = 0;
+		}
+
+		/* Try to set destination pixel fmt */
+		source_pix = sink_pix = *dst_pix;
+		/* Continue with next element */
+		source = sink;
+	}
+
+	/* Set Destination resolution and pixel format */
+	if (0 == err) {
+		*dst_pix = sink_pix;
+		*dst_res = res;
+	}
+
+	return err;
+}
+
+int path_try_resolution(struct omap3mcplugin *plugin,
+							struct v4l2_rect *src_res,
+							enum mc_plugin_pixelformat *src_pix,
+							struct v4l2_rect *dst_res,
+							enum mc_plugin_pixelformat *dst_pix)
+{
+	struct media_link *link = NULL;
+	struct sub_module *pos, *source = NULL, *sink = NULL;
+	struct v4l2_rect res;
+	struct v4l2_subdev_format subdev_fmt;
+	enum mc_plugin_pixelformat source_pix, sink_pix;
+	int first_submodule, err = -1;
+
+	if (!plugin || !src_res || !src_pix ||
+		!dst_res || !dst_pix) {
+
+		MC_PLUGIN_PRINTF("NULL pointer\n"
+						"  plugin=%p\n"
+						"  src_res=%p, src_pix=%p\n"
+						"  dst_res=%p, dst_pix=%p\n",
+						plugin,
+						src_res, src_pix,
+						dst_res, dst_pix);
+
+		return -1;
+	}
+
+	if (!src_res->width || !src_res->height || MC_PLUGIN_PIX_FMT_INVALID == *src_pix ||
+		!dst_res->width || !dst_res->height || MC_PLUGIN_PIX_FMT_INVALID == *dst_pix) {
+
+		MC_PLUGIN_PRINTF("Wrong input argumets\n"
+						"  Source format: Width = %d, Height = %d, Format = %d\n"
+						"  Destination format: Width = %d, Height = %d, Format = %d\n",
+						src_res->width, src_res->height, *src_pix,
+						dst_res->width, dst_res->height, *dst_pix);
+		return -1;
+	}
+
+	source_pix = *src_pix;
+	sink_pix = *src_pix;
+	res = *src_res;
+
+	first_submodule = 1;
+	list_for_each_entry(pos, &plugin->path->container, list) {
+
+		/* If first submodule just set source pixel format and resolution */
+		if (NULL == source) {
+			source = pos;
+			continue;
+		}
+
+		/* If we reach last submodule apply destination resolution */
+		if (media_entity_type(pos->entity) == MEDIA_ENTITY_TYPE_NODE && sink)
+			res = *dst_res;
+
+		sink = pos;
+
+		link = media_find_link(plugin->media, source->entity, sink->entity);
+
+		if (NULL == link) {
+			MC_PLUGIN_PRINTF("No link present between source and sink\n");
+			err = -1;
+			break;
+		}
+
+		if (!(link->flags & MEDIA_LINK_FLAG_ACTIVE)) {
+			MC_PLUGIN_PRINTF("This link is not active\n");
+			err = -1;
+			break;
+		}
+
+		/* Set source format */
+		memset(&subdev_fmt, 0, sizeof(subdev_fmt));
+		subdev_fmt.format.code = pixel_mc_plugin_to_subdev(source_pix);
+		subdev_fmt.which = V4L2_SUBDEV_FORMAT_TRY;
+		subdev_fmt.format.width = res.width;
+		subdev_fmt.format.height = res.height;
+		subdev_fmt.pad = link->source->index;
+
+		err = SYS_IOCTL(source->entity->fd, VIDIOC_SUBDEV_S_FMT, &subdev_fmt);
+		if (err < 0) {
+			perror("Error try source format:");
+			break;
+		} else {
+			res.width = subdev_fmt.format.width;
+			res.height = subdev_fmt.format.height;
+			source_pix = pixel_subdev_to_mc_plugin(subdev_fmt.format.code);
+		}
+
+		if (media_entity_type(pos->entity) == MEDIA_ENTITY_TYPE_NODE && sink)
+			break;
+
+		/* Set sink format */
+		memset(&subdev_fmt, 0, sizeof(subdev_fmt));
+		subdev_fmt.format.code = pixel_mc_plugin_to_subdev(sink_pix);
+		subdev_fmt.which = V4L2_SUBDEV_FORMAT_TRY;
+		subdev_fmt.format.width = res.width;
+		subdev_fmt.format.height = res.height;
+		subdev_fmt.pad = link->sink->index;
+
+		err = SYS_IOCTL(sink->entity->fd, VIDIOC_SUBDEV_S_FMT, &subdev_fmt);
+		if (err < 0) {
+			MC_PLUGIN_PRINTF("Error try sink format\n");
+			break;
+		} else {
+			res.width = subdev_fmt.format.width;
+			res.height = subdev_fmt.format.height;
+			sink_pix = pixel_subdev_to_mc_plugin(subdev_fmt.format.code);
+		}
+
+		/* Sink pix is not supported modify source pixelformat also */
+		if (source_pix != sink_pix) {
+			source_pix = sink_pix;
+
+			memset(&subdev_fmt, 0, sizeof(subdev_fmt));
+			subdev_fmt.format.code = pixel_mc_plugin_to_subdev(source_pix);
+			subdev_fmt.which = V4L2_SUBDEV_FORMAT_TRY;
+			subdev_fmt.format.width = res.width;
+			subdev_fmt.format.height = res.height;
+			subdev_fmt.pad = link->source->index;
+
+			err = SYS_IOCTL(source->entity->fd, VIDIOC_SUBDEV_S_FMT, &subdev_fmt);
+			if (err < 0) {
+				perror("Error try source format:");
+				break;
+			} else {
+				res.width = subdev_fmt.format.width;
+				res.height = subdev_fmt.format.height;
+				source_pix = pixel_subdev_to_mc_plugin(subdev_fmt.format.code);
+			}
+
+			err += (source_pix == sink_pix) ? 0 : -1;
+		}
+
+		if (err < 0) {
+			fprintf(stderr, "Error try source format for second time %s\n", source->entity->info.name);
+			break;
+		}
+
+		/* Store correct source pixel format and resolution */
+		if (first_submodule) {
+			*src_pix = source_pix;
+			*src_res = res;
+			first_submodule = 0;
+		}
+
+		/* Try to set destination pixel fmt */
+		source_pix = sink_pix = *dst_pix;
+		/* Continue with next element */
+		source = sink;
+	}
+
+	/* Set Destination resolution and pixel format */
+	if (0 == err) {
+		*dst_pix = sink_pix;
+		*dst_res = res;
+	}
+
+	return err;
+}
diff --git a/paths.h b/paths.h
new file mode 100644
index 0000000..58d2409
--- /dev/null
+++ b/paths.h
@@ -0,0 +1,64 @@
+/*
+ * Copyright (C) 2011 Nokia Corporation
+ *
+ * Contact: Yordan Kamenov <ykamenov@mm-sol.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License along
+ * with this program; if not, write to the Free Software Foundation, Inc.,
+ */
+
+#ifndef __PATHS_H__
+#define __PATHS_H__
+
+#include <linux/videodev2.h>
+#include <mediactl/media.h>
+
+#include "libv4l2plugin-omap3mc.h"
+
+struct media_link *media_find_link(struct media_device *media,
+	struct media_entity *source,
+	struct media_entity *sink);
+int pixel_mc_plugin_to_subdev(enum mc_plugin_pixelformat pixfmt);
+enum mc_plugin_pixelformat pixel_subdev_to_mc_plugin(int pixfmt);
+int pixel_mc_plugin_to_v4l(enum mc_plugin_pixelformat pixfmt);
+enum mc_plugin_pixelformat pixel_v4l_to_mc_plugin(int pixfmt);
+const struct capture_pipeline *pipe_sensor_yuv(int primary);
+struct ipipe_descriptor *path_allocate(struct media_device *media,
+	const struct capture_pipeline *pipe);
+struct sub_module *submodule_alloc();
+void submodule_free(struct sub_module *sb);
+struct sub_module *path_destination_submodule(struct ipipe_descriptor *path);
+int path_power_on(struct ipipe_descriptor *path, int fd);
+int submodule_open(struct sub_module *sb, int fd, int last_sb);
+int path_connect_entities(struct media_device *media,
+	struct ipipe_descriptor *path);
+void path_power_off(struct ipipe_descriptor *path);
+int submodule_power_off(struct sub_module *sb, int last_sb);
+int path_disconnect_entities(struct media_device *media,
+	struct ipipe_descriptor *path);
+int path_enum_src_framesizes(struct omap3mcplugin *plugin,
+	enum mc_plugin_pixelformat *pixfmt,
+	struct v4l2_rect *res, int max_rect);
+int path_set_resolution(struct omap3mcplugin *plugin,
+	struct v4l2_rect *src_res,
+	enum mc_plugin_pixelformat *src_pix,
+	struct v4l2_rect *dst_res,
+	enum mc_plugin_pixelformat *dst_pix);
+int path_try_resolution(struct omap3mcplugin *plugin,
+	struct v4l2_rect *src_res,
+	enum mc_plugin_pixelformat *src_pix,
+	struct v4l2_rect *dst_res,
+	enum mc_plugin_pixelformat *dst_pix);
+
+
+#endif /* __PATHS_H__ */
diff --git a/sl_list.h b/sl_list.h
new file mode 100644
index 0000000..e48b984
--- /dev/null
+++ b/sl_list.h
@@ -0,0 +1,65 @@
+/*
+ * Copyright (C) 2011 Nokia Corporation
+ *
+ * Contact: Yordan Kamenov <ykamenov@mm-sol.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License along
+ * with this program; if not, write to the Free Software Foundation, Inc.,
+ */
+
+#ifndef __SINGLE_LINKED_LIST_H__
+#define __SINGLE_LINKED_LIST_H__
+
+/* Simple single linked list implementation. */
+
+struct list_head {
+	struct list_head *next;
+};
+
+static inline void INIT_LIST_HEAD(struct list_head *list)
+{
+	list->next = list;
+}
+
+/* Insert new node after known node */
+static inline void list_add_after(struct list_head *new,
+					struct list_head *prev)
+{
+	new->next = prev->next;
+	prev->next = new;
+}
+
+/* Insert new node at the end of the list */
+static inline void list_add_tail(struct list_head *new, struct list_head *head)
+{
+	struct list_head *element = head;
+
+	while (element->next != head)
+		element = element->next;
+
+	list_add_after(new, element);
+}
+
+ /* Get the struct for this entry */
+#define list_entry(ptr, type, member)({          \
+	const typeof( ((type *)0)->member ) *__mptr = (ptr);    \
+	((type *)(void *)( (char *)__mptr - offsetof(type,member) ));})
+
+
+/* Iterate over the list */
+#define list_for_each_entry(pos, head, member)              \
+	for (pos = list_entry((head)->next, typeof(*pos), member);  \
+		&pos->member != (head);    \
+		pos = list_entry(pos->member.next, typeof(*pos), member))
+
+#endif
-- 
1.7.3.1

