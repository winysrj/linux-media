Return-Path: <SRS0=+Qw+=RE=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DAB07C10F03
	for <linux-media@archiver.kernel.org>; Fri,  1 Mar 2019 17:09:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A9D4D20857
	for <linux-media@archiver.kernel.org>; Fri,  1 Mar 2019 17:09:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ideasonboard.com header.i=@ideasonboard.com header.b="OsD31j+e"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389355AbfCARJA (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 1 Mar 2019 12:09:00 -0500
Received: from perceval.ideasonboard.com ([213.167.242.64]:45338 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389295AbfCARI7 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 1 Mar 2019 12:08:59 -0500
Received: from localhost.localdomain (cpc89242-aztw30-2-0-cust488.18-1.cable.virginm.net [86.31.129.233])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id 233F349;
        Fri,  1 Mar 2019 18:08:57 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1551460137;
        bh=ZU9Fuw13XkqLKY7V4fdC/0o7EwcKg0+0EIiN0YrrU9c=;
        h=From:To:Cc:Subject:Date:From;
        b=OsD31j+ev8zcalb7gNkYuLDBldio0Fng/4rw5t8Uey9FUU4+JKskAozTZ0OymQHqu
         wtzfhK3lhWAPq8p8aVRqws3YkySx+KR1uBVbIDr1hUlKyX3sDGFLEmN6y4f2nXaYXK
         9ewBkPz8b7qRoXHUSiEk0wc3u3vSvXTtp7tOWfD4=
From:   Kieran Bingham <kieran.bingham@ideasonboard.com>
To:     Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Cc:     Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Subject: [RFC PATCH v2 0/5] media: vsp1: Partition phased overlap support
Date:   Fri,  1 Mar 2019 17:08:43 +0000
Message-Id: <20190301170848.6598-1-kieran.bingham@ideasonboard.com>
X-Mailer: git-send-email 2.19.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>

The UDS and SRU (and SHP) require expanded partition windows to support
overlapping partition windows as a means of discarding discontinous pixel data,
due to repeated pixels in their input filters.

The first four patches are clean ups and helpers to facilitate the
implementation of an updated procedure for calculating the partition windows.

The entities are iterated first backwards through the pipeline allowing them to
request an expanded input window if needed to satisfy their required output.

Then, as only the WPF can support clipping on the left edge, (though the UDS
can clip on it's right edge) the partition window is then propagated forwards
through the entity list allowing them to update any offset which will mark left
pixels to be discarded by the WPF.

Any expanded pixels to the right edge will automatically be clipped by the WPF
as it's partition window will remain fixed.

TODO:

There is one component left in this patch which is still to be completed. The
UDS calculation for the left input pixel position requires the output position
to be a multiple of the mp prefilter multiplier.

Getting the right correction to pull back the left window for this is still a
work in progress, and may be posted separately.

This series is posted as an RFC to get some review coverage (I'm looking at you
Laurent of course) while I continue to investigate the pull-back factor.


Kieran Bingham (5):
  media: vsp1: Define partition algorithm helper
  media: vsp1: Initialise partition windows
  media: vsp1: Document partition algorithm in code header
  media: vsp1: Split out pre-filter multiplier
  media: vsp1: Provide partition overlap algorithm

 drivers/media/platform/vsp1/vsp1_entity.h |   2 +-
 drivers/media/platform/vsp1/vsp1_pipe.c   |  48 +++++-
 drivers/media/platform/vsp1/vsp1_pipe.h   |   7 +
 drivers/media/platform/vsp1/vsp1_rpf.c    |  10 +-
 drivers/media/platform/vsp1/vsp1_sru.c    |  37 ++++-
 drivers/media/platform/vsp1/vsp1_uds.c    | 173 ++++++++++++++++++++--
 drivers/media/platform/vsp1/vsp1_video.c  |  13 +-
 drivers/media/platform/vsp1/vsp1_wpf.c    |  16 +-
 8 files changed, 276 insertions(+), 30 deletions(-)

-- 
2.19.1

