Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f42.google.com ([74.125.82.42]:60700 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751854AbbAARsa (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 1 Jan 2015 12:48:30 -0500
Received: by mail-wg0-f42.google.com with SMTP id k14so23485912wgh.29
        for <linux-media@vger.kernel.org>; Thu, 01 Jan 2015 09:48:29 -0800 (PST)
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] media: platform: vsp1: vsp1_hsit:  Remove unused function
Date: Thu,  1 Jan 2015 18:51:30 +0100
Message-Id: <1420134690-993-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Remove the function vsp1_hsit_read() that is not used anywhere.

This was partially found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/media/platform/vsp1/vsp1_hsit.c |    5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/media/platform/vsp1/vsp1_hsit.c b/drivers/media/platform/vsp1/vsp1_hsit.c
index db2950a..9fb003b 100644
--- a/drivers/media/platform/vsp1/vsp1_hsit.c
+++ b/drivers/media/platform/vsp1/vsp1_hsit.c
@@ -26,11 +26,6 @@
  * Device Access
  */
 
-static inline u32 vsp1_hsit_read(struct vsp1_hsit *hsit, u32 reg)
-{
-	return vsp1_read(hsit->entity.vsp1, reg);
-}
-
 static inline void vsp1_hsit_write(struct vsp1_hsit *hsit, u32 reg, u32 data)
 {
 	vsp1_write(hsit->entity.vsp1, reg, data);
-- 
1.7.10.4

