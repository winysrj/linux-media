Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr8.xs4all.nl ([194.109.24.28]:1568 "EHLO
	smtp-vbr8.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751890Ab3CRMcl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Mar 2013 08:32:41 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Ismael Luceno <ismael.luceno@corp.bluecherry.net>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEW PATCH 11/19] solo6x10: fix 'BUG: key ffff88081a2a9b58 not in .data!'
Date: Mon, 18 Mar 2013 13:32:10 +0100
Message-Id: <1363609938-21735-12-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1363609938-21735-1-git-send-email-hverkuil@xs4all.nl>
References: <1363609938-21735-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Caused by a missing sysfs_attr_init().

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/staging/media/solo6x10/core.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/media/solo6x10/core.c b/drivers/staging/media/solo6x10/core.c
index 271759f..b7e5d5e 100644
--- a/drivers/staging/media/solo6x10/core.c
+++ b/drivers/staging/media/solo6x10/core.c
@@ -480,6 +480,7 @@ static int solo_sysfs_init(struct solo_dev *solo_dev)
 		}
 	}
 
+	sysfs_attr_init(&sdram_attr->attr);
 	sdram_attr->attr.name = "sdram";
 	sdram_attr->attr.mode = 0440;
 	sdram_attr->read = sdram_show;
-- 
1.7.10.4

