Return-Path: <SRS0=iic/=PR=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89DB1C43387
	for <linux-media@archiver.kernel.org>; Wed,  9 Jan 2019 00:17:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 564E420883
	for <linux-media@archiver.kernel.org>; Wed,  9 Jan 2019 00:17:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jAKaQrPn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729168AbfAIAQC (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 8 Jan 2019 19:16:02 -0500
Received: from mail-pf1-f194.google.com ([209.85.210.194]:40578 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727917AbfAIAQC (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 8 Jan 2019 19:16:02 -0500
Received: by mail-pf1-f194.google.com with SMTP id i12so2724958pfo.7;
        Tue, 08 Jan 2019 16:16:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=RmobXmdh5KaomT8TdFIr2+dJd6/NCDTEAkU6A7sJjko=;
        b=jAKaQrPngbn5pJw1ygbphTtf94Auf9YRUP5Bb9JA3DFSVtXFBbncAlO8AZs4Y6WsTa
         IuFoIuBUnV0iJaoLzF3h9sBIMeRDlGrC5woKuesl9izTKyXHsW9v+OYoR7E9XwKb89FL
         M8F3QYSpt1xVJkzWehO4enpfUyCPQE+EpvInqceOx9KiKd//QtZaMpYDd+dfUykXs0EG
         SZsv2cIA+vh7WDli9lFkJ7x8j75SSIOZNyzXUS3bxqmtbWNjIHsapBemgTO9TNn8escU
         xSHH/QXftsjd+LEAeYF64v9+B/vIpCZMKz3FwSgR0JBiNybs3dTLL1Nsxp7zAXooodnc
         9jYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=RmobXmdh5KaomT8TdFIr2+dJd6/NCDTEAkU6A7sJjko=;
        b=WZ6w/spnC/UX+gNZqAZI2nw9Rrfe1UbntdUfuUEEZ85bA0HHLcsQBiaXlAB9Z83GLb
         R2CwHn1jsaNBF64D/aX7qopDC77DOC1ie419S0XTq3/ddFDQ7ukN15jGZBvho7sPBGZs
         CwDSFqj5f62811GIM/3xrd5znSYQ++bjtJzlQGxvzCfdlw1WXYqFeWAkiEcRDfDLa7mm
         djEy5t+D1v1JG+L9i7lcrSzxL+A4nIs/sVgbchS0MMAdPRxiU78G005Sb740wdLW0+74
         HEFZbk80o5fLWWSGG3xGRgakkPFGszT2hRPNsZezBzGhzOM8ZA0lGhE4g0MU59Fm15iY
         Dykg==
X-Gm-Message-State: AJcUukeXjDHcWk3IxJN4hU7Y+GzBZddbWK0PXbQi5cnkbVa6fJ/Jo1It
        mCd5OOH0sxiCIVvC8Ocp+UOXffUu
X-Google-Smtp-Source: ALg8bN7fiAIimH8gUHAHB8YoxZHR84CXkOgaGIZHDYwmKUjoMhwjA0ZdJlP9D9+vTSy7qDCJL1C9QQ==
X-Received: by 2002:a62:d005:: with SMTP id p5mr3797170pfg.175.1546992960736;
        Tue, 08 Jan 2019 16:16:00 -0800 (PST)
Received: from majic.sklembedded.com (c-98-210-181-167.hsd1.ca.comcast.net. [98.210.181.167])
        by smtp.googlemail.com with ESMTPSA id 134sm83978490pgb.78.2019.01.08.16.15.59
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 08 Jan 2019 16:15:59 -0800 (PST)
From:   Steve Longerbeam <slongerbeam@gmail.com>
To:     linux-media@vger.kernel.org
Cc:     Steve Longerbeam <slongerbeam@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v6 01/12] media: videodev2.h: Add more field helper macros
Date:   Tue,  8 Jan 2019 16:15:40 -0800
Message-Id: <20190109001551.16113-2-slongerbeam@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190109001551.16113-1-slongerbeam@gmail.com>
References: <20190109001551.16113-1-slongerbeam@gmail.com>
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

