Return-Path: <SRS0=tcVs=Q6=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7DE9C43381
	for <linux-media@archiver.kernel.org>; Sat, 23 Feb 2019 00:17:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 782D620700
	for <linux-media@archiver.kernel.org>; Sat, 23 Feb 2019 00:17:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1550881036;
	bh=ce8yEH12ufAnMxjpcBfLb4aRGnc/dJA5vSDD9LGcV0A=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=JGzarseFN37HizdFwJeXhai7V3BHQstVTTrB28eB15nIYKG7OCcaZ44qtirZVAvgj
	 Rx2m924RDZ8W4QxBfK8fsrvcj7CBzDAK+QbTLyC5thvm+wv8E0Z5Mu/CXVYlQaVShj
	 1GIzE1qjRESKJe3/9SVqVy/ygK8lc1zlXQW45OeU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727254AbfBWARL (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 22 Feb 2019 19:17:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:33234 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725811AbfBWARL (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 22 Feb 2019 19:17:11 -0500
Received: from shuah-t480s.internal (c-24-9-64-241.hsd1.co.comcast.net [24.9.64.241])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 87093206B6;
        Sat, 23 Feb 2019 00:17:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1550881030;
        bh=ce8yEH12ufAnMxjpcBfLb4aRGnc/dJA5vSDD9LGcV0A=;
        h=From:To:Cc:Subject:Date:From;
        b=LyWswE3ZpOCO0sX/KUo0XZME7B6Otbu0dXf20u6HY5brahP/6umaUhLEvL1laLYSr
         Ixe0w7vPdpUk2s0D0WNTobNA3Y5QLFPK8UX791LWWBzLnEmtkhjOILdFEGCtV2sMTu
         gzMPVRZrUSereCeuHjS1Lt8VtW8aRZrUyLdK+gVY=
From:   Shuah Khan <shuah@kernel.org>
To:     mchehab@kernel.org
Cc:     Shuah Khan <shuah@kernel.org>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] media: replace WARN_ON in __media_pipeline_start()
Date:   Fri, 22 Feb 2019 17:17:09 -0700
Message-Id: <20190223001709.21486-1-shuah@kernel.org>
X-Mailer: git-send-email 2.19.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

__media_pipeline_start() does WARN_ON() when active pipe doesn't
match the input arg entity's pipe.

Replace WARN_ON with a conditional and error message that includes
names of both entities.

Signed-off-by: Shuah Khan <shuah@kernel.org>
---
 drivers/media/media-entity.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
index 0b1cb3559140..757c641b7409 100644
--- a/drivers/media/media-entity.c
+++ b/drivers/media/media-entity.c
@@ -436,7 +436,10 @@ __must_check int __media_pipeline_start(struct media_entity *entity,
 
 		entity->stream_count++;
 
-		if (WARN_ON(entity->pipe && entity->pipe != pipe)) {
+		if (entity->pipe && entity->pipe != pipe) {
+			pr_err("Pipe active for %s. Can't start for %s\n",
+				entity->name,
+				entity_err->name);
 			ret = -EBUSY;
 			goto error;
 		}
-- 
2.17.1

