Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:57283 "EHLO
	lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754986AbbIMTQt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 13 Sep 2015 15:16:49 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 3/4] vivid: add support for SMPTE 2084 transfer function
Date: Sun, 13 Sep 2015 21:15:20 +0200
Message-Id: <1442171721-13058-4-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1442171721-13058-1-git-send-email-hverkuil@xs4all.nl>
References: <1442171721-13058-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Support the new SMPTE 2084 transfer function in the vivid test driver.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/platform/vivid/vivid-ctrls.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/platform/vivid/vivid-ctrls.c b/drivers/media/platform/vivid/vivid-ctrls.c
index 995e303..630086b 100644
--- a/drivers/media/platform/vivid/vivid-ctrls.c
+++ b/drivers/media/platform/vivid/vivid-ctrls.c
@@ -727,6 +727,7 @@ static const char * const vivid_ctrl_xfer_func_strings[] = {
 	"SMPTE 240M",
 	"None",
 	"DCI-P3",
+	"SMPTE 2084",
 	NULL,
 };
 
-- 
2.1.4

