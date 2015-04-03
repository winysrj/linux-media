Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:37041 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752892AbbDCMHM (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 3 Apr 2015 08:07:12 -0400
Received: by wiaa2 with SMTP id a2so137754549wia.0
        for <linux-media@vger.kernel.org>; Fri, 03 Apr 2015 05:07:10 -0700 (PDT)
From: Benjamin Gaignard <benjamin.gaignard@linaro.org>
To: linux-media@vger.kernel.org, hverkuil@xs4all.nl
Cc: paramanand.singh@linaro.org,
	Benjamin Gaignard <benjamin.gaignard@linaro.org>
Subject: [PATCH] libv4l2: Changes for compilation in Android 5.0
Date: Fri,  3 Apr 2015 14:06:33 +0200
Message-Id: <1428062793-31882-1-git-send-email-benjamin.gaignard@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Added Android makefiles for libv4l2 and libv4lconvert.
Minor changes to include android-config.h.
Changed the plugin loading mechanism to avoid using
unsupported glob.h header.
Current mechanism supports a list of plugin search paths
including /system/lib and /vendor/lib.

Signed-off-by: Paramanand Singh <paramanand.singh@linaro.org>
---
 android-config.h                          |   3 +
 lib/Android.mk                            |   4 +
 lib/libv4l2/Android.mk                    |  31 ++++++
 lib/libv4l2/libv4l2.c                     |   4 +
 lib/libv4l2/log.c                         |   4 +
 lib/libv4l2/v4l2-plugin-android.c         | 153 ++++++++++++++++++++++++++++++
 lib/libv4l2/v4l2convert.c                 |   7 +-
 lib/libv4lconvert/Android.mk              |  53 +++++++++++
 lib/libv4lconvert/control/libv4lcontrol.c |   8 +-
 lib/libv4lconvert/jl2005bcd.c             |   6 +-
 lib/libv4lconvert/jpeg.c                  |   4 +
 lib/libv4lconvert/jpeg_memsrcdest.c       |   4 +
 lib/libv4lconvert/libv4lconvert-priv.h    |   4 +
 lib/libv4lconvert/libv4lconvert.c         |   4 +
 lib/libv4lconvert/libv4lsyscall-priv.h    |   6 +-
 15 files changed, 289 insertions(+), 6 deletions(-)
 create mode 100644 lib/Android.mk
 create mode 100644 lib/libv4l2/Android.mk
 create mode 100644 lib/libv4l2/v4l2-plugin-android.c
 create mode 100644 lib/libv4lconvert/Android.mk

diff --git a/android-config.h b/android-config.h
index f474330..9f12b8f 100644
--- a/android-config.h
+++ b/android-config.h
@@ -1,3 +1,5 @@
+#ifndef __V4L_ANDROID_CONFIG_H__
+#define __V4L_ANDROID_CONFIG_H__
 /* config.h.  Generated from config.h.in by configure.  */
 /* config.h.in.  Generated from configure.ac by autoheader.  */
 
@@ -358,3 +360,4 @@ getsubopt (char **optionp, char *const *tokens, char **valuep)
 
   return -1;
 }
