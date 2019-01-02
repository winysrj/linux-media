Return-Path: <SRS0=KeAI=PK=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2AF1EC43387
	for <linux-media@archiver.kernel.org>; Wed,  2 Jan 2019 16:04:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E7681218A4
	for <linux-media@archiver.kernel.org>; Wed,  2 Jan 2019 16:04:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="U83POzEZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730354AbfABQEK (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 2 Jan 2019 11:04:10 -0500
Received: from mail-ed1-f68.google.com ([209.85.208.68]:42853 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729435AbfABQEK (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 2 Jan 2019 11:04:10 -0500
Received: by mail-ed1-f68.google.com with SMTP id y20so26556284edw.9
        for <linux-media@vger.kernel.org>; Wed, 02 Jan 2019 08:04:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=nlScZb1Kr12SXjk8ffD51mk9WQmM6MiWVvQFDfBJLuI=;
        b=U83POzEZsEdcc8FZE8QpWRBhbSUfC/EgS7wSJ7u1cATfbZAeaa6540mjQ412Aw+MSa
         lbzvCOiZe+n2fTwGFevpRgM82FlB3jSxi4c1afvz9cBXKr5kcKf0CPMvapkKZx6ZZKEt
         LNru5UFesceiC7lEAgw/9v5ve1n5m9H7np0AbV6h8JlrphEUVtIj8YFO+kLzT++EMmZQ
         GvqwOvON90iSIeEpS/c8Rl2qp7bWVEQZIhaDQfdl0u5pGVznFXZ9ed5OnaR8PTkhAHm+
         Y7VZCPlgHXJ2pQhdGlurLMhULfr602BO2QeTq0C4VZuakzarGGQUcqcCYLCdvrqShjAo
         O7pA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=nlScZb1Kr12SXjk8ffD51mk9WQmM6MiWVvQFDfBJLuI=;
        b=pn/aPbWYyaSqNp5GrHKcfNZoX8djtelJXnwrqheRpMFy+CKUfHWGNNgyGI71tJvsvr
         YwhGyp4NIWfhk1s2GSEd0LyYzr9F+2jalNQ6XLMhCVqMRmjA/zgO+R4iP5jNBg0dyRkh
         BNFxgRc9gcg+pT9p3H29w2Rkpb01mz90cBjIz0wNaqExBoY2FPMkoaR17jnKYNkJw3bv
         CZvENBZvZi4swEdXQVvrdWj+G3QeJnpSMNFn/31/H4WCDqh7KMtYVUiHp8T4ycxR9SUu
         Y1EVBvGJ9uVTiRYYJRUlVu50cZCNeYrFB/R7791Um6yi1XdPaC5ii2G1sX4YuWzoDcM9
         tlkQ==
X-Gm-Message-State: AA+aEWYZ1V22gzJohOq7IlAAhnd0KK+42EguBBqhB1n1GUlJZHCmtRoz
        xwrcy/ejemfcjtQrzWQehHJ9mTsb
X-Google-Smtp-Source: AFSGD/XjpoTFZPSJdM6rnqLErrUmTVQ3PRvE6J74Rm4GGKC7cOytSibRM/8lD8cPMcgXk2RsOER7Pg==
X-Received: by 2002:a50:ab82:: with SMTP id u2mr40216725edc.111.1546445048223;
        Wed, 02 Jan 2019 08:04:08 -0800 (PST)
Received: from localhost.localdomain (195.145.107.92.dynamic.wline.res.cust.swisscom.ch. [92.107.145.195])
        by smtp.gmail.com with ESMTPSA id l18sm21291593edq.87.2019.01.02.08.04.07
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 02 Jan 2019 08:04:07 -0800 (PST)
From:   =?UTF-8?q?Andr=C3=A9=20Roth?= <neolynx@gmail.com>
To:     linux-media@vger.kernel.org
Cc:     abassetta@tiscali.it,
        =?UTF-8?q?Andr=C3=A9=20Roth?= <neolynx@gmail.com>
Subject: [PATCH 2/3] libdvbv5: enable newlines in dvb strings
Date:   Wed,  2 Jan 2019 17:03:13 +0100
Message-Id: <20190102160314.7451-2-neolynx@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190102160314.7451-1-neolynx@gmail.com>
References: <20190102160314.7451-1-neolynx@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Newlines in are encoded as 0x8a, convert them to '\n'

Signed-off-by: André Roth <neolynx@gmail.com>
---
 lib/libdvbv5/parse_string.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/lib/libdvbv5/parse_string.c b/lib/libdvbv5/parse_string.c
index 6e301ac8..d354f497 100644
--- a/lib/libdvbv5/parse_string.c
+++ b/lib/libdvbv5/parse_string.c
@@ -461,11 +461,13 @@ void dvb_parse_string(struct dvb_v5_fe_parms *parms, char **dest, char **emph,
 				emphasis = 1;
 			else if (*s == 0x87 && emphasis)
 				emphasis = 0;
-			else  if (*s >= 0x20 && (*s < 0x80 || *s > 0x9f)) {
+			else if (*s >= 0x20 && (*s < 0x80 || *s > 0x9f)) {
 				*p++ = *s;
 				if (emphasis)
 					*p2++ = *s;
 			}
+			else if (*s == 0x8a)
+				*p++ = '\n';
 		}
 		*p = '\0';
 		*p2 = '\0';
@@ -495,6 +497,8 @@ void dvb_parse_string(struct dvb_v5_fe_parms *parms, char **dest, char **emph,
 				emphasis = 1;
 			else if (code == 0xe087 && emphasis)
 				emphasis = 0;
+			else if (code == 0xe08a)
+				/* newline, append code blow */ ;
 			else if (code >= 0xe080 && code <= 0xe09f)
 				continue;
 
-- 
2.17.1

