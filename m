Return-Path: <SRS0=qapk=PV=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77884C43444
	for <linux-media@archiver.kernel.org>; Sun, 13 Jan 2019 23:38:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 45AEA20850
	for <linux-media@archiver.kernel.org>; Sun, 13 Jan 2019 23:38:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gxSLFUPL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726651AbfAMXiq (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sun, 13 Jan 2019 18:38:46 -0500
Received: from mail-io1-f67.google.com ([209.85.166.67]:36264 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726471AbfAMXiq (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 13 Jan 2019 18:38:46 -0500
Received: by mail-io1-f67.google.com with SMTP id m19so16347316ioh.3
        for <linux-media@vger.kernel.org>; Sun, 13 Jan 2019 15:38:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=xG6SHz4LAwaeR7V+JJOIO8LPQO9eG3z72NjVFpbzRGk=;
        b=gxSLFUPLFI1o65J3YWy63qIlxwLkgWCYp2uUFLaZXLJdGOD5X1YHiiyReKAgBFY5t1
         c6WfRWzBerNano91Rso8PHbXOYfm+ffGBl5p/kXPJp/vby3RaFWx5RhHvE7Lo6whnNMh
         DFyHF7Xo+4K1z8RdphWFuv4BzQpA1o3SWCegO8Vbqamox2Nw3tXeHevhHboh29YGyyr9
         ppOgL+Y7vNOfDzjz5TOUCivie3Vc3lNSHBAU7eLJw9pggChpQN3lIHWqjLhCnQsBk1jP
         qHQ4z2fqFo+OOB29u2fBCDmiVGBnF7nAzb+MziIEKDHFKrOYsmukPbPmVjR04EaJCSf8
         ucrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=xG6SHz4LAwaeR7V+JJOIO8LPQO9eG3z72NjVFpbzRGk=;
        b=NS8OqsRgnku2DxAvsc//rK3UA1jtyAPtBf8EXsdOwU/xjyHm/IQmro414ED5reBQTb
         kLYC2/RNB7cpvmjd19DbLmbHwgKyMZ4xKHgVAKpGrF3TNpkjl/jBpjrOhrq4ing09QCx
         2KSkp4RbbW70oEb4RLYKlkOwLKyy0NCyYnYs8MtHXg9WAA9zs46djJbbruoKCsH6IFRa
         OyU6WQN7kf/0MKT6RcZLznGpXAWSn/UioEfLukr3uifN0NyVd98jKovrtP1NzDHstRYX
         CP86sBr1AfIhbgzH9CdZdHL0bwMHNUxbKVQmnY8jUdb0jjS4EOohGF/U3VSqqLFid/dy
         eCOA==
X-Gm-Message-State: AJcUukd0KfgUZOk79KQ3VXCTyHWapV8B6xX5bu6ak7sVGxB8uIKVnZeY
        hg46diepoV4bammv/XP443s=
X-Google-Smtp-Source: ALg8bN44beJY4DajG/y0al9XZoumbqvWjAM9R7zzN11kt0yjyiFAsu7NkL0OpayyVz3hYRbTdiN83Q==
X-Received: by 2002:a6b:600b:: with SMTP id r11mr16094264iog.259.1547422725355;
        Sun, 13 Jan 2019 15:38:45 -0800 (PST)
Received: from dragon.Home (71-218-4-112.hlrn.qwest.net. [71.218.4.112])
        by smtp.gmail.com with ESMTPSA id t70sm3132285ita.17.2019.01.13.15.38.43
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Sun, 13 Jan 2019 15:38:44 -0800 (PST)
From:   james.hilliard1@gmail.com
To:     mchehab+samsung@kernel.org
Cc:     linux-media@vger.kernel.org, Viacheslav Volkov <sv99@inbox.ru>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        James Hilliard <james.hilliard1@gmail.com>
Subject: [PATCH zbar 2/5] Fix function protoype to be compatible with recent libjpeg
Date:   Mon, 14 Jan 2019 07:38:26 +0800
Message-Id: <1547422709-7111-2-git-send-email-james.hilliard1@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1547422709-7111-1-git-send-email-james.hilliard1@gmail.com>
References: <1547422709-7111-1-git-send-email-james.hilliard1@gmail.com>
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

From: Viacheslav Volkov <sv99@inbox.ru>

Signed-off-by: Viacheslav Volkov <sv99@inbox.ru>
Signed-off-by: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Signed-off-by: James Hilliard <james.hilliard1@gmail.com>
---
 zbar/jpeg.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/zbar/jpeg.c b/zbar/jpeg.c
index 972bfea..fdd1619 100644
--- a/zbar/jpeg.c
+++ b/zbar/jpeg.c
@@ -68,7 +68,7 @@ void init_source (j_decompress_ptr cinfo)
     cinfo->src->bytes_in_buffer = img->datalen;
 }
 
-int fill_input_buffer (j_decompress_ptr cinfo)
+boolean fill_input_buffer (j_decompress_ptr cinfo)
 {
     /* buffer underrun error case */
     cinfo->src->next_input_byte = fake_eoi;
-- 
2.7.4

