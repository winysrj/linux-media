Return-Path: <SRS0=AYlV=OX=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 731F1C6786C
	for <linux-media@archiver.kernel.org>; Fri, 14 Dec 2018 06:19:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4047A2086D
	for <linux-media@archiver.kernel.org>; Fri, 14 Dec 2018 06:19:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4047A2086D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=ragnatech.se
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726520AbeLNGTK (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 14 Dec 2018 01:19:10 -0500
Received: from vsp-unauthed02.binero.net ([195.74.38.227]:48483 "EHLO
        vsp-unauthed02.binero.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726494AbeLNGTK (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 14 Dec 2018 01:19:10 -0500
X-Halon-ID: 20adb41a-ff68-11e8-911a-0050569116f7
Authorized-sender: niklas@soderlund.pp.se
Received: from bismarck.berto.se (unknown [89.233.230.99])
        by bin-vsp-out-03.atm.binero.net (Halon) with ESMTPA
        id 20adb41a-ff68-11e8-911a-0050569116f7;
        Fri, 14 Dec 2018 07:19:01 +0100 (CET)
From:   =?UTF-8?q?Niklas=20S=C3=B6derlund?= 
        <niklas.soderlund+renesas@ragnatech.se>
To:     Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org
Cc:     linux-renesas-soc@vger.kernel.org,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?= 
        <niklas.soderlund+renesas@ragnatech.se>
Subject: [PATCH 0/4] rcar-vin: add support for suspend and resume
Date:   Fri, 14 Dec 2018 07:18:20 +0100
Message-Id: <20181214061824.10296-1-niklas.soderlund+renesas@ragnatech.se>
X-Mailer: git-send-email 2.19.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi,

This series add suspend and resume support for rcar-vin pipelines. It 
suspends all active pipelines and implicitly adds support for 
suspend/resume to rcar-csi2. It is tested on Gen3 and Gen2 and based 
on-top of latest media-tree.

Patch 1/4 fixes a bug in the driver which prevents suspend/resume to 
function properly. While patch 2/4 and 3/4 prepares for the feature and 
finally 4/4 enables support.

Niklas Söderlund (4):
  rcar-vin: fix wrong return value in rvin_set_channel_routing()
  rcar-vin: cache the CSI-2 channel selection value
  rcar-vin: make rvin_{start,stop}_streaming() available for internal
    use
  rcar-vin: add support for suspend and resume

 drivers/media/platform/rcar-vin/rcar-core.c | 51 +++++++++++++++++++++
 drivers/media/platform/rcar-vin/rcar-dma.c  | 24 +++++++---
 drivers/media/platform/rcar-vin/rcar-vin.h  | 15 ++++--
 3 files changed, 79 insertions(+), 11 deletions(-)

-- 
2.19.2

