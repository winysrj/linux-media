Return-Path: <SRS0=99fO=RB=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF22BC10F0B
	for <linux-media@archiver.kernel.org>; Tue, 26 Feb 2019 17:05:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B912220C01
	for <linux-media@archiver.kernel.org>; Tue, 26 Feb 2019 17:05:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QzUzH1Kf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728647AbfBZRF7 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 26 Feb 2019 12:05:59 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:40820 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727416AbfBZRF6 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 26 Feb 2019 12:05:58 -0500
Received: by mail-wr1-f68.google.com with SMTP id q1so14808409wrp.7
        for <linux-media@vger.kernel.org>; Tue, 26 Feb 2019 09:05:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=J1x9nmxOmPvgVvYTLLB7Sji6XAxQvIs8qtgVWC75xxU=;
        b=QzUzH1KfdL9thtkkDgc2fR8QuOCWR7O9LgBiv1XKW0mFRTEn/VsKVPM85k/Vqf5sXt
         tANsaCi/PzlGNQwVbVvXiSyxcpIHcYUDCZI9TtUPPU2Lfqs7Coy0KlxJTp3PFcymNXOj
         QYuH4DqxGRT8AGaACbP9RFAqWNmmZ2piLDtYvYTA14snVYEOfg9zfJrVmupxMCjaMRQd
         hCCl7/dJuf2Z0dfv5DVTo7OGFz+lMsXY5SYa4IU9QcOefPn482q1tgg1bOFb1tNfoN57
         8yioLUo0l6RMUgsqCWWWWiFoi+B8slxfBuGYaxJJhoHCgrDutx5jCPgmioZsdwVZaNaX
         dVOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=J1x9nmxOmPvgVvYTLLB7Sji6XAxQvIs8qtgVWC75xxU=;
        b=V5HEoDDGnTj4vFy21DmB5TvmbfrKVICzCTdb2RwEMe8V1yvOeGZj53m87B3Wip5lpG
         HNvyWgx2cZeIT8wPLFogUoPTjej5Mktq539fuYJJr2Z4uEBJUTRKvaIUAamQ2/C2+Ieg
         Tc/JeAnvZ+9sVhBPWj+AI4RB90tDrXlACLOxth9RsIsE1xBRoScJRKXUMxrWDI1Hn8ho
         nPi/6SKwqtqhjkJ+4bh1zfYdb0yK4Uli6MYuuj/uvfySQRbqFABDxk9AYJrD9R7DHx+H
         oyDcxivtXbSFfD3JnDR+TRx9Z2QZPi30p656iiFpQ4FOGp69IcIN6qJPYYDqgjzXiok5
         YYHQ==
X-Gm-Message-State: AHQUAub8uWq2ZzuNFNVPHP0rrLsWdr7xvHPzFCFPO1Ut400ARUWdUHww
        nDwIBrs8Pz78STj7cAQV12zDxBaTnIk=
X-Google-Smtp-Source: AHgI3IZeXR/G22d4IJO5OnWOBM1Em7WAiFjqXumirlQv2eFIU8+HeyTgugJOodXN2jIGR5HaiQxirw==
X-Received: by 2002:a5d:6207:: with SMTP id y7mr16731847wru.60.1551200756465;
        Tue, 26 Feb 2019 09:05:56 -0800 (PST)
Received: from ubuntu.home ([77.127.107.32])
        by smtp.gmail.com with ESMTPSA id w4sm21024486wrk.85.2019.02.26.09.05.55
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 26 Feb 2019 09:05:55 -0800 (PST)
From:   Dafna Hirschfeld <dafna3@gmail.com>
To:     linux-media@vger.kernel.org
Cc:     hverkuil@xs4all.nl, helen.koike@collabora.com,
        Dafna Hirschfeld <dafna3@gmail.com>
Subject: [PATCH v5 18/21] media: vicodec: add documentation to V4L2_PIX_FMT_FWHT_STATELESS
Date:   Tue, 26 Feb 2019 09:05:11 -0800
Message-Id: <20190226170514.86127-19-dafna3@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190226170514.86127-1-dafna3@gmail.com>
References: <20190226170514.86127-1-dafna3@gmail.com>
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

add documentation to V4L2_PIX_FMT_FWHT_STATELESS
in pixfmt-compressed.rst

Signed-off-by: Dafna Hirschfeld <dafna3@gmail.com>
---
 Documentation/media/uapi/v4l/pixfmt-compressed.rst | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/Documentation/media/uapi/v4l/pixfmt-compressed.rst b/Documentation/media/uapi/v4l/pixfmt-compressed.rst
index 2675bef3eefe..6c961cfb74da 100644
--- a/Documentation/media/uapi/v4l/pixfmt-compressed.rst
+++ b/Documentation/media/uapi/v4l/pixfmt-compressed.rst
@@ -125,3 +125,9 @@ Compressed Formats
       - Video elementary stream using a codec based on the Fast Walsh Hadamard
         Transform. This codec is implemented by the vicodec ('Virtual Codec')
 	driver. See the codec-fwht.h header for more details.
+    * .. _V4L2-PIX-FMT-FWHT-STATELESS:
+
+      - ``V4L2_PIX_FMT_FWHT_STATELESS``
+      - 'SFWH'
+      - Same format as V4L2_PIX_FMT_FWHT but requires stateless codec implementation.
+	See the :ref:`associated Codec Control IDs <v4l2-mpeg-fwht>`.
-- 
2.17.1

