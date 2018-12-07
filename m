Return-Path: <SRS0=1NWX=OQ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	T_DKIMWL_WL_HIGH,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D411C07E85
	for <linux-media@archiver.kernel.org>; Fri,  7 Dec 2018 13:08:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D78342146D
	for <linux-media@archiver.kernel.org>; Fri,  7 Dec 2018 13:08:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1544188082;
	bh=teKibmCOp43dnaTiZ26gaqj/Zo8KsXNNTSNQBTabv/s=;
	h=From:Cc:Subject:Date:To:List-ID:From;
	b=mgfAeLkWGeu8tmNWMwZ35f5fok7GL97A65X7NVyN0I8E97gsgdMTbqLhgn1HSGGmt
	 TZkgZHna/GydPWh7CasSuGUyIeaWpjT24EBHLm96o0kct3olH0P2lqsnAVlQPQiaWX
	 7f1xHUlqG+/KB54Fj7hknbSnhPZ9IKQ42IGFcClI=
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D78342146D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726287AbeLGNIA (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 7 Dec 2018 08:08:00 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:33330 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726285AbeLGNIA (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 7 Dec 2018 08:08:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Reply-To:Content-Type:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=S4D309UtMR+Ifs2BnnxBWbxL9F/zRbU2P6RZrdAxbwU=; b=rFJj+GA0YRRpLVUQDE3PW+qpI
        B5HW/UIe9R072Y8jDKaymBWB2r3YiGFaaEadCGZouYov8lmXM2B77kCCV81zl8FivqeNGZ/6EoQal
        SylEXFBgpQd10mOvnTqwblsQi7JMaiLvv+bfYxLX+CFIbHOef1b3tb/fmiOCIVi1HdEyc37F8Ami5
        WhoQAkV6IEa24zBsMr8mq8fTgeBw9nUNXEU5kCdRKxlSb7rzC+k+QMSPMBUqgGMLVh2dtp9mrRQpU
        qK2nS6onp19lDIiwitciHGE6Ap8xPxj7vW/MsN4cAwfwfh7iFlR7Czj+5aoGQLaMUVSd6EvnfLRUa
        2eMQXMkAw==;
Received: from [179.95.33.236] (helo=bombadil.infradead.org)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1gVFrK-000335-Qo; Fri, 07 Dec 2018 13:07:58 +0000
Received: from mchehab by bombadil.infradead.org with local (Exim 4.91)
        (envelope-from <mchehab@bombadil.infradead.org>)
        id 1gVFrI-0004Pk-74; Fri, 07 Dec 2018 08:07:56 -0500
From:   Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Akinobu Mita <akinobu.mita@gmail.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Robert Jarzmik <robert.jarzmik@free.fr>
Subject: [PATCH 1/2] media: pxa_camera: don't deferenciate a NULL pointer
Date:   Fri,  7 Dec 2018 08:07:54 -0500
Message-Id: <aa54ca91f2310ecea413daa289ab882cf9f37245.1544188058.git.mchehab+samsung@kernel.org>
X-Mailer: git-send-email 2.19.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

As warned by smatch:
	drivers/media/platform/pxa_camera.c:2400 pxa_camera_probe() error: we previously assumed 'pcdev->pdata' could be null (see line 2397)

It would be possible that neither DT nor platform data would be
provided. This is a Kernel bug, so warn about that and bail.

Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
---
 drivers/media/platform/pxa_camera.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/media/platform/pxa_camera.c b/drivers/media/platform/pxa_camera.c
index 5f930560eb30..f91f8fd424c4 100644
--- a/drivers/media/platform/pxa_camera.c
+++ b/drivers/media/platform/pxa_camera.c
@@ -2396,6 +2396,9 @@ static int pxa_camera_probe(struct platform_device *pdev)
 	pcdev->pdata = pdev->dev.platform_data;
 	if (pdev->dev.of_node && !pcdev->pdata) {
 		err = pxa_camera_pdata_from_dt(&pdev->dev, pcdev, &pcdev->asd);
+	} else if (!pcdev->pdata) {
+		WARN_ON(1);
+		return -ENODEV;
 	} else {
 		pcdev->platform_flags = pcdev->pdata->flags;
 		pcdev->mclk = pcdev->pdata->mclk_10khz * 10000;
-- 
2.19.2

