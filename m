Return-Path: <SRS0=Cp5C=P2=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 652F3C61CE3
	for <linux-media@archiver.kernel.org>; Fri, 18 Jan 2019 23:31:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3518D20823
	for <linux-media@archiver.kernel.org>; Fri, 18 Jan 2019 23:31:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QHpMgtM+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730280AbfARXbP (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 18 Jan 2019 18:31:15 -0500
Received: from mail-pl1-f196.google.com ([209.85.214.196]:45609 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730115AbfARXam (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 18 Jan 2019 18:30:42 -0500
Received: by mail-pl1-f196.google.com with SMTP id a14so6972890plm.12;
        Fri, 18 Jan 2019 15:30:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=tILAUjKy4+5QmA7cKr1Y9UyKRlK9bcmdZJH0+ju/KnI=;
        b=QHpMgtM+oz03m9EzvSgVU6jBMUPCSMve87QxryhQuBBrRf1k1LCLsfcrtUPbZ9WdSq
         +qerKqWG2bOJ7vU96ybpRcyMA8hr6KJLRijEZn2yaeiTaxWk5LgoqhRu8rqfDdeZu33p
         xQCM2fDzHuy5T8iqI/+ON+ay/Bi7iVXznEkDNZWfz07Rxkw3tSyFWd3o6P5ZtxhkWsTx
         Hsj5f4Q+QBtdVru2CPk0unG3POJZVrnhLpbAcVUagjlvO/e7BUGSrlDPzEeIGex7zZvt
         VOKYsivBf0VNfXUCuC9jqZKtqeKyI7x43cn7tboZzBvTcPZh6n3YoD04qWt2/UUs50F0
         5WXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=tILAUjKy4+5QmA7cKr1Y9UyKRlK9bcmdZJH0+ju/KnI=;
        b=DPXK8/3yW2Xvquw2QOz3VLkCxmPNYeJDbR9y+MMlNtlBbfSzVyucxBrKQyeuSSRAVC
         hXQ2mLFXfMENuvUhJW7B6f9PaVwed4bnpUL8g1TsvWRV6sYPpojyuu5Z6SOuE6a3rWZ1
         /eRg8nlkFAVbViioyNcs8l5/zxYnhDi++DdSdSg4DBDJtGK5JP5qaUNplyn7vEEeZdLy
         fHjE4vOV68tNmXcgFhu2wQm6LxK/Eu/T0iJnY5xTeUdKbWL5rIOgbw4dhAjAIC2YFOdF
         6xmI1OqgCA7lWXywSK1/gNjx3X1hXoljCXKliHtrCrfYWRnHcvq4qAbdl/0Jx2tPZDN/
         BMfQ==
X-Gm-Message-State: AJcUukdBA09sD2wBNWQV8BSjNMCvH+nag2Frm0pPS+gfVNcX8rILO9Gg
        bE5/KlcpnWMDXKGp0t+6ID/OlSdp
X-Google-Smtp-Source: ALg8bN5VEagiDKQwIiUcPeGMlaX1SaKu/WMXQmrfjl2jZRezLaDOo2KEESA4A42gtb2/joNGblHi+w==
X-Received: by 2002:a17:902:7005:: with SMTP id y5mr21062746plk.7.1547854241595;
        Fri, 18 Jan 2019 15:30:41 -0800 (PST)
Received: from dtor-ws.mtv.corp.google.com ([2620:15c:202:201:3adc:b08c:7acc:b325])
        by smtp.gmail.com with ESMTPSA id f6sm11857163pfg.188.2019.01.18.15.30.40
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 18 Jan 2019 15:30:41 -0800 (PST)
From:   Dmitry Torokhov <dmitry.torokhov@gmail.com>
To:     Mauro Carvalho Chehab <mchehab@kernel.org>
Cc:     Jiri Kosina <jikos@kernel.org>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org
Subject: [PATCH 2/7] [media] doc-rst: switch to new names for Full Screen/Aspect keys
Date:   Fri, 18 Jan 2019 15:30:32 -0800
Message-Id: <20190118233037.87318-2-dmitry.torokhov@gmail.com>
X-Mailer: git-send-email 2.20.1.321.g9e740568ce-goog
In-Reply-To: <20190118233037.87318-1-dmitry.torokhov@gmail.com>
References: <20190118233037.87318-1-dmitry.torokhov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

We defined better names for keys to activate full screen mode or
change aspect ratio (while keeping the existing keycodes to avoid
breaking userspace), so let's use them in the document.

Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
---
 Documentation/media/uapi/rc/rc-tables.rst | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/media/uapi/rc/rc-tables.rst b/Documentation/media/uapi/rc/rc-tables.rst
index c8ae9479f842..57797e56f45e 100644
--- a/Documentation/media/uapi/rc/rc-tables.rst
+++ b/Documentation/media/uapi/rc/rc-tables.rst
@@ -616,7 +616,7 @@ the remote via /dev/input/event devices.
 
     -  .. row 78
 
-       -  ``KEY_SCREEN``
+       -  ``KEY_ASPECT_RATIO``
 
        -  Select screen aspect ratio
 
@@ -624,7 +624,7 @@ the remote via /dev/input/event devices.
 
     -  .. row 79
 
-       -  ``KEY_ZOOM``
+       -  ``KEY_FULL_SCREEN``
 
        -  Put device into zoom/full screen mode
 
-- 
2.20.1.321.g9e740568ce-goog

