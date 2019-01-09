Return-Path: <SRS0=iic/=PR=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A17D2C43387
	for <linux-media@archiver.kernel.org>; Wed,  9 Jan 2019 00:16:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7078A20883
	for <linux-media@archiver.kernel.org>; Wed,  9 Jan 2019 00:16:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VZdkybwD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729580AbfAIAQO (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 8 Jan 2019 19:16:14 -0500
Received: from mail-pg1-f196.google.com ([209.85.215.196]:40076 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729569AbfAIAQO (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 8 Jan 2019 19:16:14 -0500
Received: by mail-pg1-f196.google.com with SMTP id z10so2464236pgp.7;
        Tue, 08 Jan 2019 16:16:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=BwIrt/QiZthUXo9qim2CsYJxYbNHfbi5cRl8NpsI+xE=;
        b=VZdkybwDcsoYv6tBaahD7DhnejAFNuVHNbUPxmPosRqTpdOboE6kDcLWdUngTZJpsF
         p9DFQox+Mk9qrOpPTkUaJy+OWjHnajMbw4qkLKgRGNOdPH+5C9vMritsT8z2dHclAp9Z
         m9cG++/ev0g1uNVf6F0mkzzqPfGKD+YQQWHH9MnfqzJmM6vMfRdNeSKJB2DRc9bVQH5q
         Om5Lqq2Ff9DDGOBHluaJpwrhM0wAaSnws3SuOdNcgWZUZEAqlTtBzgGCcHb4x2knQEFi
         5NM4iQwFLxemJOCOlFVSBgjE67ONd0PTIKXU9VbC/vxOGBcscRMx9WxgHcEJmhZnY3BO
         4khQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=BwIrt/QiZthUXo9qim2CsYJxYbNHfbi5cRl8NpsI+xE=;
        b=nFSVetBadnayU38w1LblfssgPlpaasz/5kI+wU5Ve1NjNn7Hadq3bfNSZSWG6X8V7I
         2rDHExbmtwRP9++Cob03TEV6fRU4MAyzOIm5C0afM3UANOcQ65YVPdo9NmwVB0QQGOr5
         9scJNWQblJzLibhhFxdkGfILi+YZt3MwrRY2IRjhHLu5mIujaT6s+4tR5TAWsoYpY83C
         k9O65rFU+GPQzhuO6p9ag35BsCTO3fREZdwdDEsjdis6n4MWt1usk0GsY2TQSq57P0S7
         srXcX6YnkKAOh/hLZh7nfR6HKUDLjwkGLpzfEEo5avQMdgpxn8apArQtwdoHnGXWzHnI
         nAIw==
X-Gm-Message-State: AJcUukfxfH1yoKAHo5ssk+1QiC7I2t9Bk4CWrk7WswxrjbZgLsfJguqW
        qiWybFeYaad+lmZCBxZkoRNS7oHG
X-Google-Smtp-Source: ALg8bN6IUk6ABHMKRC+26yGEcy07ZOdK/4rDY6FmyXzrXb3Y+R5hxciJ8UNTvQX5FXi48pACmm19Lg==
X-Received: by 2002:a63:5d20:: with SMTP id r32mr3429357pgb.329.1546992972806;
        Tue, 08 Jan 2019 16:16:12 -0800 (PST)
Received: from majic.sklembedded.com (c-98-210-181-167.hsd1.ca.comcast.net. [98.210.181.167])
        by smtp.googlemail.com with ESMTPSA id 134sm83978490pgb.78.2019.01.08.16.16.11
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 08 Jan 2019 16:16:12 -0800 (PST)
From:   Steve Longerbeam <slongerbeam@gmail.com>
To:     linux-media@vger.kernel.org
Cc:     Steve Longerbeam <slongerbeam@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org (open list:STAGING SUBSYSTEM),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v6 09/12] media: imx: vdic: rely on VDIC for correct field order
Date:   Tue,  8 Jan 2019 16:15:48 -0800
Message-Id: <20190109001551.16113-10-slongerbeam@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190109001551.16113-1-slongerbeam@gmail.com>
References: <20190109001551.16113-1-slongerbeam@gmail.com>
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

prepare_vdi_in_buffers() was setting up the dma pointers as if the
VDIC is always programmed to receive the fields in bottom-top order,
i.e. as if ipu_vdi_set_field_order() only programs BT order in the VDIC.
But that's not true, ipu_vdi_set_field_order() is working correctly.

So fix prepare_vdi_in_buffers() to give the VDIC the fields in whatever
order they were received by the video source, and rely on the VDIC to
sort out which is top and which is bottom.

Signed-off-by: Steve Longerbeam <slongerbeam@gmail.com>
---
 drivers/staging/media/imx/imx-media-vdic.c | 12 ++----------
 1 file changed, 2 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/media/imx/imx-media-vdic.c b/drivers/staging/media/imx/imx-media-vdic.c
index 482250d47e7c..4a890714193e 100644
--- a/drivers/staging/media/imx/imx-media-vdic.c
+++ b/drivers/staging/media/imx/imx-media-vdic.c
@@ -219,26 +219,18 @@ static void __maybe_unused prepare_vdi_in_buffers(struct vdic_priv *priv,
 
 	switch (priv->fieldtype) {
 	case V4L2_FIELD_SEQ_TB:
-		prev_phys = vb2_dma_contig_plane_dma_addr(prev_vb, 0);
-		curr_phys = vb2_dma_contig_plane_dma_addr(curr_vb, 0) + fs;
-		next_phys = vb2_dma_contig_plane_dma_addr(curr_vb, 0);
-		break;
 	case V4L2_FIELD_SEQ_BT:
 		prev_phys = vb2_dma_contig_plane_dma_addr(prev_vb, 0) + fs;
 		curr_phys = vb2_dma_contig_plane_dma_addr(curr_vb, 0);
 		next_phys = vb2_dma_contig_plane_dma_addr(curr_vb, 0) + fs;
 		break;
+	case V4L2_FIELD_INTERLACED_TB:
 	case V4L2_FIELD_INTERLACED_BT:
+	case V4L2_FIELD_INTERLACED:
 		prev_phys = vb2_dma_contig_plane_dma_addr(prev_vb, 0) + is;
 		curr_phys = vb2_dma_contig_plane_dma_addr(curr_vb, 0);
 		next_phys = vb2_dma_contig_plane_dma_addr(curr_vb, 0) + is;
 		break;
-	default:
-		/* assume V4L2_FIELD_INTERLACED_TB */
-		prev_phys = vb2_dma_contig_plane_dma_addr(prev_vb, 0);
-		curr_phys = vb2_dma_contig_plane_dma_addr(curr_vb, 0) + is;
-		next_phys = vb2_dma_contig_plane_dma_addr(curr_vb, 0);
-		break;
 	}
 
 	ipu_cpmem_set_buffer(priv->vdi_in_ch_p, 0, prev_phys);
-- 
2.17.1