+#endif
diff --git a/lib/Android.mk b/lib/Android.mk
new file mode 100644
index 0000000..2e43120
--- /dev/null
+++ b/lib/Android.mk
@@ -0,0 +1,4 @@
+LOCAL_PATH:= $(call my-dir)
+include $(CLEAR_VARS)
+
+include $(call all-makefiles-under,$(LOCAL_PATH))
diff --git a/lib/libv4l2/Android.mk b/lib/libv4l2/Android.mk
new file mode 100644
index 0000000..7d723fb
--- /dev/null
+++ b/lib/libv4l2/Android.mk
@@ -0,0 +1,31 @@
+LOCAL_PATH:= $(call my-dir)
+
+include $(CLEAR_VARS)
+
+LOCAL_SRC_FILES := \
+    log.c \
+    libv4l2.c \
+    v4l2convert.c \
+    v4l2-plugin-android.c
+
+LOCAL_CFLAGS += -Wno-missing-field-initializers
+LOCAL_CFLAGS += -Wno-sign-compare
+
+LOCAL_C_INCLUDES := \
+    $(LOCAL_PATH)/../include \
+    $(LOCAL_PATH)/../../include \
+    $(LOCAL_PATH)/../.. \
+	$(TOP)/bionic/libc/upstream-openbsd/lib/libc/gen
+
+LOCAL_SHARED_LIBRARIES := \
+    libutils \
+    libcutils \
+    libdl \
+    libssl \
+    libz
+
+LOCAL_STATIC_LIBRARIES := libv4l_convert
+LOCAL_MODULE := libv4l2
+LOCAL_MODULE_TAGS := optional
+
+include $(BUILD_SHARED_LIBRARY)
diff --git a/lib/libv4l2/libv4l2.c b/lib/libv4l2/libv4l2.c
index 966a000..70a6fd2 100644
--- a/lib/libv4l2/libv4l2.c
+++ b/lib/libv4l2/libv4l2.c
@@ -55,7 +55,11 @@
    When modifications are made, one should be careful that this behavior is
    preserved.
  */
+#ifdef ANDROID
+#include <android-config.h>
+#else
 #include <config.h>
+#endif
 #include <errno.h>
 #include <stdarg.h>
 #include <stdio.h>
diff --git a/lib/libv4l2/log.c b/lib/libv4l2/log.c
index d1042ed..9d3eab1 100644
--- a/lib/libv4l2/log.c
+++ b/lib/libv4l2/log.c
@@ -18,7 +18,11 @@
 # Foundation, Inc., 51 Franklin Street, Suite 500, Boston, MA  02110-1335  USA
  */
 
+#ifdef ANDROID
+#include <android-config.h>
+#else
 #include <config.h>
+#endif
 #include <stdio.h>
 #include <stdlib.h>
 #include <string.h>
