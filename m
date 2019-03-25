Return-Path: <SRS0=dbhF=R4=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61515C43381
	for <linux-media@archiver.kernel.org>; Mon, 25 Mar 2019 22:03:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 32E3920857
	for <linux-media@archiver.kernel.org>; Mon, 25 Mar 2019 22:03:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1553551425;
	bh=+GPqgvndcKe29NOOKlw1ZLd/qmeExxVHalIDi3XNkDk=;
	h=From:Cc:Subject:Date:In-Reply-To:References:To:List-ID:From;
	b=JVP6oUvQsDdZ8YgYl2TYsNsfofc4p8SYhBZERW9dq/cloLCwZmnb5HmgecHVlZCQd
	 Nig44JaQMpAQBAcyxKNr5nmeB5hjTh2QIjCNHAy7hTUk6vYIJWUGXvBeN+yCHuXSa5
	 MUOp8CS06Y/ZHiFhEV3P6i1Fx7u2bUGTqSFY5B6g=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730616AbfCYWDo (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 25 Mar 2019 18:03:44 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:54914 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730006AbfCYWDm (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 25 Mar 2019 18:03:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=JMuLDl4OtgdYsBvKKL7DpQ6Euc4wIOaih+OS0AYRBto=; b=SB3YPrzVGnrNVTIe84RRkTwENh
        eZHhemB7AGSaNRL6v1jijNWfSQmnMisi1o8Tp/X68rfogNUyJt7N9+hOD/qMD2VBTnCdJ2AXpS5gL
        f6YKMz7vmJgmZMi0gXbWNKI8aSTwQ1XzTAvI+Z5i+akPccM0LxBHskjoGgSExuSQVr5THzODB2L5f
        ogH3zxGdCrmQGWO4aUYTn6tH+OBWrfbU1aGsEBg4OQdFKKPZv7EAPwQu2LL5dG49udPPvHnae7Ca3
        cxJMg5l+xTpMVWj2cbn19IYMuKQkZKhO8/WmhqMqv6vaWxjdA1KAhQokbcIh1xyakNoJf/UtOFUMB
        mJXjC0IA==;
Received: from 177.41.113.24.dynamic.adsl.gvt.net.br ([177.41.113.24] helo=bombadil.infradead.org)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1h8Xh0-0001YD-E0; Mon, 25 Mar 2019 22:03:42 +0000
Received: from mchehab by bombadil.infradead.org with local (Exim 4.92)
        (envelope-from <mchehab@bombadil.infradead.org>)
        id 1h8Xgw-0001al-Hq; Mon, 25 Mar 2019 18:03:38 -0400
From:   Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 2/5] media: pwc-ctl: pChoose can't be NULL
Date:   Mon, 25 Mar 2019 18:03:34 -0400
Message-Id: <4f777d011bdd9e78fcf02701e89c8be457504a6c.1553551369.git.mchehab+samsung@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <cover.1553551369.git.mchehab+samsung@kernel.org>
References: <cover.1553551369.git.mchehab+samsung@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

The way the code works, compression will be a valid value (less or equal to 3)
on both set_video_mode_foo() calls at the beginning of the while() loop.

So, the value for pChoose can't be NULL.

Solves those smatch warnings:

	drivers/media/usb/pwc/pwc-ctrl.c: drivers/media/usb/pwc/pwc-ctrl.c:252 set_video_mode_Timon() warn: variable dereferenced before check 'pChoose' (see line 248)
	drivers/media/usb/pwc/pwc-ctrl.c: drivers/media/usb/pwc/pwc-ctrl.c:302 set_video_mode_Kiara() warn: variable dereferenced before check 'pChoose' (see line 298)

and simplifies the code a little bit.

Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
---
 drivers/media/usb/pwc/pwc-ctrl.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/media/usb/pwc/pwc-ctrl.c b/drivers/media/usb/pwc/pwc-ctrl.c
index 655cef39eb3d..b681a184ef87 100644
--- a/drivers/media/usb/pwc/pwc-ctrl.c
+++ b/drivers/media/usb/pwc/pwc-ctrl.c
@@ -242,14 +242,14 @@ static int set_video_mode_Timon(struct pwc_device *pdev, int size, int pixfmt,
 	fps = (frames / 5) - 1;
 
 	/* Find a supported framerate with progressively higher compression */
-	pChoose = NULL;
-	while (*compression <= 3) {
+	do {
 		pChoose = &Timon_table[size][fps][*compression];
 		if (pChoose->alternate != 0)
 			break;
 		(*compression)++;
-	}
-	if (pChoose == NULL || pChoose->alternate == 0)
+	} while (*compression <= 3);
+
+	if (pChoose->alternate == 0)
 		return -ENOENT; /* Not supported. */
 
 	if (send_to_cam)
@@ -279,7 +279,7 @@ static int set_video_mode_Timon(struct pwc_device *pdev, int size, int pixfmt,
 static int set_video_mode_Kiara(struct pwc_device *pdev, int size, int pixfmt,
 				int frames, int *compression, int send_to_cam)
 {
-	const struct Kiara_table_entry *pChoose = NULL;
+	const struct Kiara_table_entry *pChoose;
 	int fps, ret = 0;
 
 	if (size >= PSZ_MAX || *compression < 0 || *compression > 3)
@@ -293,13 +293,14 @@ static int set_video_mode_Kiara(struct pwc_device *pdev, int size, int pixfmt,
 	fps = (frames / 5) - 1;
 
 	/* Find a supported framerate with progressively higher compression */
-	while (*compression <= 3) {
+	do {
 		pChoose = &Kiara_table[size][fps][*compression];
 		if (pChoose->alternate != 0)
 			break;
 		(*compression)++;
-	}
-	if (pChoose == NULL || pChoose->alternate == 0)
+	} while (*compression <= 3);
+
+	if (pChoose->alternate == 0)
 		return -ENOENT; /* Not supported. */
 
 	/* Firmware bug: video endpoint is 5, but commands are sent to endpoint 4 */
-- 
2.20.1

