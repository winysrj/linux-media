Return-Path: <SRS0=k2dg=RL=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58072C10F0C
	for <linux-media@archiver.kernel.org>; Fri,  8 Mar 2019 23:57:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2D47A20684
	for <linux-media@archiver.kernel.org>; Fri,  8 Mar 2019 23:57:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726427AbfCHX5N (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 8 Mar 2019 18:57:13 -0500
Received: from bin-mail-out-05.binero.net ([195.74.38.228]:35963 "EHLO
        bin-mail-out-05.binero.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726094AbfCHX5N (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 8 Mar 2019 18:57:13 -0500
X-Halon-ID: de61dfb6-41fd-11e9-846a-005056917a89
Authorized-sender: niklas@soderlund.pp.se
Received: from bismarck.berto.se (unknown [89.233.230.99])
        by bin-vsp-out-01.atm.binero.net (Halon) with ESMTPA
        id de61dfb6-41fd-11e9-846a-005056917a89;
        Sat, 09 Mar 2019 00:57:08 +0100 (CET)
From:   =?UTF-8?q?Niklas=20S=C3=B6derlund?= 
        <niklas.soderlund+renesas@ragnatech.se>
To:     Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org
Cc:     linux-renesas-soc@vger.kernel.org,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?= 
        <niklas.soderlund+renesas@ragnatech.se>
Subject: [PATCH v2 0/3] rcar-csi2: Update start procedures to latest revision of datasheet
Date:   Sat,  9 Mar 2019 00:56:59 +0100
Message-Id: <20190308235702.27057-1-niklas.soderlund+renesas@ragnatech.se>
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
(rev 1.50). All changes are related to register setup when starting the
stream.

This series depends on [PATCH v2] rcar-csi2: Propagate the FLD signal 
for NTSC and PAL.

Niklas Söderlund (3):
  rcar-csi2: Update V3M and E3 start procedure
  rcar-csi2: Update start procedure for H3 ES2
  rcar-csi2: Move setting of Field Detection Control Register

 drivers/media/platform/rcar-vin/rcar-csi2.c | 51 +++++++++++++++++----
 1 file changed, 41 insertions(+), 10 deletions(-)

-- 
2.21.0

