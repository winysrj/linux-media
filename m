Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga06.intel.com ([134.134.136.31]:41974 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751277AbeDEK7O (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 5 Apr 2018 06:59:14 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: tfiga@google.com, hverkuil@xs4all.nl
Subject: [v4l-utils RFC 5/6] mediatext: Add library
Date: Thu,  5 Apr 2018 13:58:18 +0300
Message-Id: <1522925899-14073-6-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1522925899-14073-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1522925899-14073-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

libmediatext is a helper library for converting configurations (Media
controller links, V4L2 controls and V4L2 sub-device media bus formats and
selections) from text-based form into IOCTLs.

libmediatext depends on libv4l2subdev and libmediactl.

The patch includes a test program, mediatext-test, that can be used to
write tests in interpreted languages such as shell scripts.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Teemu Tuominen <teemu.tuominen@intel.com>
---
 libmediatext.pc.in                 |   10 +
 utils/media-ctl/Makefile.am        |   11 +-
 utils/media-ctl/libmediatext.pc.in |   10 +
 utils/media-ctl/mediatext-test.c   |  127 +++
 utils/media-ctl/mediatext.c        | 2176 ++++++++++++++++++++++++++++++++++++
 utils/media-ctl/mediatext.h        |   33 +
 6 files changed, 2365 insertions(+), 2 deletions(-)
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
index 8fe653d..ddbc453 100644
--- a/utils/media-ctl/Makefile.am
+++ b/utils/media-ctl/Makefile.am
@@ -1,4 +1,4 @@
-noinst_LTLIBRARIES = libmediactl.la libv4l2subdev.la
+noinst_LTLIBRARIES = libmediactl.la libv4l2subdev.la libmediatext.la
 
 libmediactl_la_SOURCES = libmediactl.c mediactl-priv.h
 libmediactl_la_CFLAGS = -static $(LIBUDEV_CFLAGS)
@@ -26,9 +26,16 @@ libv4l2subdev_la_LIBADD = libmediactl.la
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
+mediatext_LDFLAGS = $(STATIC_LDFLAGS)
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
index 0000000..77e8dc7
--- /dev/null
+++ b/utils/media-ctl/mediatext-test.c
@@ -0,0 +1,127 @@
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
+	{ "coproc", 0, 0, 'c', },
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
+	while ((opt = getopt_long(argc, argv, "cd:f:hv", opts, NULL)) != -1) {
+		switch (opt) {
+		case 'd':
+			devname = optarg;
+			break;
+		case 'c':
+			fprintf(stdout, "%s",
+				"eval_line() {"
+				"	while [ $# -ne 0 ]; do"
+				"		local name=${1%=*};"
+				"		local value=${1#*=};"
+				"		p[$name]=\"$value\";"
+				"		shift;"
+				"	done;"
+				"}\n");
+			fflush(stdout);
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
index 0000000..b3b26a5
--- /dev/null
+++ b/utils/media-ctl/mediatext.c
@@ -0,0 +1,2176 @@
+/*
+ * Media controller text-based configuration library
+ *
+ * Copyright (C) 2013--2018 Intel Corporation
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
+#include <time.h>
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
+	bool queued;
+};
+
+struct v4l2_queue {
+	struct mt_buf *bufs;
+	unsigned int nbufs;
+	unsigned int queued;
+	uint32_t memory;
+	unsigned int type;
+	bool auto_rw;
+	bool auto_qbuf;
+	char *buf_fname;
+	struct timeval ts;
+	struct v4l2_format fmt;
+	struct v4l2_device *vdev;
+	bool streaming;
+};
+
+#define BUF_TYPES	(V4L2_BUF_TYPE_META_CAPTURE + 1)
+
+struct v4l2_device {
+	struct name name;
+	int fd;
+	dev_t dev;
+	struct v4l2_queue q[BUF_TYPES];
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
+static const char *buf_types[] = {
+	"",
+	"VIDEO_CAPTURE",
+	"VIDEO_OUTPUT",
+	"VIDEO_OVERLAY",
+	"VBI_CAPTURE",
+	"VBI_OUTPUT",
+	"SLICED_VBI_CAPTURE",
+	"SLICED_VBI_OUTPUT",
+	"VIDEO_OUTPUT_OVERLAY",
+	"VIDEO_CAPTURE_MPLANE",
+	"VIDEO_OUTPUT_MPLANE",
+	"SDR_CAPTURE",
+	"SDR_OUTPUT",
+	"META_CAPTURE",
+};
+
+static int get_buf_type(struct media_text *mt, char *s)
+{
+	unsigned int i;
+
+	for (i = 0; i < ARRAY_SIZE(buf_types); i++)
+		if (!strcmp(s, buf_types[i]))
+			return i;
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
+static void request_get(struct media_text *mt, struct mt_request *mtr)
+{
+	if (!mtr)
+		return;
+
+	mtr->refcount++;
+}
+
+static int request_close(struct mt_request *mtr)
+{
+	int fd;
+
+	name_cleanup(&mtr->name);
+	fd = mtr->name.id;
+	free(mtr);
+
+	close(fd);
+
+	return 0;
+}
+
+static void request_put(struct media_text *mt, struct mt_request *mtr)
+{
+	if (!mtr)
+		return;
+
+	if (!--mtr->refcount)
+		request_close(mtr);
+}
+
+static struct mt_request *request_find(struct media_text *mt, char *str)
+{
+	struct name *name;
+
+	name = name_find(&mt->request_names, str);
+	if (!name)
+		return NULL;
+
+	return container_of(name, struct mt_request, name);
+}
+
+static struct mt_request *request_find_by_fd(struct media_text *mt, int fd)
+{
+	struct name *name;
+
+	name = name_find_by_id(&mt->request_names, fd);
+
+	if (!name)
+		return NULL;
+
+	return container_of(name, struct mt_request, name);
+}
+
+static int request_poll(struct media_text *mt, int fd, short revents)
+{
+	struct mt_request *mtr;
+
+	mtr = request_find_by_fd(mt, fd);
+	if (!mtr) {
+		fprintf(mt->log, "invalid fd %d\n", fd);
+		return -EINVAL;
+	}
+
+	if (revents & POLLPRI) {
+		char buf[128];
+		int rval;
+
+		mtr->queued = false;
+		strncpy(buf, mtr->name.str, sizeof(buf));
+		request_put(mt, mtr);
+		fprintf(mt->log, "event=request-complete req=%s rval=%d\n",
+			buf, rval);
+		return 0;
+	}
+
+	fprintf(mt->log, "no events on fd %d\n", fd);
+
+	return 0;
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
+			  "Failed setting control 0x8.8x: \"%s\" %d to value %"
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
+	case V4L2_BUF_TYPE_VBI_CAPTURE:
+	case V4L2_BUF_TYPE_SLICED_VBI_CAPTURE:
+	case V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE:
+	case V4L2_BUF_TYPE_SDR_CAPTURE:
+	case V4L2_BUF_TYPE_META_CAPTURE:
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
+	case V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE:
+		return true;
+	default:
+		return false;
+	}
+}
+
+static int v4l2_reqbufs_zero(struct media_text *mt, struct v4l2_queue *q)
+{
+	struct v4l2_requestbuffers rb = { .type = q->type,
+					  .count = 0,
+					  .memory = q->memory };
+	unsigned int i;
+	int rval;
+
+	if (q->streaming) {
+		fprintf(mt->log, "still streaming\n");
+		return -EBUSY;
+	}
+
+	for (i = 0; i < q->nbufs; i++) {
+		struct mt_buf *mb = &q->bufs[i];
+		unsigned int j;
+
+		for (j = 0; j < (is_buf_type_mplane(q->type) ?
+				 mb->vb.length : 1); j++) {
+
+			if (!mb->plane_ptrs[j])
+				continue;
+
+			munmap(mb->plane_ptrs[j], is_buf_type_mplane(q->type) ?
+			       mb->planes[j].length : mb->vb.length);
+		}
+	}
+
+	rval = ioctl(q->vdev->fd, VIDIOC_REQBUFS, &rb);
+	if (rval == -1)
+		return -errno;
+
+	free(q->bufs);
+	q->bufs = NULL;
+	q->nbufs = 0;
+
+	return 0;
+}
+
+static int v4l2_querybuf(struct v4l2_queue *q, unsigned int index)
+{
+	struct v4l2_buffer *vb = &q->bufs[index].vb;
+
+	vb->memory = q->memory;
+	vb->type = q->type;
+	vb->index = index;
+	vb->m.planes = q->bufs[index].planes;
+	vb->length = q->fmt.fmt.pix_mp.num_planes;
+
+	return ioctl(q->vdev->fd, VIDIOC_QUERYBUF, vb) == -1 ? -errno : 0;
+}
+
+static int parse_v4l2_reqbufs(struct media_text *mt, char *string, bool help)
+{
+	struct v4l2_requestbuffers rb = { 0 };
+	struct v4l2_device *vdev;
+	struct v4l2_queue *q;
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
+		return v4l2_reqbufs_zero(mt, &vdev->q[rb.type]);
+
+	q = &vdev->q[rb.type];
+
+	if (q->nbufs) {
+		fprintf(mt->log, "buffers allocated already\n");
+		return -EINVAL;
+	}
+
+	q->bufs = calloc(rb.count, sizeof(*q->bufs));
+	if (!q->bufs)
+		return -ENOMEM;
+
+	rval = ioctl(vdev->fd, VIDIOC_REQBUFS, &rb);
+	if (rval == -1) {
+		rval = -errno;
+		goto out_release;
+	}
+
+	q->memory = rb.memory;
+	q->nbufs = rb.count;
+
+	for (i = 0; i < rb.count; i++) {
+		struct v4l2_buffer *vb = &q->bufs[i].vb;
+		struct v4l2_plane *planes = q->bufs[i].planes;
+		void **plane_ptrs = q->bufs[i].plane_ptrs;
+		unsigned int j;
+
+		rval = v4l2_querybuf(q, i);
+		if (rval) {
+			v4l2_reqbufs_zero(mt, q);
+			return rval;
+		}
+
+		for (j = 0; j < (is_buf_type_mplane(rb.type) ?
+				 vb->length : 1); j++) {
+			plane_ptrs[j] = mmap(
+				NULL, is_buf_type_mplane(rb.type) ?
+				planes[j].length : vb->length,
+				PROT_READ | PROT_WRITE, MAP_SHARED,
+				vdev->fd, is_buf_type_mplane(rb.type) ?
+				planes[j].m.mem_offset : vb->m.offset);
+
+			if (!plane_ptrs[j]) {
+				v4l2_reqbufs_zero(mt, q);
+				fprintf(mt->log, "failed to mmap %u/%u\n",
+					i, j);
+				return -ENOMEM;
+			}
+		}
+
+		vb->sequence = -1;
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
+	vdev->q[fmt.type].fmt = fmt;
+
+#ifndef v4l2_fourcc_conv
+#define v4l2_fourcc_conv "%c%c%c%c%s"
+#endif
+
+#ifndef v4l2_fourcc_to_conv
+#define v4l2_fourcc_to_conv(fourcc)					\
+	(fourcc) & 0x7f, ((fourcc) >> 8) & 0x7f, ((fourcc) >> 16) & 0x7f, \
+	((fourcc) >> 24) & 0x7f, (fourcc) & (1 << 31) ? "-BE" : ""
+#endif
+
+	if (mt->verbose && !is_buf_type_mplane(fmt.type))
+		fprintf(mt->log, "%s: width %u, height %u, format "
+			v4l2_fourcc_conv ", bytesperline %u, sizeimage %u\n",
+			vdev->name.str, fmt.fmt.pix.width, fmt.fmt.pix.height,
+			v4l2_fourcc_to_conv(fmt.fmt.pix.pixelformat),
+			fmt.fmt.pix.bytesperline, fmt.fmt.pix.sizeimage);
+
+	return 0;
+}
+
+/* Get a buffer with oldest data to write to memory. */
+static struct mt_buf *oldest_seq_mb_data(struct v4l2_queue *q)
+{
+	struct mt_buf *best = NULL;
+	unsigned int i;
+
+	for (i = 0; i < q->nbufs; i++) {
+		struct mt_buf *this = &q->bufs[i];
+
+		if (this->vb.flags & (V4L2_BUF_FLAG_QUEUED |
+				      V4L2_BUF_FLAG_IN_REQUEST))
+			continue;
+
+		if (this->dirty != is_buf_type_capture(q->type))
+			continue;
+
+		if (!best ||
+		    (int)(best->vb.sequence - this->vb.sequence) > 0)
+			best = this;
+	}
+
+	return best;
+}
+
+/* Get a buffer, preferrably without dirty data for capture. */
+static struct mt_buf *oldest_seq_mb_buf(struct v4l2_queue *q)
+{
+	struct mt_buf *best = NULL;
+	unsigned int i;
+
+	for (i = 0; i < q->nbufs; i++) {
+		struct mt_buf *this = &q->bufs[i];
+
+		if (this->vb.flags & (V4L2_BUF_FLAG_QUEUED |
+				      V4L2_BUF_FLAG_IN_REQUEST))
+			continue;
+
+		if (best && this->dirty == is_buf_type_capture(q->type)
+		    && best->dirty != is_buf_type_capture(q->type))
+			continue;
+
+		if (!best ||
+		    (int)(best->vb.sequence - this->vb.sequence) > 0)
+			best = this;
+	}
+
+	return best;
+}
+
+static int do_read_write(struct media_text *mt, struct v4l2_queue *q,
+			 struct mt_buf *mb, char *fname)
+{
+	char __fname[strlen(fname) + 1 /* \0 */ + 20 /* buffer index + plane */];
+	char *pos = strchr(fname, '#');
+	char *ing = is_buf_type_capture(q->type) ? "writing" : "reading";
+	char *tofrom = is_buf_type_capture(q->type) ? "to" : "from";
+	unsigned int plane;
+	int fd;
+	int rval = 0;
+
+	if (!is_buf_type_capture(q->type)) {
+		struct timespec ts;
+
+		clock_gettime(CLOCK_MONOTONIC, &ts);
+		mb->vb.timestamp.tv_sec = ts.tv_sec;
+		mb->vb.timestamp.tv_usec = ts.tv_nsec / 1000;
+	}
+
+	if (!pos && is_buf_type_mplane(q->type))
+		pos = fname + strlen(fname);
+
+	for (plane = 0; plane < (is_buf_type_mplane(q->type)
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
+			fprintf(mt->log,
+				"%s: %s plane %u %s \"%s\", buffer type %s, index %u\n",
+				q->vdev->name.str, ing, plane, tofrom, plane_fname,
+				buf_types[q->type], mb->vb.index);
+
+		if (is_buf_type_capture(q->type))
+			fd = open(plane_fname, O_CREAT | O_WRONLY | O_TRUNC,
+				  S_IRUSR | S_IWUSR | S_IRGRP | S_IWGRP
+				  | S_IROTH | S_IWOTH);
+		else
+			fd = open(plane_fname, O_RDONLY);
+		if (fd == -1) {
+			rval = -errno;
+			fprintf(mt->log, "can't open \"%s\", \"%s\"\n",
+				plane_fname, strerror(errno));
+			return rval;
+		}
+
+		if (is_buf_type_capture(q->type)) {
+			rval = write(fd, mb->plane_ptrs[plane],
+				     is_buf_type_mplane(q->type) ?
+				     mb->planes[plane].length : mb->vb.length);
+		} else {
+			rval = read(fd, mb->plane_ptrs[plane],
+				    is_buf_type_mplane(q->type) ?
+				    mb->planes[plane].length : mb->vb.length);
+			if (is_buf_type_mplane(q->type))
+				mb->planes[plane].bytesused = q->fmt.fmt.pix_mp.plane_fmt[plane].sizeimage;
+			else
+				mb->vb.bytesused = q->fmt.fmt.pix.sizeimage;
+		}
+		if (rval == -1)
+			rval = -errno;
+		else
+			rval = 0;
+		close(fd);
+		if (rval < 0) {
+			fprintf(mt->log, "%s %u bytes failed\n",
+				ing, is_buf_type_mplane(q->type) ?
+				mb->planes[plane].length : mb->vb.length);
+			goto err;
+		}
+	}
+
+	mb->dirty = !is_buf_type_capture(q->type);
+
+err:
+	return rval;
+}
+
+static int __v4l2_prepare_queue_buf(struct media_text *mt, struct v4l2_queue *q,
+				    unsigned int index, struct mt_request *mtr,
+				    bool queue)
+{
+	int ioctlcmd = queue ? VIDIOC_QBUF : VIDIOC_PREPARE_BUF;
+	struct mt_buf *mb = &q->bufs[index];
+	int rval;
+
+	if (mtr) {
+		mb->vb.request_fd = mtr->name.id;
+		mb->vb.flags |= V4L2_BUF_FLAG_REQUEST_FD;
+	} else {
+		mb->vb.flags &= ~V4L2_BUF_FLAG_REQUEST_FD;
+	}
+
+	if (q->auto_rw && !is_buf_type_capture(q->type)) {
+		rval = do_read_write(mt, q, mb, q->buf_fname);
+		if (rval == -1)
+			return -errno;
+	}
+
+	if (mt->verbose)
+		fprintf(mt->log, "%s: %s %s buffer %u request %s\n",
+			q->vdev->name.str,
+			queue ? "queueing" : "preparing",
+			buf_types[q->type], index, mtr ? mtr->name.str : "nul");
+
+	rval = ioctl(q->vdev->fd, ioctlcmd, &mb->vb);
+	if (rval == -1) {
+		rval = errno;
+		fprintf(mt->log, "cannot queue buffer %u, error %d \"%s\"\n",
+			index, rval, strerror(rval));
+		return -rval;
+	}
+
+	request_get(mt, mtr);
+
+	q->queued++;
+
+	return 0;
+}
+
+static int v4l2_prepare_queue_buf(struct media_text *mt, char *string,
+				  bool queue)
+{
+	struct v4l2_device *vdev;
+	struct v4l2_queue *q;
+	uint32_t index = -1, count = 1, type;
+	struct mt_request *mtr = NULL;
+	struct arg a;
+	struct param p[] = {
+		{ "vdev", PARAM_TYPE_V4L2_DEVICE, &vdev },
+		{ "index", PARAM_TYPE_U32, &index, true },
+		{ "count", PARAM_TYPE_U32, &count, true },
+		{ "type", PARAM_TYPE_BUF_TYPE, &type },
+		{ "req", PARAM_TYPE_MEDIA_REQ, &mtr, true },
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
+	q = &vdev->q[type];
+	{
+		struct param p2[] = {
+			{ "auto-qbuf", PARAM_TYPE_BOOL, &q->auto_qbuf, true },
+			{ 0 },
+		};
+
+		rval = arg_param(mt, &a, p2);
+		if (rval)
+			return rval;
+	}
+
+	if (mtr) {
+		if (q->auto_qbuf) {
+			fprintf(mt->log,
+				"auto-qbuf not possible with requests\n");
+			return -EINVAL;
+		}
+	}
+
+	if (index == -1) {
+		struct mt_buf *mb = oldest_seq_mb_buf(q);
+
+		if (!mb) {
+			fprintf(mt->log,
+				"no free buffers available\n");
+			return -EINVAL;
+		}
+
+		index = mb->vb.index;
+	}
+
+	if (index != -1) {
+		if (count != 1) {
+			fprintf(mt->log, "can't set both index and count\n");
+			return -EINVAL;
+		}
+
+		__v4l2_prepare_queue_buf(mt, q, index, mtr, queue);
+
+		return 0;
+	}
+
+	for (index = 0; count && index < q->nbufs;
+	     index++) {
+		if (q->bufs[index].vb.flags & V4L2_BUF_FLAG_QUEUED)
+			continue;
+
+		__v4l2_prepare_queue_buf(mt, q, index, NULL, queue);
+
+		count--;
+	}
+	if (index == q->nbufs && count) {
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
+static struct mt_buf *mt_buf_seq(struct v4l2_queue *q, uint32_t sequence)
+{
+	unsigned int i;
+
+	for (i = 0; i < q->nbufs; i++) {
+		struct mt_buf *this = &q->bufs[i];
+
+		if (this->vb.flags & (V4L2_BUF_FLAG_QUEUED |
+				      V4L2_BUF_FLAG_IN_REQUEST))
+			continue;
+
+		if (this->dirty != is_buf_type_capture(q->type))
+			continue;
+
+		if (this->vb.sequence == sequence)
+			return this;
+	}
+
+	return NULL;
+}
+
+static int parse_v4l2_read_write(struct media_text *mt, char *string, bool help)
+{
+	struct v4l2_device *vdev;
+	struct v4l2_queue *q;
+	char *fname = NULL;
+	uint32_t sequence = -1, type;
+	struct param p[] = {
+		{ "vdev", PARAM_TYPE_V4L2_DEVICE, &vdev },
+		{ "type", PARAM_TYPE_BUF_TYPE, &type },
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
+	q = &vdev->q[type];
+
+	{
+		struct param p2[] = {
+			{ "auto", PARAM_TYPE_BOOL, &q->auto_rw, true },
+			{ 0 },
+		};
+		rval = arg_param(mt, &a, p2);
+		if (rval)
+			return rval;
+	}
+
+	if (fname) {
+		free(q->buf_fname);
+		q->buf_fname = strdup(fname);
+		if (!q->buf_fname) {
+			q->auto_rw = false;
+			return -ENOMEM;
+		}
+	} else {
+		fname = q->buf_fname;
+	}
+	if (!fname)
+		return -EINVAL;
+
+	if (q->auto_rw)
+		return 0;
+
+	mb = mt_buf_seq(q, sequence);
+	if (!mb)
+		mb = oldest_seq_mb_data(q);
+	if (!mb)
+		return -ENODATA;
+
+	return do_read_write(mt, q, mb, fname);
+}
+
+static int v4l2_dqbuf(struct media_text *mt, struct v4l2_queue *q)
+{
+	struct v4l2_device *vdev = q->vdev;
+	struct v4l2_plane planes[VIDEO_MAX_PLANES];
+	struct v4l2_buffer vb = {
+		.type = q->type,
+		.memory = q->memory,
+	};
+	int rval;
+
+	if (is_buf_type_mplane(q->type)) {
+		vb.length = VIDEO_MAX_PLANES;
+		vb.m.planes = planes;
+	}
+
+	rval = ioctl(vdev->fd, VIDIOC_DQBUF, &vb);
+	if (rval == -1) {
+		rval = -errno;
+		if (rval != -EAGAIN)
+			fprintf(mt->log, "dqbuf failed, %s\n", strerror(errno));
+		return rval;
+	}
+
+	q->queued--;
+
+	q->bufs[vb.index].vb = vb;
+	q->bufs[vb.index].dirty = is_buf_type_capture(q->type);
+
+	{
+		float fps = vb.timestamp.tv_sec || vb.timestamp.tv_usec ?
+			1000000. / (float)(
+				(vb.timestamp.tv_sec - q->ts.tv_sec) * 1000000 +
+				vb.timestamp.tv_usec - q->ts.tv_usec) : 0.;
+		struct mt_request *mtr = request_find_by_fd(mt, vb.request_fd);
+
+		fprintf(mt->log,
+			"event=dqbuf req=%s entity=\"%s\" vdev=%s type=%s index=%u seq=%u ts=%lu.%6.6lu fps=%.3f\n",
+			mtr ? mtr->name.str : "nul",
+			media_entity_get_info(vdev->entity)->name,
+			vdev->name.str, buf_types[q->type], vb.index, vb.sequence,
+			(unsigned long)vb.timestamp.tv_sec,
+			(unsigned long)vb.timestamp.tv_usec, fps);
+
+		request_put(mt, mtr);
+	}
+
+	q->ts = vb.timestamp;
+
+	if (q->auto_rw && is_buf_type_capture(q->type))
+		do_read_write(mt, q, &q->bufs[vb.index], q->buf_fname);
+
+	if (q->auto_qbuf) {
+		if (q->auto_rw && !is_buf_type_capture(q->type))
+			do_read_write(mt, q, &q->bufs[vb.index], q->buf_fname);
+		rval = ioctl(vdev->fd, VIDIOC_QBUF, &vb);
+		if (rval == -1) {
+			fprintf(mt->log, "event=error error=\"queueing buffer %u failed \"%s\"\"\n",
+				vb.index, strerror(errno));
+			return 0;
+		}
+		q->queued--;
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
+	if (revents & (POLLIN | POLLOUT)) {
+		unsigned int i;
+		bool has_buf = false;
+
+		for (i = 0; i < BUF_TYPES; i++)
+			if (vdev->q[i].streaming &&
+			    !v4l2_dqbuf(mt, &vdev->q[i]))
+				has_buf = true;
+
+		if (has_buf)
+			return 0;
+	}
+
+	fprintf(mt->log, "no events on fd %d\n", fd);
+
+	return 0;
+}
+
+static int set_stream(struct media_text *mt, char *string, bool enable)
+{
+	struct v4l2_device *vdev;
+	struct v4l2_queue *q;
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
+	q = &vdev->q[type];
+
+	if (enable) {
+		q->ts.tv_sec = q->ts.tv_usec = 0;
+		rval = ioctl(vdev->fd, VIDIOC_STREAMON, &type);
+	} else {
+		unsigned int i;
+
+		rval = ioctl(vdev->fd, VIDIOC_STREAMOFF, &type);
+
+		for (i = 0; i < q->nbufs; i++)
+			v4l2_querybuf(q, i);
+
+		q->queued = 0;
+	}
+
+	if (rval)
+		return -errno;
+
+	q->streaming = enable;
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
+	char *s;
+	char *n = NULL;
+	struct param p[] = {
+		{ "entity", PARAM_TYPE_STRING, &s },
+		{ "name", PARAM_TYPE_STRING, &n, true },
+		{ 0 },
+	};
+	struct v4l2_device *vdev = NULL;
+	unsigned int i;
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
+
+	fd = open(node, O_RDWR | O_NONBLOCK);
+	if (fd == -1) {
+		return -errno;
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
+	vdev->entity = entity;
+	vdev->dev = stat.st_rdev;
+
+	for (i = 0; i < BUF_TYPES; i++) {
+		struct v4l2_queue *q = &vdev->q[i];
+
+		q->vdev = vdev;
+		q->type = i;
+
+#define SUFFIX	".bin"
+		q->buf_fname = malloc(strlen(source_fname) + 1 /* \0 */
+				      + 3 /* - * 3 */
+				      + 2 /* [type] */
+				      + 20 /* index and plane */
+				      + strlen(SUFFIX));
+		if (!q->buf_fname)
+			goto err_close;
+
+		sprintf(q->buf_fname, "%s-%s-#" SUFFIX, source_fname, buf_types[i]);
+	}
+
+	fprintf(mt->log, "event=return which=\"v4l open\" dev=\"%s\" name=\"%s\" fd=%d node=%u.%u\n",
+		s, n, fd, major(stat.st_rdev), minor(stat.st_rdev));
+
+	return 0;
+
+err_close:
+	for (i = 0; i < BUF_TYPES; i++) {
+		struct v4l2_queue *q = &vdev->q[i];
+
+		free(q->buf_fname);
+	}
+
+	free(vdev);
+	close(fd);
+
+	return rval;
+}
+
+static void v4l2_close(struct media_text *mt, struct v4l2_device *vdev)
+{
+	unsigned int i;
+
+	for (i = 0; i < BUF_TYPES; i++)
+		v4l2_reqbufs_zero(mt, &vdev->q[i]);
+
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
+#define HELP_TYPES "type [CAPTURE|CAPTURE_MPLANE]\n"
+
+static const struct parser v4l2_parsers[] = {
+	{ "ctrl", parse_v4l2_ctrl, 0, "set V4L2 control" },
+	{ "subdev-fmt", parse_v4l2_subdev_fmt, 0, "set sub-device format" },
+	{ "reqbufs", parse_v4l2_reqbufs, 0, "request buffers\n\narguments:\nfd\n" HELP_TYPES "count\nmemory [USERPTR|MMAP]" },
+	{ "fmt", parse_v4l2_set_format, 0, "set pixel format\n\narguments:\nfd\n" HELP_TYPES "width\nheight\npixelformat\nbytesperline\n" },
+	{ "qbuf", parse_v4l2_qbuf, 0, "queue a buffer\n\narguments:\nfd\n" HELP_TYPES "index (optional)\ncount (optional)\nauto-qbuf=[true|false] (optional)" },
+	{ "prepare-buf", parse_v4l2_prepare_buf, 0, "prepare a buffer\n\narguments:\nfd\n" HELP_TYPES "index (optional)\ncount (optional)\nauto-qbuf=[true|false] (optional)\nreq" },
+	{ "io", parse_v4l2_read_write, 0, "read or write buffer contents to a file\n\narguments:\nfd\n" HELP_TYPES "fname (# will be replaced by sequence)\nauto=[true|false] (optional)" },
+	{ "streamon", parse_v4l2_streamon, 0, "start streaming\n\narguments:\nfd\n" HELP_TYPES },
+	{ "streamoff", parse_v4l2_streamoff, 0, "stop streaming\n\narguments:\nfd\n" HELP_TYPES },
+	{ "open", parse_v4l2_open, 0, "open a video node\n\narguments:\nentity\nname --- name of the device; vdev for other commands" },
+	{ "close", parse_v4l2_close, 0, "close a video node\n\narguments:\nfile desriptor" },
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
+static int media_ioctl_req_alloc(struct media_text *mt, struct mt_request *mtr)
+{
+	struct media_request_alloc new = { 0 };
+	int rval;
+
+	rval = media_device_open(mt->media);
+	if (rval < 0)
+		return rval;
+
+	rval = ioctl(media_device_fd(mt->media), MEDIA_IOC_REQUEST_ALLOC,
+		     &new);
+	media_device_close(mt->media);
+	if (rval == -1) {
+		rval = -errno;
+		if (mt->verbose)
+			fprintf(mt->log, "cannot allocate request \"%s\"\n",
+				strerror(-rval));
+		return rval;
+	}
+
+	return new.fd;
+}
+
+static int media_ioctl_req_queue(struct media_text *mt, struct mt_request *mtr)
+{
+	int rval;
+
+	rval = ioctl((int)mtr->name.id, MEDIA_REQUEST_IOC_QUEUE);
+	if (rval == -1) {
+		rval = -errno;
+		if (mt->verbose)
+			fprintf(mt->log,
+				"queueing request %u \"%s\" failed \"%s\"\n",
+				mtr->name.id, mtr->name.str,
+				strerror(-rval));
+		return rval;
+	}
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
+	int fd, rval;
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
+	fd = rval = media_ioctl_req_alloc(mt, mtr);
+	if (rval < 0)
+		goto out_free_mtr;
+
+	rval = name_init(&mt->request_names, &mtr->name, fd, req_name);
+	if (rval)
+		goto out_fd_close;
+
+	mtr->refcount = 1;
+
+	return 0;
+
+out_fd_close:
+	close(fd);
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
+static int parse_media_req_close(struct media_text *mt, char *string,
+				 bool help)
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
+	return request_close(mtr);
+}
+
+static int parse_media_req_queue(struct media_text *mt, char *string,
+				 bool help)
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
+	rval = media_ioctl_req_queue(mt, mtr);
+	if (rval)
+		return rval;
+
+	mt->requests_queued++;
+	mtr->queued = true;
+
+	return 0;
+}
+
+static const struct parser media_parsers[] = {
+	{ "link-reset", parse_media_link_reset, FLAG_ARGS_NONE, "reset all links" },
+	{ "link-setup", parse_media_link_setup, 0, "enable or disable a link" },
+	{ "req-create", parse_media_req_create, 0, "create media request\n\nreq=requestname" },
+	{ "req-list", parse_media_req_list, FLAG_ARGS_NONE, "list media requests" },
+	{ "req-close", parse_media_req_close, 0, "close media request" },
+	{ "req-queue", parse_media_req_queue, 0, "queue media request" },
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
+static int parse_log(struct media_text *mt, char *string, bool help)
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
+	{ "verbose", parse_verbose, 0, "set verbose flag\n\narguments:\ntrue|false" },
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
+	unsigned int poll_nfds = 0, poll_v4l2_pos = 0, poll_nfds_max = 0;
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
+		for (i = 1; i < poll_v4l2_pos; i++) {
+			if (!(fds[i].revents & (POLLIN | POLLOUT)))
+				continue;
+
+			rval = v4l2_poll(mt, fds[i].fd, fds[i].revents);
+			if (rval < 0)
+				goto out_free;
+		}
+
+		for (; i < poll_nfds; i++) {
+			if (!(fds[i].revents & POLLPRI))
+				continue;
+
+			rval = request_poll(mt, fds[i].fd, fds[i].revents);
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
+		/* Get number of file descriptors to poll */
+		poll_nfds = 1;
+
+		list_for_each_name(&mt->vdev_names, name)
+			poll_nfds++;
+
+		list_for_each_name(&mt->request_names, name) {
+			struct mt_request *mtr =
+				container_of(name, struct mt_request, name);
+
+			if (mtr->queued)
+				poll_nfds++;
+		}
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
+		poll_v4l2_pos = 1;
+
+		list_for_each_name(&mt->vdev_names, name) {
+			struct v4l2_device *vdev =
+				container_of(name, struct v4l2_device, name);
+			unsigned int i;
+
+			for (i = 0; i < BUF_TYPES; i++) {
+				struct v4l2_queue *q = &vdev->q[i];
+
+				if (!q->streaming)
+					continue;
+
+				if (!q->queued)
+					continue;
+
+				fds[poll_v4l2_pos].fd = vdev->fd;
+				fds[poll_v4l2_pos].events = POLLIN | POLLOUT;
+				poll_v4l2_pos++;
+
+				break;
+			}
+		}
+
+		poll_nfds = poll_v4l2_pos;
+
+		list_for_each_name(&mt->request_names, name) {
+			struct mt_request *mtr =
+				container_of(name, struct mt_request, name);
+
+			if (!mtr->queued)
+				continue;
+
+			fds[poll_nfds].fd = name->id;
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
