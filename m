Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:30210 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933071Ab0CaJcs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 31 Mar 2010 05:32:48 -0400
Received: from eu_spt2 (mailout2.w1.samsung.com [210.118.77.12])
 by mailout2.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0L0500DZR3UJE4@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 31 Mar 2010 10:32:43 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0L0500K0V3UJ13@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 31 Mar 2010 10:32:43 +0100 (BST)
Date: Wed, 31 Mar 2010 11:32:27 +0200
From: Pawel Osciak <p.osciak@samsung.com>
Subject: [PATCH v2 3/3] v4l: Add documentation for the new error flag
In-reply-to: <1270027947-28327-1-git-send-email-p.osciak@samsung.com>
To: linux-media@vger.kernel.org
Cc: p.osciak@samsung.com, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com
Message-id: <1270027947-28327-4-git-send-email-p.osciak@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <1270027947-28327-1-git-send-email-p.osciak@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add documentation for V4L2_BUF_FLAG_ERROR.

Signed-off-by: Pawel Osciak <p.osciak@samsung.com>
---
 Documentation/DocBook/v4l/io.xml          |   10 ++++++++++
 Documentation/DocBook/v4l/vidioc-qbuf.xml |   14 ++++++++++++--
 2 files changed, 22 insertions(+), 2 deletions(-)

diff --git a/Documentation/DocBook/v4l/io.xml b/Documentation/DocBook/v4l/io.xml
index e870330..1bc2057 100644
--- a/Documentation/DocBook/v4l/io.xml
+++ b/Documentation/DocBook/v4l/io.xml
@@ -702,6 +702,16 @@ They can be both cleared however, then the buffer is in "dequeued"
 state, in the application domain to say so.</entry>
 	  </row>
 	  <row>
+	    <entry><constant>V4L2_BUF_FLAG_ERROR</constant></entry>
+	    <entry>0x0040</entry>
+	    <entry>When this flag is set, the buffer has been dequeued
+	    sucessfully, although the data might have been corrupted.
+	    This is recoverable, streaming may continue as normal and 
+	    the buffer may be reused normally. 
+	    Drivers set this flag when the <constant>VIDIOC_DQBUF</constant>
+	    ioctl is called.</entry>
+	  </row>
+	  <row>
 	    <entry><constant>V4L2_BUF_FLAG_KEYFRAME</constant></entry>
 	    <entry>0x0008</entry>
 	  <entry>Drivers set or clear this flag when calling the
diff --git a/Documentation/DocBook/v4l/vidioc-qbuf.xml b/Documentation/DocBook/v4l/vidioc-qbuf.xml
index b843bd7..ab691eb 100644
--- a/Documentation/DocBook/v4l/vidioc-qbuf.xml
+++ b/Documentation/DocBook/v4l/vidioc-qbuf.xml
@@ -111,7 +111,11 @@ from the driver's outgoing queue. They just set the
 and <structfield>reserved</structfield>
 fields of a &v4l2-buffer; as above, when <constant>VIDIOC_DQBUF</constant>
 is called with a pointer to this structure the driver fills the
-remaining fields or returns an error code.</para>
+remaining fields or returns an error code. The driver may also set
+<constant>V4L2_BUF_FLAG_ERROR</constant> in the <structfield>flags</structfield>
+field. It indicates a non-critical (recoverable) streaming error. In such case
+the application may continue as normal, but should be aware that data in the
+dequeued buffer might be corrupted.</para>
 
     <para>By default <constant>VIDIOC_DQBUF</constant> blocks when no
 buffer is in the outgoing queue. When the
@@ -158,7 +162,13 @@ enqueue a user pointer buffer.</para>
 	  <para><constant>VIDIOC_DQBUF</constant> failed due to an
 internal error. Can also indicate temporary problems like signal
 loss. Note the driver might dequeue an (empty) buffer despite
-returning an error, or even stop capturing.</para>
+returning an error, or even stop capturing. Reusing such buffer may be unsafe
+though and its details (e.g. <structfield>index</structfield>) may not be
+returned either. It is recommended that drivers indicate recoverable errors
+by setting the <constant>V4L2_BUF_FLAG_ERROR</constant> and returning 0 instead.
+In that case the application should be able to safely reuse the buffer and
+continue streaming.
+	</para>
 	</listitem>
       </varlistentry>
     </variablelist>
-- 
1.7.0.31.g1df487

