Return-Path: <SRS0=Cp5C=P2=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9A9CC61CE3
	for <linux-media@archiver.kernel.org>; Fri, 18 Jan 2019 23:31:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7770120823
	for <linux-media@archiver.kernel.org>; Fri, 18 Jan 2019 23:31:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WZHXE0YF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730167AbfARXam (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 18 Jan 2019 18:30:42 -0500
Received: from mail-pg1-f193.google.com ([209.85.215.193]:38807 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729842AbfARXam (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 18 Jan 2019 18:30:42 -0500
Received: by mail-pg1-f193.google.com with SMTP id g189so6753169pgc.5;
        Fri, 18 Jan 2019 15:30:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=kNUf+iB/LoK2OdmSM9fbNdTqLzr17MC+P0LbuoGYOrI=;
        b=WZHXE0YFfXV5zDSuK4FfeEGDlRf5P7cjbnqBHEiNsKXSxuB7aohCDLJYX+743V2qkC
         swY79GOejVcsH+LZwNsJnON3pKxbChQA+SQ73a7UH5fZAQboITfCNZ5w4CZHv1XrFSAH
         Qpg1wlbUBcrJij0lpyGKedLcird1NXhr/8D+4RrVUUd6uS1qzrBLZwvMSVug03I7dv0y
         ZeM+2kDBTlpExs2hwEH5VJ0dmCJaWrj8UsF2cvvIgusmMV0mm9RkRtJ5ZSwWufv3HJ/e
         6ed53Sw1dj9ouhHKEkFC7WJny6Q76a14FJ3ezlimyEAhZNPTT7rUBSoqryXBWmDAmDkc
         wGgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=kNUf+iB/LoK2OdmSM9fbNdTqLzr17MC+P0LbuoGYOrI=;
        b=fgV0NupRm0J72SUgjpFS1uCNgMv/QfB/fkXlE4bn3mSmKcQdMFFiw02TXZXKnQmGZy
         EK2w04kmPAM+2Fym3jOO66dTKb5eJbSA2y1W1HfzoyzjBYjkVJGU0cXqL3tyEbX2Cmsb
         ayNGmMmHtI4s+iBCL4sk1PpZLpiGPpvWscOPOfo/z1HZbjmfz2ZurvWCYK4DqVQmABmq
         sOd0FryzlW7f6UPoCk1Hi54g7o6G4lv59imf0xTpFbctTfy6gIEWeRpGq8mK6MGAy0u6
         W9/NkzRf3RPMYtpHwXy5B6C8HZhZjJga+e+KS1QSunmjFf94PdR7q3lYqjLYDuwVQrI2
         LdRw==
X-Gm-Message-State: AJcUukdGPBInzQE3LyueQkJova1TiVVEmbD2j8hiHAaDA2YpFF9esLUp
        SczrZ+AvDZlI+yb/ZvGq6zY=
X-Google-Smtp-Source: ALg8bN565phsMfeWZ0mzQWQ/sKuk3Yy/nU8e/MFubEzfkAUeIoeFiHxxUK+oS8spJvZaZP3rNr+6oQ==
X-Received: by 2002:a63:334a:: with SMTP id z71mr19807787pgz.400.1547854240660;
        Fri, 18 Jan 2019 15:30:40 -0800 (PST)
Received: from dtor-ws.mtv.corp.google.com ([2620:15c:202:201:3adc:b08c:7acc:b325])
        by smtp.gmail.com with ESMTPSA id f6sm11857163pfg.188.2019.01.18.15.30.39
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 18 Jan 2019 15:30:40 -0800 (PST)
From:   Dmitry Torokhov <dmitry.torokhov@gmail.com>
To:     Jiri Kosina <jikos@kernel.org>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>
Cc:     Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org
Subject: [PATCH 1/7] Input: document meanings of KEY_SCREEN and KEY_ZOOM
Date:   Fri, 18 Jan 2019 15:30:31 -0800
Message-Id: <20190118233037.87318-1-dmitry.torokhov@gmail.com>
X-Mailer: git-send-email 2.20.1.321.g9e740568ce-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

It is hard to say what KEY_SCREEN and KEY_ZOOM mean, but historically DVB
folks have used them to indicate switch to full screen mode. Later, they
converged on using KEY_ZOOM to switch into full screen mode and KEY)SCREEN
to control aspect ratio (see Documentation/media/uapi/rc/rc-tables.rst).

Let's commit to these uses, and define:

- KEY_FULL_SCREEN (and make KEY_ZOOM its alias)
- KEY_ASPECT_RATIO (and make KEY_SCREEN its alias)

Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
---

Please let me know how we want merge this. Some of patches can be applied
independently and I tried marking them as such, but some require new key
names from input.h

 include/uapi/linux/input-event-codes.h | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/input-event-codes.h b/include/uapi/linux/input-event-codes.h
index ae366b87426a..bc5054e51bef 100644
--- a/include/uapi/linux/input-event-codes.h
+++ b/include/uapi/linux/input-event-codes.h
@@ -439,10 +439,12 @@
 #define KEY_TITLE		0x171
 #define KEY_SUBTITLE		0x172
 #define KEY_ANGLE		0x173
-#define KEY_ZOOM		0x174
+#define KEY_FULL_SCREEN		0x174	/* AC View Toggle */
+#define KEY_ZOOM		KEY_FULL_SCREEN
 #define KEY_MODE		0x175
 #define KEY_KEYBOARD		0x176
-#define KEY_SCREEN		0x177
+#define KEY_ASPECT_RATIO	0x177	/* HUTRR37: Aspect */
+#define KEY_SCREEN		KEY_ASPECT_RATIO
 #define KEY_PC			0x178	/* Media Select Computer */
 #define KEY_TV			0x179	/* Media Select TV */
 #define KEY_TV2			0x17a	/* Media Select Cable */
-- 
2.20.1.321.g9e740568ce-goog

