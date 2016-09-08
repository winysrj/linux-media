Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:43769 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932299AbcIHMES (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 8 Sep 2016 08:04:18 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Markus Heiser <markus.heiser@darmarit.de>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: [PATCH 06/47] [media] dtv-core.rst: move DTV ringbuffer notes to kAPI doc
Date: Thu,  8 Sep 2016 09:03:28 -0300
Message-Id: <ff72982c4ca8b8e0efdc4f83a8a7a68daae5bb65.1473334905.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1473334905.git.mchehab@s-opensource.com>
References: <cover.1473334905.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1473334905.git.mchehab@s-opensource.com>
References: <cover.1473334905.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Instead of keeping those notes at the file on a non-structured
way, move them to dtv-core.rst, using the proper ReST tags.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/media/kapi/dtv-core.rst   | 38 +++++++++++++++++++++++++++++++--
 drivers/media/dvb-core/dvb_ringbuffer.h | 28 ------------------------
 2 files changed, 36 insertions(+), 30 deletions(-)

diff --git a/Documentation/media/kapi/dtv-core.rst b/Documentation/media/kapi/dtv-core.rst
index 41df9f144fcb..a3c4642eabfc 100644
--- a/Documentation/media/kapi/dtv-core.rst
+++ b/Documentation/media/kapi/dtv-core.rst
@@ -6,8 +6,6 @@ Digital TV Common functions
 
 .. kernel-doc:: drivers/media/dvb-core/dvb_math.h
 
-.. kernel-doc:: drivers/media/dvb-core/dvb_ringbuffer.h
-
 .. kernel-doc:: drivers/media/dvb-core/dvbdev.h
 
 
@@ -18,6 +16,42 @@ Digital TV Common functions
 .. kernel-doc:: drivers/media/dvb-core/dvbdev.h
    :export: drivers/media/dvb-core/dvbdev.c
 
+Digital TV Ring buffer
+----------------------
+
+Those routines implement ring buffers used to handle digital TV data and
+copy it from/to userspace.
+
+.. note::
+
+  1) For performance reasons read and write routines don't check buffer sizes
+     and/or number of bytes free/available. This has to be done before these
+     routines are called. For example:
+
+   .. code-block:: c
+
+        /* write @buflen: bytes */
+        free = dvb_ringbuffer_free(rbuf);
+        if (free >= buflen)
+                count = dvb_ringbuffer_write(rbuf, buffer, buflen);
+        else
+                /* do something */
+
+        /* read min. 1000, max. @bufsize: bytes */
+        avail = dvb_ringbuffer_avail(rbuf);
+        if (avail >= 1000)
+                count = dvb_ringbuffer_read(rbuf, buffer, min(avail, bufsize));
+        else
+                /* do something */
+
+  2) If there is exactly one reader and one writer, there is no need
+     to lock read or write operations.
+     Two or more readers must be locked against each other.
+     Flushing the buffer counts as a read operation.
+     Resetting the buffer counts as a read and write operation.
+     Two or more writers must be locked against each other.
+
+.. kernel-doc:: drivers/media/dvb-core/dvb_ringbuffer.h
 
 
 Digital TV Frontend kABI
diff --git a/drivers/media/dvb-core/dvb_ringbuffer.h b/drivers/media/dvb-core/dvb_ringbuffer.h
index 8209eb4db2aa..f64bd86fe5fd 100644
--- a/drivers/media/dvb-core/dvb_ringbuffer.h
+++ b/drivers/media/dvb-core/dvb_ringbuffer.h
@@ -66,34 +66,6 @@ extern void dvb_ringbuffer_init(struct dvb_ringbuffer *rbuf, void *data,
  *
  * @rbuf: pointer to struct dvb_ringbuffer
  */
-/*
- * Notes:
- * ------
- * (1) For performance reasons read and write routines don't check buffer sizes
- *     and/or number of bytes free/available. This has to be done before these
- *     routines are called. For example:
- *
- *     *** write @buflen: bytes ***
- *     free = dvb_ringbuffer_free(rbuf);
- *     if (free >= buflen)
- *         count = dvb_ringbuffer_write(rbuf, buffer, buflen);
- *     else
- *         ...
- *
- *     *** read min. 1000, max. @bufsize: bytes ***
- *     avail = dvb_ringbuffer_avail(rbuf);
- *     if (avail >= 1000)
- *         count = dvb_ringbuffer_read(rbuf, buffer, min(avail, bufsize));
- *     else
- *         ...
- *
- * (2) If there is exactly one reader and one writer, there is no need
- *     to lock read or write operations.
- *     Two or more readers must be locked against each other.
- *     Flushing the buffer counts as a read operation.
- *     Resetting the buffer counts as a read and write operation.
- *     Two or more writers must be locked against each other.
- */
 extern int dvb_ringbuffer_empty(struct dvb_ringbuffer *rbuf);
 
 /**
-- 
2.7.4


