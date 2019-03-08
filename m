Return-Path: <SRS0=k2dg=RL=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E089C10F09
	for <linux-media@archiver.kernel.org>; Fri,  8 Mar 2019 13:56:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0993C20661
	for <linux-media@archiver.kernel.org>; Fri,  8 Mar 2019 13:56:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726833AbfCHN4e (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 8 Mar 2019 08:56:34 -0500
Received: from lb2-smtp-cloud9.xs4all.net ([194.109.24.26]:37508 "EHLO
        lb2-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726800AbfCHN4c (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 8 Mar 2019 08:56:32 -0500
Received: from tschai.fritz.box ([212.251.195.8])
        by smtp-cloud9.xs4all.net with ESMTPA
        id 2Fz7hPu8XI8AW2FzChLWGH; Fri, 08 Mar 2019 14:56:31 +0100
From:   Hans Verkuil <hverkuil-cisco@xs4all.nl>
To:     linux-media@vger.kernel.org
Cc:     Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Helen Koike <helen.koike@collabora.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>
Subject: [PATCHv4 7/9] vimc: zero the media_device on probe
Date:   Fri,  8 Mar 2019 14:56:23 +0100
Message-Id: <20190308135625.11278-8-hverkuil-cisco@xs4all.nl>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190308135625.11278-1-hverkuil-cisco@xs4all.nl>
References: <20190308135625.11278-1-hverkuil-cisco@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMAE-Envelope: MS4wfCa5hWYgNNC07lkC3IT1K5S3bgsgC0za9RjbGz0DEjZ+YzS6D9ZeIwwA8iScYOm3xzEIlcYMpXwQnDe7awViX/3oEwb1E5TH7TwbOcCEkxuRHWN+xmKi
 aRZI1c17NJac0N0WPv47CPCMaa+rm5UzKNsX2BY8t4IVVwvpoB34h+NfZoZYr6X1u7zMXoEoTKL38n9WmKqVVJZ0xnKgH/demXIjC8qsw6bXQblAlWkV/VDp
 yIqomdi8sZwGvimsljOQgQJlBldn701r3Gm8Lv4iYF2hVVeRO3QWDfqrWGIX8l7VYJFs5cGM5NMRN9Zq5UshTw==
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

The media_device is part of a static global vimc_device struct.
The media framework expects this to be zeroed before it is
used, however, since this is a global this is not the case if
vimc is unbound and then bound again.

So call memset to ensure any left-over values are cleared.

Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
---
 drivers/media/platform/vimc/vimc-core.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/platform/vimc/vimc-core.c b/drivers/media/platform/vimc/vimc-core.c
index 0fbb7914098f..3aa62d7e3d0e 100644
--- a/drivers/media/platform/vimc/vimc-core.c
+++ b/drivers/media/platform/vimc/vimc-core.c
@@ -304,6 +304,8 @@ static int vimc_probe(struct platform_device *pdev)
 
 	dev_dbg(&pdev->dev, "probe");
 
+	memset(&vimc->mdev, 0, sizeof(vimc->mdev));
+
 	/* Create platform_device for each entity in the topology*/
 	vimc->subdevs = devm_kcalloc(&vimc->pdev.dev, vimc->pipe_cfg->num_ents,
 				     sizeof(*vimc->subdevs), GFP_KERNEL);
-- 
2.20.1

