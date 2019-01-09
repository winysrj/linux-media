Return-Path: <SRS0=iic/=PR=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46B39C43387
	for <linux-media@archiver.kernel.org>; Wed,  9 Jan 2019 18:30:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F2DB221738
	for <linux-media@archiver.kernel.org>; Wed,  9 Jan 2019 18:30:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ONehKLSb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726881AbfAISa3 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 9 Jan 2019 13:30:29 -0500
Received: from mail-pl1-f195.google.com ([209.85.214.195]:38041 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726465AbfAISa3 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 9 Jan 2019 13:30:29 -0500
Received: by mail-pl1-f195.google.com with SMTP id e5so3956767plb.5;
        Wed, 09 Jan 2019 10:30:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=RmobXmdh5KaomT8TdFIr2+dJd6/NCDTEAkU6A7sJjko=;
        b=ONehKLSbVq+0fPChek5XsBf9lexIOo5/LOzDcjlbNrGC5gKyGIb5nSQc7Ka11PapqJ
         Ho5Bv3s4MAa+NrPNJHt0v6qsUvkpnHY1E55E68kyAbkJcZMB4r6PTRuKwNCNWns2Xt8g
         4vKEDv0tlfHDnYDSEO8WioYkfpJFwcH6ywgdiKeFHsLMJYBA73JQ3W11CRHLW1dpwWe9
         mS0kC2ABs9Ug+V+TgSgYwWg9p8ktYI5J+qWEjQTiR/+8LCcbceXoYqAFXDH0rgp7vCCk
         hpGiPBVz/0r3uZcy5SwEsiAlDB4Vsd+jOoSTGx2VLhw5MU9QufbrsfkCJeITGIaT4C3T
         p/2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=RmobXmdh5KaomT8TdFIr2+dJd6/NCDTEAkU6A7sJjko=;
        b=UZujKcAN0BFYMJMJgnK4rbW3ge3HQ9stmoRuedeFveVBbfbwIyJi/Ep8m/oNxrHBE4
         UEy7ieM9cv0z7Hd75+nirs4f0F5smOXbQAbNqV4nFFilHpxcJj2aflGXkWntb+EjG2Kb
         TQIVUM6KNgp04apfBL9coz2yP6t5AhIZvCaZxrTRfyl3PS75Wq1ClYJ1Eupk693xg6zd
         2luWPv7XdcMXCvA7QF1tg7WfN2DSYZSVeS43nRTnZFkG+1kuhR3Erz6RTfyzEs/GSKtn
         4X9oabcRmiITUEBmm9c5IMbqLtDfl2rpBHRpZbFqkCrnONkRDhwh7IYM3dYCWj9scLUw
         R/Ng==
X-Gm-Message-State: AJcUukeWT+ZbXMmPkukWoKT01+X4EC5alcs9dgjuRhmoRV0nVPkeRI9R
        rOIQZscYGkNEnKDkfR2PUzQI4swV
X-Google-Smtp-Source: ALg8bN42d5PKBPw20PX6QXXbXuHl4fFs5OOdA9gKZ9Y3c18/A0E87cL/c1t5VdAMY58IOUOM5+zhVA==
X-Received: by 2002:a17:902:e18d:: with SMTP id cd13mr7157567plb.262.1547058627810;
        Wed, 09 Jan 2019 10:30:27 -0800 (PST)
Received: from majic.sklembedded.com (c-98-210-181-167.hsd1.ca.comcast.net. [98.210.181.167])
        by smtp.googlemail.com with ESMTPSA id v191sm157551056pgb.77.2019.01.09.10.30.26
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 09 Jan 2019 10:30:27 -0800 (PST)
From:   Steve Longerbeam <slongerbeam@gmail.com>
To:     linux-media@vger.kernel.org
Cc:     Steve Longerbeam <slongerbeam@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v8 01/11] media: videodev2.h: Add more field helper macros
Date:   Wed,  9 Jan 2019 10:30:04 -0800
Message-Id: <20190109183014.20466-2-slongerbeam@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190109183014.20466-1-slongerbeam@gmail.com>
References: <20190109183014.20466-1-slongerbeam@gmail.com>
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Adds two helper macros:

V4L2_FIELD_IS_SEQUENTIAL: returns true if the given field type is
'sequential', that is a full frame is transmitted, or exists in
memory, as all top field lines followed by all bottom field lines,
or vice-versa.

V4L2_FIELD_IS_INTERLACED: returns true if the given field type is
'interlaced', that is a full frame is transmitted, or exists in
memory, as top field lines interlaced with bottom field lines.

Signed-off-by: Steve Longerbeam <slongerbeam@gmail.com>
---
Changes since v3:
- none
Changes since v2:
- none
Changes since v1:
- add the complement macro V4L2_FIELD_IS_INTERLACED
- remove V4L2_FIELD_ALTERNATE from V4L2_FIELD_IS_SEQUENTIAL macro.
- moved new macros past end of existing V4L2_FIELD_HAS_* macros.
---
 include/uapi/linux/videodev2.h | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
index d6eed479c3a6..bca07d35ea09 100644
--- a/include/uapi/linux/videodev2.h
+++ b/include/uapi/linux/videodev2.h
@@ -130,6 +130,13 @@ enum v4l2_field {
 	((field) == V4L2_FIELD_BOTTOM ||\
 	 (field) == V4L2_FIELD_TOP ||\
 	 (field) == V4L2_FIELD_ALTERNATE)
+#define V4L2_FIELD_IS_INTERLACED(field) \
+	((field) == V4L2_FIELD_INTERLACED ||\
+	 (field) == V4L2_FIELD_INTERLACED_TB ||\
+	 (field) == V4L2_FIELD_INTERLACED_BT)
+#define V4L2_FIELD_IS_SEQUENTIAL(field) \
+	((field) == V4L2_FIELD_SEQ_TB ||\
+	 (field) == V4L2_FIELD_SEQ_BT)
 
 enum v4l2_buf_type {
 	V4L2_BUF_TYPE_VIDEO_CAPTURE        = 1,
-- 
2.17.1

