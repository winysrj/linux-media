Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr2.xs4all.nl ([194.109.24.22]:3854 "EHLO
	smtp-vbr2.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751780Ab2DWLvj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Apr 2012 07:51:39 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Janne Grunau <j@jannau.net>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Andy Walls <awalls@md.metrocast.net>,
	"Igor M. Liplianin" <liplianin@me.by>,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	Manu Abraham <abraham.manu@gmail.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH 3/8] ivtv/cx18: fix compiler warnings
Date: Mon, 23 Apr 2012 13:51:23 +0200
Message-Id: <6c2471c1d618b0ab8c6183d3faf27904fc665ef7.1335181658.git.hans.verkuil@cisco.com>
In-Reply-To: <1335181888-4917-1-git-send-email-hverkuil@xs4all.nl>
References: <1335181888-4917-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <100836b0eeed3d802c1ce4f7645d8beefe26df25.1335181658.git.hans.verkuil@cisco.com>
References: <100836b0eeed3d802c1ce4f7645d8beefe26df25.1335181658.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

media_build/v4l/cx18-alsa-main.c: In function 'cx18_alsa_exit':
media_build/v4l/cx18-alsa-main.c:282:6: warning: variable 'ret' set but not used [-Wunused-but-set-variable]
media_build/v4l/cx18-mailbox.c: In function 'cx18_api_call':
media_build/v4l/cx18-mailbox.c:598:6: warning: variable 'state' set but not used [-Wunused-but-set-variable]
media_build/v4l/cx18-alsa-pcm.c: In function 'snd_cx18_pcm_capture_open':
media_build/v4l/cx18-alsa-pcm.c:156:6: warning: variable 'ret' set but not used [-Wunused-but-set-variable]
media_build/v4l/cx18-alsa-pcm.c: In function 'snd_cx18_pcm_capture_close':
media_build/v4l/cx18-alsa-pcm.c:202:6: warning: variable 'ret' set but not used [-Wunused-but-set-variable]
media_build/v4l/cx18-alsa-pcm.c: In function 'snd_cx18_pcm_hw_params':
media_build/v4l/cx18-alsa-pcm.c:255:6: warning: variable 'ret' set but not used [-Wunused-but-set-variable]
media_build/v4l/cx18-streams.c: In function 'cx18_stop_v4l2_encode_stream':
media_build/v4l/cx18-streams.c:983:16: warning: variable 'then' set but not used [-Wunused-but-set-variable]
media_build/v4l/ivtv-ioctl.c: In function 'ivtv_set_speed':
media_build/v4l/ivtv-ioctl.c:138:22: warning: variable 's' set but not used [-Wunused-but-set-variable]
media_build/v4l/ivtvfb.c: In function 'ivtvfb_init':
media_build/v4l/ivtvfb.c:1286:6: warning: variable 'err' set but not used [-Wunused-but-set-variable]
media_build/v4l/ivtvfb.c: In function 'ivtvfb_cleanup':
media_build/v4l/ivtvfb.c:1306:6: warning: variable 'err' set but not used [-Wunused-but-set-variable]

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/video/cx18/cx18-alsa-main.c |    1 +
 drivers/media/video/cx18/cx18-alsa-pcm.c  |   10 +++-------
 drivers/media/video/cx18/cx18-mailbox.c   |    6 +-----
 drivers/media/video/cx18/cx18-streams.c   |    3 ---
 drivers/media/video/ivtv/ivtv-ioctl.c     |    3 ---
 drivers/media/video/ivtv/ivtvfb.c         |    2 ++
 6 files changed, 7 insertions(+), 18 deletions(-)

diff --git a/drivers/media/video/cx18/cx18-alsa-main.c b/drivers/media/video/cx18/cx18-alsa-main.c
index e118361..6d2a982 100644
--- a/drivers/media/video/cx18/cx18-alsa-main.c
+++ b/drivers/media/video/cx18/cx18-alsa-main.c
@@ -285,6 +285,7 @@ static void __exit cx18_alsa_exit(void)
 
 	drv = driver_find("cx18", &pci_bus_type);
 	ret = driver_for_each_device(drv, NULL, NULL, cx18_alsa_exit_callback);