diff --git a/lib/libv4l2/v4l2-plugin-android.c b/lib/libv4l2/v4l2-plugin-android.c
new file mode 100644
index 0000000..af7f4ae
--- /dev/null
+++ b/lib/libv4l2/v4l2-plugin-android.c
@@ -0,0 +1,153 @@
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
+#ifdef ANDROID
+#include <android-config.h>
+#else
+#include <config.h>
+#endif
+#include <stdarg.h>
+#include <dlfcn.h>
+#include <fcntl.h>
+#include <glob.h>
+#include <sys/stat.h>
+#include <sys/mman.h>
+#include <sys/types.h>
+#include <dirent.h>
+#include <stdlib.h>
+#include <string.h>
+#include "libv4l2.h"
+#include "libv4l2-priv.h"
+#include "libv4l-plugin.h"
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
+/* list of plugin search paths */
+static const char *g_plugin_search_paths[] = {
+	"/system/lib/libv4l/plugins",
+	"/vendor/lib/libv4l/plugins",
+	NULL /* list terminator */
+};
+
+void v4l2_plugin_init(int fd, void **plugin_lib_ret, void **plugin_priv_ret,
+			  const struct libv4l_dev_ops **dev_ops_ret)
+{
+	char *error;
+	void *plugin_library = NULL;
+	const struct libv4l_dev_ops *libv4l2_plugin = NULL;
+	DIR *plugin_dir = NULL;
+	struct dirent *entry;
+	char *suffix = NULL;
+	int length, i;
+	char filename[256];
+
+	/* initialize output params */
+	*dev_ops_ret = v4lconvert_get_default_dev_ops();
+	*plugin_lib_ret = NULL;
+	*plugin_priv_ret = NULL;
+
+	/* read the plugin directory for "*.so" files */
+	for (i = 0; g_plugin_search_paths[i] != NULL; i++) {
+		plugin_dir = opendir(g_plugin_search_paths[i]);
+		if (plugin_dir == NULL) {
+			V4L2_LOG_ERR("PLUGIN: opening plugin directory (%s) failed\n",
+				g_plugin_search_paths[i]);
+			continue;
+		}
+
+		while (entry = readdir(plugin_dir)) {
+			/* get last 3 letter suffix from the filename */
+			length = strlen(entry->d_name);
+			if (length > 3)
+				suffix = entry->d_name + (length - 3);
+
+			if (!suffix || strcmp(suffix, ".so")) {
+				suffix = NULL; /* reset for next iteration */
+				continue;
+			}
+
+			/* load library and get desired symbol */
+			sprintf(filename, "%s/%s", g_plugin_search_paths[i], entry->d_name);
+			V4L2_LOG("PLUGIN: dlopen(%s);\n", filename);
+			plugin_library = dlopen(filename, RTLD_LAZY);
+			if (!plugin_library)
+				continue;
+
+			dlerror(); /* Clear any existing error */
+			libv4l2_plugin = (struct libv4l_dev_ops *)
+				dlsym(plugin_library, "libv4l2_plugin");
+			error = dlerror();
+			if (error != NULL) {
+				V4L2_LOG_ERR("PLUGIN: dlsym failed: %s\n", error);
+				dlclose(plugin_library);
+				continue;
+			}
+
+			if (!libv4l2_plugin->init ||
+				!libv4l2_plugin->close ||
+				!libv4l2_plugin->ioctl) {
+				V4L2_LOG("PLUGIN: does not have all mandatory ops\n");
+				dlclose(plugin_library);
+				continue;
+			}
+
+			*plugin_priv_ret = libv4l2_plugin->init(fd);
+			if (!*plugin_priv_ret) {
+				V4L2_LOG("PLUGIN: plugin open() returned NULL\n");
+				dlclose(plugin_library);
+				continue;
+			}
+
+			/* exit loop when a suitable plugin is found */
+			*plugin_lib_ret = plugin_library;
+			*dev_ops_ret = libv4l2_plugin;
+			break;
+		}
+		closedir(plugin_dir);
+
+		/* exit loop when a suitable plugin is found */
+		if (*plugin_lib_ret && *plugin_priv_ret && *dev_ops_ret)
+			break;
+	}
+}
+
+void v4l2_plugin_cleanup(void *plugin_lib, void *plugin_priv,
+			 const struct libv4l_dev_ops *dev_ops)
+{
+	if (plugin_lib) {
+		dev_ops->close(plugin_priv);
+		dlclose(plugin_lib);
+	}
+}
diff --git a/lib/libv4l2/v4l2convert.c b/lib/libv4l2/v4l2convert.c
index 9b46ab8..d046834 100644
--- a/lib/libv4l2/v4l2convert.c
+++ b/lib/libv4l2/v4l2convert.c
@@ -25,7 +25,11 @@
 
 #define _LARGEFILE64_SOURCE 1
 
+#ifdef ANDROID
+#include <android-config.h>
+#else
 #include <config.h>
+#endif
 #include <stdarg.h>
 #include <stdlib.h>
 #include <fcntl.h>
@@ -111,6 +115,7 @@ LIBV4L_PUBLIC int open64(const char *file, int oflag, ...)
 }
 #endif
 
