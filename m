Return-Path: <SRS0=KIs1=PS=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 420EDC43387
	for <linux-media@archiver.kernel.org>; Thu, 10 Jan 2019 15:28:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0E06420685
	for <linux-media@archiver.kernel.org>; Thu, 10 Jan 2019 15:28:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="F3Ut7zUE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728521AbfAJP2s (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 10 Jan 2019 10:28:48 -0500
Received: from mail-pl1-f195.google.com ([209.85.214.195]:34171 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727793AbfAJP2s (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 10 Jan 2019 10:28:48 -0500
Received: by mail-pl1-f195.google.com with SMTP id w4so5334893plz.1
        for <linux-media@vger.kernel.org>; Thu, 10 Jan 2019 07:28:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=yV0VwaMpOhDGV8jNSl4zo0yDjjhzaD5Gc3yEhCwq2ss=;
        b=F3Ut7zUEbUrTJNriWkviN7s/SVl526Slt7kZeSeO+Uur7oD6DdIwTfvNHkIjdisXg8
         cpQcJUuRi2k/prFBWpAKT5pCZlyBf8ndkoHiCvIxnofqhgdPNJ6ONpbJr0qiU1+sPmHj
         hRmKZ6gUPhKNKprirEAa06FDLZERsYgUxY3Nn3g/ATnSnPAbJMG+fftmI/8E09SvuF9c
         Zg2eJPQgELrsem+kQ55ryV60Sl59/MpzOILdL47XZ97vaBzD1vLpzooOBwRVPDgsgHXm
         0hR5EPBPTIaFqNVEeZRj+dxBIfoaqkHVQnWJHl+AllvTtZYIBnbV0YKgiHW0slN4qhEU
         EmBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=yV0VwaMpOhDGV8jNSl4zo0yDjjhzaD5Gc3yEhCwq2ss=;
        b=mXy1kPRS2BDxRniaP7xEzBixAsRM7Q0Fbcjd4oLrCuLIbvvuTYNwkNs1P3lZZbgL2t
         S+CUHvPMAS47GjAmPxkBwQtNNPHbGRq2hLpYlP4dMPtMGrzQ3zNDXJhtl9nFHJT8J7Yg
         DMokheD5J8DMagvgp49xvw+nP/tyVKGxd7SuxyEoBFcADOPbBnO0byhmc05V+bhP4Cf2
         k6aetQ+MO7QMUfdSUNxPo3bpsmiKZZW8vhgGsa9YH4p2xAn1Bsddcao+fIRScKQkhBl6
         d3qTKgEuckvR3fhjBrFJER/YnfT7vfEhsT1YYiPLp/bL87+zgpugEQPIckmj/j1jD4tf
         ufDg==
X-Gm-Message-State: AJcUukdHW2yvoAKCNjCwJzNFAVBqbPRrsIxOCT9Cv+r32ycb9hspPWFj
        uSmKvZttCks09W8y1bB5SbrkU/2w
X-Google-Smtp-Source: ALg8bN5aT/yLSJtPft+BKqMQ0p4A/EV4aey3qUgYy9nGWu3AeHA354wi/7BctIDJOzifQtYOrUFekQ==
X-Received: by 2002:a17:902:aa0a:: with SMTP id be10mr10602911plb.266.1547134127373;
        Thu, 10 Jan 2019 07:28:47 -0800 (PST)
Received: from localhost.localdomain ([240f:34:212d:1:25a3:d6ca:ee6b:e202])
        by smtp.gmail.com with ESMTPSA id y1sm105916116pfe.9.2019.01.10.07.28.44
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Thu, 10 Jan 2019 07:28:46 -0800 (PST)
From:   Akinobu Mita <akinobu.mita@gmail.com>
To:     linux-media@vger.kernel.org
Cc:     Akinobu Mita <akinobu.mita@gmail.com>,
        Enrico Scholz <enrico.scholz@sigma-chemnitz.de>,
        Michael Grzeschik <m.grzeschik@pengutronix.de>,
        Marco Felsch <m.felsch@pengutronix.de>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: [PATCH v2 0/3] media: bugfixes for mt9m111 driver
Date:   Fri, 11 Jan 2019 00:28:26 +0900
Message-Id: <1547134109-21449-1-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 2.7.4
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

This patch series contains four bugfixes for mt9m111 driver.

* v2
- Drop patch 1/4 in v1 ("fix setting pixclk polarit") since it was wrong.
- Use format->pad for the argument of v4l2_subdev_get_try_format().

Akinobu Mita (3):
  media: mt9m111: make VIDIOC_SUBDEV_G_FMT ioctl work with
    V4L2_SUBDEV_FORMAT_TRY
  media: mt9m111: set all mbus format field when G_FMT and S_FMT ioctls
  media: mt9m111: set initial frame size other than 0x0

 drivers/media/i2c/mt9m111.c | 40 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 40 insertions(+)

Cc: Enrico Scholz <enrico.scholz@sigma-chemnitz.de>
Cc: Michael Grzeschik <m.grzeschik@pengutronix.de>
Cc: Marco Felsch <m.felsch@pengutronix.de>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
-- 
2.7.4

