Return-Path: <SRS0=tJec=Q3=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D88E5C43381
	for <linux-media@archiver.kernel.org>; Wed, 20 Feb 2019 12:51:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A5F8A2147C
	for <linux-media@archiver.kernel.org>; Wed, 20 Feb 2019 12:51:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ideasonboard.com header.i=@ideasonboard.com header.b="S9HBPYxX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728034AbfBTMve (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 20 Feb 2019 07:51:34 -0500
Received: from perceval.ideasonboard.com ([213.167.242.64]:59600 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727879AbfBTMvd (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 20 Feb 2019 07:51:33 -0500
Received: from pendragon.bb.dnainternet.fi (81-175-216-236.bb.dnainternet.fi [81.175.216.236])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id 756FB2D1;
        Wed, 20 Feb 2019 13:51:31 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1550667091;
        bh=w3HtSSulrFeckP/igv3PuIVlXXRr55usgK+w01zQxLc=;
        h=From:To:Cc:Subject:Date:From;
        b=S9HBPYxXnQhJ3dio4k+f+DvlyP6Z/URM0W3f37gE1sGfble7hlGIQLVjJzlyKUpCw
         s61yV6GqnsCDBEWPkz6cbH02Ex6HVJ7FerDyQBP3hYaSiIrFShOJJgkWwTjfpQAtCs
         s6fHtvcq4i5SESuxyaBEs31P3hKR6zLqk7lTXiF4=
From:   Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To:     linux-media@vger.kernel.org
Cc:     Kieran Bingham <kieran.bingham@ideasonboard.com>
Subject: [PATCH yavta 0/7] Compound controls and controls reset support
Date:   Wed, 20 Feb 2019 14:51:16 +0200
Message-Id: <20190220125123.9410-1-laurent.pinchart@ideasonboard.com>
X-Mailer: git-send-email 2.19.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hello,

This patch series implements support for compound controls in yavta,
including the ability to reset controls to their default value. Only
array compound controls are supported for now, other types may be added
later.

The patches have lived out of the master branch for long enough, it's
time to get them merged.

Kieran Bingham (1):
  Add support to reset device controls

Laurent Pinchart (6):
  yavta: Refactor video_list_controls()
  Implement VIDIOC_QUERY_EXT_CTRL support
  Implement compound control get support
  Implement compound control set support
  Support setting control from values stored in a file
  Remove unneeded conditional compilation for old V4L2 API versions

 yavta.c | 602 +++++++++++++++++++++++++++++++++++++++++++-------------
 1 file changed, 464 insertions(+), 138 deletions(-)

-- 
Regards,

Laurent Pinchart

