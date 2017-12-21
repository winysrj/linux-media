Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:42334 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753334AbdLUQSZ (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 21 Dec 2017 11:18:25 -0500
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Satendra Singh Thakur <satendra.t@samsung.com>,
        Inki Dae <inki.dae@samsung.com>,
        Seung-Woo Kim <sw0312.kim@samsung.com>,
        Junghak Sung <jh1009.sung@samsung.com>
Subject: [PATCH 05/11] media: dvb_vb2: fix a warning about streamoff logic
Date: Thu, 21 Dec 2017 14:18:04 -0200
Message-Id: <1bb5247a5eb355693098ed715170b7523fc20530.1513872637.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1513872637.git.mchehab@s-opensource.com>
References: <cover.1513872637.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1513872637.git.mchehab@s-opensource.com>
References: <cover.1513872637.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The streamoff logic is causing those warnings:

 WARNING: CPU: 3 PID: 3382 at drivers/media/v4l2-core/videobuf2-core.c:1652 __vb2_queue_cancel+0x177/0x250 [videobuf2_core]
 Modules linked in: bnep fuse xt_CHECKSUM iptable_mangle tun ebtable_filter ebtables ip6table_filter ip6_tables xt_physdev br_netfilter bluetooth bridge rfkill ecdh_generic stp llc nf_log_ipv4 nf_log_common xt_LOG xt_conntrack ipt_MASQUERADE nf_nat_masquerade_ipv4 iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack libcrc32c sunrpc vfat fat snd_hda_codec_hdmi rc_dib0700_nec i915 rc_pinnacle_pctv_hd em28xx_rc a8293 ts2020 m88ds3103 i2c_mux em28xx_dvb dib8000 dvb_usb_dib0700 dib0070 dib7000m dib0090 dvb_usb dvb_core uvcvideo snd_usb_audio videobuf2_v4l2 dib3000mc videobuf2_vmalloc videobuf2_memops dibx000_common videobuf2_core rc_core snd_usbmidi_lib snd_rawmidi em28xx tveeprom v4l2_common videodev media intel_rapl x86_pkg_temp_thermal intel_powerclamp coretemp snd_hda_intel
 kvm_intel snd_hda_codec kvm snd_hwdep snd_hda_core snd_seq irqbypass crct10dif_pclmul crc32_pclmul i2c_algo_bit ghash_clmulni_intel snd_seq_device drm_kms_helper snd_pcm intel_cstate intel_uncore snd_timer tpm_tis drm mei_wdt iTCO_wdt iTCO_vendor_support tpm_tis_core snd intel_rapl_perf mei_me mei tpm i2c_i801 soundcore lpc_ich video binfmt_misc hid_logitech_hidpp hid_logitech_dj e1000e crc32c_intel ptp pps_core analog gameport joydev
 CPU: 3 PID: 3382 Comm: lt-dvbv5-zap Not tainted 4.14.0+ #3
 Hardware name:                  /D53427RKE, BIOS RKPPT10H.86A.0048.2017.0506.1545 05/06/2017
 task: ffff94b93bbe1e40 task.stack: ffffb7a98320c000
 RIP: 0010:__vb2_queue_cancel+0x177/0x250 [videobuf2_core]
 RSP: 0018:ffffb7a98320fd40 EFLAGS: 00010202
 RAX: 0000000000000001 RBX: ffff94b92ff72428 RCX: 0000000000000000
 RDX: 0000000000000001 RSI: 0000000000000001 RDI: ffff94b92ff72428
 RBP: ffffb7a98320fd68 R08: ffff94b92ff725d8 R09: ffffb7a98320fcc8
 R10: ffff94b978003d98 R11: ffff94b92ff72428 R12: ffff94b92ff72428
 R13: 0000000000000282 R14: ffff94b92059ae20 R15: dead000000000100
 FS:  0000000000000000(0000) GS:ffff94b99e380000(0000) knlGS:0000000000000000
 CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
 CR2: 0000555953007d70 CR3: 000000012be09004 CR4: 00000000001606e0
 Call Trace:
  vb2_core_streamoff+0x28/0x90 [videobuf2_core]
  dvb_vb2_stream_off+0xd1/0x150 [dvb_core]
  dvb_dvr_release+0x114/0x120 [dvb_core]
  __fput+0xdf/0x1e0
  ____fput+0xe/0x10
  task_work_run+0x94/0xc0
  do_exit+0x2dc/0xba0
  do_group_exit+0x47/0xb0
  SyS_exit_group+0x14/0x20
  entry_SYSCALL_64_fastpath+0x1a/0xa5
 RIP: 0033:0x7f775e931ed8
 RSP: 002b:00007fff07019d68 EFLAGS: 00000246 ORIG_RAX: 00000000000000e7
 RAX: ffffffffffffffda RBX: 0000000001d02690 RCX: 00007f775e931ed8
 RDX: 0000000000000001 RSI: 000000000000003c RDI: 0000000000000001
 RBP: 00007fff0701a500 R08: 00000000000000e7 R09: ffffffffffffff70
 R10: 00007f775e854dd8 R11: 0000000000000246 R12: 0000000000000000
 R13: 00000000035fa000 R14: 000000000000000a R15: 000000000000000a
 Code: 00 00 04 74 1c 44 89 e8 49 83 c5 01 41 39 84 24 88 01 00 00 77 8a 5b 41 5c 41 5d 41 5e 41 5f 5d c3 48 89 df e8 bb fd ff ff eb da <0f> ff 41 8b b4 24 88 01 00 00 85 f6 74 34 bb 01 00 00 00 eb 10

There are actually two issues here:

1) list_del() should be called when changing the buffer state;

