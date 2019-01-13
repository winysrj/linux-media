Return-Path: <SRS0=qapk=PV=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 357AEC43387
	for <linux-media@archiver.kernel.org>; Sun, 13 Jan 2019 21:14:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EE9FC20842
	for <linux-media@archiver.kernel.org>; Sun, 13 Jan 2019 21:14:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="s5rgelWO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726564AbfAMVOB (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sun, 13 Jan 2019 16:14:01 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:54511 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726481AbfAMVOB (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 13 Jan 2019 16:14:01 -0500
Received: by mail-wm1-f68.google.com with SMTP id a62so7031466wmh.4
        for <linux-media@vger.kernel.org>; Sun, 13 Jan 2019 13:13:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=V7TaU2bmoQLh4sdZQPatWH9OmhaIog7r6ZxN7CMhSVk=;
        b=s5rgelWORpp3ubQ4Ev4dG/RGFcfdpRvGt0eth120cuHazLeVJXSWasmYkdNImGd7vf
         RiBsryT96CNQ3iFdXYQgZKxYsPg8qf47b2QpDsDOZqcIz4T5CKeunjNMYbh7dwoYvu8s
         l26b519+CQ53MlgOcQSstiMXyy4XXZx3qngUrGJuq+xwZopvNHaSIEnt9WgHk8lgFmC/
         YccBHfEaYXf1eSUKtkFqKF1nVALnQDdomI3PBGT7nxqaHlYgS8nj6WENkvyaitv6Hrgz
         u1ie0JDvGpaGaj0Qbfkl5y7vXQt2K4GduaWNifz8dfWoEIQBY/3jR/egbZDYjcANRlO5
         ke6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=V7TaU2bmoQLh4sdZQPatWH9OmhaIog7r6ZxN7CMhSVk=;
        b=SCzb+lLwTBUSFfCzJndQcB6q6EN1YhKG4pX1ewy5h5joDq26zUsJjQbaWFBm3Kwb3W
         3PJo44JpFqeLaLsbQ1NdleK+wHcSdFa8rtWma0lsgQivvbjzpbIEJ8+29USsQ4FDsrkQ
         g170P5CUqHkty/6PjbUGp/huB2+LaFCiZu3tRqiydgIy/XhauU2uN+979qwAve6TFLxf
         LYrQYvsJohcr8eU0dcTN/R+JLFcekEGljEsJ8VN4Q1l0s9htqdmn5jLXOcNnHkHm/ooe
         8fTxo2ySuQJkv9gbPhGI6K0yUrtfDHUAPWUQ3YxoF/8TCQwqzUqLCfh/gueRC1HUNkVU
         lafQ==
X-Gm-Message-State: AJcUuke7wBHyvdU1eby6ctewMnUY+wQjqsPFxAAi8+apwUmo2vw4Rtx3
        t7OD+SiE2vNZ+fAn5hAado6/IA2Vmwk=
X-Google-Smtp-Source: ALg8bN4pqF16l2wdH/tp9LNnx4HO9pubSaQw2+hNi4DY3k5/qJuhy6EsqZqhar1t8sVUait9sAWu7A==
X-Received: by 2002:a1c:85d2:: with SMTP id h201mr8937474wmd.151.1547414038146;
        Sun, 13 Jan 2019 13:13:58 -0800 (PST)
Received: from localhost.localdomain ([194.99.106.150])
        by smtp.gmail.com with ESMTPSA id n20sm17995132wmi.11.2019.01.13.13.13.56
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Sun, 13 Jan 2019 13:13:57 -0800 (PST)
From:   James Hutchinson <jahutchinson99@googlemail.com>
To:     linux-media@vger.kernel.org
Cc:     James Hutchinson <jahutchinson99@googlemail.com>
Subject: [PATCH] media: m88ds3103: serialize reset messages in m88ds3103_set_frontend
Date:   Sun, 13 Jan 2019 21:13:47 +0000
Message-Id: <1547414027-31928-1-git-send-email-jahutchinson99@googlemail.com>
X-Mailer: git-send-email 2.7.4
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Ref: https://bugzilla.kernel.org/show_bug.cgi?id=199323

Users are experiencing problems with the DVBSky S960/S960C USB devices
since the following commit:

9d659ae: ("locking/mutex: Add lock handoff to avoid starvation")

