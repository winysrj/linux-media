Return-Path: <SRS0=KeAI=PK=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3140C43387
	for <linux-media@archiver.kernel.org>; Wed,  2 Jan 2019 16:04:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8404C218A4
	for <linux-media@archiver.kernel.org>; Wed,  2 Jan 2019 16:04:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fv35KvAp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730104AbfABQEM (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 2 Jan 2019 11:04:12 -0500
Received: from mail-ed1-f65.google.com ([209.85.208.65]:38763 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729748AbfABQEL (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 2 Jan 2019 11:04:11 -0500
Received: by mail-ed1-f65.google.com with SMTP id h50so26605760ede.5
        for <linux-media@vger.kernel.org>; Wed, 02 Jan 2019 08:04:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=pPjeukSh+TRKXoj/0X/oUWs3R6ZLikejzxWh67ky9XQ=;
        b=fv35KvApSc/NMdrvdKawa+O98zI6cqZwi3cMlWIcFpzD91LWJfExbE90jnTp/Iqqqs
         LaG9jO2uvdIHW9uoinpNt+icVvtrDFwPCNt+dd6/tTyL7A5OwIlvgSyAy09ADpax4FkK
         NaQb/Gd5L7Ivon19BqFkPAEzxKPnWmDQe5mNbTGKTyArAY7MgGFPHuAAbdIDsLNTUnIg
         ZwNsmMbSkhEoEvkCInIzHDLPKI/W4AEJtI3gkHhq8PFqSNqNVQySS5Vht5VEmv6A1yWn
         ywve5688SCw6mJWu0j7WWlaycBUVrPgCs9FYpWrtS4Eyby8fgJfiONHkpzb38P6p2SI3
         gQoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=pPjeukSh+TRKXoj/0X/oUWs3R6ZLikejzxWh67ky9XQ=;
        b=ovjWswaUdDCnce49A2B3Ymw7p5dWE/gf7V75weiEvYKuLF8vR1RMiNo+OyEperFAXC
         wlqusKpE64qBJf+f0Sjz0jT4qb8OtBQ1AR9g0nAeXGHNfG0H8jjelPi/emorvINr+TZT
         EGEAgkgC6uzmwbhaNP+OhVU9sVNKOTRfj053ZfAfHOtXn28JizkJACLHS26K70M6TnxO
         SA4DU5UyTLxArtnYcKCSXEFlnbvlyOLVPohWSwicLJ5LAuvEnAWZyZCCgnZsFGMuD66a
         WGSVIgqxcbL+NapaZPQn15H28vAvwNilaAjmsBT/MJ+CoAPSrz0DtSN1e1y/SP35ZxJ3
         MaQg==
X-Gm-Message-State: AJcUukdtz3LLvoeYJkD/Ew5rcKsOWtZlH2k6oSzhREyp13S1pdsETXB5
        YcsdN1ChuWcO10JZBwnmBdwBZFZL
X-Google-Smtp-Source: ALg8bN6E89V8tYGW1i//xr9P2C3gpWF7iNZV4UmqQvlEXjo/86Y0k8irqorrnxwJzUbTBitxoc+adA==
X-Received: by 2002:a17:906:1189:: with SMTP id n9-v6mr3239306eja.2.1546445049413;
        Wed, 02 Jan 2019 08:04:09 -0800 (PST)
Received: from localhost.localdomain (195.145.107.92.dynamic.wline.res.cust.swisscom.ch. [92.107.145.195])
        by smtp.gmail.com with ESMTPSA id l18sm21291593edq.87.2019.01.02.08.04.08
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 02 Jan 2019 08:04:08 -0800 (PST)
From:   =?UTF-8?q?Andr=C3=A9=20Roth?= <neolynx@gmail.com>
To:     linux-media@vger.kernel.org
Cc:     abassetta@tiscali.it,
        =?UTF-8?q?Andr=C3=A9=20Roth?= <neolynx@gmail.com>
Subject: [PATCH 3/3] libdvbv5: fix array size in desc_logical_channel
Date:   Wed,  2 Jan 2019 17:03:14 +0100
Message-Id: <20190102160314.7451-3-neolynx@gmail.com>
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

This fixes the descriptor paring on 64bit systems.
Thanks to abassetta@tiscali.it for finding and patching.

Signed-off-by: André Roth <neolynx@gmail.com>
---
 lib/libdvbv5/descriptors/desc_logical_channel.c | 4 ++--
 lib/libdvbv5/dvb-file.c                         | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/lib/libdvbv5/descriptors/desc_logical_channel.c b/lib/libdvbv5/descriptors/desc_logical_channel.c
index 7ae4d59a..1a8dc658 100644
--- a/lib/libdvbv5/descriptors/desc_logical_channel.c
+++ b/lib/libdvbv5/descriptors/desc_logical_channel.c
@@ -40,7 +40,7 @@ int dvb_desc_logical_channel_init(struct dvb_v5_fe_parms *parms,
 
 	memcpy(d->lcn, p, d->length);
 
-	len = d->length / sizeof(d->lcn);
+	len = d->length / 4;
 
 	for (i = 0; i < len; i++) {
 		bswap16(d->lcn[i].service_id);
@@ -55,7 +55,7 @@ void dvb_desc_logical_channel_print(struct dvb_v5_fe_parms *parms, const struct
 	int i;
 	size_t len;
 
-	len = d->length / sizeof(d->lcn);
+	len = d->length / 4;
 
 	for (i = 0; i < len; i++) {
 		dvb_loginfo("|           service ID[%d]     %d", i, d->lcn[i].service_id);
diff --git a/lib/libdvbv5/dvb-file.c b/lib/libdvbv5/dvb-file.c
index ffdfe292..d077271a 100644
--- a/lib/libdvbv5/dvb-file.c
+++ b/lib/libdvbv5/dvb-file.c
@@ -987,7 +987,7 @@ static char *dvb_vchannel(struct dvb_v5_fe_parms_priv *parms,
 		size_t len;
 		int r;
 
-		len = d->length / sizeof(d->lcn);
+		len = d->length / 4;
 		for (i = 0; i < len; i++) {
 			if (service_id == d->lcn[i].service_id) {
 				r = asprintf(&buf, "%d.%d",
-- 
2.17.1

