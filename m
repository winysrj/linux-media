Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pd0-f169.google.com ([209.85.192.169]:41370 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752345AbaKZGUE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 26 Nov 2014 01:20:04 -0500
Received: by mail-pd0-f169.google.com with SMTP id fp1so2162150pdb.0
        for <linux-media@vger.kernel.org>; Tue, 25 Nov 2014 22:20:03 -0800 (PST)
From: Takanari Hayama <taki@igel.co.jp>
To: linux-media@vger.kernel.org
Cc: linux-sh@vger.kernel.org
Subject: [PATCH 2/2] v4l: vsp1: Always enable virtual RPF when BRU is in use
Date: Wed, 26 Nov 2014 15:19:52 +0900
Message-Id: <1416982792-11917-3-git-send-email-taki@igel.co.jp>
In-Reply-To: <1416982792-11917-1-git-send-email-taki@igel.co.jp>
References: <1416982792-11917-1-git-send-email-taki@igel.co.jp>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Regardless of a number of inputs, we should always enable virtual RPF
when BRU is used. This allows the case when there's only one input to
BRU, and a size of the input is smaller than a size of an output of BRU.

Signed-off-by: Takanari Hayama <taki@igel.co.jp>
---
 drivers/media/platform/vsp1/vsp1_wpf.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/media/platform/vsp1/vsp1_wpf.c b/drivers/media/platform/vsp1/vsp1_wpf.c
index 6e05776..29ea28b 100644
--- a/drivers/media/platform/vsp1/vsp1_wpf.c
+++ b/drivers/media/platform/vsp1/vsp1_wpf.c
@@ -92,19 +92,20 @@ static int wpf_s_stream(struct v4l2_subdev *subdev, int enable)
 		return 0;
 	}
 
-	/* Sources. If the pipeline has a single input configure it as the
-	 * master layer. Otherwise configure all inputs as sub-layers and
-	 * select the virtual RPF as the master layer.
+	/* Sources. If the pipeline has a single input and BRU is not used,
+	 * configure it as the master layer. Otherwise configure all
+	 * inputs as sub-layers and select the virtual RPF as the master
+	 * layer.
 	 */
 	for (i = 0; i < pipe->num_inputs; ++i) {
 		struct vsp1_rwpf *input = pipe->inputs[i];
 
-		srcrpf |= pipe->num_inputs == 1
+		srcrpf |= ((!pipe->bru) && (pipe->num_inputs == 1))
 			? VI6_WPF_SRCRPF_RPF_ACT_MST(input->entity.index)
 			: VI6_WPF_SRCRPF_RPF_ACT_SUB(input->entity.index);
 	}
 
-	if (pipe->num_inputs > 1)
+	if ((pipe->bru) || (pipe->num_inputs > 1))
 		srcrpf |= VI6_WPF_SRCRPF_VIRACT_MST;
 
 	vsp1_wpf_write(wpf, VI6_WPF_SRCRPF, srcrpf);
-- 
1.8.0

