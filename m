Return-Path: <SRS0=gp/0=PH=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9E0FC43387
	for <linux-media@archiver.kernel.org>; Sun, 30 Dec 2018 13:20:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9DFEA20656
	for <linux-media@archiver.kernel.org>; Sun, 30 Dec 2018 13:20:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XMJwr9ow"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725953AbeL3NUc (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sun, 30 Dec 2018 08:20:32 -0500
Received: from mail-pf1-f193.google.com ([209.85.210.193]:34188 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725904AbeL3NUc (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 30 Dec 2018 08:20:32 -0500
Received: by mail-pf1-f193.google.com with SMTP id h3so12330086pfg.1
        for <linux-media@vger.kernel.org>; Sun, 30 Dec 2018 05:20:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=XNETrALG7h7TgyQvSvkemRocUX2Vp8RDeHGHqd+9eyE=;
        b=XMJwr9owg53g9DJfGAf1eqOnWscrABUSPQ/A76gjvsPA/RJ2XzpaptOBz+qzfWBxxW
         Y7/B3ZYkH4LRBWsbZe/3Rb82hTOvbcHFj4QcNUcBxhl0Twc/wyh3jGquCoxIuRo9h9gu
         aM6FJBPwxmUDUyGHXyBG6wqaCieZsv449m3afnvrOSRyd/fp25VlrXOyec5gXj9wTJl9
         AxWIcHU0v/YMxvfFndWCiUDShTLZwDruJY6GWoaHt/jwy3dywi012yov39XneenrwjP6
         PqoZsPb5zCre9trknmieNa44ReFgfeuIXsvarHesf5RIdSb3dtg2QmTyquh+TBgP4TVM
         crdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=XNETrALG7h7TgyQvSvkemRocUX2Vp8RDeHGHqd+9eyE=;
        b=lk/SSUxh0ASfQy6S1We+nCBQJzesWubwGzIL35/zkKyuBr/q9ojd45JoF6Vk74rOkB
         QXnxKggYSO9q66NHu959LMNhnwG/FEBnYyT7OnVsWto4IltSRFXg+oYMC7OT5Ro+izIR
         UpKuai0fEG7RJtkh+A6pye1CPcuLph+HDXNVmRorUppjZzdE2druCDZ6V2RL0xwQ85MZ
         OQZ/fmnxOwGr8lKeSW4RLshmv/pP54UhO7kkME5DQnEm8Nplvs94VEks4lmjGBRQLu4g
         zLNZ1Rz7j7bzBTQTByOhFe+uyYoMd7woc8IuRnO3Zug1rPzo/BdZVzoyzuihu+qKZ/yn
         kJ+Q==
X-Gm-Message-State: AJcUukdu9VZDUyf0t9bTCnU3Lgw1j7E77F5Pgzdb0G/zJrfs3bgrPvYD
        zjxBpgOGlvi/TlCQpf2AEiLzcRogK4k=
X-Google-Smtp-Source: ALg8bN5VMiiiq4hKtUqYpY0LMxqugTLXfenfGvFVUyqwKXHEXwl6Rp8+d5pOI8ZJTRwWNuH687Jx7Q==
X-Received: by 2002:a63:8d44:: with SMTP id z65mr4521720pgd.57.1546176031402;
        Sun, 30 Dec 2018 05:20:31 -0800 (PST)
Received: from localhost.localdomain ([240f:34:212d:1:80f:9263:abd:68d3])
        by smtp.gmail.com with ESMTPSA id g2sm60622568pfi.95.2018.12.30.05.20.28
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Sun, 30 Dec 2018 05:20:30 -0800 (PST)
From:   Akinobu Mita <akinobu.mita@gmail.com>
To:     linux-media@vger.kernel.org
Cc:     Akinobu Mita <akinobu.mita@gmail.com>,
        Eric Anholt <eric@anholt.net>,
        Stefan Wahren <stefan.wahren@i2se.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Hans Verkuil <hansverk@cisco.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH] media: staging: bcm2835-camera: use V4L2_FRACT_COMPARE
Date:   Sun, 30 Dec 2018 22:20:16 +0900
Message-Id: <1546176016-16245-1-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 2.7.4
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Now the equivalent of FRACT_CMP() is added in v4l2 common internal API
header.

Cc: Eric Anholt <eric@anholt.net>
Cc: Stefan Wahren <stefan.wahren@i2se.com>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Hans Verkuil <hansverk@cisco.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
---
 drivers/staging/vc04_services/bcm2835-camera/bcm2835-camera.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/vc04_services/bcm2835-camera/bcm2835-camera.c b/drivers/staging/vc04_services/bcm2835-camera/bcm2835-camera.c
index 611a6ee..7c6cf41 100644
--- a/drivers/staging/vc04_services/bcm2835-camera/bcm2835-camera.c
+++ b/drivers/staging/vc04_services/bcm2835-camera/bcm2835-camera.c
@@ -1370,10 +1370,6 @@ static int vidioc_g_parm(struct file *file, void *priv,
 	return 0;
 }
 
-#define FRACT_CMP(a, OP, b)	\
-	((u64)(a).numerator * (b).denominator  OP  \
-	 (u64)(b).numerator * (a).denominator)
-
 static int vidioc_s_parm(struct file *file, void *priv,
 			 struct v4l2_streamparm *parm)
 {
@@ -1387,8 +1383,8 @@ static int vidioc_s_parm(struct file *file, void *priv,
 
 	/* tpf: {*, 0} resets timing; clip to [min, max]*/
 	tpf = tpf.denominator ? tpf : tpf_default;
-	tpf = FRACT_CMP(tpf, <, tpf_min) ? tpf_min : tpf;
-	tpf = FRACT_CMP(tpf, >, tpf_max) ? tpf_max : tpf;
+	tpf = V4L2_FRACT_COMPARE(tpf, <, tpf_min) ? tpf_min : tpf;
+	tpf = V4L2_FRACT_COMPARE(tpf, >, tpf_max) ? tpf_max : tpf;
 
 	dev->capture.timeperframe = tpf;
 	parm->parm.capture.timeperframe = tpf;
-- 
2.7.4

