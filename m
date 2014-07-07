Return-path: <linux-media-owner@vger.kernel.org>
Received: from bay004-omc2s21.hotmail.com ([65.54.190.96]:49597 "EHLO
	BAY004-OMC2S21.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750911AbaGGH12 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 7 Jul 2014 03:27:28 -0400
Message-ID: <BAY176-W19A194B095C32CE30B0B8DA90D0@phx.gbl>
From: Divneil Wadhawan <divneil@outlook.com>
To: Hans Verkuil <hverkuil@xs4all.nl>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: RE: vb2_reqbufs() is not allowing more than VIDEO_MAX_FRAME
Date: Mon, 7 Jul 2014 12:57:27 +0530
In-Reply-To: <53B65C2E.9040503@xs4all.nl>
References: <BAY176-W18F88DAF5A1C8B5194F30DA94E0@phx.gbl>,<536A0709.5090605@xs4all.nl>,<BAY176-W38EDAC885E5441BBA2E0B2A94E0@phx.gbl>,<536A1A45.6080201@xs4all.nl>
 <BAY176-W960662BE81D5920B94F97A9350@phx.gbl>,<53B65C2E.9040503@xs4all.nl>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,


> include/media/davinci/vpfe_capture.h

It uses videobuf-dma-contig.h, so, I left it out.


> drivers/media/platform/vivi-core.c

Cannot find this one. Checked with find, in case it changed location, but couldn't.


> drivers/media/pci/saa7134/*

Updated.


Please find below the patch. I am hoping it's good to go.


Regards,

Divneil


>From 1792d75dc0f893a181d991a0b238bbd0ead945c1 Mon Sep 17 00:00:00 2001
From: Divneil Wadhawan <divneil.wadhawan@st.com>
Date: Mon, 7 Jul 2014 12:38:06 +0530
Subject: [PATCH] v4l2: vb2: replace VIDEO_MAX_FRAME with VB2_MAX_FRAME

- vb2 drivers to rely on VB2_MAX_FRAME.

- VB2_MAX_FRAME bumps the value to 64 from current 32

Change-Id: I3d7998898df43553486166c44b54524aac449deb
Signed-off-by: Divneil Wadhawan <divneil.wadhawan@st.com>
---
 drivers/media/pci/saa7134/saa7134-ts.c    |    4 ++--
 drivers/media/pci/saa7134/saa7134-vbi.c   |    4 ++--
 drivers/media/pci/saa7134/saa7134-video.c |    2 +-
 drivers/media/platform/mem2mem_testdev.c  |    2 +-
 drivers/media/platform/ti-vpe/vpe.c       |    2 +-
 drivers/media/v4l2-core/videobuf2-core.c  |    8 ++++----
 include/media/videobuf2-core.h            |    4 +++-
 7 files changed, 14 insertions(+), 12 deletions(-)

diff --git a/drivers/media/pci/saa7134/saa7134-ts.c b/drivers/media/pci/saa7134/saa7134-ts.c
index bd25323..0d04995 100644
--- a/drivers/media/pci/saa7134/saa7134-ts.c
+++ b/drivers/media/pci/saa7134/saa7134-ts.c
@@ -227,8 +227,8 @@ int saa7134_ts_init1(struct saa7134_dev *dev)
  /* sanitycheck insmod options */
  if (tsbufs < 2)
   tsbufs = 2;
- if (tsbufs> VIDEO_MAX_FRAME)
-  tsbufs = VIDEO_MAX_FRAME;
+ if (tsbufs> VB2_MAX_FRAME)
+  tsbufs = VB2_MAX_FRAME;
  if (ts_nr_packets < 4)
   ts_nr_packets = 4;
  if (ts_nr_packets> 312)
diff --git a/drivers/media/pci/saa7134/saa7134-vbi.c b/drivers/media/pci/saa7134/saa7134-vbi.c
index c06dbe1..15b5860 100644
--- a/drivers/media/pci/saa7134/saa7134-vbi.c
+++ b/drivers/media/pci/saa7134/saa7134-vbi.c
@@ -203,8 +203,8 @@ int saa7134_vbi_init1(struct saa7134_dev *dev)
 
  if (vbibufs < 2)
   vbibufs = 2;
- if (vbibufs> VIDEO_MAX_FRAME)
-  vbibufs = VIDEO_MAX_FRAME;
+ if (vbibufs> VB2_MAX_FRAME)
+  vbibufs = VB2_MAX_FRAME;
  return 0;
 }
 
diff --git a/drivers/media/pci/saa7134/saa7134-video.c b/drivers/media/pci/saa7134/saa7134-video.c
index d375999..47dda6c 100644
--- a/drivers/media/pci/saa7134/saa7134-video.c
+++ b/drivers/media/pci/saa7134/saa7134-video.c
@@ -2032,7 +2032,7 @@ int saa7134_video_init1(struct saa7134_dev *dev)
  int ret;
 
  /* sanitycheck insmod options */
