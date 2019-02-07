Return-Path: <SRS0=uIFo=QO=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1B3AC282C2
	for <linux-media@archiver.kernel.org>; Thu,  7 Feb 2019 09:13:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 833092147C
	for <linux-media@archiver.kernel.org>; Thu,  7 Feb 2019 09:13:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726655AbfBGJNm (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 7 Feb 2019 04:13:42 -0500
Received: from lb2-smtp-cloud9.xs4all.net ([194.109.24.26]:34540 "EHLO
        lb2-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726480AbfBGJNm (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 7 Feb 2019 04:13:42 -0500
Received: from marune.fritz.box ([IPv6:2001:983:e9a7:1:38dd:c345:eb31:caf5])
        by smtp-cloud9.xs4all.net with ESMTPA
        id rfkYgHeo6RO5ZrfkagrP3w; Thu, 07 Feb 2019 10:13:40 +0100
From:   Hans Verkuil <hverkuil-cisco@xs4all.nl>
To:     linux-media@vger.kernel.org
Cc:     sakari.ailus@linux.intel.com,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>
Subject: [PATCH 2/6] vim2m: fix smatch warning
Date:   Thu,  7 Feb 2019 10:13:34 +0100
Message-Id: <20190207091338.55705-3-hverkuil-cisco@xs4all.nl>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190207091338.55705-1-hverkuil-cisco@xs4all.nl>
References: <20190207091338.55705-1-hverkuil-cisco@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMAE-Envelope: MS4wfAjd/7ltqEPSxaBb9dbLcekKaGTns7bLf0arAdM6etvugChb7Cwt41l1ho9UHofXm/ORxKFn//31Cpi41SRvi2NGHGUnVF0c8EW+5JyyjkhbwTr/bo5x
 3Wj5TNqIrlGBCf3NY6XnuQdmjhystB1yegIy3mMXL5Cn23q3VFm0Z0aSGtzK2cNmmv96Sdvgv5gB0SvA8GSRGKo2rKizXO/ndmFUJCiT4FCx5aBmLQGAgjJw
 meAiiX5Vz3UbZ5kQTKx8OHjpzp3nwptH5NJA3vYcfGjx90+GSol5zaG4JW2FcVqsPayIXo+UNbuJKuvUab8Xcitw8Ib+N2FMJ/vb5LrB8AQOffZVum5W3giY
 6X3+mqJjdPwykfCKHEYFfRmGXuF5CjMHM7r2bJEPn2wG0QgtqqB27bBM7RcPsEzRl3WV906I
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

drivers/media/platform/vim2m.c: drivers/media/platform/vim2m.c:525 device_work() warn: variable dereferenced before check 'curr_ctx' (see line 523)

Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
---
 drivers/media/platform/vim2m.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/vim2m.c b/drivers/media/platform/vim2m.c
index e31c14c7d37f..910727982230 100644
--- a/drivers/media/platform/vim2m.c
+++ b/drivers/media/platform/vim2m.c
@@ -520,13 +520,13 @@ static void device_work(struct work_struct *w)
 	unsigned long flags;
 
 	curr_ctx = container_of(w, struct vim2m_ctx, work_run.work);
-	vim2m_dev = curr_ctx->dev;
 
 	if (NULL == curr_ctx) {
 		pr_err("Instance released before the end of transaction\n");
 		return;
 	}
 
+	vim2m_dev = curr_ctx->dev;
 	src_vb = v4l2_m2m_src_buf_remove(curr_ctx->fh.m2m_ctx);
 	dst_vb = v4l2_m2m_dst_buf_remove(curr_ctx->fh.m2m_ctx);
 
-- 
2.20.1

