Return-Path: <SRS0=OvUS=QF=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43874C169C4
	for <linux-media@archiver.kernel.org>; Tue, 29 Jan 2019 16:00:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0E1F52175B
	for <linux-media@archiver.kernel.org>; Tue, 29 Jan 2019 16:00:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1548777628;
	bh=whcTyKO4npM458/zSACzcckWbBsQax9UQ1N4VzrHR2E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=mXiRkS6W6X7eEk298mpQujv9suoAzqFCkMO4FpU/ah6zqkhDy+e6Y6gYIWB4f7qJB
	 26wdguq/fWIBcHTTxytx37DgKib7bQePdLW0aXx8r+lbnTqAaCevo8c9k0vjiQzbiv
	 QzJ/xhr1DNsKb8rnkNAO9wtKUmb3/2wycUghC1+o=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726913AbfA2QA1 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 29 Jan 2019 11:00:27 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:53870 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726298AbfA2QA1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 29 Jan 2019 11:00:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=696h5dEItVGLUJjaWq/e86n6ScvucQYWrO9+DOhIgmw=; b=vAQFGp39Y4Ae3EfkJi9/Id6Ofz
        9Zj2GEXrFsrnM87XC4m/PFwVwjF4M/BoToij5Ms2QOahnleguXc43aq1ojHSTktyikTbgVF4Z21ON
        HwFG5aw/XPPvI1/9FNwB5s2FVoQzRAEBvmsnFD6md2s2szvD0ub3ZBXRs3peoBmah3FPd38lsZ/In
        L8fBmbC0NZaztz69fYtBQj7TfBx7RoZrfExDFRa0TJ66oUquY48WPWl2QbwpRNSM+eafLB7EWQ8bB
        NpzGxKMRaINhIv+259eZNV+7HTDk1LdnpcU7ozG1kn6/Hs3D1AdlKRIVvb+nx4PJQDc+/OpMEbaTi
        JIlkNXQg==;
Received: from 177.43.31.175.dynamic.adsl.gvt.net.br ([177.43.31.175] helo=bombadil.infradead.org)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1goVoI-0006oB-R9; Tue, 29 Jan 2019 16:00:26 +0000
Received: from mchehab by bombadil.infradead.org with local (Exim 4.91)
        (envelope-from <mchehab@bombadil.infradead.org>)
        id 1goVoD-0006UV-Bh; Tue, 29 Jan 2019 14:00:21 -0200
From:   Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To:     Linux Media Mailing List <linux-media@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>
Cc:     Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Ezequiel Garcia <ezequiel@collabora.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Anton Leontiev <scileont@gmail.com>
Subject: [PATCH 3/3] media: vim2m: allow setting the default transaction time via parameter
Date:   Tue, 29 Jan 2019 14:00:17 -0200
Message-Id: <24e5cd4c01e918ef09a14352fc5f9afbe3b1fd3b.1548776693.git.mchehab+samsung@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <cover.1548776693.git.mchehab+samsung@kernel.org>
References: <cover.1548776693.git.mchehab+samsung@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

While there's a control to allow setting it at runtime, as the
control handler is per file handler, only the application setting
the m2m device can change it. As this is a custom control, it is
unlikely that existing apps would be able to set it.

Due to that, and due to the fact that v4l2-mem2mem serializes all
accesses to a m2m device, trying to setup two GStreamer
v4l2videoconvert instance at the same time will cause frame drops.

So, add an alternate way of setting its default via a modprobe parameter.

Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
---
 drivers/media/platform/vim2m.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/drivers/media/platform/vim2m.c b/drivers/media/platform/vim2m.c
index a9e43070567e..0e7814b2327e 100644
--- a/drivers/media/platform/vim2m.c
+++ b/drivers/media/platform/vim2m.c
@@ -41,6 +41,12 @@ static unsigned debug;
 module_param(debug, uint, 0644);
 MODULE_PARM_DESC(debug, "activates debug info");
 
+/* Default transaction time in msec */
+static unsigned default_transtime = 40; /* Max 25 fps */
+module_param(default_transtime, uint, 0644);
+MODULE_PARM_DESC(default_transtime, "default transaction time in ms");
+
+
 #define MIN_W 32
 #define MIN_H 32
 #define MAX_W 640
@@ -58,9 +64,6 @@ MODULE_PARM_DESC(debug, "activates debug info");
 /* In bytes, per queue */
 #define MEM2MEM_VID_MEM_LIMIT	(16 * 1024 * 1024)
 
-/* Default transaction time in msec */
-#define MEM2MEM_DEF_TRANSTIME	40
-
 /* Flags that indicate processing mode */
 #define MEM2MEM_HFLIP	(1 << 0)
 #define MEM2MEM_VFLIP	(1 << 1)
@@ -764,6 +767,8 @@ static int vim2m_s_ctrl(struct v4l2_ctrl *ctrl)
 
 	case V4L2_CID_TRANS_TIME_MSEC:
 		ctx->transtime = ctrl->val;
+		if (ctx->transtime < 1)
+			ctx->transtime = 1;
 		break;
 
 	case V4L2_CID_TRANS_NUM_BUFS:
@@ -961,12 +966,11 @@ static int queue_init(void *priv, struct vb2_queue *src_vq, struct vb2_queue *ds
 	return vb2_queue_init(dst_vq);
 }
 
-static const struct v4l2_ctrl_config vim2m_ctrl_trans_time_msec = {
+static struct v4l2_ctrl_config vim2m_ctrl_trans_time_msec = {
 	.ops = &vim2m_ctrl_ops,
 	.id = V4L2_CID_TRANS_TIME_MSEC,
 	.name = "Transaction Time (msec)",
 	.type = V4L2_CTRL_TYPE_INTEGER,
-	.def = MEM2MEM_DEF_TRANSTIME,
 	.min = 1,
 	.max = 10001,
 	.step = 1,
@@ -1008,6 +1012,8 @@ static int vim2m_open(struct file *file)
 	v4l2_ctrl_handler_init(hdl, 4);
 	v4l2_ctrl_new_std(hdl, &vim2m_ctrl_ops, V4L2_CID_HFLIP, 0, 1, 1, 0);
 	v4l2_ctrl_new_std(hdl, &vim2m_ctrl_ops, V4L2_CID_VFLIP, 0, 1, 1, 0);
+
+	vim2m_ctrl_trans_time_msec.def = default_transtime;
 	v4l2_ctrl_new_custom(hdl, &vim2m_ctrl_trans_time_msec, NULL);
 	v4l2_ctrl_new_custom(hdl, &vim2m_ctrl_trans_num_bufs, NULL);
 	if (hdl->error) {
-- 
2.20.1

