Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:62753 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753278Ab2DPN7B (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Apr 2012 09:59:01 -0400
MIME-version: 1.0
Content-transfer-encoding: 8BIT
Content-type: text/plain; charset=UTF-8
Received: from euspt2 ([210.118.77.14]) by mailout4.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0M2K007VLS6HJB10@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 16 Apr 2012 14:59:05 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0M2K00D7HS683Y@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 16 Apr 2012 14:58:57 +0100 (BST)
Date: Mon, 16 Apr 2012 15:58:55 +0200
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: [PATCHv2 8/8] media/video/s5p-tv: mark const init data with
 __initconst instead of __initdata
In-reply-to: <1334584735-12439-1-git-send-email-t.stanislaws@samsung.com>
To: linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, t.stanislaws@samsung.com,
	kyungmin.park@samsung.com, laurent.pinchart@ideasonboard.com,
	mchehab@redhat.com, hverkuil@xs4all.nl, sachin.kamat@linaro.org,
	u.kleine-koenig@pengutronix.de,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-arm-kernel@lists.infradead.org
Message-id: <1334584735-12439-9-git-send-email-t.stanislaws@samsung.com>
References: <1334584735-12439-1-git-send-email-t.stanislaws@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

As long as there is no other non-const variable marked __initdata in the
same compilation unit it doesn't hurt. If there were one however
compilation would fail with

	error: $variablename causes a section type conflict

because a section containing const variables is marked read only and so
cannot contain non-const variables.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Tomasz Stanislawski <t.stanislaws@samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-media@vger.kernel.org
---
 drivers/media/video/s5p-tv/mixer_drv.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/s5p-tv/mixer_drv.c b/drivers/media/video/s5p-tv/mixer_drv.c
index a2c0c25..edca065 100644
--- a/drivers/media/video/s5p-tv/mixer_drv.c
+++ b/drivers/media/video/s5p-tv/mixer_drv.c
@@ -461,7 +461,7 @@ static struct platform_driver mxr_driver __refdata = {
 static int __init mxr_init(void)
 {
 	int i, ret;
-	static const char banner[] __initdata = KERN_INFO
+	static const char banner[] __initconst = KERN_INFO
 		"Samsung TV Mixer driver, "
 		"(c) 2010-2011 Samsung Electronics Co., Ltd.\n";
 	printk(banner);
-- 
1.7.5.4

