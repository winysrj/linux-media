Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:2448 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752465AbaCGKh6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 7 Mar 2014 05:37:58 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEW PATCH for v3.14 3/3] saa7134: fix WARN_ON during resume.
Date: Fri,  7 Mar 2014 11:37:49 +0100
Message-Id: <1394188669-22260-4-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1394188669-22260-1-git-send-email-hverkuil@xs4all.nl>
References: <1394188669-22260-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Do not attempt to reload the tuner modules when resuming after a suspend.
This triggers a WARN_ON in kernel/kmod.c:148 __request_module.

This fixes https://bugzilla.kernel.org/show_bug.cgi?id=69581.

This has always been wrong, but it was never noticed until the WARN_ON
was added in 3.9.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/pci/saa7134/saa7134-cards.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/pci/saa7134/saa7134-cards.c b/drivers/media/pci/saa7134/saa7134-cards.c
index d45e7f6..e87a734 100644
--- a/drivers/media/pci/saa7134/saa7134-cards.c
+++ b/drivers/media/pci/saa7134/saa7134-cards.c
@@ -8045,8 +8045,8 @@ int saa7134_board_init2(struct saa7134_dev *dev)
 		break;
 	} /* switch() */
 
-	/* initialize tuner */
-	if (TUNER_ABSENT != dev->tuner_type) {
+	/* initialize tuner (don't do this when resuming) */
+	if (!dev->insuspend && TUNER_ABSENT != dev->tuner_type) {
 		int has_demod = (dev->tda9887_conf & TDA9887_PRESENT);
 
 		/* Note: radio tuner address is always filled in,
-- 
1.9.0

