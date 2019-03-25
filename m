Return-Path: <SRS0=dbhF=R4=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76EE0C43381
	for <linux-media@archiver.kernel.org>; Mon, 25 Mar 2019 02:24:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 40E2320830
	for <linux-media@archiver.kernel.org>; Mon, 25 Mar 2019 02:24:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ideasonboard.com header.i=@ideasonboard.com header.b="pRGKAST9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729285AbfCYCYp (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sun, 24 Mar 2019 22:24:45 -0400
Received: from perceval.ideasonboard.com ([213.167.242.64]:33284 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729264AbfCYCYp (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 24 Mar 2019 22:24:45 -0400
Received: from pendragon.ideasonboard.com (30.net042126252.t-com.ne.jp [42.126.252.30])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id C4CC7E2
        for <linux-media@vger.kernel.org>; Mon, 25 Mar 2019 03:24:42 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1553480683;
        bh=elV2hwUu8nQsx6mK6+hLmapeVLS0B9nUvTfqQtp7y4w=;
        h=Date:From:To:Subject:From;
        b=pRGKAST9gmVHSmXU8BKtNNtV7Hc0roBaLVyFDct3KJg8vSkUJbKXdEbpZcVkOJ1r7
         dZMfSY5ikOvCivPkd862qd5V/0hZzUPhKGs6YONtygg4/apgzY3V4thQVBJrc53dbK
         LuVVRxXU0Gme3ErkHWk6rL4T88jWliZRyCWG32qo=
Date:   Mon, 25 Mar 2019 04:24:31 +0200
From:   Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To:     linux-media@vger.kernel.org
Subject: [GIT PULL FOR v5.2] R-Car FDP1 changes
Message-ID: <20190325022431.GA12029@pendragon.ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Mauro,

The following changes since commit 8a3946cad244e8453e26f3ded5fe40bf2627bb30:

  media: v4l2-fwnode: Add a deprecation note in the old ACPI parsing example (2019-03-20 06:37:55 -0400)

are available in the Git repository at:

  git://linuxtv.org/pinchartl/media.git tags/fdp1-next-20190325

for you to fetch changes up to aed816dcfd685dde720f3bb97857bd7db2c8f6cf:

  v4l: rcar_fdp1: Fix indentation oddities (2019-03-25 04:20:10 +0200)

----------------------------------------------------------------
FDP1 changes for v5.2

----------------------------------------------------------------
Laurent Pinchart (1):
      v4l: rcar_fdp1: Fix indentation oddities

 drivers/media/platform/rcar_fdp1.c | 28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

-- 
Regards,

Laurent Pinchart
