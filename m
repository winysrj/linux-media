Return-Path: <SRS0=G3Vt=RO=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F6E4C43381
	for <linux-media@archiver.kernel.org>; Mon, 11 Mar 2019 15:36:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2EDBA20883
	for <linux-media@archiver.kernel.org>; Mon, 11 Mar 2019 15:36:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HWm4Wkoy"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726779AbfCKPgU (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 11 Mar 2019 11:36:20 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:33073 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726546AbfCKPgU (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 11 Mar 2019 11:36:20 -0400
Received: by mail-pg1-f195.google.com with SMTP id h11so4324820pgl.0
        for <linux-media@vger.kernel.org>; Mon, 11 Mar 2019 08:36:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Zw+ZDBhtH5rEsPuUwE6cbsXvsVpuOmGxWeTV7vbELQI=;
        b=HWm4WkoyDMDRu5CE6Y67Jgdk3Gk/QmO13BwS1n/OVlgLJ0OZGk4G9SYHFA1wOe2TCy
         Vw9wucAX9UL4RutL71BWvFnTW/Pf/evq17samwZWu8ZX39q2RBxlV88anyEFV6Z+79ym
         FU89l7iE0dPcUfzBOd3clapdREVCH3l5zcpO/4Ori4vAVZAHy8JdXhK8Qb71VyiYdR8+
         N2iL0hfzPb6xFqMqWFVTMq5oiG7Kavf0RfUGzJsByr51ufXf74lF1x9vHWUjlctxhMCE
         bJi3BQbDpxUsWsQVRLfGMZT/pQxxJ7bz1lQpxD7GT2ghSemWUIuDPB2CeKECNCBn5vSc
         G1Ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Zw+ZDBhtH5rEsPuUwE6cbsXvsVpuOmGxWeTV7vbELQI=;
        b=qeHlawZnFO8Ny1GAG4O7iAjGg0iJfbBYoZ9P/FikKH4BboI1Et1QqAYk+CHoKbV1Um
         DHjyMOKZB7xuC3quBoWzSedkwGByjAWzp6pjQzkT9VOYyXOeQlWY0NpYffYnUk9EQMyb
         JeYD7IQVFLwz84HRSla1GqCoX9YkxeSn5A23yk6vQugfBZfzAXnE/ll2f2TpkzeEbRqx
         Q01LXQTHjT4FQeTfDtoDyHO1oUUEA0OtnKkEzn6ddMbYseRMYz3aU7b7PWdWmSeRAXen
         /Q91zbrR0SfVRXE+GWD7vYxJsy8xexNoLVgi/MinRdxzvV9Zp0mMImqzrO923zPZ44bD
         /FWQ==
X-Gm-Message-State: APjAAAWULbx9sexk/nDnUPrj3+0mc8jyNVzXggYYLZYrKz2wtzJzjLb/
        qKfw5jP9yJYmRJfndA4eaWbMB/VV
X-Google-Smtp-Source: APXvYqwuX4DuJoPeO/gvX7wlQ076ICy8UmVs/uPA00/Fygt+FEu/eaUbPvQPxQeObElB2Gq78dvoAg==
X-Received: by 2002:a63:1053:: with SMTP id 19mr30652673pgq.55.1552318579688;
        Mon, 11 Mar 2019 08:36:19 -0700 (PDT)
Received: from localhost.localdomain ([240f:34:212d:1:1b24:991b:df50:ea3f])
        by smtp.gmail.com with ESMTPSA id f28sm10428364pfh.178.2019.03.11.08.36.17
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Mon, 11 Mar 2019 08:36:19 -0700 (PDT)
From:   Akinobu Mita <akinobu.mita@gmail.com>
To:     linux-media@vger.kernel.org
Cc:     Akinobu Mita <akinobu.mita@gmail.com>,
        Lubomir Rintel <lkundrak@v3.sk>,
        Jonathan Corbet <corbet@lwn.net>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: [PATCH 1/2] media: ov7670: restore default settings after power-up
Date:   Tue, 12 Mar 2019 00:36:02 +0900
Message-Id: <1552318563-6685-2-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1552318563-6685-1-git-send-email-akinobu.mita@gmail.com>
References: <1552318563-6685-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Since commit 3d6a8fe25605 ("media: ov7670: hook s_power onto v4l2 core"),
the device is actually powered off while the video stream is stopped.

The frame format and framerate are restored right after power-up, but
restoring the default register settings is forgotten.

Fixes: 3d6a8fe25605 ("media: ov7670: hook s_power onto v4l2 core")
Cc: Lubomir Rintel <lkundrak@v3.sk>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
---
 drivers/media/i2c/ov7670.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/i2c/ov7670.c b/drivers/media/i2c/ov7670.c
index a7d26b2..e65693c 100644
--- a/drivers/media/i2c/ov7670.c
+++ b/drivers/media/i2c/ov7670.c
@@ -1664,6 +1664,7 @@ static int ov7670_s_power(struct v4l2_subdev *sd, int on)
 
 	if (on) {
 		ov7670_power_on (sd);
+		ov7670_init(sd, 0);
 		ov7670_apply_fmt(sd);
 		ov7675_apply_framerate(sd);
 		v4l2_ctrl_handler_setup(&info->hdl);
-- 
2.7.4

