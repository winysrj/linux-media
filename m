Return-Path: <SRS0=xMd0=QZ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7383EC10F01
	for <linux-media@archiver.kernel.org>; Mon, 18 Feb 2019 19:29:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 453F8217F5
	for <linux-media@archiver.kernel.org>; Mon, 18 Feb 2019 19:29:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1550518155;
	bh=nQBYIPQ09ni9jpBAsdaNb8/Z7yVYNIYaiKCuE4DAf10=;
	h=From:Cc:Subject:Date:In-Reply-To:References:To:List-ID:From;
	b=s9DJPIJqrv1SNcLMcutYb0vkA/eTdgWf4nxIWVwlRBvdUqomVE5s9H6RiSkJD8Og6
	 bkWzHu33JvxJjWwa0oyg8Y1C2nty8Vcp0X9H73kA4e5+3HX9lMb7Jj1AteU4zOEB8N
	 cvjZbejTjujkuJFf1CDeDW0m6W4vV9ci9KYrua20=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726089AbfBRT3O (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 18 Feb 2019 14:29:14 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:34204 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725308AbfBRT3N (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 18 Feb 2019 14:29:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=NtNxCDkSKFyMENISOjMfwhG3Si0Dc8wfaMeu3FeGiEQ=; b=AhawJ4FaQMgpLkSh1rvdFlXw5R
        p3j8pTAavnOVAzwP/W9G2PZQcchygy6QMRz++ZBNJRN93YgKNh3a5lmAFziCO9cgcO3wDviwi/TN7
        Kl/GaOKSgNuiiPyWWErLppsHl7zhBELoKFXrei5Lyio0biiCfO16DjigjoHblL5yOzmrSMFoLjeGN
        Qj5QFzuIWLbSP6QV28rzjBwj/MKU1Br2TVQlV31Yyq+VWGbQWFPF6CfBQanRyQpvdlJiOT8wW5ewf
        8mn0urrbyJm1ZXL636epAmw4heIQ3yGLKP6v3hZhxFSl9pA//HBFuMMwo9F7lltIjSboIELDm7zD7
        ztnRNRfg==;
Received: from 177.96.194.24.dynamic.adsl.gvt.net.br ([177.96.194.24] helo=bombadil.infradead.org)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1gvobJ-0002Ul-5J; Mon, 18 Feb 2019 19:29:13 +0000
Received: from mchehab by bombadil.infradead.org with local (Exim 4.91)
        (envelope-from <mchehab@bombadil.infradead.org>)
        id 1gvobG-0006gD-ED; Mon, 18 Feb 2019 14:29:10 -0500
From:   Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 10/14] media: v4l2-core: fix several typos
Date:   Mon, 18 Feb 2019 14:29:04 -0500
Message-Id: <d8fc5756adce67c2793e923b49d4727254da8f29.1550518128.git.mchehab+samsung@kernel.org>
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
 drivers/media/v4l2-core/v4l2-fwnode.c         | 16 ++++++++--------
 drivers/media/v4l2-core/v4l2-ioctl.c          |  2 +-
 drivers/media/v4l2-core/videobuf-core.c       |  2 +-
 drivers/media/v4l2-core/videobuf-dma-contig.c |  2 +-
 drivers/media/v4l2-core/videobuf-vmalloc.c    |  2 +-
 5 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-fwnode.c b/drivers/media/v4l2-core/v4l2-fwnode.c
index 9bfedd7596a1..20571846e636 100644
--- a/drivers/media/v4l2-core/v4l2-fwnode.c
+++ b/drivers/media/v4l2-core/v4l2-fwnode.c
@@ -46,7 +46,7 @@ static const struct v4l2_fwnode_bus_conv {
 	enum v4l2_fwnode_bus_type fwnode_bus_type;
 	enum v4l2_mbus_type mbus_type;
 	const char *name;
-} busses[] = {
+} buses[] = {
 	{
 		V4L2_FWNODE_BUS_TYPE_GUESS,
 		V4L2_MBUS_UNKNOWN,
@@ -83,9 +83,9 @@ get_v4l2_fwnode_bus_conv_by_fwnode_bus(enum v4l2_fwnode_bus_type type)
 {
 	unsigned int i;
 
-	for (i = 0; i < ARRAY_SIZE(busses); i++)
-		if (busses[i].fwnode_bus_type == type)
-			return &busses[i];
+	for (i = 0; i < ARRAY_SIZE(buses); i++)
+		if (buses[i].fwnode_bus_type == type)
+			return &buses[i];
 
 	return NULL;
 }
@@ -113,9 +113,9 @@ get_v4l2_fwnode_bus_conv_by_mbus(enum v4l2_mbus_type type)
 {
 	unsigned int i;
 
-	for (i = 0; i < ARRAY_SIZE(busses); i++)
-		if (busses[i].mbus_type == type)
-			return &busses[i];
+	for (i = 0; i < ARRAY_SIZE(buses); i++)
+		if (buses[i].mbus_type == type)
+			return &buses[i];
 
 	return NULL;
 }
@@ -809,7 +809,7 @@ static int v4l2_fwnode_reference_parse(struct device *dev,
  * root node and the value of that property matching with the integer argument
  * of the reference, at the same index.
  *
- * The child fwnode reched at the end of the iteration is then returned to the
+ * The child fwnode reached at the end of the iteration is then returned to the
  * caller.
  *
  * The core reason for this is that you cannot refer to just any node in ACPI.
diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
index 206b7348797e..fbf4ce7b54eb 100644
--- a/drivers/media/v4l2-core/v4l2-ioctl.c
+++ b/drivers/media/v4l2-core/v4l2-ioctl.c
@@ -88,7 +88,7 @@ const char *v4l2_norm_to_name(v4l2_std_id id)
 	int i;
 
 	/* HACK: ppc32 architecture doesn't have __ucmpdi2 function to handle
-	   64 bit comparations. So, on that architecture, with some gcc
+	   64 bit comparisons. So, on that architecture, with some gcc
 	   variants, compilation fails. Currently, the max value is 30bit wide.
 	 */
 	BUG_ON(myid != id);
diff --git a/drivers/media/v4l2-core/videobuf-core.c b/drivers/media/v4l2-core/videobuf-core.c
index d1bcfa91aaf8..5e3636615f5c 100644
--- a/drivers/media/v4l2-core/videobuf-core.c
+++ b/drivers/media/v4l2-core/videobuf-core.c
@@ -214,7 +214,7 @@ int videobuf_queue_is_busy(struct videobuf_queue *q)
 			return 1;
 		}
 		if (q->bufs[i]->state == VIDEOBUF_ACTIVE) {
-			dprintk(1, "busy: buffer #%d avtive\n", i);
+			dprintk(1, "busy: buffer #%d active\n", i);
 			return 1;
 		}
 	}
diff --git a/drivers/media/v4l2-core/videobuf-dma-contig.c b/drivers/media/v4l2-core/videobuf-dma-contig.c
index f46132504d88..e1bf50df4c70 100644
--- a/drivers/media/v4l2-core/videobuf-dma-contig.c
+++ b/drivers/media/v4l2-core/videobuf-dma-contig.c
@@ -248,7 +248,7 @@ static int __videobuf_iolock(struct videobuf_queue *q,
 
 		/* All handling should be done by __videobuf_mmap_mapper() */
 		if (!mem->vaddr) {
-			dev_err(q->dev, "memory is not alloced/mmapped.\n");
+			dev_err(q->dev, "memory is not allocated/mmapped.\n");
 			return -EINVAL;
 		}
 		break;
diff --git a/drivers/media/v4l2-core/videobuf-vmalloc.c b/drivers/media/v4l2-core/videobuf-vmalloc.c
index 293213ad9ef7..cb50f1957828 100644
--- a/drivers/media/v4l2-core/videobuf-vmalloc.c
+++ b/drivers/media/v4l2-core/videobuf-vmalloc.c
@@ -171,7 +171,7 @@ static int __videobuf_iolock(struct videobuf_queue *q,
 
 		/* All handling should be done by __videobuf_mmap_mapper() */
 		if (!mem->vaddr) {
-			printk(KERN_ERR "memory is not alloced/mmapped.\n");
+			printk(KERN_ERR "memory is not allocated/mmapped.\n");
 			return -EINVAL;
 		}
 		break;
-- 
2.20.1

