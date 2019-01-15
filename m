Return-Path: <SRS0=Ztfs=PX=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1FE7C43387
	for <linux-media@archiver.kernel.org>; Tue, 15 Jan 2019 00:14:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A61F620659
	for <linux-media@archiver.kernel.org>; Tue, 15 Jan 2019 00:14:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=codyps.com header.i=@codyps.com header.b="buicu8ZM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726911AbfAOAOh (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 14 Jan 2019 19:14:37 -0500
Received: from mail-qk1-f195.google.com ([209.85.222.195]:45602 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726769AbfAOAOh (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 14 Jan 2019 19:14:37 -0500
Received: by mail-qk1-f195.google.com with SMTP id y78so571103qka.12
        for <linux-media@vger.kernel.org>; Mon, 14 Jan 2019 16:14:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=codyps.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=U3/XlavFaV+83MK62S0qixF0uFWWpLHgt5a5yu35Agc=;
        b=buicu8ZMu5wkDF6oZmeci2+cyaWDaWjxu06XOAv2AVC9GSdgFvHoHQbKIMqOHuLQxR
         G1wXyqqBkSadPFjr04BL3Z0kE5QiuWUnZev9swbfASvDsj6WUMM7QvjntNXCr46Cohoq
         l/l2MEiDmoShBWss73LQgN0CVHoMCxCpCWJ3E=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=U3/XlavFaV+83MK62S0qixF0uFWWpLHgt5a5yu35Agc=;
        b=azm3yfVeqqg1g2PqvodEJhgMRKsbBPeCrT0Cr3gNRvjILNn/UQrr4CfXwJf6GBf552
         p+zdex/4T4KN2pQwp8i9PGNlEut84e5fqOJ2TG5KDgG58wkzUeDA3Xs3vQXf5pwhiQdN
         Nfo+I3A/v47E0pfS36PaJUjlvPFkP78K6RTylXmcJUDOogSzkV5aUGBdfa6rtEUuTD4+
         +GpCRU08xvyEfkBAxHkyPXRfGhagFEUQ1lHhosqSRVkNfpOB1EJ7KGiX0yRg5KQG6iUa
         bU2LsnfFB0WJ+18xSRfbQvbO4Kfk9g6I7idoIjjgZWEsAmrGx8Jn9dS4gCYnEm3C4wFd
         LhCQ==
X-Gm-Message-State: AJcUukdqefmWACJwsVBPDWXe8TyzKjYIXaNKYUf8wpBkZ5pAWAw/b3RJ
        38vqnZU5zJlqO/Isg4lA7a78
X-Google-Smtp-Source: ALg8bN5j9ApHaKZhTUZy5ALgwxurn5N80Cvs7BjfNAXNy0vz/+ln1ADzSmLeTgoSyTphGGtqQbkexA==
X-Received: by 2002:a37:aa0c:: with SMTP id t12mr795204qke.358.1547511276388;
        Mon, 14 Jan 2019 16:14:36 -0800 (PST)
Received: from localhost ([2601:18f:880:9aee::8bb])
        by smtp.gmail.com with ESMTPSA id a17sm52358384qtk.82.2019.01.14.16.14.34
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 14 Jan 2019 16:14:35 -0800 (PST)
From:   Cody P Schafer <dev@codyps.com>
To:     "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>,
        Brad Love <brad@nextdimension.cc>,
        Cody P Schafer <dev@codyps.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc:     stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org
Subject: [PATCH] media: cx25840: mark pad sig_types to fix cx231xx init
Date:   Mon, 14 Jan 2019 19:14:24 -0500
Message-Id: <20190115001431.10276-1-dev@codyps.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Without this, we get failures like this when the kernel attempts to
initialize a cx231xx device:

	[16046.153653] cx231xx 3-1.2:1.1: New device Hauppauge Hauppauge Device @ 480 Mbps (2040:c200) with 6 interfaces
	[16046.153900] cx231xx 3-1.2:1.1: can't change interface 3 alt no. to 3: Max. Pkt size = 0
	[16046.153907] cx231xx 3-1.2:1.1: Identified as Hauppauge USB Live 2 (card=9)
	[16046.154350] i2c i2c-11: Added multiplexed i2c bus 13
	[16046.154379] i2c i2c-11: Added multiplexed i2c bus 14
	[16046.267194] cx25840 10-0044: cx23102 A/V decoder found @ 0x88 (cx231xx #0-0)
	[16048.424551] cx25840 10-0044: loaded v4l-cx231xx-avcore-01.fw firmware (16382 bytes)
	[16048.463224] cx231xx 3-1.2:1.1: v4l2 driver version 0.0.3
	[16048.567878] cx231xx 3-1.2:1.1: Registered video device video2 [v4l2]
	[16048.568001] cx231xx 3-1.2:1.1: Registered VBI device vbi0
	[16048.568419] cx231xx 3-1.2:1.1: audio EndPoint Addr 0x83, Alternate settings: 3
	[16048.568425] cx231xx 3-1.2:1.1: video EndPoint Addr 0x84, Alternate settings: 5
	[16048.568431] cx231xx 3-1.2:1.1: VBI EndPoint Addr 0x85, Alternate settings: 2
	[16048.568436] cx231xx 3-1.2:1.1: sliced CC EndPoint Addr 0x86, Alternate settings: 2
	[16048.568448] usb 3-1.2: couldn't get decoder output pad for V4L I/O
	[16048.568453] cx231xx 3-1.2:1.1: V4L2 device vbi0 deregistered
	[16048.568579] cx231xx 3-1.2:1.1: V4L2 device video2 deregistered
	[16048.569001] cx231xx: probe of 3-1.2:1.1 failed with error -22

Likely a regession since Commit 9d6d20e652c0
("media: v4l2-mc: switch it to use the new approach to setup pipelines")
(v4.19-rc1-100-g9d6d20e652c0), which introduced the use of
PAD_SIGNAL_DV within v4l2_mc_create_media_graph().

This also modifies cx25840 to remove the VBI pad, matching the action
taken in Commit 092a37875a22 ("media: v4l2: remove VBI output pad").

Fixes: 9d6d20e652c0 ("media: v4l2-mc: switch it to use the new approach to setup pipelines")
Cc: stable@vger.kernel.org
Signed-off-by: Cody P Schafer <dev@codyps.com>
---
 drivers/media/i2c/cx25840/cx25840-core.c | 3 ++-
 drivers/media/i2c/cx25840/cx25840-core.h | 1 -
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/i2c/cx25840/cx25840-core.c b/drivers/media/i2c/cx25840/cx25840-core.c
index b168bf3635b6..8b0b8b5aa531 100644
--- a/drivers/media/i2c/cx25840/cx25840-core.c
+++ b/drivers/media/i2c/cx25840/cx25840-core.c
@@ -5216,8 +5216,9 @@ static int cx25840_probe(struct i2c_client *client,
 	 * those extra inputs. So, let's add it only when needed.
 	 */
 	state->pads[CX25840_PAD_INPUT].flags = MEDIA_PAD_FL_SINK;
+	state->pads[CX25840_PAD_INPUT].sig_type = PAD_SIGNAL_ANALOG;
 	state->pads[CX25840_PAD_VID_OUT].flags = MEDIA_PAD_FL_SOURCE;
-	state->pads[CX25840_PAD_VBI_OUT].flags = MEDIA_PAD_FL_SOURCE;
+	state->pads[CX25840_PAD_VID_OUT].sig_type = PAD_SIGNAL_DV;
 	sd->entity.function = MEDIA_ENT_F_ATV_DECODER;
 
 	ret = media_entity_pads_init(&sd->entity, ARRAY_SIZE(state->pads),
diff --git a/drivers/media/i2c/cx25840/cx25840-core.h b/drivers/media/i2c/cx25840/cx25840-core.h
index c323b1af1f83..9efefa15d090 100644
--- a/drivers/media/i2c/cx25840/cx25840-core.h
+++ b/drivers/media/i2c/cx25840/cx25840-core.h
@@ -40,7 +40,6 @@ enum cx25840_model {
 enum cx25840_media_pads {
 	CX25840_PAD_INPUT,
 	CX25840_PAD_VID_OUT,
-	CX25840_PAD_VBI_OUT,
 
 	CX25840_NUM_PADS
 };
-- 
2.20.1

