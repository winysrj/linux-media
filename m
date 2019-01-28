Return-Path: <SRS0=ymVG=QE=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 165E7C282CD
	for <linux-media@archiver.kernel.org>; Mon, 28 Jan 2019 17:44:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D80BB20881
	for <linux-media@archiver.kernel.org>; Mon, 28 Jan 2019 17:44:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1548697476;
	bh=GimJwDBZPDcf6I0LyCLPvuyGUj5ppxJl4VF6fyJOwPY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=1Z3XujHB7t9BrG5EwKtfXZuBMcFt970rPbxTMqp8xGOZfxMuodnSDSY7JmjgtqaYt
	 n/A+0stlXjE8olXMQUfaoztzPzngak855VYDiLIWnvSPhoIzOaV9lwToRe+UeakmLW
	 sbqB5SZVUaSNG9oh8P6G0dpadJPWej9PSDbFxr4o=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728601AbfA1Ps7 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 28 Jan 2019 10:48:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:34442 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728589AbfA1Ps4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 28 Jan 2019 10:48:56 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 393DC2147A;
        Mon, 28 Jan 2019 15:48:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1548690536;
        bh=GimJwDBZPDcf6I0LyCLPvuyGUj5ppxJl4VF6fyJOwPY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lCzCj8cqLIIYZ7sx1B02IZMvUmoJUbLHyzuHcqvcPvcYjoRRN0MeAsbv70jIfm/l3
         DplAnxUfAXE69BdsuziqbWGx06prHpn3asQj9fYh4Zmt07QXpXxmnYRRSMFyDnznqe
         4BugiQ+cUjC8R/nhi3DNgqHT5vahsBF4aNMI/NSU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alexey Khoroshilov <khoroshilov@ispras.ru>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 4.20 115/304] media: DaVinci-VPBE: fix error handling in vpbe_initialize()
Date:   Mon, 28 Jan 2019 10:40:32 -0500
Message-Id: <20190128154341.47195-115-sashal@kernel.org>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190128154341.47195-1-sashal@kernel.org>
References: <20190128154341.47195-1-sashal@kernel.org>
MIME-Version: 1.0
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

From: Alexey Khoroshilov <khoroshilov@ispras.ru>

[ Upstream commit aa35dc3c71950e3fec3e230c06c27c0fbd0067f8 ]

If vpbe_set_default_output() or vpbe_set_default_mode() fails,
vpbe_initialize() returns error code without releasing resources.

The patch adds error handling for that case.

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/davinci/vpbe.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/davinci/vpbe.c b/drivers/media/platform/davinci/vpbe.c
index 18c035ef84cf..df1ae6b5c854 100644
--- a/drivers/media/platform/davinci/vpbe.c
+++ b/drivers/media/platform/davinci/vpbe.c
@@ -740,7 +740,7 @@ static int vpbe_initialize(struct device *dev, struct vpbe_device *vpbe_dev)
 	if (ret) {
 		v4l2_err(&vpbe_dev->v4l2_dev, "Failed to set default output %s",
 			 def_output);
-		return ret;
+		goto fail_kfree_amp;
 	}
 
 	printk(KERN_NOTICE "Setting default mode to %s\n", def_mode);
@@ -748,12 +748,15 @@ static int vpbe_initialize(struct device *dev, struct vpbe_device *vpbe_dev)
 	if (ret) {
 		v4l2_err(&vpbe_dev->v4l2_dev, "Failed to set default mode %s",
 			 def_mode);
-		return ret;
+		goto fail_kfree_amp;
 	}
 	vpbe_dev->initialized = 1;
 	/* TBD handling of bootargs for default output and mode */
 	return 0;
 
+fail_kfree_amp:
+	mutex_lock(&vpbe_dev->lock);
+	kfree(vpbe_dev->amp);
 fail_kfree_encoders:
 	kfree(vpbe_dev->encoders);
 fail_dev_unregister:
-- 
2.19.1

