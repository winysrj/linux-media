Return-Path: <SRS0=iic/=PR=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 820BFC43387
	for <linux-media@archiver.kernel.org>; Wed,  9 Jan 2019 08:46:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5222C2075C
	for <linux-media@archiver.kernel.org>; Wed,  9 Jan 2019 08:46:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linaro.org header.i=@linaro.org header.b="KzLn6sB5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729729AbfAIIqz (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 9 Jan 2019 03:46:55 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:42119 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730061AbfAIIqr (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 9 Jan 2019 03:46:47 -0500
Received: by mail-wr1-f66.google.com with SMTP id q18so6746424wrx.9
        for <linux-media@vger.kernel.org>; Wed, 09 Jan 2019 00:46:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=QhVYgwj7yl7MmrsTxcuTj32eYDDbC109TInYY9lJ7N0=;
        b=KzLn6sB5gXyDiESLuXVHb8RSBZdS3Z+JGMfZ7rjtrCXazereVFyE6KzxRKqp1ReyF0
         bOOkU6dJSOmE0O5YjnDybR816ROyzy4/FPr9ildnJSUuCVJllCDVQuk0r36XlptvTelG
         Ql9ffvZBNu3zkyIIxajgs4XqFK+JHE16rdbq8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=QhVYgwj7yl7MmrsTxcuTj32eYDDbC109TInYY9lJ7N0=;
        b=MSLonNsj+VYsPs5I3DI6KGHzqItlLe3jPUa3tSIR8WIpgyyUpHKKdECvTnhB7+zmO+
         ZXiGPh9Asfun5OwHUA9h41z6vSq2K4zMgnCFNcJT1xHMkrEZvJNPfrP7T7uaywiPvPLE
         G+4z0jiUf7oIv0w7ukcuEMDtAEzpz9As/OKGBkTWPritvU53xVqK6cSz0paHX6bvOc6z
         Z9XVjnh1mjCGwtStEo4JB7/BzntXdmqfv0hI//nj0RibOsVBoUdaKK0VzjQqNioHnN+r
         xN8QUvfyYKMP+ZG/vbIQhWNADphQ4VozbOm32mHlodWRgECVyrGQ6jt5NonkgT9Ptb2u
         XkRA==
X-Gm-Message-State: AJcUukdA/79zbfD0I6uSCYsHceRZDAoyjE/pOvHSueQAzZivWaM7jsm+
        JQd+8mdzTFMLXbb6MBLhK0LDxSPrWoM=
X-Google-Smtp-Source: ALg8bN5uJio6uuBP8RtKt2F0rjR7xDtzJIx6UmStkfDwSqGSC9QxbvF7g6y9LsvkKrpA8bsUF80Ayg==
X-Received: by 2002:adf:c452:: with SMTP id a18mr4262717wrg.145.1547023605976;
        Wed, 09 Jan 2019 00:46:45 -0800 (PST)
Received: from localhost.localdomain ([37.157.136.206])
        by smtp.gmail.com with ESMTPSA id n82sm12776455wma.42.2019.01.09.00.46.44
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 09 Jan 2019 00:46:45 -0800 (PST)
From:   Stanimir Varbanov <stanimir.varbanov@linaro.org>
To:     linux-media@vger.kernel.org
Cc:     Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        Vikash Garodia <vgarodia@codeaurora.org>,
        Tomasz Figa <tfiga@chromium.org>,
        Alexandre Courbot <acourbot@chromium.org>,
        Malathi Gottam <mgottam@codeaurora.org>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>
Subject: [PATCH 4/4] venus: helpers: drop setting of timestap invalid flag
Date:   Wed,  9 Jan 2019 10:46:16 +0200
Message-Id: <20190109084616.17162-5-stanimir.varbanov@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190109084616.17162-1-stanimir.varbanov@linaro.org>
References: <20190109084616.17162-1-stanimir.varbanov@linaro.org>
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

The zero timestap is really a valid so not sure why I discarded it. Fix
that mistake by drop the code which checks for zero timestamp.

Signed-off-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>
---
 drivers/media/platform/qcom/venus/helpers.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/media/platform/qcom/venus/helpers.c b/drivers/media/platform/qcom/venus/helpers.c
index e436385bc5ab..5cad601d4c57 100644
--- a/drivers/media/platform/qcom/venus/helpers.c
+++ b/drivers/media/platform/qcom/venus/helpers.c
@@ -439,9 +439,6 @@ session_process_buf(struct venus_inst *inst, struct vb2_v4l2_buffer *vbuf)
 	fdata.flags = 0;
 	fdata.clnt_data = vbuf->vb2_buf.index;
 
-	if (!fdata.timestamp)
-		fdata.flags |= HFI_BUFFERFLAG_TIMESTAMPINVALID;
-
 	if (type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {
 		fdata.buffer_type = HFI_BUFFER_INPUT;
 		fdata.filled_len = vb2_get_plane_payload(vb, 0);
-- 
2.17.1

