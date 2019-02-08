Return-Path: <SRS0=EeSY=QP=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5AD3CC169C4
	for <linux-media@archiver.kernel.org>; Fri,  8 Feb 2019 19:19:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2627D2177B
	for <linux-media@archiver.kernel.org>; Fri,  8 Feb 2019 19:19:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Kob84pmC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727354AbfBHTTf (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 8 Feb 2019 14:19:35 -0500
Received: from mail-pl1-f194.google.com ([209.85.214.194]:41295 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727125AbfBHTTf (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 8 Feb 2019 14:19:35 -0500
Received: by mail-pl1-f194.google.com with SMTP id k15so2141399pls.8
        for <linux-media@vger.kernel.org>; Fri, 08 Feb 2019 11:19:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=iS1nGQ2m/eKoQogiGOlojshQ2USUpLeMbFSeHBwVztg=;
        b=Kob84pmCFFyOgyU0t+G46WklN8H5+v4yCXhxqBNM4/r9R79oA3lpJrT5sGgr5kp2JI
         2wPRQU0Y/iOGH31SU64rhe0AuXVMGewtmtuXSW1E/gZ9RD9j0tyHddNYn+eOqAqj/Jhx
         x+zhX7/zeIIra+wmFZU/B4jCzubmYBYyekhaI928LPg/HBX71YD54oG5uP6lSiwIvfVI
         DnyH7AV+uP24qrqiVcZh07Jn9+u1kTuiopQwfjD2hH/oU8fqgc+yhZVk6VNcXdyl6yPN
         3pKwJe/5fTgdSwAe2pDPdlRCOYEtbGagAEvKHPp5S2a48rgnMUG451rwo+MIYWTey5sA
         nEcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=iS1nGQ2m/eKoQogiGOlojshQ2USUpLeMbFSeHBwVztg=;
        b=C5MqR8hseXSIxragWrt8BjIKCnFqEheSnKrEqAEGNIoT2f912DGEWC04TG/HuEkFpt
         3KIDw6D3jVROzYF6FpD4bgFWnpUepck5KAoheAXAFS9FIXIdXWShtc5Umtcu3rkWrrFT
         0O5ZE8mB+9Cf1YOTpLzHU1ZQBayhFAZI5UcoV/32Q7Kmke3TtA0W9ERR/RGSZpA4jhnX
         nNSJec+IoZiNKs5byJzoTmU6D6eW0BZNzJetT2NXYn6q5bhMtlG2qNeJzY9HxH+d0TwS
         olNJs2BxRQWcNFNrvDg2QpSEJwZBz4o3myUTACqTnN7bLLmBjhLqtGrlw/TCZkJ3KUMV
         Lqjg==
X-Gm-Message-State: AHQUAuaq5nwWstH3g8QsdkP/3jG892DpbnjkncQMgNBAyAeXRNamUBkX
        T0w0K24GRaq9ATmro1dA/1tbuB7b
X-Google-Smtp-Source: AHgI3IYknbLgzvYBvWXItAwj6FAS3Z1rW1exvbzyKtejxO0Zm/5An/pjHccYePW7QgFj1Bt5sWsCXg==
X-Received: by 2002:a17:902:9a81:: with SMTP id w1mr23467544plp.19.1549653574460;
        Fri, 08 Feb 2019 11:19:34 -0800 (PST)
Received: from majic.sklembedded.com (c-73-202-231-77.hsd1.ca.comcast.net. [73.202.231.77])
        by smtp.googlemail.com with ESMTPSA id o5sm4761817pgm.68.2019.02.08.11.19.33
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 08 Feb 2019 11:19:33 -0800 (PST)
From:   Steve Longerbeam <slongerbeam@gmail.com>
X-Google-Original-From: Steve Longerbeam <steve_longerbeam@mentor.com>
To:     linux-media@vger.kernel.org
Cc:     Tim Harvey <tharvey@gateworks.com>,
        Steve Longerbeam <steve_longerbeam@mentor.com>
Subject: [PATCH v2 0/4] media: imx: Add support for BT.709 encoding
Date:   Fri,  8 Feb 2019 11:19:24 -0800
Message-Id: <20190208191928.13273-1-steve_longerbeam@mentor.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

This patchset adds support for the BT.709 encoding and inverse encoding
matrices to the ipu_ic task init functions. The imx-media driver can
now support both BT.601 and BT.709 encoding.

History:
v2:
- rename ic_csc_rgb2rgb matrix to ic_csc_identity.
- only return "Unsupported YCbCr encoding" error if inf != outf,
  since if inf == outf, the identity matrix can be used. Reported
  by Tim Harvey.
- move ic_route check above default colorimetry checks, and fill default
  colorimetry for ic_route, otherwise it's not possible to set BT.709
  encoding for ic routes.

Steve Longerbeam (4):
  gpu: ipu-v3: ipu-ic: Rename yuv2rgb encoding matrices
  gpu: ipu-v3: ipu-ic: Simplify selection of encoding matrix
  gpu: ipu-v3: ipu-ic: Add support for BT.709 encoding
  media: imx: Allow BT.709 encoding for IC routes

 drivers/gpu/ipu-v3/ipu-ic.c                 | 94 +++++++++++++++++----
 drivers/gpu/ipu-v3/ipu-image-convert.c      |  1 +
 drivers/staging/media/imx/imx-ic-prpencvf.c |  4 +-
 drivers/staging/media/imx/imx-media-utils.c | 20 +++--
 include/video/imx-ipu-v3.h                  |  5 +-
 5 files changed, 97 insertions(+), 27 deletions(-)

-- 
2.17.1

