Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:56247 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752529AbdK2MIQ (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 29 Nov 2017 07:08:16 -0500
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH 4/7] media: davinci: fix kernel-doc warnings
Date: Wed, 29 Nov 2017 07:08:07 -0500
Message-Id: <a62cc016ab4e397cd822d80967dd840c7dc40d40.1511952403.git.mchehab@s-opensource.com>
In-Reply-To: <c73fcbc4af259923feac19eda4bb5e996b6de0fd.1511952403.git.mchehab@s-opensource.com>
References: <c73fcbc4af259923feac19eda4bb5e996b6de0fd.1511952403.git.mchehab@s-opensource.com>
In-Reply-To: <c73fcbc4af259923feac19eda4bb5e996b6de0fd.1511952403.git.mchehab@s-opensource.com>
References: <c73fcbc4af259923feac19eda4bb5e996b6de0fd.1511952403.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There are several of kernel-doc warnings:

    drivers/media/platform/davinci/vpif_display.c:114: warning: No description found for parameter 'sizes'
    drivers/media/platform/davinci/vpif_display.c:165: warning: No description found for parameter 'vq'
    drivers/media/platform/davinci/vpif_display.c:165: warning: Excess function parameter 'vb' description in 'vpif_start_streaming'
    drivers/media/platform/davinci/vpif_display.c:780: warning: No description found for parameter 'vpif_cfg'
    drivers/media/platform/davinci/vpif_display.c:780: warning: No description found for parameter 'chan_cfg'
    drivers/media/platform/davinci/vpif_display.c:780: warning: No description found for parameter 'index'
    drivers/media/platform/davinci/vpif_display.c:813: warning: No description found for parameter 'vpif_cfg'
    drivers/media/platform/davinci/vpif_display.c:813: warning: No description found for parameter 'ch'
    drivers/media/platform/davinci/vpif_display.c:813: warning: No description found for parameter 'index'
    drivers/media/platform/davinci/vpif_capture.c:121: warning: No description found for parameter 'sizes'
    drivers/media/platform/davinci/vpif_capture.c:174: warning: No description found for parameter 'vq'
    drivers/media/platform/davinci/vpif_capture.c:174: warning: Excess function parameter 'vb' description in 'vpif_start_streaming'
    drivers/media/platform/davinci/vpif_capture.c:636: warning: No description found for parameter 'iface'
    drivers/media/platform/davinci/vpif_capture.c:647: warning: No description found for parameter 'ch'
    drivers/media/platform/davinci/vpif_capture.c:647: warning: No description found for parameter 'muxmode'
    drivers/media/platform/davinci/vpif_capture.c:676: warning: No description found for parameter 'vpif_cfg'
    drivers/media/platform/davinci/vpif_capture.c:676: warning: No description found for parameter 'chan_cfg'
    drivers/media/platform/davinci/vpif_capture.c:676: warning: No description found for parameter 'input_index'
    drivers/media/platform/davinci/vpif_capture.c:712: warning: No description found for parameter 'vpif_cfg'
    drivers/media/platform/davinci/vpif_capture.c:712: warning: No description found for parameter 'ch'
    drivers/media/platform/davinci/vpif_capture.c:712: warning: No description found for parameter 'index'
    drivers/media/platform/davinci/vpif_capture.c:798: warning: No description found for parameter 'std'
    drivers/media/platform/davinci/vpif_capture.c:798: warning: Excess function parameter 'std_id' description in 'vpif_g_std'
    drivers/media/platform/davinci/vpif_capture.c:940: warning: No description found for parameter 'fmt'
    drivers/media/platform/davinci/vpif_capture.c:940: warning: Excess function parameter 'index' description in 'vpif_enum_fmt_vid_cap'
    drivers/media/platform/davinci/vpif_capture.c:1750: warning: No description found for parameter 'dev'

Fix them.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/platform/davinci/vpif_capture.c | 27 ++++++++++++++-------------
 drivers/media/platform/davinci/vpif_display.c | 16 ++++++++--------
 2 files changed, 22 insertions(+), 21 deletions(-)

diff --git a/drivers/media/platform/davinci/vpif_capture.c b/drivers/media/platform/davinci/vpif_capture.c
index a89367ab1e06..fca4dc829f73 100644
--- a/drivers/media/platform/davinci/vpif_capture.c
+++ b/drivers/media/platform/davinci/vpif_capture.c
@@ -109,7 +109,7 @@ static int vpif_buffer_prepare(struct vb2_buffer *vb)
  * @vq: vb2_queue ptr
  * @nbuffers: ptr to number of buffers requested by application
  * @nplanes:: contains number of distinct video planes needed to hold a frame
- * @sizes[]: contains the size (in bytes) of each plane.
+ * @sizes: contains the size (in bytes) of each plane.
  * @alloc_devs: ptr to allocation context
  *
  * This callback function is called when reqbuf() is called to adjust
@@ -167,7 +167,7 @@ static void vpif_buffer_queue(struct vb2_buffer *vb)
 
 /**
  * vpif_start_streaming : Starts the DMA engine for streaming
- * @vb: ptr to vb2_buffer
+ * @vq: ptr to vb2_buffer
  * @count: number of buffers
  */
 static int vpif_start_streaming(struct vb2_queue *vq, unsigned int count)
