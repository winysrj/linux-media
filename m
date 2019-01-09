Return-Path: <SRS0=iic/=PR=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9B9EC43387
	for <linux-media@archiver.kernel.org>; Wed,  9 Jan 2019 18:18:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A88F1206B6
	for <linux-media@archiver.kernel.org>; Wed,  9 Jan 2019 18:18:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DDkJr3jh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727633AbfAISQw (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 9 Jan 2019 13:16:52 -0500
Received: from mail-pf1-f194.google.com ([209.85.210.194]:45222 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727574AbfAISQw (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 9 Jan 2019 13:16:52 -0500
Received: by mail-pf1-f194.google.com with SMTP id g62so4015064pfd.12;
        Wed, 09 Jan 2019 10:16:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=RmobXmdh5KaomT8TdFIr2+dJd6/NCDTEAkU6A7sJjko=;
        b=DDkJr3jhu1Svtxh9aobnSIVGOnOtFoAjb6KbsJZtfCL3qHTC2OasLGHRGZD/tjA4C4
         7hclNkvt+OR3vfD82KeSvOthlqX4LT+Kx5wASMoXfXq5W8cx+N67Eq78DkMrV/lleIhs
         a/b8jsDyZSHYLun9sGMQdAdR8T+DYG3hIeIPAf2VKfokBTquPIzMFjOQB9IF2b9dX7Ke
         tEswuY/dK47v1QetI4DmewGCVTyNd9leJOT7X6BLlKtOcCSOgn/MQkN2xLnlzuEIxp9o
         xzYlf1ryUmByInyZJfWrezVU7Vu9T3QaIcfPcyveQINP2YOGG5vIt02nZbLM6JZkXCaI
         oX8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=RmobXmdh5KaomT8TdFIr2+dJd6/NCDTEAkU6A7sJjko=;
        b=cXhztmmo2ktRRD7V2XUY4LtAIPMDF4F238gquUn9HRBvCtLINzJk5CMLFAmUT44AfR
         zpAZhkSBr9Ej5a1ubiYSds0NWkvak6tCRQI/N4OvldRsOS6TMnepHQ5PqjjburUykL5y
         CcKO+FndCYafA1xmVD6nuBZQaf+rZPTSn7YOX+3ErqmSbKNSF7rTIoBm9G6a8B2piZm4
         3Tvx6llCAgJsKD7dylGUnNpvnNdGz4CK7QaedS2ot2/FMzzbaD6LbsC5XQoREHHwR3Mm
         HH4ZuCnHTHq+ZuIj9IKDE+Hrad/LKNK4T2aiBoVihr2ayS1yZ+wJ+RvNdLVjKWlOF2DL
         1C6A==
X-Gm-Message-State: AJcUukfFbsIAlK740javAV4BnB5O/Kgn+i2d5H7C1vkcN6mXmTgQu+lw
        DcQRnXaIdcrVQiWcJ5lZOs+2TOXq
X-Google-Smtp-Source: ALg8bN428o/50VsT5RQcCNP1YMkRa+jTMpK08liC6tWu2tFFZxRds0VuKb2LjFDLst+qYfnpqWHWgw==
X-Received: by 2002:a63:d655:: with SMTP id d21mr6378761pgj.280.1547057811091;
        Wed, 09 Jan 2019 10:16:51 -0800 (PST)
Received: from majic.sklembedded.com (c-98-210-181-167.hsd1.ca.comcast.net. [98.210.181.167])
        by smtp.googlemail.com with ESMTPSA id h19sm97030004pfn.114.2019.01.09.10.16.49
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 09 Jan 2019 10:16:50 -0800 (PST)
From:   Steve Longerbeam <slongerbeam@gmail.com>
To:     linux-media@vger.kernel.org
Cc:     Steve Longerbeam <slongerbeam@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v7 01/11] media: videodev2.h: Add more field helper macros
Date:   Wed,  9 Jan 2019 10:16:31 -0800
Message-Id: <20190109181642.19378-2-slongerbeam@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190109181642.19378-1-slongerbeam@gmail.com>
References: <20190109181642.19378-1-slongerbeam@gmail.com>
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

