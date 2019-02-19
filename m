Return-Path: <SRS0=RQn6=Q2=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE249C43381
	for <linux-media@archiver.kernel.org>; Tue, 19 Feb 2019 13:24:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9F0DC21736
	for <linux-media@archiver.kernel.org>; Tue, 19 Feb 2019 13:24:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1550582698;
	bh=TCHvbINNNzWNG/J5wu/KomwcIOmOSfQ8fDx9d8qdHjA=;
	h=From:Cc:Subject:Date:In-Reply-To:References:To:List-ID:From;
	b=KfP9MbPDLeolKtG6s1uCxe4uWNl21PlxuD/ZSxS/n1wwvI54Pp4nmKGSLcFdeU2u2
	 pEMkGyakO56amKLpF5W5uLrNA6goDXmGc6+Tu5L4Y+ortH59QsGH5Ptb7Dj6piewRs
	 kAsfGbRiDxyvKh26DtrDejyCXI4PV9ZTqnq+9ID4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727529AbfBSNY5 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 19 Feb 2019 08:24:57 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:49184 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728630AbfBSNY4 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 19 Feb 2019 08:24:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=xLyc0G5IaKS96Akucq00qcfns0vn3r1wLQhrkAQg2O0=; b=ForfPBL5/D3SGaBuEiKGBYmk2H
        D9pioilA8QllFS1BWf2tQGEzJvNmQAgYDCAU0kaPZH7ty6iE7jUcVkBS+Rk4ncGrQuBMH6vq0rZ7g
        L70DoRJJ5YE21ZaSiT0hKaD0d38TwGCRixWJhOB6u+d21njGuFwypL1xAlWLII1bMNgAorxLB5F1/
        JweYITzTpgHviVmebFxBKNrEGjrsVB9SoVSyXJ9CNps1MrQ8Bir9nx1FmWh4I/l5WpfzTKBazux/B
        rGZESr2ijLkl5QySirhEq5p05FfLl/+aI9Bbi7cOpMCG8o7YmJghe6O2mqQ+23PQ0js1/F8ps5sD6
        VLDzpYBw==;
Received: from 177.96.194.24.dynamic.adsl.gvt.net.br ([177.96.194.24] helo=bombadil.infradead.org)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1gw5OJ-0005BJ-Tu; Tue, 19 Feb 2019 13:24:55 +0000
Received: from mchehab by bombadil.infradead.org with local (Exim 4.91)
        (envelope-from <mchehab@bombadil.infradead.org>)
        id 1gw5OH-0001Id-BP; Tue, 19 Feb 2019 08:24:53 -0500
From:   Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Rui Miguel Silva <rmfrfs@gmail.com>,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org
Subject: [PATCH 2/2] media: imx7-media-csi: get rid of unused var
Date:   Tue, 19 Feb 2019 08:24:52 -0500
Message-Id: <91937229883824924f1a06ded49dfded4ca96d43.1550582690.git.mchehab+samsung@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <1c186d5fd734e63305352986b6c5e84d19375787.1550582690.git.mchehab+samsung@kernel.org>
References: <1c186d5fd734e63305352986b6c5e84d19375787.1550582690.git.mchehab+samsung@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

	drivers/staging/media/imx/imx7-media-csi.c: In function 'imx7_csi_enum_mbus_code':
	drivers/staging/media/imx/imx7-media-csi.c:926:33: warning: variable 'in_cc' set but not used [-Wunused-but-set-variable]
	  const struct imx_media_pixfmt *in_cc;
	                                 ^~~~~

Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
---
 drivers/staging/media/imx/imx7-media-csi.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/staging/media/imx/imx7-media-csi.c b/drivers/staging/media/imx/imx7-media-csi.c
index 0b1788d79ce9..3fba7c27c0ec 100644
--- a/drivers/staging/media/imx/imx7-media-csi.c
+++ b/drivers/staging/media/imx/imx7-media-csi.c
@@ -923,7 +923,6 @@ static int imx7_csi_enum_mbus_code(struct v4l2_subdev *sd,
 				   struct v4l2_subdev_mbus_code_enum *code)
 {
 	struct imx7_csi *csi = v4l2_get_subdevdata(sd);
-	const struct imx_media_pixfmt *in_cc;
 	struct v4l2_mbus_framefmt *in_fmt;
 	int ret = 0;
 
@@ -931,8 +930,6 @@ static int imx7_csi_enum_mbus_code(struct v4l2_subdev *sd,
 
 	in_fmt = imx7_csi_get_format(csi, cfg, IMX7_CSI_PAD_SINK, code->which);
 
-	in_cc = imx_media_find_mbus_format(in_fmt->code, CS_SEL_ANY, true);
-
 	switch (code->pad) {
 	case IMX7_CSI_PAD_SINK:
 		ret = imx_media_enum_mbus_format(&code->code, code->index,
-- 
2.20.1

