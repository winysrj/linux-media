Return-Path: <SRS0=xMd0=QZ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23113C43381
	for <linux-media@archiver.kernel.org>; Mon, 18 Feb 2019 15:34:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E44EA217F9
	for <linux-media@archiver.kernel.org>; Mon, 18 Feb 2019 15:34:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1550504052;
	bh=sAIjFJ6os8DaLQNb9gqLtkRCe0GNPXnMLZ94DVdZ458=;
	h=From:Cc:Subject:Date:To:List-ID:From;
	b=n0LZe62cHd+2UQnjK1gnRIz3QugGmNES3QecGbO6s3thvLS0uTEQXnoQLk2Oj1vFw
	 DfuobJkXE7cPVuPLjpqPwLZKbkBzhsl3rCFpWgTq2UAsqt0ybA0HFxE5YWIWP93rjN
	 bTEQEY7HbnapCKKW9f55PmfWlR4xUflshj/wOy6I=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731083AbfBRPeL (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 18 Feb 2019 10:34:11 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:42890 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730658AbfBRPeK (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 18 Feb 2019 10:34:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Reply-To:Content-Type:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=SyYbQSNpFioo7BEuIkF3mexft6xBdu7zg3vxy3SHCU0=; b=RhvL3/i1PE6pJoWYNY25a6Wv2
        hpFA7ik26KpIwkpEpb3cHrCf+ikUpT8C1oYlidcJjaz9JmDWMpRzYVPwO7jIDpV72eQZMgLZxFqfi
        2oSA1TDF7URMW954d8et50Sk9k1IgaD3KJthjQo8UbrRFSurrm3SWFb0+5cSNKUX3nOyZWPE5ZX3b
        opzwmNTby6VrAsUUxsAuLO6MAAExwqOQgNihnlGtHXlAn2TZqFu9xDGSfyQrC+vQ9DkabPeXxDec8
        SF0BK+HQgZJIeMnqLLYSmdeWODlEFu5sJiwHXgswzUizkXGsdeqcfZ+6DmXRUBzS1n6U4DqgKGxkM
        rQbwlq+Fw==;
Received: from 177.96.194.24.dynamic.adsl.gvt.net.br ([177.96.194.24] helo=bombadil.infradead.org)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1gvkvq-0000WS-JA; Mon, 18 Feb 2019 15:34:10 +0000
Received: from mchehab by bombadil.infradead.org with local (Exim 4.91)
        (envelope-from <mchehab@bombadil.infradead.org>)
        id 1gvkvn-00019j-1G; Mon, 18 Feb 2019 10:34:07 -0500
From:   Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Ezequiel Garcia <ezequiel@collabora.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Kees Cook <keescook@chromium.org>,
        Anton Leontiev <scileont@gmail.com>
Subject: [PATCH] media: vim2m: fix build breakage due to a merge conflict
Date:   Mon, 18 Feb 2019 10:34:06 -0500
Message-Id: <c81314716b420ffcbd34f156af86a8f7d77368e1.1550504042.git.mchehab+samsung@kernel.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

A merge conflict rised when merging from -rc7. Fix it.

Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
---
 drivers/media/platform/vim2m.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/vim2m.c b/drivers/media/platform/vim2m.c
index 04250adf58e0..3e4cda2db0bf 100644
--- a/drivers/media/platform/vim2m.c
+++ b/drivers/media/platform/vim2m.c
@@ -902,11 +902,12 @@ static int vim2m_start_streaming(struct vb2_queue *q, unsigned count)
 static void vim2m_stop_streaming(struct vb2_queue *q)
 {
 	struct vim2m_ctx *ctx = vb2_get_drv_priv(q);
+	struct vim2m_dev *dev = ctx->dev;
 	struct vb2_v4l2_buffer *vbuf;
 	unsigned long flags;
 
 	if (v4l2_m2m_get_curr_priv(dev->m2m_dev) == ctx)
-		cancel_delayed_work_sync(&dev->work_run);
+		cancel_delayed_work_sync(&ctx->work_run);
 
 	for (;;) {
 		if (V4L2_TYPE_IS_OUTPUT(q->type))
-- 
2.20.1

