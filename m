Return-Path: <SRS0=adTL=RQ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6EB28C10F0F
	for <linux-media@archiver.kernel.org>; Wed, 13 Mar 2019 00:06:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4258E214AE
	for <linux-media@archiver.kernel.org>; Wed, 13 Mar 2019 00:06:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ideasonboard.com header.i=@ideasonboard.com header.b="P4G9/VSg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727565AbfCMAGH (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 12 Mar 2019 20:06:07 -0400
Received: from perceval.ideasonboard.com ([213.167.242.64]:42054 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727403AbfCMAGA (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 12 Mar 2019 20:06:00 -0400
Received: from pendragon.bb.dnainternet.fi (81-175-216-236.bb.dnainternet.fi [81.175.216.236])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id A8FDB9C5;
        Wed, 13 Mar 2019 01:05:53 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1552435554;
        bh=Yl3iW5ZQXBZJn+Yy1IB/dkIyi4AaR7UB8SMaDjBSXjE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P4G9/VSgjiVkw5vkLDzdfzynZV/dFHeM993Q+RFKUmUiqK9KuFtwQti1d4m7kuLb4
         0Tfy3kCNyuPEVHHm9fosVL6EEjprdDzwxKbwJAJM0G2yMzWtNtsHtTqRC/urZn31Ih
         R0pUJrq9uxA8TVsE6EMJnDk3kXgAUUI6hfo/yHyo=
From:   Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To:     dri-devel@lists.freedesktop.org
Cc:     linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Liviu Dudau <Liviu.Dudau@arm.com>,
        Brian Starkey <brian.starkey@arm.com>,
        Kieran Bingham <kieran.bingham@ideasonboard.com>
Subject: [PATCH v6 15/18] drm: rcar-du: Fix rcar_du_crtc structure documentation
Date:   Wed, 13 Mar 2019 02:05:29 +0200
Message-Id: <20190313000532.7087-16-laurent.pinchart+renesas@ideasonboard.com>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20190313000532.7087-1-laurent.pinchart+renesas@ideasonboard.com>
References: <20190313000532.7087-1-laurent.pinchart+renesas@ideasonboard.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

The rcar_du_crtc structure index field contains the CRTC hardware index,
not the hardware and software index. Update the documentation
accordingly.

Fixes: 5361cc7f8e91 ("drm: rcar-du: Split CRTC handling to support hardware indexing")
Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Reviewed-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
---
 drivers/gpu/drm/rcar-du/rcar_du_crtc.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/rcar-du/rcar_du_crtc.h b/drivers/gpu/drm/rcar-du/rcar_du_crtc.h
index bcb35b0b7612..c478953be092 100644
--- a/drivers/gpu/drm/rcar-du/rcar_du_crtc.h
+++ b/drivers/gpu/drm/rcar-du/rcar_du_crtc.h
@@ -27,7 +27,7 @@ struct rcar_du_vsp;
  * @clock: the CRTC functional clock
  * @extclock: external pixel dot clock (optional)
  * @mmio_offset: offset of the CRTC registers in the DU MMIO block
- * @index: CRTC software and hardware index
+ * @index: CRTC hardware index
  * @initialized: whether the CRTC has been initialized and clocks enabled
  * @dsysr: cached value of the DSYSR register
  * @vblank_enable: whether vblank events are enabled on this CRTC
-- 
Regards,

Laurent Pinchart

