Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud8.xs4all.net ([194.109.24.25]:51901 "EHLO
        lb2-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727837AbeK1Tio (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 28 Nov 2018 14:38:44 -0500
From: hverkuil-cisco@xs4all.nl
To: linux-media@vger.kernel.org
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>
Subject: [PATCH for v4.20 5/5] vivid: drop v4l2_ctrl_request_complete() from start_streaming
Date: Wed, 28 Nov 2018 09:37:47 +0100
Message-Id: <20181128083747.18530-6-hverkuil-cisco@xs4all.nl>
In-Reply-To: <20181128083747.18530-1-hverkuil-cisco@xs4all.nl>
References: <20181128083747.18530-1-hverkuil-cisco@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hverkuil-cisco@xs4all.nl>

If start_streaming() fails and all queued buffers are returned to
vb2, then do not call v4l2_ctrl_request_complete(). Nothing happened
to the request and the state should remain as it was before
start_streaming was called.

Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
---
 drivers/media/platform/vivid/vivid-sdr-cap.c | 2 --
 drivers/media/platform/vivid/vivid-vbi-cap.c | 2 --
 drivers/media/platform/vivid/vivid-vbi-out.c | 2 --
 drivers/media/platform/vivid/vivid-vid-cap.c | 2 --
 drivers/media/platform/vivid/vivid-vid-out.c | 2 --
 5 files changed, 10 deletions(-)

diff --git a/drivers/media/platform/vivid/vivid-sdr-cap.c b/drivers/media/platform/vivid/vivid-sdr-cap.c
index dcdc80e272c2..9acc709b0740 100644
--- a/drivers/media/platform/vivid/vivid-sdr-cap.c
+++ b/drivers/media/platform/vivid/vivid-sdr-cap.c
@@ -276,8 +276,6 @@ static int sdr_cap_start_streaming(struct vb2_queue *vq, unsigned count)
 
 		list_for_each_entry_safe(buf, tmp, &dev->sdr_cap_active, list) {
 			list_del(&buf->list);
-			v4l2_ctrl_request_complete(buf->vb.vb2_buf.req_obj.req,
-						   &dev->ctrl_hdl_sdr_cap);
 			vb2_buffer_done(&buf->vb.vb2_buf,
 					VB2_BUF_STATE_QUEUED);
 		}
diff --git a/drivers/media/platform/vivid/vivid-vbi-cap.c b/drivers/media/platform/vivid/vivid-vbi-cap.c
index 903cebeb5ce5..d666271bdaed 100644
--- a/drivers/media/platform/vivid/vivid-vbi-cap.c
+++ b/drivers/media/platform/vivid/vivid-vbi-cap.c
@@ -204,8 +204,6 @@ static int vbi_cap_start_streaming(struct vb2_queue *vq, unsigned count)
 
 		list_for_each_entry_safe(buf, tmp, &dev->vbi_cap_active, list) {
 			list_del(&buf->list);
-			v4l2_ctrl_request_complete(buf->vb.vb2_buf.req_obj.req,
-						   &dev->ctrl_hdl_vbi_cap);
 			vb2_buffer_done(&buf->vb.vb2_buf,
 					VB2_BUF_STATE_QUEUED);
 		}
diff --git a/drivers/media/platform/vivid/vivid-vbi-out.c b/drivers/media/platform/vivid/vivid-vbi-out.c
index 9357c07e30d6..cd56476902a2 100644
--- a/drivers/media/platform/vivid/vivid-vbi-out.c
+++ b/drivers/media/platform/vivid/vivid-vbi-out.c
@@ -96,8 +96,6 @@ static int vbi_out_start_streaming(struct vb2_queue *vq, unsigned count)
 
 		list_for_each_entry_safe(buf, tmp, &dev->vbi_out_active, list) {
 			list_del(&buf->list);
-			v4l2_ctrl_request_complete(buf->vb.vb2_buf.req_obj.req,
-						   &dev->ctrl_hdl_vbi_out);
 			vb2_buffer_done(&buf->vb.vb2_buf,
 					VB2_BUF_STATE_QUEUED);
 		}
diff --git a/drivers/media/platform/vivid/vivid-vid-cap.c b/drivers/media/platform/vivid/vivid-vid-cap.c
index a1ed5fdabc75..c059fc12668a 100644
--- a/drivers/media/platform/vivid/vivid-vid-cap.c
+++ b/drivers/media/platform/vivid/vivid-vid-cap.c
@@ -243,8 +243,6 @@ static int vid_cap_start_streaming(struct vb2_queue *vq, unsigned count)
 
 		list_for_each_entry_safe(buf, tmp, &dev->vid_cap_active, list) {
 			list_del(&buf->list);
-			v4l2_ctrl_request_complete(buf->vb.vb2_buf.req_obj.req,
-						   &dev->ctrl_hdl_vid_cap);
 			vb2_buffer_done(&buf->vb.vb2_buf,
 					VB2_BUF_STATE_QUEUED);
 		}
diff --git a/drivers/media/platform/vivid/vivid-vid-out.c b/drivers/media/platform/vivid/vivid-vid-out.c
index 7642cbdb0e14..ea250aee2b2e 100644
--- a/drivers/media/platform/vivid/vivid-vid-out.c
+++ b/drivers/media/platform/vivid/vivid-vid-out.c
@@ -162,8 +162,6 @@ static int vid_out_start_streaming(struct vb2_queue *vq, unsigned count)
 
 		list_for_each_entry_safe(buf, tmp, &dev->vid_out_active, list) {
 			list_del(&buf->list);
-			v4l2_ctrl_request_complete(buf->vb.vb2_buf.req_obj.req,
-						   &dev->ctrl_hdl_vid_out);
 			vb2_buffer_done(&buf->vb.vb2_buf,
 					VB2_BUF_STATE_QUEUED);
 		}
-- 
2.19.1
