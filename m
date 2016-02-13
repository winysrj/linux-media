Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:60983 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751083AbcBMSr4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 13 Feb 2016 13:47:56 -0500
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (Postfix) with ESMTPS id 95FD78E258
	for <linux-media@vger.kernel.org>; Sat, 13 Feb 2016 18:47:56 +0000 (UTC)
From: Hans de Goede <hdegoede@redhat.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH tvtime 07/17] Add get_media_devices.c from xawtv
Date: Sat, 13 Feb 2016 19:47:28 +0100
Message-Id: <1455389258-13470-7-git-send-email-hdegoede@redhat.com>
In-Reply-To: <1455389258-13470-1-git-send-email-hdegoede@redhat.com>
References: <1455389258-13470-1-git-send-email-hdegoede@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This will allow us to automatically detect the tv-card and the matching
alsa capture device for the alsa digital loopback.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 src/Makefile.am         |   6 +-
 src/get_media_devices.c | 597 ++++++++++++++++++++++++++++++++++++++++++++++++
 src/get_media_devices.h | 168 ++++++++++++++
 3 files changed, 769 insertions(+), 2 deletions(-)
 create mode 100644 src/get_media_devices.c
 create mode 100644 src/get_media_devices.h

diff --git a/src/Makefile.am b/src/Makefile.am
index bf05b90..931c65c 100644
--- a/src/Makefile.am
+++ b/src/Makefile.am
@@ -46,7 +46,8 @@ COMMON_SRCS = mixer.c videoinput.c rtctimer.c leetft.c osdtools.c tvtimeconf.c \
 	cpuinfo.h cpuinfo.c menu.c menu.h \
 	outputfilter.h outputfilter.c xmltv.h xmltv.c gettext.h tvtimeglyphs.h \
 	copyfunctions.h copyfunctions.c alsa_stream.c alsa_stream.h \
-	epg.h epg.c mixer-oss.c $(ALSA_SRCS)
+	epg.h epg.c mixer-oss.c get_media_devices.c get_media_devices.h \
+	$(ALSA_SRCS)
 
 if ARCH_X86
 DSCALER_SRCS = ../plugins/dscalerapi.h \
@@ -94,7 +95,8 @@ tvtime_configure_SOURCES = utils.h utils.c tvtimeconf.h tvtimeconf.c \
 tvtime_configure_CFLAGS = $(OPT_CFLAGS) $(XML2_FLAG) $(AM_CFLAGS)
 tvtime_configure_LDFLAGS  = $(ZLIB_LIBS) $(XML2_LIBS)
 tvtime_scanner_SOURCES = utils.h utils.c videoinput.h videoinput.c \
-	tvtimeconf.h tvtimeconf.c station.h station.c tvtime-scanner.c
+	tvtimeconf.h tvtimeconf.c station.h station.c tvtime-scanner.c \
+	get_media_devices.c get_media_devices.h
 tvtime_scanner_CFLAGS = $(OPT_CFLAGS) $(XML2_FLAG) $(ALSA_CFLAGS) $(AM_CFLAGS)
 tvtime_scanner_LDFLAGS  = $(ZLIB_LIBS) $(XML2_LIBS) $(ALSA_LIBS)
 