+#ifndef ANDROID
 LIBV4L_PUBLIC int close(int fd)
 {
 	return v4l2_close(fd);
@@ -156,4 +161,4 @@ LIBV4L_PUBLIC int munmap(void *start, size_t length)
 {
 	return v4l2_munmap(start, length);
 }
-
+#endif
diff --git a/lib/libv4lconvert/Android.mk b/lib/libv4lconvert/Android.mk
new file mode 100644
index 0000000..99a136b
--- /dev/null
+++ b/lib/libv4lconvert/Android.mk
@@ -0,0 +1,53 @@
+LOCAL_PATH:= $(call my-dir)
+
+include $(CLEAR_VARS)
+
+LOCAL_SRC_FILES := \
+    bayer.c \
+    cpia1.c \
+    crop.c \
+    flip.c \
+    helper.c \
+    hm12.c \
+    jidctflt.c \
+    jl2005bcd.c \
+    jpeg.c \
+    jpeg_memsrcdest.c \
+    jpgl.c \
+    libv4lconvert.c \
+    mr97310a.c \
+    pac207.c \
+    rgbyuv.c \
+    se401.c \
+    sn9c10x.c \
+    sn9c2028-decomp.c \
+    sn9c20x.c \
+    spca501.c \
+    spca561-decompress.c \
+    sq905c.c \
+    stv0680.c \
+    tinyjpeg.c \
+    control/libv4lcontrol.c \
+    processing/autogain.c  \
+    processing/gamma.c \
+    processing/libv4lprocessing.c  \
+    processing/whitebalance.c \
+
+LOCAL_CFLAGS += -Wno-missing-field-initializers
+LOCAL_CFLAGS += -Wno-sign-compare
+
+LOCAL_C_INCLUDES := \
+    $(LOCAL_PATH)/../include \
+    $(LOCAL_PATH)/../../include \
+    $(LOCAL_PATH)/../.. \
+
+LOCAL_SHARED_LIBRARIES := \
+    libutils \
+    libcutils \
+    libdl \
+    libz
+
+LOCAL_MODULE := libv4l_convert
+LOCAL_MODULE_TAGS := optional
+
+include $(BUILD_STATIC_LIBRARY)
diff --git a/lib/libv4lconvert/control/libv4lcontrol.c b/lib/libv4lconvert/control/libv4lcontrol.c
index 9916e02..7e92f88 100644
--- a/lib/libv4lconvert/control/libv4lcontrol.c
+++ b/lib/libv4lconvert/control/libv4lcontrol.c
@@ -362,7 +362,7 @@ static int v4lcontrol_get_usb_info(struct v4lcontrol_data *data,
 		int *speed)
 {
 	FILE *f;
-	int i, minor;
+	int i, minor_dev;
 	struct stat st;
 	char sysfs_name[512];
 	char c, *s, buf[32];
@@ -388,8 +388,8 @@ static int v4lcontrol_get_usb_info(struct v4lcontrol_data *data,
 		s = fgets(buf, sizeof(buf), f);
 		fclose(f);
 
-		if (s && sscanf(buf, "%*d:%d%c", &minor, &c) == 2 &&
-		    c == '\n' && minor == minor(st.st_rdev))
+		if (s && sscanf(buf, "%*d:%d%c", &minor_dev, &c) == 2 &&
+		    c == '\n' && minor_dev == minor(st.st_rdev))
 			break;
 	}
 	if (i == 256)
@@ -716,6 +716,7 @@ struct v4lcontrol_data *v4lcontrol_create(int fd, void *dev_ops_priv,
 		if (shm_name[i] == '/')
 			shm_name[i] = '-';
 
+#ifndef ANDROID
 	/* Open the shared memory object identified by shm_name */
 	shm_fd = shm_open(shm_name, (O_CREAT | O_EXCL | O_RDWR), (S_IREAD | S_IWRITE));
 	if (shm_fd >= 0)
@@ -738,6 +739,7 @@ struct v4lcontrol_data *v4lcontrol_create(int fd, void *dev_ops_priv,
 		}
 	} else
 		perror("libv4lcontrol: error creating shm segment failed");
+#endif
 
 	/* Fall back to malloc */
 	if (data->shm_values == NULL) {
diff --git a/lib/libv4lconvert/jl2005bcd.c b/lib/libv4lconvert/jl2005bcd.c
index 14171a1..5a29830 100644
--- a/lib/libv4lconvert/jl2005bcd.c
+++ b/lib/libv4lconvert/jl2005bcd.c
@@ -23,7 +23,11 @@
  * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
  */
 
-#include <config.h>
+#ifdef ANDROID
+#include <android-config.h>
+#else
+#include <config.h>
+#endif
 #include <stdlib.h>
 #include <string.h>
 
diff --git a/lib/libv4lconvert/jpeg.c b/lib/libv4lconvert/jpeg.c
index 0142d44..15f8dec 100644
--- a/lib/libv4lconvert/jpeg.c
+++ b/lib/libv4lconvert/jpeg.c
@@ -16,7 +16,11 @@
 # Foundation, Inc., 51 Franklin Street, Suite 500, Boston, MA  02110-1335  USA
  */
 
+#ifdef ANDROID
+#include <android-config.h>
+#else
 #include <config.h>
+#endif
 #include <errno.h>
 #include <stdlib.h>
 #include "libv4lconvert-priv.h"
diff --git a/lib/libv4lconvert/jpeg_memsrcdest.c b/lib/libv4lconvert/jpeg_memsrcdest.c
index b70af8e..323e7af 100644
--- a/lib/libv4lconvert/jpeg_memsrcdest.c
+++ b/lib/libv4lconvert/jpeg_memsrcdest.c
@@ -16,7 +16,11 @@
 
 /* this is not a core library module, so it doesn't define JPEG_INTERNALS */
 
+#ifdef ANDROID
+#include <android-config.h>
+#else
 #include <config.h>
+#endif
 #include <stdlib.h>
 #include <stdio.h>
 
diff --git a/lib/libv4lconvert/libv4lconvert-priv.h b/lib/libv4lconvert/libv4lconvert-priv.h
index ac1391e..c19bbd4 100644
--- a/lib/libv4lconvert/libv4lconvert-priv.h
+++ b/lib/libv4lconvert/libv4lconvert-priv.h
@@ -19,7 +19,11 @@
 #ifndef __LIBV4LCONVERT_PRIV_H
 #define __LIBV4LCONVERT_PRIV_H
 
+#ifdef ANDROID
+#include <android-config.h>
+#else
 #include <config.h>
+#endif
 #include <stdio.h>
 #include <stdint.h>
 #include <sys/types.h>
diff --git a/lib/libv4lconvert/libv4lconvert.c b/lib/libv4lconvert/libv4lconvert.c
index e4aa54a..004dc72 100644
--- a/lib/libv4lconvert/libv4lconvert.c
+++ b/lib/libv4lconvert/libv4lconvert.c
@@ -16,7 +16,11 @@
 # Foundation, Inc., 51 Franklin Street, Suite 500, Boston, MA  02110-1335  USA
  */
 
+#ifdef ANDROID
+#include <android-config.h>
+#else
 #include <config.h>
+#endif
 #include <errno.h>
 #include <string.h>
 #include <stdlib.h>
diff --git a/lib/libv4lconvert/libv4lsyscall-priv.h b/lib/libv4lconvert/libv4lsyscall-priv.h
index cdd38bc..f548fb2 100644
--- a/lib/libv4lconvert/libv4lsyscall-priv.h
+++ b/lib/libv4lconvert/libv4lsyscall-priv.h
@@ -36,7 +36,7 @@
 
 #ifdef linux
 #include <sys/time.h>
-#include <syscall.h>
+#include <sys/syscall.h>
 #include <linux/types.h>
 #include <linux/ioctl.h>
 /* On 32 bits archs we always use mmap2, on 64 bits archs there is no mmap2 */
@@ -62,6 +62,10 @@
 typedef off_t __off_t;
 #endif
 
+#if defined(ANDROID)
+typedef off_t __off_t;
+#endif
+
 #undef SYS_OPEN
 #undef SYS_CLOSE
 #undef SYS_IOCTL
-- 
1.9.1

