Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:45214 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751794AbeE3N4V (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 30 May 2018 09:56:21 -0400
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org
Subject: [PATCH v2] media: dvb: get rid of VIDEO_SET_SPU_PALETTE
Date: Wed, 30 May 2018 10:56:14 -0300
Message-Id: <b19293fadb838db5f5a7f28a30cb952708fe22ef.1527688565.git.mchehab+samsung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

No upstream drivers use it. It doesn't make any sense to have
a compat32 code for something that nobody uses upstream.

Reported-by: Alexander Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
---
 .../media/uapi/dvb/video-set-spu-palette.rst  | 82 -------------------
 .../media/uapi/dvb/video_function_calls.rst   |  1 -
 Documentation/media/uapi/dvb/video_types.rst  | 18 ----
 Documentation/media/video.h.rst.exceptions    |  1 -
 fs/compat_ioctl.c                             | 30 -------
 include/uapi/linux/dvb/video.h                |  7 --
 6 files changed, 139 deletions(-)
 delete mode 100644 Documentation/media/uapi/dvb/video-set-spu-palette.rst

diff --git a/Documentation/media/uapi/dvb/video-set-spu-palette.rst b/Documentation/media/uapi/dvb/video-set-spu-palette.rst
deleted file mode 100644
index 51a1913d21d2..000000000000
--- a/Documentation/media/uapi/dvb/video-set-spu-palette.rst
+++ /dev/null
@@ -1,82 +0,0 @@
-.. -*- coding: utf-8; mode: rst -*-
-
-.. _VIDEO_SET_SPU_PALETTE:
-
-=====================
-VIDEO_SET_SPU_PALETTE
-=====================
-
-Name
-----
-
-VIDEO_SET_SPU_PALETTE
-
-.. attention:: This ioctl is deprecated.
-
-Synopsis
---------
-
-.. c:function:: int ioctl(fd, VIDEO_SET_SPU_PALETTE, struct video_spu_palette *palette )
-    :name: VIDEO_SET_SPU_PALETTE
-
-
-Arguments
----------
-
-.. flat-table::
-    :header-rows:  0
-    :stub-columns: 0
-
-
-    -  .. row 1
-
-       -  int fd
-
-       -  File descriptor returned by a previous call to open().
-
-    -  .. row 2
-
-       -  int request
-
-       -  Equals VIDEO_SET_SPU_PALETTE for this command.
-
-    -  .. row 3
-
-       -  video_spu_palette_t \*palette
-
-       -  SPU palette according to section ??.
-
-
-Description
------------
-
-This ioctl sets the SPU color palette.
-
-.. c:type:: video_spu_palette
-
-.. code-block::c
-
-	typedef struct video_spu_palette {      /* SPU Palette information */
-		int length;
-		__u8 __user *palette;
-	} video_spu_palette_t;
-
-Return Value
-------------
-
-On success 0 is returned, on error -1 and the ``errno`` variable is set
-appropriately. The generic error codes are described at the
-:ref:`Generic Error Codes <gen-errors>` chapter.
-
-
-
-.. flat-table::
-    :header-rows:  0
-    :stub-columns: 0
-
-
-    -  .. row 1
-
-       -  ``EINVAL``
-
-       -  input is not a valid palette or driver doesn’t handle SPU.
diff --git a/Documentation/media/uapi/dvb/video_function_calls.rst b/Documentation/media/uapi/dvb/video_function_calls.rst
index 68588ac7fecb..8d8383ffaeba 100644
--- a/Documentation/media/uapi/dvb/video_function_calls.rst
+++ b/Documentation/media/uapi/dvb/video_function_calls.rst
@@ -38,6 +38,5 @@ Video Function Calls
     video-set-system
     video-set-highlight
     video-set-spu
-    video-set-spu-palette
     video-get-navi
     video-set-attributes
diff --git a/Documentation/media/uapi/dvb/video_types.rst b/Documentation/media/uapi/dvb/video_types.rst
index 640a21de6b8a..4cfa00e5c934 100644
--- a/Documentation/media/uapi/dvb/video_types.rst
+++ b/Documentation/media/uapi/dvb/video_types.rst
@@ -320,24 +320,6 @@ to the following format:
      } video_spu_t;
 
 
