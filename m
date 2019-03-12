Return-Path: <SRS0=ZIWa=RP=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE6F0C10F00
	for <linux-media@archiver.kernel.org>; Tue, 12 Mar 2019 23:50:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C2D02206BA
	for <linux-media@archiver.kernel.org>; Tue, 12 Mar 2019 23:50:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727372AbfCLXu1 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 12 Mar 2019 19:50:27 -0400
Received: from vsp-unauthed02.binero.net ([195.74.38.227]:1526 "EHLO
        vsp-unauthed02.binero.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726890AbfCLXu1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 12 Mar 2019 19:50:27 -0400
X-Halon-ID: 98880c96-4521-11e9-8144-0050569116f7
Authorized-sender: niklas@soderlund.pp.se
Received: from bismarck.berto.se (unknown [89.233.230.99])
        by bin-vsp-out-03.atm.binero.net (Halon) with ESMTPA
        id 98880c96-4521-11e9-8144-0050569116f7;
        Wed, 13 Mar 2019 00:50:25 +0100 (CET)
From:   =?UTF-8?q?Niklas=20S=C3=B6derlund?= 
        <niklas.soderlund+renesas@ragnatech.se>
To:     Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org
Cc:     linux-renesas-soc@vger.kernel.org,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?= 
        <niklas.soderlund+renesas@ragnatech.se>
Subject: [PATCH v3 0/3] rcar-csi2: Update start procedures to latest revision of datasheet
Date:   Wed, 13 Mar 2019 00:50:16 +0100
Message-Id: <20190312235019.23420-1-niklas.soderlund+renesas@ragnatech.se>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi,

This series update the driver to match changes in the latest datasheet
(rev 1.0 and 1.50). All changes are related to register setup when 
starting the stream.

This series depends on [PATCH v3] rcar-csi2: Propagate the FLD signal
for NTSC and PAL.

* Changes since v2
- Update commit message to include v1.0 and v1.50.
- Use wrappers to reduce static data for H3 ES2 special case.
- Collect review tags.

Niklas Söderlund (3):
  rcar-csi2: Update V3M and E3 start procedure
  rcar-csi2: Update start procedure for H3 ES2
  rcar-csi2: Move setting of Field Detection Control Register

 drivers/media/platform/rcar-vin/rcar-csi2.c | 47 +++++++++++++++------
 1 file changed, 35 insertions(+), 12 deletions(-)

-- 
2.21.0