- if (gbuffers < 2 || gbuffers> VIDEO_MAX_FRAME)
+ if (gbuffers < 2 || gbuffers> VB2_MAX_FRAME)
   gbuffers = 2;
  if (gbufsize> gbufsize_max)
   gbufsize = gbufsize_max;
diff --git a/drivers/media/platform/mem2mem_testdev.c b/drivers/media/platform/mem2mem_testdev.c
index 0714070..fe3235d 100644
--- a/drivers/media/platform/mem2mem_testdev.c
+++ b/drivers/media/platform/mem2mem_testdev.c
@@ -55,7 +55,7 @@ MODULE_PARM_DESC(debug, "activates debug info");
 #define MEM2MEM_NAME  "m2m-testdev"
 
 /* Per queue */
-#define MEM2MEM_DEF_NUM_BUFS VIDEO_MAX_FRAME
+#define MEM2MEM_DEF_NUM_BUFS VB2_MAX_FRAME
 /* In bytes, per queue */
 #define MEM2MEM_VID_MEM_LIMIT (16 * 1024 * 1024)
 
diff --git a/drivers/media/platform/ti-vpe/vpe.c b/drivers/media/platform/ti-vpe/vpe.c
index 972f43f..6b370ed 100644
--- a/drivers/media/platform/ti-vpe/vpe.c
+++ b/drivers/media/platform/ti-vpe/vpe.c
@@ -1970,7 +1970,7 @@ static const struct v4l2_ctrl_config vpe_bufs_per_job = {
  .type = V4L2_CTRL_TYPE_INTEGER,
  .def = VPE_DEF_BUFS_PER_JOB,
  .min = 1,
- .max = VIDEO_MAX_FRAME,
+ .max = VB2_MAX_FRAME,
  .step = 1,
 };
 
diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
index 7c4489c..09bc9bb 100644
--- a/drivers/media/v4l2-core/videobuf2-core.c
+++ b/drivers/media/v4l2-core/videobuf2-core.c
@@ -904,7 +904,7 @@ static int __reqbufs(struct vb2_queue *q, struct v4l2_requestbuffers *req)
  /*
   * Make sure the requested values and current defaults are sane.
   */
- num_buffers = min_t(unsigned int, req->count, VIDEO_MAX_FRAME);
+ num_buffers = min_t(unsigned int, req->count, VB2_MAX_FRAME);
  num_buffers = max_t(unsigned int, num_buffers, q->min_buffers_needed);
  memset(q->plane_sizes, 0, sizeof(q->plane_sizes));
  memset(q->alloc_ctx, 0, sizeof(q->alloc_ctx));
@@ -1005,7 +1005,7 @@ static int __create_bufs(struct vb2_queue *q, struct v4l2_create_buffers *create
  unsigned int num_planes = 0, num_buffers, allocated_buffers;
  int ret;
 
- if (q->num_buffers == VIDEO_MAX_FRAME) {
+ if (q->num_buffers == VB2_MAX_FRAME) {
   dprintk(1, "maximum number of buffers already allocated\n");
   return -ENOBUFS;
  }
@@ -1016,7 +1016,7 @@ static int __create_bufs(struct vb2_queue *q, struct v4l2_create_buffers *create
   q->memory = create->memory;
  }
 
- num_buffers = min(create->count, VIDEO_MAX_FRAME - q->num_buffers);
+ num_buffers = min(create->count, VB2_MAX_FRAME - q->num_buffers);
 
  /*
   * Ask the driver, whether the requested number of buffers, planes per
@@ -2686,7 +2686,7 @@ struct vb2_fileio_data {
  struct v4l2_requestbuffers req;
  struct v4l2_plane p;
  struct v4l2_buffer b;
- struct vb2_fileio_buf bufs[VIDEO_MAX_FRAME];
+ struct vb2_fileio_buf bufs[VB2_MAX_FRAME];
  unsigned int cur_index;
  unsigned int initial_index;
  unsigned int q_count;
diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
index 8fab6fa..3702a33 100644
--- a/include/media/videobuf2-core.h
+++ b/include/media/videobuf2-core.h
@@ -18,6 +18,8 @@
 #include <linux/videodev2.h>
 #include <linux/dma-buf.h>
 
+#define VB2_MAX_FRAME  64
+
 struct vb2_alloc_ctx;
 struct vb2_fileio_data;
 struct vb2_threadio_data;
@@ -395,7 +397,7 @@ struct vb2_queue {
 
 /* private: internal use only */
  enum v4l2_memory  memory;
- struct vb2_buffer  *bufs[VIDEO_MAX_FRAME];
+ struct vb2_buffer  *bufs[VB2_MAX_FRAME];
  unsigned int   num_buffers;
 
  struct list_head  queued_list;
-- 
1.7.6.5 		 	   		  