+	(void)ret;	/* suppress compiler warning */
 
 	cx18_ext_init = NULL;
 	printk(KERN_INFO "cx18-alsa: module unload complete\n");
diff --git a/drivers/media/video/cx18/cx18-alsa-pcm.c b/drivers/media/video/cx18/cx18-alsa-pcm.c
index 82d195b..7a5b84a 100644
--- a/drivers/media/video/cx18/cx18-alsa-pcm.c
+++ b/drivers/media/video/cx18/cx18-alsa-pcm.c
@@ -190,7 +190,7 @@ static int snd_cx18_pcm_capture_open(struct snd_pcm_substream *substream)
 	ret = cx18_start_v4l2_encode_stream(s);
 	snd_cx18_unlock(cxsc);
 
-	return 0;
+	return ret;
 }
 
 static int snd_cx18_pcm_capture_close(struct snd_pcm_substream *substream)
@@ -199,12 +199,11 @@ static int snd_cx18_pcm_capture_close(struct snd_pcm_substream *substream)
 	struct v4l2_device *v4l2_dev = cxsc->v4l2_dev;
 	struct cx18 *cx = to_cx18(v4l2_dev);
 	struct cx18_stream *s;
-	int ret;
 
 	/* Instruct the cx18 to stop sending packets */
 	snd_cx18_lock(cxsc);
 	s = &cx->streams[CX18_ENC_STREAM_TYPE_PCM];
-	ret = cx18_stop_v4l2_encode_stream(s, 0);
+	cx18_stop_v4l2_encode_stream(s, 0);
 	clear_bit(CX18_F_S_STREAMING, &s->s_flags);
 
 	cx18_release_stream(s);
