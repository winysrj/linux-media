Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:65156 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753666Ab2F3TYa (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 30 Jun 2012 15:24:30 -0400
Received: by mail-ee0-f46.google.com with SMTP id t10so1687663eei.19
        for <linux-media@vger.kernel.org>; Sat, 30 Jun 2012 12:24:29 -0700 (PDT)
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
To: linux-media@vger.kernel.org
Cc: posciak@google.com, andrzej.p@samsung.com, hans.verkuil@cisco.com,
	hdegoede@redhat.com, javier.martin@vista-silicon.com,
	jtp.park@samsung.com, kyungmin.park@samsung.com,
	k.debski@samsung.com, mchehab@infradead.org,
	m.szyprowski@samsung.com,
	Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Subject: [PATCH/RFC 1/2] V4L: Add capability flags for memory-to-memory devices
Date: Sat, 30 Jun 2012 21:23:42 +0200
Message-Id: <1341084223-4616-2-git-send-email-sylvester.nawrocki@gmail.com>
In-Reply-To: <1341084223-4616-1-git-send-email-sylvester.nawrocki@gmail.com>
References: <1341084223-4616-1-git-send-email-sylvester.nawrocki@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds new V4L2_CAP_VIDEO_M2M and V4L2_CAP_VIDEO_M2M_MPLANE capability
flags that are intended to be used for memory-to-memory (M2M) devices, instead
of ORed V4L2_CAP_VIDEO_CAPTURE and V4L2_CAP_VIDEO_OUTPUT.

V4L2_CAP_VIDEO_M2M flag is added at the drivers, CAPTURE and OUTPUT capability
flags are left untouched and will be removed in future, after a transition
period required for existing applications to be adapted to check only for
V4L2_CAP_VIDEO_M2M.

Signed-off-by: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
---
 Documentation/DocBook/media/v4l/compat.xml         |    9 +++++++++
 .../DocBook/media/v4l/vidioc-querycap.xml          |   13 +++++++++++++
 drivers/media/video/mem2mem_testdev.c              |    4 +---
 drivers/media/video/mx2_emmaprp.c                  |   10 +++++++---
 drivers/media/video/s5p-fimc/fimc-m2m.c            |    7 ++++++-
 drivers/media/video/s5p-g2d/g2d.c                  |    9 +++++++--
 drivers/media/video/s5p-jpeg/jpeg-core.c           |   10 +++++++---
 drivers/media/video/s5p-mfc/s5p_mfc_dec.c          |   10 ++++++++--
 drivers/media/video/s5p-mfc/s5p_mfc_enc.c          |   11 ++++++++---
 include/linux/videodev2.h                          |    4 ++++
 10 files changed, 70 insertions(+), 17 deletions(-)

diff --git a/Documentation/DocBook/media/v4l/compat.xml b/Documentation/DocBook/media/v4l/compat.xml
index ea42ef8..3ab6e0fc9 100644
--- a/Documentation/DocBook/media/v4l/compat.xml
+++ b/Documentation/DocBook/media/v4l/compat.xml
@@ -2458,6 +2458,15 @@ details.</para>
       </orderedlist>
     </section>
 
+    <section>
+      <title>V4L2 in Linux 3.6</title>
+      <orderedlist>
+        <listitem>
+	  <para>Added V4L2_CAP_VIDEO_M2M and V4L2_CAP_VIDEO_M2M_MPLANE capabilities.</para>
+        </listitem>
+      </orderedlist>
+    </section>
+
     <section id="other">
       <title>Relation of V4L2 to other Linux multimedia APIs</title>
 
diff --git a/Documentation/DocBook/media/v4l/vidioc-querycap.xml b/Documentation/DocBook/media/v4l/vidioc-querycap.xml
index 4643505..f33dd74 100644
--- a/Documentation/DocBook/media/v4l/vidioc-querycap.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-querycap.xml
@@ -192,6 +192,19 @@ linkend="output">Video Output</link> interface.</entry>
 	    <link linkend="output">Video Output</link> interface.</entry>
 	  </row>
 	  <row>
+	    <entry><constant>V4L2_CAP_VIDEO_M2M</constant></entry>
+	    <entry>0x00004000</entry>
+	    <entry>The device supports the single-planar API through the
+	    Video Memory-To-Memory interface.</entry>
+	  </row>
+	  <row>
+	    <entry><constant>V4L2_CAP_VIDEO_M2M_MPLANE</constant></entry>
+	    <entry>0x00008000</entry>
+	    <entry>The device supports the
+	    <link linkend="planar-apis">multi-planar API</link> through the
+	    Video Memory-To-Memory  interface.</entry>
+	  </row>
+	  <row>
 	    <entry><constant>V4L2_CAP_VIDEO_OVERLAY</constant></entry>
 	    <entry>0x00000004</entry>
 	    <entry>The device supports the <link
diff --git a/drivers/media/video/mem2mem_testdev.c b/drivers/media/video/mem2mem_testdev.c
index 3945556..a8fa79a 100644
--- a/drivers/media/video/mem2mem_testdev.c
+++ b/drivers/media/video/mem2mem_testdev.c
@@ -381,9 +381,7 @@ static int vidioc_querycap(struct file *file, void *priv,
 	strncpy(cap->driver, MEM2MEM_NAME, sizeof(cap->driver) - 1);
 	strncpy(cap->card, MEM2MEM_NAME, sizeof(cap->card) - 1);
 	cap->bus_info[0] = 0;
-	cap->capabilities = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_VIDEO_OUTPUT
-			  | V4L2_CAP_STREAMING;
-
+	cap->capabilities = V4L2_CAP_VIDEO_M2M | V4L2_CAP_STREAMING;
 	return 0;
 }
 
diff --git a/drivers/media/video/mx2_emmaprp.c b/drivers/media/video/mx2_emmaprp.c
index 0bd5815..5f8a6f5 100644
--- a/drivers/media/video/mx2_emmaprp.c
+++ b/drivers/media/video/mx2_emmaprp.c
@@ -396,9 +396,13 @@ static int vidioc_querycap(struct file *file, void *priv,
 {
 	strncpy(cap->driver, MEM2MEM_NAME, sizeof(cap->driver) - 1);
 	strncpy(cap->card, MEM2MEM_NAME, sizeof(cap->card) - 1);
-	cap->capabilities = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_VIDEO_OUTPUT
-			  | V4L2_CAP_STREAMING;
-
+	/*
+	 * This is only a mem-to-mem video device. The capture and output
+	 * device capability flags are left only for backward compatibility
+	 * and are scheduled for removal.
+	 */
+	cap->capabilities = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_VIDEO_OUTPUT |
+			    V4L2_CAP_VIDEO_M2M | V4L2_CAP_STREAMING;
 	return 0;
 }
 
diff --git a/drivers/media/video/s5p-fimc/fimc-m2m.c b/drivers/media/video/s5p-fimc/fimc-m2m.c
index 4c58e05..98b080e 100644
--- a/drivers/media/video/s5p-fimc/fimc-m2m.c
+++ b/drivers/media/video/s5p-fimc/fimc-m2m.c
@@ -259,7 +259,12 @@ static int fimc_m2m_querycap(struct file *file, void *fh,
 	strncpy(cap->driver, fimc->pdev->name, sizeof(cap->driver) - 1);
 	strncpy(cap->card, fimc->pdev->name, sizeof(cap->card) - 1);
 	cap->bus_info[0] = 0;
-	cap->capabilities = V4L2_CAP_STREAMING |
+	/*
+	 * This is only a mem-to-mem video device. The capture and output
+	 * device capability flags are left only for backward compatibility
+	 * and are scheduled for removal.
+	 */
+	cap->capabilities = V4L2_CAP_STREAMING | V4L2_CAP_VIDEO_M2M_MPLANE |
 		V4L2_CAP_VIDEO_CAPTURE_MPLANE | V4L2_CAP_VIDEO_OUTPUT_MPLANE;
 
 	return 0;
diff --git a/drivers/media/video/s5p-g2d/g2d.c b/drivers/media/video/s5p-g2d/g2d.c
index 7c98ee7..7c22004 100644
--- a/drivers/media/video/s5p-g2d/g2d.c
+++ b/drivers/media/video/s5p-g2d/g2d.c
@@ -290,8 +290,13 @@ static int vidioc_querycap(struct file *file, void *priv,
 	strncpy(cap->card, G2D_NAME, sizeof(cap->card) - 1);
 	cap->bus_info[0] = 0;
 	cap->version = KERNEL_VERSION(1, 0, 0);
-	cap->capabilities = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_VIDEO_OUTPUT
-							| V4L2_CAP_STREAMING;
+	/*
+	 * This is only a mem-to-mem video device. The capture and output
+	 * device capability flags are left only for backward compatibility
+	 * and are scheduled for removal.
+	 */
+	cap->capabilities = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_VIDEO_OUTPUT |
+			    V4L2_CAP_VIDEO_M2M | V4L2_CAP_STREAMING;
 	return 0;
 }
 
diff --git a/drivers/media/video/s5p-jpeg/jpeg-core.c b/drivers/media/video/s5p-jpeg/jpeg-core.c
index 28b5225d..2bde13f 100644
--- a/drivers/media/video/s5p-jpeg/jpeg-core.c
+++ b/drivers/media/video/s5p-jpeg/jpeg-core.c
@@ -489,9 +489,13 @@ static int s5p_jpeg_querycap(struct file *file, void *priv,
 			sizeof(cap->card));
 	}
 	cap->bus_info[0] = 0;
-	cap->capabilities = V4L2_CAP_STREAMING |
-			    V4L2_CAP_VIDEO_CAPTURE |
-			    V4L2_CAP_VIDEO_OUTPUT;
+	/*
+	 * This is only a mem-to-mem video device. The capture and output
+	 * device capability flags are left only for backward compatibility
+	 * and are scheduled for removal.
+	 */
+	cap->capabilities = V4L2_CAP_STREAMING | V4L2_CAP_VIDEO_M2M |
+			    V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_VIDEO_OUTPUT;
 	return 0;
 }
 
diff --git a/drivers/media/video/s5p-mfc/s5p_mfc_dec.c b/drivers/media/video/s5p-mfc/s5p_mfc_dec.c
index 4dd32fc..00fc4ac 100644
--- a/drivers/media/video/s5p-mfc/s5p_mfc_dec.c
+++ b/drivers/media/video/s5p-mfc/s5p_mfc_dec.c
@@ -220,8 +220,14 @@ static int vidioc_querycap(struct file *file, void *priv,
 	strncpy(cap->card, dev->plat_dev->name, sizeof(cap->card) - 1);
 	cap->bus_info[0] = 0;
 	cap->version = KERNEL_VERSION(1, 0, 0);
-	cap->capabilities = V4L2_CAP_VIDEO_CAPTURE_MPLANE |
-			V4L2_CAP_VIDEO_OUTPUT_MPLANE | V4L2_CAP_STREAMING;
+	/*
+	 * This is only a mem-to-mem video device. The capture and output
+	 * device capability flags are left only for backward compatibility
+	 * and are scheduled for removal.
+	 */
+	cap->capabilities = V4L2_CAP_VIDEO_M2M_MPLANE | V4L2_CAP_STREAMING |
+			    V4L2_CAP_VIDEO_CAPTURE_MPLANE |
+			    V4L2_CAP_VIDEO_OUTPUT_MPLANE;
 	return 0;
 }
 
diff --git a/drivers/media/video/s5p-mfc/s5p_mfc_enc.c b/drivers/media/video/s5p-mfc/s5p_mfc_enc.c
index 03d8334..b5ade31 100644
--- a/drivers/media/video/s5p-mfc/s5p_mfc_enc.c
+++ b/drivers/media/video/s5p-mfc/s5p_mfc_enc.c
@@ -779,9 +779,14 @@ static int vidioc_querycap(struct file *file, void *priv,
 	strncpy(cap->card, dev->plat_dev->name, sizeof(cap->card) - 1);
 	cap->bus_info[0] = 0;
 	cap->version = KERNEL_VERSION(1, 0, 0);
-	cap->capabilities = V4L2_CAP_VIDEO_CAPTURE_MPLANE
-			  | V4L2_CAP_VIDEO_OUTPUT_MPLANE
-			  | V4L2_CAP_STREAMING;
+	/*
+	 * This is only a mem-to-mem video device. The capture and output
+	 * device capability flags are left only for backward compatibility
+	 * and are scheduled for removal.
+	 */
+	cap->capabilities = V4L2_CAP_VIDEO_M2M_MPLANE | V4L2_CAP_STREAMING |
+			    V4L2_CAP_VIDEO_CAPTURE_MPLANE |
+			    V4L2_CAP_VIDEO_OUTPUT_MPLANE;
 	return 0;
 }
 
diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
index f79d0cc..b960c48 100644
--- a/include/linux/videodev2.h
+++ b/include/linux/videodev2.h
@@ -273,6 +273,10 @@ struct v4l2_capability {
 #define V4L2_CAP_VIDEO_CAPTURE_MPLANE	0x00001000
 /* Is a video output device that supports multiplanar formats */
 #define V4L2_CAP_VIDEO_OUTPUT_MPLANE	0x00002000
+/* Is a video mem-to-mem device that supports multiplanar formats */
+#define V4L2_CAP_VIDEO_M2M_MPLANE	0x00004000
+/* Is a video mem-to-mem device */
+#define V4L2_CAP_VIDEO_M2M		0x00008000
 
 #define V4L2_CAP_TUNER			0x00010000  /* has a tuner */
 #define V4L2_CAP_AUDIO			0x00020000  /* has audio support */
-- 
1.7.4.1

