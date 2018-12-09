Return-Path: <SRS0=qcaw=OS=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1801BC07E85
	for <linux-media@archiver.kernel.org>; Sun,  9 Dec 2018 05:20:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C9A0C20837
	for <linux-media@archiver.kernel.org>; Sun,  9 Dec 2018 05:20:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="oCxZL5Up"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C9A0C20837
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726086AbeLIFUq (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sun, 9 Dec 2018 00:20:46 -0500
Received: from mail-pg1-f196.google.com ([209.85.215.196]:45850 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726062AbeLIFUq (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sun, 9 Dec 2018 00:20:46 -0500
Received: by mail-pg1-f196.google.com with SMTP id y4so3457734pgc.12
        for <linux-media@vger.kernel.org>; Sat, 08 Dec 2018 21:20:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=6Vyh8vWHk9VF8vDcrdwy6gaZI56R1Hex8Lv905X7CCA=;
        b=oCxZL5UpW24uycG9Ju03Ba6HhSK29sj2iAyLxdwwnKAviH9jxkRBE23YEZ/TcmepMP
         tSM7M0dkqDeIPv5bAdcFOo7V0QHSFaEAWeOiOnIV6qL71iSsMV163EEEdcvZStG4SgYp
         avWDoe2f+NJLolyHydqGXhlVSD8mV90BVNFYeLchLkeSZ1jTqyoocC3hg0jQYdrSvK87
         WGwPHpJQt8kwp4AX/ZG7bZDYh7S5kZa5Tsay2kNAAVTCCBbtlowPnUPLZ8FA2e+gGWFz
         TEiZeM7wm9mks6SJKmMostrKvppY82u9a89KbYHRutgtX0FSG3pbqgRpJK9co+z0uYlN
         IVJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=6Vyh8vWHk9VF8vDcrdwy6gaZI56R1Hex8Lv905X7CCA=;
        b=ncmNU5xBSTelOLZv3aeTslJYV2P/bHg7Tvo2HsigWYzrXZnYBhL+ArzDNTPGaSlitk
         vU/eUfo2L4/K6WqZlRRyFiLsQxYg2O6iN3WUgtVd/heDmW5wKA4up2ObVtW/wezK0Myy
         dk1QD03BZnhawTf7Q1NxicEVLf+fnsvtRShqeP3dRggKGv0Gbdqhws7ODOm5yEvfvAIj
         NqJKouIR7pxW1iLpAZi23XMsFmoLEhv/0SGU8lp5hBB5aobIzJqcuvRXDBHT8aEOCZtx
         tNB/MrAhTqO1HAV4thtWjvH52d32KLc/pX0BmAovOlkONCpWgkJ0yw2oygY1Wrq74PNF
         Y96Q==
X-Gm-Message-State: AA+aEWade6aDVuFhlqrxSLEM2HQUAZu1LKW4kPjtH6i17lgm4A8LW5fu
        l5LIoMjGELhnUbysig+w/Qw4kbOeUQI=
X-Google-Smtp-Source: AFSGD/Vhz78mTpj3fDZGZ+xi8hv5tzj9paghK+DIVEk5ByIu7+UGKWCTPHNquUODGIKFcGlKd4rZkg==
X-Received: by 2002:a63:374e:: with SMTP id g14mr7091495pgn.59.1544332845344;
        Sat, 08 Dec 2018 21:20:45 -0800 (PST)
Received: from localhost.localdomain ([240f:34:212d:1:a17f:ba11:defa:e2d1])
        by smtp.gmail.com with ESMTPSA id v14sm14973270pgf.3.2018.12.08.21.20.42
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Sat, 08 Dec 2018 21:20:43 -0800 (PST)
From:   Akinobu Mita <akinobu.mita@gmail.com>
To:     linux-media@vger.kernel.org
Cc:     Akinobu Mita <akinobu.mita@gmail.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: [PATCH v2 0/3] media: ov2640: fix two problems
Date:   Sun,  9 Dec 2018 14:20:30 +0900
Message-Id: <1544332833-10369-1-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 2.7.4
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

This patch series contains two bugfixes and a preparatory change for
ov2640 driver.

* v2
- fix build error when CONFIG_VIDEO_V4L2_SUBDEV_API is not defined,
  reported by kbuild test robot.

Akinobu Mita (3):
  media: ov2640: set default window and format code at probe time
  media: ov2640: make VIDIOC_SUBDEV_G_FMT ioctl work with
    V4L2_SUBDEV_FORMAT_TRY
  media: ov2640: set all mbus format field when G_FMT and S_FMT ioctls

 drivers/media/i2c/ov2640.c | 45 +++++++++++++++++++++++++++++++++++++++------
 1 file changed, 39 insertions(+), 6 deletions(-)

Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
-- 
2.7.4