2) The logic with marks the buffers as done is at the wrong place.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/dvb-core/dvb_vb2.c | 33 ++++++++++++++++++++-------------
 1 file changed, 20 insertions(+), 13 deletions(-)

diff --git a/drivers/media/dvb-core/dvb_vb2.c b/drivers/media/dvb-core/dvb_vb2.c
index 34193a4acc47..277d33b83089 100644
--- a/drivers/media/dvb-core/dvb_vb2.c
+++ b/drivers/media/dvb-core/dvb_vb2.c
@@ -89,8 +89,19 @@ static int _start_streaming(struct vb2_queue *vq, unsigned int count)
 static void _stop_streaming(struct vb2_queue *vq)
 {
 	struct dvb_vb2_ctx *ctx = vb2_get_drv_priv(vq);
+	struct dvb_buffer *buf;
+	unsigned long flags = 0;
 
 	dprintk(3, "[%s]\n", ctx->name);
+
+	spin_lock_irqsave(&ctx->slock, flags);
+	while (!list_empty(&ctx->dvb_q)) {
+		buf = list_entry(ctx->dvb_q.next,
+				 struct dvb_buffer, list);
+		vb2_buffer_done(&buf->vb, VB2_BUF_STATE_ERROR);
+		list_del(&buf->list);
+	}
+	spin_unlock_irqrestore(&ctx->slock, flags);
 }
 
 static void _dmxdev_lock(struct vb2_queue *vq)
@@ -224,21 +235,8 @@ int dvb_vb2_stream_off(struct dvb_vb2_ctx *ctx)
 {
 	struct vb2_queue *q = (struct vb2_queue *)&ctx->vb_q;
 	int ret;
-	unsigned long flags = 0;
 
 	ctx->state &= ~DVB_VB2_STATE_STREAMON;
-	spin_lock_irqsave(&ctx->slock, flags);
-	while (!list_empty(&ctx->dvb_q)) {
-		struct dvb_buffer       *buf;
-
-		buf = list_entry(ctx->dvb_q.next,
-				 struct dvb_buffer, list);
-		list_del(&buf->list);
-		spin_unlock_irqrestore(&ctx->slock, flags);
-		vb2_buffer_done(&buf->vb, VB2_BUF_STATE_ERROR);
-		spin_lock_irqsave(&ctx->slock, flags);
-	}
-	spin_unlock_irqrestore(&ctx->slock, flags);
 	ret = vb2_core_streamoff(q, q->type);
 	if (ret) {
 		ctx->state = DVB_VB2_STATE_NONE;
@@ -291,7 +289,10 @@ int dvb_vb2_fill_buffer(struct dvb_vb2_ctx *ctx,
 		}
 
 		if (!dvb_vb2_is_streaming(ctx)) {
+			spin_lock_irqsave(&ctx->slock, flags);
 			vb2_buffer_done(&ctx->buf->vb, VB2_BUF_STATE_ERROR);
+			list_del(&ctx->buf->list);
+			spin_unlock_irqrestore(&ctx->slock, flags);
 			ctx->buf = NULL;
 			break;
 		}
@@ -307,14 +308,20 @@ int dvb_vb2_fill_buffer(struct dvb_vb2_ctx *ctx,
 		ctx->offset += ll;
 
 		if (ctx->remain == 0) {
+			spin_lock_irqsave(&ctx->slock, flags);
 			vb2_buffer_done(&ctx->buf->vb, VB2_BUF_STATE_DONE);
+			list_del(&ctx->buf->list);
+			spin_unlock_irqrestore(&ctx->slock, flags);
 			ctx->buf = NULL;
 		}
 	}
 
 	if (ctx->nonblocking && ctx->buf) {
+		spin_lock_irqsave(&ctx->slock, flags);
 		vb2_set_plane_payload(&ctx->buf->vb, 0, ll);
 		vb2_buffer_done(&ctx->buf->vb, VB2_BUF_STATE_DONE);
+		list_del(&ctx->buf->list);
+		spin_unlock_irqrestore(&ctx->slock, flags);
 		ctx->buf = NULL;
 	}
 
-- 
2.14.3
