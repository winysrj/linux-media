Return-Path: <SRS0=99fO=RB=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22495C43381
	for <linux-media@archiver.kernel.org>; Tue, 26 Feb 2019 17:05:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DDFC82173C
	for <linux-media@archiver.kernel.org>; Tue, 26 Feb 2019 17:05:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="qwxUAL6d"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728524AbfBZRFo (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 26 Feb 2019 12:05:44 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:42766 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728475AbfBZRFo (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 26 Feb 2019 12:05:44 -0500
Received: by mail-wr1-f67.google.com with SMTP id r5so14776201wrg.9
        for <linux-media@vger.kernel.org>; Tue, 26 Feb 2019 09:05:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=W9KqbqFn/6YfJv+YuJSvZWh6iSIWrSMsB1/ivTkTeB8=;
        b=qwxUAL6dXgeNAMq51wYa6jbC9s9TzHweutUOkbh7HQSqOxIHD5J728czGNEyjF1kaH
         fXaNPfAgGDcoUUP9v8aY4DywxJ+dV3+Y+Av+ARnAvpFBfoXmruYrRnMkXULcPAqZo15E
         xPxUbGCajCNRSI8r/gUbNyJBnvH6f4f6uAvQIMBCVnUG1usXsfivMP+uPJH2xX/OK6TN
         h4bFJo0EU7mxSs3CmECW3zRdV47up+MPauGyB8OFbed8EacYU5W6YkvbRZ2YNPg8m3Qc
         by1vwMq0aP2EU3EXtspOZDtneoESxIf4MmN8+zBdK4euasHnjzmdh8bx83c7KhqKFMj/
         2iaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=W9KqbqFn/6YfJv+YuJSvZWh6iSIWrSMsB1/ivTkTeB8=;
        b=Ye0OUZfDfHNPVQ7GDLxTFhZNtzop+Ge0spyEDFYqxLt9L8KUiHgBEr8Ac6reX767MY
         Q0Ri/c1I+4x2Ug+b2a5WYlu134TvZDdUA/evEVRxjmeD3CsDa8lVB3VV/VzBi93Z7Bkd
         BoMvOpPXyyEPAFhdG4OmnakUs05jGZ2Nl6/1yuqyfXeQPegnUlyUOHu8y+/QiB3SrgKP
         7gSLgcspCBcarqcnr0eRfswllgCFHhoiXDZbL8aO7tsOmhgH7ETAGnW+tFXaZt/q3Us4
         DQKXDATdu0eHnbsKrEJA1eVx36978OCbQX54ydmkCzry6I7gnFK0Fk2SyOn6jjvZXIeR
         TMqA==
X-Gm-Message-State: AHQUAuarYbFZ6tICNS2kMoR299G9B7WTuugV0GIZlJSBfPVfI5jrkCU+
        SCbSj9X7AZYsZDzrVPbQzHIjOJtFCkE=
X-Google-Smtp-Source: AHgI3IZY0mM51TAbjDr2R2sHZQdeabx6zV3TZSMWvD4kspPgb/orAuMWB6b3aCmqozwK6jkpUtSfeA==
X-Received: by 2002:adf:f9c4:: with SMTP id w4mr17819103wrr.218.1551200741925;
        Tue, 26 Feb 2019 09:05:41 -0800 (PST)
Received: from ubuntu.home ([77.127.107.32])
        by smtp.gmail.com with ESMTPSA id w4sm21024486wrk.85.2019.02.26.09.05.40
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 26 Feb 2019 09:05:41 -0800 (PST)
From:   Dafna Hirschfeld <dafna3@gmail.com>
To:     linux-media@vger.kernel.org
Cc:     hverkuil@xs4all.nl, helen.koike@collabora.com,
        Dafna Hirschfeld <dafna3@gmail.com>
Subject: [PATCH v5 09/21] media: vicodec: bugfix: free compressed_frame upon device release
Date:   Tue, 26 Feb 2019 09:05:02 -0800
Message-Id: <20190226170514.86127-10-dafna3@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190226170514.86127-1-dafna3@gmail.com>
References: <20190226170514.86127-1-dafna3@gmail.com>
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Free compressed_frame buffer upon device release.

Signed-off-by: Dafna Hirschfeld <dafna3@gmail.com>
---
 drivers/media/platform/vicodec/vicodec-core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/platform/vicodec/vicodec-core.c b/drivers/media/platform/vicodec/vicodec-core.c
index 8205a602bb38..8128ea6d1948 100644
--- a/drivers/media/platform/vicodec/vicodec-core.c
+++ b/drivers/media/platform/vicodec/vicodec-core.c
@@ -1614,6 +1614,7 @@ static int vicodec_release(struct file *file)
 	v4l2_fh_del(&ctx->fh);
 	v4l2_fh_exit(&ctx->fh);
 	v4l2_ctrl_handler_free(&ctx->hdl);
+	kvfree(ctx->state.compressed_frame);
 	kfree(ctx);
 
 	return 0;
-- 
2.17.1

