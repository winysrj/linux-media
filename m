Return-Path: <SRS0=iic/=PR=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8647C43387
	for <linux-media@archiver.kernel.org>; Wed,  9 Jan 2019 18:17:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B39F720859
	for <linux-media@archiver.kernel.org>; Wed,  9 Jan 2019 18:17:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="qc0g96HM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726198AbfAISRb (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 9 Jan 2019 13:17:31 -0500
Received: from mail-pl1-f194.google.com ([209.85.214.194]:44646 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727728AbfAISRD (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 9 Jan 2019 13:17:03 -0500
Received: by mail-pl1-f194.google.com with SMTP id e11so3938375plt.11;
        Wed, 09 Jan 2019 10:17:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=BwIrt/QiZthUXo9qim2CsYJxYbNHfbi5cRl8NpsI+xE=;
        b=qc0g96HMoyahdxFH+33mN7X35erKicLfMQiUuNhysV5nOLV27f0JQf04v/cmlfIFnE
         0BlAWyeLDcq+PklPVAl5lh69v7xTEWVtLSBdT5nWdBjnVHxcxS7R92/CFXcWOp2Mu5KS
         IYZrCjr5BuGpIw9EexqKMgbD9iU2sNlHMQrIdMhysZOndc8t4x9cDK/+K+nROZq0VLDq
         NCSNFw0UADB56uJzatTMERwmEK9Yy4KKvUbdiFv4fpjqY5OBBrIrEnUPfkzcZ0L0xV30
         76h7g0BHrox6aCXuXrtx5njo16+5kZID5Ljp283Pd8jxCZJZ7QsjLJGp+9A0qWyvVkBw
         Imrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=BwIrt/QiZthUXo9qim2CsYJxYbNHfbi5cRl8NpsI+xE=;
        b=GruWDJI1lTc8RYQ0C/EeW5RYSJhVUec+oYpWKmrAgJNJIODI8qrE8RI10ceLnalmkm
         Ncn2ylXyKMNUVD7dev8eFGeBLYtWCK7ATXxkhQhPQ52YdiDkyLKR12NF5IfI90jYSKp7
         3OQd2gupVB6Lo6x2Vkktp7KeKvknUIEmsd+aeflqVaDaASFB4bFJvSn23f2elDGNyMrb
         TLtm8Bc2KQoQI/aR/WpAIT7cwxYlxa3czgx7Jgo9Lc14194NsSd7F589oWH42IipxxgP
         ihvDwalYimqkK46VFBFgqvvS6qBZkLcQC5Xs23YX9TtuCQ1au93+QE1XD/i48X0RPKGf
         +L+w==
X-Gm-Message-State: AJcUukcm6zqf92MiIoJIZA6C+H99oivMxgQr9yBTOQ9V+qYeWH87t5ae
        44jzOmOSzmciylsrvR+hHda7I1+c
X-Google-Smtp-Source: ALg8bN5TuhVcNrBXOJfvPNNXo2MPL4CstKnC9kYdJAStvOtKD1uzo2zqSGouB5jrmGrUXIoQIoqihg==
X-Received: by 2002:a17:902:765:: with SMTP id 92mr7093297pli.242.1547057822413;
        Wed, 09 Jan 2019 10:17:02 -0800 (PST)
Received: from majic.sklembedded.com (c-98-210-181-167.hsd1.ca.comcast.net. [98.210.181.167])
        by smtp.googlemail.com with ESMTPSA id h19sm97030004pfn.114.2019.01.09.10.17.01
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 09 Jan 2019 10:17:01 -0800 (PST)
From:   Steve Longerbeam <slongerbeam@gmail.com>
To:     linux-media@vger.kernel.org
Cc:     Steve Longerbeam <slongerbeam@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org (open list:STAGING SUBSYSTEM),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v7 08/11] media: imx: vdic: rely on VDIC for correct field order
Date:   Wed,  9 Jan 2019 10:16:38 -0800
Message-Id: <20190109181642.19378-9-slongerbeam@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190109181642.19378-1-slongerbeam@gmail.com>
References: <20190109181642.19378-1-slongerbeam@gmail.com>
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

