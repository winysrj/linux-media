Return-Path: <SRS0=xMd0=QZ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50A4BC10F01
	for <linux-media@archiver.kernel.org>; Mon, 18 Feb 2019 19:29:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1EEA321872
	for <linux-media@archiver.kernel.org>; Mon, 18 Feb 2019 19:29:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1550518160;
	bh=uIkkG/9Yj1H4iTH1wFFKK1wqOIyqHEQ3izT1JneLj6U=;
	h=From:Cc:Subject:Date:In-Reply-To:References:To:List-ID:From;
	b=gc4ChHmOtKCFtE2anZGPiQwM1szFb+RHSVxHr6DMx25o0wE14PAvTmJ4iRSA4dg8W
	 4uB8gAJBnyu98jxHOhdZdNN3/SU5lAyM5DysLflDZpqTbljGJmsGKXSVj4X+OVuTEC
	 D/WN9eIRxewM3qWicyYC2cfGm8xVyJ2Mdlw4QwRk=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726030AbfBRT3R (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 18 Feb 2019 14:29:17 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:34274 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726141AbfBRT3Q (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 18 Feb 2019 14:29:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=TqV5irFsJS1LgwCivkK74OH+ovgTwywshOToqWcbpZQ=; b=ftFj2O14ZlOI7yvoN+QowPkNqn
        fny9uTixunk5CMRF8OB2p9yqrS9LEIJ4H63ABlWXFMPUje/mhQw8pOmwdr8HkHC4i2zK3/J5ta6BA
        q1j1ndZjuRio5dIPBNQg634nlxBFFLTbxzXjUAB8tiHfuQg1PSMhiq2+stSYjKoMT3WBbeUZGda01
        DbpSzyV2YHadej54LwbOVXT8gEr9dcWv2RxPvUC180D53JRE+TLzg33O0cn8p7Uda9q5FAlboedcJ
        NZ2ixHd2/Q4cIg/W4729a74GvrPWFOffbDwyuJKYJMEjPP/MglzCHsAL9+Mhpcy+uLpUvx2s6FjGq
        qNfLIkJQ==;
Received: from 177.96.194.24.dynamic.adsl.gvt.net.br ([177.96.194.24] helo=bombadil.infradead.org)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1gvobJ-0002Up-9j; Mon, 18 Feb 2019 19:29:13 +0000
Received: from mchehab by bombadil.infradead.org with local (Exim 4.91)
        (envelope-from <mchehab@bombadil.infradead.org>)
        id 1gvobG-0006gR-Ex; Mon, 18 Feb 2019 14:29:10 -0500
From:   Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Pawel Osciak <pawel@osciak.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: [PATCH 11/14] media: common: fix several typos
Date:   Mon, 18 Feb 2019 14:29:05 -0500
Message-Id: <2ed377fbee4991589509407353cf6becd79021a1.1550518128.git.mchehab+samsung@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <f235ba60b2b7e5fba09d3c6b0d5dbbd8a86ea9b9.1550518128.git.mchehab+samsung@kernel.org>
References: <f235ba60b2b7e5fba09d3c6b0d5dbbd8a86ea9b9.1550518128.git.mchehab+samsung@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Use codespell to fix lots of typos over frontends.

Manually verified to avoid false-positives.

Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
---
 drivers/media/common/saa7146/saa7146_video.c      | 2 +-
 drivers/media/common/siano/sms-cards.c            | 2 +-
 drivers/media/common/siano/smscoreapi.h           | 2 +-
 drivers/media/common/videobuf2/videobuf2-dma-sg.c | 2 +-
 drivers/media/common/videobuf2/videobuf2-memops.c | 2 +-
 5 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/media/common/saa7146/saa7146_video.c b/drivers/media/common/saa7146/saa7146_video.c
index f90aa8109663..a0f0b5eef0bd 100644
--- a/drivers/media/common/saa7146/saa7146_video.c
+++ b/drivers/media/common/saa7146/saa7146_video.c
@@ -796,7 +796,7 @@ static int vidioc_s_fmt_vid_overlay(struct file *file, void *__fh, struct v4l2_f
 		return -EFAULT;
 	}
 
-	/* vv->ov.fh is used to indicate that we have valid overlay informations, too */
+	/* vv->ov.fh is used to indicate that we have valid overlay information, too */
 	vv->ov.fh = fh;
 
 	/* check if our current overlay is active */
diff --git a/drivers/media/common/siano/sms-cards.c b/drivers/media/common/siano/sms-cards.c
index af6b2268db61..e238c9bc17d3 100644
--- a/drivers/media/common/siano/sms-cards.c
+++ b/drivers/media/common/siano/sms-cards.c
@@ -311,7 +311,7 @@ int sms_board_led_feedback(struct smscore_device_t *coredev, int led)
 	int board_id = smscore_get_board_id(coredev);
 	struct sms_board *board = sms_get_board(board_id);
 
-	/* dont touch GPIO if LEDs are already set */
+	/* don't touch GPIO if LEDs are already set */
 	if (smscore_led_state(coredev, -1) == led)
 		return 0;
 
diff --git a/drivers/media/common/siano/smscoreapi.h b/drivers/media/common/siano/smscoreapi.h
index eb58853008c9..476fa7a8b152 100644
--- a/drivers/media/common/siano/smscoreapi.h
+++ b/drivers/media/common/siano/smscoreapi.h
@@ -750,7 +750,7 @@ struct sms_stats {
 	u32 num_of_corrected_mpe_tlbs;/* Number of MPE tables which were
 	corrected by MPE RS decoding */
 	/* Common params */
-	u32 ber_error_count;	/* Number of errornous SYNC bits. */
+	u32 ber_error_count;	/* Number of erroneous SYNC bits. */
 	u32 ber_bit_count;	/* Total number of SYNC bits. */
 
 	/* Interface information */
diff --git a/drivers/media/common/videobuf2/videobuf2-dma-sg.c b/drivers/media/common/videobuf2/videobuf2-dma-sg.c
index f02876d971d7..270c3162fdcb 100644
--- a/drivers/media/common/videobuf2/videobuf2-dma-sg.c
+++ b/drivers/media/common/videobuf2/videobuf2-dma-sg.c
@@ -67,7 +67,7 @@ static int vb2_dma_sg_alloc_compacted(struct vb2_dma_sg_buf *buf,
 		int i;
 
 		order = get_order(size);
-		/* Dont over allocate*/
+		/* Don't over allocate*/
 		if ((PAGE_SIZE << order) > size)
 			order--;
 
diff --git a/drivers/media/common/videobuf2/videobuf2-memops.c b/drivers/media/common/videobuf2/videobuf2-memops.c
index 89e51989332b..c4a85be48ac2 100644
--- a/drivers/media/common/videobuf2/videobuf2-memops.c
+++ b/drivers/media/common/videobuf2/videobuf2-memops.c
@@ -121,7 +121,7 @@ static void vb2_common_vm_close(struct vm_area_struct *vma)
 }
 
 /*
- * vb2_common_vm_ops - common vm_ops used for tracking refcount of mmaped
+ * vb2_common_vm_ops - common vm_ops used for tracking refcount of mmapped
  * video buffers
  */
 const struct vm_operations_struct vb2_common_vm_ops = {
-- 
2.20.1