@@ -252,13 +251,10 @@ static int snd_pcm_alloc_vmalloc_buffer(struct snd_pcm_substream *subs,
 static int snd_cx18_pcm_hw_params(struct snd_pcm_substream *substream,
 			 struct snd_pcm_hw_params *params)
 {
-	int ret;
-
 	dprintk("%s called\n", __func__);
 
-	ret = snd_pcm_alloc_vmalloc_buffer(substream,
+	return snd_pcm_alloc_vmalloc_buffer(substream,
 					   params_buffer_bytes(params));
-	return 0;
 }
 
 static int snd_cx18_pcm_hw_free(struct snd_pcm_substream *substream)
diff --git a/drivers/media/video/cx18/cx18-mailbox.c b/drivers/media/video/cx18/cx18-mailbox.c
index 0c7796e..ed81183 100644
--- a/drivers/media/video/cx18/cx18-mailbox.c
+++ b/drivers/media/video/cx18/cx18-mailbox.c
@@ -595,9 +595,8 @@ void cx18_api_epu_cmd_irq(struct cx18 *cx, int rpu)
 static int cx18_api_call(struct cx18 *cx, u32 cmd, int args, u32 data[])
 {
 	const struct cx18_api_info *info = find_api_info(cmd);
-	u32 state, irq, req, ack, err;
+	u32 irq, req, ack, err;
 	struct cx18_mailbox __iomem *mb;
-	u32 __iomem *xpu_state;
 	wait_queue_head_t *waitq;
 	struct mutex *mb_lock;
 	unsigned long int t0, timeout, ret;
@@ -628,14 +627,12 @@ static int cx18_api_call(struct cx18 *cx, u32 cmd, int args, u32 data[])
 		mb_lock = &cx->epu2apu_mb_lock;
 		irq = IRQ_EPU_TO_APU;
 		mb = &cx->scb->epu2apu_mb;
-		xpu_state = &cx->scb->apu_state;
 		break;
 	case CPU:
 		waitq = &cx->mb_cpu_waitq;
 		mb_lock = &cx->epu2cpu_mb_lock;
 		irq = IRQ_EPU_TO_CPU;
 		mb = &cx->scb->epu2cpu_mb;
-		xpu_state = &cx->scb->cpu_state;
 		break;
 	default:
 		CX18_WARN("Unknown RPU (%d) for API call\n", info->rpu);
@@ -653,7 +650,6 @@ static int cx18_api_call(struct cx18 *cx, u32 cmd, int args, u32 data[])
 	 * by a signal, we may get here and find a busy mailbox.  After waiting,
 	 * mark it "not busy" from our end, if the XPU hasn't ack'ed it still.
 	 */
-	state = cx18_readl(cx, xpu_state);
 	req = cx18_readl(cx, &mb->request);
 	timeout = msecs_to_jiffies(10);
 	ret = wait_event_timeout(*waitq,
diff --git a/drivers/media/video/cx18/cx18-streams.c b/drivers/media/video/cx18/cx18-streams.c
index 638cca1..4185bcb 100644
--- a/drivers/media/video/cx18/cx18-streams.c
+++ b/drivers/media/video/cx18/cx18-streams.c
@@ -980,7 +980,6 @@ void cx18_stop_all_captures(struct cx18 *cx)
 int cx18_stop_v4l2_encode_stream(struct cx18_stream *s, int gop_end)
 {
 	struct cx18 *cx = s->cx;
-	unsigned long then;
 
 	if (!cx18_stream_enabled(s))
 		return -EINVAL;
@@ -999,8 +998,6 @@ int cx18_stop_v4l2_encode_stream(struct cx18_stream *s, int gop_end)
 	else
 		cx18_vapi(cx, CX18_CPU_CAPTURE_STOP, 1, s->handle);
 
-	then = jiffies;
-
 	if (s->type == CX18_ENC_STREAM_TYPE_MPG && gop_end) {
 		CX18_INFO("ignoring gop_end: not (yet?) supported by the firmware\n");
 	}
diff --git a/drivers/media/video/ivtv/ivtv-ioctl.c b/drivers/media/video/ivtv/ivtv-ioctl.c
index 989e556..6ae15b5 100644
--- a/drivers/media/video/ivtv/ivtv-ioctl.c
+++ b/drivers/media/video/ivtv/ivtv-ioctl.c
@@ -135,7 +135,6 @@ void ivtv_set_osd_alpha(struct ivtv *itv)
 int ivtv_set_speed(struct ivtv *itv, int speed)
 {
 	u32 data[CX2341X_MBOX_MAX_DATA];
-	struct ivtv_stream *s;
 	int single_step = (speed == 1 || speed == -1);
 	DEFINE_WAIT(wait);
 
@@ -145,8 +144,6 @@ int ivtv_set_speed(struct ivtv *itv, int speed)
 	if (speed == itv->speed && !single_step)
 		return 0;
 
-	s = &itv->streams[IVTV_DEC_STREAM_TYPE_MPG];
-
 	if (single_step && (speed < 0) == (itv->speed < 0)) {
 		/* Single step video and no need to change direction */
 		ivtv_vapi(itv, CX2341X_DEC_STEP_VIDEO, 1, 0);
diff --git a/drivers/media/video/ivtv/ivtvfb.c b/drivers/media/video/ivtv/ivtvfb.c
index e5e7fa9..05b94aa 100644
--- a/drivers/media/video/ivtv/ivtvfb.c
+++ b/drivers/media/video/ivtv/ivtvfb.c
@@ -1293,6 +1293,7 @@ static int __init ivtvfb_init(void)
 
 	drv = driver_find("ivtv", &pci_bus_type);
 	err = driver_for_each_device(drv, NULL, &registered, ivtvfb_callback_init);
+	(void)err;	/* suppress compiler warning */
 	if (!registered) {
 		printk(KERN_ERR "ivtvfb:  no cards found\n");
 		return -ENODEV;
@@ -1309,6 +1310,7 @@ static void ivtvfb_cleanup(void)
 
 	drv = driver_find("ivtv", &pci_bus_type);
 	err = driver_for_each_device(drv, NULL, NULL, ivtvfb_callback_cleanup);
+	(void)err;	/* suppress compiler warning */
 }
 
 module_init(ivtvfb_init);
-- 
1.7.10

