Return-path: <linux-media-owner@vger.kernel.org>
Received: from gateway36.websitewelcome.com ([192.185.186.5]:48368 "EHLO
        gateway36.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751935AbdGFUO0 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 6 Jul 2017 16:14:26 -0400
Received: from cm13.websitewelcome.com (cm13.websitewelcome.com [100.42.49.6])
        by gateway36.websitewelcome.com (Postfix) with ESMTP id 08E1144A845F6
        for <linux-media@vger.kernel.org>; Thu,  6 Jul 2017 15:14:24 -0500 (CDT)
Date: Thu, 6 Jul 2017 15:14:23 -0500
From: "Gustavo A. R. Silva" <garsilva@embeddedor.com>
To: Hugues Fruchet <hugues.fruchet@st.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <garsilva@embeddedor.com>
Subject: [PATCH] st-delta: constify vb2_ops structures
Message-ID: <20170706201423.GA7477@embeddedgus>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Check for vb2_ops structures that are only stored in the ops field of a
vb2_queue structure. That field is declared const, so vb2_ops structures
that have this property can be declared as const also.

This issue was detected using Coccinelle and the following semantic patch:

@r disable optional_qualifier@
identifier i;
position p;
@@
static struct vb2_ops i@p = { ... };

@ok@
identifier r.i;
struct vb2_queue e;
position p;
@@
e.ops = &i@p;

@bad@
position p != {r.p,ok.p};
identifier r.i;
struct vb2_ops e;
@@
e@i@p

@depends on !bad disable optional_qualifier@
identifier r.i;
@@
static
+const
struct vb2_ops i = { ... };

Signed-off-by: Gustavo A. R. Silva <garsilva@embeddedor.com>
---
 drivers/media/platform/sti/delta/delta-v4l2.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/sti/delta/delta-v4l2.c b/drivers/media/platform/sti/delta/delta-v4l2.c
index c6f2e24..ff9850e 100644
--- a/drivers/media/platform/sti/delta/delta-v4l2.c
+++ b/drivers/media/platform/sti/delta/delta-v4l2.c
@@ -1574,7 +1574,7 @@ static void delta_vb2_frame_stop_streaming(struct vb2_queue *q)
 }
 
 /* VB2 queue ops */
-static struct vb2_ops delta_vb2_au_ops = {
+static const struct vb2_ops delta_vb2_au_ops = {
 	.queue_setup = delta_vb2_au_queue_setup,
 	.buf_prepare = delta_vb2_au_prepare,
 	.buf_queue = delta_vb2_au_queue,
@@ -1584,7 +1584,7 @@ static struct vb2_ops delta_vb2_au_ops = {
 	.stop_streaming = delta_vb2_au_stop_streaming,
 };
 
-static struct vb2_ops delta_vb2_frame_ops = {
+static const struct vb2_ops delta_vb2_frame_ops = {
 	.queue_setup = delta_vb2_frame_queue_setup,
 	.buf_prepare = delta_vb2_frame_prepare,
 	.buf_finish = delta_vb2_frame_finish,
-- 
2.5.0
