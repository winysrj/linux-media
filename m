Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f50.google.com ([209.85.220.50]:35446 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750869AbbCFCjr (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 5 Mar 2015 21:39:47 -0500
Date: Fri, 6 Mar 2015 08:09:40 +0530
From: Tapasweni Pathak <tapaswenipathak@gmail.com>
To: hverkuil@xs4all.nl, mchehab@osg.samsung.com,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: tapaswenipathak@gmail.com, julia.lawall@lip6.fr
Subject: [PATCH] drivers: media: platform: vivid: Fix possible null derefrence
Message-ID: <20150306023940.GA6451@kt-Inspiron-3542>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Check for dev_fmt being null before derefrencing it, to assign it
to planes.

Found using Coccinelle.

Signed-off-by: Tapasweni Pathak <tapaswenipathak@gmail.com>
Acked-by: Julia Lawall <julia.lawall@lip6.fr>
---
 drivers/media/platform/vivid/vivid-vid-out.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/vivid/vivid-vid-out.c b/drivers/media/platform/vivid/vivid-vid-out.c
index 39ff79f..8f081bb 100644
--- a/drivers/media/platform/vivid/vivid-vid-out.c
+++ b/drivers/media/platform/vivid/vivid-vid-out.c
@@ -114,7 +114,7 @@ static int vid_out_buf_prepare(struct vb2_buffer *vb)
 {
 	struct vivid_dev *dev = vb2_get_drv_priv(vb->vb2_queue);
 	unsigned long size;
-	unsigned planes = dev->fmt_out->planes;
+	unsigned planes;
 	unsigned p;

 	dprintk(dev, 1, "%s\n", __func__);
@@ -122,6 +122,8 @@ static int vid_out_buf_prepare(struct vb2_buffer *vb)
 	if (WARN_ON(NULL == dev->fmt_out))
 		return -EINVAL;

+	planes = dev->fmt_out->planes;
+
 	if (dev->buf_prepare_error) {
 		/*
 		 * Error injection: test what happens if buf_prepare() returns
--
1.7.9.5

