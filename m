Return-Path: <SRS0=d4St=Q7=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8943C43381
	for <linux-media@archiver.kernel.org>; Sun, 24 Feb 2019 09:03:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7D46D20652
	for <linux-media@archiver.kernel.org>; Sun, 24 Feb 2019 09:03:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BVBVOYEY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728194AbfBXJDD (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sun, 24 Feb 2019 04:03:03 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:45375 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728171AbfBXJDD (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 24 Feb 2019 04:03:03 -0500
Received: by mail-wr1-f66.google.com with SMTP id w17so6634588wrn.12
        for <linux-media@vger.kernel.org>; Sun, 24 Feb 2019 01:03:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=o9zYKasQfC6ebh8duof0c11E7kUOHzi6LO5uCUHPzRk=;
        b=BVBVOYEYKXwqP0MNBMZwqOm7egIn3/3t0VzYwj64iCBSOsnQa0JGw2c+NMX0bg8IH0
         ByLd0gMOFVO43JLtayAFlFWOuEukk5Pzo+04DAGJT17KT1iY918z4VGkpNrcq7paLdbt
         pW1wakGhZlWLc+b1DzlQnlutYpS/PD/8XSs+d2HnDkDrbAAJ0IamZDsg3cQ6Vq/dKvVn
         r8nA1RMiLI7x6Z3HGDQk2sstuRXAw0De5ygdr6+1CyiahdK4nSjkY1foOiGPe1c4sgjH
         9cp+L8jyiXgcF/USq5rNp5oSZzOtDKx75r7D83BFlJHPSXnlKZp8QVgZyIg92Dic2yol
         W1tA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=o9zYKasQfC6ebh8duof0c11E7kUOHzi6LO5uCUHPzRk=;
        b=gATCjhgfbqtG1WeMR5Zvd4SX23f5j0cT0sJaDWxtigdZkmHu2Y0sr+Ts90zw/BKffr
         ryM42JORi4YnplLvx/2wqd6EOayEas/8avk9pK/j6Dr4KUiogpE2KWDrJv2n+jzHabFq
         h5rGO5I2rC2yqmPdui2pFXZU/JOJc1B1NSaPeJZqrUkkDcxdSsn3nqevxw0TfU/C8PdW
         qX0aF1BSYDOOsxkK21JyKYv0ELkrWGsGhA/d5n9QR+QDtXvqQsIrdB816UUpKy02MyRw
         i8PT4Etx7nV7Vq5GkIzL9LBneD1APnwVi0x7HFS6wJ2oV7ECmWymAUDJRl/0TxObA3Ly
         skPA==
X-Gm-Message-State: AHQUAuYd1mrX7N22vavNUf47xLK+E5w7/yq1UBjpQb7kCJjgqh6HR79o
        PBD5lG8ufIQRm5zJi3cQwyZ0Q8UJlnk=
X-Google-Smtp-Source: AHgI3Ib5ObBUX+MpJ6wJ3NMUQsKAJSp/AUbjEXJr8DKE6YsakCkAJ3rRcJRKSzdzqroUs/8eX/x+DA==
X-Received: by 2002:a5d:4841:: with SMTP id n1mr8834533wrs.85.1550998980796;
        Sun, 24 Feb 2019 01:03:00 -0800 (PST)
Received: from ubuntu.home ([77.127.107.32])
        by smtp.gmail.com with ESMTPSA id e75sm8701971wmg.32.2019.02.24.01.02.59
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 24 Feb 2019 01:03:00 -0800 (PST)
From:   Dafna Hirschfeld <dafna3@gmail.com>
To:     linux-media@vger.kernel.org
Cc:     hverkuil@xs4all.nl, helen.koike@collabora.com,
        Dafna Hirschfeld <dafna3@gmail.com>
Subject: [PATCH v3 08/18] media: vicodec: bugfix: free compressed_frame upon device release
Date:   Sun, 24 Feb 2019 01:02:25 -0800
Message-Id: <20190224090234.19723-9-dafna3@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190224090234.19723-1-dafna3@gmail.com>
References: <20190224090234.19723-1-dafna3@gmail.com>
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
index cd08f0cd4cf8..d1f7b7304364 100644
--- a/drivers/media/platform/vicodec/vicodec-core.c
+++ b/drivers/media/platform/vicodec/vicodec-core.c
@@ -1614,6 +1614,7 @@ static int vicodec_release(struct file *file)
 	mutex_lock(vfd->lock);
 	v4l2_m2m_ctx_release(ctx->fh.m2m_ctx);
 	mutex_unlock(vfd->lock);
+	kvfree(ctx->state.compressed_frame);
 	kfree(ctx);
 
 	return 0;
-- 
2.17.1

