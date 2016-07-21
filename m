Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:22871 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753166AbcGUPQW (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 21 Jul 2016 11:16:22 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, hverkuil@xs4all.nl
Subject: [v4l-utils RFC 3/3] mediatext: Add library
Date: Thu, 21 Jul 2016 18:15:46 +0300
Message-Id: <1469114146-11109-4-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1469114146-11109-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1469114146-11109-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

libmediatext is a helper library for converting configurations (Media
controller links, V4L2 controls and V4L2 sub-device media bus formats and
selections) from text-based form into IOCTLs.

libmediatext depends on libv4l2subdev and libmediactl.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 libmediatext.pc.in                 |   10 +
 utils/media-ctl/Makefile.am        |   10 +-
 utils/media-ctl/libmediatext.pc.in |   10 +
 utils/media-ctl/mediatext-test.c   |  114 ++
 utils/media-ctl/mediatext.c        | 2012 ++++++++++++++++++++++++++++++++++++
 utils/media-ctl/mediatext.h        |   33 +
 6 files changed, 2187 insertions(+), 2 deletions(-)
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
index 8fe653d..a233f16 100644
--- a/utils/media-ctl/Makefile.am
+++ b/utils/media-ctl/Makefile.am
@@ -1,4 +1,4 @@
-noinst_LTLIBRARIES = libmediactl.la libv4l2subdev.la
+noinst_LTLIBRARIES = libmediactl.la libv4l2subdev.la libmediatext.la
 
 libmediactl_la_SOURCES = libmediactl.c mediactl-priv.h
 libmediactl_la_CFLAGS = -static $(LIBUDEV_CFLAGS)
@@ -26,9 +26,15 @@ libv4l2subdev_la_LIBADD = libmediactl.la
 libv4l2subdev_la_CFLAGS = -static
 libv4l2subdev_la_LDFLAGS = -static
 
+libmediatext_la_SOURCES = mediatext.c
+libmediatext_la_CFLAGS = -static $(LIBUDEV_CFLAGS)
+libmediatext_la_LDFLAGS = -static $(LIBUDEV_LIBS)
+
 mediactl_includedir=$(includedir)/mediactl
 noinst_HEADERS = mediactl.h v4l2subdev.h
 
-bin_PROGRAMS = media-ctl
+bin_PROGRAMS = media-ctl mediatext
 media_ctl_SOURCES = media-ctl.c options.c options.h tools.h
 media_ctl_LDADD = libmediactl.la libv4l2subdev.la
+mediatext_SOURCES = mediatext-test.c
+mediatext_LDADD = libmediatext.la libmediactl.la libv4l2subdev.la
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
index 0000000..6313fa5
--- /dev/null
+++ b/utils/media-ctl/mediatext-test.c
@@ -0,0 +1,114 @@
+/*
+ * libmediatext test program
+ *
+ * Copyright (C) 2013--2016 Intel Corporation
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
+#include <getopt.h>
+#include <stdbool.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <unistd.h>
+
+#include "mediactl.h"
+#include "mediatext.h"
+
+static const struct option opts[] = {
+	{ "device", 1, 0, 'd', },
+	{ "fd", 1, 0, 'f', },
+	{ "help", 0, 0, 'h', },
+	{ "verbose", 0, 0, 'v', },
+	{ 0 },
+};
+
+void help(char *myname)
+{
+	fprintf(stderr, "usage: %s <media device> <string>\n\n", myname);
+	fprintf(stderr, "\tstring := [ v4l2-ctrl | v4l2-mbus | link-reset | link-conf]\n\n");
+	fprintf(stderr, "\tv4l2-ctrl := \"entity\" ctrl_type ctrl_id ctrl_value\n");
+	fprintf(stderr, "\tctrl_type := [ int | int64 | bitmask ]\n");
+	fprintf(stderr, "\tctrl_value := [ %%d | %%PRId64 | bitmask_value ]\n");
+	fprintf(stderr, "\tbitmask_value := b<binary_number>\n\n");
+	fprintf(stderr, "\tv4l2-mbus := \n");
+	fprintf(stderr, "\tlink-conf := \"entity\":pad -> \"entity\":pad[link-flags]\n");
+}
+
+int main(int argc, char *argv[])
+{
+	struct media_device *device;
+	struct media_text *mt;
+	bool verbose = false;
+	char *devname = "/dev/media0";
+	int fd = 0;
+	int opt;
+	int rval;
+
+	while ((opt = getopt_long(argc, argv, "d:f:hv", opts, NULL)) != -1) {
+		switch (opt) {
+		case 'd':
+			devname = optarg;
+			break;
+		case 'f':
+			fd = atoi(optarg);
+			break;
+		case 'h':
+			help(argv[0]);
+			return EXIT_SUCCESS;
+		case 'v':
+			verbose = true;
+			break;
+		default:
+			fprintf(stderr, "unknown option '%c'\n", opt);
+			return EXIT_FAILURE;
+		}
+	}
+
+	device = media_device_new(devname);
+	if (!device)
+		return EXIT_FAILURE;
+
+	if (verbose)
+		media_debug_set_handler(device, (void (*)(void *, ...))fprintf,
+					stdout);
+
+	rval = media_device_enumerate(device);
+	if (rval)
+		return EXIT_FAILURE;
+
+	mt = mediatext_init(device);
+	if (!mt)
+		return EXIT_FAILURE;
+
+	if (optind < argc) {
+		rval = mediatext_parse(mt, argv[optind]);
+		if (rval) {
+			fprintf(stderr, "bad string %s (%s)\n", argv[2],
+				strerror(-rval));
+			return EXIT_FAILURE;
+		}
+	}
+
+	rval = mediatext_poll(mt, fd);
+
+	mediatext_cleanup(mt);
+
+	media_device_unref(device);
+
+	return EXIT_SUCCESS;
+}
diff --git a/utils/media-ctl/mediatext.c b/utils/media-ctl/mediatext.c
new file mode 100644
index 0000000..5766e11
--- /dev/null
+++ b/utils/media-ctl/mediatext.c
@@ -0,0 +1,2012 @@
+/*
+ * Media controller text-based configuration library
+ *
+ * Copyright (C) 2013--2016 Intel Corporation
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
+#include <assert.h>
+#include <ctype.h>
+#include <errno.h>
+#include <fcntl.h>
+#include <inttypes.h>
+#include <malloc.h>
+#include <poll.h>
+#include <stdbool.h>
+#include <stdio.h>
+#include <stdint.h>
+#include <stdlib.h>
+#include <string.h>
+#include <unistd.h>
+
+#include <sys/ioctl.h>
+#include <sys/mman.h>
+#include <sys/stat.h>
+#include <sys/types.h>
+
+#include <linux/types.h>
+
+#include "mediactl.h"
+#include "mediactl-priv.h"
+#include "tools.h"
+#include "v4l2subdev.h"
+
+struct {
+	char *string;
+	uint32_t pixelformat;
+} v4l2_pix_formats[] = {
+#include "v4l2-pix-formats.h"
+};
+
+#define container_of(ptr, type, field) \
+	((type *)((uintptr_t)ptr - (uintptr_t)&(((type *)NULL)->field)))
+
+#define array_length(a) (sizeof(a) / sizeof(*(a)))
+
+struct list {
+	struct list *next;
+	struct list *prev;
+};
+
+#define list_next(list) ((list)->next)
+#define list_first(list) list_next(list)
+#define list_last(list) list_prev(list)
+#define list_prev(list) ((list)->prev)
+
+static void list_init(struct list *list)
+{
+	list->next = list;
+	list->prev = list;
+}
+
+static bool list_empty(struct list *list)
+{
+	return list->next == list->prev;
+}
+
+static void list_add(struct list *list, struct list *item)
+{
+	item->next = list->next;
+	list->next->prev = item;
+	list->next = item;
+	item->prev = list;
+}
+
+static void list_add_tail(struct list *list, struct list *item)
+{
+	list_add(list_last(list), item);
+}
+
+static void list_del(struct list *item)
+{
+	item->prev->next = item->next;
+	item->next->prev = item->prev;
+	item->prev = item;
+	item->next = item;
+}
+
+#define list_for_each(list, iter)			      \
+	for (iter = list_next(list); iter != (list);	      \
+	     iter = list_next(iter))
+
+#define list_for_each_entry(list, entry, type, field)			\
+	for (entry = container_of(list_next(list), type, field);	\
+	     &entry->field != list;					\
+	     entry = container_of(list_next(&entry->field), type, field))
+
+struct name {
+	uint32_t id;
+	char *str;
+	struct list list;
+};
+
+void name_cleanup(struct name *name)
+{
+	free(name->str);
+	list_del(&name->list);
+}
+
+int name_init(struct list *list, struct name *name, uint32_t id, char *str)
+{
+	struct list *iter;
+
+	list_for_each(list, iter) {
+		struct name *n = container_of(iter, struct name, list);
+
+		if (!strcmp(n->str, str))
+			return -EEXIST;
+	}
+
+	name->str = strdup(str);
+	if (!name->str)
+		return -ENOMEM;
+
+	name->id = id;
+
+	list_add_tail(list, &name->list);
+
+	return 0;
+}
+
+struct name *name_find(struct list *list, char *str)
+{
+	struct list *iter;
+
+	list_for_each(list, iter) {
+		struct name *name = container_of(iter, struct name, list);
+
+		if (!strcmp(str, name->str))
+			return name;
+	}
+
+	return NULL;
+}
+
+struct name *name_find_by_id(struct list *list, unsigned int id)
+{
+	struct list *iter;
+
+	list_for_each(list, iter) {
+		struct name *name = container_of(iter, struct name, list);
+
+		if (id == name->id)
+			return name;
+	}
+
+	return NULL;
+}
+
+#define list_to_name(__list) container_of(__list, struct name, list)
+
+#define list_for_each_name(__list, __name) \
+	list_for_each_entry(__list, __name, struct name, list)
+
+struct mt_buf {
+	struct v4l2_buffer vb;
+	struct v4l2_plane planes[VIDEO_MAX_PLANES];
+	void *plane_ptrs[VIDEO_MAX_PLANES];
+	bool dirty;
+};
+
+struct mt_request {
+	struct name name;
+	unsigned int refcount;
+};
+
+struct v4l2_device {
+	struct name name;
+	int fd;
+	dev_t dev;
+	struct mt_buf *bufs;
+	unsigned int nbufs;
+	unsigned int queued;
+	uint32_t type;
+	uint32_t memory;
+	bool streaming;
+	bool auto_write;
+	bool auto_qbuf;
+	char *buf_fname;
+	struct timeval ts;
+	struct v4l2_format fmt;
+	struct media_entity *entity;
+};
+
+struct media_text {
+	struct media_device *media;
+	struct list vdev_names;
+	struct list request_names;
+	unsigned int requests_queued;
+	bool verbose;
+	FILE *log;
+	bool quit;
+};
+
+struct media_text *mediatext_init(struct media_device *media)
+{
+	struct media_text *mt;
+
+	mt = calloc(1, sizeof(*mt));
+	if (!mt)
+		return NULL;
+
+	mt->media = media;
+	mt->log = stderr;
+
+	list_init(&mt->request_names);
+	list_init(&mt->vdev_names);
+
+	return mt;
+}
+
+static void v4l2_close(struct media_text *mt, struct v4l2_device *vdev);
+
+void mediatext_cleanup(struct media_text *mt)
+{
+	while (!list_empty(&mt->vdev_names)) {
+		struct name *name = list_to_name(list_first(&mt->vdev_names));
+		struct v4l2_device *vdev =
+			container_of(name, struct v4l2_device, name);
+
+		v4l2_close(mt, vdev);
+	}
+
+	if (mt && mt->log != stderr)
+		fclose(mt->log);
+	free(mt);
+}
+
+#define FLAG_ARGS_NONE		0x0001
+#define FLAG_ARGS_OPTIONAL	0x0002
+#define FLAG_MENU		0x0004
+
+struct parser {
+	char *prefix;
+	int (*parse)(struct media_text *media,
+		     char *string, bool help);
+	unsigned long flags;
+	char *help;
+};
+
+static void show_help(struct media_text *mt, const struct parser *p)
+{
+	while (p->prefix) {
+		fprintf(mt->log, "\t%s\n", p->prefix);
+		p++;
+	}
+}
+
+static int parse(struct media_text *mt, const struct parser *p, char *string,
+		 bool help)
+{
+	if (!string && help) {
+		show_help(mt, p);
+		return 0;
+	}
+
+	while (isspace(*string))
+		string++;
+
+	if (!*string)
+		return 0;
+
+	for (; p->prefix; p++) {
+		size_t len = strlen(p->prefix);
+		bool has_arg;
+		int rval;
+
+		if (strncmp(p->prefix, string, len))
+			continue;
+
+		string += len;
+
+		for (; isspace(*string); string++);
+
+		has_arg = strlen(string);
+
+		if (help && !has_arg) {
+			fprintf(mt->log, "%s\n", p->help);
+			return p->flags & FLAG_MENU ?
+				p->parse(mt, NULL, help) : 0;
+		}
+
+		if (p->flags & FLAG_ARGS_OPTIONAL)
+			return p->parse(mt, has_arg ? string : NULL, help);
+		else if (!(p->flags & FLAG_ARGS_NONE) && !has_arg)
+			return -ENOEXEC;
+		else
+			return p->parse(mt, string, help);
+
+		if (!help || !rval)
+			return rval;
+
+		return 0;
+
+	}
+
+	fprintf(mt->log,
+		"invalid command \"%s\"; use \"help\" for help\n",
+		string);
+
+	return 0;
+}
+
+#define MAX_ARG 32
+
+struct arg {
+	unsigned int n;
+	char *str;
+	struct pair {
+		char *key;
+		char *value;
+	} pair[MAX_ARG];
+};
+
+static int arg_parse(struct media_text *mt, struct arg *a, char *str)
+{
+	char *base;
+	char *end = str + strlen(str) + 1 /* \0 */;
+
+	memset(a, 0, sizeof(*a));
+
+	a->str = str;
+
+	for (base = str; *str && a->n < MAX_ARG && str < end; str++, base = str) {
+		while (isspace(*str))
+			str++;
+
+		a->pair[a->n].key = str;
+
+		for (; *str && *str != '='; str++)
+			if (isspace(*str))
+				*str = 0;
+
+		if (*str != '=') {
+			*str = 0;
+			a->n++;
+			break;
+		}
+
+		*str = 0;
+
+		str++;
+		base = str;
+
+		if (*str != '"') {
+			while (*str && !isspace(*str))
+				str++;
+			a->pair[a->n].value = base;
+			*str = 0;
+			a->n++;
+			continue;
+		}
+
+		/* Handle quoted strings */
+		if (!str[1]) {
+			fprintf(mt->log, "unmatched \" at %s\n", str);
+			return -EINVAL;
+		}
+
+		/* Copy the entire string on top of the quote mark */
+		memmove(str, str + 1, strlen(str));
+
+		while (*str && *str != '"') {
+			if (*str == '\\') {
+				if (str[1] != '"') {
+					fprintf(mt->log, "invalid \\ at %s\n",
+						str);
+					return -EINVAL;
+				} else {
+					memmove(base + 1, base, str - base);
+					base++;
+					*str = '"';
+				}
+			}
+			str++;
+		}
+		if (!*str) {
+			fprintf(mt->log, "unmatched \" at %s\n", str);
+			return -EINVAL;
+		}
+		*str = 0;
+		a->pair[a->n].value = base;
+		a->n++;
+	}
+
+	return 0;
+}
+
+struct pair *arg_pos(struct arg *a, unsigned int pos)
+{
+	if (pos >= a->n)
+		return NULL;
+
+	return &a->pair[pos];
+}
+
+static char *arg(struct arg *a, char *key)
+{
+	unsigned int pos;
+
+	for (pos = 0; pos < a->n; pos++) {
+		if (!strcmp(a->pair[pos].key, key))
+			return a->pair[pos].value;
+	}
+
+	return NULL;
+}
+
+enum param_type {
+	PARAM_TYPE_INT,
+	PARAM_TYPE_U32,
+	PARAM_TYPE_BOOL,
+	PARAM_TYPE_STRING,
+	PARAM_TYPE_V4L2_DEVICE,
+	PARAM_TYPE_MEMORY,
+	PARAM_TYPE_BUF_TYPE,
+	PARAM_TYPE_PIXELFORMAT,
+	PARAM_TYPE_MEDIA_REQ,
+};
+
+struct param {
+	char *key;
+	enum param_type type;
+	void *ptr;
+	bool optional;
+};
+
+static int get_buf_type(struct media_text *mt, char *s)
+{
+	if (!strcmp(s, "CAPTURE"))
+		return V4L2_BUF_TYPE_VIDEO_CAPTURE;
+	else if (!strcmp(s, "CAPTURE_MPLANE"))
+		return V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE;
+
+	fprintf(mt->log, "invalid buffer type %s\n", s);
+
+	return -EINVAL;
+}
+
+static int get_memory(struct media_text *mt, char *s)
+{
+	if (!strcmp(s, "MMAP"))
+		return V4L2_MEMORY_MMAP;
+	else if (!strcmp(s, "USERPTR"))
+		return V4L2_MEMORY_USERPTR;
+
+	printf("invalid memory %s\n", s);
+	return -EINVAL;
+}
+
+static int get_pixel_format(struct media_text *mt, char *s, uint32_t *pixelformat)
+{
+	unsigned int i;
+
+	for (i = 0; i < ARRAY_SIZE(v4l2_pix_formats); i++) {
+		if (strcmp(s, v4l2_pix_formats[i].string))
+			continue;
+
+		*pixelformat = v4l2_pix_formats[i].pixelformat;
+
+		return 0;
+	}
+
+	fprintf(mt->log, "can't find pixelformat \"%s\"\n", s);
+
+	return -ENOENT;
+}
+
+static struct v4l2_device *v4l2_device_find(struct media_text *mt, int fd)
+{
+	struct name *name;
+
+	list_for_each_name(&mt->vdev_names, name) {
+		struct v4l2_device *vdev =
+			container_of(name, struct v4l2_device, name);
+
+		if (vdev->fd != fd)
+			continue;
+
+		return vdev;
+	}
+
+	return NULL;
+}
+
+static void request_get(struct mt_request *mtr)
+{
+	mtr->refcount++;
+}
+
+static void request_put(struct mt_request *mtr)
+{
+	if (mtr && !--mtr->refcount) {
+		name_cleanup(&mtr->name);
+		free(mtr);
+	}
+}
+
+static struct mt_request *request_find(struct media_text *mt, char *str)
+{
+	struct name *name;
+
+	name = name_find(&mt->request_names, str);
+
+	if (!name)
+		return NULL;
+
+	return container_of(name, struct mt_request, name);
+}
+
+static struct mt_request *request_find_by_id(struct media_text *mt,
+					     unsigned int id)
+{
+	struct name *name;
+
+	name = name_find_by_id(&mt->request_names, id);
+
+	if (!name)
+		return NULL;
+
+	return container_of(name, struct mt_request, name);
+}
+
+static int arg_param(struct media_text *mt, struct arg *a, struct param *p)
+{
+	for (; p->key; p++) {
+		char *s = arg(a, p->key);
+
+		if (!s) {
+			if (p->optional)
+				continue;
+			fprintf(mt->log, "missing mandatory parameter \"%s\"\n",
+				p->key);
+			return -EINVAL;
+		}
+
+		switch (p->type) {
+		case PARAM_TYPE_INT:
+			*(int *)p->ptr = atoi(s);
+			break;
+		case PARAM_TYPE_U32:
+			*(uint32_t *)p->ptr = strtoul(s, NULL, 0);
+			break;
+		case PARAM_TYPE_BOOL:
+			*(bool *)p->ptr = !(strcasecmp(s, "true") && strcmp(s, "1"));
+			break;
+		case PARAM_TYPE_STRING:
+			*(char **)p->ptr = s;
+			break;
+		case PARAM_TYPE_V4L2_DEVICE: {
+			struct name *name = name_find(&mt->vdev_names, s);
+
+			if (name) {
+				*(struct v4l2_device **)p->ptr =
+					container_of(name, struct v4l2_device,
+						     name);
+				break;
+			}
+
+			*(struct v4l2_device **)p->ptr =
+				v4l2_device_find(mt, atoi(s));
+
+			if (!*(struct v4l2_device **)p->ptr) {
+				fprintf(mt->log,
+					"unable to find video device \"%s\"\n",
+					s);
+				return -EINVAL;
+			}
+			break;
+		}
+		case PARAM_TYPE_MEMORY: {
+			int memory = get_memory(mt, s);
+
+			if (memory < 0)
+				return memory;
+
+			*(uint32_t *)p->ptr = memory;
+			break;
+		}
+		case PARAM_TYPE_BUF_TYPE: {
+			int type = get_buf_type(mt, s);
+
+			if (type < 0)
+				return type;
+
+			*(uint32_t *)p->ptr = type;
+			break;
+		}
+		case PARAM_TYPE_PIXELFORMAT: {
+			uint32_t pixelformat;
+			int rval = get_pixel_format(mt, s, &pixelformat);
+
+			if (rval < 0)
+				return rval;
+
+			*(uint32_t *)p->ptr = pixelformat;
+			break;
+		}
+		case PARAM_TYPE_MEDIA_REQ: {
+			struct mt_request *mtr = request_find(mt, s);
+
+			if (!mtr)
+				return -ENOENT;
+
+			*(struct mt_request **)p->ptr = mtr;
+			break;
+		}
+		default:
+			return -EINVAL;
+		}
+	}
+
+	return 0;
+}
+
+static int parse_param(struct media_text *mt, struct param *p, char *s)
+{
+	struct arg a;
+	int rval;
+
+	rval = arg_parse(mt, &a, s);
+	if (rval)
+		return rval;
+
+	return arg_param(mt, &a, p);
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
+static int parse_v4l2_ctrl(struct media_text *mt,
+			   char *string, bool help)
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
+	entity = media_parse_entity(mt->media, string, &string);
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
+	for (; isspace(*string); string++);
+	rval = sscanf(string, "0x%" PRIx32, &ctrl.id);
+	if (rval <= 0)
+		return -EINVAL;
+
+	for (; !isspace(*string) && *string; string++);
+	for (; isspace(*string); string++);
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
+	media_dbg(mt->media,
+		  "Setting control 0x%8.8x (type %s), value %" PRId64 "\n",
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
+			if (rval != -1)
+				ctrl.value64 = old.value;
+		}
+	}
+	if (rval == -1) {
+		rval = -errno;
+		media_dbg(mt->media,
+			  "Failed setting control 0x8.8x: %s (%d) to value %"
+			  PRId64 "\n", ctrl.id, strerror(errno), errno, val);;
+		return rval;
+	}
+
+	if (val != ctrl.value64)
+		media_dbg(mt->media,
+			  "Asking for %" PRId64 ", got %" PRId64 "\n",
+			  val, ctrl.value64);
+
+	return 0;
+}
+
+static int parse_v4l2_subdev_fmt(struct media_text *mt,
+				 char *string, bool help)
+{
+	media_dbg(mt->media, "Media bus format setup: \"%s\"\n", string);
+	return v4l2_subdev_parse_setup_formats(mt->media, string);
+}
+
+static bool is_buf_type_capture(int type)
+{
+	switch (type) {
+	case V4L2_BUF_TYPE_VIDEO_CAPTURE:
+	case V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE:
+		return true;
+	default:
+		return false;
+	}
+}
+
+static bool is_buf_type_mplane(int type)
+{
+	switch (type) {
+	case V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE:
+		return true;
+	default:
+		return false;
+	}
+}
+
+static int v4l2_reqbufs_zero(struct media_text *mt, struct v4l2_device *vdev)
+{
+	struct v4l2_requestbuffers rb = { .type = vdev->type,
+					  .count = 0,
+					  .memory = vdev->memory };
+	unsigned int i;
+	int rval;
+
+	if (vdev->streaming) {
+		fprintf(mt->log, "still streaming\n");
+		return -EBUSY;
+	}
+
+	for (i = 0; i < vdev->nbufs; i++) {
+		unsigned int j;
+
+		if (!vdev->bufs[i].plane_ptrs)
+			continue;
+
+		for (j = 0; j < is_buf_type_mplane(vdev->type) ?
+			     vdev->bufs[i].vb.length : 1; j++) {
+			if (!vdev->bufs[i].plane_ptrs[j])
+				continue;
+
+			munmap(vdev->bufs[i].plane_ptrs[j], is_buf_type_mplane(vdev->type) ?
+			       vdev->bufs[i].planes[j].length : vdev->bufs[i].vb.length);
+		}
+	}
+
+	rval = ioctl(vdev->fd, VIDIOC_REQBUFS, &rb);
+	if (rval == -1)
+		return -errno;
+
+	free(vdev->bufs);
+	vdev->bufs = NULL;
+	vdev->nbufs = 0;
+
+	return 0;
+}
+
+static int v4l2_querybuf(struct v4l2_device *vdev, unsigned int index)
+{
+	struct v4l2_buffer *vb = &vdev->bufs[index].vb;
+
+	vb->memory = vdev->memory;
+	vb->type = vdev->type;
+	vb->index = index;
+	vb->m.planes = vdev->bufs[index].planes;
+	vb->length = vdev->fmt.fmt.pix_mp.num_planes;
+
+	return ioctl(vdev->fd, VIDIOC_QUERYBUF, vb) == -1 ? -errno : 0;
+}
+
+static int parse_v4l2_reqbufs(struct media_text *mt, char *string, bool help)
+{
+	struct v4l2_requestbuffers rb = { 0 };
+	struct v4l2_device *vdev;
+	struct param p[] = {
+		{ "vdev", PARAM_TYPE_V4L2_DEVICE, &vdev },
+		{ "type", PARAM_TYPE_BUF_TYPE, &rb.type },
+		{ "count", PARAM_TYPE_U32, &rb.count },
+		{ "memory", PARAM_TYPE_MEMORY, &rb.memory },
+		{ 0 },
+	};
+	unsigned int i;
+	int rval;
+
+	rval = parse_param(mt, p, string);
+	if (rval)
+		return rval;
+
+	if (!rb.count)
+		return v4l2_reqbufs_zero(mt, vdev);
+
+	if (vdev->nbufs) {
+		fprintf(mt->log, "buffers allocated already\n");
+		return -EINVAL;
+	}
+
+	vdev->bufs = calloc(rb.count, sizeof(*vdev->bufs));
+	if (!vdev->bufs)
+		return -ENOMEM;
+
+	rval = ioctl(vdev->fd, VIDIOC_REQBUFS, &rb);
+	if (rval == -1) {
+		rval = -errno;
+		goto out_release;
+	}
+
+	vdev->memory = rb.memory;
+	vdev->type = rb.type;
+	vdev->nbufs = rb.count;
+
+	for (i = 0; i < rb.count; i++) {
+		struct v4l2_buffer *vb = &vdev->bufs[i].vb;
+		struct v4l2_plane *planes = vdev->bufs[i].planes;
+		void **plane_ptrs = vdev->bufs[i].plane_ptrs;
+		unsigned int j;
+
+		rval = v4l2_querybuf(vdev, i);
+		if (rval) {
+			v4l2_reqbufs_zero(mt, vdev);
+			return rval;
+		}
+
+		for (j = 0; j < (is_buf_type_mplane(vdev->type) ?
+				 vb->length : 1); j++) {
+			plane_ptrs[j] = mmap(
+				NULL, is_buf_type_mplane(vdev->type) ?
+				planes[j].length : vb->length,
+				PROT_READ | PROT_WRITE, MAP_SHARED,
+				vdev->fd, is_buf_type_mplane(vdev->type) ?
+				planes[j].m.mem_offset : vb->m.offset);
+
+			if (!plane_ptrs[j]) {
+				v4l2_reqbufs_zero(mt, vdev);
+				fprintf(mt->log, "failed to mmap %u/%u\n",
+					i, j);
+				return -ENOMEM;
+			}
+		}
+
+	}
+
+	return 0;
+
+out_release:
+
+	return rval;
+}
+
+static int parse_v4l2_set_format(struct media_text *mt, char *string, bool help)
+{
+	struct v4l2_format fmt = { 0 };
+	struct v4l2_device *vdev = NULL;
+	struct arg a;
+	struct param p[] = {
+		{ "vdev", PARAM_TYPE_V4L2_DEVICE, &vdev, true },
+		{ "type", PARAM_TYPE_BUF_TYPE, &fmt.type },
+		{ "width", PARAM_TYPE_U32, &fmt.fmt.pix.width },
+		{ "height", PARAM_TYPE_U32, &fmt.fmt.pix.height },
+		{ "pixelformat", PARAM_TYPE_PIXELFORMAT, &fmt.fmt.pix.pixelformat },
+		{ 0 },
+	};
+	int rval;
+
+	rval = arg_parse(mt, &a, string);
+	if (rval)
+		return rval;
+
+	rval = arg_param(mt, &a, p);
+	if (rval)
+		return rval;
+
+	if (is_buf_type_mplane(fmt.type)) {
+		struct param pm[] = {
+			{ "num_planes", PARAM_TYPE_U32, &fmt.fmt.pix_mp.num_planes },
+			{ 0 },
+		};
+
+		rval = arg_param(mt, &a, pm);
+		if (rval)
+			return rval;
+
+		if (fmt.fmt.pix_mp.num_planes > VIDEO_MAX_PLANES)
+			return -EINVAL;
+	} else {
+		struct param ps[] = {
+			{ "bytesperline", PARAM_TYPE_U32, &fmt.fmt.pix.bytesperline, true },
+			{ 0 },
+		};
+
+		rval = arg_param(mt, &a, ps);
+		if (rval)
+			return rval;
+	}
+
+	rval = ioctl(vdev->fd, VIDIOC_S_FMT, &fmt);
+	if (rval == -1)
+		return -errno;
+
+	vdev->fmt = fmt;
+
+	return 0;
+}
+
+/* Get a buffer with oldest data to write to memory. */
+static struct mt_buf *oldest_seq_mb_data(struct v4l2_device *vdev)
+{
+	struct mt_buf *best = NULL;
+	unsigned int i;
+
+	for (i = 0; i < vdev->nbufs; i++) {
+		struct mt_buf *this = &vdev->bufs[i];
+
+		if (!(this->vb.flags & V4L2_BUF_FLAG_DONE))
+			continue;
+
+		if (!this->dirty)
+			continue;
+
+		if (!best ||
+		    best->vb.sequence - this->vb.sequence
+		    < this->vb.sequence - best->vb.sequence)
+			best = this;
+	}
+
+	return best;
+}
+
+/* Get a buffer for queueing, preferrably without dirty data. */
+static struct mt_buf *oldest_seq_mb_capture(struct v4l2_device *vdev)
+{
+	struct mt_buf *best = NULL;
+	unsigned int i;
+
+	for (i = 0; i < vdev->nbufs; i++) {
+		struct mt_buf *this = &vdev->bufs[i];
+
+		if (this->vb.flags & V4L2_BUF_FLAG_QUEUED)
+			continue;
+
+		if (best && this->dirty && !best->dirty)
+			continue;
+
+		if (!best ||
+		    best->vb.sequence - this->vb.sequence
+		    < this->vb.sequence - best->vb.sequence)
+			best = this;
+	}
+
+	return best;
+}
+
+static int v4l2_prepare_queue_buf(struct media_text *mt, char *string, bool queue)
+{
+	struct v4l2_device *vdev;
+	uint32_t index = -1, count = 1;
+	struct mt_request *mtr = NULL;
+	struct arg a;
+	struct param p[] = {
+		{ "vdev", PARAM_TYPE_V4L2_DEVICE, &vdev },
+		{ "index", PARAM_TYPE_U32, &index, true },
+		{ "count", PARAM_TYPE_U32, &count, true },
+		{ "req", PARAM_TYPE_MEDIA_REQ, &mtr, true },
+		{ 0 },
+	};
+	int ioctlcmd = queue ? VIDIOC_QBUF : VIDIOC_PREPARE_BUF;
+	int rval;
+
+	rval = arg_parse(mt, &a, string);
+	if (rval)
+		return rval;
+
+	rval = arg_param(mt, &a, p);
+	if (rval)
+		return rval;
+
+	{
+		struct param p2[] = {
+			{ "auto-qbuf", PARAM_TYPE_BOOL, &vdev->auto_qbuf, true },
+			{ 0 },
+		};
+
+		rval = arg_param(mt, &a, p2);
+		if (rval)
+			return rval;
+	}
+
+	if (mtr) {
+		if (vdev->auto_qbuf) {
+			fprintf(mt->log,
+				"auto-qbuf not possible with requests\n");
+			return -EINVAL;
+		}
+
+		if (index == -1) {
+			struct mt_buf *mb = oldest_seq_mb_capture(vdev);
+
+			if (!mb) {
+				fprintf(mt->log,
+					"no free buffers available\n");
+				return -EINVAL;
+			}
+
+			index = mb->vb.index;
+		}
+	}
+
+	if (index != -1) {
+		if (count != 1) {
+			fprintf(mt->log, "can't set both index and count\n");
+			return -EINVAL;
+		}
+
+		vdev->bufs[index].vb.request = mtr ? mtr->name.id : 0;
+
+		if (mt->verbose)
+			fprintf(mt->log, "%s: %s buffer %u\n",
+				media_entity_get_info(vdev->entity)->name,
+				queue ? "queueing" : "preparing", index);
+		rval = ioctl(vdev->fd, ioctlcmd, &vdev->bufs[index].vb);
+		if (rval == -1)
+			return -errno;
+
+		if (mtr)
+			request_get(mtr);
+
+		vdev->queued++;
+
+		return 0;
+	}
+
+	for (index = 0; count && index < vdev->nbufs;
+	     index++) {
+		if (vdev->bufs[index].vb.flags & V4L2_BUF_FLAG_QUEUED)
+			continue;
+
+		if (mt->verbose)
+			fprintf(mt->log, "%s: queueing buffer %u\n",
+				media_entity_get_info(vdev->entity)->name, index);
+
+		rval = ioctl(vdev->fd, ioctlcmd, &vdev->bufs[index].vb);
+		if (rval == -1)
+			return -errno;
+
+		vdev->queued++;
+
+		count--;
+	}
+	if (index == vdev->nbufs && count) {
+		fprintf(mt->log, "no available buffers\n");
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int parse_v4l2_prepare_buf(struct media_text *mt, char *string, bool help)
+{
+	return v4l2_prepare_queue_buf(mt, string, false);
+}
+
+static int parse_v4l2_qbuf(struct media_text *mt, char *string, bool help)
+{
+	return v4l2_prepare_queue_buf(mt, string, true);
+}
+
+static struct mt_buf *mt_buf_seq(struct v4l2_device *vdev, uint32_t sequence)
+{
+	unsigned int i;
+
+	for (i = 0; i < vdev->nbufs; i++) {
+		struct mt_buf *this = &vdev->bufs[i];
+
+		if (!(this->vb.flags & V4L2_BUF_FLAG_DONE))
+			continue;
+
+		if (!this->dirty)
+			continue;
+
+		if (this->vb.sequence == sequence)
+			return this;
+	}
+
+	return NULL;
+}
+
+static int do_write(struct media_text *mt, struct v4l2_device *vdev,
+		    struct mt_buf *mb, char *fname)
+{
+	char __fname[strlen(fname) + 1 /* \0 */ + 20 /* buffer index + plane */];
+	char *pos = strchr(fname, '#');
+	unsigned int plane;
+	int fd;
+	int rval = 0;
+
+	if (!pos && is_buf_type_mplane(vdev->type))
+		pos = fname + strlen(fname);
+
+	for (plane = 0; plane < (is_buf_type_mplane(vdev->type)
+				 ? mb->vb.length : 1); plane++) {
+		char *plane_fname = fname;
+
+		if (pos) {
+			snprintf(__fname, sizeof(__fname),
+				 "%.*s%6.6" PRIu32 "-%1" PRIu32 "%s",
+				 (int)(pos - fname), fname,
+				 mb->vb.sequence, plane,
+				 *pos == '#' ? pos + 1 : pos);
+			plane_fname = __fname;
+		}
+
+		if (mt->verbose)
+			printf("writing plane to \"%s\"\n", plane_fname);
+
+		fd = open(plane_fname, O_CREAT | O_WRONLY | O_TRUNC,
+			  S_IRUSR | S_IWUSR | S_IRGRP | S_IWGRP
+			  | S_IROTH | S_IWOTH);
+		if (fd == -1) {
+			rval = -errno;
+			fprintf(mt->log, "can't open \"%s\" (%s)\n",
+				plane_fname, strerror(errno));
+			return rval;
+		}
+
+		rval = write(fd, mb->plane_ptrs[plane],
+			     is_buf_type_mplane(vdev->type) ?
+			     mb->planes[plane].length : mb->vb.length);
+		if (rval == -1)
+			rval = -errno;
+		else
+			rval = 0;
+		close(fd);
+		if (rval < 0) {
+			fprintf(mt->log, "write %u bytes failed\n",
+				is_buf_type_mplane(vdev->type) ?
+				mb->planes[plane].length : mb->vb.length);
+			goto err;
+		}
+	}
+
+	mb->dirty = false;
+
+err:
+	return rval;
+}
+
+static int parse_v4l2_write(struct media_text *mt, char *string, bool help)
+{
+	struct v4l2_device *vdev;
+	char *fname = NULL;
+	uint32_t sequence = -1;
+	struct param p[] = {
+		{ "vdev", PARAM_TYPE_V4L2_DEVICE, &vdev },
+		{ "fname", PARAM_TYPE_STRING, &fname, true },
+		{ "sequence", PARAM_TYPE_U32, &sequence, true },
+		{ 0 },
+	};
+	struct arg a;
+	struct mt_buf *mb;
+	int rval;
+
+	rval = arg_parse(mt, &a, string);
+	if (rval)
+		return rval;
+
+	rval = arg_param(mt, &a, p);
+	if (rval)
+		return rval;
+
+	{
+		struct param p2[] = {
+			{ "auto-write", PARAM_TYPE_BOOL, &vdev->auto_write, true },
+			{ 0 },
+		};
+		rval = arg_param(mt, &a, p2);
+		if (rval)
+			return rval;
+	}
+
+	if (fname) {
+		free(vdev->buf_fname);
+		vdev->buf_fname = strdup(fname);
+		if (!vdev->buf_fname) {
+			vdev->auto_write = false;
+			return -ENOMEM;
+		}
+	} else {
+		fname = vdev->buf_fname;
+	}
+	if (!fname)
+		return -EINVAL;
+
+	if (vdev->auto_write)
+		return 0;
+
+	mb = mt_buf_seq(vdev, sequence);
+	if (!mb)
+		mb = oldest_seq_mb_data(vdev);
+	if (!mb)
+		return -ENODATA;
+
+	return do_write(mt, vdev, mb, fname);
+}
+
+static int v4l2_dqbuf(struct media_text *mt, struct v4l2_device *vdev)
+{
+	struct v4l2_plane planes[VIDEO_MAX_PLANES];
+	struct v4l2_buffer vb = {
+		.type = vdev->type,
+		.memory = vdev->memory,
+	};
+	int rval;
+
+	if (is_buf_type_mplane(vdev->type)) {
+		vb.length = VIDEO_MAX_PLANES;
+		vb.m.planes = planes;
+	}
+
+	rval = ioctl(vdev->fd, VIDIOC_DQBUF, &vb);
+	if (rval == -1) {
+		fprintf(mt->log, "dqbuf failed\n");
+		return -errno;
+	}
+
+	vdev->queued--;
+
+	vdev->bufs[vb.index].vb = vb;
+	vdev->bufs[vb.index].dirty = true;
+
+	{
+		float fps = vb.timestamp.tv_sec || vb.timestamp.tv_usec ?
+			1000000. / (float)(
+				(vb.timestamp.tv_sec - vdev->ts.tv_sec) * 1000000 +
+				vb.timestamp.tv_usec - vdev->ts.tv_usec) : 0.;
+		struct mt_request *mtr = request_find_by_id(mt, vb.request);
+
+		fprintf(mt->log,
+			"event=dqbuf req=%s entity=\"%s\" vdev=%s index=%u seq=%u ts=%lu.%6.6lu fps=%.3f\n",
+			mtr ? mtr->name.str : "nul",
+			media_entity_get_info(vdev->entity)->name,
+			vdev->name.str, vb.index, vb.sequence,
+			(unsigned long)vb.timestamp.tv_sec,
+			(unsigned long)vb.timestamp.tv_usec, fps);
+
+		request_put(mtr);
+	}
+
+	vdev->ts = vb.timestamp;
+
+	if (vdev->auto_write)
+		do_write(mt, vdev, &vdev->bufs[vb.index], vdev->buf_fname);
+
+	if (vdev->auto_qbuf) {
+		rval = ioctl(vdev->fd, VIDIOC_QBUF, &vb);
+		if (rval == -1) {
+			fprintf(mt->log, "queueing buffer %u failed (%s)\n",
+				vb.index, strerror(errno));
+			return 0;
+		}
+		vdev->queued--;
+	}
+
+	return 0;
+}
+
+static int v4l2_poll(struct media_text *mt, int fd, short revents)
+{
+	struct v4l2_device *vdev;
+
+	vdev = v4l2_device_find(mt, fd);
+	if (!vdev) {
+		fprintf(mt->log, "invalid fd %d\n", fd);
+		return -EINVAL;
+	}
+
+	if (revents & POLLIN)
+		return v4l2_dqbuf(mt, vdev);
+
+	fprintf(mt->log, "no events on fd %d\n", fd);
+
+	return 0;
+}
+
+static int set_stream(struct media_text *mt, char *string, bool enable)
+{
+	struct v4l2_device *vdev;
+	uint32_t type;
+	struct param p[] = {
+		{ "vdev", PARAM_TYPE_V4L2_DEVICE, &vdev },
+		{ "type", PARAM_TYPE_BUF_TYPE, &type },
+		{ 0 },
+	};
+	int rval;
+
+	rval = parse_param(mt, p, string);
+	if (rval)
+		return rval;
+
+	if (enable) {
+		vdev->ts.tv_sec = vdev->ts.tv_usec = 0;
+		rval = ioctl(vdev->fd, VIDIOC_STREAMON, &type);
+	} else {
+		unsigned int i;
+
+		rval = ioctl(vdev->fd, VIDIOC_STREAMOFF, &type);
+
+		for (i = 0; i < vdev->nbufs; i++)
+			v4l2_querybuf(vdev, i);
+
+		vdev->queued = 0;
+	}
+
+	if (rval)
+		return -errno;
+
+	vdev->streaming = enable;
+
+	return 0;
+}
+
+static int parse_v4l2_streamon(struct media_text *mt, char *string, bool help)
+{
+	return set_stream(mt, string, true);
+}
+
+static int parse_v4l2_streamoff(struct media_text *mt, char *string, bool help)
+{
+	return set_stream(mt, string, false);
+}
+
+static int parse_v4l2_open(struct media_text *mt, char *string, bool help)
+{
+	struct media_entity *entity;
+	const char *node, *source_fname;
+	struct stat stat;
+	struct name *name;
+	char *buf_fname;
+	char *s;
+	char *n = NULL;
+	struct param p[] = {
+		{ "entity", PARAM_TYPE_STRING, &s },
+		{ "name", PARAM_TYPE_STRING, &n, true },
+		{ 0 },
+	};
+	struct v4l2_device *vdev = NULL;
+	int fd;
+	int rval;
+
+	rval = parse_param(mt, p, string);
+	if (rval)
+		return rval;
+
+	entity = media_get_entity_by_name(mt->media, s);
+	if (!entity) {
+		fprintf(mt->log, "can't find entity \"%s\"\n", s);
+		return -ENOENT;
+	}
+
+	node = media_entity_get_devname(entity);
+	if (!node) {
+		fprintf(mt->log, "can't find device node for entity\n");
+		return -ENOENT;
+	}
+
+	source_fname = rindex(node, '/');
+	if (n)
+		source_fname = n;
+	else if (source_fname)
+		source_fname++;
+	else
+		source_fname = node;
+#define SUFFIX		".bin"
+	buf_fname = malloc(strlen(source_fname) + 1 /* \0 */
+			   + 2 /* - * 2 */
+			   + 20 /* index and plane */
+			   + strlen(SUFFIX));
+	if (!buf_fname)
+		return -ENOMEM;
+
+	sprintf(buf_fname, "%s-#" SUFFIX, source_fname);
+
+	fd = open(node, O_RDWR | O_NONBLOCK);
+	if (fd == -1) {
+		rval = -errno;
+		goto err_free;
+	}
+
+	rval = fstat(fd, &stat);
+	if (rval == -1) {
+		rval = -errno;
+		goto err_close;
+	}
+
+	list_for_each_name(&mt->vdev_names, name) {
+		struct v4l2_device *__vdev =
+			container_of(name, struct v4l2_device, name);
+
+		if (__vdev->dev == stat.st_rdev) {
+			rval = -EEXIST;
+			goto err_close;
+		}
+	}
+
+	vdev = calloc(1, sizeof(*vdev));
+	if (!vdev) {
+		rval = -ENOMEM;
+		goto err_close;
+	}
+
+	if (n) {
+		rval = name_init(&mt->vdev_names, &vdev->name, fd, n);
+		if (rval)
+			goto err_close;
+	}
+
+	vdev->fd = fd;
+	vdev->buf_fname = buf_fname;
+	vdev->entity = entity;
+	vdev->dev = stat.st_rdev;
+
+	fprintf(mt->log, "event=return which=\"v4l open\" dev=\"%s\" name=\"%s\" fd=%d node=%u.%u\n",
+		s, n, fd, major(stat.st_rdev), minor(stat.st_rdev));
+
+	return 0;
+
+err_close:
+	free(vdev);
+	close(fd);
+
+err_free:
+	free(buf_fname);
+
+	return rval;
+}
+
+static void v4l2_close(struct media_text *mt, struct v4l2_device *vdev)
+{
+	v4l2_reqbufs_zero(mt, vdev);
+	close(vdev->fd);
+	name_cleanup(&vdev->name);
+	free(vdev);
+}
+
+static int parse_v4l2_close(struct media_text *mt, char *string, bool help)
+{
+	struct v4l2_device *vdev;
+	struct param p[] = {
+		{ "vdev", PARAM_TYPE_V4L2_DEVICE, &vdev },
+		{ 0 },
+	};
+	int rval;
+
+	rval = parse_param(mt, p, string);
+	if (rval)
+		return rval;
+
+	v4l2_close(mt, vdev);
+
+	return 0;
+}
+
+static int parse_verbose(struct media_text *mt, char *string, bool help)
+{
+	mt->verbose = !strcasestr(string, "true") || !strstr(string, "1");
+
+	return 0;
+}
+
+static const struct parser v4l2_parsers[] = {
+	{ "ctrl", parse_v4l2_ctrl, 0, "set V4L2 control" },
+	{ "subdev-fmt", parse_v4l2_subdev_fmt, 0, "set sub-device format" },
+	{ "reqbufs", parse_v4l2_reqbufs, 0, "request buffers\n\narguments:\nfd\ntype [CAPTURE|CAPTURE_MPLANE]\ncount\nmemory [USERPTR|MMAP]" },
+	{ "fmt", parse_v4l2_set_format, 0, "set pixel format\n\narguments:\nfd\ntype [CAPTURE|CAPTURE_MPLANE]\nwidth\nheight\npixelformat\nbytesperline\n" },
+	{ "qbuf", parse_v4l2_qbuf, 0, "queue a buffer\n\narguments:\nfd\nindex (optional)\ncount (optional)\nauto-qbuf=[true|false] (optional)" },
+	{ "prepare-buf", parse_v4l2_prepare_buf, 0, "prepare a buffer\n\narguments:\nfd\nindex (optional)\ncount (optional)\nauto-qbuf=[true|false] (optional)\nreq" },
+	{ "write", parse_v4l2_write, 0, "write buffer contents to a file\n\narguments:\nfd\nfname (# will be replaced by sequence)\nauto-write=[true|false] (optional)" },
+	{ "streamon", parse_v4l2_streamon, 0, "start streaming\n\narguments:\nfd\ntype" },
+	{ "streamoff", parse_v4l2_streamoff, 0, "stop streaming\n\narguments:\nfd\ntype" },
+	{ "open", parse_v4l2_open, 0, "open a video node\n\narguments:\nentity\nname --- name of the device; vdev for other commands" },
+	{ "close", parse_v4l2_close, 0, "close a video node\n\narguments:\nfile desriptor" },
+	{ "verbose", parse_verbose, 0, "set verbose flag\n\narguments:\ntrue|false" },
+	{ 0 }
+};
+
+static int parse_v4l2(struct media_text *mt, char *string, bool help)
+{
+	return parse(mt, v4l2_parsers, string, help);
+}
+
+static int parse_media_link_reset(struct media_text *mt, char *string,
+				  bool help)
+{
+	media_dbg(mt->media, "Resetting links\n");
+	return media_reset_links(mt->media);
+}
+
+static int parse_media_link_setup(struct media_text *mt,
+				  char *string,
+				  bool help)
+{
+	media_dbg(mt->media, "Setting up links: %s\n", string);
+	return media_parse_setup_links(mt->media, string);
+}
+
+static char *media_req_cmd[] = {
+	"ALLOC",
+	"DELETE",
+	"APPLY",
+	"QUEUE",
+};
+
+static int media_req_ioctl(struct media_text *mt, struct mt_request *mtr,
+			   uint32_t cmd)
+{
+	uint32_t id = mtr ? mtr->name.id : 0;
+	struct media_request_cmd mr = {
+		.cmd = cmd,
+		.request = id,
+		.flags = MEDIA_REQ_FL_COMPLETE_EVENT,
+	};
+	int rval;
+
+	assert(!mtr == (cmd == MEDIA_REQ_CMD_ALLOC));
+
+	rval = ioctl(*(int *)mt->media, MEDIA_IOC_REQUEST_CMD, &mr);
+	if (rval == -1) {
+		rval = -errno;
+		if (mt->verbose)
+			fprintf(mt->log,
+				"request %u (%s) command %s failed (%s)\n",
+				id, mtr ? mtr->name.str : NULL,
+				(cmd < array_length(media_req_cmd))
+				? media_req_cmd[cmd]
+				: "INVALID", strerror(-rval));
+		return rval;
+	}
+
+	return (cmd == MEDIA_REQ_CMD_ALLOC) ? mr.request : 0;
+}
+
+static char* media_event_type[] = {
+	"",
+	"REQUEST_COMPLETE",
+};
+
+static int media_dqevent(struct media_text *mt)
+{
+	struct media_event ev = { 0 };
+	struct mt_request *mtr;
+	int rval;
+
+	rval = ioctl(*(int *)mt->media, MEDIA_IOC_DQEVENT, &ev);
+	if (rval == -1) {
+		rval = -errno;
+		fprintf(mt->log, "error dequeueing media event %d\n", rval);
+		return rval;
+	}
+
+	mt->requests_queued--;
+
+	mtr = request_find_by_id(mt, ev.req_complete.id);
+
+	fprintf(mt->log, "event=dqevent type=%s seq=%u req=%s req-id=%u\n",
+		ev.type < ARRAY_SIZE(media_event_type)
+		? media_event_type[ev.type] : "INVALID", ev.sequence,
+		mtr->name.str, mtr->name.id);
+
+	request_put(mtr);
+
+	return 0;
+}
+
+static int parse_media_req_create(struct media_text *mt, char *string,
+				  bool help)
+{
+	char *req_name;
+	struct param p[] = {
+		{ "req", PARAM_TYPE_STRING, &req_name },
+		{ 0 },
+	};
+	struct mt_request *mtr;
+	int rval;
+
+	rval = parse_param(mt, p, string);
+	if (rval)
+		return rval;
+
+	if (name_find(&mt->request_names, req_name))
+		return -EEXIST;
+
+	mtr = calloc(1, sizeof(*mtr));
+	if (!mtr)
+		return -ENOMEM;
+
+	rval = media_req_ioctl(mt, NULL, MEDIA_REQ_CMD_ALLOC);
+	if (rval < 0)
+		goto out_free_mtr;
+
+	rval = name_init(&mt->request_names, &mtr->name, rval, req_name);
+	if (rval)
+		goto out_req_release;
+
+	mtr->refcount = 0;
+
+	return 0;
+
+out_req_release:
+	media_req_ioctl(mt, mtr, MEDIA_REQ_CMD_DELETE);
+
+out_free_mtr:
+	free(mtr);
+
+	return rval;
+}
+
+static int parse_media_req_list(struct media_text *mt, char *string,
+				bool help)
+{
+	struct name *name;
+
+	list_for_each_name(&mt->request_names, name) {
+		struct mt_request *mr =
+			container_of(name, struct mt_request, name);
+
+		fprintf(mt->log, "request %u, name %s\n",
+			mr->name.id, mr->name.str);
+	}
+
+	return 0;
+}
+
+static int parse_media_req_release(struct media_text *mt, char *string,
+				   bool help)
+{
+	struct mt_request *mtr;
+	struct param p[] = {
+		{ "req", PARAM_TYPE_MEDIA_REQ, &mtr },
+		{ 0 },
+	};
+	int rval;
+
+	rval = parse_param(mt, p, string);
+	if (rval)
+		return rval;
+
+	/* FIXME: reference counts */
+	rval = media_req_ioctl(mt, mtr, MEDIA_REQ_CMD_DELETE);
+	request_put(mtr);
+
+	name_cleanup(&mtr->name);
+
+	return 0;
+}
+
+static int media_req_queue_apply(struct media_text *mt, char *string,
+				 uint32_t cmd)
+{
+	struct mt_request *mtr;
+	struct param p[] = {
+		{ "req", PARAM_TYPE_MEDIA_REQ, &mtr },
+		{ 0 },
+	};
+	int rval;
+
+	rval = parse_param(mt, p, string);
+	if (rval)
+		return rval;
+
+	rval = media_req_ioctl(mt, mtr, cmd);
+	if (rval)
+		return rval;
+
+	mt->requests_queued++;
+	request_get(mtr);
+
+	return 0;
+}
+
+static int parse_media_req_queue(struct media_text *mt, char *string,
+				 bool help)
+{
+	return media_req_queue_apply(mt, string, MEDIA_REQ_CMD_QUEUE);
+}
+
+static int parse_media_req_apply(struct media_text *mt, char *string,
+				 bool help)
+{
+	return media_req_queue_apply(mt, string, MEDIA_REQ_CMD_APPLY);
+}
+
+static const struct parser media_parsers[] = {
+	{ "link-reset", parse_media_link_reset, FLAG_ARGS_NONE, "reset all links" },
+	{ "link-setup", parse_media_link_setup, 0, "enable or disable a link" },
+	{ "req-create", parse_media_req_create, 0, "create media request" },
+	{ "req-list", parse_media_req_list, FLAG_ARGS_NONE, "list media requests" },
+	{ "req-release", parse_media_req_release, 0, "release media request" },
+	{ "req-queue", parse_media_req_queue, 0, "queue media request" },
+	{ "req-apply", parse_media_req_apply, 0, "apply media request" },
+	{ 0 }
+};
+
+static int parse_media(struct media_text *mt,
+		       char *string, bool help)
+{
+	return parse(mt, media_parsers, string, help);
+}
+
+static int parse_help(struct media_text *mt,
+		      char *string, bool help);
+
+static int file_reopen(struct media_text *mt, FILE **file, char *fname)
+{
+	FILE *log;
+
+	log = fopen(fname, "w");
+	if (!log) {
+		fprintf(mt->log, "can't fopen \"%s\"\n", fname);
+		return -EINVAL;
+	}
+
+	setvbuf(log, NULL, _IONBF, 0);
+
+	if (*file != stderr)
+		fclose(*file);
+	*file = log;
+
+	return 0;
+}
+
+static int parse_log(struct media_text *mt,
+		      char *string, bool help)
+{
+	char *fname;
+	struct param p[] = {
+		{ "fname", PARAM_TYPE_STRING, &fname },
+		{ 0 },
+	};
+	int rval;
+
+	rval = parse_param(mt, p, string);
+	if (rval)
+		return rval;
+
+	return file_reopen(mt, &mt->log, fname);
+}
+
+static int parse_quit(struct media_text *mt, char *string, bool help)
+{
+	mt->quit = true;
+
+	return 0;
+}
+
+static const struct parser parsers[] = {
+	{ "v4l", parse_v4l2, FLAG_MENU, "V4L2", },
+	{ "media", parse_media, FLAG_MENU, "Media controller", },
+	{ "help", parse_help, FLAG_ARGS_OPTIONAL, "help!", },
+	{ "log", parse_log, 0, "log errors to a file\n\narguments:\nfname\n", },
+	{ "quit", parse_quit, FLAG_ARGS_OPTIONAL, "quit\n", },
+	{ 0 }
+};
+
+static int parse_help(struct media_text *mt,
+		      char *string, bool help)
+{
+	if (!string) {
+		fprintf(mt->log, "help topics\n");
+		show_help(mt, parsers);
+		return 0;
+	}
+
+	return parse(mt, parsers, string, true);
+}
+
+int mediatext_parse(struct media_text *mt, char *string)
+{
+	return parse(mt, parsers, string, false);
+}
+
+static int mediatext_read(struct media_text *mt, char *buf, size_t bufsize,
+			  size_t *pos, int fd)
+{
+	size_t len = read(fd, buf + *pos, bufsize - *pos - 1);
+	unsigned int i;
+	bool eof = !len;
+	int rval;
+
+	if (len == -1)
+		return -errno;
+
+	if (eof) {
+		mediatext_parse(mt, buf);
+		*buf = 0;
+		*pos = 0;
+		return 0;
+	}
+
+	buf[*pos + len] = 0;
+
+next:
+	for (i = *pos ? *pos - 1 : 0; i < *pos + len; i++) {
+
+		if (buf[i] == '\\' && i < *pos + len + 1
+		    && buf[i + 1] == '\n') {
+			len -= 2;
+			memmove(buf + i, buf + i + 2, len - i + *pos);
+			i--;
+			continue;
+		}
+		/*
+		 * Split input into lines, and handle the last
+		 * line before eof as well.
+		 */
+		if (buf[i] != '\0' && buf[i] != '\n' && !eof)
+			continue;
+
+		buf[i] = '\0';
+
+		rval = mediatext_parse(mt, buf);
+		if (rval) {
+			unsigned int j;
+
+			for (j = 0; j < i; j++)
+				if (!buf[j])
+					buf[j] = ' ';
+
+			fprintf(mt->log, "event=error error=\"%s\" command=\"%s\"\n",
+				strerror(-rval), buf);
+		}
+
+		len -= i - *pos + 1;
+		*pos = 0;
+		*buf = 0;
+		if (len)
+			memmove(buf, buf + i + 1, len);
+
+		goto next;
+	}
+
+	*pos = i;
+
+	return !eof;
+}
+
+int mediatext_poll(struct media_text *mt, int fd)
+{
+	char buf[4096];
+	size_t buf_pos = 0;
+	unsigned int poll_nfds = 0, poll_nfds_max = 0;
+	struct pollfd *fds = NULL;
+	int rval;
+
+	rval = fcntl(fd, F_SETFL, O_NONBLOCK);
+	if (rval == -1) {
+		fprintf(mt->log, "fcntl\n");
+		return -errno;
+	}
+
+	rval = -1;
+
+	do {
+		struct name *name;
+		unsigned int i;
+
+		if (!rval)
+			return 0;
+
+		for (i = 1; i < poll_nfds; i++) {
+			if (!(fds[i].revents & POLLIN))
+				continue;
+
+			rval = v4l2_poll(mt, fds[i].fd, fds[i].revents);
+			if (rval < 0)
+				goto out_free;
+		}
+
+		if (fds && fds[0].revents & POLLIN) {
+			rval = mediatext_read(mt, buf, sizeof(buf),
+					      &buf_pos, fd);
+			switch (rval) {
+			case 0:
+				errno = 0;
+				/* Fall through */
+			case -1:
+				goto out_free;
+			}
+		}
+
+		if (fds && fds[poll_nfds - 1].revents & POLLPRI)
+			media_dqevent(mt);
+
+		/* Get number of file descriptors to poll */
+		poll_nfds = 1;
+
+		list_for_each_name(&mt->vdev_names, name)
+			poll_nfds++;
+
+		if (mt->requests_queued)
+			poll_nfds++;
+
+		/* Reallocate space required for poll file descriptors */
+		if (poll_nfds > poll_nfds_max) {
+			fds = realloc(fds, poll_nfds * sizeof(*fds));
+			if (!fds) {
+				rval = -ENOMEM;
+				goto out_free;
+			}
+			poll_nfds_max = poll_nfds;
+		}
+
+		/* Fill in poll file descriptors */
+		fds[0].fd = fd;
+		fds[0].events = POLLIN;
+
+		poll_nfds = 1;
+
+		list_for_each_name(&mt->vdev_names, name) {
+			struct v4l2_device *vdev =
+				container_of(name, struct v4l2_device, name);
+
+			if (!vdev->streaming || !vdev->queued)
+				continue;
+
+			fds[poll_nfds].fd = vdev->fd;
+			fds[poll_nfds].events =
+				is_buf_type_capture(vdev->type)
+				? POLLIN : POLLOUT;
+			poll_nfds++;
+		}
+
+		if (mt->requests_queued) {
+			fds[poll_nfds].fd = *(int *)mt->media;
+			fds[poll_nfds].events = POLLPRI;
+			poll_nfds++;
+		}
+
+	} while (!mt->quit && (rval = poll(fds, poll_nfds, -1)) != -1);
+
+out_free:
+	free(fds);
+
+	return rval ? -errno : 0;
+}
diff --git a/utils/media-ctl/mediatext.h b/utils/media-ctl/mediatext.h
new file mode 100644
index 0000000..53167e8
--- /dev/null
+++ b/utils/media-ctl/mediatext.h
@@ -0,0 +1,33 @@
+/*
+ * Media controller text-based configuration library
+ *
+ * Copyright (C) 2013--2016 Intel Corporation
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
+struct media_text;
+
+struct media_text *mediatext_init(struct media_device *media);
+void mediatext_cleanup(struct media_text *mt);
+int mediatext_poll(struct media_text *mt, int fd);
+int mediatext_parse(struct media_text *mt, char *string);
+
+#endif /* __MEDIATEXT_H__ */
-- 
2.7.4