-.. c:type:: video_spu_palette
-
-struct video_spu_palette
-========================
-
-The following structure is used to set the SPU palette by calling
-VIDEO_SPU_PALETTE:
-
-
-.. code-block:: c
-
-     typedef
-     struct video_spu_palette {
-	 int length;
-	 uint8_t *palette;
-     } video_spu_palette_t;
-
-
 .. c:type:: video_navi_pack
 
 struct video_navi_pack
diff --git a/Documentation/media/video.h.rst.exceptions b/Documentation/media/video.h.rst.exceptions
index a91aa884ce0e..89d7c3ef2da7 100644
--- a/Documentation/media/video.h.rst.exceptions
+++ b/Documentation/media/video.h.rst.exceptions
@@ -36,5 +36,4 @@ replace typedef video_stream_source_t :c:type:`video_stream_source`
 replace typedef video_play_state_t :c:type:`video_play_state`
 replace typedef video_highlight_t :c:type:`video_highlight`
 replace typedef video_spu_t :c:type:`video_spu`
-replace typedef video_spu_palette_t :c:type:`video_spu_palette`
 replace typedef video_navi_pack_t :c:type:`video_navi_pack`
diff --git a/fs/compat_ioctl.c b/fs/compat_ioctl.c
index ef80085ed564..6c36b931ca90 100644
--- a/fs/compat_ioctl.c
+++ b/fs/compat_ioctl.c
@@ -200,34 +200,6 @@ static int do_video_stillpicture(struct file *file,
 	return err;
 }
 
-struct compat_video_spu_palette {
-	int length;
-	compat_uptr_t palette;
-};
-
-static int do_video_set_spu_palette(struct file *file,
-		unsigned int cmd, struct compat_video_spu_palette __user *up)
-{
-	struct video_spu_palette __user *up_native;
-	compat_uptr_t palp;
-	int length, err;
-
-	err  = get_user(palp, &up->palette);
-	err |= get_user(length, &up->length);
-	if (err)
-		return -EFAULT;
-
-	up_native = compat_alloc_user_space(sizeof(struct video_spu_palette));
-	err  = put_user(compat_ptr(palp), &up_native->palette);
-	err |= put_user(length, &up_native->length);
-	if (err)
-		return -EFAULT;
-
-	err = do_ioctl(file, cmd, (unsigned long) up_native);
-
-	return err;
-}
-
 #ifdef CONFIG_BLOCK
 typedef struct sg_io_hdr32 {
 	compat_int_t interface_id;	/* [i] 'S' for SCSI generic (required) */
@@ -1349,8 +1321,6 @@ static long do_ioctl_trans(unsigned int cmd,
 		return do_video_get_event(file, cmd, argp);
 	case VIDEO_STILLPICTURE:
 		return do_video_stillpicture(file, cmd, argp);
-	case VIDEO_SET_SPU_PALETTE:
-		return do_video_set_spu_palette(file, cmd, argp);
 	}
 
 	/*
diff --git a/include/uapi/linux/dvb/video.h b/include/uapi/linux/dvb/video.h
index df3d7028c807..6a0c9757b7ba 100644
--- a/include/uapi/linux/dvb/video.h
+++ b/include/uapi/linux/dvb/video.h
@@ -186,12 +186,6 @@ typedef struct video_spu {
 } video_spu_t;
 
 
-typedef struct video_spu_palette {      /* SPU Palette information */
-	int length;
-	__u8 __user *palette;
-} video_spu_palette_t;
-
-
 typedef struct video_navi_pack {
 	int length;          /* 0 ... 1024 */
 	__u8 data[1024];
@@ -248,7 +242,6 @@ typedef __u16 video_attributes_t;
 #define VIDEO_SET_SYSTEM           _IO('o', 38)
 #define VIDEO_SET_HIGHLIGHT        _IOW('o', 39, video_highlight_t)
 #define VIDEO_SET_SPU              _IOW('o', 50, video_spu_t)
-#define VIDEO_SET_SPU_PALETTE      _IOW('o', 51, video_spu_palette_t)
 #define VIDEO_GET_NAVI             _IOR('o', 52, video_navi_pack_t)
 #define VIDEO_SET_ATTRIBUTES       _IO('o', 53)
 #define VIDEO_GET_SIZE             _IOR('o', 55, video_size_t)
-- 
2.17.0
