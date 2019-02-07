Return-Path: <SRS0=EeSY=QP=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9E3AC282C4
	for <linux-media@archiver.kernel.org>; Fri,  8 Feb 2019 00:00:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9A35421907
	for <linux-media@archiver.kernel.org>; Fri,  8 Feb 2019 00:00:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GtwkA+xQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726788AbfBGX7y (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 7 Feb 2019 18:59:54 -0500
Received: from mail-qk1-f195.google.com ([209.85.222.195]:46135 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726622AbfBGX7y (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 7 Feb 2019 18:59:54 -0500
Received: by mail-qk1-f195.google.com with SMTP id q1so1078593qkf.13;
        Thu, 07 Feb 2019 15:59:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=QIQy8UA2s3N6eKseWTIkLkpwPJxb2oawnJMhaA2ueEk=;
        b=GtwkA+xQaymPlGV1dsBU1zjqynglrY1SJROabYWuZ9gwNVZ1dXU+y5L62Ex7RPh4zD
         mlOxK8GzpOoAXyNTzXyY1sqTLgPa5a9zoqHGdLVj2B9cmHymY+0R3vq6faZPXE0fTmEM
         Cn8t/dOnV+kchD+oDrL9WOI6iibC+akXhuGupxvwG6jUx8uLTIpwbvMznwiwojWwmSs8
         fttiVIIfHg93kl5Dmjs/bcDBI4VOWEY1D4U70gfE3ThUasaHAIYPfAOocVvroDdi8sFP
         FA17IvR1jw9Ma1n+3aS43wC+XlmSmLlN4KTZVXoqjkHA9ko7QYq+uWMAs58Z0Rr/4kav
         V89g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=QIQy8UA2s3N6eKseWTIkLkpwPJxb2oawnJMhaA2ueEk=;
        b=cD9rlj2Uu+G2CAZdJOKHSP7ospZDLYRP2dHXg8fF+EDlx9S0yyZv26ToLIb0TLPsjZ
         x5bwmtylmU3FIyd1/fSKTJg26QlmvcUT4t63f1BEsp/OcTGSZ6agOcdjmxNc/OPC5Pox
         c7et90uQ9mg1F41dT7c5ojbKuRpi+PAPEtJVyvSof+jqo5XsDfS7cicbuzwyQC/UO7d+
         8hH/ojsNV5hqss11ZD8Z8jiFTxZLHw7KzTDu2LwgqZlmMcww+IjgiWH7EAJ6adj35x/K
         IvR5o7etVO7WgDT7CFMYrsHZ2pkiqm+dOG05dK4KGaDr8Ef5MetgxfTQsN9dtZ7mpC+d
         mMLg==
X-Gm-Message-State: AHQUAuaOIQATBNFS6R58enjOBim1Hq0kjLpPU94EuBcAP+4EEqM9IIzu
        uyX761iOuCRomGj42298YpmN3hvD3GFZnA==
X-Google-Smtp-Source: AHgI3IZF7Ku0pjH9dhIo25ezlhzqeWurBApmNzt5aRGWR1Mkf+xLNBELNkUvL5FfKLimxbWFd2a3Yg==
X-Received: by 2002:a37:7442:: with SMTP id p63mr13688599qkc.320.1549583993144;
        Thu, 07 Feb 2019 15:59:53 -0800 (PST)
Received: from localhost.localdomain ([177.194.44.253])
        by smtp.gmail.com with ESMTPSA id f36sm303310qtb.67.2019.02.07.15.59.49
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 07 Feb 2019 15:59:52 -0800 (PST)
From:   "Lucas A. M. Magalhaes" <lucmaga@gmail.com>
To:     linux-media@vger.kernel.org
Cc:     helen.koike@collabora.com, hverkuil@xs4all.nl, mchehab@kernel.org,
        lkcamp@lists.libreplanetbr.org, linux-kernel@vger.kernel.org,
        "Lucas A. M. Magalhaes" <lucmaga@gmail.com>
Subject: [PATCH] media: vimc: Remove unused but set variables
Date:   Thu,  7 Feb 2019 21:59:41 -0200
Message-Id: <20190207235941.6600-1-lucmaga@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Remove unused but set variables to clean up the code and avoid
warning.

Signed-off-by: Lucas A. M. Magalhães <lucmaga@gmail.com>
---
 drivers/media/platform/vimc/vimc-sensor.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/drivers/media/platform/vimc/vimc-sensor.c b/drivers/media/platform/vimc/vimc-sensor.c
index 93961a1e694f..59195f262623 100644
--- a/drivers/media/platform/vimc/vimc-sensor.c
+++ b/drivers/media/platform/vimc/vimc-sensor.c
@@ -204,13 +204,6 @@ static void *vimc_sen_process_frame(struct vimc_ent_device *ved,
 {
 	struct vimc_sen_device *vsen = container_of(ved, struct vimc_sen_device,
 						    ved);
-	const struct vimc_pix_map *vpix;
-	unsigned int frame_size;
-
-	/* Calculate the frame size */
-	vpix = vimc_pix_map_by_code(vsen->mbus_format.code);
-	frame_size = vsen->mbus_format.width * vpix->bpp *
-		     vsen->mbus_format.height;
 
 	tpg_fill_plane_buffer(&vsen->tpg, 0, 0, vsen->frame);
 	return vsen->frame;
-- 
2.20.1

