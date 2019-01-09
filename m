Return-Path: <SRS0=iic/=PR=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E03FC43444
	for <linux-media@archiver.kernel.org>; Wed,  9 Jan 2019 18:31:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4DFF921738
	for <linux-media@archiver.kernel.org>; Wed,  9 Jan 2019 18:31:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="emG33698"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727577AbfAISam (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 9 Jan 2019 13:30:42 -0500
Received: from mail-pg1-f195.google.com ([209.85.215.195]:42997 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727564AbfAISaj (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 9 Jan 2019 13:30:39 -0500
Received: by mail-pg1-f195.google.com with SMTP id d72so3658345pga.9;
        Wed, 09 Jan 2019 10:30:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=BwIrt/QiZthUXo9qim2CsYJxYbNHfbi5cRl8NpsI+xE=;
        b=emG336981TFdCUY7y0qoK45HeEv+pXU9lwS5N/BoNJGeYwDPZ42S31fu+s/ryOLg4N
         gU47Xonr5TjvkRfpC2H3uy3kF+ASHOFZVnwBXqDXz51QhxN0AqTDY7iiHlM1KfS08a2j
         uWUOFr3EiDXP1irH/JYtkUfoTGQkbLQ9bvZ7LpIT+M1ticqIUemgIU6C3YWwcCluwN1R
         CxGaipfZp0Qt0LefXqx9xpLKkPgagsXV7Lpp3njHFTsxonkheJmSXMawy3X0dwDzW4NG
         b2RiW9kXqMCVMSWp4iAt06bqpkRGwS2zjQCPnUFXFKA//eP/IOiACNW5zMUl26aSCNh0
         gYTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=BwIrt/QiZthUXo9qim2CsYJxYbNHfbi5cRl8NpsI+xE=;
        b=dbhKAPZCAoHOBgnkSZ6874t/glTdYvTX8WZiIU1Sn00NjElNyP/tJn6KTVyhfGJOQR
         uXG9ojQQJef3DOfy17kiAYOrnukTMNyDqOm02t6HAJ5RmhESHKm+1jrbJilVFDsxZPwC
         WLzbYLQh2UUDQHHJN+om3EdpEnOX47PBbqzZNVfibua6GZxsBycaHBbNS7/AbssFA7wY
         Cc7H4OrpWpgNWq5/zG4kKE4VEhXMFh1t4m0Mm+9CqMlvoGymWyZ5KRgQe/1XHvYptIef
         ZNwIdnZ9U5xWN7edlzbedYM5lye/0ddaFwy2uKmUUy2KwreD5HdfvvnKAvRSk1F4LhWN
         vxZA==
X-Gm-Message-State: AJcUukevbpUUw7yOvN28pxC3H7jqV6+kEyGhYikCD7Y+0GeyRD/3p6u0
        p76AMebFzdGH6xexLrNzQkC12mZh
X-Google-Smtp-Source: ALg8bN5vW8U5T1LzIGmQ7sPihf9u/sASnFuuodK/PKZyOufH/bedmrYRaB8/hMLjYxho6+kuOmPGwQ==
X-Received: by 2002:aa7:87ce:: with SMTP id i14mr7024922pfo.20.1547058638765;
        Wed, 09 Jan 2019 10:30:38 -0800 (PST)
Received: from majic.sklembedded.com (c-98-210-181-167.hsd1.ca.comcast.net. [98.210.181.167])
        by smtp.googlemail.com with ESMTPSA id v191sm157551056pgb.77.2019.01.09.10.30.37
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 09 Jan 2019 10:30:38 -0800 (PST)
From:   Steve Longerbeam <slongerbeam@gmail.com>
To:     linux-media@vger.kernel.org
Cc:     Steve Longerbeam <slongerbeam@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org (open list:STAGING SUBSYSTEM),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v8 08/11] media: imx: vdic: rely on VDIC for correct field order
Date:   Wed,  9 Jan 2019 10:30:11 -0800
Message-Id: <20190109183014.20466-9-slongerbeam@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190109183014.20466-1-slongerbeam@gmail.com>
References: <20190109183014.20466-1-slongerbeam@gmail.com>
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