diff --git a/src/get_media_devices.c b/src/get_media_devices.c
new file mode 100644
index 0000000..619734e
--- /dev/null
+++ b/src/get_media_devices.c
@@ -0,0 +1,597 @@
+/*
+   Copyright © 2011 by Mauro Carvalho Chehab <mchehab@redhat.com>
+
+   The get_media_devices is free software; you can redistribute it and/or
+   modify it under the terms of the GNU Lesser General Public
+   License as published by the Free Software Foundation; either
+   version 2.1 of the License, or (at your option) any later version.
+
+   The libv4l2util Library is distributed in the hope that it will be useful,
+   but WITHOUT ANY WARRANTY; without even the implied warranty of
+   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+   Lesser General Public License for more details.
+
+   You should have received a copy of the GNU Lesser General Public
+   License along with the libv4l2util Library; if not, write to the Free
+   Software Foundation, Inc., 51 Franklin Street, Suite 500, Boston, MA
+   02110-1335 USA.
+ */
+
+#ifdef __linux__ /* This depends on sysfs, so it is linux only */
+
+#include <stdio.h>
+#include <unistd.h>
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <string.h>
+#include <stdlib.h>
+#include <malloc.h>
+#include <dirent.h>
+#include "get_media_devices.h"
+
+#define ARRAY_SIZE(arr) (sizeof(arr) / sizeof((arr)[0]))
+
+/**
+ * struct media_device_entry - Describes one device entry got via sysfs
+ *
+ * @device:		sysfs name for a device.
+ *			PCI devices are like: pci0000:00/0000:00:1b.0
+ *			USB devices are like: pci0000:00/0000:00:1d.7/usb1/1-8
+ * @node:		Device node, in sysfs or alsa hw identifier
+ * @device_type:	Type of the device (V4L_*, DVB_*, SND_*)
+ */
+struct media_device_entry {
+	char *device;
+	char *node;
+	enum device_type type;
+	enum bus_type bus;
+	unsigned major, minor;		/* Device major/minor */
+};
+
+/**
+ * struct media_devices - Describes all devices found
+ *
+ * @device:		sysfs name for a device.
+ *			PCI devices are like: pci0000:00/0000:00:1b.0
+ *			USB devices are like: pci0000:00/0000:00:1d.7/usb1/1-8
+ * @node:		Device node, in sysfs or alsa hw identifier
+ * @device_type:	Type of the device (V4L_*, DVB_*, SND_*)
+ */
+struct media_devices {
+	struct media_device_entry *md_entry;
+	unsigned int md_size;
+};
+
+typedef int (*fill_data_t)(struct media_device_entry *md);
+
+#define DEVICE_STR "devices"
+
+static void get_uevent_info(struct media_device_entry *md_ptr, char *dname)
+{
+	FILE *fd;
+	char file[PATH_MAX], *name, *p;
+	char s[1024];
+
+	snprintf(file, PATH_MAX, "%s/%s/uevent", dname, md_ptr->node);
+	fd = fopen(file, "r");
+	if (!fd)
+		return;
+	while (fgets(s, sizeof(s), fd)) {
+		p = strtok(s, "=");
+		if (!p)
+			continue;
+		name = p;
+		p = strtok(NULL, "\n");
+		if (!p)
+			continue;
+		if (!strcmp(name, "MAJOR"))
+			md_ptr->major = atol(p);
+		else if (!strcmp(name, "MINOR"))
+			md_ptr->minor = atol(p);
+	}
+
+	fclose(fd);
+}
+
+static enum bus_type get_bus(char *device)
+{
+	char file[PATH_MAX];
+	char s[1024];
+	FILE *f;
+
+	if (!strcmp(device, "/sys/devices/virtual"))
+		return MEDIA_BUS_VIRTUAL;
+
+	snprintf(file, PATH_MAX, "%s/modalias", device);
+	f = fopen(file, "r");
+	if (!f)
+		return MEDIA_BUS_UNKNOWN;
+	if (!fgets(s, sizeof(s), f))
+		return MEDIA_BUS_UNKNOWN;
+	fclose(f);
+
+	if (!strncmp(s, "pci", 3))
+		return MEDIA_BUS_PCI;
+	if (!strncmp(s, "usb", 3))
+		return MEDIA_BUS_USB;
+
+	return MEDIA_BUS_UNKNOWN;
+}
+
+static int get_class(char *class,
+		     struct media_device_entry **md,
+		     unsigned int *md_size,
+		     fill_data_t fill)
+{
+	DIR		*dir;
+	struct dirent	*entry;
+	char		dname[PATH_MAX];
+	char		fname[PATH_MAX];
+	char		link[PATH_MAX];
+	char		virt_dev[60];
+	int		err = -2;
+	struct		media_device_entry *md_ptr = NULL;
+	char		*p, *device;
+	enum bus_type	bus;
+	static int	virtual = 0;
+
+	snprintf(dname, PATH_MAX, "/sys/class/%s", class);
+	dir = opendir(dname);
+	if (!dir) {
+		return 0;
+	}
+	for (entry = readdir(dir); entry; entry = readdir(dir)) {
+		/* Skip . and .. */
+		if (entry->d_name[0] == '.')
+			continue;
+		/* Canonicalize the device name */
+		snprintf(fname, PATH_MAX, "%s/%s", dname, entry->d_name);
+		if (realpath(fname, link)) {
+			device = link;
+
+			/* Remove the subsystem/class_name from the string */
+			p = strstr(device, class);
+			if (!p)
+				continue;
+			*(p - 1) = '\0';
+
+			bus = get_bus(device);
+
+			/* remove the /sys/devices/ from the name */
+			device += 13;
+
+			switch (bus) {
+			case MEDIA_BUS_PCI:
+				/* Remove the device function nr */
+				p = strrchr(device, '.');
+				if (!p)
+					continue;
+				*p = '\0';
+				break;
+			case MEDIA_BUS_USB:
+				/* Remove USB interface from the path */
+				p = strrchr(device, '/');
+				if (!p)
+					continue;
+				/* In case we have a device where the driver
+				   attaches directly to the usb device rather
+				   then to an interface */
+				if (!strchr(p, ':'))
+					break;
+				*p = '\0';
+				break;
+			case MEDIA_BUS_VIRTUAL:
+				/* Don't group virtual devices */
+				sprintf(virt_dev, "virtual%d", virtual++);
+				device = virt_dev;
+				break;
+			case MEDIA_BUS_UNKNOWN:
+				break;
+			}
+
+			/* Add one more element to the devices struct */
+			*md = realloc(*md, (*md_size + 1) * sizeof(*md_ptr));
+			if (!*md)
+				goto error;
+			md_ptr = (*md) + *md_size;
+			(*md_size)++;
+
+			/* Cleans previous data and fills it with device/node */
+			memset(md_ptr, 0, sizeof(*md_ptr));
+			md_ptr->type = UNKNOWN;
+			md_ptr->device = strdup(device);
+			md_ptr->node = strdup(entry->d_name);
+
+			/* Retrieve major and minor information */
+			get_uevent_info(md_ptr, dname);
+
+			/* Used to identify the type of node */
+			fill(md_ptr);
+		}
+	}
+	err = 0;
+error:
+	closedir(dir);
+	return err;
+}
+
+static int add_v4l_class(struct media_device_entry *md)
+{
+	if (strstr(md->node, "video"))
+		md->type = MEDIA_V4L_VIDEO;
+	else if (strstr(md->node, "vbi"))
+		md->type = MEDIA_V4L_VBI;
+	else if (strstr(md->node, "radio"))
+		md->type = MEDIA_V4L_RADIO;
+	else if (strstr(md->node, "v4l-subdev"))
+		md->type = MEDIA_V4L_SUBDEV;
+
+	return 0;
+}
+
+static int add_snd_class(struct media_device_entry *md)
+{
+	unsigned c = 65535, d = 65535;
+	char node[64];
+
+	if (strstr(md->node, "timer")) {
+		md->type = MEDIA_SND_TIMER;
+		return 0;
+	} else if (strstr(md->node, "seq")) {
+		md->type = MEDIA_SND_SEQ;
+		return 0;
+	} if (strstr(md->node, "card")) {
+		sscanf(md->node, "card%u", &c);
+		md->type = MEDIA_SND_CARD;
+	} else if (strstr(md->node, "hw")) {
+		sscanf(md->node, "hwC%uD%u", &c, &d);
+		md->type = MEDIA_SND_HW;
+	} else if (strstr(md->node, "control")) {
+		sscanf(md->node, "controlC%u", &c);
+		md->type = MEDIA_SND_CONTROL;
+	} else if (strstr(md->node, "pcm")) {
+		sscanf(md->node, "pcmC%uD%u", &c, &d);
+		if (md->node[strlen(md->node) - 1] == 'p')
+			md->type = MEDIA_SND_OUT;
+		else if (md->node[strlen(md->node) - 1] == 'c')
+			md->type = MEDIA_SND_CAP;
+	}
+
+	if (c == 65535)
+		return 0;
+
+	/* Reformat device to be useful for alsa userspace library */
+	if (d == 65535)
+		snprintf(node, sizeof(node), "hw:%u", c);
+	else
+		snprintf(node, sizeof(node), "hw:%u,%u", c, d);
+
+	free(md->node);
+	md->node = strdup(node);
+
+	return 0;
+}
+
+static int add_dvb_class(struct media_device_entry *md)
+{
+	if (strstr(md->node, "video"))
+		md->type = MEDIA_DVB_VIDEO;
+	if (strstr(md->node, "audio"))
+		md->type = MEDIA_DVB_AUDIO;
+	if (strstr(md->node, "sec"))
+		md->type = MEDIA_DVB_SEC;
+	if (strstr(md->node, "frontend"))
+		md->type = MEDIA_DVB_FRONTEND;
+	else if (strstr(md->node, "demux"))
+		md->type = MEDIA_DVB_DEMUX;
+	else if (strstr(md->node, "dvr"))
+		md->type = MEDIA_DVB_DVR;
+	else if (strstr(md->node, "net"))
+		md->type = MEDIA_DVB_NET;
+	else if (strstr(md->node, "ca"))
+		md->type = MEDIA_DVB_CA;
+	else if (strstr(md->node, "osd"))
+		md->type = MEDIA_DVB_OSD;
+
+	return 0;
+}
+
+static int sort_media_device_entry(const void *a, const void *b)
+{
+	const struct media_device_entry *md_a = a;
+	const struct media_device_entry *md_b = b;
+	int cmp;
+
+	cmp = strcmp(md_a->device, md_b->device);
+	if (cmp)
+		return cmp;
+	cmp = (int)md_a->type - (int)md_b->type;
+	if (cmp)
+		return cmp;
+
+	return strcmp(md_a->node, md_b->node);
+}
+
+
+/* Public functions */
+
+void free_media_devices(void *opaque)
+{
+	struct media_devices *md = opaque;
+	struct media_device_entry *md_ptr = md->md_entry;
+	int i;
+	for (i = 0; i < md->md_size; i++) {
+		free(md_ptr->node);
+		free(md_ptr->device);
+		md_ptr++;
+	}
+	free(md->md_entry);
+	free(md);
+}
+
+void *discover_media_devices(void)
+{
+	struct media_devices *md = NULL;
+	struct media_device_entry *md_entry = NULL;
+
+	md = calloc(1, sizeof(*md));
+	if (!md)
+		return NULL;
+
+	md->md_size = 0;
+	if (get_class("video4linux", &md_entry, &md->md_size, add_v4l_class))
+		goto error;
+	if (get_class("sound", &md_entry, &md->md_size, add_snd_class))
+		goto error;
+	if (get_class("dvb", &md_entry, &md->md_size, add_dvb_class))
+		goto error;
+
+	/* There's no media device */
+	if (!md_entry)
+		goto error;
+
+	qsort(md_entry, md->md_size, sizeof(*md_entry), sort_media_device_entry);
+
+	md->md_entry = md_entry;
+
+	return md;
+
+error:
+	free_media_devices(md);
+	return NULL;
+}
+
+const char *media_device_type(enum device_type type)
+{
+	switch(type) {
+		/* V4L nodes */
+	case MEDIA_V4L_VIDEO:
+		return  "video";
+	case MEDIA_V4L_VBI:
+		return  "vbi";
+	case MEDIA_V4L_RADIO:
+		return "radio";
+	case MEDIA_V4L_SUBDEV:
+		return "v4l subdevice";
+
+		/* DVB nodes */
+	case MEDIA_DVB_VIDEO:
+		return  "dvb video";
+	case MEDIA_DVB_AUDIO:
+		return  "dvb audio";
+	case MEDIA_DVB_SEC:
+		return  "dvb sec";
+	case MEDIA_DVB_FRONTEND:
+		return  "dvb frontend";
+	case MEDIA_DVB_DEMUX:
+		return  "dvb demux";
+	case MEDIA_DVB_DVR:
+		return  "dvb dvr";
+	case MEDIA_DVB_NET:
+		return  "dvb net";
+	case MEDIA_DVB_CA:
+		return  "dvb conditional access";
+	case MEDIA_DVB_OSD:
+		return  "dvb OSD";
+
+		/* Alsa nodes */
+	case MEDIA_SND_CARD:
+		return  "sound card";
+	case MEDIA_SND_CAP:
+		return  "pcm capture";
+	case MEDIA_SND_OUT:
+		return  "pcm output";
+	case MEDIA_SND_CONTROL:
+		return  "mixer";
+	case MEDIA_SND_HW:
+		return  "sound hardware";
+	case MEDIA_SND_TIMER:
+		return  "sound timer";
+	case MEDIA_SND_SEQ:
+		return  "sound sequencer";
+
+	default:
+		return "unknown";
+	};
+}
+
+void display_media_devices(void *opaque)
+{
+	struct media_devices *md = opaque;
+	struct media_device_entry *md_ptr = md->md_entry;
+	int i;
+	char *prev = "";
+
+	for (i = 0; i < md->md_size; i++) {
+		if (strcmp(prev, md_ptr->device)) {
+			printf("\nDevice %s:\n\t", md_ptr->device);
+			prev = md_ptr->device;
+		}
+		printf("%s(%s, dev %i:%i) ", md_ptr->node,
+		       media_device_type(md_ptr->type),
+		       md_ptr->major, md_ptr->minor);
+		md_ptr++;
+	}
+	printf("\n");
+}
+
+const char *get_associated_device(void *opaque,
+				  const char *last_seek,
+				  const enum device_type desired_type,
+				  const char *seek_device,
+				  const enum device_type seek_type)
+{
+	struct media_devices *md = opaque;
+	struct media_device_entry *md_ptr = md->md_entry;
+	int i, found = 0;
+	char *prev, *p;
+
+	if (seek_type != NONE && seek_device[0]) {
+		/* Get just the device name */
+		p = strrchr(seek_device, '/');
+		if (p)
+			seek_device = p + 1;
+
+		/* Step 1: Find the seek node */
+		for (i = 0; i < md->md_size; i++, md_ptr++) {
+			if (last_seek && md_ptr->type == seek_type &&
+			    !strcmp(md_ptr->node, last_seek)) {
+				found = 1;
+				continue;
+			}
+			if (last_seek && !found)
+				continue;
+			if (md_ptr->type == seek_type &&
+			    !strcmp(seek_device, md_ptr->node))
+				break;
+		}
+		if (i == md->md_size)
+			return NULL;
+		i++;
+		prev = md_ptr->device;
+		md_ptr++;
+		/* Step 2: find the associated node */
+		for (; i < md->md_size && !strcmp(prev, md_ptr->device); i++, md_ptr++) {
+			if (last_seek && md_ptr->type == seek_type &&
+			    !strcmp(md_ptr->node, last_seek)) {
+				found = 1;
+				continue;
+			}
+			if (last_seek && !found)
+				continue;
+			if (md_ptr->type == desired_type)
+				return md_ptr->node;
+		}
+	} else {
+		for (i = 0; i < md->md_size; i++, md_ptr++) {
+			if (last_seek && !strcmp(md_ptr->node, last_seek)) {
+				found = 1;
+				continue;
+			}
+			if (last_seek && !found)
+				continue;
+			if (md_ptr->type == desired_type)
+				return md_ptr->node;
+		}
+	}
+
+	return NULL;
+}
+
+const char *fget_associated_device(void *opaque,
+				   const char *last_seek,
+				   const enum device_type desired_type,
+				   const int fd_seek_device,
+				   const enum device_type seek_type)
+{
+	struct media_devices *md = opaque;
+	struct media_device_entry *md_ptr = md->md_entry;
+	struct stat f_status;
+	unsigned int dev_major, dev_minor;
+	int i, found = 0;
+	char *prev;
+
+	if (fstat(fd_seek_device, &f_status)) {
+		perror("Can't get file status");
+		return NULL;
+	}
+	if (!S_ISCHR(f_status.st_mode)) {
+		fprintf(stderr, "File descriptor is not a char device\n");
+		return NULL;
+	}
+	dev_major = major(f_status.st_rdev);
+	dev_minor = minor(f_status.st_rdev);
+
+	/* Step 1: Find the seek node */
+	for (i = 0; i < md->md_size; i++, md_ptr++) {
+		if (last_seek && md_ptr->type == seek_type
+		    && md_ptr->major == dev_major
+		    && md_ptr->minor == dev_minor) {
+			found = 1;
+			continue;
+		}
+		if (last_seek && !found)
+			continue;
+		if (md_ptr->type == seek_type
+		    && md_ptr->major == dev_major
+		    && md_ptr->minor == dev_minor)
+			break;
+	}
+	if (i == md->md_size)
+		return NULL;
+	i++;
+	prev = md_ptr->device;
+	md_ptr++;
+	/* Step 2: find the associated node */
+	for (; i < md->md_size && !strcmp(prev, md_ptr->device); i++, md_ptr++) {
+		if (last_seek && md_ptr->type == seek_type
+		    && md_ptr->major == dev_major
+		    && md_ptr->minor == dev_minor) {
+			found = 1;
+			continue;
+		}
+		if (last_seek && !found)
+			continue;
+		if (md_ptr->type == desired_type)
+			return md_ptr->node;
+	}
+	return NULL;
+}
+
+const char *get_not_associated_device(void *opaque,
+				      const char *last_seek,
+				      const enum device_type desired_type,
+				      const enum device_type not_desired_type)
+{
+	struct media_devices *md = opaque;
+	struct media_device_entry *md_ptr = md->md_entry;
+	int i, skip = 0, found = 0;
+	char *prev = "", *result = NULL;
+
+	/* Step 1: Find a device without seek_type node */
+	for (i = 0; i < md->md_size; i++, md_ptr++) {
+		if (last_seek && !strcmp(md_ptr->node, last_seek)) {
+			found = 1;
+			continue;
+		}
+		if (last_seek && !found)
+			continue;
+		if (strcmp(prev, md_ptr->device)) {
+			if (!skip && result)
+				break;
+			prev = md_ptr->device;
+			skip = 0;
+			result = NULL;
+		}
+		if (md_ptr->type == not_desired_type)
+			skip = 1;
+		else if (!skip && !result && md_ptr->type == desired_type)
+			result = md_ptr->node;
+	}
+	if (skip)
+		result = NULL;
+
+	return result;
+}
+
+#endif
diff --git a/src/get_media_devices.h b/src/get_media_devices.h
new file mode 100644
index 0000000..bfa697b
--- /dev/null
+++ b/src/get_media_devices.h
@@ -0,0 +1,168 @@
+/*
+   Copyright © 2011 by Mauro Carvalho Chehab <mchehab@redhat.com>
+
+   The get_media_devices is free software; you can redistribute it and/or
+   modify it under the terms of the GNU Lesser General Public
+   License as published by the Free Software Foundation; either
+   version 2.1 of the License, or (at your option) any later version.
+
+   The libv4l2util Library is distributed in the hope that it will be useful,
+   but WITHOUT ANY WARRANTY; without even the implied warranty of
+   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+   Lesser General Public License for more details.
+
+   You should have received a copy of the GNU Lesser General Public
+   License along with the libv4l2util Library; if not, write to the Free
+   Software Foundation, Inc., 51 Franklin Street, Suite 500, Boston, MA
+   02110-1335 USA.
+ */
+
+/*
+ * Version of the API
+ */
+#define GET_MEDIA_DEVICES_VERSION	0x0105
+
+/**
+ * enum device_type - Enumerates the type for each device
+ *
+ * The device_type is used to sort the media devices array.
+ * So, the order is relevant. The first device should be
+ * MEDIA_V4L_VIDEO.
+ */
+enum device_type {
+	UNKNOWN = 65535,
+	NONE    = 65534,
+	MEDIA_V4L_VIDEO = 0,
+	MEDIA_V4L_VBI,
+	MEDIA_V4L_RADIO,
+	MEDIA_V4L_SUBDEV,
+
+	MEDIA_DVB_VIDEO = 100,
+	MEDIA_DVB_AUDIO,
+	MEDIA_DVB_SEC,
+	MEDIA_DVB_FRONTEND,
+	MEDIA_DVB_DEMUX,
+	MEDIA_DVB_DVR,
+	MEDIA_DVB_CA,
+	MEDIA_DVB_NET,
+	MEDIA_DVB_OSD,
+
+	MEDIA_SND_CARD = 200,
+	MEDIA_SND_CAP,
+	MEDIA_SND_OUT,
+	MEDIA_SND_CONTROL,
+	MEDIA_SND_HW,
+	MEDIA_SND_TIMER,
+	MEDIA_SND_SEQ,
+	/*
+	 * FIXME: not all alsa devices were mapped. missing things like
+	 *	midi, midiC%iD%i and timer interfaces
+	 */
+};
+
+enum bus_type {
+	MEDIA_BUS_UNKNOWN,
+	MEDIA_BUS_VIRTUAL,
+	MEDIA_BUS_PCI,
+	MEDIA_BUS_USB,
+};
+
+/**
+ * discover_media_devices() - Returns a list of the media devices
+ * @md_size:	Returns the size of the media devices found
+ *
+ * This function reads the /sys/class nodes for V4L, DVB and sound,
+ * and returns an opaque desciptor that keeps a list of the devices.
+ * The fields on this list is opaque, as they can be changed on newer
+ * releases of this library. So, all access to it should be done via
+ * a function provided by the API. The devices are ordered by device,
+ * type and node. At return, md_size is updated.
+ */
+void *discover_media_devices(void);
+
+/**
+ * free_media_devices() - Frees the media devices array
+ *
+ * @opaque:	media devices opaque descriptor
+ *
+ * As discover_media_devices() dynamically allocate space for the
+ * strings, feeing the list requires also to free those data. So,
+ * the safest and recommended way is to call this function.
+ */
+void free_media_devices(void *opaque);
+
+/**
+ * media_device_type() - returns a string with the name of a given type
+ *
+ * @type:	media device type
+ */
+const char *media_device_type(const enum device_type type);
+
+/**
+ * display_media_devices() - prints a list of media devices
+ *
+ * @opaque:	media devices opaque descriptor
+ */
+void display_media_devices(void *opaque);
+
+/**
+ * get_associated_device() - Return the next device associated with another one
+ *
+ * @opaque:		media devices opaque descriptor
+ * @last_seek:		last seek result. Use NULL to get the first result
+ * @desired_type:	type of the desired device
+ * @seek_device:	name of the device with you want to get an association.
+ *@ seek_type:		type of the seek device. Using NONE produces the same
+ *			result of using NULL for the seek_device.
+ *
+ * This function seeks inside the media_devices struct for the next device
+ * that it is associated with a seek parameter.
+ * It can be used to get an alsa device associated with a video device. If
+ * the seek_device is NULL or seek_type is NONE, it will just search for
+ * devices of the desired_type.
+ */
+const char *get_associated_device(void *opaque,
+				  const char *last_seek,
+				  const enum device_type desired_type,
+				  const char *seek_device,
+				  const enum device_type seek_type);
+
+/**
+ * fget_associated_device() - Return the next device associated with another one
+ *
+ * @opaque:		media devices opaque descriptor
+ * @last_seek:		last seek result. Use NULL to get the first result
+ * @desired_type:	type of the desired device
+ * @fd_seek_device:	file handler for the device where the association will
+			be made
+ *@ seek_type:		type of the seek device. Using NONE produces the same
+ *			result of using NULL for the seek_device.
+ *
+ * This function seeks inside the media_devices struct for the next device
+ * that it is associated with a seek parameter.
+ * It can be used to get an alsa device associated with an open file descriptor
+ */
+const char *fget_associated_device(void *opaque,
+				   const char *last_seek,
+				   const enum device_type desired_type,
+				   const int fd_seek_device,
+				   const enum device_type seek_type);
+
+/**
+ * get_not_associated_device() - Return the next device not associated with
+ *			     an specific device type.
+ *
+ * @opaque:		media devices opaque descriptor
+ * @last_seek:		last seek result. Use NULL to get the first result
+ * @desired_type:	type of the desired device
+ * @not_desired_type:	type of the seek device
+ *
+ * This function seeks inside the media_devices struct for the next physical
+ * device that doesn't support a non_desired type.
+ * This method is useful for example to return the audio devices that are
+ * provided by the motherboard.
+ */
+const char *get_not_associated_device(void *opaque,
+				      const char *last_seek,
+				      const enum device_type desired_type,
+				      const enum device_type not_desired_type);
-- 
2.5.0

