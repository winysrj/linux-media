Return-Path: <SRS0=jH9h=P3=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A8A4C61CE3
	for <linux-media@archiver.kernel.org>; Sat, 19 Jan 2019 01:05:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0A7BD2087E
	for <linux-media@archiver.kernel.org>; Sat, 19 Jan 2019 01:05:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XKlWFYjR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727256AbfASBFH (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 18 Jan 2019 20:05:07 -0500
Received: from mail-pl1-f195.google.com ([209.85.214.195]:44256 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726325AbfASBFH (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 18 Jan 2019 20:05:07 -0500
Received: by mail-pl1-f195.google.com with SMTP id e11so7053896plt.11;
        Fri, 18 Jan 2019 17:05:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=DR6wQrOYCRD76/XALXGYcBsHpWArVMALpXWgTdCxRPU=;
        b=XKlWFYjRaCmTAQuh5EggygwHVM9RMNkaw2jstdar/lhRFWtXt30mMRQwr7zbZNNIBQ
         m0dkIOi69fg1/k66MubV80ylgqLmUTOT7drPXucmuSB/idrxcj3/54SGGcedPTuLERkq
         uTEIN1Ess3e0kcKTRaaMLVOqVMjL/nmebn47dmtRULLwzuN+YAAr34rZSEgFYkzUSL5C
         wM7zpLEM5rjdsTs5B0LQdpNs5ddP0pHXzc0s1G/f/HAGR2RPiB/SsNBWyKl3izMZETEA
         gnneJ031IMAUHxUw44O/8AlJDfwpEtN+5G9buT0MkMoLzRtRkxnqJKmD9pN1gEwLeH5A
         N9Rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=DR6wQrOYCRD76/XALXGYcBsHpWArVMALpXWgTdCxRPU=;
        b=AuOGehDGuLIMb6N7nYq4geIir9pnBa+G3J1vsoDntGmtD8TDvc8TAOzStGUCriKmEw
         U7AfSYS4wy+Q3KlQr5rchB4PM+FqaM1EfP/lNAvl0fjzvxxBdL4njgaBzNtZi6b5vkpz
         5sjWaCbxZoaT4wACijXQvsXB4tPJpW+2nZl8D73AXYZbz44hR/JSF35io4IxwIq2ZnKx
         5doFP2Yc90YpCtdcLwPmpFrCkV05nT3xyhnCXgr4Ykxa6MNC4boEeAwhZEYrExMvpf7a
         FFZvSIRT8mLtehLIwhJuIL8NLlIEZ6jgCrebKgjtkR1wXb4m0Ab4P9STZkKrEumddjuy
         i/Tg==
X-Gm-Message-State: AJcUukdR1qktBrGP0k0NTrbhnKye6fsZbVzEWd5cA74q7H8YxjDkfQ02
        GRz6MERkQxlheSOLBOTF4RamvEje98g=
X-Google-Smtp-Source: ALg8bN4QasAfyaqf8r2dleIhJeniM3vvKxcb5NrZWLN5dgAKF24tQLK4pyBPmRY7beU1lfBpZek0mw==
X-Received: by 2002:a17:902:9a81:: with SMTP id w1mr20407109plp.19.1547859905751;
        Fri, 18 Jan 2019 17:05:05 -0800 (PST)
Received: from majic.sklembedded.com (c-73-202-231-77.hsd1.ca.comcast.net. [73.202.231.77])
        by smtp.googlemail.com with ESMTPSA id w128sm7955307pfw.79.2019.01.18.17.05.04
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 18 Jan 2019 17:05:05 -0800 (PST)
From:   Steve Longerbeam <slongerbeam@gmail.com>
To:     linux-media@vger.kernel.org
Cc:     Gael PORTAY <gael.portay@collabora.com>,
        Peter Seiderer <ps.report@gmx.net>,
        Steve Longerbeam <slongerbeam@gmail.com>,
        stable@vger.kernel.org, Philipp Zabel <p.zabel@pengutronix.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org (open list:STAGING SUBSYSTEM),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v3 1/2] media: imx: csi: Disable SMFC before disabling IDMA channel
Date:   Fri, 18 Jan 2019 17:04:56 -0800
Message-Id: <20190119010457.2623-2-slongerbeam@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190119010457.2623-1-slongerbeam@gmail.com>
References: <20190119010457.2623-1-slongerbeam@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Disable the SMFC before disabling the IDMA channel, instead of after,
in csi_idmac_unsetup().

This fixes a complete system hard lockup on the SabreAuto when streaming
from the ADV7180, by repeatedly sending a stream off immediately followed
by stream on:

while true; do v4l2-ctl  -d4 --stream-mmap --stream-count=3; done

Eventually this either causes the system lockup or EOF timeouts at all
subsequent stream on, until a system reset.

The lockup occurs when disabling the IDMA channel at stream off. Stopping
the video data stream entering the IDMA channel before disabling the
channel itself appears to be a reliable fix for the hard lockup. That can
be done either by disabling the SMFC or the CSI before disabling the
channel. Disabling the SMFC before the channel is the easiest solution,
so do that.

Fixes: 4a34ec8e470cb ("[media] media: imx: Add CSI subdev driver")

Suggested-by: Peter Seiderer <ps.report@gmx.net>
Reported-by: Gaël PORTAY <gael.portay@collabora.com>
Signed-off-by: Steve Longerbeam <slongerbeam@gmail.com>
Cc: stable@vger.kernel.org
---
Changes in v3:
- switch from disabling the CSI before the channel to disabling the
  SMFC before the channel.
Changes in v2:
- restore an empty line
- Add Fixes: and Cc: stable
---
 drivers/staging/media/imx/imx-media-csi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/media/imx/imx-media-csi.c b/drivers/staging/media/imx/imx-media-csi.c
index e18f58f56dfb..8610027eac97 100644
--- a/drivers/staging/media/imx/imx-media-csi.c
+++ b/drivers/staging/media/imx/imx-media-csi.c
@@ -560,8 +560,8 @@ static int csi_idmac_setup_channel(struct csi_priv *priv)
 static void csi_idmac_unsetup(struct csi_priv *priv,
 			      enum vb2_buffer_state state)
 {
-	ipu_idmac_disable_channel(priv->idmac_ch);
 	ipu_smfc_disable(priv->smfc);
+	ipu_idmac_disable_channel(priv->idmac_ch);
 
 	csi_idmac_unsetup_vb2_buf(priv, state);
 }
-- 
2.17.1

