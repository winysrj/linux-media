Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx.fr.smartjog.net ([95.81.144.3]:33356 "EHLO
	mx.fr.smartjog.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932772Ab1JZOfK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 26 Oct 2011 10:35:10 -0400
Message-ID: <4EA816E2.8080607@smartjog.com>
Date: Wed, 26 Oct 2011 16:19:14 +0200
From: Laurent Defert <laurent.defert@smartjog.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: [PATCH] [media] compat_ioctl: add compat handler for FE_SET_PROPERTY
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

You'll find below a patch that implements the FE_SET_PROPERTY ioctl 
compat code. This code is reached  when a 32 bit application does the 
ioctl on a 64 bit kernel.
There are other dvb ioctl that are missing from the compat layer 
(FE_GET_PROPERTY and  FE_SET_FRONTEND_TUNE_MODE), if this patch is ok, 
i'm going to write them as well.

Laurent

commit 6647fda45d70d1947f2dff06c485aa64d78357d7
Author: Laurent Defert <laurent.defert@smartjog.com>
Date:   Wed Oct 26 14:32:29 2011 +0200

[media] compat_ioctl: add compat handler for FE_SET_PROPERTY

fixes following error seen on x86_64 kernel:
ioctl32(dvblast:6973): Unknown cmd fd(3) cmd(40086f52){t:'o';sz:8} 
arg(0805a318) on /dev/dvb/adapter0/frontend0

The argument (struct dtv_properties) contains a pointer to an array of 
struct dtv_property.
Both struct are converted to have proper pointer size.

Signed-off-by: Laurent Defert <laurent.defert@smartjog.com>

diff --git a/fs/compat_ioctl.c b/fs/compat_ioctl.c
index 51352de..6b89ff0 100644
--- a/fs/compat_ioctl.c
+++ b/fs/compat_ioctl.c
@@ -222,6 +222,84 @@ static int do_video_set_spu_palette(unsigned int 
fd, unsigned int cmd,
      return err;
  }

+struct compat_dtv_property {
+    __u32 cmd;
+    __u32 reserved[3];
+    union {
+        __u32 data;
+        struct {
+            __u8 data[32];
+            __u32 len;
+            __u32 reserved1[3];
+            compat_uptr_t reserved2;
+        } buffer;
+    } u;
+    int result;
+};
+
+struct compat_dtv_properties {
+    __u32 num;
+    compat_uptr_t props;
+};
+
+#define FE_SET_PROPERTY32    _IOW('o', 82, struct compat_dtv_properties)
+
+static int do_fe_set_property(unsigned int fd, unsigned int cmd,
+        struct compat_dtv_properties __user *dtv32)
+{
+    struct dtv_properties __user *dtv;
+    struct dtv_property __user *properties;
+    struct compat_dtv_property __user *properties32;
+    compat_uptr_t data;
+
+    int err;
+    int i;
+    __u32 num;
+
+    err = get_user(num, &dtv32->num);
+    err |= get_user(data, &dtv32->props);
+
+    if(err)
+        return -EFAULT;
+
+    dtv = compat_alloc_user_space(sizeof(struct dtv_properties) +
+                    sizeof(struct dtv_property) * num);
+    properties = (struct dtv_property*)((char*)dtv +
+                    sizeof(struct dtv_properties));
+
+    err = put_user(properties, &dtv->props);
+    err |= put_user(num, &dtv->num);
+
+    properties32 = compat_ptr(data);
+
+    if(err)
+        return -EFAULT;
+
+    for(i = 0; i < num; i++) {
+        compat_uptr_t reserved2;
+
+        err |= copy_in_user(&properties[i], &properties32[i],
+                (8 * sizeof(__u32)) + (32 * sizeof(__u8)));
+        err |= get_user(reserved2, &properties32[i].u.buffer.reserved2);
+        err |= put_user(compat_ptr(reserved2),
+ &properties[i].u.buffer.reserved2);
+    }
+
+    if(err)
+        return -EFAULT;
+
+    err = sys_ioctl(fd, FE_SET_PROPERTY, (unsigned long) dtv);
+
+    for(i = 0; i < num; i++) {
+        if(copy_in_user(&properties[i].result, &properties32[i].result,
+                                sizeof(int)))
+            return -EFAULT;
+    }
+
+    return err;
+}
+
+
  #ifdef CONFIG_BLOCK
  typedef struct sg_io_hdr32 {
      compat_int_t interface_id;    /* [i] 'S' for SCSI generic 
(required) */
@@ -1470,6 +1548,8 @@ static long do_ioctl_trans(int fd, unsigned int cmd,
          return do_video_stillpicture(fd, cmd, argp);
      case VIDEO_SET_SPU_PALETTE:
          return do_video_set_spu_palette(fd, cmd, argp);
+    case FE_SET_PROPERTY32:
+        return do_fe_set_property(fd, cmd, argp);
      }

      /*