The device malfunctions after running for an indeterminable period of
time, and the problem can only be cleared by rebooting the machine.

It is possible to encourage the problem to surface by blocking the
signal to the LNB.

Further debugging revealed the cause of the problem.

In the following capture:
- thread #1325 is running m88ds3103_set_frontend
- thread #42 is running ts2020_stat_work

a> [1325] usb 1-1: dvb_usb_v2_generic_io: >>> 08 68 02 07 80
   [1325] usb 1-1: dvb_usb_v2_generic_io: <<< 08
   [42] usb 1-1: dvb_usb_v2_generic_io: >>> 09 01 01 68 3f
   [42] usb 1-1: dvb_usb_v2_generic_io: <<< 08 ff
   [42] usb 1-1: dvb_usb_v2_generic_io: >>> 08 68 02 03 11
   [42] usb 1-1: dvb_usb_v2_generic_io: <<< 07
   [42] usb 1-1: dvb_usb_v2_generic_io: >>> 09 01 01 60 3d
   [42] usb 1-1: dvb_usb_v2_generic_io: <<< 07 ff
b> [1325] usb 1-1: dvb_usb_v2_generic_io: >>> 08 68 02 07 00
   [1325] usb 1-1: dvb_usb_v2_generic_io: <<< 07
   [42] usb 1-1: dvb_usb_v2_generic_io: >>> 08 68 02 03 11
   [42] usb 1-1: dvb_usb_v2_generic_io: <<< 07
   [42] usb 1-1: dvb_usb_v2_generic_io: >>> 09 01 01 60 21
   [42] usb 1-1: dvb_usb_v2_generic_io: <<< 07 ff
   [42] usb 1-1: dvb_usb_v2_generic_io: >>> 08 68 02 03 11
   [42] usb 1-1: dvb_usb_v2_generic_io: <<< 07
   [42] usb 1-1: dvb_usb_v2_generic_io: >>> 09 01 01 60 66
   [42] usb 1-1: dvb_usb_v2_generic_io: <<< 07 ff
   [1325] usb 1-1: dvb_usb_v2_generic_io: >>> 08 68 02 03 11
   [1325] usb 1-1: dvb_usb_v2_generic_io: <<< 07
   [1325] usb 1-1: dvb_usb_v2_generic_io: >>> 08 60 02 10 0b
   [1325] usb 1-1: dvb_usb_v2_generic_io: <<< 07

Two i2c messages are sent to perform a reset in m88ds3103_set_frontend:

  a. 0x07, 0x80
  b. 0x07, 0x00

However, as shown in the capture, the regmap mutex is being handed over
to another thread (ts2020_stat_work) in between these two messages.

From here, the device responds to every i2c message with an 07 message,
and will only return to normal operation following a power cycle.

Use regmap_multi_reg_write to group the two reset messages, ensuring
both are processed before the regmap mutex is unlocked.

Signed-off-by: James Hutchinson <jahutchinson99@googlemail.com>
---
 drivers/media/dvb-frontends/m88ds3103.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/media/dvb-frontends/m88ds3103.c b/drivers/media/dvb-frontends/m88ds3103.c
index 123f2a3..77fe3dc 100644
--- a/drivers/media/dvb-frontends/m88ds3103.c
+++ b/drivers/media/dvb-frontends/m88ds3103.c
@@ -309,6 +309,7 @@ static int m88ds3103_set_frontend(struct dvb_frontend *fe)
 	u16 u16tmp;
 	u32 tuner_frequency_khz, target_mclk;
 	s32 s32tmp;
+	static const struct reg_sequence reset_buf[] = {{0x07, 0x80}, {0x07, 0x00}};
 
 	dev_dbg(&client->dev,
 		"delivery_system=%d modulation=%d frequency=%u symbol_rate=%d inversion=%d pilot=%d rolloff=%d\n",
@@ -321,11 +322,7 @@ static int m88ds3103_set_frontend(struct dvb_frontend *fe)
 	}
 
 	/* reset */
-	ret = regmap_write(dev->regmap, 0x07, 0x80);
-	if (ret)
-		goto err;
-
-	ret = regmap_write(dev->regmap, 0x07, 0x00);
+	ret = regmap_multi_reg_write(dev->regmap, reset_buf, 2);
 	if (ret)
 		goto err;
 
-- 
2.7.4

