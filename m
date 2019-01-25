Return-Path: <SRS0=PLMr=QB=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 311EAC282C3
	for <linux-media@archiver.kernel.org>; Fri, 25 Jan 2019 01:49:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E9956218CD
	for <linux-media@archiver.kernel.org>; Fri, 25 Jan 2019 01:49:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="t1oeCSxC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728320AbfAYBt6 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 24 Jan 2019 20:49:58 -0500
Received: from mail-io1-f68.google.com ([209.85.166.68]:42646 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727983AbfAYBt6 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 24 Jan 2019 20:49:58 -0500
Received: by mail-io1-f68.google.com with SMTP id x6so6492212ioa.9
        for <linux-media@vger.kernel.org>; Thu, 24 Jan 2019 17:49:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=k1eV9OMVLkhnMJCPlXb5Ty01IS0SRm8qx61vOIWEbQM=;
        b=t1oeCSxC9Ni7+NgDmL7sD1yx4JAzgXC55umOoVWLDtGYxAb+2NKs7tEBiZ9q8fbv8i
         7THSZSmHBhXTW3LHaUWiU6B/picuhuc454RWNGjKNN1EuSTYoHDjEbAQ98014QABI5ka
         BN2hmdi5qPIDQ8NHvBJVKEs1k9a02IKBMZxjZGehvellW3MR+Zgxs/dCRxlb4sfAvBsQ
         ZPez3ySkfI3W23gA71wb5ltXp16ZSUAkBre7uDSq+94fkCWIAwF1P+s4IFG4Ts1SGBOy
         jpHYX6FuIHT4YN1759Xpw4Hp3HFkYGcHiB86JuC9R6hJQLY1doImuOxvY5E0yujY56SQ
         rylA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=k1eV9OMVLkhnMJCPlXb5Ty01IS0SRm8qx61vOIWEbQM=;
        b=XSUUehRC5Kmjcf+rBTp4ER5692BhS1g7cqmMyXP8816nMg1lT76fZa1TtLMdym2pLp
         PmD5Nnc1+jXMwdEwX0EPd29urqLVArz4z5i0IDszu6phmpVwWoekJ5zb55apeyTA2tdr
         +iSa9+mvy7JlJM2L4YEs8366YbhR/H4QEFkxsgvP/aZDG+RkDibUPAdCjAQsN+/5XPuy
         iTuwrKoq5Vr64RKufNodxLkZtauyc6arNRrVxw58M0V+R9fLuZ0zRMWm1RbGRMDh7O+c
         BxnATB0IipweBAy5VqcTbLNU3e+Xn4rVAgg5bF4rEPbzMMFhjGpSrpdxfk6LrH0oQklg
         cbVQ==
X-Gm-Message-State: AJcUukcUmRmBZSLxKtuHeoewhpY+D6j1Y7TmTAtseKtP2BJSxCOHkLjh
        7Sp8RXM+fcivjmdY/cwr4NsR0lQ5
X-Google-Smtp-Source: AHgI3IafA8giY3+nVJXbYgNsv4ojMhpjq8qxknwaXEPw+HjpuUhrQTB5R8qzug2Us0FJlDxx5UTc4Q==
X-Received: by 2002:a6b:b589:: with SMTP id e131mr5066960iof.41.1548380997063;
        Thu, 24 Jan 2019 17:49:57 -0800 (PST)
Received: from dragon.Home (71-218-4-112.hlrn.qwest.net. [71.218.4.112])
        by smtp.gmail.com with ESMTPSA id c21sm9550494iob.22.2019.01.24.17.49.55
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Thu, 24 Jan 2019 17:49:55 -0800 (PST)
From:   james.hilliard1@gmail.com
To:     mchehab+samsung@kernel.org
Cc:     linux-media@vger.kernel.org,
        James Hilliard <james.hilliard1@gmail.com>
Subject: [PATCH zbar 1/1] v4l2: add fallback for systems without v4l2_query_ext_ctrl
Date:   Fri, 25 Jan 2019 09:48:01 +0800
Message-Id: <1548380881-17340-1-git-send-email-james.hilliard1@gmail.com>
X-Mailer: git-send-email 2.7.4
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

From: James Hilliard <james.hilliard1@gmail.com>

Signed-off-by: James Hilliard <james.hilliard1@gmail.com>
---
 zbar/video/v4l2.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/zbar/video/v4l2.c b/zbar/video/v4l2.c
index 0d18094..1610b95 100644
--- a/zbar/video/v4l2.c
+++ b/zbar/video/v4l2.c
@@ -55,6 +55,28 @@
 #define V4L2_FORMATS_MAX 64
 #define V4L2_FORMATS_SIZE_MAX 256
 
+#ifndef VIDIOC_QUERY_EXT_CTRL
+#define VIDIOC_QUERY_EXT_CTRL   _IOWR('V', 103, struct v4l2_query_ext_ctrl)
+#define V4L2_CTRL_MAX_DIMS    (4)
+
+struct v4l2_query_ext_ctrl {
+    __u32            id;
+    __u32            type;
+    char             name[32];
+    __s64            minimum;
+    __s64            maximum;
+    __u64            step;
+    __s64            default_value;
+    __u32                flags;
+    __u32                elem_size;
+    __u32                elems;
+    __u32                nr_of_dims;
+    __u32                dims[V4L2_CTRL_MAX_DIMS];
+    __u32            reserved[32];
+};
+
+#endif
+
 typedef struct video_controls_priv_s {
     struct video_controls_s s;
 
-- 
2.7.4

