Return-Path: <SRS0=tJec=Q3=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D465CC43381
	for <linux-media@archiver.kernel.org>; Wed, 20 Feb 2019 01:09:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A2B6E217D9
	for <linux-media@archiver.kernel.org>; Wed, 20 Feb 2019 01:09:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jsxnb+ib"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727547AbfBTBJr (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 19 Feb 2019 20:09:47 -0500
Received: from mail-pg1-f196.google.com ([209.85.215.196]:33576 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726016AbfBTBJr (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 19 Feb 2019 20:09:47 -0500
Received: by mail-pg1-f196.google.com with SMTP id h11so8616151pgl.0;
        Tue, 19 Feb 2019 17:09:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=/ZXl8u2+Ji7jhuDrdnqY/X5VDHJkz/h056CNe/x5sP4=;
        b=jsxnb+ibyvF08NSmHdch3pRCMIHSBnKTIZk24PhDBzBYqpRiKQ9vQAbL1IgmeN1eGU
         UaAVAQdedikJ/e+b41TIvRAhJdYbIuXHuEWK+NC+Vw+jfGKQXgllwAS0p1DHyD1iQ08m
         smh/jSnbFf7qt3iC+aydS2JvKCQJXiSlKnijyJErpCf8SCKw74i2UHPxJR659u26JHyd
         td5NnDkJDNgTlsXPtpkeUlmVVRiUHHBzSeck71KEXCUi6gtiNshfXNOYmKow/IJs8by5
         zug33pXZcGM7/ezAk3RM1XUun7isPZs4vrd+mJZdYAobARbp0rWy91ayj+dPPuZI502Y
         mruA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=/ZXl8u2+Ji7jhuDrdnqY/X5VDHJkz/h056CNe/x5sP4=;
        b=fQOcdVcKnllnIi2WX5DxXF0EtPUrzPAOWEfdo+QwM63+ZMO666qPwsJEcqbSsqrkhd
         dejwFu8FvP51i90IFOtOkCKRoXbJu+l0f/2Ef2X8b/7PRjPAuJDw8ozF795fgISH+zBZ
         dM4gAEOC8YvAiYJnpd7UOc3VmZEqU+NIGgPA3fl05ijkGT00rWbe4ZOWHfSNOzje/a8A
         jnyww0kg195rsDQRZLWhqG51boWgEMf3psr1DCs3Y2MHqTpv7MI9s+U0mR+2ORhybwWk
         bSh90U9iSCrMIKFDnDWWJA+FUIJrTlt4EvfJNXKQ7V5dNwvUD/nNJNecDOKQlnr2OVQS
         hajw==
X-Gm-Message-State: AHQUAualF0VJQ0nmd58IRcSPcKgYXl5hACOyxCSFKz1NQiPN86NyVKRm
        59wpraLL+Zq8wvads+6UC1nm0j5l
X-Google-Smtp-Source: AHgI3IZ9HOc+W0MAtLDj4iqrkQCb3s5VnEvATLHqkmTUtwEcPJLLmLMmmyIBlHn/K2LGNB0R2B54pA==
X-Received: by 2002:a63:2882:: with SMTP id o124mr26878378pgo.446.1550624986007;
        Tue, 19 Feb 2019 17:09:46 -0800 (PST)
Received: from majic.sklembedded.com (c-73-202-231-77.hsd1.ca.comcast.net. [73.202.231.77])
        by smtp.googlemail.com with ESMTPSA id 67sm58685582pfl.175.2019.02.19.17.09.44
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 19 Feb 2019 17:09:45 -0800 (PST)
From:   Steve Longerbeam <slongerbeam@gmail.com>
To:     linux-media@vger.kernel.org
Cc:     Steve Longerbeam <slongerbeam@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org (open list:STAGING SUBSYSTEM),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] media: imx: vdic: Restore default case to prepare_vdi_in_buffers()
Date:   Tue, 19 Feb 2019 17:09:38 -0800
Message-Id: <20190220010938.5197-1-slongerbeam@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Restore a default case to prepare_vdi_in_buffers() to fix the following
smatch errors:

drivers/staging/media/imx/imx-media-vdic.c:236 prepare_vdi_in_buffers() error: uninitialized symbol 'prev_phys'.
drivers/staging/media/imx/imx-media-vdic.c:237 prepare_vdi_in_buffers() error: uninitialized symbol 'curr_phys'.
drivers/staging/media/imx/imx-media-vdic.c:238 prepare_vdi_in_buffers() error: uninitialized symbol 'next_phys'.

Fixes: 6e537b58de772 ("media: imx: vdic: rely on VDIC for correct field order")

Reported-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Steve Longerbeam <slongerbeam@gmail.com>
---
 drivers/staging/media/imx/imx-media-vdic.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/staging/media/imx/imx-media-vdic.c b/drivers/staging/media/imx/imx-media-vdic.c
index 2808662e2597..37bfbd4a1c39 100644
--- a/drivers/staging/media/imx/imx-media-vdic.c
+++ b/drivers/staging/media/imx/imx-media-vdic.c
@@ -231,6 +231,12 @@ static void __maybe_unused prepare_vdi_in_buffers(struct vdic_priv *priv,
 		curr_phys = vb2_dma_contig_plane_dma_addr(curr_vb, 0);
 		next_phys = vb2_dma_contig_plane_dma_addr(curr_vb, 0) + is;
 		break;
+	default:
+		/*
+		 * can't get here, priv->fieldtype can only be one of
+		 * the above. This is to quiet smatch errors.
+		 */
+		return;
 	}
 
 	ipu_cpmem_set_buffer(priv->vdi_in_ch_p, 0, prev_phys);
-- 
2.17.1

