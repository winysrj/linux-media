Return-Path: <SRS0=AYlV=OX=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB59AC43387
	for <linux-media@archiver.kernel.org>; Fri, 14 Dec 2018 16:40:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4F7D3206C2
	for <linux-media@archiver.kernel.org>; Fri, 14 Dec 2018 16:40:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="s8TMglQP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729963AbeLNQkk (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 14 Dec 2018 11:40:40 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:37260 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729672AbeLNQkk (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 14 Dec 2018 11:40:40 -0500
Received: by mail-wr1-f65.google.com with SMTP id s12so5610783wrt.4
        for <linux-media@vger.kernel.org>; Fri, 14 Dec 2018 08:40:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=iyhUgks24sZvLp6IVPwibFTcjECEa/g1mPYTW1iaoaY=;
        b=s8TMglQPDMBPqSfwOKbG5NljgPNZqAeDkYHhTgDRDwmPeW2Eqa3jXPE5f14tqJ9ET2
         U6eb86+/9QHhFluvLLAS6KAtvIC3QCL7e9M3M6nExxkmlWCimKjc+WoqAnjzLszDv0Cb
         ertWrx5qDQa5j+RTjT3lVo6Ug2IuYDQ/EU5/jly+dERH0KdBs43LptEFr5ShDJiJPxEa
         ziA23TP6UaThWI+J3wI422c2GPCuZR0JXtPd6XEkzu2fiK+VN1cWCbFuaMVtILdjpNnx
         dQd68mqihRXJI6UHe5OOspuOd+20d3txksM5Yfj+4t7FUYBPcZ1VpZ509rs7n9aAtl2P
         kGeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=iyhUgks24sZvLp6IVPwibFTcjECEa/g1mPYTW1iaoaY=;
        b=jniZIC9Cwm5fengb15emA/P/DTMUgQMI0aNcyQOo1JWyKjtfYiYSGqte8/i4QI2y5p
         xhtN26S/sAAHrIlMI+5dz7EebEPOoAavPEukFIklWtA4DzOsogo2kYy7sipQg0yWcYkz
         G9AiktWQ44SS06D6Co8ZFxjit7ShCoOSNIqUadfUoR52Dwi5amcBZI8JnMvHaGUGtn6F
         yQKJhIq5DzjxLB5zvpT9OcawlQCxKqrmXAWNNbSD9d+05wqWUZ9xnWwQEbiPbX7okz8S
         d0ntYCsJ4TWs9FSnAR7e0qAuh5WDLF0aTaDs6QiLhzRCSmfgRhaeKdOBwMYM7vK2zduX
         A7lw==
X-Gm-Message-State: AA+aEWYci4Jznq0wjr34L9O1A/+TwstZlyBKiW8Dxs8YnJpmpebYKoG4
        N0xZESZzfZuYXtI6mXDHENISOkBF
X-Google-Smtp-Source: AFSGD/Xf7RyP39nKERO30/kKc6glE/IYDFXdRlVeDoaMP7MBwH7qcp0dmGPGftT42IgLKbXsWym8Rw==
X-Received: by 2002:adf:dbcb:: with SMTP id e11mr3359698wrj.58.1544805638422;
        Fri, 14 Dec 2018 08:40:38 -0800 (PST)
Received: from ped.lan (ip5f5abcae.dynamic.kabel-deutschland.de. [95.90.188.174])
        by smtp.googlemail.com with ESMTPSA id c13sm7680392wrb.38.2018.12.14.08.40.37
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 14 Dec 2018 08:40:37 -0800 (PST)
From:   Philipp Zabel <philipp.zabel@gmail.com>
To:     linux-media@vger.kernel.org
Cc:     Hans Verkuil <hverkuil@xs4all.nl>,
        Philipp Zabel <philipp.zabel@gmail.com>
Subject: [PATCH 0/8] gspca_ov534 raw bayer (SGRBG8) support
Date:   Fri, 14 Dec 2018 17:40:23 +0100
Message-Id: <20181214164031.16757-1-philipp.zabel@gmail.com>
X-Mailer: git-send-email 2.20.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi,

this series adds raw bayer (V4L2_PIX_FMT_SGRBG8) support to the gspca
ov534-ov772x driver used for the PlayStation Eye camera for VGA and
QVGA modes. Selecting the SGRBG8 format bypasses image processing
(brightness, contrast, saturation, and hue controls).

regards
Philipp

Philipp Zabel (8):
  media: gspca: ov534: replace msleep(10) with usleep_range
  media: gspca: support multiple pixel formats in ENUM_FRAMEINTERVALS
  media: gspca: support multiple pixel formats in TRY_FMT
  media: gspca: ov543-ov772x: move video format specific registers into
    bridge_start
  media: gspca: ov534-ov772x: add SGBRG8 bayer mode support
  media: gspca: ov534-ov722x: remove mode specific video data registers
    from bridge_init
  media: gspca: ov534-ov722x: remove camera clock setup from bridge_init
  media: gspca: ov534-ov772x: remove unnecessary COM3 initialization

 drivers/media/usb/gspca/gspca.c |  18 ++--
 drivers/media/usb/gspca/ov534.c | 153 +++++++++++++++++++++++---------
 2 files changed, 123 insertions(+), 48 deletions(-)

-- 
2.20.0

