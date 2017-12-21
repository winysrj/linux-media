Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:57210 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753275AbdLUQSX (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 21 Dec 2017 11:18:23 -0500
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Seung-Woo Kim <sw0312.kim@samsung.com>,
        Geunyoung Kim <nenggun.kim@samsung.com>,
        Junghak Sung <jh1009.sung@samsung.com>,
        Satendra Singh Thakur <satendra.t@samsung.com>
Subject: [PATCH 09/11] media: dvb-core: get rid of mmap reserved field
Date: Thu, 21 Dec 2017 14:18:08 -0200
Message-Id: <f6aa3431948c8b8b4d08534e8d719b3b7d7b5a7d.1513872637.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1513872637.git.mchehab@s-opensource.com>
References: <cover.1513872637.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1513872637.git.mchehab@s-opensource.com>
References: <cover.1513872637.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The "reserved" field was a way, used at V4L2 API, to add new
data to existing structs without breaking userspace. However,
there are now clever ways of doing that, without needing to add
an uneeded overhead. So, get rid of them.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/media/uapi/dvb/dmx-expbuf.rst   | 2 --
 Documentation/media/uapi/dvb/dmx-qbuf.rst     | 2 --
 Documentation/media/uapi/dvb/dmx-querybuf.rst | 2 --
 Documentation/media/uapi/dvb/dmx-reqbufs.rst  | 2 --
 drivers/media/dvb-core/dvb_vb2.c              | 1 -
 include/uapi/linux/dvb/dmx.h                  | 3 ---
 6 files changed, 12 deletions(-)

diff --git a/Documentation/media/uapi/dvb/dmx-expbuf.rst b/Documentation/media/uapi/dvb/dmx-expbuf.rst
index 51df34c6fb59..2d96cfe891df 100644
--- a/Documentation/media/uapi/dvb/dmx-expbuf.rst
+++ b/Documentation/media/uapi/dvb/dmx-expbuf.rst
@@ -36,8 +36,6 @@ This ioctl is an extension to the memory mapping I/O method.
 It can be used to export a buffer as a DMABUF file at any time after
 buffers have been allocated with the :ref:`DMX_REQBUFS` ioctl.
 
-The ``reserved`` array must be zeroed before calling it.
-
 To export a buffer, applications fill struct :c:type:`dmx_exportbuffer`.
 Applications must set the ``index`` field. Valid index numbers
 range from zero to the number of buffers allocated with :ref:`DMX_REQBUFS`
diff --git a/Documentation/media/uapi/dvb/dmx-qbuf.rst b/Documentation/media/uapi/dvb/dmx-qbuf.rst
index b20b8153d48d..b48c4931658e 100644
--- a/Documentation/media/uapi/dvb/dmx-qbuf.rst
+++ b/Documentation/media/uapi/dvb/dmx-qbuf.rst
@@ -45,8 +45,6 @@ numbers range from zero to the number of buffers allocated with
 one. The contents of the struct :c:type:`dmx_buffer` returned
 by a :ref:`DMX_QUERYBUF` ioctl will do as well.
 
-The and ``reserved`` field must be set to 0.
-
 When ``DMX_QBUF`` is called with a pointer to this structure, it locks the
 memory pages of the buffer in physical memory, so they cannot be swapped
 out to disk. Buffers remain locked until dequeued, until the
diff --git a/Documentation/media/uapi/dvb/dmx-querybuf.rst b/Documentation/media/uapi/dvb/dmx-querybuf.rst
index 46a50f191b10..89481e24bb86 100644
--- a/Documentation/media/uapi/dvb/dmx-querybuf.rst
+++ b/Documentation/media/uapi/dvb/dmx-querybuf.rst
@@ -36,8 +36,6 @@ This ioctl is part of the mmap streaming I/O method. It can
 be used to query the status of a buffer at any time after buffers have
 been allocated with the :ref:`DMX_REQBUFS` ioctl.
 
-The ``reserved`` array must be zeroed before calling it.
-
 Applications set the ``index`` field. Valid index numbers range from zero
 to the number of buffers allocated with :ref:`DMX_REQBUFS`
 (struct :c:type:`dvb_requestbuffers` ``count``) minus one.
diff --git a/Documentation/media/uapi/dvb/dmx-reqbufs.rst b/Documentation/media/uapi/dvb/dmx-reqbufs.rst
index 0749623d9d83..14b80d60bf35 100644
--- a/Documentation/media/uapi/dvb/dmx-reqbufs.rst
+++ b/Documentation/media/uapi/dvb/dmx-reqbufs.rst
@@ -42,8 +42,6 @@ allocated by applications through a device driver, and this ioctl only
 configures the driver into DMABUF I/O mode without performing any direct
 allocation.
 
-The ``reserved`` array must be zeroed before calling it.
-
 To allocate device buffers applications initialize all fields of the
 struct :c:type:`dmx_requestbuffers` structure. They set the  ``count`` field
 to the desired number of buffers,  and ``size`` to the size of each
diff --git a/drivers/media/dvb-core/dvb_vb2.c b/drivers/media/dvb-core/dvb_vb2.c
index 277d33b83089..7b1663f64e84 100644
--- a/drivers/media/dvb-core/dvb_vb2.c
+++ b/drivers/media/dvb-core/dvb_vb2.c
@@ -140,7 +140,6 @@ static void _fill_dmx_buffer(struct vb2_buffer *vb, void *pb)
 	b->length = vb->planes[0].length;
 	b->bytesused = vb->planes[0].bytesused;
 	b->offset = vb->planes[0].m.offset;
-	memset(b->reserved, 0, sizeof(b->reserved));
 	dprintk(3, "[%s]\n", ctx->name);
 }
 
diff --git a/include/uapi/linux/dvb/dmx.h b/include/uapi/linux/dvb/dmx.h
index e212aa18ad78..5f3c5a918f00 100644
--- a/include/uapi/linux/dvb/dmx.h
+++ b/include/uapi/linux/dvb/dmx.h
@@ -229,7 +229,6 @@ struct dmx_buffer {
 	__u32			bytesused;
 	__u32			offset;
 	__u32			length;
-	__u32			reserved[4];
 };
 
 /**
@@ -244,7 +243,6 @@ struct dmx_buffer {
 struct dmx_requestbuffers {
 	__u32			count;
 	__u32			size;
-	__u32			reserved[2];
 };
 
 /**
@@ -266,7 +264,6 @@ struct dmx_exportbuffer {
 	__u32		index;
 	__u32		flags;
 	__s32		fd;
-	__u32		reserved[5];
 };
 
 #define DMX_START                _IO('o', 41)
-- 
2.14.3
