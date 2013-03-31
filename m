Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40451 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753833Ab3CaMof (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 31 Mar 2013 08:44:35 -0400
From: Hans de Goede <hdegoede@redhat.com>
To: hverkuil@xs4all.nl
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH 1/2] libng: Add a get_min_size function to the plugins
Date: Sun, 31 Mar 2013 14:48:04 +0200
Message-Id: <1364734085-4227-1-git-send-email-hdegoede@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 libng/grab-ng.h                |  1 +
 libng/plugins/drv0-bsd.c       |  8 +++++++
 libng/plugins/drv0-v4l2.tmpl.c | 49 ++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 58 insertions(+)

diff --git a/libng/grab-ng.h b/libng/grab-ng.h
index 2c73b79..32275e2 100644
--- a/libng/grab-ng.h
+++ b/libng/grab-ng.h
@@ -292,6 +292,7 @@ struct ng_vid_driver {
     char* (*get_devname)(void *handle);
     int   (*capabilities)(void *handle);
     struct ng_attribute* (*list_attrs)(void *handle);
+    void (*get_min_size)(void *handle, int *min_width, int *min_height);
 
     /* overlay */
     int   (*setupfb)(void *handle, struct ng_video_fmt *fmt, void *base);
diff --git a/libng/plugins/drv0-bsd.c b/libng/plugins/drv0-bsd.c
index 61774a7..d8eec47 100644
--- a/libng/plugins/drv0-bsd.c
+++ b/libng/plugins/drv0-bsd.c
@@ -77,6 +77,7 @@ static int     bsd_flags(void *handle);
 static struct ng_attribute* bsd_attrs(void *handle);
 static int     bsd_read_attr(struct ng_attribute*);
 static void    bsd_write_attr(struct ng_attribute*, int val);
+static void    bsd_get_min_size(void *hdl, int *min_width, int *min_height);
 
 static int   bsd_setupfb(void *handle, struct ng_video_fmt *fmt, void *base);
 static int   bsd_overlay(void *handle, struct ng_video_fmt *fmt, int x, int y,
@@ -103,6 +104,7 @@ struct ng_vid_driver bsd_driver = {
 
     capabilities:  bsd_flags,
     list_attrs:    bsd_attrs,
+    get_min_size:  bsd_get_min_size,
 
     setupfb:       bsd_setupfb,
     overlay:       bsd_overlay,
@@ -471,6 +473,12 @@ static struct ng_attribute* bsd_attrs(void *handle)
     return h->attr;
 }
 
+static void bsd_get_min_size(void *handle, int *min_width, int *min_height)
+{
+    *min_width = 32;
+    *min_height = 24;
+}
+
 /* ---------------------------------------------------------------------- */
 
 static int
diff --git a/libng/plugins/drv0-v4l2.tmpl.c b/libng/plugins/drv0-v4l2.tmpl.c
index 40dff35..88abb04 100644
--- a/libng/plugins/drv0-v4l2.tmpl.c
+++ b/libng/plugins/drv0-v4l2.tmpl.c
@@ -54,6 +54,7 @@ static int     v4l2_flags(void *handle);
 static struct ng_attribute* v4l2_attrs(void *handle);
 static int     v4l2_read_attr(struct ng_attribute*);
 static void    v4l2_write_attr(struct ng_attribute*, int val);
+static void    v4l2_get_min_size(void *hdl, int *min_width, int *min_height);
 
 /* overlay */
 static int   v4l2_setupfb(void *handle, struct ng_video_fmt *fmt, void *base);
@@ -87,6 +88,7 @@ struct v4l2_handle {
 
     /* device descriptions */
     int                         ninputs,nstds,nfmts;
+    unsigned int                min_width, min_height;
     struct v4l2_capability	cap;
     struct v4l2_streamparm	streamparm;
     struct v4l2_input		inp[MAX_INPUT];
@@ -131,6 +133,7 @@ struct ng_vid_driver v4l2_driver = {
     get_devname:   v4l2_devname,
     capabilities:  v4l2_flags,
     list_attrs:    v4l2_attrs,
+    get_min_size:  v4l2_get_min_size,
 
     setupfb:       v4l2_setupfb,
     overlay:       v4l2_overlay,
@@ -263,6 +266,41 @@ get_device_capabilities(struct v4l2_handle *h)
     }
 }
 
+static void
+find_min_size(struct v4l2_handle *h)
+{
+    int i;
+    struct v4l2_fmtdesc fmtdesc = { .type = V4L2_BUF_TYPE_VIDEO_CAPTURE };
+    struct v4l2_format fmt = { .type = V4L2_BUF_TYPE_VIDEO_CAPTURE };
+
+    if (xioctl(h->fd, VIDIOC_G_FMT, &fmt, 0)) {
+        h->min_width  = 32;
+        h->min_height = 24;
+        return;
+    }
+
+    h->min_width = -1;
+    h->min_height = -1;
+
+    for (i = 0; ; i++) {
+        fmtdesc.index = i;
+
+        if (xioctl(h->fd, VIDIOC_ENUM_FMT, &fmtdesc, 1))
+            break;
+
+        fmt.fmt.pix.pixelformat = fmtdesc.pixelformat;
+        fmt.fmt.pix.width = 32;
+        fmt.fmt.pix.height = 24;
+
+        if (xioctl(h->fd, VIDIOC_TRY_FMT, &fmt, 0) == 0) {
+            if (fmt.fmt.pix.width < h->min_width)
+                h->min_width = fmt.fmt.pix.width;
+            if (fmt.fmt.pix.height < h->min_height)
+                h->min_height = fmt.fmt.pix.height;
+        }
+    }
+}
+
 static struct STRTAB *
 build_norms(struct v4l2_handle *h)
 {
@@ -552,6 +590,10 @@ v4l2_open_handle(char *device, int req_flags)
 		h->cap.version         & 0xff,
 		h->cap.card,h->cap.bus_info);
     get_device_capabilities(h);
+    find_min_size(h);
+    if (ng_debug)
+	fprintf(stderr,"v4l2: device min size %ux%u\n",
+	        h->min_width, h->min_height);
 
     /* attributes */
     v4l2_add_attr(h, NULL, ATTR_ID_NORM,  build_norms(h));
@@ -644,6 +686,13 @@ static struct ng_attribute* v4l2_attrs(void *handle)
     return h->attr;
 }
 
+static void v4l2_get_min_size(void *handle, int *min_width, int *min_height)
+{
+    struct v4l2_handle *h = handle;
+    *min_width = h->min_width;
+    *min_height = h->min_height;
+}
+
 /* ---------------------------------------------------------------------- */
 
 static unsigned long
-- 
1.8.1.4

