Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailrelay110.isp.belgacom.be ([195.238.20.137]:7620 "EHLO
	mailrelay110.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933968AbbFJQdv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Jun 2015 12:33:51 -0400
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Julia Lawall <Julia.Lawall@lip6.fr>,
	Fabian Frederick <fabf@skynet.be>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-media@vger.kernel.org
Subject: [PATCH 1/1 linux-next] [media] btcx-risc: use swap() in btcx_sort_clips()
Date: Wed, 10 Jun 2015 18:33:45 +0200
Message-Id: <1433954026-24981-1-git-send-email-fabf@skynet.be>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use kernel.h macro definition.

Thanks to Julia Lawall for Coccinelle scripting support.

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 drivers/media/pci/bt8xx/btcx-risc.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/media/pci/bt8xx/btcx-risc.c b/drivers/media/pci/bt8xx/btcx-risc.c
index 00f0880..57c7f58 100644
--- a/drivers/media/pci/bt8xx/btcx-risc.c
+++ b/drivers/media/pci/bt8xx/btcx-risc.c
@@ -160,7 +160,6 @@ btcx_align(struct v4l2_rect *win, struct v4l2_clip *clips, unsigned int n, int m
 void
 btcx_sort_clips(struct v4l2_clip *clips, unsigned int nclips)
 {
-	struct v4l2_clip swap;
 	int i,j,n;
 
 	if (nclips < 2)
@@ -168,9 +167,7 @@ btcx_sort_clips(struct v4l2_clip *clips, unsigned int nclips)
 	for (i = nclips-2; i >= 0; i--) {
 		for (n = 0, j = 0; j <= i; j++) {
 			if (clips[j].c.left > clips[j+1].c.left) {
-				swap = clips[j];
-				clips[j] = clips[j+1];
-				clips[j+1] = swap;
+				swap(clips[j], clips[j + 1]);
 				n++;
 			}
 		}
-- 
2.4.2

