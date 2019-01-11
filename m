Return-Path: <SRS0=SCQz=PT=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E90FC43612
	for <linux-media@archiver.kernel.org>; Fri, 11 Jan 2019 17:41:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1823120870
	for <linux-media@archiver.kernel.org>; Fri, 11 Jan 2019 17:41:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ideasonboard.com header.i=@ideasonboard.com header.b="SkvNAmXy"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731459AbfAKRls (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 11 Jan 2019 12:41:48 -0500
Received: from perceval.ideasonboard.com ([213.167.242.64]:33714 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730100AbfAKRls (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 11 Jan 2019 12:41:48 -0500
Received: from localhost.localdomain (cpc89242-aztw30-2-0-cust488.18-1.cable.virginm.net [86.31.129.233])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id DA6F753E;
        Fri, 11 Jan 2019 18:41:45 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1547228506;
        bh=mF0IgxJu9knnf20ipHtY8kls114XAOdfh5tm+YBaADc=;
        h=From:To:Cc:Subject:Date:From;
        b=SkvNAmXypf8MeEXl/MatJ1IFUCHG77OT3f3+wcPqTy8jjagbl1d+GRqIicRCCw5Sb
         yVhZ4NLP9pKP9M+/vOCp/MI67Ktod7ZAuiEJi0xeOVto9yQ6zXxbmsaAiWmQAmBj6t
         tOf+qXo+s+jIF8PZjVMDGazZAlkiMJ2/pKBRdUtA=
From:   Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
To:     Koji Matsuoka <koji.matsuoka.xm@renesas.com>,
        Jacopo Mondi <jacopo@jmondi.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?= <niklas.soderlund@ragnatech.se>,
        Steve Longerbeam <steve_longerbeam@mentor.com>
Cc:     linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Subject: [PATCH 0/2] media: i2c: adv748x: Refactor sw_reset handling
Date:   Fri, 11 Jan 2019 17:41:39 +0000
Message-Id: <20190111174141.12594-1-kieran.bingham+renesas@ideasonboard.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

The sw_reset functionality was implemented through a poorly documented
set of 'required writes' from a table.

This also included an delay in the table which required a 'hack' in the
adv748x_write() routines.

These patches rework the reset handling to a function and remove the
delay workaround.

Kieran Bingham (2):
  media: i2c: adv748x: Convert SW reset routine to function
  media: i2c: adv748x: Remove PAGE_WAIT

 drivers/media/i2c/adv748x/adv748x-core.c | 49 ++++++++++++++----------
 drivers/media/i2c/adv748x/adv748x.h      | 17 +++++++-
 2 files changed, 44 insertions(+), 22 deletions(-)

-- 
2.17.1

