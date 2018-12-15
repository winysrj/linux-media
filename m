Return-Path: <SRS0=dU+R=OY=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE34AC43387
	for <linux-media@archiver.kernel.org>; Sat, 15 Dec 2018 11:52:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7CC6D2086D
	for <linux-media@archiver.kernel.org>; Sat, 15 Dec 2018 11:52:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="csNxwdCQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729192AbeLOLwW (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sat, 15 Dec 2018 06:52:22 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:42524 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729029AbeLOLwW (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 15 Dec 2018 06:52:22 -0500
Received: by mail-wr1-f68.google.com with SMTP id q18so7828192wrx.9
        for <linux-media@vger.kernel.org>; Sat, 15 Dec 2018 03:52:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=DbmgdC303OT0M84wMm0AGENqvWuZinvEg3v2HMO1gWE=;
        b=csNxwdCQ+8ORl3yjpBqjXZjhB3J9TWrgV5UT9PU2jHSUk2BwWfwOo7AmiUU/oyjWBK
         VqZ+u0W6AbZP8oHjPWwuZjkRw3K+87dKb9FdpBkLNfV+s2oioEkk50kuqVwGmuI/SLtT
         yGCpoQTtb/NQX7ZI6G/eBHnjRFcbm1wgq6tqxf7FeGtFjN/IxXqTHo0LldhDpIVR7ID2
         BlroxmtbVHMax2OEFVR4qLYk/asJxoygnCBGWLWsN8BlTpBefgVZvQgFNMLl4PsO2aCE
         zisC5sjRqLz5fCRr1AedqgM0j14Kba3jYjjKWPzkQ4Yr3Mv1GShSfxLJ5XEztuF4Ix/Q
         /Sjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=DbmgdC303OT0M84wMm0AGENqvWuZinvEg3v2HMO1gWE=;
        b=Pkf+9nDPDWXGqXsMqwtn7ETeabSHpiIlhYhrhisjUgZpLES40MqrSHKSxmCHipMrQM
         dTx0n1Rciq/yTue56dS6ImJurf2VrRfs2u3u23PNYRh2XTR91kMDYiZuJA4I1BOl3T3h
         ySs8rKeaZMPPJT0hDQQsDxiqhJHv2fg4spDKoR3YmPjvTyV1J63c7XUh2Ed2juS78/nt
         QuQisF5SDrXsrCeB8KwTgWCqzx882AHChN2c/Tsm6I4QiZFyLPxkyMfcHRj50TV4D44b
         sbUowsz+diIQ/1IZGwXyyvL598RjzKJ6N+kK2RXWzRSCm1NqFV4DXAGYgLOvbZcCxGT8
         9t7w==
X-Gm-Message-State: AA+aEWZwxx7NgDOz3M5ltW1VeoNr17F1Q6eGLm/19fZshiFubNnP8XXQ
        JXa9Veqkxmxhgo6h/y672Bu7siLngNg=
X-Google-Smtp-Source: AFSGD/VstqEEur6zX2VF0i4jIlDXGFSXVXWxQ6cSkWS58TcAP+iA28jTdcqnNPgiGmRIRmkj4oUm6w==
X-Received: by 2002:adf:9422:: with SMTP id 31mr5759435wrq.106.1544874740233;
        Sat, 15 Dec 2018 03:52:20 -0800 (PST)
Received: from localhost.localdomain ([77.124.106.231])
        by smtp.gmail.com with ESMTPSA id c13sm10822082wrb.38.2018.12.15.03.52.18
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 15 Dec 2018 03:52:19 -0800 (PST)
From:   Dafna Hirschfeld <dafna3@gmail.com>
To:     linux-media@vger.kernel.org
Cc:     hverkuil@xs4all.nl, helen.koike@collabora.com,
        Dafna Hirschfeld <dafna3@gmail.com>
Subject: [PATCH] media: vicodec: bugfix - replace '=' with '|='
Date:   Sat, 15 Dec 2018 03:51:19 -0800
Message-Id: <20181215115119.2732-1-dafna3@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

In the function fwht_encode_frame, 'encoding = encode_plane'
should be replaced with 'encoding |= encode_plane'
so existing flags won't be overwrriten.

Signed-off-by: Dafna Hirschfeld <dafna3@gmail.com>
---
 drivers/media/platform/vicodec/codec-fwht.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/vicodec/codec-fwht.c b/drivers/media/platform/vicodec/codec-fwht.c
index 5630f1dc45e6..a678a716580c 100644
--- a/drivers/media/platform/vicodec/codec-fwht.c
+++ b/drivers/media/platform/vicodec/codec-fwht.c
@@ -787,7 +787,7 @@ u32 fwht_encode_frame(struct fwht_raw_frame *frm,
 
 	if (frm->components_num == 4) {
 		rlco_max = rlco + size / 2 - 256;
-		encoding = encode_plane(frm->alpha, ref_frm->alpha, &rlco,
+		encoding |= encode_plane(frm->alpha, ref_frm->alpha, &rlco,
 					rlco_max, cf, frm->height, frm->width,
 					frm->luma_alpha_step,
 					is_intra, next_is_intra);
-- 
2.17.1

