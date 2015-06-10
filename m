Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:45478 "EHLO
	lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751748AbbFJFpy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Jun 2015 01:45:54 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id 51DA12A00AD
	for <linux-media@vger.kernel.org>; Wed, 10 Jun 2015 07:45:45 +0200 (CEST)
Message-ID: <5577CF09.5060606@xs4all.nl>
Date: Wed, 10 Jun 2015 07:45:45 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH] cobalt: fix 64-bit division
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There was still one more remaining 64-bit division in the cobalt code.
Replace it by div_u64.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Reported-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/pci/cobalt/cobalt-v4l2.c b/drivers/media/pci/cobalt/cobalt-v4l2.c
index 6fb8812..b40c2d1 100644
--- a/drivers/media/pci/cobalt/cobalt-v4l2.c
+++ b/drivers/media/pci/cobalt/cobalt-v4l2.c
@@ -327,7 +327,7 @@ static int cobalt_start_streaming(struct vb2_queue *q, unsigned int count)
 	iowrite32(clk_freq / 1000000, &clkloss->ref_clk_cnt_val);
 	/* The lower bound for the clock frequency is 0.5% lower as is
 	 * allowed by the spec */
-	iowrite32((((u64)bt->pixelclock * 995) / 1000) / 1000000,
+	iowrite32(div_u64(bt->pixelclock * 995, 1000000000),
 		  &clkloss->test_clk_cnt_val);
 	/* will be enabled after the first frame has been received */
 	iowrite32(bt->width * bt->height, &fw->active_length);