@@ -629,7 +629,7 @@ static void vpif_calculate_offsets(struct channel_obj *ch)
 
 /**
  * vpif_get_default_field() - Get default field type based on interface
- * @vpif_params - ptr to vpif params
+ * @iface: ptr to vpif interface
  */
 static inline enum v4l2_field vpif_get_default_field(
 				struct vpif_interface *iface)
@@ -640,8 +640,8 @@ static inline enum v4l2_field vpif_get_default_field(
 
 /**
  * vpif_config_addr() - function to configure buffer address in vpif
- * @ch - channel ptr
- * @muxmode - channel mux mode
+ * @ch: channel ptr
+ * @muxmode: channel mux mode
  */
 static void vpif_config_addr(struct channel_obj *ch, int muxmode)
 {
@@ -661,9 +661,9 @@ static void vpif_config_addr(struct channel_obj *ch, int muxmode)
 
 /**
  * vpif_input_to_subdev() - Maps input to sub device
- * @vpif_cfg - global config ptr
- * @chan_cfg - channel config ptr
- * @input_index - Given input index from application
+ * @vpif_cfg: global config ptr
+ * @chan_cfg: channel config ptr
+ * @input_index: Given input index from application
  *
  * lookup the sub device information for a given input index.
  * we report all the inputs to application. inputs table also
@@ -699,9 +699,9 @@ static int vpif_input_to_subdev(
 
 /**
  * vpif_set_input() - Select an input
- * @vpif_cfg - global config ptr
- * @ch - channel
- * @_index - Given input index from application
+ * @vpif_cfg: global config ptr
+ * @ch: channel
+ * @index: Given input index from application
  *
  * Select the given input.
  */
@@ -792,7 +792,7 @@ static int vpif_querystd(struct file *file, void *priv, v4l2_std_id *std_id)
  * vpif_g_std() - get STD handler
  * @file: file ptr
  * @priv: file handle
- * @std_id: ptr to std id
+ * @std: ptr to std id
  */
 static int vpif_g_std(struct file *file, void *priv, v4l2_std_id *std)
 {
@@ -933,7 +933,7 @@ static int vpif_s_input(struct file *file, void *priv, unsigned int index)
  * vpif_enum_fmt_vid_cap() - ENUM_FMT handler
  * @file: file ptr
  * @priv: file handle
- * @index: input index
+ * @fmt: ptr to V4L2 format descriptor
  */
 static int vpif_enum_fmt_vid_cap(struct file *file, void  *priv,
 					struct v4l2_fmtdesc *fmt)
@@ -1745,6 +1745,7 @@ static int vpif_remove(struct platform_device *device)
 #ifdef CONFIG_PM_SLEEP
 /**
  * vpif_suspend: vpif device suspend
+ * @dev: pointer to &struct device
  */
 static int vpif_suspend(struct device *dev)
 {
diff --git a/drivers/media/platform/davinci/vpif_display.c b/drivers/media/platform/davinci/vpif_display.c
index ff2f75a328c9..7be636237acf 100644
--- a/drivers/media/platform/davinci/vpif_display.c
+++ b/drivers/media/platform/davinci/vpif_display.c
@@ -102,7 +102,7 @@ static int vpif_buffer_prepare(struct vb2_buffer *vb)
  * @vq: vb2_queue ptr
  * @nbuffers: ptr to number of buffers requested by application
  * @nplanes:: contains number of distinct video planes needed to hold a frame
- * @sizes[]: contains the size (in bytes) of each plane.
+ * @sizes: contains the size (in bytes) of each plane.
  * @alloc_devs: ptr to allocation context
  *
  * This callback function is called when reqbuf() is called to adjust
@@ -158,7 +158,7 @@ static void vpif_buffer_queue(struct vb2_buffer *vb)
 
 /**
  * vpif_start_streaming : Starts the DMA engine for streaming
- * @vb: ptr to vb2_buffer
+ * @vq: ptr to vb2_buffer
  * @count: number of buffers
  */
 static int vpif_start_streaming(struct vb2_queue *vq, unsigned int count)
@@ -766,9 +766,9 @@ static int vpif_enum_output(struct file *file, void *fh,
 
 /**
  * vpif_output_to_subdev() - Maps output to sub device
- * @vpif_cfg - global config ptr
- * @chan_cfg - channel config ptr
- * @index - Given output index from application
+ * @vpif_cfg: global config ptr
+ * @chan_cfg: channel config ptr
+ * @index: Given output index from application
  *
  * lookup the sub device information for a given output index.
  * we report all the output to application. output table also
@@ -802,9 +802,9 @@ vpif_output_to_subdev(struct vpif_display_config *vpif_cfg,
 
 /**
  * vpif_set_output() - Select an output
- * @vpif_cfg - global config ptr
- * @ch - channel
- * @index - Given output index from application
+ * @vpif_cfg: global config ptr
+ * @ch: channel
+ * @index: Given output index from application
  *
  * Select the given output.
  */
-- 
2.14.3
