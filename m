Return-Path: <SRS0=IHIA=PY=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 036EDC43387
	for <linux-media@archiver.kernel.org>; Wed, 16 Jan 2019 05:23:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BFC9020859
	for <linux-media@archiver.kernel.org>; Wed, 16 Jan 2019 05:23:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aefGEI3w"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726091AbfAPFXa (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 16 Jan 2019 00:23:30 -0500
Received: from mail-io1-f66.google.com ([209.85.166.66]:46702 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725882AbfAPFX3 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 16 Jan 2019 00:23:29 -0500
Received: by mail-io1-f66.google.com with SMTP id v10so3933379ios.13
        for <linux-media@vger.kernel.org>; Tue, 15 Jan 2019 21:23:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=/BSD0M36uKF/j4SOu/uX7OU0kugnbjYTxx4pe7PDAJc=;
        b=aefGEI3wYMkQXSUOQvvSKXqPYCMfiw1+5USmFlTPOJgiWZsIr1PcqvdTQ51RfjVjK6
         8eY0Z+IHqOebPVRUQf3cBUcuDSl/fpUtIoGEx/G2upMvCTu2QXd4HJHPwveL+miYvJgp
         V3aH+8wV6NbPQwkSETDOjmBEqPBYwWl90Ad7Mebl2hWx3lqaVP2hy5+XoMxO9fl8UTGk
         LuirdRoupcLAkyC9vfLw+N4yPXTlHgl20opYKv+AyaCSJFJYeH3eGR2L1IlFbQLZRXt8
         1bLxG4mx4OU/Emi4Tx3usxgoUykMp2T4I95rDiPmgCx0fSOGffmDcZRQ4oX/6QC9W6BH
         7GmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=/BSD0M36uKF/j4SOu/uX7OU0kugnbjYTxx4pe7PDAJc=;
        b=tYzlr2BLdaydvqxcg89qCQPCFzZXSiCMMpJkod37Yufe+XzRXn5EmiXGtxtXkpz9Qd
         w5rzaVuZCvNnrSsdZPuFO2XQu+NfTjTn+K5SYgl+pzsf9r++neSS94t4JPi8Tlpa2A4O
         8JzQz4A+zpVPsj4SyCkc1VXFqynM7SgK53f00GO0WKD+J1axJVoYA/jG5puKi2WuEZxf
         DuotMD4tXc/+BFebbzlfJJqI6w+itQBF1jydSbLiouNYLJFJiDU9UDQVBCdzc6U2jG0r
         6nHCmYfj3jtltpkNqRlR8NUm5Ocvzq7Xy5evjLU4+3bYq1HClJblcZFMor40jyGTspJq
         wgeA==
X-Gm-Message-State: AJcUukdANoNAaPLsogg1ekPGXjGToAvPfj3v9/mRS49lxkVnpSntaAaH
        OakG9RNWSiWHbi0GG2fE5qs=
X-Google-Smtp-Source: ALg8bN6qSTxoqDl1g5QUQP3RZsSluRo7z/vg2Et16633mlFvvqQsrQqVzUOo3Zp8WJ9Le83MsrGnjA==
X-Received: by 2002:a6b:9188:: with SMTP id t130mr3819211iod.261.1547616208623;
        Tue, 15 Jan 2019 21:23:28 -0800 (PST)
Received: from dragon.Home (71-218-4-112.hlrn.qwest.net. [71.218.4.112])
        by smtp.gmail.com with ESMTPSA id t17sm2156347iog.34.2019.01.15.21.23.26
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Tue, 15 Jan 2019 21:23:27 -0800 (PST)
From:   james.hilliard1@gmail.com
To:     mchehab+samsung@kernel.org
Cc:     linux-media@vger.kernel.org,
        James Hilliard <james.hilliard1@gmail.com>
Subject: [PATCH zbar 1/1] v4l2: add fallback for systems without V4L2_CTRL_WHICH_CUR_VAL
Date:   Wed, 16 Jan 2019 13:23:10 +0800
Message-Id: <1547616190-24085-1-git-send-email-james.hilliard1@gmail.com>
X-Mailer: git-send-email 2.7.4
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

From: James Hilliard <james.hilliard1@gmail.com>

Some older systems don't seem to have V4L2_CTRL_WHICH_CUR_VAL so add a
fallback.

Signed-off-by: James Hilliard <james.hilliard1@gmail.com>
---
 zbar/video/v4l2.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/zbar/video/v4l2.c b/zbar/video/v4l2.c
index 0147cb1..b883ecc 100644
--- a/zbar/video/v4l2.c
+++ b/zbar/video/v4l2.c
@@ -866,7 +866,11 @@ static int v4l2_s_control(zbar_video_t *vdo,
 
     memset(&ctrls, 0, sizeof(ctrls));
     ctrls.count = 1;
+#ifdef V4L2_CTRL_WHICH_CUR_VAL
     ctrls.which = V4L2_CTRL_WHICH_CUR_VAL;
+#else
+    ctrls.ctrl_class = V4L2_CTRL_CLASS_USER;
+#endif
     ctrls.controls = &c;
 
     memset(&c, 0, sizeof(c));
@@ -914,7 +918,11 @@ static int v4l2_g_control(zbar_video_t *vdo,
 
     memset(&ctrls, 0, sizeof(ctrls));
     ctrls.count = 1;
+#ifdef V4L2_CTRL_WHICH_CUR_VAL
     ctrls.which = V4L2_CTRL_WHICH_CUR_VAL;
+#else
+    ctrls.ctrl_class = V4L2_CTRL_CLASS_USER;
+#endif
     ctrls.controls = &c;
 
     memset(&c, 0, sizeof(c));
-- 
2.7.4

