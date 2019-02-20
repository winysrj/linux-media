Return-Path: <SRS0=tJec=Q3=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C78EC43381
	for <linux-media@archiver.kernel.org>; Wed, 20 Feb 2019 15:20:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5C4322086A
	for <linux-media@archiver.kernel.org>; Wed, 20 Feb 2019 15:20:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ideasonboard.com header.i=@ideasonboard.com header.b="NzBlqHFn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727367AbfBTPUB (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 20 Feb 2019 10:20:01 -0500
Received: from perceval.ideasonboard.com ([213.167.242.64]:42010 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726291AbfBTPUB (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 20 Feb 2019 10:20:01 -0500
Received: from pendragon.bb.dnainternet.fi (dfj612yhrgyx302h3jwwy-3.rev.dnainternet.fi [IPv6:2001:14ba:21f5:5b00:ce28:277f:58d7:3ca4])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id A512D2D1;
        Wed, 20 Feb 2019 16:19:59 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1550675999;
        bh=41HnJMTNfmefKmU7XisWaYsYWPLI5g5bu7PaDbviRDk=;
        h=From:To:Cc:Subject:Date:From;
        b=NzBlqHFnCZ58vCTSGZnVd8Ymuk6IOSSxioJwfXyvfo6R8kk7jpWsIcYB7HQug5oXE
         dqm4B17Aa6Hnojl1oMhmU97jGaszlyguJ6l+VM0lKenQukqHl/1A1OBYAXDlFl6U9y
         Jk3XxQsDiWIxwFd+Yx/59ZWQstNHpzs0tliPee7w=
From:   Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To:     linux-media@vger.kernel.org
Cc:     Kieran Bingham <kieran.bingham@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@iki.fi>
Subject: [PATCH yavta 0/3] Fixes for compound control support
Date:   Wed, 20 Feb 2019 17:19:49 +0200
Message-Id: <20190220151952.15376-1-laurent.pinchart@ideasonboard.com>
X-Mailer: git-send-email 2.19.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hello,

This small series fixes issues in yavta reported during the review of
the compound control support patches.

Laurent Pinchart (3):
  Fix emulation of old API for string controls
  Print numerical control type for unsupported types
  Fix control array parsing

 yavta.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

-- 
Regards,

Laurent Pinchart

