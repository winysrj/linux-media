Return-Path: <SRS0=LTSq=OR=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46513C04EB8
	for <linux-media@archiver.kernel.org>; Sat,  8 Dec 2018 04:45:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EE271208E7
	for <linux-media@archiver.kernel.org>; Sat,  8 Dec 2018 04:45:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HaRw57sS"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org EE271208E7
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726098AbeLHEpA (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 7 Dec 2018 23:45:00 -0500
Received: from mail-pf1-f172.google.com ([209.85.210.172]:42238 "EHLO
        mail-pf1-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726081AbeLHEo7 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 7 Dec 2018 23:44:59 -0500
Received: by mail-pf1-f172.google.com with SMTP id 64so2869425pfr.9
        for <linux-media@vger.kernel.org>; Fri, 07 Dec 2018 20:44:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=BJ/pFAZO75a/qZknITFnRH8NZPcCO0VzAbIJ+Kl6aKw=;
        b=HaRw57sSyFwcna+hi6ovuJ1nii5qjivDEsfChFC4rNzZ1rrgGJ027+DXGd1Vcq6s9O
         WnytCaAnVl2K8nqioGJbCjFUd42SNwWSz8fwJO7w29ns46ltywzcljkv56iH/v9/WU+J
         InRKmcemfgIq7SLN9Tngda+gruQgQAtwk9/kUjRKsRQeoiTPRIm9kPm0Ctjq9HwBhsbf
         N6yg7+PHdCKFrfAEn+s0ouGfKmhWVJHAPUfWUtn4+9KLQQF+Ro3Hvd7UXvTu79M8+tHz
         Ze332F66czyZoblFxPPHx6vZd2sBww2+g7iuchm8zhsC7JW3ZAioIWgHEu3T/k1BgPoS
         X6dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=BJ/pFAZO75a/qZknITFnRH8NZPcCO0VzAbIJ+Kl6aKw=;
        b=BbQP0/MrI5xrR7grxdqv7xypljAyzTAVhxyVGd7X/K4Q2JHgUsxo0Z2DVgrs5XTxhe
         TG2zR1rKI+n1+84z6ej5CufAZoyfjT+yMFqMpSZ9BqHsFqdg1z1E3l6zSdJsJB18Xe1S
         4RZa4h7/XCWO4wu6sDImLoaKkjGXW3kv3ibX5fh0o3tpcNavRrTdFIH8Z3bcqUIvHu9e
         N83Lf95Ag9RaiaU7Ad2c/yzsKX31IRhN6ntOMEQVE0DubfdH+5UfN98t6lWSSSkyuZ5s
         jSSXw7D464yrItuXxqrJiVWkoT5p5HFGf6H9IeXYlY0zTb2kwJOwLBbEISC1BdZjNpBg
         9m0w==
X-Gm-Message-State: AA+aEWa9QpfzhXFz1Z3GxY1nlUyAxJ81D8mq18yWsa4AwLaOBzDoO1Dd
        DQQO883/t+9P8DU057H0hjAppDwt
X-Google-Smtp-Source: AFSGD/XDSvJ90jqRWswb99b9iQXgyjBbLyO9ppb8di+dHdJXg7gRTwr3PIj0NF0Tqn8twlVN/uAUZw==
X-Received: by 2002:a62:5dd1:: with SMTP id n78mr4731049pfj.58.1544244298778;
        Fri, 07 Dec 2018 20:44:58 -0800 (PST)
Received: from localhost.localdomain ([240f:34:212d:1:9ca3:939e:b94a:438e])
        by smtp.gmail.com with ESMTPSA id h74sm8248193pfd.35.2018.12.07.20.44.56
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Fri, 07 Dec 2018 20:44:57 -0800 (PST)
From:   Akinobu Mita <akinobu.mita@gmail.com>
To:     linux-media@vger.kernel.org
Cc:     Akinobu Mita <akinobu.mita@gmail.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: [PATCH 0/3] media: ov2640: fix two problems
Date:   Sat,  8 Dec 2018 13:44:43 +0900
Message-Id: <1544244286-11597-1-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 2.7.4
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

This patch series contains two bugfixes and a preparatory change for
ov2640 driver.

Akinobu Mita (3):
  media: ov2640: set default window and format code at probe time
  media: ov2640: make VIDIOC_SUBDEV_G_FMT ioctl work with
    V4L2_SUBDEV_FORMAT_TRY
  media: ov2640: set all mbus format field when G_FMT and S_FMT ioctls

 drivers/media/i2c/ov2640.c | 41 +++++++++++++++++++++++++++++++++++------
 1 file changed, 35 insertions(+), 6 deletions(-)

Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
-- 
2.7.4

