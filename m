Return-path: <mchehab@pedra>
Received: from ns.mm-sol.com ([213.240.235.226]:35352 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754603Ab1AGRBi (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 7 Jan 2011 12:01:38 -0500
From: Yordan Kamenov <ykamenov@mm-sol.com>
To: hdegoede@redhat.com
Cc: linux-media@vger.kernel.org,
	sakari.ailus@maxwell.research.nokia.com,
	Yordan Kamenov <ykamenov@mm-sol.com>
Subject: [PATCH 1/1] Add plugin support to libv4l
Date: Fri,  7 Jan 2011 18:59:35 +0200
Message-Id: <4aa83c66a0b9030d422123f49d75e6eb5e2d58bd.1294418213.git.ykamenov@mm-sol.com>
In-Reply-To: <cover.1294418213.git.ykamenov@mm-sol.com>
References: <cover.1294418213.git.ykamenov@mm-sol.com>
In-Reply-To: <cover.1294418213.git.ykamenov@mm-sol.com>
References: <cover.1294418213.git.ykamenov@mm-sol.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

A libv4l2 plugin will sit in between libv4l2 itself and the
actual /dev/video device node a fd refers to. It will be called each time
libv4l2 wants to do an operation (read/write/ioctl/mmap/munmap) on the
actual /dev/video node in question.

Signed-off-by: Yordan Kamenov <ykamenov@mm-sol.com>
---
 lib/include/libv4l2-plugin.h |   74 ++++++++
 lib/include/libv4l2.h        |   15 ++
 lib/libv4l2/Makefile         |    4 +-
 lib/libv4l2/libv4l2-priv.h   |    9 +
 lib/libv4l2/libv4l2.c        |   56 ++++++-
 lib/libv4l2/v4l2-plugin.c    |  399 ++++++++++++++++++++++++++++++++++++++++++
 lib/libv4l2/v4l2convert.c    |   20 ++-
 7 files changed, 568 insertions(+), 9 deletions(-)
 create mode 100644 lib/include/libv4l2-plugin.h
 create mode 100644 lib/libv4l2/v4l2-plugin.c

diff --git a/lib/include/libv4l2-plugin.h b/lib/include/libv4l2-plugin.h
new file mode 100644
index 0000000..881b55d
--- /dev/null
+++ b/lib/include/libv4l2-plugin.h
@@ -0,0 +1,74 @@
+/*
+* Copyright (C) 2010 Nokia Corporation <multimedia@maemo.org>
+
+* This program is free software; you can redistribute it and/or modify
+* it under the terms of the GNU Lesser General Public License as published by
+* the Free Software Foundation; either version 2.1 of the License, or
+* (at your option) any later version.
+*
+* This program is distributed in the hope that it will be useful,
+* but WITHOUT ANY WARRANTY; without even the implied warranty of
+* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+* Lesser General Public License for more details.
+*
+* You should have received a copy of the GNU Lesser General Public License
+* along with this program; if not, write to the Free Software
+* Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+*/
+
+#ifndef __LIBV4L2_PLUGIN_H
+#define __LIBV4L2_PLUGIN_H
+
+#include <sys/types.h>
+
+/* A libv4l2 plugin will sit in between libv4l2 itself and the
+   actual /dev/video device node a fd refers to. It will be called each time
+   libv4l2 wants to do an operation (read/write/ioctl/mmap/munmap) on the
+   actual /dev/video node in question. When called the plugin can then choose
+   to do one of the following:
+   1. Pass the call unmodified to the fd, and return the return value unmodifed
+   2. Modify some arguments in the call and pass it through
+   3. Modify the return(ed) value(s) of a passed through call
+   4. Not do any operation on the fd at all but instead completely fake it
+       (which opens the possibility for "fake" v4l devices)
+
+   libv4l2 plugins should *never* use any global variables. All data should be
+   bound to the specific fd to which the plugin is bound. This ensures that for
+   example a plugin for a specific type of usb webcam will also work when 2
+   identical cameras are plugged into a system (and both are used from the same
+   process).
+
+   A libv4l2 plugin can register plugin private data using:
+   void libv4l2_set_plugindata(int fd, void *plugin_data);
+
+   And can get this data out of libv4l2 again inside a callback using:
+   void *libv4l2_get_plugindata(int fd);
+
+   Note that a plugin should call libv4l2_set_plugindata only once per fd !
+   Calling it a second time will overwrite the previous value. The logical
+   place to use libv4l2_set_plugindata is from the plugin's open callback.
+*/
+
+/* Plugin callback function struct */
+struct libv4l2_plugin_data {
+	int (*open)(const char *file, int oflag, ...);
+	int (*close)(int fd);
+	int (*ioctl)(int fd, unsigned long int request, ...);
+	ssize_t (*read)(int fd, void *buffer, size_t n);
+	void *(*mmap)(void *start, size_t length, int prot, int flags,
+			int fd, int64_t offset);
+	/* Note as munmap has no fd argument, defining a callback for munmap
+		will result in it getting called for *any* call to v4l2_munmap.
+		So if a plugin defines a callback for munmap (because for
+		example it returns fake mmap buffers from its mmap callback).
+		Then it must keep track of the addresses at which these buffers
+		live and their size and check the munmap arguments to see if the
+		munmap call was meant for it. */
+	int (*munmap)(void *_start, size_t length);
+};
+
+/* Plugin utility functions */
+void libv4l2_set_plugindata(int fd, void *plugin_data);
+void *libv4l2_get_plugindata(int fd);
+
+#endif
diff --git a/lib/include/libv4l2.h b/lib/include/libv4l2.h
index cc0ab4a..2123546 100644
--- a/lib/include/libv4l2.h
+++ b/lib/include/libv4l2.h
@@ -22,6 +22,7 @@
 #include <stdio.h>
 #include <unistd.h>
 #include <stdint.h>
+#include "libv4l2-plugin.h"
 
 #ifdef __cplusplus
 extern "C" {
@@ -108,6 +109,20 @@ LIBV4L_PUBLIC int v4l2_get_control(int fd, int cid);
    (note the fd is left open in this case). */
 LIBV4L_PUBLIC int v4l2_fd_open(int fd, int v4l2_flags);
 
+
+LIBV4L_PUBLIC int v4l2_plugin_open(int *plugin_used, const char *file,
+					int oflag, ...);
+LIBV4L_PUBLIC int v4l2_plugin_close(int *plugin_used, int fd);
+LIBV4L_PUBLIC int v4l2_plugin_ioctl(int *plugin_used, int fd,
+					unsigned long int request, ...);
+LIBV4L_PUBLIC ssize_t v4l2_plugin_read(int *plugin_used, int fd, void *dest,
+					size_t n);
+LIBV4L_PUBLIC void *v4l2_plugin_mmap(int *plugin_used, void *start,
+					size_t length, int prot, int flags,
+					int fd, int64_t offset);
+LIBV4L_PUBLIC int v4l2_plugin_munmap(int *plugin_used, void *_start,
+					size_t length);
+
 #ifdef __cplusplus
 }
 #endif /* __cplusplus */
diff --git a/lib/libv4l2/Makefile b/lib/libv4l2/Makefile
index d78632f..eb1c019 100644
--- a/lib/libv4l2/Makefile
+++ b/lib/libv4l2/Makefile
@@ -1,8 +1,8 @@
 override CPPFLAGS += -I../include -fvisibility=hidden
 
-LIBS_libv4l2  = -lpthread
+LIBS_libv4l2  = -lpthread -ldl
 
-V4L2_OBJS     = libv4l2.o log.o
+V4L2_OBJS     = libv4l2.o v4l2-plugin.o log.o
 V4L2CONVERT   = v4l2convert.so
 V4L2CONVERT_O = v4l2convert.o libv4l2.so
 TARGETS       = $(V4L2_LIB) libv4l2.pc
diff --git a/lib/libv4l2/libv4l2-priv.h b/lib/libv4l2/libv4l2-priv.h
index 46d6103..3873b1d 100644
--- a/lib/libv4l2/libv4l2-priv.h
+++ b/lib/libv4l2/libv4l2-priv.h
@@ -87,6 +87,15 @@ struct v4l2_dev_info {
 	unsigned char *readbuf;
 };
 
+struct v4l2_plugin_info {
+	int fd;
+	void *plugin_library;
+	struct libv4l2_plugin_data *libv4l2_plugin;
+	unsigned char *frame_pointers[V4L2_MAX_NO_FRAMES];
+	int frame_sizes[V4L2_MAX_NO_FRAMES];
+	void *plugin_data;
+};
+
 /* From log.c */
 void v4l2_log_ioctl(unsigned long int request, void *arg, int result);
 
diff --git a/lib/libv4l2/libv4l2.c b/lib/libv4l2/libv4l2.c
index ab85ea7..8696c68 100644
--- a/lib/libv4l2/libv4l2.c
+++ b/lib/libv4l2/libv4l2.c
@@ -67,6 +67,7 @@
 #include <sys/stat.h>
 #include "libv4l2.h"
 #include "libv4l2-priv.h"
+#include "libv4l2-plugin.h"
 
 /* Note these flags are stored together with the flags passed to v4l2_fd_open()
    in v4l2_dev_info's flags member, so care should be taken that the do not
@@ -522,7 +523,24 @@ static int v4l2_buffers_mapped(int index)
 
 int v4l2_open(const char *file, int oflag, ...)
 {
-	int fd;
+	int fd, plugin_used;
+
+	if (oflag & O_CREAT) {
+		va_list ap;
+		mode_t mode;
+
+		va_start(ap, oflag);
+		mode = va_arg(ap, mode_t);
+
+		fd = v4l2_plugin_open(&plugin_used, file, oflag, mode);
+
+		va_end(ap);
+	} else {
+		fd = v4l2_plugin_open(&plugin_used, file, oflag, 0);
+	}
+
+	if (plugin_used)
+		return fd;
 
 	/* original open code */
 	if (oflag & O_CREAT) {
@@ -684,7 +702,12 @@ static int v4l2_get_index(int fd)
 
 int v4l2_close(int fd)
 {
-	int index, result;
+	int index, result, plugin_used;
+
+	result = v4l2_plugin_close(&plugin_used, fd);
+
+	if (plugin_used)
+		return result;
 
 	index = v4l2_get_index(fd);
 	if (index == -1)
@@ -806,13 +829,18 @@ int v4l2_ioctl(int fd, unsigned long int request, ...)
 {
 	void *arg;
 	va_list ap;
-	int result, index, saved_err;
+	int result, index, saved_err, plugin_used;
 	int is_capture_request = 0, stream_needs_locking = 0;
 
 	va_start(ap, request);
 	arg = va_arg(ap, void *);
 	va_end(ap);
 
+	result = v4l2_plugin_ioctl(&plugin_used, fd, request, arg);
+
+	if (plugin_used)
+		return result;
+
 	index = v4l2_get_index(fd);
 	if (index == -1)
 		return SYS_IOCTL(fd, request, arg);
@@ -1205,9 +1233,14 @@ int v4l2_ioctl(int fd, unsigned long int request, ...)
 ssize_t v4l2_read(int fd, void *dest, size_t n)
 {
 	ssize_t result;
-	int saved_errno;
+	int saved_errno, plugin_used;
 	int index = v4l2_get_index(fd);
 
+	result = v4l2_plugin_read(&plugin_used, fd, dest, n);
+
+	if (plugin_used)
+		return result;
+
 	if (index == -1)
 		return SYS_READ(fd, dest, n);
 
@@ -1264,10 +1297,16 @@ leave:
 void *v4l2_mmap(void *start, size_t length, int prot, int flags, int fd,
 		int64_t offset)
 {
-	int index;
+	int index, plugin_used;
 	unsigned int buffer_index;
 	void *result;
 
+	result = v4l2_plugin_mmap(&plugin_used, start, length, prot,
+							flags, fd, offset);
+
+	if (plugin_used)
+		return result;
+
 	index = v4l2_get_index(fd);
 	if (index == -1 ||
 			/* Check if the mmap data matches our answer to QUERY_BUF, if it doesn't
@@ -1329,10 +1368,15 @@ leave:
 
 int v4l2_munmap(void *_start, size_t length)
 {
-	int index;
+	int index, result, plugin_used;
 	unsigned int buffer_index;
 	unsigned char *start = _start;
 
+	result = v4l2_plugin_munmap(&plugin_used, _start, length);
+
+	if (plugin_used)
+		return result;
+
 	/* Is this memory ours? */
 	if (start != MAP_FAILED && length == V4L2_FRAME_BUF_SIZE) {
 		for (index = 0; index < devices_used; index++)
diff --git a/lib/libv4l2/v4l2-plugin.c b/lib/libv4l2/v4l2-plugin.c
new file mode 100644
index 0000000..3efd533
--- /dev/null
+++ b/lib/libv4l2/v4l2-plugin.c
@@ -0,0 +1,399 @@
+/*
+* Copyright (C) 2010 Nokia Corporation <multimedia@maemo.org>
+
+* This program is free software; you can redistribute it and/or modify
+* it under the terms of the GNU Lesser General Public License as published by
+* the Free Software Foundation; either version 2.1 of the License, or
+* (at your option) any later version.
+*
+* This program is distributed in the hope that it will be useful,
+* but WITHOUT ANY WARRANTY; without even the implied warranty of
+* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+* Lesser General Public License for more details.
+*
+* You should have received a copy of the GNU Lesser General Public License
+* along with this program; if not, write to the Free Software
+* Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+*/
+
+#include <stdarg.h>
+#include <dlfcn.h>
+#include <fcntl.h>
+#include <glob.h>
+#include <sys/stat.h>
+#include <sys/mman.h>
+#include "libv4l2.h"
+#include "libv4l2-priv.h"
+#include "libv4l2-plugin.h"
+
+/* libv4l plugin support:
+   it is provided by functions v4l2_plugin_[open,close,etc].
+
+   When open() is called libv4l dlopens files in /usr/lib[64]/libv4l/plugins
+   1 at a time and call open callback passing through the applications
+   parameters unmodified.
+
+   If a plugin is relevant for the specified device node, it can indicate so
+   by returning a value other then -1 (the actual file descriptor).
+   As soon as a plugin returns another value then -1 plugin loading stops and
+   information about it (fd and corresponding library handle) is stored. For
+   each function v4l2_[ioctl,read,close,etc] is called corresponding
+   v4l2_plugin_* function which looks if there is loaded plugin for that file
+   and call it's callbacks.
+
+   v4l2_plugin_* function indicates by it's first argument if plugin was used,
+   and if it was not then v4l2_* functions proceed with their usual behavior.
+*/
+
+#define PLUGINS_PATTERN "/usr/lib/libv4l/plugins/*.so"
+
+static pthread_mutex_t v4l2_plugin_mutex = PTHREAD_MUTEX_INITIALIZER;
+
+static struct v4l2_plugin_info plugins[V4L2_MAX_DEVICES];
+
+int v4l2_plugin_open(int *plugin_used, const char *file, int oflag, ...)
+{
+	char *error;
+	int index, fd = -1, glob_ret, plugin_num, i;
+	void *plugin_library = NULL;
+	struct libv4l2_plugin_data *libv4l2_plugin = NULL;
+	glob_t globbuf;
+	static int structs_initialized = 0;
+
+	pthread_mutex_lock(&v4l2_plugin_mutex);
+	if (!structs_initialized) {
+		for (index = 0; index < V4L2_MAX_DEVICES; index++)
+			plugins[index].fd = -1;
+
+		structs_initialized = 1;
+	}
+
+	/* Check if there is empty slot for plugin */
+	for (index = 0; index < V4L2_MAX_DEVICES; index++)
+		if (plugins[index].fd == -1)
+			break;
+	pthread_mutex_unlock(&v4l2_plugin_mutex);
+
+	if (index == V4L2_MAX_DEVICES) {
+		V4L2_LOG_ERR("attempting to open more than %d libv4l plugins\n",
+			V4L2_MAX_DEVICES);
+		*plugin_used = 0;
+		return -1;
+	}
+
+	glob_ret = glob(PLUGINS_PATTERN, 0, NULL, &globbuf);
+
+	if (glob_ret == GLOB_NOSPACE) {
+		*plugin_used = 0;
+		return -1;
+	}
+
+	if (glob_ret == GLOB_ABORTED || glob_ret == GLOB_NOMATCH) {
+		*plugin_used = 0;
+		goto leave;
+	}
+
+	for (plugin_num = 0; plugin_num < globbuf.gl_pathc; plugin_num++) {
+
+		V4L2_LOG("PLUGIN: dlopen(%s);\n", globbuf.gl_pathv[plugin_num]);
+
+		plugin_library = dlopen(globbuf.gl_pathv[plugin_num], RTLD_LAZY);
+
+		if (!plugin_library)
+			continue;
+
+		dlerror();    /* Clear any existing error */
+		libv4l2_plugin = (struct libv4l2_plugin_data *)
+					dlsym(plugin_library, "libv4l2_plugin");
+
+		error = dlerror();
+		if (error != NULL)  {
+			V4L2_LOG_ERR("PLUGIN: dlsym failed: %s\n", error);
+			dlclose(plugin_library);
+
+			continue;
+		}
+
+		if (libv4l2_plugin->open == NULL) {
+			fd = -1;
+		} else {
+			if (oflag & O_CREAT) {
+				va_list ap;
+				mode_t mode;
+
+				va_start(ap, oflag);
+				mode = va_arg(ap, mode_t);
+
+				fd = libv4l2_plugin->open(file, oflag, mode);
+
+				va_end(ap);
+			} else {
+				fd = libv4l2_plugin->open(file, oflag, 0);
+			}
+		}
+
+		if (fd != -1) {
+			V4L2_LOG("PLUGIN: plugin open() returned %d\n", fd);
+			pthread_mutex_lock(&v4l2_plugin_mutex);
+			/* The plugin may have called libv4l2_set_plugindata()
+			   and there is already reserved slot with that fd */
+			for (index = 0; index < V4L2_MAX_DEVICES; index++)
+				if (plugins[index].fd == fd)
+					break;
+
+			/* There is no such fd */
+			if (index == V4L2_MAX_DEVICES)
+				for (index = 0; index < V4L2_MAX_DEVICES; index++)
+					if (plugins[index].fd == -1)
+						break;
+
+			plugins[index].fd = fd;
+			plugins[index].plugin_library = plugin_library;
+			plugins[index].libv4l2_plugin = libv4l2_plugin;
+			for (i = 0; i < V4L2_MAX_NO_FRAMES; i++) {
+				plugins[index].frame_pointers[i] = MAP_FAILED;
+				plugins[index].frame_sizes[i] = 0;
+			}
+			pthread_mutex_unlock(&v4l2_plugin_mutex);
+			break;
+		} else {
+			V4L2_LOG("PLUGIN: plugin open() returned -1\n");
+			dlclose(plugin_library);
+			plugin_library = NULL;
+		}
+
+	}
+
+leave:
+	globfree(&globbuf);
+
+	if (fd == -1)
+		*plugin_used = 0;
+	else
+		*plugin_used = 1;
+
+	return fd;
+}
+
+int v4l2_plugin_close(int *plugin_used, int fd)
+{
+	int index, result = -1;
+	void *plugin_library = NULL;
+	struct libv4l2_plugin_data *libv4l2_plugin = NULL;
+
+	pthread_mutex_lock(&v4l2_plugin_mutex);
+	for (index = 0; index < V4L2_MAX_DEVICES; index++)
+		if (plugins[index].fd == fd) {
+			plugin_library = plugins[index].plugin_library;
+			libv4l2_plugin = plugins[index].libv4l2_plugin;
+			break;
+		}
+	pthread_mutex_unlock(&v4l2_plugin_mutex);
+
+	if (index == V4L2_MAX_DEVICES) {
+		*plugin_used = 0;
+	} else {
+		if (libv4l2_plugin->close == NULL) {
+			*plugin_used = 0;
+		} else {
+			result = libv4l2_plugin->close(fd);
+			*plugin_used = 1;
+		}
+
+		dlclose(plugin_library);
+
+		pthread_mutex_lock(&v4l2_plugin_mutex);
+		plugins[index].fd = -1;
+		pthread_mutex_unlock(&v4l2_plugin_mutex);
+	}
+
+	return result;
+}
+
+int v4l2_plugin_ioctl(int *plugin_used, int fd, unsigned long int request, ...)
+{
+	void *arg;
+	va_list ap;
+	int index, result = -1;
+	void *plugin_library = NULL;
+	struct libv4l2_plugin_data *libv4l2_plugin = NULL;
+
+	pthread_mutex_lock(&v4l2_plugin_mutex);
+	for (index = 0; index < V4L2_MAX_DEVICES; index++)
+		if (plugins[index].fd == fd) {
+			plugin_library = plugins[index].plugin_library;
+			libv4l2_plugin = plugins[index].libv4l2_plugin;
+			break;
+		}
+	pthread_mutex_unlock(&v4l2_plugin_mutex);
+
+	if (index == V4L2_MAX_DEVICES || libv4l2_plugin->ioctl == NULL) {
+		*plugin_used = 0;
+	} else {
+		va_start(ap, request);
+		arg = va_arg(ap, void *);
+		va_end(ap);
+
+		result = libv4l2_plugin->ioctl(fd, request, arg);
+		*plugin_used = 1;
+	}
+
+	return result;
+}
+
+ssize_t v4l2_plugin_read(int *plugin_used, int fd, void *dest, size_t n)
+{
+	int index, result = -1;
+	void *plugin_library = NULL;
+	struct libv4l2_plugin_data *libv4l2_plugin = NULL;
+
+	pthread_mutex_lock(&v4l2_plugin_mutex);
+	for (index = 0; index < V4L2_MAX_DEVICES; index++)
+		if (plugins[index].fd == fd) {
+			plugin_library = plugins[index].plugin_library;
+			libv4l2_plugin = plugins[index].libv4l2_plugin;
+			break;
+		}
+	pthread_mutex_unlock(&v4l2_plugin_mutex);
+
+	if (index == V4L2_MAX_DEVICES || libv4l2_plugin->read == NULL) {
+		*plugin_used = 0;
+	} else {
+		result = libv4l2_plugin->read(fd, dest, n);
+		*plugin_used = 1;
+	}
+
+	return result;
+}
+
+void *v4l2_plugin_mmap(int *plugin_used, void *start, size_t length, int prot,
+					int flags, int fd, int64_t offset)
+{
+	int index, i;
+	void *result = NULL;
+	void *plugin_library = NULL;
+	struct libv4l2_plugin_data *libv4l2_plugin = NULL;
+
+	pthread_mutex_lock(&v4l2_plugin_mutex);
+	for (index = 0; index < V4L2_MAX_DEVICES; index++)
+		if (plugins[index].fd == fd) {
+			plugin_library = plugins[index].plugin_library;
+			libv4l2_plugin = plugins[index].libv4l2_plugin;
+			break;
+		}
+
+	if (fd == -1 || index == V4L2_MAX_DEVICES
+		|| libv4l2_plugin->mmap == NULL) {
+		*plugin_used = 0;
+	} else {
+		for (i = 0; i < V4L2_MAX_NO_FRAMES; i++)
+			if (plugins[index].frame_pointers[i] == MAP_FAILED)
+				break;
+
+		if (i == V4L2_MAX_NO_FRAMES) {
+			*plugin_used = 0;
+			result = NULL;
+			goto leave;
+		}
+
+		result = libv4l2_plugin->mmap(start, length, prot,
+						flags, fd, offset);
+		if (result) {
+			plugins[index].frame_pointers[i] = result;
+			plugins[index].frame_sizes[i] = length;
+			*plugin_used = 1;
+		} else {
+			*plugin_used = 0;
+		}
+	}
+
+leave:
+	pthread_mutex_unlock(&v4l2_plugin_mutex);
+
+	return result;
+}
+
+int v4l2_plugin_munmap(int *plugin_used, void *_start, size_t length)
+{
+	int index, map, result = 0;
+	void *plugin_library = NULL;
+	struct libv4l2_plugin_data *libv4l2_plugin = NULL;
+
+	pthread_mutex_lock(&v4l2_plugin_mutex);
+	for (index = 0; index < V4L2_MAX_DEVICES; index++) {
+		for (map = 0; map < V4L2_MAX_NO_FRAMES; map++) {
+			if (plugins[index].frame_pointers[map] == _start &&
+				plugins[index].frame_sizes[map] == length) {
+
+				plugin_library = plugins[index].plugin_library;
+				libv4l2_plugin = plugins[index].libv4l2_plugin;
+				plugins[index].frame_pointers[map] = MAP_FAILED;
+				plugins[index].frame_sizes[map] = 0;
+				break;
+			}
+		}
+		if (plugin_library)
+			break;
+	}
+
+	if (plugin_library) {
+		result = libv4l2_plugin->munmap(_start, length);
+
+		if (result)
+			*plugin_used = 0;
+		else
+			*plugin_used = 1;
+
+	} else {
+		*plugin_used = 0;
+	}
+
+	pthread_mutex_unlock(&v4l2_plugin_mutex);
+
+	return result;
+}
+
+LIBV4L_PUBLIC void libv4l2_set_plugindata(int fd, void *plugin_data)
+{
+	int index;
+
+	pthread_mutex_lock(&v4l2_plugin_mutex);
+	for (index = 0; index < V4L2_MAX_DEVICES; index++)
+		if (plugins[index].fd == fd)
+			break;
+
+	/* We have no info about this fd - reserve an empty slot */
+	if (index == V4L2_MAX_DEVICES) {
+		for (index = 0; index < V4L2_MAX_DEVICES; index++)
+			if (plugins[index].fd == -1)
+				break;
+	}
+	pthread_mutex_unlock(&v4l2_plugin_mutex);
+
+	if (index == V4L2_MAX_DEVICES) {
+		V4L2_LOG_ERR("store private data for more than %d plugins\n",
+			V4L2_MAX_DEVICES);
+		return;
+	}
+
+	pthread_mutex_lock(&v4l2_plugin_mutex);
+	plugins[index].fd = fd;
+	plugins[index].plugin_data = plugin_data;
+	pthread_mutex_unlock(&v4l2_plugin_mutex);
+}
+
+LIBV4L_PUBLIC void *libv4l2_get_plugindata(int fd)
+{
+	int index;
+	void *result = NULL;
+
+	pthread_mutex_lock(&v4l2_plugin_mutex);
+	for (index = 0; index < V4L2_MAX_DEVICES; index++)
+		if (plugins[index].fd == fd) {
+			result = plugins[index].plugin_data;
+			break;
+		}
+	pthread_mutex_unlock(&v4l2_plugin_mutex);
+
+	return result;
+}
diff --git a/lib/libv4l2/v4l2convert.c b/lib/libv4l2/v4l2convert.c
index e251085..9f28490 100644
--- a/lib/libv4l2/v4l2convert.c
+++ b/lib/libv4l2/v4l2convert.c
@@ -31,6 +31,7 @@
 #include "../libv4lconvert/libv4lsyscall-priv.h"
 #include <linux/videodev2.h>
 #include <libv4l2.h>
+#include "libv4l2-plugin.h"
 
 /* Check that open/read/mmap is not a define */
 #if defined open || defined read || defined mmap
@@ -45,10 +46,27 @@
 
 LIBV4L_PUBLIC int open(const char *file, int oflag, ...)
 {
-	int fd;
+	int fd, plugin_used;
 	struct v4l2_capability cap;
 	int v4l_device = 0;
 
+	if (oflag & O_CREAT) {
+		va_list ap;
+		mode_t mode;
+
+		va_start(ap, oflag);
+		mode = va_arg(ap, mode_t);
+
+		fd = v4l2_plugin_open(&plugin_used, file, oflag, mode);
+
+		va_end(ap);
+	} else {
+		fd = v4l2_plugin_open(&plugin_used, file, oflag, 0);
+	}
+
+	if (plugin_used)
+		return fd;
+
 	/* check if we're opening a video4linux2 device */
 	if (!strncmp(file, "/dev/video", 10) || !strncmp(file, "/dev/v4l/", 9)) {
 		/* Some apps open the device read only, but we need rw rights as the
-- 
1.7.3.1

