Return-Path: <SRS0=k2dg=RL=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64540C10F0D
	for <linux-media@archiver.kernel.org>; Fri,  8 Mar 2019 23:49:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3B57420851
	for <linux-media@archiver.kernel.org>; Fri,  8 Mar 2019 23:49:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726352AbfCHXtg (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 8 Mar 2019 18:49:36 -0500
Received: from bin-mail-out-05.binero.net ([195.74.38.228]:33101 "EHLO
        bin-mail-out-05.binero.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726307AbfCHXtf (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 8 Mar 2019 18:49:35 -0500
X-Halon-ID: cea75bdb-41fc-11e9-846a-005056917a89
Authorized-sender: niklas@soderlund.pp.se
Received: from bismarck.berto.se (unknown [89.233.230.99])
        by bin-vsp-out-01.atm.binero.net (Halon) with ESMTPA
        id cea75bdb-41fc-11e9-846a-005056917a89;
        Sat, 09 Mar 2019 00:49:30 +0100 (CET)
From:   =?UTF-8?q?Niklas=20S=C3=B6derlund?= 
        <niklas.soderlund+renesas@ragnatech.se>
To:     Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org
Cc:     linux-renesas-soc@vger.kernel.org,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?= 
        <niklas.soderlund+renesas@ragnatech.se>
Subject: [PATCH v2 0/2] rcar-csi2: Use standby mode instead of resetting
Date:   Sat,  9 Mar 2019 00:47:20 +0100
Message-Id: <20190308234722.25775-1-niklas.soderlund+renesas@ragnatech.se>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi,

This small series updates rcar-csi2 to use the standby mode described in 
later versions of the datasheet.

* Changes since v1
- Break up enter and exit of standby mode in two separate functions.
- Add "select RESET_CONTROLLER" to Kconfig.

Niklas Söderlund (2):
  dt-bindings: rcar-csi2: List resets as a mandatory property
  rcar-csi2: Use standby mode instead of resetting

 .../bindings/media/renesas,rcar-csi2.txt      |  3 +-
 drivers/media/platform/rcar-vin/Kconfig       |  1 +
 drivers/media/platform/rcar-vin/rcar-csi2.c   | 69 +++++++++++--------
 3 files changed, 45 insertions(+), 28 deletions(-)

-- 
2.21.0

